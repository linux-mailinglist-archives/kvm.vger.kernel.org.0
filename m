Return-Path: <kvm+bounces-56827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3360FB43BFA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 14:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B489F16EACE
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 12:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463772FDC59;
	Thu,  4 Sep 2025 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvZUc08O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8352FDC44
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756989940; cv=none; b=mZhpIbRfj9yz0Rfw6PbOPppP2D12y8PqxOuKyVVQfcrOB2EKwfht9id7zRwv3vYIztZoc8AGiuBzqYio3KsX9faTn25BhUwb43JGVfT4uveW0n6Mk3OFXNMxtaz8eI+5zpEluATRRPCRu4MzDRffesO0R4F3UrwlqahMDJO3Ais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756989940; c=relaxed/simple;
	bh=/QNmFgSgm3l3iV46R+tQWtvZ5ZHhzWR4UUhKT2/hXXc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=CQPH+G+qqkxWHXLZS6LGP1fyRP7mP1yRONBRwfuNnArFgulrUa06u2d9EeGjTLw+ScoquG7QUvapEibcKUur7oaiyPhANkglRX3l81aQYyKYpeconuWbeHbAFZJUdUoJGq7y6H0moIlHIFJP2xCcud5mUS0zgT4iscPMt6aVWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YvZUc08O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49363C4CEF1;
	Thu,  4 Sep 2025 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756989940;
	bh=/QNmFgSgm3l3iV46R+tQWtvZ5ZHhzWR4UUhKT2/hXXc=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=YvZUc08ObIiHjABIpvF7UWA3FWO8ZH2OaGFiY6ZZ1Jq/xoKaJahN1BBLFbX1xd3Fo
	 WOt/y11i3vaI/ukWOViYkXOVtoY0yQ4qZIM+0agKOxTsFujtW7ziWKE863cW5LKAxS
	 W1iUDPcZkMOt8JpL0ZXXgJi3obrRDSQA+MsYdYPbPYDWlcdmWd01gnCfsBBxJylamM
	 MvLap+PFUcuRfhjtCrG3P/8vsltAuyZzYm170jo/4GO33hQBryG/4A5T/Frnnw/v/i
	 LA2+cQSRhs8ukZPMCFfkyZ8oI4iE6nHD5b0gydFW7Y6tVusln3CCpeSAZcU9VgtSsm
	 r6036swWRDYyA==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Sep 2025 14:45:34 +0200
Message-Id: <DCK0Y92W1QSY.1O2U2K3GV61QW@kernel.org>
Cc: "Zhi Wang" <zhiw@nvidia.com>, <kvm@vger.kernel.org>,
 <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <airlied@gmail.com>,
 <daniel@ffwll.ch>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <smitra@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiwang@kernel.org>,
 <acourbot@nvidia.com>, <joelagnelf@nvidia.com>, <apopple@nvidia.com>,
 <jhubbard@nvidia.com>, <nouveau@lists.freedesktop.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
References: <20250903221111.3866249-1-zhiw@nvidia.com>
 <20250903221111.3866249-4-zhiw@nvidia.com>
 <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
 <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
 <20250904121544.GL470103@nvidia.com>
In-Reply-To: <20250904121544.GL470103@nvidia.com>

On Thu Sep 4, 2025 at 2:15 PM CEST, Jason Gunthorpe wrote:
> On Thu, Sep 04, 2025 at 11:41:03AM +0200, Danilo Krummrich wrote:
>
>> > Another note: I don't see any use of the auxiliary bus in vGPU, any cl=
ients
>> > should attach via the auxiliary bus API, it provides proper matching w=
here
>> > there's more than on compatible GPU in the system. nova-core already r=
egisters
>> > an auxiliary device for each bound PCI device.
>
> The driver here attaches to the SRIOV VF pci_device, it should obtain the
> nova-core handle of the PF device through pci_iov_get_pf_drvdata().
>
> This is the expected design of VFIO drivers because the driver core
> does not support a single driver binding to two devices (aux and VF)
> today.

Yeah, that's for the VF PCI devices, but I thought vGPU will also have some=
 kind
of "control instance" for each physical device through which it can control=
 the
creation of VFs?

