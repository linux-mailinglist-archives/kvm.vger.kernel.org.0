Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC52E49869B
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244445AbiAXRYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244509AbiAXRYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:24:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38B3C06173D
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:24:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so467419pja.2
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MNfXtMWDs94yCP5IvCirOntnPOv7KcyJEPbhbH4XF7c=;
        b=FqVOE59OXQhWJEUphirZINjoUn+baMGNtuwfvW4iNczeJetJyLUo6uMgi7HmKNKUmI
         i5ipyJdbPNtzL9MnaNfct29Ic5bz/qTyfeOa89mMwtcbVepAxEXXFD5MQ0uFfiIpge4u
         ARoOtbw0knoU83fcJUKquqYTdHrZlmO/829tWaIdMoe/kgasRT1FmK+QxuAzbNqEbu4B
         HvLRCRf2zzNeu6Z0byRDkFKQocLTSG+/dVNHJEy0z0RtkhpYIcgpX0hKCsCvSUnsZkmJ
         SsTRu9pkjXxx3FMubkNdhQMI7tPIzdy128CKxWuatt3yl4yVTtwLKJVG2oq753i7yp3J
         JpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MNfXtMWDs94yCP5IvCirOntnPOv7KcyJEPbhbH4XF7c=;
        b=lm9kJK0/2Gmk1658Ym4ED+x+bDVqsTTVL029v+FTKQEYnKJGRYpGf5lK6Vmvl1FoU4
         4Xbw893PETAwmrIxDSuLrc0Rq0NWh7ki8G+CNCtKQVJM6hiF4+eOLk4gtiZcC0vFaAHq
         yoRivu4Hn97G4+r5d9FQfWsk/1zUT3Lt2bPymNoStHZcthWQzlmXea4WVdkOAD9QgD4Z
         RsnvoJsVdt6PlapKK/u8h7rsoUr1GNRjDs02T4wndT17qVBJmeyOWlcq1tmxdlExEqwj
         vMjTmj/ruwu35SpeqM7cPHtXfuRMtPXkUkUWFOMuk8NZk8+DPH9cggtAuc2TrfERThxF
         3/Pw==
X-Gm-Message-State: AOAM530hiMyZ0QU6efAvYiQYdXbJe9TJSmpnBFn9HInpWXnhTuWP20Fa
        ZegLH6tn7tuqZ4hFH3n4ZX4/Lg==
X-Google-Smtp-Source: ABdhPJx7TnvV1SVJ9Ch47mTOqFEGHvCB5zB2duDpG/p/MJ59nwCycfSfDrGjHF11Xcg35Zse7/OaRA==
X-Received: by 2002:a17:903:22ca:b0:14b:3bbd:82ed with SMTP id y10-20020a17090322ca00b0014b3bbd82edmr8644487plg.37.1643045070980;
        Mon, 24 Jan 2022 09:24:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n22sm15967403pfu.193.2022.01.24.09.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:24:30 -0800 (PST)
Date:   Mon, 24 Jan 2022 17:24:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ayush Ranjan <ayushranjan@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Andrei Vagin <avagin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Pratt <mpratt@google.com>
Subject: Re: [PATCH] x86: add additional EPT bit definitions
Message-ID: <Ye7gykcvjig7aPNM@google.com>
References: <20220123195239.509528-1-ayushranjan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123195239.509528-1-ayushranjan@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 23, 2022, Ayush Ranjan wrote:
> From: Michael Pratt <mpratt@google.com>
> 
> Used in gvisor for EPT support.

As you may have surmised from the other patch, the changelogs from patches carried
in our internal kernels rarely meet the criteria for acceptance upstream.  E.g. this
doesn't provide sufficient justification since there's obviously no in-kernel gvisor
that's consuming this.

Submitting patches that we carry internally is perfectly ok, but there needs to be
sufficient justfication, and the patch needs to follow the rules laid out by
Documentation/process/submitting-patches.rst.

> Tested: Builds cleanly
> Signed-off-by: Ayush Ranjan <ayushranjan@google.com>
> Signed-off-by: Michael Pratt <mpratt@google.com>
> ---
>  arch/x86/include/asm/vmx.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..c77ad687cdf7 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -496,7 +496,9 @@ enum vmcs_field {
>  #define VMX_EPT_WRITABLE_MASK			0x2ull
>  #define VMX_EPT_EXECUTABLE_MASK			0x4ull
>  #define VMX_EPT_IPAT_BIT    			(1ull << 6)
> -#define VMX_EPT_ACCESS_BIT			(1ull << 8)
> +#define VMX_EPT_PSE_BIT				(1ull << 7)

I'm not a fan of "PSE", it's unnecessarily terse and "PSE" has different meaning
in IA32 paging.  VMX_EPT_PAGE_SIZE_BIT would be choice.

As for justification, something that has been mentioned once or thrice is the lack
of build-time assertions that the PT_* bits in mmu.h that are reused for EPT entries
do indeed match the EPT definitions.  I can throw together a patch/series to add
that and do the below cleanup.

> +#define VMX_EPT_ACCESS_SHIFT			8

I'd prefer we don't define the "shifts" for EPT (or PTE) bits, they really shouldn't
be used as doing things like test_and_clear_bit() via a shift value can generate
unnecessary lock instructions.  arch/x86/kvm/mmu.h could use a bit of spring cleaning
in this regard.

> +#define VMX_EPT_ACCESS_BIT			(1ull << VMX_EPT_ACCESS_SHIFT)
>  #define VMX_EPT_DIRTY_BIT			(1ull << 9)
>  #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
>  						 VMX_EPT_WRITABLE_MASK |       \
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 
