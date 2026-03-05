Return-Path: <kvm+bounces-72884-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AwkJxq/qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72884-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:36:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC65F216560
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 867623027D86
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4531C3E3DAF;
	Thu,  5 Mar 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="kZ62yR2z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Nf4uv6lz"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D923793DB;
	Thu,  5 Mar 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732022; cv=none; b=caJ0hbd+qCIX7JcKDtVzeR2c0V9pxl5l5sHBBNMmncweQ7fECHW7DetEZ9nEzpSH3XMwlxk0k/dZQ+ceA/nu8FsSU5uSTkopvzwT7VQAkSSH6DeeKkxF70c6suJdG7YDtkE56VS8qjWkpR17CmXduhB/X/5jXao2z4fKPgMfzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732022; c=relaxed/simple;
	bh=EmAbIrmI+i93dlAeOrzZh/+OihYBDIQow9KryXQnLzE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q37RLNmmPK+1nZMv9O7SwpjwpJt/EqFjeFYQjejFv4ujSIVQOLGm38EaD6vFMUVZ8DKbaps4KiRb2IztQwh0iuEnkLkLCKhh7T0XeV1U4P4TJXqFkbsL4wVB5f0bc5GLM7WK0IH/uCk+e+Q5wjjvvF4JXNq2efR60aXpdP10SF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=kZ62yR2z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Nf4uv6lz; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4C7E97A0016;
	Thu,  5 Mar 2026 12:33:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 05 Mar 2026 12:33:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772732018;
	 x=1772818418; bh=m+/p38n2KRI7cxtMuEktLPqTIrKpx/IK6VEOGDGPJqM=; b=
	kZ62yR2zUHf1XvuT6gCmWpwWI4FLe1KOZZBwnhOAlkCTKaeMN+N74gEv+oqvJavm
	AtMiMBEaWu3E1NdKyN8R+XHnl/ljMcBm15R0hx3ssJnROg2SRdOsr+ah2ep8AtzK
	521tpDYM7GeUqFgUZOU/f7EnTPmkxWc+U3EvTYPH/ciq/NR9U2KI3eHpX4CFIanm
	4pbh4zp916d6ZQWxctsN08feg7jVnImP22YpOp8A3GxGcUCquqb51GqniYaU90Bz
	X5n+QnL0P9jHd0mXIUjuED99M8ptylIeEyGWnKIETXB8Xk7iWr1Kzg8IzH1C3CBg
	1E3ICsL9V50iqa46d9YHow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772732018; x=
	1772818418; bh=m+/p38n2KRI7cxtMuEktLPqTIrKpx/IK6VEOGDGPJqM=; b=N
	f4uv6lzHBu/v/T+V080Eb/eNplj7HEckzrmdFtDdRcWG7wL6Co7ExtKolIamyIH+
	fed7qSJN1pgIgWd6O9j8CnESlsuhd2La9U0cWFAD3ol9c0vfRne/yA2u9eQyOoP3
	B5welZp4VT0ZDKNSTkUA2b6D6hcTJuG98VYsifJje/zIt0rRh44yPPX+fzOsmdwU
	QD2cTO19FSfbaaB2S8I2sOFOikXX+F00GHtUFJmOL/zPoT6+jHMvg53zoCMM5PIl
	gfMlJVj8N99KMootG+ycbBDCz2EBq1XLkeXhQ25ksAKVBVJGRAwomFHyXougdUml
	SJzdVxXtt+lmc+RQiUMmg==
X-ME-Sender: <xms:cb6paVj9K7MRh2QmdB-0pLk-zOslSWOIXupLjaI5H9ngYb2wloq9wA>
    <xme:cb6pafM1-Nxk_GxuD_B-3Tm9kiq_XTfAqsco7QkOAOdMaudrYMp7GP2axEDnXutzm
    VvbTp_lY0HMYxsfn1jzMSexGtXEagEUPto6SujvUjqD54ByhKmZnp8>
X-ME-Received: <xmr:cb6paYfSlatTSJzLNBMEzEbyNQl6GaPoTt8jJlwmKIclGSBIDWJ6H6koOuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeileelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:cb6paZwsgm5o-g6IfjRsz0PkffOzgJocX87YCBnvKUCVxxerX0dUlA>
    <xmx:cb6pad25zEvbLtvZzmXtNbZSnolwJInLN4yPJhLYVoB8YGvYcTmnlg>
    <xmx:cb6paQcxxHN9aTAGy-OP8rRSMrFUqYdtfM6VUOmPem9vOXkUp6Ff5A>
    <xmx:cb6paSW7xBUt2iWyCbSJWX54RuD0YfkEvzuO-gppUwlaapPP86aPpw>
    <xmx:cr6paR_m-uAsk5KHE9oZJoM70Ci4mhgEFGylKWp2JZ0pzToVgmOoiHxh>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Mar 2026 12:33:36 -0500 (EST)
Date: Thu, 5 Mar 2026 10:33:35 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 00/15] Add virtualization support for EGM
Message-ID: <20260305103335.74fb8141@shazbot.org>
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC65F216560
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72884-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,messagingengine.com:dkim,nvidia.com:email]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:54:59 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Background
> ----------
> Grace Hopper/Blackwell systems support the Extended GPU Memory (EGM)
> feature that enable the GPU to access the system memory allocations
> within and across nodes through high bandwidth path. This access path
> goes as: GPU <--> NVswitch <--> GPU <--> CPU. The GPU can utilize the
> system memory located on the same socket or from a different socket
> or even on a different node in a multi-node system [1]. This feature is
> being extended to virtualization.
> 
> 
> Design Details
> --------------
> EGM when enabled in the virtualization stack, the host memory
> is partitioned into 2 parts: One partition for the Host OS usage
> called Hypervisor region, and a second Hypervisor-Invisible (HI) region
> for the VM. Only the hypervisor region is part of the host EFI map
> and is thus visible to the host OS on bootup. Since the entire VM
> sysmem is eligible for EGM allocations within the VM, the HI partition
> is interchangeably called as EGM region in the series. This HI/EGM region
> range base SPA and size is exposed through the ACPI DSDT properties.
> 
> Whilst the EGM region is accessible on the host, it is not added to
> the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
> to the SPA using remap_pfn_range().
> 
> The following figure shows the memory map in the virtualization
> environment.
> 
> |---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
> |                |                  |               |
> |IPA <-> SPA map |                  |IPA <-> SPA map|
> |                |                  |               |
> |--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory
> 
> The patch series introduce a new nvgrace-egm auxiliary driver module
> to manage and map the HI/EGM region in the Grace Blackwell systems.
> This binds to the auxiliary device created by the parent
> nvgrace-gpu (in-tree module for device assignment) / nvidia-vgpu-vfio
> (out-of-tree open source module for SRIOV vGPU) to manage the
> EGM region for the VM. Note that there is a unique EGM region per
> socket and the auxiliary device gets created for every region. The
> parent module fetches the EGM region information from the ACPI
> tables and populate to the data structures shared with the auxiliary
> nvgrace-egm module.
> 
> nvgrace-egm module handles the following:
> 1. Fetch the EGM memory properties (base HPA, length, proximity domain)
> from the parent device shared EGM region structure.
> 2. Create a char device that can be used as memory-backend-file by Qemu
> for the VM and implement file operations. The char device is /dev/egmX,
> where X is the PXM node ID of the EGM being mapped fetched in 1.
> 3. Zero the EGM memory on first device open().
> 4. Map the QEMU VMA to the EGM region using remap_pfn_range.
> 5. Cleaning up state and destroying the chardev on device unbind.
> 6. Handle presence of retired poisoned pages on the EGM region.
> 
> Since nvgrace-egm is an auxiliary module to the nvgrace-gpu, it is kept
> in the same directory.

Pondering this series for a bit, is this auxiliary chardev approach
really the model we should be pursuing?

I know we're trying to disassociate the EGM region from the GPU, and
de-duplicate it between GPUs on the same socket, but is there actually a
use case of the EGM chardev separate from the GPU?

The independent lifecycle of this aux device is troubling and it hasn't
been confirmed whether or not access to the EGM region has some
dependency on the state of the GPU.  nvgrace-gpu is manipulating sysfs
on devices owned by nvgrace-egm, we don't have mechanisms to manage the
aux device relative to the state of the GPU, we're trying to add a
driver that can bind to device created by an out-of-tree driver, and
we're inventing new uAPIs on the chardev for things that already exist
for vfio regions.

Therefore, does it actually make more sense to expose EGM as a device
specific region on the vfio device fd?

For example, nvgrace-gpu might manage the de-duplication by only
exposing this device specific region on the lowest BDF GPU per socket.
The existing REGION_INFO ioctl handles reporting the size to the user.
The direct association to the GPU device handles reporting the node
locality.  If necessary, a capability on the region could report the
associated PXM, and maybe even the retired page list.

All of the lifecycle issues are automatically handled, there's no
separate aux device.  If necessary, zapping and faulting across reset
is handled just like a BAR mapping.

If we need to expose the EGM size and GPU association via sysfs for
management tooling, nvgrace-gpu could add an "egm_size" attribute to the
PCI device's sysfs node.  This could also avoid the implicit
implementation knowledge about which GPU exposes the EGM device
specific region.

Was such a design considered?  It seems much, much simpler and could be
implemented by either nvgrace-gpu or identically by an out-of-tree
driver without references in an in-kernel ID table.

I'd like to understand the pros and cons of such an approach vs the one
presented here.  Thanks,

Alex

