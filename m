Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5728E534CC6
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbiEZJwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiEZJwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:52:15 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15088C9657;
        Thu, 26 May 2022 02:52:15 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ec42eae76bso9627707b3.10;
        Thu, 26 May 2022 02:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5fW3OfjEhzE5YNooV46nflF0oAOwiUDDOMvNtmNpi/w=;
        b=K2iyAo7Bms6m+fqUFJtfe6CXeLZsYcr916aM41w+5VuE9O0UzmacBX+KtsC+fZJ9+t
         Lb0f0LJmnN78I1YHKHvn6DTizcHGYIRAfpEm2HVO5pKAz4ohKRZleWWNr0GeZ4CldsgO
         q2wVwTIpDBQGrfhwRuEjyPC+yM1MYaBU/C3q4gY1no3iZZi/Tij0J20DW25KIxOpDzPX
         PG4DDlQGYfHnZgWQlS1dnpNLurObhdtbFEEWqa+uiH1mwc2hBGAYJhRxH6UOVS4mkLn7
         iT8pux43RThpY9Kr6oTYuRb4pXz+8iALq0f8QlwrI3nO60QVKMUyzIsjdttGUUdwE0mW
         /NLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5fW3OfjEhzE5YNooV46nflF0oAOwiUDDOMvNtmNpi/w=;
        b=22ZmZ+FcPQm4ZB9Qo3/f6eRMlzqJ+SOyJWN5sFTGExIGT4uyI/ziKxyH999z924TcP
         PFobCWb8ajvTu2PDZ/jtWTFhmeSTkyNHL76mHDtImN1r42HaA7IJkaVbOys13Y/vTxS9
         8mWz7ezfUJXOGzgTZc8NPsK7s920Tg4Nm9EnSqswbGPTe8/5NheZ6xurWfWzfQ6J/5pE
         2vAkaTx2TAdPvcxYCp+hMo/J0MQel/k2rsjqC6hPDR7+MVwrX/e32z1vTMlyULdQ7uY4
         fA6mYRyotaLpDhOv1rqEA1tPfLyaKjOBfq3Y6IdwSByvJGkMwvx9oSLHBEmcm1vSjB2v
         hTZg==
X-Gm-Message-State: AOAM533UVTzRqWm5/nXOX8/S7muGcO3Xn28TwUXrj2j/AWToJRzyyvTT
        UPUM+YdCOKICwwBpNTvVNmFX1D4NWNTi59aPATU=
X-Google-Smtp-Source: ABdhPJyv0tBS5V0rb3H2z5vrD2ANb/y+4/drmRomJZR+ESqjjUNxWQapHKACIzIAq2VqcB1rA9fA+j25dCijZo6vaM0=
X-Received: by 2002:a0d:e60a:0:b0:301:b342:5316 with SMTP id
 p10-20020a0de60a000000b00301b3425316mr3759640ywe.256.1653558734405; Thu, 26
 May 2022 02:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220415103414.86555-1-jiangshanlai@gmail.com>
 <YoK3zEVj+DuIBEs7@google.com> <CALzav=c_WfJ0hvHUFHkLH-+zrDXZSCzKsGHP6kPYd77adwHkUQ@mail.gmail.com>
 <CAJhGHyBtVwZ9G+Mv8FMwC4Uku_gK4-Ng7+x+FqykZLftANm0Yg@mail.gmail.com> <70cec00b-428f-9310-96b6-c6257fe36dec@redhat.com>
In-Reply-To: <70cec00b-428f-9310-96b6-c6257fe36dec@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 17:52:03 +0800
Message-ID: <CAJhGHyAqNpESB_DKH+Hh4qW+t0MbtmG7JAore=kOPbE6SH3xeQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE
 paging mode
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm list <kvm@vger.kernel.org>
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

On Thu, May 26, 2022 at 5:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 5/26/22 10:38, Lai Jiangshan wrote:
> >> (Although the APM does say that "modern processors" do not pre-load
> >> PDPTEs.)
>
> This changed between the Oct 2020 and Nov 2021, so I suppose the change
> was done in Zen 3.
>
> > Oh, I also missed the fact that L1 is the host when emulating it.
> >
> > The code is for host-mode (L1)'s nested_cr3 which is using the
> > traditional PAE PDPTEs loading and checking.
> >
> > So using caches is the only correct way, right?
>
> The caching behavior for NPT PDPTEs does not matter too much.  What
> matters is that a PDPTE with reserved bits should cause a #NPF at usage
> time rather than a VMentry failure or a #NPF immediately after VMentry.
>

Since there is mmu->get_pdptrs() in mmu_alloc_shadow_roots(), you can't
conform this now.

It will be easier to only cause a #NPF at usage time after the one-off local
patchset.
