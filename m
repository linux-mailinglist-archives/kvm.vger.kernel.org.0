Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EACA6A7563
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCAUd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCAUd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:33:57 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E31EBCE;
        Wed,  1 Mar 2023 12:33:51 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id j17so15330024ljq.11;
        Wed, 01 Mar 2023 12:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677702829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F14Yg6j8CjnO2GgnFPI0eLv2PPbZQX2WxbIgOsUbQuo=;
        b=d/f0/EcO3a+BoqqV/QHn2B6aSbAep0kw8I8AETm0wLyNvrF4YmecfXc7J56vBuxrwx
         ZCXUHGY42VEndv3JWxsl9VGPNTajqte3UN713AtRbd41+D0FbQpZuUA3bqiCBviVBz1A
         199y3YUZdYCgQo8k3BlGxj2Hnl8EynfX/AfY5Gb942olXEvU4rcFBtWcV63ERC2jONlm
         esNej17bIqSUrDZrNKuvmAoajchvEfNMvuEXRZVhF3vWrHZzVXqPSrOq2f6wrGVgvOmH
         0cFFo77qhjLtIvAREeKVU86FyUE3URnLf36KhhxMoLWX6v5EjzeKXuw3sycEBuvQ/Yz+
         VfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677702829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F14Yg6j8CjnO2GgnFPI0eLv2PPbZQX2WxbIgOsUbQuo=;
        b=ByD/+hSLN8bcrP0Ruo6qca1FJtW+QPb7HpzTaTbB7ITE3MKtq3B8D0eWJybWxTH6Vu
         8PL9EaI6H0SYk3WgqQ4sDJXYi8Z3CShUh7tjmHaP5WVbmH75CxE5poUSS6Pm0obdJU18
         99cDWF3JkBXFtBUmndJwIgqSC6p8a+zUidgNP2qXtZ82ZT8OkNi72WVTIba/Bju3DGWz
         or5TWRO6JI+VfT58UlRIuJXnoCLwRDigz0p5dMOGufFwod4JKJvN3EWx6twxVJ/f42HF
         5y1ND7Y5toImnfp+6N8/7hDlXfL9n4P91FrFlImhGrdmdq74wGCH0CnrG8Q4+MkjnGKk
         n63g==
X-Gm-Message-State: AO0yUKVI+tiIp5p2hFGGSo9iHawBp/1x6uaP4MNIK0MAcYJ6NsphF+nV
        90ktV5Z1YG2qwuLjSzESbiA=
X-Google-Smtp-Source: AK7set/hcHtp3GjmUdRWo+Y2B7PECElEq3V23NbAxPdL1hzXgz5I4Dtwh53wl90A1VfKfnDeI5KNiw==
X-Received: by 2002:a2e:9bd6:0:b0:295:c3fc:8a49 with SMTP id w22-20020a2e9bd6000000b00295c3fc8a49mr2389921ljj.2.1677702829201;
        Wed, 01 Mar 2023 12:33:49 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v11-20020a2ea44b000000b002935632b3f8sm1822091ljn.14.2023.03.01.12.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:33:48 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 22:33:46 +0200
To:     Steven Price <steven.price@arm.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
Message-ID: <20230301223346.00000a0b@intel.com>
In-Reply-To: <04adb31d-06c5-b274-62c6-4f19dc681513@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-7-steven.price@arm.com>
        <20230213181044.00004994@gmail.com>
        <04adb31d-06c5-b274-62c6-4f19dc681513@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Mar 2023 11:55:17 +0000
Steven Price <steven.price@arm.com> wrote:

> On 13/02/2023 16:10, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:10 +0000
> > Steven Price <steven.price@arm.com> wrote:
> > 
> >> Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves
> >> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> >> the base level of the Realm Translation Tables (RTT). A VMID also need
> >> to be picked, since the RMM has a separate VMID address space a
> >> dedicated allocator is added for this purpose.
> >>
> >> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> >> before it is created.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_rme.h |  14 ++
> >>  arch/arm64/kvm/arm.c             |  19 ++
> >>  arch/arm64/kvm/mmu.c             |   6 +
> >>  arch/arm64/kvm/reset.c           |  33 +++
> >>  arch/arm64/kvm/rme.c             | 357 +++++++++++++++++++++++++++++++
> >>  5 files changed, 429 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> >> index c26bc2c6770d..055a22accc08 100644
> >> --- a/arch/arm64/include/asm/kvm_rme.h
> >> +++ b/arch/arm64/include/asm/kvm_rme.h
> >> @@ -6,6 +6,8 @@
> >>  #ifndef __ASM_KVM_RME_H
> >>  #define __ASM_KVM_RME_H
> >>  
> >> +#include <uapi/linux/kvm.h>
> >> +
> >>  enum realm_state {
> >>  	REALM_STATE_NONE,
> >>  	REALM_STATE_NEW,
> >> @@ -15,8 +17,20 @@ enum realm_state {
> >>  
> >>  struct realm {
> >>  	enum realm_state state;
> >> +
> >> +	void *rd;
> >> +	struct realm_params *params;
> >> +
> >> +	unsigned long num_aux;
> >> +	unsigned int vmid;
> >> +	unsigned int ia_bits;
> >>  };
> >>  
> > 
> > Maybe more comments for this structure?
> 
> Agreed, this series is a bit light on comments. I'll try to improve for v2.
> 
> <snip>
> 
> > 
> > Just curious. Wouldn't it be better to use IDR as this is ID allocation? There
> > were some efforts to change the use of bitmap allocation to IDR before.
> 
> I'm not sure it makes much difference really. This matches KVM's
> vmid_map, but here things are much more simple as there's no support for
> the likes of VMID rollover (the number of Realm VMs is just capped at
> the number of VMIDs).
> 
> IDR provides a lot of functionality we don't need, but equally I don't
> think performance or memory usage are really a concern here.

Agree. I am not opposed to the current approach. I gave this comment because
I vaguely remember there were some patch bundles to covert bitmap to IDR in
the kernel before. So I think it would be better to raise it up and get a
conclusion. It would save some efforts for the people who might jump in the
review later.

> 
> Steve
> 
> >> +/* Protects access to rme_vmid_bitmap */
> >> +static DEFINE_SPINLOCK(rme_vmid_lock);
> >> +static unsigned long *rme_vmid_bitmap;
> >> +
> >> +static int rme_vmid_init(void)
> >> +{
> >> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> >> +
> >> +	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
> >> +	if (!rme_vmid_bitmap) {
> >> +		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
> >> +		return -ENOMEM;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int rme_vmid_reserve(void)
> >> +{
> >> +	int ret;
> >> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> >> +
> >> +	spin_lock(&rme_vmid_lock);
> >> +	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
> >> +	spin_unlock(&rme_vmid_lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void rme_vmid_release(unsigned int vmid)
> >> +{
> >> +	spin_lock(&rme_vmid_lock);
> >> +	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
> >> +	spin_unlock(&rme_vmid_lock);
> >> +}
> >> +
> >> +static int kvm_create_realm(struct kvm *kvm)
> >> +{
> >> +	struct realm *realm = &kvm->arch.realm;
> >> +	int ret;
> >> +
> >> +	if (!kvm_is_realm(kvm) || kvm_realm_state(kvm) != REALM_STATE_NONE)
> >> +		return -EEXIST;
> >> +
> >> +	ret = rme_vmid_reserve();
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	realm->vmid = ret;
> >> +
> >> +	ret = realm_create_rd(kvm);
> >> +	if (ret) {
> >> +		rme_vmid_release(realm->vmid);
> >> +		return ret;
> >> +	}
> >> +
> >> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
> >> +
> >> +	/* The realm is up, free the parameters.  */
> >> +	free_page((unsigned long)realm->params);
> >> +	realm->params = NULL;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int config_realm_hash_algo(struct realm *realm,
> >> +				  struct kvm_cap_arm_rme_config_item *cfg)
> >> +{
> >> +	switch (cfg->hash_algo) {
> >> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
> >> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
> >> +			return -EINVAL;
> >> +		break;
> >> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
> >> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
> >> +			return -EINVAL;
> >> +		break;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +	realm->params->measurement_algo = cfg->hash_algo;
> >> +	return 0;
> >> +}
> >> +
> >> +static int config_realm_sve(struct realm *realm,
> >> +			    struct kvm_cap_arm_rme_config_item *cfg)
> >> +{
> >> +	u64 features_0 = realm->params->features_0;
> >> +	int max_sve_vq = u64_get_bits(rmm_feat_reg0,
> >> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
> >> +
> >> +	if (!rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN))
> >> +		return -EINVAL;
> >> +
> >> +	if (cfg->sve_vq > max_sve_vq)
> >> +		return -EINVAL;
> >> +
> >> +	features_0 &= ~(RMI_FEATURE_REGISTER_0_SVE_EN |
> >> +			RMI_FEATURE_REGISTER_0_SVE_VL);
> >> +	features_0 |= u64_encode_bits(1, RMI_FEATURE_REGISTER_0_SVE_EN);
> >> +	features_0 |= u64_encode_bits(cfg->sve_vq,
> >> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
> >> +
> >> +	realm->params->features_0 = features_0;
> >> +	return 0;
> >> +}
> >> +
> >> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
> >> +{
> >> +	struct kvm_cap_arm_rme_config_item cfg;
> >> +	struct realm *realm = &kvm->arch.realm;
> >> +	int r = 0;
> >> +
> >> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> >> +		return -EBUSY;
> >> +
> >> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
> >> +		return -EFAULT;
> >> +
> >> +	switch (cfg.cfg) {
> >> +	case KVM_CAP_ARM_RME_CFG_RPV:
> >> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
> >> +		break;
> >> +	case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
> >> +		r = config_realm_hash_algo(realm, &cfg);
> >> +		break;
> >> +	case KVM_CAP_ARM_RME_CFG_SVE:
> >> +		r = config_realm_sve(realm, &cfg);
> >> +		break;
> >> +	default:
> >> +		r = -EINVAL;
> >> +	}
> >> +
> >> +	return r;
> >> +}
> >> +
> >> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> >> +{
> >> +	int r = 0;
> >> +
> >> +	switch (cap->args[0]) {
> >> +	case KVM_CAP_ARM_RME_CONFIG_REALM:
> >> +		r = kvm_rme_config_realm(kvm, cap);
> >> +		break;
> >> +	case KVM_CAP_ARM_RME_CREATE_RD:
> >> +		if (kvm->created_vcpus) {
> >> +			r = -EBUSY;
> >> +			break;
> >> +		}
> >> +
> >> +		r = kvm_create_realm(kvm);
> >> +		break;
> >> +	default:
> >> +		r = -EINVAL;
> >> +		break;
> >> +	}
> >> +
> >> +	return r;
> >> +}
> >> +
> >> +void kvm_destroy_realm(struct kvm *kvm)
> >> +{
> >> +	struct realm *realm = &kvm->arch.realm;
> >> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> >> +	unsigned int pgd_sz;
> >> +	int i;
> >> +
> >> +	if (realm->params) {
> >> +		free_page((unsigned long)realm->params);
> >> +		realm->params = NULL;
> >> +	}
> >> +
> >> +	if (kvm_realm_state(kvm) == REALM_STATE_NONE)
> >> +		return;
> >> +
> >> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
> >> +
> >> +	rme_vmid_release(realm->vmid);
> >> +
> >> +	if (realm->rd) {
> >> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> >> +
> >> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
> >> +			return;
> >> +		if (WARN_ON(rmi_granule_undelegate(rd_phys)))
> >> +			return;
> >> +		free_page((unsigned long)realm->rd);
> >> +		realm->rd = NULL;
> >> +	}
> >> +
> >> +	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
> >> +	for (i = 0; i < pgd_sz; i++) {
> >> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> >> +
> >> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> >> +			return;
> >> +	}
> >> +
> >> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> >> +}
> >> +
> >> +int kvm_init_realm_vm(struct kvm *kvm)
> >> +{
> >> +	struct realm_params *params;
> >> +
> >> +	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
> >> +	if (!params)
> >> +		return -ENOMEM;
> >> +
> >> +	params->features_0 = create_realm_feat_reg0(kvm);
> >> +	kvm->arch.realm.params = params;
> >> +	return 0;
> >> +}
> >> +
> >>  int kvm_init_rme(void)
> >>  {
> >> +	int ret;
> >> +
> >>  	if (PAGE_SIZE != SZ_4K)
> >>  		/* Only 4k page size on the host is supported */
> >>  		return 0;
> >> @@ -43,6 +394,12 @@ int kvm_init_rme(void)
> >>  		/* Continue without realm support */
> >>  		return 0;
> >>  
> >> +	ret = rme_vmid_init();
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	WARN_ON(rmi_features(0, &rmm_feat_reg0));
> >> +
> >>  	/* Future patch will enable static branch kvm_rme_is_available */
> >>  
> >>  	return 0;
> > 
> 

