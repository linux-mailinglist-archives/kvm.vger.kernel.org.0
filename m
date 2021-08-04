Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A693E0992
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 22:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240984AbhHDUne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 16:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbhHDUnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 16:43:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3EC0617A1
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 13:43:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so5310663pjh.3
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 13:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1DGmVLNofyKFJ2WDfVjd9ULXSsiDt/CCk+eOwHGjfu4=;
        b=WArsvRSLlFr50dBfZn6SZ2FmQx3aDGM8BDjvlw+WToDfW5/7sFaoacLCSjg/XSPZfp
         +iPwZJGtDdfNI7X1Oft9kNYtVRTPy53ejKYzUjSKkDRN86QL4wUD5ZoA1z06BQrNcI/w
         UhqBoKZ3h5ajEcud4tt6yhTPTi1h8PsP/2XybeEqHBpidFLGokATt8Vp8FzWI1uslJo7
         B2N3K4GxezuAKoP7Msdv0lUlSuCbN754OQ8BnmzR95Lzr400lIh6gE7ngI2iXcwiLk1c
         aatIrA/teQHEe7osYVDpn4wwTe4d/V24KvA9PUbUSsxuKcZ1eS7Y9vV46jTloH1fjBrM
         C4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1DGmVLNofyKFJ2WDfVjd9ULXSsiDt/CCk+eOwHGjfu4=;
        b=nkkT9lp3n4slEURP1xr241g9JUkN8dMGDNDShKvP7FTp0x6qGt3c6+Hkhhaf76edML
         MRqV1io7H+PjD/7pFd/fJQxwysj2824RP1isKTeblTWktwE8ceXDv6sbcNTODt+gXfY/
         mxI8NIH9VVFieWMXhZRqIROl9wkwHJjUL7g5ZqkOIefd+rkYPu+m4RKt+C5woOecM83j
         RbdK8GMBlepr4VTm/5YhAuLM7pncGwL74Up7AvOhIvnM4eRj+l/zqENi05UkX8s8lxNE
         nCpDQ657Tqs31wepOtK/Jnywlers40b6T2vzx00Ng3vkOtS/Oot5fsye77y9DHv4e4Tl
         hiFQ==
X-Gm-Message-State: AOAM533lHJQVnBYGOQ1gNbA72+rD8YaY4NQTJXHtXWpS/HF9vgcldgNR
        +isONUU7IGGn5+Z1p3SDhoxNyalNVY6QtYK4PciHRA==
X-Google-Smtp-Source: ABdhPJyeQRI34XtispxUm9kcYFkw2mybSTv8DV1XRknJ0Xuiis25Z9MXXJVDoi+23/Ho5lOIL/15fsb49Kq/Sqq0iyA=
X-Received: by 2002:a63:4446:: with SMTP id t6mr967654pgk.76.1628109795439;
 Wed, 04 Aug 2021 13:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
 <CAAYXXYy=fn9dUMjY6b6wgCHSTLewnTZLKb00NMupDXSWbNC9OQ@mail.gmail.com> <1057bbfe-c73e-a182-7696-afc59a4786d8@intel.com>
In-Reply-To: <1057bbfe-c73e-a182-7696-afc59a4786d8@intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Wed, 4 Aug 2021 13:43:04 -0700
Message-ID: <CAAYXXYwDuRMQ16X3mshkGcBQXhvgoxPTCu8UGggYgfCzHOWwtQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/69] KVM: TDX: Add architectural definitions for
 structures and values
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86 <x86@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 2, 2021 at 6:25 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> No. bit 63 is not for readonly fields, but for non_arch fields.
>
> Please see 18.7.1 General definition
Thank you so much! make sense.

> > Is this information correct and is this included in the spec? I tried
> > to find it but somehow I do not see it clearly defined.
> >
> >> +#define TDX1_NR_TDCX_PAGES             4
> >> +#define TDX1_NR_TDVPX_PAGES            5
> >> +
> >> +#define TDX1_MAX_NR_CPUID_CONFIGS      6
> > Why is this just 6? I am looking at the CPUID table in the spec and
> > there are already more than 6 CPUID leaves there.
>
> This is the number of CPUID config reported by TDH.SYS.INFO. Current KVM
> only reports 6 leaves.

I, personally, still think that it should be enumerated, rather than
hardcoded. It is not clear to me why it is 6 and nothing in the spec
says it will not change.

> >> +#define TDX1_MAX_NR_CMRS               32
> >> +#define TDX1_MAX_NR_TDMRS              64
> >> +#define TDX1_MAX_NR_RSVD_AREAS         16
> >> +#define TDX1_PAMT_ENTRY_SIZE           16
> >> +#define TDX1_EXTENDMR_CHUNKSIZE                256
> >
> > I believe all of the defined variables above need to be enumerated
> > with TDH.SYS.INFO.
>
> No. Only TDX1_MAX_NR_TDMRS, TDX1_MAX_NR_RSVD_AREAS and
> TDX1_PAMT_ENTRY_SIZE can be enumerated from TDH.SYS.INFO.
>
> - TDX1_MAX_NR_CMRS is described in 18.6.3 CMR_INFO, which tells
>
>    TDH.SYS.INFO leaf function returns a MAX_CMRS(32) entry array
>    of CMR_INFO entries.
>
> - TDX1_EXTENDMR_CHUNKSIZE is describe in 20.2.23 TDH.MR.EXTEND

Thanks for the pointers for MAX_CMRS and TDX1_EXTENDMR_CHUNKSIZE.
Will the rest of it be enumerated or hardcoded?

> >> +#define TDX_TDMR_ADDR_ALIGNMENT        512
> > Is TDX_TDMR_ADDR_ALIGNMENT used anywhere or is it just for completeness?
>
> It's the leftover during rebase. We will clean it up.
Thanks!

> SEAMCALL TDH.SYS.INFO requires each cmr info in CMR_INFO_ARRAY to be
> 512B aligned

Make sense, Thanks for the explanation.
