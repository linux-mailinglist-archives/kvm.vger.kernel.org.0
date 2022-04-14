Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E500501552
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbiDNOHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 10:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343966AbiDNNjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:39:32 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7DA99EF5;
        Thu, 14 Apr 2022 06:35:57 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i20so9424343ybj.7;
        Thu, 14 Apr 2022 06:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=usbrVmh/IqZeGrbdE2M9/Szfr5yBTnD3ZEUOMvSshiE=;
        b=NLzWJaSJZPz1VxfJ8V35JeiQ1OKP+tDwmCDOL7OEXoBRqFaqNqB1W8N4bJJrl5SRDO
         BFPtv1bbVEw/tMuvepFWesW4JU7SeKkwbBPXYSfh/t5/IZOneS7duUAwQasMnSpiITQ9
         XndS1oIdD9jLUoeqTbuMs7OZ+I/NQzLvN3tLEEGwkU7+JFcFcjsh9TbKTJKTjyVu18KN
         2owBNh8/ILzG/g2vY0LQzUx0JdQxfT181fGTsE7mqO3js9KsHvu827tXz3XoV6PO3F2e
         4RFn15p8gCznyV8aiDlpQhf49jqef/UFlYcIZlfK3lbgv6UwpD4c7HKg1X1kDqU123ez
         /lAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=usbrVmh/IqZeGrbdE2M9/Szfr5yBTnD3ZEUOMvSshiE=;
        b=wcty3/V9HCLzKzMZgWfQeTeFsxbKCvWkyqw3VwRjFDxwUEHfdX2YfBMhsu6X4Dn/iE
         Fu/ptF3ljHDOGbDoEWUjGBHxsmRfyM5xj28ym6jWptQq99HUk99LmXd/PSQq7GDFWcOI
         VvHP4C7Q5xTknE3Xb+Hh8VQo5RS0QrwSXwUfxgi3NHhieg3CXPicHa82urkRLwsqU/W+
         UiCaK1CFCoN2QfX9RVJ1sg6m4/GKCnK71QajpYRJdLMDZHHqsbV30HvZqT8cXFhIsjUw
         ddGpiib3Ljof5mw3DqEWUKg3oV7zZMJqd6bh2gG72fjfeOVxt5JEhLbztw9LvXYETFkx
         Zyog==
X-Gm-Message-State: AOAM533DzkhzlcLJUO08Sv6jAOivYREyNqBYoGdyalyKtMItJaHJcmOg
        wdfqwAtZ+w+yPX7bYiPQ8M00JBN2k5ST5x9BbwNPX25JqBI=
X-Google-Smtp-Source: ABdhPJwopzv0ttPI92q96WOpOVANWZ/UA4QN3jGSBMSpKFajdl7+sC2a5dQBmaIJ77V2WoYOt6pYigc+WE79LYNZ87g=
X-Received: by 2002:a05:6902:1206:b0:641:bc56:7444 with SMTP id
 s6-20020a056902120600b00641bc567444mr1819943ybu.376.1649943356542; Thu, 14
 Apr 2022 06:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com> <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
 <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com> <CAJhGHyCgo-FEgvuRfuLZikgJSyo7HGm1OfU3gme35-WBmqo7yQ@mail.gmail.com>
In-Reply-To: <CAJhGHyCgo-FEgvuRfuLZikgJSyo7HGm1OfU3gme35-WBmqo7yQ@mail.gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 14 Apr 2022 21:35:45 +0800
Message-ID: <CAJhGHyCO23JbqdiwRvdggSSxxe93vyKPNY6H5nk+=y6cJJaxvQ@mail.gmail.com>
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

On Thu, Apr 14, 2022 at 5:32 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:

>
> All new kinds of sp added in this patchset are in the hash too.
>


I think role.guest_pae_root is needed to distinguish it from
a sp for a level-3 guest page in a 4-level pagetable.

Or just role.guest_root_level(or role.root_level) and it can replace
role.passthrough_depth and role.guest_pae_root and role.pae_root.

role.pae_root will be

(role.root_level == 3 || role.root_level == 2) && role.level == 3 &&
(host is 32bit || !tdp_enabled)
