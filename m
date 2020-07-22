Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5291422A0DF
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgGVUo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVUoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:44:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BDCC0619DC;
        Wed, 22 Jul 2020 13:44:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595450693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wXmzNCf+SuxkNEeA2BGq+ls7ErUJp1r23WIHfZ6ytY8=;
        b=wyajGkXnsNJNOy+GEr2xcZ7WbqirfqC0K6s21soI7YoKiIB/oTL8lqbKiapU9N/5ohnvku
        D3d1K/LUt/HgfKgbGveYYjFG4S5Bbr61Udj8uCDDoq+B+pyjD4jgMs4OAMnAhKv+b4F9AL
        xqM2zl08ylbrd0wK5RkmFEjouB8bmOF/1auaFPOop6yG+LS9aLhzqU/DoYMsCf3R3jYBJR
        Gc6LB/4Te2ahHOIN3yOeBweEVBRa+9/1w7s/zqRYdz52xhOmBkI1IBDqBzjz4d3UUqUlHa
        ot6lQapK1TZPQLBiqI++zY71ic1K+dJbvu4RcMJMzYMejR35bRW5NcdS5vY46w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595450693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wXmzNCf+SuxkNEeA2BGq+ls7ErUJp1r23WIHfZ6ytY8=;
        b=xgKFFSG6c+aqvhtZbhIloJilsTGyEpYIJbC+QLyW5QnyNvEzVpja7KeGWisf5hs+2VAK2k
        FXupTA7ESov48+AQ==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        rafael@kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, dave.hansen@intel.com,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
In-Reply-To: <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com> <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
Date:   Wed, 22 Jul 2020 22:44:51 +0200
Message-ID: <87lfjbz3cs.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dave Jiang <dave.jiang@intel.com> writes:
> From: Megha Dey <megha.dey@intel.com>
>
> When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
> base DEV-MSI irq  domain. If interrupt remapping is enabled, we create

s/we//

> a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
> the same.
>
> For X86, introduce a new irq_alloc_type which will be used by the
> interrupt remapping driver.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  arch/x86/include/asm/hw_irq.h       |    1 +
>  arch/x86/kernel/apic/msi.c          |   12 ++++++
>  drivers/base/dev-msi.c              |   66 +++++++++++++++++++++++++++++++----
>  drivers/iommu/intel/irq_remapping.c |   11 +++++-
>  include/linux/intel-iommu.h         |    1 +
>  include/linux/irqdomain.h           |   11 ++++++
>  include/linux/msi.h                 |    3 ++

Why is this mixing generic code, x86 core code and intel specific driver
code? This is new functionality so:

      1) Provide the infrastructure
      2) Add support to architecture specific parts
      3) Enable it

> +
> +#ifdef CONFIG_DEV_MSI
> +int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
> +			   int nvec, msi_alloc_info_t *arg)
> +{
> +	memset(arg, 0, sizeof(*arg));
> +
> +	arg->type = X86_IRQ_ALLOC_TYPE_DEV_MSI;
> +
> +	return 0;
> +}
> +#endif

What is this? Tons of new lines for taking up more space and not a
single comment.

> -static int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
> +int __weak dev_msi_prepare(struct irq_domain *domain, struct device *dev,
>  			   int nvec, msi_alloc_info_t *arg)
>  {
>  	memset(arg, 0, sizeof(*arg));

Oh well. So every architecure which needs to override this and I assume
all which are eventually going to support it need to do the memset() in
their override.

       memset(arg,,,);
       arch_dev_msi_prepare();


> -	dev_msi_default_domain = msi_create_irq_domain(fn, &dev_msi_domain_info, parent);
> +	/*
> +	 * This initcall may come after remap code is initialized. Ensure that
> +	 * dev_msi_default domain is updated correctly.

What? No, this is a disgusting hack. Get your ordering straight, that's
not rocket science.

> +#ifdef CONFIG_IRQ_REMAP

IRQ_REMAP is x86 specific. Is this file x86 only or intended to be for
general use? If it's x86 only, then this should be clearly
documented. If not, then these x86'isms have no place here.

> +struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
> +						   const char *name)

So we have msi_create_irq_domain() and this is about dev_msi, right? So
can you please stick with a consistent naming scheme?

> +{
> +	struct fwnode_handle *fn;
> +	struct irq_domain *domain;
> +
> +	fn = irq_domain_alloc_named_fwnode(name);
> +	if (!fn)
> +		return NULL;
> +
> +	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info, parent);
> +	if (!domain) {
> +		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
> +
> +	if (!dev_msi_default_domain)
> +		dev_msi_default_domain = domain;

Can this be called several times? If so, then this lacks a comment. If
not, then this condition is useless.

Thanks,

        tglx
