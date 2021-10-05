Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250DB422027
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhJEILW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhJEILV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633421371;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nquAsR0ARDMCBnBcdv/CquPP9i+YvWVE1XKBwQ6DiLg=;
        b=TQ3YVXY0QohSO9tZuhVKD+eJulbQSfBuydhIVNU/amYfUVrBDvTo3wtVG+Gaj+lscWNhyu
        PPUK7BD+GXK/CHUAyvZ+VFqg+ZU2PKhsSgksFtkUL0+UwPH6o25aXcgUP+7B4yBtx+gWxZ
        mnt0X/gCzgAt2qsDNI9Jo7HTJYWRFFQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-wwO-C3GYMhqQuUdmOUN3-w-1; Tue, 05 Oct 2021 04:09:30 -0400
X-MC-Unique: wwO-C3GYMhqQuUdmOUN3-w-1
Received: by mail-wr1-f71.google.com with SMTP id a10-20020a5d508a000000b00160723ce588so5425327wrt.23
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=nquAsR0ARDMCBnBcdv/CquPP9i+YvWVE1XKBwQ6DiLg=;
        b=RF9jYbbz7brlu0zztdS7Y+4j3NPc4PZ1mQqlCmAawhISKQ2RYVYXPK30JE+9ldS+YV
         670TGhxCIdSUHgJx6loci0okB2Lf/WZucSYb+XfhyQBqRCsmYYZd59ESwlQGIU3w6M5l
         XXGUbKPREq9j8VpQpk2YE2vNvAktUA3LnXPxO5TtYgZFTiQ6QANFiVTLKqx4UIbrkT4o
         5Wk/KOTGSRoCXBF4en3jaLlDl3xP1xfoMLJEHZdIww8wYexgSRHOUcPw6OwKPTv/0wuO
         VZJ/vop6MdkY8KHIHu3m6lVnq0029eXgcqh4Qu8q7h5UzyZ3V3D9BICgac4SJr9JETWG
         Tk8Q==
X-Gm-Message-State: AOAM530e3E5X8i3o7ooMrQMPTM5x28KP9M9Oca3+clos44L8wAHFrkOJ
        NzvJcX2ou8XXJ4rgET76YtKkGAP+y/++92tKKlBUgLXKHY84rzZkBnvOPBCV6rI6W3UgqIzLWei
        wcD+vbefHihsx
X-Received: by 2002:a1c:ce:: with SMTP id 197mr1864214wma.178.1633421368637;
        Tue, 05 Oct 2021 01:09:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxsVUdnI7a+h0TboAUEJoLNIjUBagMKVxzbWn8ap+ZX8VrAJIoVcILvtxslkDleJ7yhLDddQ==
X-Received: by 2002:a1c:ce:: with SMTP id 197mr1864180wma.178.1633421368371;
        Tue, 05 Oct 2021 01:09:28 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l26sm1056133wmi.25.2021.10.05.01.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:09:27 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 08/11] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-9-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <9e153c26-005c-d545-67b0-a8505d62ca4f@redhat.com>
Date:   Tue, 5 Oct 2021 10:09:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-9-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo,

On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add some GICv2 tests: general KVM device tests and DIST/CPUIF overlap
> tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> in vgic_init GIC version agnostic.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 111 +++++++++++++-----
>  1 file changed, 79 insertions(+), 32 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 7521dc80cf23..cb69e195ad1d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -79,74 +79,120 @@ static void vm_gic_destroy(struct vm_gic *v)
>  	kvm_vm_free(v->vm);
>  }
>  
> +struct vgic_region_attr {
> +	uint64_t attr;
> +	uint64_t size;
> +	uint64_t alignment;
> +};
> +
> +struct vgic_region_attr gic_v3_dist_region = {
> +	.attr = KVM_VGIC_V3_ADDR_TYPE_DIST,
> +	.size = 0x10000,
> +	.alignment = 0x10000,
> +};
> +
> +struct vgic_region_attr gic_v3_redist_region = {
> +	.attr = KVM_VGIC_V3_ADDR_TYPE_REDIST,
> +	.size = NR_VCPUS * 0x20000,
> +	.alignment = 0x10000,
> +};
> +
> +struct vgic_region_attr gic_v2_dist_region = {
> +	.attr = KVM_VGIC_V2_ADDR_TYPE_DIST,
> +	.size = 0x1000,
> +	.alignment = 0x1000,
> +};
> +
> +struct vgic_region_attr gic_v2_cpu_region = {
> +	.attr = KVM_VGIC_V2_ADDR_TYPE_CPU,
> +	.size = 0x2000,
> +	.alignment = 0x1000,
> +};
> +
>  /**
> - * Helper routine that performs KVM device tests in general and
> - * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
> - * device gets created, a legacy RDIST region is set at @0x0
> - * and a DIST region is set @0x60000
> + * Helper routine that performs KVM device tests in general. Eventually the
> + * ARM_VGIC (GICv2 or GICv3) device gets created with an overlapping
> + * DIST/REDIST (or DIST/CPUIF for GICv2). Assumption is 4 vcpus are going to be
> + * used hence the overlap. In the case of GICv3, A RDIST region is set at @0x0
> + * and a DIST region is set @0x70000. The GICv2 case sets a CPUIF @0x0 and a
> + * DIST region @0x1000.
>   */
> -static void subtest_v3_dist_rdist(struct vm_gic *v)
> +static void subtest_dist_rdist(struct vm_gic *v)
>  {
>  	int ret;
>  	uint64_t addr;
> +	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
> +	struct vgic_region_attr dist;
> +
> +	rdist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_redist_region
> +						: gic_v2_cpu_region;
> +	dist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_dist_region
> +						: gic_v2_dist_region;
>  
>  	/* Check existing group/attributes */
>  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			      KVM_VGIC_V3_ADDR_TYPE_DIST);
> +			      dist.attr);
>  
>  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
> +			      rdist.attr);
>  
>  	/* check non existing attribute */
> -	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
> +	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
>  	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
>  
>  	/* misaligned DIST and REDIST address settings */
> -	addr = 0x1000;
> +	addr = dist.alignment / 0x10;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 dist base not 64kB aligned");
> +				 dist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "GIC dist base not aligned");
>  
> +	addr = rdist.alignment / 0x10;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 redist base not 64kB aligned");
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
>  
>  	/* out of range address */
>  	if (max_ipa_bits) {
>  		addr = 1ULL << max_ipa_bits;
>  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +					 dist.attr, &addr, true);
>  		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
>  
>  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +					 rdist.attr, &addr, true);
>  		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
>  	}
>  
>  	/* set REDIST base address @0x0*/
>  	addr = 0x00000;
>  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +			  rdist.attr, &addr, true);
>  
>  	/* Attempt to create a second legacy redistributor region */
>  	addr = 0xE0000;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> -	TEST_ASSERT(ret && errno == EEXIST, "GICv3 redist base set again");
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
>  
> -	/* Attempt to mix legacy and new redistributor regions */
> -	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> -	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> -	TEST_ASSERT(ret && errno == EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
> +	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
> +	if (!ret) {
> +		/* Attempt to mix legacy and new redistributor regions */
> +		addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> +		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
> +					 &addr, true);
> +		TEST_ASSERT(ret && errno == EINVAL,
> +			    "attempt to mix GICv3 REDIST and REDIST_REGION");
> +	}
>  
>  	/*
>  	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
>  	 * on first vcpu run instead.
>  	 */
> -	addr = 3 * 2 * 0x10000;
> -	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
> -			  &addr, true);
> +	addr = rdist.size - rdist.alignment;
> +	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  dist.attr, &addr, true);
>  }
>  
>  /* Test the new REDIST region API */
> @@ -254,14 +300,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>   * VGIC KVM device is created and initialized before the secondary CPUs
>   * get created
>   */
> -static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> +static void test_vgic_then_vcpus(uint32_t gic_dev_type)
>  {
>  	struct vm_gic v;
>  	int ret, i;
>  
>  	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
>  
> -	subtest_v3_dist_rdist(&v);
> +	subtest_dist_rdist(&v);
>  
>  	/* Add the rest of the VCPUs */
>  	for (i = 1; i < NR_VCPUS; ++i)
> @@ -274,14 +320,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
>  }
>  
>  /* All the VCPUs are created before the VGIC KVM device gets initialized */
> -static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
> +static void test_vcpus_then_vgic(uint32_t gic_dev_type)
>  {
>  	struct vm_gic v;
>  	int ret;
>  
>  	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
>  
> -	subtest_v3_dist_rdist(&v);
> +	subtest_dist_rdist(&v);
>  
>  	ret = run_vcpu(v.vm, 3);
>  	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
> @@ -550,9 +596,10 @@ int test_kvm_device(uint32_t gic_dev_type)
>  
>  void run_tests(uint32_t gic_dev_type)
>  {
> +	test_vcpus_then_vgic(gic_dev_type);
> +	test_vgic_then_vcpus(gic_dev_type);
> +
>  	if (VGIC_DEV_IS_V3(gic_dev_type)) {
> -		test_v3_vcpus_then_vgic(gic_dev_type);
> -		test_v3_vgic_then_vcpus(gic_dev_type);
>  		test_v3_new_redist_regions();
>  		test_v3_typer_accesses();
>  		test_v3_last_bit_redist_regions();

