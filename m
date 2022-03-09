Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A424D2FD4
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiCINV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiCINVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:21:55 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506BF179250
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 05:20:56 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u1so2975881wrg.11
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 05:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BliLg0I6GQNRm+9J6hpahlGPKM+LjQC7zR5fB3dy6N4=;
        b=IY26HYZSTtIaa5msZzOr6URf8C8JpbqqxJvsglG1nQbdFkpfkR8KPn3aitMXjdOOhS
         e5jdjZcQsZ4gyA4Fz/80IMyW1o3ldk5RYzLRBiRpn+G5/KjI2UXJOuU7ue68vC5VmeJk
         rA+ndUl9z6LFKdJxvRKF55+8+zoSXofhPvvIdJqQjq6qWcqN118jlVL7uJdrVjMxtTUo
         tgEFkZwEAMiYVYXwaKId470Md1tCVCc3G1BzfUjD3EDZ8aNwd4zHC0Ypwb84DI/InLX4
         zSNuPyu8iKgA04rCXDU4xai7IPp+NT3FWb8Hv7n4nDjSO7N3cwA0yU0XvDQbsX/6r4in
         9BVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BliLg0I6GQNRm+9J6hpahlGPKM+LjQC7zR5fB3dy6N4=;
        b=HDhY5ylbGQIz6uBdEn9wZ1jjdkbRssZoEL6vZl5zAYY3+YolEVpDcKOgnfAEtvt+uA
         lg2L0NYYIqqiRidHZvUL/WGH63q7JTT9XQAbrayGMXhaGz91FIjz1y14Cd+1OwKKd0sy
         NGW5rg3YqVd8f0qo2ipjE5j0Tpgrmi8B56Nq3GIerXAOOREmrSkpsTmzJWG7sFY5tjn0
         dxRBKgWbCtcrqnd+taKMx6dTSg5Rz8bpCkQk4NwdcmEAGSG3wc+XTz89xO7PeL32PKAN
         IJLlDWpPrRrvhyqpywaHHwU+1m63ApxIb8FHaTVgZ8naOKjIxmc1UZZuI6a/hyJm6eG+
         qTiw==
X-Gm-Message-State: AOAM5327R77LKc+RtocKDGjqHnhWbHGdkB450WDQRfkxv2P7M3fylbwA
        wNsvrAGPemwrv41SGW+C5449/g==
X-Google-Smtp-Source: ABdhPJy6Ezoo4W6okv8p87oIH7rEzQH9aygXBsxBxyyFfnnJlFvTzi2RoniKpWpIJ7wdbZmKjwwDWQ==
X-Received: by 2002:adf:f74b:0:b0:203:7515:3be4 with SMTP id z11-20020adff74b000000b0020375153be4mr3106263wrp.610.1646832054693;
        Wed, 09 Mar 2022 05:20:54 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id r187-20020a1c44c4000000b0038377fb18f8sm2606152wma.5.2022.03.09.05.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 05:20:54 -0800 (PST)
Date:   Wed, 9 Mar 2022 13:20:52 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v9 2/3] aarch64: Add stolen time support
Message-ID: <YiiptPk6hkeGqqXk@google.com>
References: <20220308153227.2238533-1-sebastianene@google.com>
 <20220308153227.2238533-3-sebastianene@google.com>
 <YiilEbM1wVPsH7vB@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiilEbM1wVPsH7vB@monolith.localdoman>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 01:02:54PM +0000, Alexandru Elisei wrote:
> Hi,
>

Hi,

> On Tue, Mar 08, 2022 at 03:32:29PM +0000, Sebastian Ene wrote:
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
> > index 0000000..a45f0ea
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
> > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> 
> As far as I can tell, that should be the attr field, not addr. It has been
> been working so far because attr will be set to 0 by the initializer and
> KVM_ARM_VCPU_PVTIME_IPA is defined as 0 by the kernel API.
> 

Ack, good catch ! I will update this to use the 'attr' field.

> Thanks,
> Alex

Cheers,
Sebastian 
> 
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
> > 2.35.1.616.g0bdcbb4464-goog
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
