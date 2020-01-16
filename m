Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6713D9C8
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgAPMTN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Jan 2020 07:19:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:8848 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgAPMTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 07:19:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 04:19:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="214058940"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 16 Jan 2020 04:19:11 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:19:11 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:19:11 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.203]) with mapi id 14.03.0439.000;
 Thu, 16 Jan 2020 20:19:09 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH v4 01/12] vfio_pci: refine user config reference in
 vfio-pci module
Thread-Topic: [PATCH v4 01/12] vfio_pci: refine user config reference in
 vfio-pci module
Thread-Index: AQHVxVTyyvu6iY3Kg0i4TKhKInVOI6fibQKAgArSApA=
Date:   Thu, 16 Jan 2020 12:19:09 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A183E28@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-2-git-send-email-yi.l.liu@intel.com>
 <20200109154821.047f700a@w520.home>
In-Reply-To: <20200109154821.047f700a@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDE3ZmUyYzMtNzhjMS00MWUyLTkyMGYtYzg5NjU0MTY1MzZlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoid041UGNSSGYwZXpIOVNtazV2dDErQnZuTGtCQldiU3BwNzB5ZTNudjNLM1BFbU1tTlZDbmFTdjBrNDZDRWRHWSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, January 10, 2020 6:48 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v4 01/12] vfio_pci: refine user config reference in vfio-pci
> module
> 
> On Tue,  7 Jan 2020 20:01:38 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch adds three fields in struct vfio_pci_device to pass the user
> > configurations of vfio-pci.ko module to some functions which could be
> > common in future usage. The values stored in struct vfio_pci_device will
> > be initiated in probe and refreshed in device open phase to allow runtime
> > modifications to parameters. e.g. disable_idle_d3 and nointxmask.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 37 ++++++++++++++++++++++++++-----------
> >  drivers/vfio/pci/vfio_pci_private.h |  8 ++++++++
> >  2 files changed, 34 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 379a02c..af507c2 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -54,10 +54,10 @@ module_param(disable_idle_d3, bool, S_IRUGO |
> S_IWUSR);
> >  MODULE_PARM_DESC(disable_idle_d3,
> >  		 "Disable using the PCI D3 low power state for idle, unused devices");
> >
> > -static inline bool vfio_vga_disabled(void)
> > +static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
> >  {
> >  #ifdef CONFIG_VFIO_PCI_VGA
> > -	return disable_vga;
> > +	return vdev->disable_vga;
> >  #else
> >  	return true;
> >  #endif
> > @@ -78,7 +78,8 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque,
> bool single_vga)
> >  	unsigned char max_busnr;
> >  	unsigned int decodes;
> >
> > -	if (single_vga || !vfio_vga_disabled() || pci_is_root_bus(pdev->bus))
> > +	if (single_vga || !vfio_vga_disabled(vdev) ||
> > +		pci_is_root_bus(pdev->bus))
> >  		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> >  		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
> >
> > @@ -289,7 +290,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
> >  	if (!vdev->pci_saved_state)
> >  		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
> >
> > -	if (likely(!nointxmask)) {
> > +	if (likely(!vdev->nointxmask)) {
> >  		if (vfio_pci_nointx(pdev)) {
> >  			pci_info(pdev, "Masking broken INTx support\n");
> >  			vdev->nointx = true;
> > @@ -326,7 +327,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
> >  	} else
> >  		vdev->msix_bar = 0xFF;
> >
> > -	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
> > +	if (!vfio_vga_disabled(vdev) && vfio_pci_is_vga(pdev))
> >  		vdev->has_vga = true;
> >
> >
> > @@ -462,10 +463,17 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
> >
> >  	vfio_pci_try_bus_reset(vdev);
> >
> > -	if (!disable_idle_d3)
> > +	if (!vdev->disable_idle_d3)
> >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> >  }
> >
> > +void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
> > +			bool nointxmask, bool disable_idle_d3)
> > +{
> > +	vdev->nointxmask = nointxmask;
> > +	vdev->disable_idle_d3 = disable_idle_d3;
> 
> These two are selected (not disable_vga) because they're the only
> writable module options, correct?

yep. These were selected per previous review comments from
you. I also checked in the code, the existing 4 module options
are clarified as below, and I can see only nointxmask and disable_idle_d3
are writable. I guess this should be the evidence for selecting the
modules options to be refreshed in vfio_pci_refresh_config().

static char ids[1024] __initdata;
module_param_string(ids, ids, sizeof(ids), 0);

static bool nointxmask;
module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);

static bool disable_vga;
module_param(disable_vga, bool, S_IRUGO);

static bool disable_idle_d3;
module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);

> 
> > +}
> > +
> >  static void vfio_pci_release(void *device_data)
> >  {
> >  	struct vfio_pci_device *vdev = device_data;
> > @@ -490,6 +498,8 @@ static int vfio_pci_open(void *device_data)
> >  	if (!try_module_get(THIS_MODULE))
> >  		return -ENODEV;
> >
> > +	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
> > +
> >  	mutex_lock(&vdev->reflck->lock);
> >
> >  	if (!vdev->refcnt) {
> > @@ -1330,6 +1340,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
> >  	spin_lock_init(&vdev->irqlock);
> >  	mutex_init(&vdev->ioeventfds_lock);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> > +	vdev->nointxmask = nointxmask;
> > +#ifdef CONFIG_VFIO_PCI_VGA
> > +	vdev->disable_vga = disable_vga;
> > +#endif
> > +	vdev->disable_idle_d3 = disable_idle_d3;
> 
> But this could still use vfio_pci_refresh_config() for those writable
> options and set disable_vga separately, couldn't it? 

Right, would modify it. thanks.

> Also, since
> disable_idle_d3 is related to power handling of the device while it is
> not opened by the user, shouldn't the config also be refreshed when the
> device is released by the user?

Oh, yes. You told me to do it. But I assumed that we only care
about the config used during an open() and a release() circle.
I missed it will affect the power management. Let me add the
config refresh at release() all the same. Thanks.

> 
> >
> >  	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> >  	if (ret) {
> > @@ -1354,7 +1369,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
> >
> >  	vfio_pci_probe_power_state(vdev);
> >
> > -	if (!disable_idle_d3) {
> > +	if (!vdev->disable_idle_d3) {
> >  		/*
> >  		 * pci-core sets the device power state to an unknown value at
> >  		 * bootup and after being removed from a driver.  The only
> > @@ -1385,7 +1400,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
> >  	kfree(vdev->region);
> >  	mutex_destroy(&vdev->ioeventfds_lock);
> >
> > -	if (!disable_idle_d3)
> > +	if (!vdev->disable_idle_d3)
> >  		vfio_pci_set_power_state(vdev, PCI_D0);
> >
> >  	kfree(vdev->pm_save);
> > @@ -1620,7 +1635,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device
> *vdev)
> >  		if (!ret) {
> >  			tmp->needs_reset = false;
> >
> > -			if (tmp != vdev && !disable_idle_d3)
> > +			if (tmp != vdev && !tmp->disable_idle_d3)
> >  				vfio_pci_set_power_state(tmp, PCI_D3hot);
> >  		}
> >
> > @@ -1636,7 +1651,7 @@ static void __exit vfio_pci_cleanup(void)
> >  	vfio_pci_uninit_perm_bits();
> >  }
> >
> > -static void __init vfio_pci_fill_ids(void)
> > +static void __init vfio_pci_fill_ids(char *ids)
> 
> This might be more clear if the global was also renamed vfio_pci_ids.

Yep. Let me rename it later.

> >  {
> >  	char *p, *id;
> >  	int rc;
> > @@ -1691,7 +1706,7 @@ static int __init vfio_pci_init(void)
> >  	if (ret)
> >  		goto out_driver;
> >
> > -	vfio_pci_fill_ids();
> > +	vfio_pci_fill_ids(ids);
> >
> >  	return 0;
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> > index 8a2c760..0398608 100644
> > --- a/drivers/vfio/pci/vfio_pci_private.h
> > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > @@ -122,6 +122,11 @@ struct vfio_pci_device {
> >  	struct list_head	dummy_resources_list;
> >  	struct mutex		ioeventfds_lock;
> >  	struct list_head	ioeventfds_list;
> > +	bool			nointxmask;
> > +#ifdef CONFIG_VFIO_PCI_VGA
> > +	bool			disable_vga;
> > +#endif
> > +	bool			disable_idle_d3;
> 
> It seems like there are more relevant places these could be within this
> structure, ex. nointxmask next to nointx, disable_vga near has_vga,
> disable_idle_d3 maybe near needs_pm_restore (even though those aren't
> conceptually related).  Not necessarily related to this series, it
> might be time to convert the existing bools to bit fields, but even
> before that the alignment of adding these as bools grouped with the
> existing bools is probably better.  Thanks,

Agreed. Will place the new bools at better place (with proper neighbors:-))

> Alex

Thanks,
Yi Liu

> 
> >  };
> >
> >  #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> > @@ -130,6 +135,9 @@ struct vfio_pci_device {
> >  #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
> >  #define irq_is(vdev, type) (vdev->irq_type == type)
> >
> > +extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
> > +				bool nointxmask, bool disable_idle_d3);
> > +
> >  extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
> >  extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
> >

