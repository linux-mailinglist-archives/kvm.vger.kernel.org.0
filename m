Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CCC41D4A7
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 09:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348794AbhI3Hoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 03:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348701AbhI3Hoh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 03:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632987775;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IPnqe4/1NW8fM0FWI5JEcFoAmJYE/lm75RfKuKv23U0=;
        b=iFC2CRuOWgMnlibMdYKA0ajpDvfHY2kWdSU42zFxBdXnhIUGA4o1NjOJ6pKUMi9bnuwKiL
        lIXfysKZ+rTaYnSszb/M9V0363m/afx7ipMWphdYEeGJeKlUMYTUKwhgyDjrmmeNiQocS1
        r6ZMZ5EFUP7TzlDohwt7KarckbjO0eM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-hPf-rQuMMJao2LTLKkpKkQ-1; Thu, 30 Sep 2021 03:42:54 -0400
X-MC-Unique: hPf-rQuMMJao2LTLKkpKkQ-1
Received: by mail-wr1-f72.google.com with SMTP id z2-20020a5d4c82000000b0015b140e0562so1359643wrs.7
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 00:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=IPnqe4/1NW8fM0FWI5JEcFoAmJYE/lm75RfKuKv23U0=;
        b=MISpG9nRdWUtKYAWYa4XRxcyJ8nmoCMNGRTPvCdwfauyH6zbADUSd5azLTOc7zb0CB
         VjutwmQz/z0NhHlYMBooZul1bSlfFICPeoXuw7n3eM3DGotULClmboaOhUXmk8HMug9J
         YV9FpUgmvKhdZweL6mV9jESx52N5b9wCwlcWK0U/ZHXkjYY/fbIFbGFenWAN764gHd19
         k2TX3Ey4gM4Hbpe03LZDxLGUsRRrgszPT1CWad0XQKMzwO1MlbXrAx6/Uv1z7CseO2Fp
         CW8LkRkIPI4YK2SZgfF+cO8NzVM4iywzH2X35IqWxYRobsJoBqqL1w3ClrpyUj0+YiUO
         AJ5Q==
X-Gm-Message-State: AOAM532U+Vw6V3BXSMyeepr+tNl3aZhuG6Mlli6mZy/u2eXDBX+Z1CmB
        Pgk0QpufhbrL2aZzGB+pRdtxYZBFsxDmawD67shTyxU4Bu8mb5rQh8HqlKmPt07AfcP2GEmWHWI
        y34rWa4J6/9jJ
X-Received: by 2002:a5d:4851:: with SMTP id n17mr4261963wrs.191.1632987772779;
        Thu, 30 Sep 2021 00:42:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhlzaKa6LHbxGa5seCiD0C21SQXLN7ZrqE6U5ETyMCH2d6xh6rUVbXJXYiYB4iXDvOv1EkJg==
X-Received: by 2002:a5d:4851:: with SMTP id n17mr4261944wrs.191.1632987772526;
        Thu, 30 Sep 2021 00:42:52 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k18sm2143522wrh.68.2021.09.30.00.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:42:52 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 07/10] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-8-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <00b3c776-71e4-3687-0510-540462a43840@redhat.com>
Date:   Thu, 30 Sep 2021 09:42:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-8-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/28/21 8:48 PM, Ricardo Koller wrote:
> Add some GICv2 tests: general KVM device tests and DIST/REDIST overlap
> tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> in vgic_init GIC version agnostic.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 107 ++++++++++++------
>  1 file changed, 75 insertions(+), 32 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index b24067dbdac0..92f5c6ca6b8b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -79,74 +79,116 @@ static void vm_gic_destroy(struct vm_gic *v)
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
> + * DIST/REDIST. A RDIST region (legacy in the case of GICv3) is set at @0x0 and
> + * a DIST region is set @0x70000 for GICv3 and @0x1000 for GICv2.
I would add "Assumption is 4 vcpus are going to be used hence the overlap".
Also the RDIST is GICv3 only. In the above comment also mention the CPU I/F.
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
was that necessary?
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
> +	if (VGIC_DEV_IS_V3(v->gic_dev_type)) {
Instead you could check
    ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
                     KVM_VGIC_V3_ADDR_TYPE_REDIST);
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
> @@ -256,14 +298,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
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
> @@ -276,14 +318,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
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
> @@ -552,9 +594,10 @@ int test_kvm_device(uint32_t gic_dev_type)
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
Thanks

Eric

