Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E197C41E319
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 23:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbhI3VQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 17:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348652AbhI3VQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 17:16:08 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D9C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:14:25 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q23so6114610pfs.9
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hg19zG52jI0qoSrULpzK0t3FBxyLRjBAIZa9D41e5lk=;
        b=QJ2E5eoTFWYtnZVdHXO4IdEtHzlO9MrkPk3l20cWB246DnSyrZNoPdUK3RQhoTEfAM
         DDWuOg3j2YlAxjwPYGJBYyVqwcn2N6A2A4cF4BrvYKmUdPfNXQHmWqSl+2yjgwo1InQB
         sgieG+YFv2OePQZ4cB6mf9kkDfmzf29duTb+VVyhtqw4ggSUdPN9e3iRvY/aeQ++V6/+
         /pU9y1KfnwVtzTFc0WM51szH9ox0UEBGJ0QmJBECgXwsD5+XeQ6cO6M94R7IdIEc3KMH
         jeMLSBNMTKPKscmbtVMiDZxSXsuSl/s1KgjpN3Z8EdUwFd/xHwUCqGnMUJ3CyUYoFs3R
         3Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hg19zG52jI0qoSrULpzK0t3FBxyLRjBAIZa9D41e5lk=;
        b=CQ48GYre8HTuqRqRe7ap43ctzNL7WEkda5qdlV8qBFYcCdFIuSFAktxdEFrdX12cyR
         rGA/CCAeg1lWFsGwQQ5pmxC8qo5YhYZC1B3QJH493RFZfZJ+EgvqmxOTQyWthX/K1xvr
         Dl3Hefvh9NNs44AodSGG7E3eIQhbO1euQ0hsXfNQgV8U1tmXGl/lXRbfdI0qKZaXVD/C
         UdWJuHnKaJ2vBrg08vSw1OTiVvM8olFoa1L+wIe0wiBKuXZ+eZgoqlWccUTkZdCWRv/Y
         +nuo+8o2PVqeoW8tP1MT9eTZHWPCa7fvfJ3E+8B/rIJTzvgHNmzYZmWC6qnt9B48DvYL
         VXgA==
X-Gm-Message-State: AOAM5308rgFDKYnY/RWXe+z+c/Wk35ZTpxwPMr88RUHqovzSmGUq80w7
        HkMhc0MKK9sQ2bkHJFv2//79ig==
X-Google-Smtp-Source: ABdhPJy74/yNwbIvYcf8A1lWFDUbcOCCcR0YUHEGOaBevZ8ZbYervNn3U+Og51vg6wlVAu/3N5VAkg==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr6426537pgl.437.1633036464990;
        Thu, 30 Sep 2021 14:14:24 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id s188sm3649167pfb.44.2021.09.30.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:14:24 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:14:20 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 07/10] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
Message-ID: <YVYorHtJHBXZ+Aph@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-8-ricarkol@google.com>
 <00b3c776-71e4-3687-0510-540462a43840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b3c776-71e4-3687-0510-540462a43840@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:42:50AM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/28/21 8:48 PM, Ricardo Koller wrote:
> > Add some GICv2 tests: general KVM device tests and DIST/REDIST overlap
> > tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> > in vgic_init GIC version agnostic.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 107 ++++++++++++------
> >  1 file changed, 75 insertions(+), 32 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > index b24067dbdac0..92f5c6ca6b8b 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -79,74 +79,116 @@ static void vm_gic_destroy(struct vm_gic *v)
> >  	kvm_vm_free(v->vm);
> >  }
> >  
> > +struct vgic_region_attr {
> > +	uint64_t attr;
> > +	uint64_t size;
> > +	uint64_t alignment;
> > +};
> > +
> > +struct vgic_region_attr gic_v3_dist_region = {
> > +	.attr = KVM_VGIC_V3_ADDR_TYPE_DIST,
> > +	.size = 0x10000,
> > +	.alignment = 0x10000,
> > +};
> > +
> > +struct vgic_region_attr gic_v3_redist_region = {
> > +	.attr = KVM_VGIC_V3_ADDR_TYPE_REDIST,
> > +	.size = NR_VCPUS * 0x20000,
> > +	.alignment = 0x10000,
> > +};
> > +
> > +struct vgic_region_attr gic_v2_dist_region = {
> > +	.attr = KVM_VGIC_V2_ADDR_TYPE_DIST,
> > +	.size = 0x1000,
> > +	.alignment = 0x1000,
> > +};
> > +
> > +struct vgic_region_attr gic_v2_cpu_region = {
> > +	.attr = KVM_VGIC_V2_ADDR_TYPE_CPU,
> > +	.size = 0x2000,
> > +	.alignment = 0x1000,
> > +};
> > +
> >  /**
> > - * Helper routine that performs KVM device tests in general and
> > - * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
> > - * device gets created, a legacy RDIST region is set at @0x0
> > - * and a DIST region is set @0x60000
> > + * Helper routine that performs KVM device tests in general. Eventually the
> > + * ARM_VGIC (GICv2 or GICv3) device gets created with an overlapping
> > + * DIST/REDIST. A RDIST region (legacy in the case of GICv3) is set at @0x0 and
> > + * a DIST region is set @0x70000 for GICv3 and @0x1000 for GICv2.
> I would add "Assumption is 4 vcpus are going to be used hence the overlap".

ACK

> Also the RDIST is GICv3 only. In the above comment also mention the CPU I/F.

Will do. I wasn't sure if it was better to refer to both of them as CPU
interfaces, or redistributors (half correct in both cases).

> >   */
> > -static void subtest_v3_dist_rdist(struct vm_gic *v)
> > +static void subtest_dist_rdist(struct vm_gic *v)
> >  {
> >  	int ret;
> >  	uint64_t addr;
> > +	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
> > +	struct vgic_region_attr dist;
> > +
> > +	rdist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_redist_region
> > +						: gic_v2_cpu_region;
> > +	dist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_dist_region
> > +						: gic_v2_dist_region;
> >  
> >  	/* Check existing group/attributes */
> >  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			      KVM_VGIC_V3_ADDR_TYPE_DIST);
> > +			      dist.attr);
> >  
> >  	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
> > +			      rdist.attr);
> >  
> >  	/* check non existing attribute */
> > -	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
> > +	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
> was that necessary?

Yeah, turns out that 0 is used in v2:

#define KVM_VGIC_V2_ADDR_TYPE_DIST	0

> >  	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
> >  
> >  	/* misaligned DIST and REDIST address settings */
> > -	addr = 0x1000;
> > +	addr = dist.alignment / 0x10;
> >  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> > -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 dist base not 64kB aligned");
> > +				 dist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == EINVAL, "GIC dist base not aligned");
> >  
> > +	addr = rdist.alignment / 0x10;
> >  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > -	TEST_ASSERT(ret && errno == EINVAL, "GICv3 redist base not 64kB aligned");
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
> >  
> >  	/* out of range address */
> >  	if (max_ipa_bits) {
> >  		addr = 1ULL << max_ipa_bits;
> >  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> > +					 dist.attr, &addr, true);
> >  		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> >  
> >  		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > +					 rdist.attr, &addr, true);
> >  		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> >  	}
> >  
> >  	/* set REDIST base address @0x0*/
> >  	addr = 0x00000;
> >  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > +			  rdist.attr, &addr, true);
> >  
> >  	/* Attempt to create a second legacy redistributor region */
> >  	addr = 0xE0000;
> >  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > -	TEST_ASSERT(ret && errno == EEXIST, "GICv3 redist base set again");
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
> >  
> > -	/* Attempt to mix legacy and new redistributor regions */
> > -	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> > -	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > -	TEST_ASSERT(ret && errno == EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
> > +	if (VGIC_DEV_IS_V3(v->gic_dev_type)) {
> Instead you could check
>     ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>                      KVM_VGIC_V3_ADDR_TYPE_REDIST);

ACK, will do that instead.

> > +		/* Attempt to mix legacy and new redistributor regions */
> > +		addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
> > +		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
> > +					 &addr, true);
> > +		TEST_ASSERT(ret && errno == EINVAL,
> > +			    "attempt to mix GICv3 REDIST and REDIST_REGION");
> > +	}
> >  
> >  	/*
> >  	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
> >  	 * on first vcpu run instead.
> >  	 */
> > -	addr = 3 * 2 * 0x10000;
> > -	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
> > -			  &addr, true);
> > +	addr = rdist.size - rdist.alignment;
> > +	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  dist.attr, &addr, true);
> >  }
> >  
> >  /* Test the new REDIST region API */
> > @@ -256,14 +298,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
> >   * VGIC KVM device is created and initialized before the secondary CPUs
> >   * get created
> >   */
> > -static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> > +static void test_vgic_then_vcpus(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret, i;
> >  
> >  	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
> >  
> > -	subtest_v3_dist_rdist(&v);
> > +	subtest_dist_rdist(&v);
> >  
> >  	/* Add the rest of the VCPUs */
> >  	for (i = 1; i < NR_VCPUS; ++i)
> > @@ -276,14 +318,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> >  }
> >  
> >  /* All the VCPUs are created before the VGIC KVM device gets initialized */
> > -static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
> > +static void test_vcpus_then_vgic(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret;
> >  
> >  	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
> >  
> > -	subtest_v3_dist_rdist(&v);
> > +	subtest_dist_rdist(&v);
> >  
> >  	ret = run_vcpu(v.vm, 3);
> >  	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
> > @@ -552,9 +594,10 @@ int test_kvm_device(uint32_t gic_dev_type)
> >  
> >  void run_tests(uint32_t gic_dev_type)
> >  {
> > +	test_vcpus_then_vgic(gic_dev_type);
> > +	test_vgic_then_vcpus(gic_dev_type);
> > +
> >  	if (VGIC_DEV_IS_V3(gic_dev_type)) {
> > -		test_v3_vcpus_then_vgic(gic_dev_type);
> > -		test_v3_vgic_then_vcpus(gic_dev_type);
> >  		test_v3_new_redist_regions();
> >  		test_v3_typer_accesses();
> >  		test_v3_last_bit_redist_regions();
> Thanks
> 
> Eric
> 

Thanks,
Ricardo
