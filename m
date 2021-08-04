Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA333E0107
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbhHDMXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:23:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237022AbhHDMXE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 08:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628079771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uN7lErybz824KU9Ms5HvpKy8C+WI0iAk7y+N8+7/oA=;
        b=dVI3RNVs9+P+R8Xs1soB0WOZ4NaJ/caI3DzuSBYkAH0op+g+blkpa7f2+dZR1UsKVh91lb
        zHC5vVu5bwKU0vrcsVDAxt8ZfU4Ju2jJmXp+uksrNikf+3RjG5KmoVIwI3T0LdJRTHJFRj
        VTeZ8whsWyheKQr9VFbLDeq7fzFcAJA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-XD6g-WkdP1CpcaybXoNg1w-1; Wed, 04 Aug 2021 08:22:50 -0400
X-MC-Unique: XD6g-WkdP1CpcaybXoNg1w-1
Received: by mail-wr1-f69.google.com with SMTP id v18-20020adfe2920000b029013bbfb19640so752419wri.17
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 05:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uN7lErybz824KU9Ms5HvpKy8C+WI0iAk7y+N8+7/oA=;
        b=Zu45y8gtY+1LgnlBJ+XK2h7InVwY9u26brsVDBl5EUKqRIvCCXZRe7sBo6qrSbduXm
         EC4C/52z5bC94ezyynLbxOTEUyqYbEy+WzIDGd5QrU2DoNTt4qIC2aU4O6A2DBX550CP
         vPPG20QkDWHRipLx1maAGfyS9CdPLhIH9UQ9qHBFw6BdH29e4lXthAPIdAZ8SyHYBi3/
         Rpn7f2m5TDBSb/Oj0GrrDgzujrQKvK9NHXmOKhngSHdDSNPxQ5/1Yx6HgexlkPksWiWF
         3s9AMSeBAoue+bbB8XhvjzOIVOFoEaVDOg3SQxqJKDL+t1Wl4V1vWB8AYrNWdLDp4yb1
         v7SA==
X-Gm-Message-State: AOAM530lGxsEUdSqBesBmGszj3HRlzriCLRqKGy/o148BK1isL2FqoHm
        70TZfgV3fm4Qf1iD1VbsZAEpR9RMqOsiz/89CPi95zE5bRi0iYXLd+2qVIZsGiSanyj6XSrTUjC
        uOlxYsNo3WXN5iITjI0CJeweWtdZ+Iixwd3JxWL5TqQIFXAFgh4wTtpDf4DrrgZDn
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr27592581wmr.168.1628079768918;
        Wed, 04 Aug 2021 05:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6135G6kwLDFrCiIZrmukGtF4Xyt9DcU47IcHJqp+NanzUq5LZwFJOpuvSIRyzdaTyP6Q/VQ==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr27592563wmr.168.1628079768695;
        Wed, 04 Aug 2021 05:22:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id w10sm2240414wrr.23.2021.08.04.05.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 05:22:48 -0700 (PDT)
To:     Lara Lazier <laramglazier@gmail.com>, kvm@vger.kernel.org
References: <20210804112507.43394-1-laramglazier@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] nSVM: Modified canonicalization tests
Message-ID: <d544e449-b725-a6c1-b898-835cb1c753b3@redhat.com>
Date:   Wed, 4 Aug 2021 14:22:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804112507.43394-1-laramglazier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Better subject "nSVM: test canonicalization of segment bases in VMLOAD".

On 04/08/21 13:25, Lara Lazier wrote:
> APM2 states that VMRUN and VMLOAD should canonicalize all base
> addresses in the segment registers that have been loaded respectively.
> 
> Split up in test_canonicalization the TEST_CANONICAL for VMLOAD and
> VMRUN. Added the respective test for KERNEL_GS.
> 
> In general the canonicalization should be from 48/57 to 64 based on LA57.

It is correct to improve is_canonical like that, because it is not in an 
AMD-specific file so it should support virtual address width.  However, 
AMD processors do not yet support LA57; therefore, the change to 
is_canonical is not really related to nSVM.  I would split this change 
in two patches, one for processor.h and one for svm_tests.c, because of 
this reason.

> Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> ---
>   lib/x86/processor.h |  4 +++-
>   x86/svm_tests.c     | 54 +++++++++++++++++++++++++++++++--------------
>   2 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index f4d1757..ae708ac 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -619,7 +619,9 @@ static inline void write_pkru(u32 pkru)
>   
>   static inline bool is_canonical(u64 addr)
>   {
> -	return (s64)(addr << 16) >> 16 == addr;
> +	int shift_amt = (this_cpu_has(X86_FEATURE_LA57)) ? 7 /* 57 bits virtual */
> +                        : 16 /* 48 bits virtual */;

You can use the virtual address width from CPUID instead of LA57:

int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
int shift_amt = 64 - va_width;

> +	return (s64)(addr << shift_amt) >> shift_amt == addr;
>   }
>   
>   static inline void clear_bit(int bit, u8 *addr)
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 7c7b19d..273b80b 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2460,32 +2460,54 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>   	vmcb->control.intercept = saved_intercept;
>   }
>   
> -#define TEST_CANONICAL(seg_base, msg)					\
> -	saved_addr = seg_base;						\
> +#define TEST_CANONICAL_VMRUN(seg_base, msg)					\
> +	saved_addr = seg_base;					\
>   	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test %s.base for canonical form: %lx", msg, seg_base);							\
> +	return_value = svm_vmrun(); \
> +	if (is_canonical(seg_base)) { \
> +		report(return_value == SVM_EXIT_VMMCALL, \
> +			"Test %s.base for canonical form: %lx", msg, seg_base); \
> +	} else { \
> +		report(false, \
> +			"Test a %s.base not canonicalized: %lx", msg, seg_base); \
> +	} \

You can also split the tests in two different "report"s:

report(svm_vmrun() == SVM_EXIT_VMMCALL,
        "Successful VMRUN with noncanonical %s.base", msg);
report(is_canonical(seg_base),
        "Test %s.base for canonical form: %lx", msg, seg_base);

> -	TEST_CANONICAL(vmcb->save.es.base, "ES");
> -	TEST_CANONICAL(vmcb->save.cs.base, "CS");
> -	TEST_CANONICAL(vmcb->save.ss.base, "SS");
> -	TEST_CANONICAL(vmcb->save.ds.base, "DS");
> -	TEST_CANONICAL(vmcb->save.fs.base, "FS");
> -	TEST_CANONICAL(vmcb->save.gs.base, "GS");
> -	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
> -	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
> -	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
> -	TEST_CANONICAL(vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.fs.base, "FS");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.gs.base, "GS");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.ldtr.base, "LDTR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(vmcb->save.kernel_gs_base, "KERNEL GS");

For kernel_gs_base, we might even use VMLOAD without VMSAVE, and check 
rdmsr(MSR_KERNEL_GS_BASE).  This checks that the canonicalization is 
actually performed by VMLOAD and not VMSAVE.

(The same could be done also for gs.base using the SWAPGS instruction, 
and for fs.base if the processor has the RDFSBASE instruction, but one 
thing at a time).

But, one thing at a time.  You can keep the tests like this, and just 
fix the other things that I reported above.

Thanks!

Paolo

> +	TEST_CANONICAL_VMRUN(vmcb->save.es.base, "ES");
> +	TEST_CANONICAL_VMRUN(vmcb->save.cs.base, "CS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.ss.base, "SS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.ds.base, "DS");
> +	TEST_CANONICAL_VMRUN(vmcb->save.gdtr.base, "GDTR");
> +	TEST_CANONICAL_VMRUN(vmcb->save.idtr.base, "IDTR");
>   }
>   
>   static void svm_guest_state_test(void)
> @@ -2497,7 +2519,7 @@ static void svm_guest_state_test(void)
>   	test_cr4();
>   	test_dr();
>   	test_msrpm_iopm_bitmap_addrs();
> -	test_vmrun_canonicalization();
> +	test_canonicalization();
>   }
>   
>   static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
> 

