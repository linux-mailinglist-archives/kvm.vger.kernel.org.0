Return-Path: <kvm+bounces-43366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1FA7A8A970
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 22:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A274E17EE64
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 20:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD62D25524A;
	Tue, 15 Apr 2025 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAvNMSTm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C610D148832;
	Tue, 15 Apr 2025 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744749571; cv=none; b=UbrmuNdbrpoMrIF17EKpomd9lbQsOVfiMdnp/BCSKDROAT1jMVOedImmfUeAVZRLuEDQJeKJO4q3lfdWCfFiYQKqgpnF2dZbbmACWkl6RMz8n/yNyZFsaZ2+urSRlIKQOZ+RxaMih6UvhAUUEf2wiUnyDY3k7j1mgXGXUg3VoP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744749571; c=relaxed/simple;
	bh=udhrY2QpkeAUMTwwgLvTkQa38PwLXJ7Jg9+0djkigVM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=nUIuA3hJWNK4Z3uWKGQrkTf/kXRUwcghIHR1H8kTZlrD0UbFoG+JT+DAGwzF+8BhD/QdC55JzVlS1cRHYwrPIC7lQJffztwZizN2G1frW/sbQ6o9wIuJ9c1NP84OBZRGNWxD/OkTlE7QCFM2x/Hmq8SHiJV8yR8tBVuQKHNDU/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAvNMSTm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AE9C4CEF0;
	Tue, 15 Apr 2025 20:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744749571;
	bh=udhrY2QpkeAUMTwwgLvTkQa38PwLXJ7Jg9+0djkigVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=cAvNMSTmOH/0+PCjgTab/stDcpjsUsOHf9Q4RvAZZQ9J35BXF+w1YF9ix1X9CRZ5a
	 8WUwbvMDYXZ3GJU8vFBninHMrNillwdKGTEeQTDO4R2wD5Nejv4hR0OsX/+R2fwTf9
	 f3JRru8xIogr6CEA9NnDwi3TWqsI+OGCGoulzn/Io601Z6Zj0kwA9YcZE+UDzqLYIW
	 J+h6Sm+wJU/aaUOrlxmBfnOwCdRMaSuJVEz5av0N8JSSezG0ho8/qCsw4evFDFqUue
	 OwL/QJrYApzx1mx96txPr6cqKrNUVpJuyw7AFOLFmidW4UyqA69TN4I8ePx4hOaBhO
	 jz543S4kfJj8Q==
Date: Tue, 15 Apr 2025 15:39:29 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: naravamudan@nvidia.com, bhelgaas@google.com,
	raphael.norwitz@nutanix.com, ameynarkhede03@gmail.com,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jgg@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	kvm@vger.kernel.org, cp@absolutedigital.net, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "PCI: Avoid reset when disabled via sysfs"
Message-ID: <20250415203929.GA34692@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414211828.3530741-1-alex.williamson@redhat.com>

On Mon, Apr 14, 2025 at 03:18:23PM -0600, Alex Williamson wrote:
> This reverts commit 479380efe1625e251008d24b2810283db60d6fcd.
> 
> The reset_method attribute on a PCI device is only intended to manage
> the availability of function scoped resets for a device.  It was never
> intended to restrict resets targeting the bus or slot.
> 
> In introducing a restriction that each device must support function
> level reset by testing pci_reset_supported(), we essentially create a
> catch-22, that a device must have a function scope reset in order to
> support bus/slot reset, when we use bus/slot reset to effect a reset
> of a device that does not support a function scoped reset, especially
> multi-function devices.
> 
> This breaks the majority of uses cases where vfio-pci uses bus/slot
> resets to manage multifunction devices that do not support function
> scoped resets.
> 
> Fixes: 479380efe162 ("PCI: Avoid reset when disabled via sysfs")
> Reported-by: Cal Peake <cp@absolutedigital.net>
> Link: https://lore.kernel.org/all/808e1111-27b7-f35b-6d5c-5b275e73677b@absolutedigital.net
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied with Kevin's reviewed-by to pci/for-linus for v6.15, thanks,
and sorry for the breakage.

> ---
>  drivers/pci/pci.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 4d7c9f64ea24..e77d5b53c0ce 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5429,8 +5429,6 @@ static bool pci_bus_resettable(struct pci_bus *bus)
>  		return false;
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> -		if (!pci_reset_supported(dev))
> -			return false;
>  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
>  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
>  			return false;
> @@ -5507,8 +5505,6 @@ static bool pci_slot_resettable(struct pci_slot *slot)
>  	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
>  		if (!dev->slot || dev->slot != slot)
>  			continue;
> -		if (!pci_reset_supported(dev))
> -			return false;
>  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
>  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
>  			return false;
> -- 
> 2.48.1
> 

