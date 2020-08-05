Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660FA23CEC5
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgHETEJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Aug 2020 15:04:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:38938 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgHETDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 15:03:31 -0400
IronPort-SDR: Bjr0eIBEThAAu5Pa0JaT/CbbgMMwnPs0CnH9UwSvZopieoKLfOhX2fiHleWlDGJwoImBN1sxBJ
 t3YbOaJwvnTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="150096648"
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="150096648"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 12:02:36 -0700
IronPort-SDR: kOtcuMG4gMNIrsxRtpbD/fpRoVv/3BIlO6dAqrNrVpZQd0S6BdorrqFLwriXDE1FgTBhlMPwyU
 oG4b/XX9ymPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="332937302"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 05 Aug 2020 12:02:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 12:02:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 12:02:35 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Wed, 5 Aug 2020 12:02:35 -0700
From:   "Dey, Megha" <megha.dey@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>
CC:     "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
Thread-Topic: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
Thread-Index: AQHWX3hgPPNI1mxfxEuTvl+wlEh0s6kUiEyAgBVtKUA=
Date:   Wed, 5 Aug 2020 19:02:35 +0000
Message-ID: <ec81670539674beea58c9a6c4104b26b@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
 <87lfjbz3cs.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87lfjbz3cs.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Wednesday, July 22, 2020 1:45 PM
> To: Jiang, Dave <dave.jiang@intel.com>; vkoul@kernel.org; Dey, Megha
> <megha.dey@intel.com>; maz@kernel.org; bhelgaas@google.com;
> rafael@kernel.org; gregkh@linuxfoundation.org; hpa@zytor.com;
> alex.williamson@redhat.com; Pan, Jacob jun <jacob.jun.pan@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>; jgg@mellanox.com; Liu, Yi L <yi.l.liu@intel.com>;
> Lu, Baolu <baolu.lu@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Kumar,
> Sanjay K <sanjay.k.kumar@intel.com>; Luck, Tony <tony.luck@intel.com>; Lin,
> Jing <jing.lin@intel.com>; Williams, Dan J <dan.j.williams@intel.com>;
> kwankhede@nvidia.com; eric.auger@redhat.com; parav@mellanox.com;
> jgg@mellanox.com; rafael@kernel.org; Hansen, Dave
> <dave.hansen@intel.com>; netanelg@mellanox.com; shahafs@mellanox.com;
> yan.y.zhao@linux.intel.com; pbonzini@redhat.com; Ortiz, Samuel
> <samuel.ortiz@intel.com>; Hossain, Mona <mona.hossain@intel.com>
> Cc: dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org;
> x86@kernel.org; linux-pci@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
> 
> Dave Jiang <dave.jiang@intel.com> writes:
> > From: Megha Dey <megha.dey@intel.com>
> >
> > When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
> > base DEV-MSI irq  domain. If interrupt remapping is enabled, we create
> 
> s/we//

ok
> 
> > a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
> > the same.
> >
> > For X86, introduce a new irq_alloc_type which will be used by the
> > interrupt remapping driver.
> >
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Megha Dey <megha.dey@intel.com>
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  arch/x86/include/asm/hw_irq.h       |    1 +
> >  arch/x86/kernel/apic/msi.c          |   12 ++++++
> >  drivers/base/dev-msi.c              |   66 +++++++++++++++++++++++++++++++----
> >  drivers/iommu/intel/irq_remapping.c |   11 +++++-
> >  include/linux/intel-iommu.h         |    1 +
> >  include/linux/irqdomain.h           |   11 ++++++
> >  include/linux/msi.h                 |    3 ++
> 
> Why is this mixing generic code, x86 core code and intel specific driver code?
> This is new functionality so:
> 
>       1) Provide the infrastructure
>       2) Add support to architecture specific parts
>       3) Enable it

Ok, I will try to adhere to the layering next time around..
> 
> > +
> > +#ifdef CONFIG_DEV_MSI
> > +int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
> > +			   int nvec, msi_alloc_info_t *arg) {
> > +	memset(arg, 0, sizeof(*arg));
> > +
> > +	arg->type = X86_IRQ_ALLOC_TYPE_DEV_MSI;
> > +
> > +	return 0;
> > +}
> > +#endif
> 
> What is this? Tons of new lines for taking up more space and not a single
> comment.

Hmm, I will add a comment..
> 
> > -static int dev_msi_prepare(struct irq_domain *domain, struct device
> > *dev,
> > +int __weak dev_msi_prepare(struct irq_domain *domain, struct device
> > +*dev,
> >  			   int nvec, msi_alloc_info_t *arg)  {
> >  	memset(arg, 0, sizeof(*arg));
> 
> Oh well. So every architecure which needs to override this and I assume all
> which are eventually going to support it need to do the memset() in their
> override.
> 
>        memset(arg,,,);
>        arch_dev_msi_prepare();
> 
> 
Per you suggestion, I have introduced arch_dev_msi_prepare which returns 0 by default unless
overridden by arch code in the next patch set.

> > -	dev_msi_default_domain = msi_create_irq_domain(fn,
> &dev_msi_domain_info, parent);
> > +	/*
> > +	 * This initcall may come after remap code is initialized. Ensure that
> > +	 * dev_msi_default domain is updated correctly.
> 
> What? No, this is a disgusting hack. Get your ordering straight, that's not rocket
> science.
> 

Hmm yeah, actually I realized we don't really need to have 2 new IRQ domains for dev-msi 
(with and without interrupt remapping enabled). Hence all this will go away in the next round
of patches.

> > +#ifdef CONFIG_IRQ_REMAP
> 
> IRQ_REMAP is x86 specific. Is this file x86 only or intended to be for general use?
> If it's x86 only, then this should be clearly documented. If not, then these
> x86'isms have no place here.

True, I will take care of this in the next patch set.
> 
> > +struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain
> *parent,
> > +						   const char *name)
> 
> So we have msi_create_irq_domain() and this is about dev_msi, right? So can
> you please stick with a consistent naming scheme?

sure
> 
> > +{
> > +	struct fwnode_handle *fn;
> > +	struct irq_domain *domain;
> > +
> > +	fn = irq_domain_alloc_named_fwnode(name);
> > +	if (!fn)
> > +		return NULL;
> > +
> > +	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info,
> parent);
> > +	if (!domain) {
> > +		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
> > +		return ERR_PTR(-ENXIO);
> > +	}
> > +
> > +	irq_domain_update_bus_token(domain,
> DOMAIN_BUS_PLATFORM_MSI);
> > +
> > +	if (!dev_msi_default_domain)
> > +		dev_msi_default_domain = domain;
> 
> Can this be called several times? If so, then this lacks a comment. If not, then
> this condition is useless.

Hmm this will go way in the next patch set, thank you for your input!
> 
> Thanks,
> 
>         tglx
