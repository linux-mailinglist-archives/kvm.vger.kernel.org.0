Return-Path: <kvm+bounces-44580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 802CFA9F3F6
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD9D3BE5D6
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5995A27979E;
	Mon, 28 Apr 2025 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQp2+ZJW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785BE27978B;
	Mon, 28 Apr 2025 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745852425; cv=none; b=KOVEeCPTmvT1URdboh+/pE8VEFuIlCfTooomzl3YXjXcAXFvEVn0b+SM0HSX6zJH8f16R0GWiU6OM8bqkifUju9vf6VatZFtv7kyyq7zOaEowoHTiwHRwadVGv1MdbUQeSAJ6XURAGplJhU6XpkTX9sI5tg3l2Ju/ijg6BSrpNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745852425; c=relaxed/simple;
	bh=WAq2iabc990w1Qi0DDPIDDUC0WKvIFPY3pDowPsJQMw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=M936+de9gPc04iik+hjqzUQ2iIPrXzOJXfDZFjfV0qHDt4vcC9ds1pAdWEZPKpPPcm2fPZDExY0D5FMNsCfrNmY0A9lB14YPipjJuAMdklR4z8rKG2M6KVK1nO8kPstMNF3E2k/5HEyRaFDYs/ArEyFaeoovsJYPv+/vbYddUnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQp2+ZJW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62DAC4CEE4;
	Mon, 28 Apr 2025 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745852424;
	bh=WAq2iabc990w1Qi0DDPIDDUC0WKvIFPY3pDowPsJQMw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=kQp2+ZJW/+MDSHEWo+O6QFPsCfeB+qokVPiGOpZMvh+VJXhZ+Ml7rl8WqSIRJEgOz
	 c5OivtOlJYD22hJ8yegza6zImUfXt7BlKNF/ChKHnYY/gNXfeyUXtVauvsq0NgWUIR
	 2IZCVxl8WwgSBo0YkNbmlf1sQvV56/6CwSkz59keS/SHojIOwwZghrmtlPtrf24l6D
	 BlXjnL+2CSPuVOlkqHnwdSE4eRMX9D0g1xr/Ub1WPr3UdrFw0UNFRM4h7TjBaEV7Oq
	 NOr/kjzSdWzE65uCYubv4jeVfiFi3f4+kSSyniqm7SoMXVkY1vRQq3d4lqUVhklag+
	 sK/zOLkNRiNNw==
Date: Mon, 28 Apr 2025 10:00:23 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Cc: kvm@vger.kernel.org, Chathura Rajapaksha <chath@bu.edu>,
	William Wang <xwill@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
	Xin Zeng <xin.zeng@intel.com>, Yahui Cao <yahui.cao@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Avihai Horon <avihaih@nvidia.com>, linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] block accesses to unassigned PCI config regions
Message-ID: <20250428150023.GA670069@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426212253.40473-2-chath@bu.edu>

Hint: observe subject line conventions for the file you're changing.
See "git log --oneline drivers/vfio/pci/vfio_pci_config.c".

On Sat, Apr 26, 2025 at 09:22:48PM +0000, Chathura Rajapaksha wrote:
> Some PCIe devices trigger PCI bus errors when accesses are made to
> unassigned regions within their PCI configuration space. On certain
> platforms, this can lead to host system hangs or reboots.

1) Define "unassigned regions".  From the patch, I infer that the
64-byte header, capabilities, and extended capabilities are considered
"assigned," and anything else would be "unassigned."

2) Can you expand on what these certain platforms are and the details
of what these errors are and how they're reported?  You mention
"PCIe," but I suppose this is not really PCIe-specific.  I suppose the
hang or reboot would be a consequence of the error being reported as
SERR# or a platform-specific System Error (PCIe r6.0, sec 6.2.6)?

In conventional PCI, we may not have control over SERR# assertion and
the effect on the system.  In PCIe, bits in the Root Control register
should control SERR# assertion.

> The current vfio-pci driver allows guests to access unassigned regions
> in the PCI configuration space. Therefore, when such a device is passed
> through to a guest, the guest can induce a host system hang or reboot
> through crafted configuration space accesses, posing a threat to
> system availability.
> 
> This patch introduces support for blocking guest accesses to unassigned
> PCI configuration space, and the ability to bypass this access control
> for specific devices. The patch introduces three module parameters:

We already know which patch this refers to (so "this patch" is
unnecessary) and typical style is to use imperative mood:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=v6.14#n94

>    block_pci_unassigned_write:
>    Blocks write accesses to unassigned config space regions.
> 
>    block_pci_unassigned_read:
>    Blocks read accesses to unassigned config space regions.
> 
>    uaccess_allow_ids:
>    Specifies the devices for which the above access control is bypassed.
>    The value is a comma-separated list of device IDs in
>    <vendor_id>:<device_id> format.
> 
>    Example usage:
>    To block guest write accesses to unassigned config regions for all
>    passed through devices except for the device with vendor ID 0x1234 and
>    device ID 0x5678:
> 
>    block_pci_unassigned_write=1 uaccess_allow_ids=1234:5678
> 
> Co-developed by: William Wang <xwill@bu.edu>
> Signed-off-by: William Wang <xwill@bu.edu>
> Signed-off-by: Chathura Rajapaksha <chath@bu.edu>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 122 ++++++++++++++++++++++++++++-
>  1 file changed, 121 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 8f02f236b5b4..cb4d11aa5598 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -120,6 +120,106 @@ struct perm_bits {
>  #define	NO_WRITE	0
>  #define	ALL_WRITE	0xFFFFFFFFU
>  
> +static bool block_pci_unassigned_write;
> +module_param(block_pci_unassigned_write, bool, 0644);
> +MODULE_PARM_DESC(block_pci_unassigned_write,
> +		 "Block write accesses to unassigned PCI config regions.");
> +
> +static bool block_pci_unassigned_read;
> +module_param(block_pci_unassigned_read, bool, 0644);
> +MODULE_PARM_DESC(block_pci_unassigned_read,
> +		 "Block read accesses from unassigned PCI config regions.");
> +
> +static char *uaccess_allow_ids;
> +module_param(uaccess_allow_ids, charp, 0444);
> +MODULE_PARM_DESC(uaccess_allow_ids, "PCI IDs to allow access to unassigned PCI config regions, format is \"vendor:device\" and multiple comma separated entries can be specified");
> +
> +static LIST_HEAD(allowed_device_ids);
> +static DEFINE_SPINLOCK(device_ids_lock);
> +
> +struct uaccess_device_id {
> +	struct list_head slot_list;
> +	unsigned short vendor;
> +	unsigned short device;
> +};
> +
> +static void pci_uaccess_add_device(struct uaccess_device_id *new,
> +				   int vendor, int device)
> +{
> +	struct uaccess_device_id *pci_dev_id;
> +	unsigned long flags;
> +	int found = 0;
> +
> +	spin_lock_irqsave(&device_ids_lock, flags);
> +
> +	list_for_each_entry(pci_dev_id, &allowed_device_ids, slot_list) {
> +		if (pci_dev_id->vendor == vendor &&
> +		    pci_dev_id->device == device) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		new->vendor = vendor;
> +		new->device = device;
> +		list_add_tail(&new->slot_list, &allowed_device_ids);
> +	}
> +
> +	spin_unlock_irqrestore(&device_ids_lock, flags);
> +
> +	if (found)
> +		kfree(new);
> +}
> +
> +static bool pci_uaccess_lookup(struct pci_dev *dev)
> +{
> +	struct uaccess_device_id *pdev_id;
> +	unsigned long flags;
> +	bool found = false;
> +
> +	spin_lock_irqsave(&device_ids_lock, flags);
> +	list_for_each_entry(pdev_id, &allowed_device_ids, slot_list) {
> +		if (pdev_id->vendor == dev->vendor &&
> +		    pdev_id->device == dev->device) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&device_ids_lock, flags);
> +
> +	return found;
> +}
> +
> +static int __init pci_uaccess_init(void)
> +{
> +	char *p, *id;
> +	int fields;
> +	int vendor, device;
> +	struct uaccess_device_id *pci_dev_id;
> +
> +	/* add ids specified in the module parameter */
> +	p = uaccess_allow_ids;
> +	while ((id = strsep(&p, ","))) {
> +		if (!strlen(id))
> +			continue;
> +
> +		fields = sscanf(id, "%x:%x", &vendor, &device);
> +
> +		if (fields != 2) {
> +			pr_warn("Invalid id string \"%s\"\n", id);
> +			continue;
> +		}
> +
> +		pci_dev_id = kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
> +		if (!pci_dev_id)
> +			return -ENOMEM;
> +
> +		pci_uaccess_add_device(pci_dev_id, vendor, device);
> +	}
> +	return 0;
> +}
> +
>  static int vfio_user_config_read(struct pci_dev *pdev, int offset,
>  				 __le32 *val, int count)
>  {
> @@ -335,6 +435,18 @@ static struct perm_bits unassigned_perms = {
>  	.writefn = vfio_raw_config_write
>  };
>  
> +/*
> + * Read/write access to PCI unassigned config regions can be blocked
> + * using the block_pci_unassigned_read and block_pci_unassigned_write
> + * module parameters. The uaccess_allow_ids module parameter can be used
> + * to whitelist devices (i.e., bypass the block) when either of the
> + * above parameters is specified.
> + */
> +static struct perm_bits block_unassigned_perms = {
> +	.readfn = NULL,
> +	.writefn = NULL
> +};
> +
>  static struct perm_bits virt_perms = {
>  	.readfn = vfio_virt_config_read,
>  	.writefn = vfio_virt_config_write
> @@ -1108,6 +1220,9 @@ int __init vfio_pci_init_perm_bits(void)
>  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
>  	ecap_perms[PCI_EXT_CAP_ID_DVSEC].writefn = vfio_raw_config_write;
>  
> +	/* Device list allowed to access unassigned PCI regions */
> +	ret |= pci_uaccess_init();
> +
>  	if (ret)
>  		vfio_pci_uninit_perm_bits();
>  
> @@ -1896,7 +2011,12 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  	cap_id = vdev->pci_config_map[*ppos];
>  
>  	if (cap_id == PCI_CAP_ID_INVALID) {
> -		perm = &unassigned_perms;
> +		if (((iswrite && block_pci_unassigned_write) ||
> +		     (!iswrite && block_pci_unassigned_read)) &&
> +		    !pci_uaccess_lookup(pdev))
> +			perm = &block_unassigned_perms;
> +		else
> +			perm = &unassigned_perms;
>  		cap_start = *ppos;
>  	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
>  		perm = &virt_perms;
> -- 
> 2.34.1
> 

