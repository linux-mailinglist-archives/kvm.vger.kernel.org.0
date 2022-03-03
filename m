Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6779F4CBD46
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiCCMCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 07:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiCCMCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:02:00 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9644E16DAD8
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 04:01:14 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m6so7459679wrr.10
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 04:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSB4F21TXn1MgqrWVsXRoOrexLcW+xGDf92u7Aq7Y5s=;
        b=PYX2NuUAlj3uyyQx5TQPuukYzefwP+vkUl6piIdvtsdTdsL8eaG1Jj2gL+xwpIXLAe
         P9U2XwhgvLRsZN8d5+zHnwMftoOh2rxcSHMYC9Nb5J8YLeYMW4q5gH6zDYdghdwjcQpd
         ViBJHHnXJrVkQ1qeXcfZD5yJq8/UzXYHEJxIFcvYNM9bGw6E1sI/pgKNXd465Ft5UvLE
         dqGlshDjNlvbs5/GljfSZL70+POGvGf134eR/GmzY+DwXwvRgfwWuRx+2Py/BnhaUjWr
         HSvvH8TL8GtmJhf6L2oQV90t8tHrzwVRqnT64SzzG4myHcihafveU0SHfpecSsse1C3b
         OHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cSB4F21TXn1MgqrWVsXRoOrexLcW+xGDf92u7Aq7Y5s=;
        b=acgsNLhE15yzYHngvU5ru11aXcQ0VIX14q37OcDwnN9hr2r5neeSaI+ejUcccgxdNl
         C7AtkvfNXsmQy+5qyedlef3+udxj6WqGDHIY5ukyBQPxrT3FwVLxya6MPuVjB3bV/vLH
         HOWyOCiY39ITjQx7BbJofG4BXtNGYFzGO+EMw9BNvgyd1MXee+FQpVAFzSwiOpx0Pjr5
         eLDx64S7JoaoriC4iMyRSfB+0oo2awbGDOei+xyQ+mdO75nTX1IclzIXoeJ5flFlfgxp
         8KBIO6todTylCOzjuMYsA3GOXPzeSIapBEssxldXlg49foYzSqcaNW0nz1aTut76uHYk
         CBkA==
X-Gm-Message-State: AOAM530NACK0yB/Vxl2A7Et4Qj2aBfQko17Se8ZF32QeX6md5mRBwQnH
        jPVWUwL39lx9ly0y+zF9sLe56/8bjM7J2T14
X-Google-Smtp-Source: ABdhPJwg6+a2tiR6fwfIMKLJmYWdUBo6zkfudXv0rBNDVGV5R9Satvn0oNnIYjg6eiPW+azqel34yQ==
X-Received: by 2002:a5d:608d:0:b0:1f0:4b94:4f54 with SMTP id w13-20020a5d608d000000b001f04b944f54mr2446166wrt.479.1646308872951;
        Thu, 03 Mar 2022 04:01:12 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id u14-20020adfed4e000000b001e3323611e5sm1790801wro.26.2022.03.03.04.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 04:01:12 -0800 (PST)
Date:   Thu, 3 Mar 2022 12:01:10 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v7 2/3] aarch64: Add stolen time support
Message-ID: <YiCuBsKsh4TAZqTs@google.com>
References: <20220302140734.1015958-1-sebastianene@google.com>
 <20220302140734.1015958-3-sebastianene@google.com>
 <8735k02z98.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735k02z98.wl-maz@kernel.org>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 02:41:07PM +0000, Marc Zyngier wrote:
> Hi Sebastian,
> 

Hello Marc,

> On Wed, 02 Mar 2022 14:07:35 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > This patch adds support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> > to be used by pvtime. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  Makefile                               |   1 +
> >  arm/aarch64/arm-cpu.c                  |   2 +-
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |   1 +
> >  arm/aarch64/pvtime.c                   | 103 +++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |   6 +-
> >  include/kvm/kvm-config.h               |   1 +
> >  6 files changed, 112 insertions(+), 2 deletions(-)
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
> > index d7572b7..7e4a3c1 100644
> > --- a/arm/aarch64/arm-cpu.c
> > +++ b/arm/aarch64/arm-cpu.c
> > @@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> >  {
> >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > -	return 0;
> > +	return kvm_cpu__setup_pvtime(vcpu);
> >  }
> >  
> >  static struct kvm_arm_target target_generic_v8 = {
> > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > index 8dfb82e..2b2c1ff 100644
> > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > @@ -19,5 +19,6 @@
> >  
> >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> >  
> >  #endif /* KVM__KVM_CPU_ARCH_H */
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..fdde683
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,103 @@
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/util.h"
> > +
> > +#include <linux/byteorder.h>
> > +#include <linux/types.h>
> > +
> > +#define ARM_PVTIME_STRUCT_SIZE		(64)
> > +
> > +struct pvtime_data_priv {
> > +	bool	is_supported;
> > +	char	*usr_mem;
> 
> Consider using void * for pointers that do not have any particular
> semantics associated to them.
> 

I will update the pointer to void * type.

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
> > +	mem = mmap(NULL, ARM_PVTIME_MMIO_SIZE, PROT_RW,
> 
> I sort of object to the 'MMIO' part of the name. The spec is quite
> clear that this should be normal memory. That's purely cosmetic, but
> still a bit confusing.
> 

I will remove the 'MMIO' part of the name: ARM_PVTIME_SIZE and
ARM_PVTIME_BASE will be the new definitions. Initially I thought to keep
the 'MMIO' name as this ram portion is placed after RTC_MMIO region but I
agree that it's a bit confusing.

> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -errno;
> > +
> > +	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +				    ARM_PVTIME_MMIO_SIZE, mem);
> 
> This, on the other side, is wrong. Since the pvtime pages are memory,
> mapping them with device attributes will do the wrong thing (the
> hypervisor will write to a cacheable mapping, and the guest will
> bypass the cache due to the S2 override that you provide here).
> 
> kvm__register_ram() is more likely to lead to the behaviour you'd
> expect.
> 

Thanks for the explanation ! Nice catch. I will update the call and use
kvm__register_ram().

> > +	if (ret) {
> > +		munmap(mem, ARM_PVTIME_MMIO_SIZE);
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
> > +	kvm__destroy_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +			 ARM_PVTIME_MMIO_SIZE, pvtime_data.usr_mem);
> > +	munmap(pvtime_data.usr_mem, ARM_PVTIME_MMIO_SIZE);
> > +	pvtime_data.usr_mem = NULL;
> > +	return 0;
> > +}
> > +
> > +dev_exit(pvtime__teardown_region);
> > +
> > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > +{
> > +	int ret;
> > +	bool has_stolen_time;
> > +	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
> > +		ARM_PVTIME_STRUCT_SIZE;
> > +	struct kvm_config *kvm_cfg = NULL;
> > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > +	};
> > +
> > +	kvm_cfg = &vcpu->kvm->cfg;
> > +	if (kvm_cfg->no_pvtime)
> > +		return 0;
> > +
> > +	if (!pvtime_data.is_supported)
> > +		return -ENOTSUP;
> 
> It is a bit odd to have this hard failure if running on a system that
> doesn't have pvtime. It forces the user to alter their command-line,
> which is a bit annoying. I'd rather have a soft-fail here.
> 

The flag 'is_supported' is set to false when we support pvtime but we
fail to configure it. We verify that we support pvtime by calling the check
extension KVM_CAP_STEAL_TIME. I think the naming is odd here for the
flag name. It should be : 'is_failed_cfg'.

> > +
> > +	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> > +						  KVM_CAP_STEAL_TIME);
> > +	if (!has_stolen_time)
> > +		return 0;
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > +	if (ret) {
> > +		perror("KVM_HAS_DEVICE_ATTR failed\n");
> > +		goto out_err;
> > +	}
> > +
> > +	if (!pvtime_data.usr_mem) {
> > +		ret = pvtime__alloc_region(vcpu->kvm);
> > +		if (ret) {
> > +			perror("Failed allocating pvtime region\n");
> > +			goto out_err;
> > +		}
> > +	}
> > +
> > +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> > +	if (!ret)
> > +		return 0;
> > +
> > +	perror("KVM_SET_DEVICE_ATTR failed\n");
> > +	pvtime__teardown_region(vcpu->kvm);
> > +out_err:
> > +	pvtime_data.is_supported = false;
> > +	return ret;
> > +}
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index c645ac0..3f82663 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -15,7 +15,8 @@
> >   * |  PCI  |////| plat  |       |        |     |         |
> >   * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
> >   * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
> > - * |       |////| RTC   |       |        |     |         |
> > + * |       |////| RTC,  |       |        |     |         |
> > + * |       |////| PVTIME|       |        |     |         |
> >   * +-------+----+-------+-------+--------+-----+---------+---......
> >   */
> >  
> > @@ -34,6 +35,9 @@
> >  #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
> >  #define ARM_RTC_MMIO_SIZE	0x10000
> >  
> > +#define ARM_PVTIME_MMIO_BASE	(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> > +#define ARM_PVTIME_MMIO_SIZE	SZ_64K
> > +
> >  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> >  #define KVM_FLASH_MAX_SIZE	0x1000000
> >  
> > diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> > index 6a5720c..48adf27 100644
> > --- a/include/kvm/kvm-config.h
> > +++ b/include/kvm/kvm-config.h
> > @@ -62,6 +62,7 @@ struct kvm_config {
> >  	bool no_dhcp;
> >  	bool ioport_debug;
> >  	bool mmio_debug;
> > +	bool no_pvtime;
> >  };
> >  
> >  #endif
> 
> Thanks,
> 

Thanks for the review,

> 	M.
> 

Sebastian

> -- 
> Without deviation from the norm, progress is not possible.
