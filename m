Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DD54D18E4
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 14:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiCHNP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 08:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiCHNPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 08:15:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C151192AD
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 05:14:28 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1452567wmp.5
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 05:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Lkh2loZkpGZaLBuOXa8rDZHGHlZAmyJp5dJ6fHcIaV8=;
        b=bmBCi0yv6gpJyAT676EfdpRo8TsN5BA9Cn2y9seebgdOqEEnbeKA6Lb1xXrL2mTSRX
         bzIhoYdNtQsHRVJxB/BUKGY2UA5Mpnn0QxxONtvNLKw6pybtOjXPhJvQJ/fKGVizfKI3
         gvkvBJVM+tOnYRnyWm5da7gWlM9q+B/sfRtbd0hoiByvWIFh/xgT269JS3me+S15hdur
         3EKbcWHNc/3lufiUry/+abR1xkSV9J3VbS+2hb7BR/sa8idkggP0BA26NhdRI3BkdYXi
         R0vhuTb2SPHFQl1oJ7+fXDHthVK35DjqtHcDHwWpQogGzEf5ESTqnOiOcu4ZO4LfS1S+
         /zJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Lkh2loZkpGZaLBuOXa8rDZHGHlZAmyJp5dJ6fHcIaV8=;
        b=OJvBSSKAVEsSQxdI9vlzxzQLELtDcEBe6EsXwwAv6ELnhsbWN6oOzuv8eqzIps/ifW
         jkJjT2EbTCovU/foGwlTVXtCafb19cNZ5QFdtl/XWI6eNbJ0KPqnEXjIqjmMKKFdAHAU
         C8N/MJKxT5mffiU+WUgrO68bm2G3MyFFfVBqozJ8GucsqjsGm2JRNc5CFLfIxH53r0gn
         xq5ek7TVJVOB/JNNMg+W8A27jna8MZof8o+QthNhOKJdSuHjiVeZIVGWRrEQbAw42139
         ju2XZrN/Mu73bxG4AS+gyCqcrnOX6eZhWl23DDKwDskEZlwAuzrpSTkBrSCYYMksDOXT
         ddJQ==
X-Gm-Message-State: AOAM532hcjHwwF+xuwC4pfw6oSM/8BoRNpk9w/MYR9Ea/wfa5jwIMZ/M
        R1TuCjxY0t93uKIRbRW4JAA4yA==
X-Google-Smtp-Source: ABdhPJwbH1x3I2fjChJUjN/5+qFHFWZDog1c79+WswirYY0HE8STyrN+r5XzivZ/TT4I2dJLJWCe3g==
X-Received: by 2002:a7b:cd15:0:b0:389:a4f0:c3ba with SMTP id f21-20020a7bcd15000000b00389a4f0c3bamr3540318wmj.119.1646745266916;
        Tue, 08 Mar 2022 05:14:26 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b00389cc36a3bfsm454951wmp.6.2022.03.08.05.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:14:26 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:14:25 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v8 2/3] aarch64: Add stolen time support
Message-ID: <YidWsYk9Mwklng+n@google.com>
References: <20220307144243.2039409-1-sebastianene@google.com>
 <20220307144243.2039409-3-sebastianene@google.com>
 <YiczmAGAIf0BYLNr@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiczmAGAIf0BYLNr@monolith.localdoman>
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

On Tue, Mar 08, 2022 at 10:44:40AM +0000, Alexandru Elisei wrote:
> Hi,

Hi,

> 
> On Mon, Mar 07, 2022 at 02:42:43PM +0000, Sebastian Ene wrote:
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
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |   2 +
> >  arm/aarch64/pvtime.c                   | 108 +++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |   6 +-
> >  arm/kvm-cpu.c                          |   1 +
> >  include/kvm/kvm-config.h               |   1 +
> >  7 files changed, 119 insertions(+), 2 deletions(-)
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
> > index 0000000..4db2e9f
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,108 @@
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
> > +	bool	is_failed_cfg;
> > +	void	*usr_mem;
> > +};
> > +
> > +static struct pvtime_data_priv pvtime_data = {
> > +	.is_failed_cfg	= true,
> > +	.usr_mem	= NULL
> > +};
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
> > +	pvtime_data.usr_mem = mem;
> > +	return ret;
> > +}
> > +
> > +static int pvtime__teardown_region(struct kvm *kvm)
> > +{
> > +	if (pvtime_data.usr_mem == NULL)
> > +		return 0;
> > +
> > +	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> > +			 ARM_PVTIME_BASE, pvtime_data.usr_mem);
> > +	munmap(pvtime_data.usr_mem, ARM_PVTIME_BASE);
> > +	pvtime_data.usr_mem = NULL;
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
> > +	};
> > +
> > +	kvm_cfg = &vcpu->kvm->cfg;
> > +	if (kvm_cfg->no_pvtime)
> > +		return 0;
> > +
> > +	if (!pvtime_data.is_failed_cfg)
> > +		return -ENOTSUP;
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
> > +	pvtime_data.is_failed_cfg = false;
> 
> kvm_cpu__init() calls kvm_cpu__arch_init()->kvm_cpu__setup_pvtime() for each
> VCPU from the main thread (so sequentually), not from the VCPU threads.  If this
> function returns an error, kvm_cpu__arch_init() calls die(), which means that
> kvmtool will terminate without calling kvm_cpu__setup_pvtime() for the other
> VCPUs.
> 
> What I'm trying to say is that the field is_failed_cfg is not useful, because if
> one VCPU fails initialization, then kvmtool will not attempt to initialize the
> rest of the VCPUs.
> 
> If you drop is_failed_cfg you can also drop the pvtime_data_priv struct and use
> a static user_mem variable (up to you).
> 

Got it, thanks I will do the cleanup by dropping those pieces.

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
> 
> This causes compilation for aarch32 to fail:
> 
> arm/kvm-cpu.c: In function ‘kvm_cpu__delete’:
> arm/kvm-cpu.c:147:2: error: implicit declaration of function ‘kvm_cpu__teardown_pvtime’ [-Werror=implicit-function-declaration]
>   147 |  kvm_cpu__teardown_pvtime(vcpu->kvm);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~
> arm/kvm-cpu.c:147:2: error: nested extern declaration of ‘kvm_cpu__teardown_pvtime’ [-Werror=nested-externs]
> cc1: all warnings being treated as errors
> make: *** [Makefile:482: arm/kvm-cpu.o] Error 1
> 
> The reason for that is that there is no stub for kvm_cpu__teardown_pvtime() for
> aarch32. This fixes the compilation error for me:
> 

I am afraid I didn't check on aarch32. Thanks for raising this issue, I
will fix the problem.

> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index 780e0e2f0934..ae77a136d0ce 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -19,5 +19,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
>  {
>         return 0;
>  }
> +static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> +{
> +       return 0;
> +}
> 
>  #endif /* KVM__KVM_CPU_ARCH_H */
> 
> Thanks,
> Alex
> 
> >  	free(vcpu);
> >  }

Thanks for the review,
Sebastian

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
