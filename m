Return-Path: <kvm+bounces-40881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C04ACA5EB2F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 870493A29CF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BB71F0996;
	Thu, 13 Mar 2025 05:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5kJHn6N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD462E3366
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843939; cv=none; b=A25cqh9L693K/ixd33Zx1FbddOnrV386+0tLAkOgWjTOAbjdVts51bZMY7JJvQ42VVriGUoyziQi3laf9say6xV/B1RqKXFEZnF7ftPOhspCD2jpV9jgS3zGqTfFz5Ue886dsDIfS4XnRfMpF+3yj4H0XbPXSad5WpoqyYcD9/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843939; c=relaxed/simple;
	bh=emJoGt99NIuuRfKoBT8X5IZIhInNkbZdFL6rrAyLdYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P/b3v/L42eAEECf0Dgo4WAYjh7INiKamT5siBlh1gyWeN0jPnX7DwZb5DzjcSsXora+wK4VO4v4bJHkEpOf5ZJ3P6ggfPWqd4W6d9icCKmN29opFBM4zlFNFrsLo638lyfu+DknHkCYHyWrXcemuu5KMV9O6esXae8SAGicRje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5kJHn6N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1520AC4CEDD;
	Thu, 13 Mar 2025 05:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741843937;
	bh=emJoGt99NIuuRfKoBT8X5IZIhInNkbZdFL6rrAyLdYo=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Z5kJHn6N/Z7Gh4Xlm1eZDQAC3QQ0Kqbv3kMBw2UgT+foZlGN/pf2StKvjXzDrQtvS
	 BC0Z51FdTLyOjbyJe1Ek/GuDzKLZj2FEZ42ZCVpLJ4FDqjMwhjzWzeQKwdTRuFb1/R
	 LdstGmxDjKVnqTtjiKFoK7iw2TZVJsXQ7uJRiboB46ThaRwW2keERHcWVtkAdflsM3
	 hZeY5voHe4C4XdPzo2BHFut6f1Gnet8H2RDg2JwsNMOraxGuV4VOYhZZHVFSFNQoCB
	 yd13aFeGqybdW8+zPtIc989dPF8DvXdHR0146JFGZmOHNJoHpANgpHlD4+1T3w3h+f
	 uEpllFxNmkKjA==
Message-ID: <61b7748f-839d-4746-a623-1912028c4fe8@kernel.org>
Date: Thu, 13 Mar 2025 14:32:14 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] nvmet: Add NVMe target mdev/vfio driver
To: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, joao.m.martins@oracle.com,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, kwankhede@nvidia.com,
 alex.williamson@redhat.com, mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 14:18, Mike Christie wrote:
> The following patches were made over Linus's tree. They implement
> a virtual PCI NVMe device using mdev/vfio. The device can be used
> by QEMU and in the guest will look like a normal old local PCI
> NVMe drive.
> 
> They are based on Maxim Levitsky's mdev patches:
> 
> https://lore.kernel.org/lkml/20190506125752.GA5288@lst.de/t/
> 
> but instead of trying to export a physical NVMe device to a guest, they
> are only focused on exporting a virtual device using the nvmet layer.
> 
> Why another driver when we have so many? Performance.
> =====================================================
> Without any tuning and major locks still in the main IO path, 4K IOPS for
> a single controller with a single namespace are higher than the kernel
> vhost-scsi driver and SPDK vhost-scsi/blk user when using lower number
> of queues/cpus/jobs. At just 2 queues, we are able to hit 1M IOPS:
> 
> Note: the nvme mdev values below have the shadow doorbell enabled
> 
>         mdev vhost-scsi vhost-scsi-usr vhost-blk-usr
> numjobs
> 1       518K    198K        332K        301K
> 2       1037K   363K        609K        664K
> 4       974K    633K        1369K       1383K
> 8       813K    1788K       1358K       1363K
> 
> However, by default we can't scale. But, tuning mdev to pre-pin pages
> (this requires patches to the vfio layer to support) then it also performs
> better at lower and higher number of queues/cpus/jobs used with it
> reaching 2.3M IOPS woth only 4 cpus/queues used:
> 
>         mdev
> numjobs
> 1       505K
> 2       1037K
> 4       2375K
> 8       2162K
> 
> If we agree on a new virtual NVMe driver being ok, why mdev vs vhost?
> =====================================================================
> The problem with a vhost nvme is:
> 
> 2.1. If we do a fully vhost nvmet solution, it will require new guest
> drivers that present NVMe interfaces to userspace then perform the
> vhost spec on the backend like how vhost-scsi does.
> 
> I don't want to implement a windows or even a linux nvme vhost
> driver. I don't think anyone wants the extra headache.
> 
> 2.2. We can do a hybrid approach where in the guest it looks like we
> are a normal old local NVMe drive and use the guest's native NVMe driver.
> However in QEMU we would have a vhost nvme module that instead of using
> vhost virtqueues handles virtual PCI memory accesses as well as a vhost
> nvme kernel or user driver to process IO.
> 
> So not as much extra code as option 1 since we don't have to worry about
> the guest but still extra QEMU code.
> 
> 3. The mdev based solution does not have these drawbacks as it can
> look like a normal old local NVMe drive to the guest and can use QEMU's
> existing vfio layer. So it just requires the kernel driver.
> 
> Why not a new blk driver or why not vdpa blk?
> =============================================
> Applications want standardized interfaces for things like persistent
> reservations. They have to support them with SCSI and NVMe already
> and don't want to have to support a new virtio block interface.
> 
> Also the nvmet-mdev-pci driver in this patchset can perform was well
> as SPDK vhost blk so that doesn't have the perf advantage like it
> used to.
> 
> Status
> ======
> This patchset is RFC quality only. You can discover a drive and do
> IO but it's not stable. There's several TODO items mentioned in the
> last patch. However, I think the patches are at the point where I
> wanted to get some feedback about if this even acceptable because
> the last time they were posted some people did not like how
> they hooked into drivers/nvme/host (this has been fixed in this
> posting). There's some other issues like:
> 
> 1. Should the driver integrate with pci-epf (the drivers work very
> differently but could share some code)?

Will have a look.

> 
> 2. Should it try to fit into the existing configfs interface or implement
> it's own like how pci-epf did? I did an attempt for this but it feels
> wrong.

Note that the configfs for pci-epf is supported by the PCI endpoint
infrastructure. It is not all implemented by the driver alone.

-- 
Damien Le Moal
Western Digital Research

