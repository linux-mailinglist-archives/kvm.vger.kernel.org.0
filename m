Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB741BBAA
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 02:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbhI2AVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 20:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhI2AVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 20:21:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F192AC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 17:20:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so2850907pjb.1
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 17:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VW5ROBZ57Bc3bmxw0lo66kLteeQHzsOCYqDBMl9HovU=;
        b=IwO12wLFAGMbs4S8k3EBPxDqzfGlfvR+OKcZUdMbTIBhNhrceUQYW8zoGRfiddsnyq
         D7Ny01TeGzwgmEZY32eDldRV7tydMoEHqGn9NpAm1vn6lRbYHcBVDGPEp0KBo8xHHV0G
         keNcBYwWK9yRXyi4QkBSZnGJCbQKpY4J8v2iOuh5rJT8LAZoTNaQoxFQrHxocZ0zGJug
         x0P+wKHMEp7wXNJtx/HSR1cYKMb05yr+hCRso8ZQVT32gqWp2HljvrGiDXI5V8aFCnXj
         DYsBF6ZxcBiCFUhLQQAhEuzDdkujCWVNx4YHOuxYo/RGzwsUKidRt7e+MZBMXqokuRKB
         LjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VW5ROBZ57Bc3bmxw0lo66kLteeQHzsOCYqDBMl9HovU=;
        b=Ppw5bBBJwXvAPUi/ScI3EEM2qaKfRWiV7XhpTyjRo035xvifoYQfZhAV8VyhvFOWqc
         ph6SUGkm7clkW1U3HvjzZ/XFjMvWsmDAoFn2Su955bmOTFNf/T+gBCcNyqX0kPzKN9hl
         KX1SOdwEQk4CQA886eCMv21RntebOKoWULUwkIMrEgk7B+Nrq4tn+lA7gUgqGs05XzaV
         lO0YIA1CNYI5NIgowCgK2+A7bJKbFqxzwSZyHsEFiInsXlsiEog0p0XcS68KPQgutQks
         9DbbXCOvDS9e7l6WzBVU23v6Bfk9NXaKAbxSxL2Yi7Z4/eDlH2v4cDlo/qH163UNZE2W
         JwXA==
X-Gm-Message-State: AOAM531GkbRLIrYT2TDpg1CUwZu7mA/gSbomwGhenP5eiCN3FXuL5SUB
        fgXcp0e0TypDyfs+YwbUFfgFbnVhJAWi/w==
X-Google-Smtp-Source: ABdhPJx6YGh7ixXXr0JV5zyepV3FpPhXhE8lTfYur7l6549ETUjoRZlxE1xg0lypH+pneZh5+S7TDQ==
X-Received: by 2002:a17:90a:ab94:: with SMTP id n20mr3136878pjq.146.1632874803871;
        Tue, 28 Sep 2021 17:20:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y6sm256924pfb.64.2021.09.28.17.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:20:03 -0700 (PDT)
Date:   Tue, 28 Sep 2021 17:19:59 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device
 tests
Message-ID: <YVOxLz3/JPOjWd2d@google.com>
References: <20210928201157.2510143-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928201157.2510143-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 01:11:57PM -0700, Ricardo Koller wrote:
> Add some ITS device tests: general KVM device tests (address not defined
> already, address aligned) and tests for the ITS region being within the
> addressable IPA range.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 417a9a515cad..180221ec325d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_v3_its_region(void)
> +{
> +	struct vm_gic v;
> +	uint64_t addr;
> +	int its_fd, ret;
> +
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
> +	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
> +
> +	addr = 0x401000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +		"ITS region with misaligned address");
> +
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"register ITS region with base address beyond IPA range");
> +
> +	addr = max_phys_size - 0x10000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"Half of ITS region is beyond IPA range");
> +
> +	/* This one succeeds setting the ITS base */
> +	addr = 0x400000;
> +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +
> +	addr = 0x300000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
> +
> +	close(its_fd);
> +	vm_gic_destroy(&v);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
> +		test_v3_its_region();
>  	}
>  }
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Please ignore this email. This patch is already included in the right trhread.

Sorry and thanks,
Ricardo
