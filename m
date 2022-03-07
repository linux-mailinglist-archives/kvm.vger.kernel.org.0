Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA64D0227
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiCGO4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiCGO4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:56:03 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322A03F33E
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:55:09 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e24so10738600wrc.10
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 06:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RqvP7US5ABisfi2wPF47bzSvLDeEI3AwOXbI0hOn0c4=;
        b=k0uXWnT53hIPsNtjD8/1kr6WtkuPDiCvinEg1z5RqLIZpPznW11mCIxNqeuhMHH1EP
         t5ubRHIISuWqUPTTvCjjvy35RAAdm1K+5oymxN2z71NTNhW/hSAK3mEvTRzuWX7UubRk
         thU7rE+nbxg6glagU65oTeLUP9wDu/qgrsp6AgU+Clqq9WGNqUNr70OHLgFbmIdGELxz
         LnlfcKit5VVDosyQPtgrgJ4L0MdPL73aiIfF7M9Cz8FwX9Ao2lN8shDY5OewJCfwMPOf
         pgu8UuO8RxnlBsWe9yaMS20TeF/OgHckwhYOTpd5zBjtCG5icYSumIQLeLssC+Bj22cl
         EVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RqvP7US5ABisfi2wPF47bzSvLDeEI3AwOXbI0hOn0c4=;
        b=p0WLabG2eNhWuYUqnmPurndDZxqKq+pthN/L07TQtZ7JuL9f0xOsIp4JZ8LkwDSr4h
         FRGnZXFE9u5j+iF1UafA8cbM37y1neELUJiCiRXJdaec5H1eSaTH0Rh2nX3n7Gtr7ia5
         f+9jCBJq7zV/uIMb0Pvo4ipWMfv3PIDNthq+s0bBvNb8VLSFLE/Inhn/4pBXBvX5myC+
         V/LrGesaXGk4My4LzjnnDhj0L+wn2Ch9GQb+LdlLHPl3WwlFhGz4E2oLzhG56WJSOEb+
         oYYOgWFt3ntzcNnzAVIh2r/7MmzZ43wVYIyQGG8iyo/rso9ackdKZPvrupc5N4WaDq1P
         wMBA==
X-Gm-Message-State: AOAM533GyfIDgbnRLWyBDJXOrd0NPlt1MZ2imOAmAFJQxHdbwqJoKdjW
        Jx2vQNrWJOt7/PiO/KhDrbzjQXN6NVuovUvl
X-Google-Smtp-Source: ABdhPJwZez8SBtnP781b7Xi2vNlCK6tgEWnZ0dt0gNC/ShwEbczjUN8EjWDdsgY5/c2+mdWnErELHQ==
X-Received: by 2002:a5d:44d2:0:b0:1f0:247d:8cf7 with SMTP id z18-20020a5d44d2000000b001f0247d8cf7mr8160627wrr.475.1646664907618;
        Mon, 07 Mar 2022 06:55:07 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600c1d1000b003816edb5711sm20649970wms.26.2022.03.07.06.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:55:07 -0800 (PST)
Date:   Mon, 7 Mar 2022 14:55:05 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v7 2/3] aarch64: Add stolen time support
Message-ID: <YiYcyUbSjZMYocsx@google.com>
References: <20220302140734.1015958-1-sebastianene@google.com>
 <20220302140734.1015958-3-sebastianene@google.com>
 <YiXwgY/n4Y3W4XAi@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiXwgY/n4Y3W4XAi@monolith.localdoman>
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

On Mon, Mar 07, 2022 at 11:46:09AM +0000, Alexandru Elisei wrote:
> Hi,
>

Hi,

> On Wed, Mar 02, 2022 at 02:07:35PM +0000, Sebastian Ene wrote:
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
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -errno;
> > +
> > +	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +				    ARM_PVTIME_MMIO_SIZE, mem);
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
> 
> This looks awkward: pvtime initialization is done in kvm_cpu__arch_init(), but
> teardown is done in the device exit stage.
> 
> I think it would be better to choose one approach and stick with it: (1) keep
> initialization in kvm_cpu__arch_init() and move teardown to kvm_cpu__delete();
> or (2) treat pvtime as a device, move the code to hw/pvtime.c, compile the file
> only for arm64 and move initialization to dev_init() (and keep teardown in
> dev_exit()).
> 
> I have no preference for either, but I think a consistent approach to enabling
> pvtime is desirable.
>

Thanks for the feedback, I will take the first approach as 'pvtime'
is not really a device. I did this as part of patch v8.


Thanks,
Sebastian

> Thanks,
> Alex
