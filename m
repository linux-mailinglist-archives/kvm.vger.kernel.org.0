Return-Path: <kvm+bounces-62102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E52CC37735
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE13E4EE33D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFE233E353;
	Wed,  5 Nov 2025 19:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="j+Zknbdu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Cs+LRfvQ"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F05335567;
	Wed,  5 Nov 2025 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370147; cv=none; b=tBB5qJeMIj2a5FOOMklK3H/y/f1WSAsmLxT+RVVbUBeyvU8LhBxANn95N62yUMRw2ao9zmpyY1Km2SFBvnb1olmrK7J6m39m//gajjPMkdnW6iUA3O/ehavAUjiURJQ/GIkVd/sNa3o42uvkJY/HSsUdeAq03kkIO6al2jcMz0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370147; c=relaxed/simple;
	bh=JHrjqXSucTdWSjF048Fffi/Gv6t5IxwMWWkAGDg9aLI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HINBFLTsoDwBTucgVp+fwBSGL+GEF2tgQ9s9wl6QtOqaMVh5hBDX8sllk5dsEsPR+vkwNpXQMdQL1kFoYh8+r2GWBjqyr/BDzFIvxEF0ywYJIZmc0nqPG6s+R9glDJeJ71r9UTQdUcqF5GwS9gMJVNhM7nr1dFoCVYCzikjVz0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=j+Zknbdu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Cs+LRfvQ; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 59F0E1400025;
	Wed,  5 Nov 2025 14:15:43 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 05 Nov 2025 14:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762370143;
	 x=1762456543; bh=aJuWzjYZpwayO82etSJ9DlNzTR0YS587Z3mrFGjvSvI=; b=
	j+ZknbduQvC9Jt6BKGmiiHcCO++qEmGIKCEPCYA/bbVnMc1sU5p2SgVuLU3zwqPw
	X/YOtnn/tBm2DQLdJevBQ+TKKokCw0eQc6iscTuDo180P5pFit8RdIv9ERY8mmMh
	BeIV0sAK4haguj9ADKxG9jFIXbgI5cQjwBddoY47Ure090ghrO8JRS87/QziMzy+
	PCi29HRMCRpeSVuVat9CtZc/qihjYwClD+ScyzQzdkNAguQBkHAM/GdbkX+AviKx
	5BYLpre2Rh8PaKmAX9pOGkNO/Nc4JAPXWsBCIv2QQFWWXMm7tH18pK2hfC5RZxnG
	YMnaXNKkUyUYHICDT1w8gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762370143; x=
	1762456543; bh=aJuWzjYZpwayO82etSJ9DlNzTR0YS587Z3mrFGjvSvI=; b=C
	s+LRfvQRS3nLoptUOkshy0SfnmXzAStLGpijpHBMsxx9BLS4xBKGhoeOg9SGvbtQ
	Dv2Mf7jr2zMpTf1sHqFKULcq93kCC3GsWSitKlcchtmm56I9xAb0ouqdHZF40+F0
	MphDwxMOBwpcdpnO6lFP2uW+hZ0JSmMmHCSpe35OD4vuzxJthfq1+OUxcpEUKAxG
	1NYaro27oSGSghoqn6bcaxYpYNM6YiXqmEaMp0unmM9/z5tefP3QBJRCwBV5Cipv
	oz3z+5iUNvTx8HHzCcZWfWJCMeuKC0gXVJsAJvtYaDE2cfcwaImfHTflKioKXbJD
	QfCbNbR0LZ+ipe2y5fqug==
X-ME-Sender: <xms:XqILabW8NhedOpGG1o2ClMmFQE9KKuIeFIQUjqMuXr0k0Ui1Juf3-Q>
    <xme:XqILaURlZIs4aNqgfztJgBhCzq3dDManUgaqTtfwZP-gOlT8cSFgG_lpRUidZE_nw
    NdEaf2jYI4UV91CB7FJHstMbufiZ-uAM398z-ss7SWeVbHRT3z9fw>
X-ME-Received: <xmr:XqILaVkKHyeV6PONPGf6fNebA-qPL0RnRmTGC9bYjwLQNpXixzgkP7kP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeegjedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgfffvdefjeejueevfeetudfhgeetfeeuheetfeekjedvuddvueehffdtgeej
    keetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeejpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopeifrghthhhsrghlrgdrvhhithhhrghnrghgvgesrghrmh
    drtghomhdprhgtphhtthhopehjvghrvghmhidrlhhinhhtohhnsegrrhhmrdgtohhmpdhr
    tghpthhtoheprghlvgigrdifihhllhhirghmshhonhesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohepphhsthgrnhhnvghrsehr
    vgguhhgrthdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:XqILaa693JWyVBeFDmpWk-3HW2_jwypi0opJj0oFp8N7MvKjFd31LA>
    <xmx:XqILabhyqVWJ5JLCs8ylB3Hm9frirnaWnT4KVl54b2Z92mYTxxq31w>
    <xmx:XqILaXEjQJYOaKeboWE3KTPI1X_bYbuYseZDQKt43EPd-3mZgQ8x1g>
    <xmx:XqILaRRb39bIeJDaqNUBbDKAvcpQGgxxwVl_Xnrg_eM0oedNetHoNw>
    <xmx:X6ILad4j6y76eAi2iyPIgGTFE1v_4hu3XrJfcXCI7BfVFQRnDxe4GVOK>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 14:15:42 -0500 (EST)
Date: Wed, 5 Nov 2025 12:15:41 -0700
From: Alex Williamson <alex@shazbot.org>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>, alex.williamson@redhat.com,
 jgg@ziepe.ca, pstanner@redhat.com, kvm@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] vfio/pci: add PCIe TPH device ioctl
Message-ID: <20251105121541.4d383694.alex@shazbot.org>
In-Reply-To: <4bf8ba8f-57c3-4af2-9f2a-f4313121be87@arm.com>
References: <20251013163515.16565-1-wathsala.vithanage@arm.com>
	<9df72789-ab35-46a0-86cf-7b1eb3339ac7@arm.com>
	<4bf8ba8f-57c3-4af2-9f2a-f4313121be87@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Oct 2025 09:33:33 -0500
Wathsala Vithanage <wathsala.vithanage@arm.com> wrote:

> On 10/16/25 16:41, Jeremy Linton wrote:
> > Hi,
> >
> > On 10/13/25 11:35 AM, Wathsala Vithanage wrote: =20
> >> TLP Processing Hints (TPH) let a requester provide steering hints that
> >> can enable direct cache injection on supported platforms and PCIe
> >> devices. The PCIe core already exposes TPH handling to kernel drivers.
> >>
> >> This change adds the VFIO_DEVICE_PCI_TPH ioctl and exposes TPH control
> >> to user space to reduce memory latency and improve throughput for
> >> polling drivers (e.g., DPDK poll-mode drivers). Through this interface,
> >> user-space drivers can:
> >> =C2=A0=C2=A0 - enable or disable TPH for the device function
> >> =C2=A0=C2=A0 - program steering tags in device-specific mode
> >>
> >> The ioctl is available only when the device advertises the TPH
> >> Capability. Invalid modes or tags are rejected. No functional change
> >> occurs unless the ioctl is used.
> >>
> >> Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
> >> ---
> >> =C2=A0 drivers/vfio/pci/vfio_pci_core.c | 74 +++++++++++++++++++++++++=
+++++++
> >> =C2=A0 include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 36 ++++++++++++++++
> >> =C2=A0 2 files changed, 110 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c=20
> >> b/drivers/vfio/pci/vfio_pci_core.c
> >> index 7dcf5439dedc..0646d9a483fb 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -28,6 +28,7 @@
> >> =C2=A0 #include <linux/nospec.h>
> >> =C2=A0 #include <linux/sched/mm.h>
> >> =C2=A0 #include <linux/iommufd.h>
> >> +#include <linux/pci-tph.h>
> >> =C2=A0 #if IS_ENABLED(CONFIG_EEH)
> >> =C2=A0 #include <asm/eeh.h>
> >> =C2=A0 #endif
> >> @@ -1443,6 +1444,77 @@ static int vfio_pci_ioctl_ioeventfd(struct=20
> >> vfio_pci_core_device *vdev,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ioeventfd.fd);
> >> =C2=A0 }
> >> =C2=A0 +static int vfio_pci_tph_set_st(struct vfio_pci_core_device *vd=
ev,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct vfio_pci_tph_entry *en=
t)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 int ret, mem_type;
> >> +=C2=A0=C2=A0=C2=A0 u16 st;
> >> +=C2=A0=C2=A0=C2=A0 u32 cpu_id =3D ent->cpu_id;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (cpu_id >=3D nr_cpu_ids || !cpu_present(cpu_id))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (!cpumask_test_cpu(cpu_id, current->cpus_ptr))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 switch (ent->mem_type) {
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_TPH_MEM_TYPE_VMEM:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem_type =3D TPH_MEM_TYPE_=
VM;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_TPH_MEM_TYPE_PMEM:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem_type =3D TPH_MEM_TYPE_=
PM;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> +=C2=A0=C2=A0=C2=A0 default:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0 ret =3D pcie_tph_get_cpu_st(vdev->pdev, mem_type,=
=20
> >> topology_core_id(cpu_id),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &st);
> >> +=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> +=C2=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * PCI core enforces table bounds and disable=
s TPH on error.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> +=C2=A0=C2=A0=C2=A0 return pcie_tph_set_st_entry(vdev->pdev, ent->inde=
x, st);
> >> +}
> >> +
> >> +static int vfio_pci_tph_enable(struct vfio_pci_core_device *vdev,=20
> >> int mode)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 /* IV mode is not supported. */
> >> +=C2=A0=C2=A0=C2=A0 if (mode =3D=3D PCI_TPH_ST_IV_MODE)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +=C2=A0=C2=A0=C2=A0 /* PCI core validates 'mode' and returns -EINVAL o=
n bad values. */
> >> +=C2=A0=C2=A0=C2=A0 return pcie_enable_tph(vdev->pdev, mode);
> >> +}
> >> +
> >> +static int vfio_pci_tph_disable(struct vfio_pci_core_device *vdev)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 pcie_disable_tph(vdev->pdev);
> >> +=C2=A0=C2=A0=C2=A0 return 0;
> >> +}
> >> +
> >> +static int vfio_pci_ioctl_tph(struct vfio_pci_core_device *vdev,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __user *uarg)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph tph;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (copy_from_user(&tph, uarg, sizeof(struct vfio_=
pci_tph)))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (tph.argsz !=3D sizeof(struct vfio_pci_tph))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 switch (tph.op) {
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_DEVICE_TPH_ENABLE:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci_tph_enable=
(vdev, tph.mode);
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_DEVICE_TPH_DISABLE:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci_tph_disabl=
e(vdev);
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_DEVICE_TPH_SET_ST:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci_tph_set_st=
(vdev, &tph.ent);
> >> +=C2=A0=C2=A0=C2=A0 default:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +}
> >> +
> >> =C2=A0 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigne=
d=20
> >> int cmd,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long arg)
> >> =C2=A0 {
> >> @@ -1467,6 +1539,8 @@ long vfio_pci_core_ioctl(struct vfio_device=20
> >> *core_vdev, unsigned int cmd,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci=
_ioctl_reset(vdev, uarg);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case VFIO_DEVICE_SET_IRQS:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci=
_ioctl_set_irqs(vdev, uarg);
> >> +=C2=A0=C2=A0=C2=A0 case VFIO_DEVICE_PCI_TPH:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vfio_pci_ioctl_tph(=
vdev, uarg);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOTTY;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 75100bf009ba..cfdee851031e 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -873,6 +873,42 @@ struct vfio_device_ioeventfd {
> >> =C2=A0 =C2=A0 #define VFIO_DEVICE_IOEVENTFD=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 _IO(VFIO_TYPE, VFIO_BASE + 16)
> >> =C2=A0 +/**
> >> + * VFIO_DEVICE_PCI_TPH - _IO(VFIO_TYPE, VFIO_BASE + 22)
> >> + *
> >> + * Control PCIe TLP Processing Hints (TPH) on a PCIe device.
> >> + *
> >> + * Supported operations:
> >> + * - VFIO_DEVICE_TPH_ENABLE: enable TPH in no-steering-tag (NS) or
> >> + *=C2=A0=C2=A0 device-specific (DS) mode. IV mode is not supported vi=
a this ioctl
> >> + *=C2=A0=C2=A0 and returns -EINVAL.
> >> + * - VFIO_DEVICE_TPH_DISABLE: disable TPH on the device.
> >> + * - VFIO_DEVICE_TPH_SET_ST: program an entry in the device TPH=20
> >> Steering-Tag
> >> + *=C2=A0=C2=A0 (ST) table. The kernel derives the ST from cpu_id and =
mem_type;=20
> >> the
> >> + *=C2=A0=C2=A0 value is not returned to userspace.
> >> + */
> >> +struct vfio_pci_tph_entry {
> >> +=C2=A0=C2=A0=C2=A0 __u32 cpu_id;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* CPU logical ID */
> >> +=C2=A0=C2=A0=C2=A0 __u8=C2=A0 mem_type;
> >> +#define VFIO_TPH_MEM_TYPE_VMEM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0 /* Request volatile memory=20
> >> ST */
> >> +#define VFIO_TPH_MEM_TYPE_PMEM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 1=C2=A0=C2=A0 /* Request persistent=20
> >> memory ST */
> >> +=C2=A0=C2=A0=C2=A0 __u8=C2=A0 rsvd[1];
> >> +=C2=A0=C2=A0=C2=A0 __u16 index;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* ST-table index */
> >> +};
> >> +
> >> +struct vfio_pci_tph {
> >> +=C2=A0=C2=A0=C2=A0 __u32 argsz;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Size of vfio_pci_tph */
> >> +=C2=A0=C2=A0=C2=A0 __u32 mode;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* NS and DS modes; IV not supported */
> >> +=C2=A0=C2=A0=C2=A0 __u32 op;
> >> +#define VFIO_DEVICE_TPH_ENABLE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
> >> +#define VFIO_DEVICE_TPH_DISABLE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1
> >> +#define VFIO_DEVICE_TPH_SET_ST=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 2
> >> +=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph_entry ent;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_PCI_TPH=C2=A0=C2=A0=C2=A0 _IO(VFIO_TYPE, VFIO_BAS=
E + 22) =20
> >
> > A quick look at this, it seems its following the way the existing vfio=
=20
> > IOCTls are defined, yet two of them (ENABLE and DISABLE) won't likely=20
> > really change their structure, or don't need a structure in the case=20
> > of disable. Why not use IOW() and let the kernel error handling deal=20
> > with those two as independent ioctls?
> >
> >
> > Thanks, =20
>=20
>=20
> It will require two IOCTLs.=C2=A0I=E2=80=99m ok with having two IOCTLs fo=
r this=20
> feature if the maintainers are fine with it.

TBH, I'm not sure why we didn't use a DEVICE_FEATURE for this.  Seems
like we could implement a SET operation that does enable/disable and
another for steering tags.  I still need to fully grasp the
implications of this support though.  Thanks,

Alex

