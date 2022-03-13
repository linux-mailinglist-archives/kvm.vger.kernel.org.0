Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93CD4D76A1
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiCMQIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 12:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiCMQIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 12:08:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9637DAA2
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:07:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r6so19891300wrr.2
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KLIjBFVUdnhZCwV++o0PuDAfVw6AnYVs+d1922S6HjE=;
        b=RNR0ZOU2EIifTXgg17kp0lHpUVX3o3wDJALOr9V8DG6LI4IffvQbaul7kvN4OkKq0I
         T4SsNb6e/It/p0E96JRuuKc4KCua/YktY7EhMVn3/NEBUksRcpOKnm/AFukTOcKr2EDE
         /Rf7F+QvRn5A77ymo62WlmWRC1ky8EwBoRFPDYpNOqtBp18xukFjQtAsMaUjsNe3Wpmq
         p1ah73z+WbuDKfiy45ixublGYglXZZ9GlKvTAVvA2PsGMZvMBhdVY4xogZNd2/9Sd4Tb
         POS0dUzPXSpx+/40SZ983W+HkQ6xHEW+qDF9Yhx2wdXd6RybZKQoa9WWGq3zZ3roatfP
         tbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KLIjBFVUdnhZCwV++o0PuDAfVw6AnYVs+d1922S6HjE=;
        b=ldZNYHEn6sUty7mzuUyTHcMjZajPqeCGvDc2x5yG8m7uAxAEtf3LqFB9y58mMSCf2L
         6IK6BWGmkFXJ744bGk6pguFJGE6tkZ1jVC84kaH5XGsl5/Omo+eqFNF7jVkY7p03EIZL
         0dnKbeInTnCusShtNKSDthWOb9igP3w8NzcrKHZPLc0H3UrgcuaTlx1Uh1Sd5AH6V+D7
         YhwuR3jjvDQ5cf6KhpY4OhPHEPKRnmpuoWKJj+RoDsn+oOWK8O56hTEDtpmUvWRAOodl
         m6iHMWTO6DhnhZGl3rWs5fWq7T05fyTwDGBr3tin8dShXTDyQRs1iRhhtGJDf30KmKBA
         GwcQ==
X-Gm-Message-State: AOAM533lC10GZd8iF+zt0aHGat9qM0XYoh+nWlejLNfSfy81taFrSoqz
        PLW+nZxilZGnMJpvhpXp9V+ERg==
X-Google-Smtp-Source: ABdhPJyzdUGUePz6WFo90wPSBSPomOgB2jy5pycgi/V7bglYS35SLwCHiF580o9FEjjB+dJeCnOKXQ==
X-Received: by 2002:a5d:44d2:0:b0:1f0:247d:8cf7 with SMTP id z18-20020a5d44d2000000b001f0247d8cf7mr13334865wrr.475.1647187659451;
        Sun, 13 Mar 2022 09:07:39 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id v12-20020a5d4a4c000000b001e68ba61747sm11187250wrs.16.2022.03.13.09.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 09:07:38 -0700 (PDT)
Date:   Sun, 13 Mar 2022 16:07:37 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v10 2/3] aarch64: Add stolen time support
Message-ID: <Yi4WydNfkA8IqEES@google.com>
References: <20220309133422.2432649-1-sebastianene@google.com>
 <20220309133422.2432649-3-sebastianene@google.com>
 <YiswH2PGOB86gLNQ@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiswH2PGOB86gLNQ@monolith.localdoman>
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

On Fri, Mar 11, 2022 at 11:18:55AM +0000, Alexandru Elisei wrote:
> Hi,
> 

Hi,

> On Wed, Mar 09, 2022 at 01:34:23PM +0000, Sebastian Ene wrote:
> > This patch adds support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> > to be used by pvtime. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  Makefile                               |  1 +
> >  arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
> >  arm/aarch64/arm-cpu.c                  |  2 +-
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
> >  arm/aarch64/pvtime.c                   | 96 ++++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |  6 +-
> >  arm/kvm-cpu.c                          |  1 +
> >  include/kvm/kvm-config.h               |  1 +
> >  8 files changed, 112 insertions(+), 2 deletions(-)
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
> > diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> > index 780e0e2..6fe0206 100644
> > --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> > @@ -20,4 +20,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> > +{
> > +	return 0;
> > +}
> > +
> >  #endif /* KVM__KVM_CPU_ARCH_H */
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
> > index 8dfb82e..35996dc 100644
> > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > @@ -19,5 +19,7 @@
> >  
> >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> > +int kvm_cpu__teardown_pvtime(struct kvm *kvm);
> >  
> >  #endif /* KVM__KVM_CPU_ARCH_H */
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..720e9de
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,96 @@
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/util.h"
> > +
> > +#include <linux/byteorder.h>
> > +#include <linux/types.h>
> > +
> > +#define ARM_PVTIME_STRUCT_SIZE		(64)
> > +
> > +static void *usr_mem;
> > +
> > +static int pvtime__alloc_region(struct kvm *kvm)
> > +{
> > +	char *mem;
> > +	int ret = 0;
> > +
> > +	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -errno;
> > +
> > +	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
> > +				ARM_PVTIME_BASE, mem);
> > +	if (ret) {
> > +		munmap(mem, ARM_PVTIME_BASE);
> > +		return ret;
> > +	}
> > +
> > +	usr_mem = mem;
> > +	return ret;
> > +}
> > +
> > +static int pvtime__teardown_region(struct kvm *kvm)
> > +{
> > +	if (usr_mem == NULL)
> > +		return 0;
> > +
> > +	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> > +			 ARM_PVTIME_BASE, usr_mem);
> > +	munmap(usr_mem, ARM_PVTIME_BASE);
> > +	usr_mem = NULL;
> > +	return 0;
> > +}
> > +
> > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > +{
> > +	int ret;
> > +	bool has_stolen_time;
> > +	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
> > +		ARM_PVTIME_STRUCT_SIZE;
> > +	struct kvm_config *kvm_cfg = NULL;
> > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > +		.attr	= KVM_ARM_VCPU_PVTIME_IPA
> > +	};
> > +
> > +	kvm_cfg = &vcpu->kvm->cfg;
> > +	if (kvm_cfg->no_pvtime)
> > +		return 0;
> > +
> > +	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> > +						  KVM_CAP_STEAL_TIME);
> > +	if (!has_stolen_time) {
> > +		kvm_cfg->no_pvtime = true;
> > +		return 0;
> > +	}
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > +	if (ret) {
> > +		perror("KVM_HAS_DEVICE_ATTR failed\n");
> > +		goto out_err;
> 
> Nitpick: here we return -1 (ioctl() return value when it fails) instead of
> returning -errno. You can set ret = -errno before the perror() call (in
> case it also fails for some reason, thus changing the value of errno).
> 
> Not a big deal, but it changes the semantics of the return value for the
> function: below, for pvtime__alloc_region() we return -errno, but here we
> return -1. Someone who is debugging an error might print this return value
> and think that the ioctl() failed with error code EPERM (EPERM is 1), which
> is not a valid error code for ioctl() according to man 2 ioctl. It will
> also look rather strange for the perror to print the error message
> associated with a different error code than the error code that is returned
> from this function.
> 

I will update the return code, thanks for the suggestion.

> > +	}
> > +
> > +	if (!usr_mem) {
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
> 
> Nitpick: same here, ret must be set to -errno before returning.
>

Right, I will set it to errno on 'ret != 0'.

> > +
> > +	perror("KVM_SET_DEVICE_ATTR failed\n");
> > +	pvtime__teardown_region(vcpu->kvm);
> > +out_err:
> > +	return ret;
> > +}
> > +
> > +int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> > +{
> > +	return pvtime__teardown_region(kvm);
> > +}
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index c645ac0..43b1f77 100644
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
> > +#define ARM_PVTIME_BASE		(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> > +#define ARM_PVTIME_SIZE		SZ_64K
> > +
> >  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> >  #define KVM_FLASH_MAX_SIZE	0x1000000
> >  
> > diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> > index 84ac1e9..00660d6 100644
> > --- a/arm/kvm-cpu.c
> > +++ b/arm/kvm-cpu.c
> > @@ -144,6 +144,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
> >  
> >  void kvm_cpu__delete(struct kvm_cpu *vcpu)
> >  {
> > +	kvm_cpu__teardown_pvtime(vcpu->kvm);
> >  	free(vcpu);
> >  }
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
> > -- 
> 
> Tested the series, a guest is able to detect pvtime:
> 
> [    0.008661] arm-pv: using stolen time PV
> 

Thanks for the review and for testing this,

> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> With the two nitpicks above fixed, the patch looks correct to me:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks,
> Alex

Cheers,
Sebastian
