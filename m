Return-Path: <kvm+bounces-64946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B148C930BC
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 20:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9357434A416
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 19:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B1333436C;
	Fri, 28 Nov 2025 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="X/W4zJ4a";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="km8V7Piy"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0163C27587E;
	Fri, 28 Nov 2025 19:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764359100; cv=none; b=FPyxDpDvVPcrdeeNxxV/guQGKZDTpv2+3yNZxR2cDL3afvaNGbJowy0gvFjQVy+28qT32zPxMH1Q8grviaV0W2frnzaM41pmkcKNsjBnh9tv5jyCNfavZamxxRJq+TKJaV33uEN3hie+V4NJ25l36cRyfaqoYR1/NXyW6f6hiuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764359100; c=relaxed/simple;
	bh=C9i7awpzYDU/ou8oDCf3F4sKL9eNqr+aOvKa80iZkvk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EPH6w+cMQyyTfOJy2Sl3ZY3f+uX//duBitG+pGr79X9PSwaU2/7RK6rerPY6RU3/tl5NLwWqmBjCn10sB+3QXc7T+cfcOWSqycPM5EyY2Z2IZzcUIqPqUlPi+jgavs04lLguH76ewxurROVWGq50nQGNv6UCZi17ZIcJm8n1qAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=X/W4zJ4a; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=km8V7Piy; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 115D71D0072E;
	Fri, 28 Nov 2025 14:44:57 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 28 Nov 2025 14:44:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764359096;
	 x=1764445496; bh=4O1Anyo7QeOiltfx0oBC8JHG7P4eCCuZHh1FdGOKm3Y=; b=
	X/W4zJ4aTasE/9/y+3S5whAkYD7EU7Hv3RzDmwseMFN4Ezel58Q03KAI2eOiVA7S
	dmaOZPD++0+25TxxuuM6OupWJuTSKd/eDCKT1rMY6ZiEEVIkIP8PQNqPfSwtysyP
	EfLcpweFVPxq9GSbawEXq0emAb7Ntn3rkVq5PbbUKBU9Xnew56aLlELn6/yyNOqN
	fgxCPYe48JvkvasCfjF0GMn1Bx5P2TaMxZyBarrSUh8JzeHlucDKQbj4xUJSE7tC
	12bzByWqUKfYfMlADCHlqv/qJLw5SlYSwiNoEgpGsn4t+2Lx4iS0i6+QGcTLu5Oy
	sDWXFRbqQft5SzehlVlLDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764359096; x=
	1764445496; bh=4O1Anyo7QeOiltfx0oBC8JHG7P4eCCuZHh1FdGOKm3Y=; b=k
	m8V7Piy93qQy9IvtDufhNpUlxzl1l4giy2QDv7MhsKtf7fRxI9flsO03k9PQMgJL
	A5uEvw6QnR3qR8XC20sWgpu0WPJAPFuHa4e1dVxP+d72U1FfOfLU/I79BHNLlYi5
	bV0IX/ZsgdQ+Kg3kXQX9n9EqsUH++gK3weAUscqxM6netcrPGvpdHcMI5cDF+jB1
	DAgfyfTB/oJFj2/sBK4DcIrNXClwt3cbd7i2evnn18nVvj7YPFrXRaaQUJIwxUVR
	jLvCIRyc8QJzQar7nJbGd4dkIiCg4EvgbtJpw+8GQIhTrTOlCY4voKD95KKZt7nE
	7r4DF3TForwpiS2c9xVAA==
X-ME-Sender: <xms:uPspaQ8ThisG_B22jbKylJgSviNTpkkUbEgL_tv0hGIybayk1i1q5A>
    <xme:uPspaaPBqhYjcjvZqVGKkcQwd282ffxDvhE_QYEdupLb584ZzBZR4woKEDRz8o5XH
    FVgXXvcAODRj4KKu2_fomB3FXxYod4pnQ34GXeE-eaO41Hc_knm6Q>
X-ME-Received: <xmr:uPspaWGhBiJyYW9Trefk1OKK4TLLjkODcthBHVgb5RFpWN9VDG49-DnE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvhedtjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhepfffhvf
    evuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucghihhllhhirghm
    shhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepte
    etudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudethffhnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshh
    griigsohhtrdhorhhgpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopegrlhgvgiesshhhrgiisghothdrohhrghdprhgtphhtthhopehkvhhmse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
    pdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:uPspaQQ2OFmr21Qthg4S5ytLDjRaRzYZy_ptSCZI4k2xMupE1ajQjQ>
    <xmx:uPspabvfXxfU5lgAFiISQtjX7O_iKGSSUwsqVxAXD0XaqnMrIPajFQ>
    <xmx:uPspaQKGqXjNn9CN4Ecmh1u5D7Ghr-LUzk8Gp2JCnWU_UQzaIYKaRw>
    <xmx:uPspaYk1Lz2eobB7JCgJ_0diQ_AvC6C4wGAr4rYcp0g3PGtyKVp84w>
    <xmx:uPspaTL2Mz4LKDAlQFLotxWJ-7SfCSPEdyGFa7JQCWidwbwZF4EEPMle>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Nov 2025 14:44:55 -0500 (EST)
Date: Fri, 28 Nov 2025 12:44:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: alex@shazbot.org
Cc: kvm@vger.kernel.org, jgg@ziepe.ca, kevin.tian@intel.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Use RCU for error/request triggers to avoid
 circular locking
Message-ID: <20251128124449.37a27d86.alex@shazbot.org>
In-Reply-To: <20251124223623.2770706-1-alex@shazbot.org>
References: <20251124223623.2770706-1-alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Nov 2025 15:36:22 -0700
Alex Williamson <alex@shazbot.org> wrote:

> From: Alex Williamson <alex.williamson@nvidia.com>
> 
> Thanks to a device generating an ACS violation during bus reset,
> lockdep reported the following circular locking issue:
> 
> CPU0: SET_IRQS (MSI/X): holds igate, acquires memory_lock
> CPU1: HOT_RESET: holds memory_lock, acquires pci_bus_sem
> CPU2: AER: holds pci_bus_sem, acquires igate
> 
> This results in a potential 3-way deadlock.
> 
> Remove the pci_bus_sem->igate leg of the triangle by using RCU
> to peek at the eventfd rather than locking it with igate.
> 
> Fixes: 3be3a074cf5b ("vfio-pci: Don't use device_lock around AER interrupt setup")
> Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 68 ++++++++++++++++++++++---------
>  drivers/vfio/pci/vfio_pci_intrs.c | 52 ++++++++++++++---------
>  drivers/vfio/pci/vfio_pci_priv.h  |  4 ++
>  include/linux/vfio_pci_core.h     | 10 ++++-
>  4 files changed, 93 insertions(+), 41 deletions(-)

Applied to vfio next branch for v6.19.  Thanks,

Alex

