Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6C9500BC6
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 13:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbiDNLIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 07:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiDNLIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 07:08:49 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0B26EC47;
        Thu, 14 Apr 2022 04:06:23 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id p65so8709301ybp.9;
        Thu, 14 Apr 2022 04:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5JiJfdBMAAlT8pKpib3a2JLnNC277gjJU5jp8/O+lc=;
        b=a4d4W/3sTHyXzWW788ts/VevnYbWY1vdYYS98fm265b9Tt52sN3GR0/jdW4gS4ZFuh
         vuAmqMPZQHwdkXdn0nZFAUKdWxFF5gIPFRRoDok/MQ/YY2zBUA7M+RqTcIQjHiKOLtW4
         5DPmZXPnr03G4UohDVjBgFa3GN000P2ljoIJDKXrI3XYjTHFtJBK6r0OZqLFBRTdDElj
         oKRU1cfSNKt2iSZtIGV9rcMOILVlHYKOyfmnYWdlmD5YwzGOkfIgJajqI9d5PFQ9VCxW
         z0FcnpMh//ObMuhTTah0v5L8SNOwVR7f0zMuihLR6PmSOWvYrkGm+AcO1pTFoOlwq3rV
         x/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5JiJfdBMAAlT8pKpib3a2JLnNC277gjJU5jp8/O+lc=;
        b=YOwJLEQtkHiOdfKfkklkf/Ulqd2JOrDvLMKFVwGB8VWXBthljGr5S6QxzL7Mzz24x2
         w0Y8SCMONN/O2mXhGfluYhRsvvQcwdTNmTru5v+sscNuRrqMrbp/0/So4zMwbn9O3Zrh
         oohp5w6pZ1f4B6T9pPxsPY8l+kGdmLnXQW3kcSiy8s+JEdiPNxlgR7SqdopHiAduVY13
         UMIf77k0jKLWLJccOOH/vfQ3WnIc4df7CFsXk7cKkKt3XzgEduzJb8M7vDuBi0iSFcXR
         Dn404/8ADXxKN5WDS0wKRpXu0hF4xHOYQObsn8TcS4BjSB1LSj69Ry2LrrOxHq35IgNp
         u5pQ==
X-Gm-Message-State: AOAM532jL0Sm2j2h9R3IAzPzyS3Xn5byM+8FLuKdve5kRWy0Ou2eEU23
        q4urpEN40ONadEOGLueyrxsEE8p7TYsL7X/HlkI=
X-Google-Smtp-Source: ABdhPJzAXh95LBfH7s5qOyw/Vn2M5G0aiYX7ztv768NkUSBBPye7QN8H+hOkHUy3WrdMF9FNr4+jPihpBMixVjcpO7c=
X-Received: by 2002:a25:b991:0:b0:610:bf4e:1b33 with SMTP id
 r17-20020a25b991000000b00610bf4e1b33mr1406088ybg.352.1649934382554; Thu, 14
 Apr 2022 04:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com> <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
 <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com> <CAJhGHyCgo-FEgvuRfuLZikgJSyo7HGm1OfU3gme35-WBmqo7yQ@mail.gmail.com>
 <658729a1-a4a1-a353-50d6-ef71e83a4375@redhat.com>
In-Reply-To: <658729a1-a4a1-a353-50d6-ef71e83a4375@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 14 Apr 2022 19:06:11 +0800
Message-ID: <CAJhGHyDYeQGUWmco=c4TA1uu=33ccW7z0fDLuYjvkGFW5WnDSQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 6:04 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/14/22 11:32, Lai Jiangshan wrote:
> > kvm_mmu_free_roots() can not free those new types of sp if they are still
> > valid.  And different vcpu can use the same pae root sp if the guest cr3
> > of the vcpus are the same.
>
> Right, but then load_pdptrs only needs to zap the page before (or
> instead of) calling kvm_mmu_free_roots().
>


Guest PAE page is write-protected instead now (see patch4) and
kvm_mmu_pte_write() needs to handle this special write operation
with respect to sp->pae_off (todo).
And load_pdptrs() doesn't need to check if the pdptrs are changed.

The semantics will be changed. When the guest updates its PAE root,
the hwTLB will not be updated/flushed immediately until some change
to CRx, but after this change, it will be flushed immediately.

Could we fix 5-level NPT L0 for 4-level NPT L1 only first? it is
a real bug.  I separated it out when I tried to implement one-off
shadow pages.
