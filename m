Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06B74BBA5E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 15:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiBRODd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 09:03:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiBRODc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 09:03:32 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115CE173B33
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 06:03:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id p9so14743719wra.12
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 06:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vGCgEB2EWkLQKUMYKQNwxkOP/Yb7el6dtXFMGwKacLA=;
        b=rm5ZfC4muyEsvYz5oGesAtl+TwTSHzGYN/qFHp5rJ/YiflwZ8t3Do6yRA2fMWzhbcC
         5DW8POqrMPoQvzxbZvJZyoXBy3mkFpvGC4Mt0VCLEVbVvcI+MW8Tdf5N0ltaQa+YO1Q7
         PvaRRhei9Npd7uqwx/yFwZXExQssjpl+iu+itXPkL3u0lkhXz7Ee786bBz501NjRqZFg
         wUAWgRzjqnqQOwO8muCc1TWiPRUiz1NQHrqH0jzyBMCq5N4Iv/liBGqe25JgW6yOZPju
         EdzEXa5e/WVSTaolGxd3cdo5WoYDdyYnM8k1Op6PFYiNWehrV41RlXJ/ARwI7DEAnLKk
         dGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vGCgEB2EWkLQKUMYKQNwxkOP/Yb7el6dtXFMGwKacLA=;
        b=lqyb8DGar6ptnnLvIl4F0cgjeU8QULvDayl+O+azAULOb5OJrKSRbjhV7t7Yne7eRN
         JOvITbo4DfEhHC+OMnl9PfdWWO2nnKAV3kUDJgRl3RJLy4RBg18N2PCthMf165TWK0DI
         kXMGPFI3rfsylXKu/vrrML9pRZ0EGmkaQwUb7q7t9WWfPNCw02BnHv+e0C+wxvNHy5jE
         y0I+hhtclm5GbZ70kTG3b4aCgitKgu1hj3Shj8chnpEpsi9pDRufzCTU3pBChnCe9CoZ
         qpga20rSPOFkjUjdENhe6q4BuKUrEsAKsOtXf2igM417z5uyuN4yYKVjm8kxGl7uC30D
         Hw1g==
X-Gm-Message-State: AOAM531t4+d3r/ZG85xoNMsr1q70IaGRWuqMio0LFn9F3h53Od8gto9W
        W62AeEwb1Q2tl7vw38h75STn8w==
X-Google-Smtp-Source: ABdhPJxcA2yASEx5/GK9YR96JJftsm/aMdoMqXug8OhXaru+n5yM4+f2mpHywje/xZl0AJ2T9TzKwQ==
X-Received: by 2002:a05:6000:1541:b0:1e8:30f7:b3f0 with SMTP id 1-20020a056000154100b001e830f7b3f0mr6136243wry.578.1645192993441;
        Fri, 18 Feb 2022 06:03:13 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id x10sm4206731wmj.17.2022.02.18.06.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 06:03:13 -0800 (PST)
Date:   Fri, 18 Feb 2022 14:03:11 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v2] aarch64: Add stolen time support
Message-ID: <Yg+nHwSMmIXGoHjO@google.com>
References: <Yg5lBZKsSoPNmVkT@google.com>
 <Yg5tE3TqgwWRFypB@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg5tE3TqgwWRFypB@monolith.localdoman>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 03:43:15PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Some general comments while I familiarize myself with the stolen time spec.
> 
> On Thu, Feb 17, 2022 at 03:08:53PM +0000, Sebastian Ene wrote:
> > This patch adds support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> 
> It is customary to describe the changes you have made from the previous version,
> to make it easier for the people who want to review your code.
> 

Hello,

Thanks for the feedback. I will include the changelog in the next
patches.

> >  Makefile                               |  1 +
> >  arm/aarch64/arm-cpu.c                  |  1 +
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
> >  arm/aarch64/pvtime.c                   | 84 ++++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |  4 ++
> >  arm/kvm-cpu.c                          | 14 ++---
> >  6 files changed, 98 insertions(+), 7 deletions(-)
> >  create mode 100644 arm/aarch64/pvtime.c
> > 
> > diff --git a/Makefile b/Makefile
> > index f251147..e9121dc 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
> >  	OBJS		+= arm/aarch64/arm-cpu.o
> >  	OBJS		+= arm/aarch64/kvm-cpu.o
> >  	OBJS		+= arm/aarch64/kvm.o
> > +	OBJS		+= arm/aarch64/pvtime.o
> >  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> >  	ARCH_INCLUDE	+= -Iarm/aarch64/include
> >  
> > diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> > index d7572b7..326fb20 100644
> > --- a/arm/aarch64/arm-cpu.c
> > +++ b/arm/aarch64/arm-cpu.c
> > @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> >  {
> >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > +	kvm_cpu__setup_pvtime(vcpu);
> >  	return 0;
> >  }
> >  
> > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > index 8dfb82e..b57d6e6 100644
> > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > @@ -19,5 +19,6 @@
> >  
> >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> >  
> >  #endif /* KVM__KVM_CPU_ARCH_H */
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..c09fd89
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,84 @@
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/util.h"
> > +
> > +#include <linux/byteorder.h>
> > +#include <linux/types.h>
> > +
> > +struct pvtime_data_priv {
> > +	bool	is_supported;
> > +	char	*usr_mem;
> > +};
> > +
> > +static struct pvtime_data_priv pvtime_data = {
> > +	.is_supported	= true,
> > +	.usr_mem	= NULL
> > +};
> > +
> > +static int pvtime__alloc_region(struct kvm *kvm)
> > +{
> > +	char *mem;
> > +	int ret = 0;
> > +
> > +	mem = mmap(NULL, AARCH64_PVTIME_IPA_MAX_SIZE, PROT_RW,
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -ENOMEM;
> > +
> > +	ret = kvm__register_dev_mem(kvm, AARCH64_PVTIME_IPA_START,
> > +				    AARCH64_PVTIME_IPA_MAX_SIZE, mem);
> > +	if (ret) {
> > +		munmap(mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> > +		return ret;
> > +	}
> > +
> > +	pvtime_data.usr_mem = mem;
> > +	return ret;
> > +}
> > +
> > +static int pvtime__teardown_region(struct kvm *kvm)
> > +{
> > +	if (pvtime_data.usr_mem == NULL)
> > +		return 0;
> > +
> > +	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
> > +			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
> > +	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> > +	pvtime_data.usr_mem = NULL;
> > +	return 0;
> > +}
> > +
> > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > +{
> > +	int ret;
> > +	u64 pvtime_guest_addr = AARCH64_PVTIME_IPA_START + vcpu->cpu_id *
> > +		AARCH64_PVTIME_SIZE;
> > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > +	};
> > +
> > +	if (!pvtime_data.is_supported)
> > +		return;
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > +	if (ret)
> > +		goto out_err;
> > +
> > +	if (!pvtime_data.usr_mem) {
> > +		ret = pvtime__alloc_region(vcpu->kvm);
> > +		if (ret)
> > +			goto out_err;
> > +	}
> > +
> > +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> > +	if (!ret)
> > +		return;
> > +
> > +	pvtime__teardown_region(vcpu->kvm);
> > +out_err:
> > +	pvtime_data.is_supported = false;
> > +}
> > +
> > +dev_exit(pvtime__teardown_region);
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index c645ac0..865bd68 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -54,6 +54,10 @@
> >  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> >  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
> >  
> > +#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
> > +#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
> > +					 AARCH64_PVTIME_IPA_MAX_SIZE)
> 
> This overlaps with the ARM_PCI_MMIO_AREA. If you want to change the memory
> layout for a guest, there's a handy ASCII map at the top of this file.  That
> should also be updated to reflect the modified layout.

Right, when pvtime is supported it ovelaps that region. While this
feature is supported only for arm64, does it make sense to update the ASCII
map in this header which is arm-common ? Also, probably it makes sense to move
all of the definitions to pvtime.c ? What do you think ?

> 
> Why do you want to put it below RAM? Is there a requirement to have it there or
> was the location chosen for other reasons?
>

I don't have a strong argument for this placement but I am open to
suggestions if you would like to move it somewhere else. For example, we
are placing pvtime in the same region in crosvm.

> > +#define AARCH64_PVTIME_SIZE		(64)
> 
> This looks like something that should go in pvtime.c, as it's not relevant to
> the memory layout.
>

I agree, I will move this. Thanks.

> >  
> >  #define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> >  #define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> > diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> > index 6a2408c..84ac1e9 100644
> > --- a/arm/kvm-cpu.c
> > +++ b/arm/kvm-cpu.c
> > @@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  			die("Unable to find matching target");
> >  	}
> >  
> > +	/* Populate the vcpu structure. */
> > +	vcpu->kvm		= kvm;
> > +	vcpu->cpu_id		= cpu_id;
> > +	vcpu->cpu_type		= vcpu_init.target;
> > +	vcpu->cpu_compatible	= target->compatible;
> > +	vcpu->is_running	= true;
> > +
> >  	if (err || target->init(vcpu))
> >  		die("Unable to initialise vcpu");
> >  
> > @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  		vcpu->ring = (void *)vcpu->kvm_run +
> >  			     (coalesced_offset * PAGE_SIZE);
> >  
> > -	/* Populate the vcpu structure. */
> > -	vcpu->kvm		= kvm;
> > -	vcpu->cpu_id		= cpu_id;
> > -	vcpu->cpu_type		= vcpu_init.target;
> > -	vcpu->cpu_compatible	= target->compatible;
> > -	vcpu->is_running	= true;
> > -
> 
> Why this change?
>

I will add a comment to describe why I moved this. During pvtime setup,
in vcpu initialization I need to access the kvm structure from the vcpu.

> Thanks,
> Alex
> 

Thanks for the review,
Sebastian

> >  	if (kvm_cpu__configure_features(vcpu))
> >  		die("Unable to configure requested vcpu features");
> >  
> > -- 
> > 2.35.1.265.g69c8d7142f-goog
> > 
