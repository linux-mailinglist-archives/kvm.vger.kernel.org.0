Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22835A675
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhDITAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 15:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbhDITAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 15:00:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E939C061762
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 11:59:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v8so3198369plz.10
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 11:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OPV0Bn/4l4uCXyDUP/ld/YFg29vzzpG0LE7NFkqt+40=;
        b=AHFkXKH4ctQOuTIpGp0y8vlB4SrVXEXyWvbTxMBES6ua+yWwR9mYRmmwPg4CBoG2JA
         h+SA8fnirD26NNXbHatmMIiaDwLIzmcRsQN+BnmsrkvTdXuYAk1GauxW1yQq4dxGZOXN
         HdYR4GEzbqaM7PkltRQGvjXl1w1cA24YImPgkATdPQ0FcImCecuL1erpswtc2f9k4Eu6
         H1WjrxO8sBbLYZN8zp/yIzg45ZUef5ODt3qfaX8dr47EhVMaLGkRlWEYf83Q6NbQcXdv
         AsSWSmd8KJQWjZ2JSCp6Ji7zEfvafxAcB9mXfLx8pcH0pAtg4J07j6HHPQGG8bcy9N7B
         jnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OPV0Bn/4l4uCXyDUP/ld/YFg29vzzpG0LE7NFkqt+40=;
        b=Slj0XXHtvEk0+qBrFLeNYFA5sv9M3jzdOPSaboR/PAuwUeHExSoYCN94x45W5P/AH6
         NSUqVIhyh9yrro8zjeMC8Z+scrhDuUfoTqKog7g2+rUAFDgM3r0lHOI3Rn4xOjDLdDYG
         siTYo9XJEHwZTWlDIn+Ab37FTxhq0ww15tBSEWzWhq/qWt+D/pQlPm6i6JMU64xWHJZg
         A0eXxe/0RhGX0SMpa1eA2VTgiD88WRWQkvRVXTSLW9BtGpl+n6+jYdHHau+MlzNS1l3P
         GEgemg4uj7z81D8DH7hMZM4mXrCJHMKSZ1MAy4R5iWD1hWroBDn0WgnDmLrvvwMf7ZA6
         ahYg==
X-Gm-Message-State: AOAM533P75M+9+8wePaduxOlfFu/wKEkl1zkxlh7iSmdb4bVwCR85CaH
        9//ry7blEmSc6c1UI+b/kuNwhQ==
X-Google-Smtp-Source: ABdhPJyKsBAG8JJkzrghc5k+W4UIaeH7j5PHlfgPB5S+x8wwuXAuNauCfhRbtBZJcbWszCrYsNQCxw==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr15364086pjb.92.1617994789638;
        Fri, 09 Apr 2021 11:59:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v8sm2159709pfn.11.2021.04.09.11.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:59:49 -0700 (PDT)
Date:   Fri, 9 Apr 2021 18:59:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
Message-ID: <YHCkIRvXAFmS/hUn@google.com>
References: <20210409075518.32065-1-weijiang.yang@intel.com>
 <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021, Paolo Bonzini wrote:
> On 09/04/21 09:55, Yang Weijiang wrote:
> > During kvm-unit-test, below failure pattern is observed, this is due to testing thread
> > migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
> > Pin the test app to certain physical CPU can fix the issue as well. The error report is
> > misleading, pke is the victim of the issue.
> > 
> > test user cr4.pke: FAIL: error code 5 expected 4
> > Dump mapping: address: 0x123400000000
> > ------L4: 21ea007
> > ------L3: 21eb007
> > ------L2: 21ec000
> > ------L1: 2000000
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >   x86/access.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/x86/access.c b/x86/access.c
> > index 7dc9eb6..379d533 100644
> > --- a/x86/access.c
> > +++ b/x86/access.c
> > @@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
> >           ptl2[2] |= PT_USER_MASK;
> >       if (!r)
> >           shadow_cr4 = cr4;
> > +
> > +    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
> >       return r;
> >   }
> > 
> 
> Applied, thanks.

Egad, I can't keep up with this new Paolo :-D


Would it also work to move the existing invlpg() into ac_test_do_access()?

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..5f335dd 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -451,8 +451,6 @@ fault:

 static void ac_set_expected_status(ac_test_t *at)
 {
-    invlpg(at->virt);
-
     if (at->ptep)
        at->expected_pte = *at->ptep;
     at->expected_pde = *at->pdep;
@@ -658,6 +656,9 @@ static int ac_test_do_access(ac_test_t *at)

     set_cr4_smep(F(AC_CPU_CR4_SMEP));

+    /* Flush after _all_ setup is done, toggling SMEP may also modify PMDs. */
+    invlpg(at->virt);
+
     if (F(AC_ACCESS_TWICE)) {
        asm volatile (
            "mov $fixed2, %%rsi \n\t
