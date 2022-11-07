Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D511861FE2E
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 20:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiKGTIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 14:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiKGTIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 14:08:11 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FF327934
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 11:08:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o7so11469693pjj.1
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 11:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m/smU66JT85NOS0VK+FU28TFmR0yhSePSzVihKgN5Wk=;
        b=WuHv/UTGMUcH0gr9L9+3fOeNzSoqNF7oT+WtcVFKKHZYM8dpXwuK3Bbzx9DSh7F8Au
         jdlmwkpM/SdazGlPLV1XTzJGRed0WeAnzovlRHxLLj7r977/RuHbdZZJKSdjeKP+OFdv
         GdvhEyDcYz08l7kClKl8ebKO8PBvw+XTA3luczT/x1+fZfXjS/HilYx2R6g3duR8aTvX
         +2csArPBf8Hpm9Hmh4yN6ndkP9oblY+NZOGUMmMV37jXXo4bIvzsiuNUK+viakgGv2Hw
         j4pveCLyh9dmvcMYILlmGnfVDsEW8TLAIvqB2ZMIOsDYphy+UM0l9Cf974qs5bU6Mr48
         +VzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/smU66JT85NOS0VK+FU28TFmR0yhSePSzVihKgN5Wk=;
        b=TMg2C6i8O4A/mz5gdYpQuZ2xFDPlOTbF4ObYKEHMC0GQg+42GS9gsDdz6JUywZcWq/
         crp94qgTTEVcKZR2rbD8e2piINJcFY32bnscp5FL8/iVpRQG7EzUhME9GJ5mXJ35n7e6
         iGmelUel45pO/Eo7R6kRPqvL5eTuWGrsdIp78BJm+Eaj1IRwdYovWxGPoP2r6EL4PVon
         zguF9eSYk+edq1YfmUkjd31lGjUrQozuTSlTN6eC5fKzNfVWEMD/RpbVF9bc1wMFen70
         5OK9o0g2eMRTs3f5i13Rn06O8qJZKCZLNsJB8cypTsVJKxrv4K+xtO+sfWh7F89dRbP1
         Dd4g==
X-Gm-Message-State: ACrzQf24TibeqSXqMJ5Nm2sZ+LX7sYZpM3dbnA+IjPoaKNBiRsvCxvNp
        BsuBm0SCq6a6iPrUsXPOYOfZJw==
X-Google-Smtp-Source: AMsMyM5kVEKodnOMDoaC6u8LpeeVwpvTksodaQW/qkpwoHpjOPB2wZFIb6HX2zfSRxOOchP4ckqm+A==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr54600829pjb.143.1667848089737;
        Mon, 07 Nov 2022 11:08:09 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b5-20020aa79505000000b0056bfd4a2702sm4831963pfp.45.2022.11.07.11.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 11:08:09 -0800 (PST)
Date:   Mon, 7 Nov 2022 11:08:05 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
Message-ID: <Y2lXld6G+Hp0FW3A@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105045704.2315186-5-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 09:57:02PM -0700, Vipin Sharma wrote:
> Make guest OS ID calculation common to all hyperv tests and similar to
> hv_generate_guest_id().

This commit makes the HV_LINUX_VENDOR_ID and adds LINUX_VERSION_CODE
to existing tests. Can you split out the latter to a separate commit?
Also what's the reason to add LINUX_VERSION_CODE to the mix?

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 10 ++++++++++
>  tools/testing/selftests/kvm/x86_64/hyperv_clock.c    |  2 +-
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c |  6 ++----
>  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
>  4 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 075fd29071a6..9d8c325af1d9 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -9,6 +9,10 @@
>  #ifndef SELFTEST_KVM_HYPERV_H
>  #define SELFTEST_KVM_HYPERV_H
>  
> +#include <linux/version.h>
> +
> +#define HV_LINUX_VENDOR_ID			0x8100
> +
>  #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS	0x40000000
>  #define HYPERV_CPUID_INTERFACE			0x40000001
>  #define HYPERV_CPUID_VERSION			0x40000002
> @@ -189,4 +193,10 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
>  
> +static inline uint64_t hv_linux_guest_id(void)
> +{
> +	return ((uint64_t)HV_LINUX_VENDOR_ID << 48) |
> +	       ((uint64_t)LINUX_VERSION_CODE << 16);

This can be a compile-time constant (i.e. macro).

> +}
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> index d576bc8ce823..f9112c5dc3f7 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> @@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
>  
>  	/* Set Guest OS id to enable Hyper-V emulation */
>  	GUEST_SYNC(1);
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  	GUEST_SYNC(2);
>  
>  	check_tsc_msr_rdtsc();
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 6b443ce456b6..b5a42cf1ad9d 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -13,8 +13,6 @@
>  #include "processor.h"
>  #include "hyperv.h"
>  
> -#define LINUX_OS_ID ((u64)0x8100 << 48)
> -
>  static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>  				vm_vaddr_t output_address, uint64_t *hv_status)
>  {
> @@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  
>  	GUEST_ASSERT(hcall->control);
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
>  
>  	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> @@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
>  			 */
>  			msr->idx = HV_X64_MSR_GUEST_OS_ID;
>  			msr->write = 1;
> -			msr->write_val = LINUX_OS_ID;
> +			msr->write_val = hv_linux_guest_id();
>  			msr->available = 1;
>  			break;
>  		case 3:
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> index a380ad7bb9b3..2c13a144b04c 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> @@ -69,7 +69,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
>  
>  	GUEST_SYNC(1);
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  
>  	GUEST_ASSERT(svm->vmcb_gpa);
>  	/* Prepare for L2 execution. */
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
