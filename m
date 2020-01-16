Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F5413DA37
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAPMmr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Jan 2020 07:42:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:13165 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgAPMmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 07:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 04:42:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="219670957"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jan 2020 04:42:46 -0800
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:42:45 -0800
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:42:45 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.28]) with mapi id 14.03.0439.000;
 Thu, 16 Jan 2020 20:42:43 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH v4 07/12] vfio_pci: shrink vfio_pci.c
Thread-Topic: [PATCH v4 07/12] vfio_pci: shrink vfio_pci.c
Thread-Index: AQHVxVT47BVKVR+h0EemyJ2mRHEtmafibQgAgArasfA=
Date:   Thu, 16 Jan 2020 12:42:42 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A183EF9@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-8-git-send-email-yi.l.liu@intel.com>
 <20200109154826.7a818be8@w520.home>
In-Reply-To: <20200109154826.7a818be8@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODhmYWYzOTgtMzVkYy00MmUyLTlhZDYtM2YyZWMyZjIxMzlmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUXFYVUFIdWtPOFIxOG9hVXBGXC9PMkI2UnZXZnFyU0FzelhiUUcyQnc0TFFmYW00SjA2Umc1V0YzWGlrMVRhUEMifQ==
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
> Subject: Re: [PATCH v4 07/12] vfio_pci: shrink vfio_pci.c
> 
> On Tue,  7 Jan 2020 20:01:44 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch removes the common codes in vfio_pci.c, leave the module
> > specific codes, new vfio_pci.c will leverage the common functions
> > implemented in vfio_pci_common.c.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/Makefile           |    3 +-
> >  drivers/vfio/pci/vfio_pci.c         | 1442 -----------------------------------
> >  drivers/vfio/pci/vfio_pci_common.c  |    2 +-
> >  drivers/vfio/pci/vfio_pci_private.h |    2 +
> >  4 files changed, 5 insertions(+), 1444 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > index f027f8a..d94317a 100644
> > --- a/drivers/vfio/pci/Makefile
> > +++ b/drivers/vfio/pci/Makefile
> > @@ -1,6 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >
> > -vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
> > +vfio-pci-y := vfio_pci.o vfio_pci_common.o vfio_pci_intrs.o \
> > +		vfio_pci_rdwr.o vfio_pci_config.o
> >  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> >  vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 103e493..7e24da2 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> 
> I think there are a bunch of headers that are no longer needed here
> too.  It at least compiles without these:
> 
> -#include <linux/eventfd.h>
> -#include <linux/file.h>
> -#include <linux/interrupt.h>
> -#include <linux/notifier.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/uaccess.h>
> -#include <linux/nospec.h>

Got it, let me remove them.

> 
> 
> > @@ -54,411 +54,6 @@ module_param(disable_idle_d3, bool, S_IRUGO |
> S_IWUSR);
> >  MODULE_PARM_DESC(disable_idle_d3,
> >  		 "Disable using the PCI D3 low power state for idle, unused devices");
> >
> > -/*
> > - * Our VGA arbiter participation is limited since we don't know anything
> > - * about the device itself.  However, if the device is the only VGA device
> > - * downstream of a bridge and VFIO VGA support is disabled, then we can
> > - * safely return legacy VGA IO and memory as not decoded since the user
> > - * has no way to get to it and routing can be disabled externally at the
> > - * bridge.
> > - */
> > -unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
> > -{
> > -	struct vfio_pci_device *vdev = opaque;
> > -	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
> > -	unsigned char max_busnr;
> > -	unsigned int decodes;
> > -
> > -	if (single_vga || !vfio_vga_disabled(vdev) ||
> > -		pci_is_root_bus(pdev->bus))
> > -		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> > -		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
> > -
> > -	max_busnr = pci_bus_max_busnr(pdev->bus);
> > -	decodes = VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
> > -
> > -	while ((tmp = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, tmp)) != NULL) {
> > -		if (tmp == pdev ||
> > -		    pci_domain_nr(tmp->bus) != pci_domain_nr(pdev->bus) ||
> > -		    pci_is_root_bus(tmp->bus))
> > -			continue;
> > -
> > -		if (tmp->bus->number >= pdev->bus->number &&
> > -		    tmp->bus->number <= max_busnr) {
> > -			pci_dev_put(tmp);
> > -			decodes |= VGA_RSRC_LEGACY_IO |
> VGA_RSRC_LEGACY_MEM;
> > -			break;
> > -		}
> > -	}
> > -
> > -	return decodes;
> > -}
> > -
> > -static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
> > -{
> > -	struct resource *res;
> > -	int i;
> > -	struct vfio_pci_dummy_resource *dummy_res;
> > -
> > -	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> > -
> > -	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> > -		int bar = i + PCI_STD_RESOURCES;
> > -
> > -		res = &vdev->pdev->resource[bar];
> > -
> > -		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> > -			goto no_mmap;
> > -
> > -		if (!(res->flags & IORESOURCE_MEM))
> > -			goto no_mmap;
> > -
> > -		/*
> > -		 * The PCI core shouldn't set up a resource with a
> > -		 * type but zero size. But there may be bugs that
> > -		 * cause us to do that.
> > -		 */
> > -		if (!resource_size(res))
> > -			goto no_mmap;
> > -
> > -		if (resource_size(res) >= PAGE_SIZE) {
> > -			vdev->bar_mmap_supported[bar] = true;
> > -			continue;
> > -		}
> > -
> > -		if (!(res->start & ~PAGE_MASK)) {
> > -			/*
> > -			 * Add a dummy resource to reserve the remainder
> > -			 * of the exclusive page in case that hot-add
> > -			 * device's bar is assigned into it.
> > -			 */
> > -			dummy_res = kzalloc(sizeof(*dummy_res), GFP_KERNEL);
> > -			if (dummy_res == NULL)
> > -				goto no_mmap;
> > -
> > -			dummy_res->resource.name = "vfio sub-page reserved";
> > -			dummy_res->resource.start = res->end + 1;
> > -			dummy_res->resource.end = res->start + PAGE_SIZE - 1;
> > -			dummy_res->resource.flags = res->flags;
> > -			if (request_resource(res->parent,
> > -						&dummy_res->resource)) {
> > -				kfree(dummy_res);
> > -				goto no_mmap;
> > -			}
> > -			dummy_res->index = bar;
> > -			list_add(&dummy_res->res_next,
> > -					&vdev->dummy_resources_list);
> > -			vdev->bar_mmap_supported[bar] = true;
> > -			continue;
> > -		}
> > -		/*
> > -		 * Here we don't handle the case when the BAR is not page
> > -		 * aligned because we can't expect the BAR will be
> > -		 * assigned into the same location in a page in guest
> > -		 * when we passthrough the BAR. And it's hard to access
> > -		 * this BAR in userspace because we have no way to get
> > -		 * the BAR's location in a page.
> > -		 */
> > -no_mmap:
> > -		vdev->bar_mmap_supported[bar] = false;
> > -	}
> > -}
> > -
> > -static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
> > -
> > -/*
> > - * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> > - * _and_ the ability detect when the device is asserting INTx via PCI_STATUS.
> > - * If a device implements the former but not the latter we would typically
> > - * expect broken_intx_masking be set and require an exclusive interrupt.
> > - * However since we do have control of the device's ability to assert INTx,
> > - * we can instead pretend that the device does not implement INTx, virtualizing
> > - * the pin register to report zero and maintaining DisINTx set on the host.
> > - */
> > -static bool vfio_pci_nointx(struct pci_dev *pdev)
> > -{
> > -	switch (pdev->vendor) {
> > -	case PCI_VENDOR_ID_INTEL:
> > -		switch (pdev->device) {
> > -		/* All i40e (XL710/X710/XXV710) 10/20/25/40GbE NICs */
> > -		case 0x1572:
> > -		case 0x1574:
> > -		case 0x1580 ... 0x1581:
> > -		case 0x1583 ... 0x158b:
> > -		case 0x37d0 ... 0x37d2:
> > -			return true;
> > -		default:
> > -			return false;
> > -		}
> > -	}
> > -
> > -	return false;
> > -}
> > -
> > -void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
> > -{
> > -	struct pci_dev *pdev = vdev->pdev;
> > -	u16 pmcsr;
> > -
> > -	if (!pdev->pm_cap)
> > -		return;
> > -
> > -	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
> > -
> > -	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
> > -}
> > -
> > -/*
> > - * pci_set_power_state() wrapper handling devices which perform a soft reset on
> > - * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
> > - * restore when returned to D0.  Saved separately from pci_saved_state for use
> > - * by PM capability emulation and separately from pci_dev internal saved state
> > - * to avoid it being overwritten and consumed around other resets.
> > - */
> > -int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
> > -{
> > -	struct pci_dev *pdev = vdev->pdev;
> > -	bool needs_restore = false, needs_save = false;
> > -	int ret;
> > -
> > -	if (vdev->needs_pm_restore) {
> > -		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
> > -			pci_save_state(pdev);
> > -			needs_save = true;
> > -		}
> > -
> > -		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
> > -			needs_restore = true;
> > -	}
> > -
> > -	ret = pci_set_power_state(pdev, state);
> > -
> > -	if (!ret) {
> > -		/* D3 might be unsupported via quirk, skip unless in D3 */
> > -		if (needs_save && pdev->current_state >= PCI_D3hot) {
> > -			vdev->pm_save = pci_store_saved_state(pdev);
> > -		} else if (needs_restore) {
> > -			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
> > -			pci_restore_state(pdev);
> > -		}
> > -	}
> 
> 
> This gets a bit ugly, vfio_pci_remove() retains:
> 
> kfree(vdev->pm_save)
> 
> But vfio_pci.c otherwise has no use of this field on the
> vfio_pci_device.  I'm afraid we're really just doing a pretty rough
> splitting of the code rather than massaging the callbacks between the
> modules into an actual API, for example maybe there should be init and
> exit callbacks into the common code to handle such things.
> ioeventfds_{list,lock} are similar, vfio_pci.c inits and destroys them,
> but otherwise doesn't know what they're for.  I wonder how many more
> such things exist.  Thanks,

yeah, I tried to keep the code as what it looks like today. So it is
now much more like a code splitting). But I agree we need to make it
more thorough. I had been considering how to make the code work as
what you described here since I saw your comment last week. I may
need a more detailed investigation on it per your direction, and answer
your question better.

Thanks very much for your guidelines.

Regards,
Yi Liu

> 
> Alex

