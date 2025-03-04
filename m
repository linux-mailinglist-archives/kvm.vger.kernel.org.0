Return-Path: <kvm+bounces-40092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F114A4F114
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 161817AA678
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E18261586;
	Tue,  4 Mar 2025 22:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYWF2w35"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F1827BF82;
	Tue,  4 Mar 2025 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129158; cv=none; b=ufbLAuy6fWqNx4yac78uHKXsHBDRcLPid2Cs7cQILN0nEl6d5kV7SohpZQ8DphvTKA8qD0Bx5rWtoctUH/UOWh74cCiqZeM1I0nYlAMG4izI9yWIHRkfi360zsFkihgDvKVlRf/c3Xnii6BrO/iXN1USE3u741gmTc86UAN2Afs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129158; c=relaxed/simple;
	bh=5fmOcMbWEYyFn1vlUabcduL1DY32zpRpBQx2RBuzbqo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=oJ6/dsXM+liRMtHHUvmcA1nr1Fgnh1hbw0gB/J5cUur5sOTjgw4zMAqgrYRtKsFdRYAEO2vYp0hwSF6o2eWB36y/AaZD9L3Goc0TLiVI+WYI9tCfu2CDajwE/08xrAukSlqYxLESiZzWToO4t+pyYWcwk28dp98t3ge7CitKECs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYWF2w35; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93810C4CEE5;
	Tue,  4 Mar 2025 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129155;
	bh=5fmOcMbWEYyFn1vlUabcduL1DY32zpRpBQx2RBuzbqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ZYWF2w35jdYCHsflLo1upLUHiJuYK/SSxPrqLaFOpahdwuUV0blKUlg3mfIfL3nWc
	 mCbD/Lx+NjP0eEdJstmRDVM7WLBTmxyeS+FaAQd3puxhryfsQi1gQfcSPCeBD8Skpf
	 QoQna5y7PE8CHR83rS6C0LJit1sei5s6eTL6upQ30KEbu25k5YrwLD9L/lsmmaIPBe
	 K1bQCo415jf2i3vLMSrnu/DUVIX2G0lr0gidJ+abfXu/eQ1Zge9SZ2H/KZtJ45yJ9F
	 KDXqaVtlCTekonlnx3IIwigxv+kKnQWlK+5oxqD+0rG03CmaCn678/Q1fBt6J+Yls3
	 cJqyFkYzr9Vqw==
Date: Tue, 4 Mar 2025 16:59:14 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Message-ID: <20250304225914.GA263226@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226-vfio_pci_mmap-v7-0-c5c0f1d26efd@linux.ibm.com>

On Wed, Feb 26, 2025 at 01:07:44PM +0100, Niklas Schnelle wrote:
> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. There is thus nothing fundamentally
> preventing s390 from supporting VFIO_PCI_MMAP, allowing user-space
> drivers to access PCI resources without going through the pread()
> interface. To actually enable VFIO_PCI_MMAP a few issues need fixing
> however.
> 
> Firstly the s390 MMIO syscalls do not cause a page fault when
> follow_pte() fails due to the page not being present. This breaks
> vfio-pci's mmap() handling which lazily maps on first access.
> 
> Secondly on s390 there is a virtual PCI device called ISM which has
> a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
> which leads to any attempt to mmap() it fail with the following message:
> 
>     vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size
> 
> Even if one tried to map this BAR only partially the mapping would not
> be usable on systems with MIO support enabled. So just block mapping
> BARs which don't fit between IOREMAP_START and IOREMAP_END. Solve this
> by keeping the vfio-pci mmap() blocking behavior around for this
> specific device via a PCI quirk and new pdev->non_mappable_bars
> flag.
> 
> As noted by Alex Williamson With mmap() enabled in vfio-pci it makes
> sense to also enable HAVE_PCI_MMAP with the same restriction for pdev->
> non_mappable_bars. So this is added in patch 3 and I tested this with
> another small test program.
> 
> Note:
> For your convenience the code is also available in the tagged
> b4/vfio_pci_mmap branch on my git.kernel.org site below:
> https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/
> 
> Thanks,
> Niklas
> 
> Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
> Changes in v7:
> - Move all s390 changes, except for a one-lineer to set pdev->
>   non_mappable_bars for all devices, to the third patch (Bjorn)
> - Move checks in pci-sysfs.c and proc.c to the second patch (Bjorn)
> - Only set ARCH_GENERIC_PCI_MMAP_RESOURCES not HAVE_PCI_MMAP following
>   the recommendation for new architectures in
>   Documentation/PCI/sysfs-pci.rst. This only enables the sysfs but not
>   the proc interface.
> - Link to v6: https://lore.kernel.org/r/20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com
> 
> Changes in v6:
> - Add a patch to also enable PCI resource mmap() via sysfs and proc
>   exlcluding pdev->non_mappable_bars devices (Alex Williamson)
> - Added Acks
> - Link to v5: https://lore.kernel.org/r/20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com
> 
> Changes in v5:
> - Instead of relying on the existing pdev->non_compliant_bars introduce
>   a new pdev->non_mappable_bars flag. This replaces the VFIO_PCI_MMAP
>   Kconfig option and makes it per-device. This is necessary to not break
>   upcoming vfio-pci use of ISM devices (Julian Ruess)
> - Squash the removal of VFIO_PCI_MMAP into the second commit as this
>   is now where its only use goes away.
> - Switch to using follow_pfnmap_start() in MMIO syscall page fault
>   handling to match upstream changes
> - Dropped R-b's because the changes are significant
> - Link to v4: https://lore.kernel.org/r/20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com
> 
> Changes in v4:
> - Overhauled and split up patch 2 which caused errors on ppc due to
>   unexported __kernel_io_end. Replaced it with a minimal s390 PCI fixup
>   harness to set pdev->non_compliant_bars for ISM plus ignoring devices
>   with this flag in vfio-pci. Idea for using PCI quirks came from
>   Christoph Hellwig, thanks. Dropped R-bs for patch 2 accordingly.
> - Rebased on v6.10-rc5 which includes the vfio-pci mmap fault handler
>   fix to the issue I stumbled over independently in v3
> - Link to v3: https://lore.kernel.org/r/20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com
> 
> Changes in v3:
> - Rebased on v6.10-rc1 requiring change to follow_pte() call
> - Use current->mm for fixup_user_fault() as seems more common
> - Collected new trailers
> - Link to v2: https://lore.kernel.org/r/20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com
> 
> Changes in v2:
> - Changed last patch to remove VFIO_PCI_MMAP instead of just enabling it
>   for s390 as it is unconditionally true with s390 supporting PCI resource mmap() (Jason)
> - Collected R-bs from Jason
> - Link to v1: https://lore.kernel.org/r/20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com
> 
> ---
> Niklas Schnelle (3):
>       s390/pci: Fix s390_mmio_read/write syscall page fault handling
>       PCI: s390: Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP
>       PCI: s390: Support mmap() of PCI resources except for ISM devices
> 
>  arch/s390/Kconfig                |  4 +---
>  arch/s390/include/asm/pci.h      |  3 +++
>  arch/s390/pci/Makefile           |  2 +-
>  arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
>  arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
>  drivers/pci/pci-sysfs.c          |  4 ++++
>  drivers/pci/proc.c               |  4 ++++
>  drivers/s390/net/ism_drv.c       |  1 -
>  drivers/vfio/pci/Kconfig         |  4 ----
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  include/linux/pci.h              |  1 +
>  include/linux/pci_ids.h          |  1 +
>  12 files changed, 52 insertions(+), 15 deletions(-)

Applied to pci/resource for v6.15, thanks!

I updated the subject lines to all start with "s390/pci" since that's
where all the interesting bits are and there's only a single instance
of "PCI: s390" in the history.

