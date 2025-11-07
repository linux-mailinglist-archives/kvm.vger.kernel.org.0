Return-Path: <kvm+bounces-62271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A6FC3E744
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 05:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A9E73AD837
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 04:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE052749C9;
	Fri,  7 Nov 2025 04:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="E3BzWP4a";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LJyDMq8o"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA3218EB1;
	Fri,  7 Nov 2025 04:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762490104; cv=none; b=YKCIAVX2jrN/b6Ox0dmJPyfBST+emfhpHXclOwuXQoLlst9Z1zr6PKeNJABR9+z1ub1QXQFXk7psYhLiy7dsEKN3D5y47D2VfnJfgv2/b2YkBhiojIXNjpku+Vo1ZiP6vwU34rZmEX0yjgFvnCZVaRShSaHjRz79Q6APLE2YSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762490104; c=relaxed/simple;
	bh=W1wqGjzdfUq2Mhwa0s66M2u7rWFpJDN0HNv9wCtndjs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPto6F1E8NxWwoxhxRk2jnEIy3mQALKPl5o9CNc1pHZJnHtswseFKccTbkeFcp37aVlGtJDJ8SwHSTg+BzeeXppIe61eKX78tiCxva5OrX+gpbd7DIbbqQR1hC3P9fZ8Hcham3+7gb+leU3oOTwisGPgpAdjGHpYAmQVlpJSmyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=E3BzWP4a; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LJyDMq8o; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 53BB37A012A;
	Thu,  6 Nov 2025 23:35:01 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 06 Nov 2025 23:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762490101;
	 x=1762576501; bh=uBH3uQqEnyr5owZWF+hSXhOInCPe2pAJka5AOENTYd0=; b=
	E3BzWP4awfQwh+NRZXtyh4kV8LdMnQiQeWdOv7njbi+gNPa8WQmrhHtgBikpCRr1
	S8ZKGGH8nVPA6LyI9LsAuk32z5y8KT+VFs5B2EaD4dLACqJxsSDpfMOAUMyFKHly
	tJdlvPNfmJ8pYipTel33Dwz7W4kenLDe0ZgfY2W8gsn+NMzY1ThcOPjFzcr+dhgz
	xWUU4LgMsXoKYwvnITLR6nElSF0hmwS56P8dgJ0HsyZRmLCGATdqBEpo54aCcPRs
	UF+N5NkQDxTv1PLGabfjZ98mq8SC2z0/smsa7V40d6L3j3nk7PrvIuB+1QVSxgAs
	t4MN5CfDC0pi+Df3f9RVJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762490101; x=
	1762576501; bh=uBH3uQqEnyr5owZWF+hSXhOInCPe2pAJka5AOENTYd0=; b=L
	JyDMq8o1Ct6vh8tTXiN2TqXxCKuTVxQgIoaMFRziebImnnz2pEErDSioWbw/TIun
	vLeeknaKVDUTELUCWInFJmIE++K5Ik/2PpQdIM1mFr3JNMxF3gyNv72yjt0mVsT/
	N2xmE0E+Nit2FMpHXPGnZioSFbAz2qLTbx7kNYN/E+FW/2kU/F4q1PO0NDurON+v
	/koOjDwekG6dw8zIrSre9c4ecvkMfTH/dfuweDwXTUrrHJSZJicvJRSarUi/LqkT
	00GBDp10aW/HUmj0KfPYAx1errq79ir/XM73w+xUg/bJyJy6vwT0HgTyusTbl9hf
	PeYfL+wGn3OBAL+F4EslA==
X-ME-Sender: <xms:9HYNaR9r0HsJFbkWkxU_1o5U_DIUdo0GdND3as9HBap1YqsytKwAaw>
    <xme:9HYNafuTeA9LbR3vrrNmsTY2GUiF9LK0dWemkpwWw0OFtLvqEsu0ATX48sjHAROrE
    XKzr-QGjQ0vjRP6voKDIyORc_LBLPPJ-UOQGTMVdVn-dDuaMww>
X-ME-Received: <xmr:9HYNaVoS7SiggUjMknqaYF9481vf42fP0sgXYn0ptx0jrUdRi88wGodL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeekjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeekpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehrrghnrghnthgrsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopegrlhgvgidrfihilhhlihgr
    mhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhulhhonhhgfhgrnhhgse
    hhuhgrfigvihdrtghomhdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepjhhrhhhilhhkvgesghhoohhglhgvrdgtohhmpdhrtghpthhtoh
    epkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhk
    vghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9XYNaTqqHUN-AfAxdySVMgpMXSibZtHKj51Ehgeu8BnMegsULkoZmA>
    <xmx:9XYNaUbnzPZ-hTkQVa_RqmSq8ALzFufEu9s4g-4tJ4SH_8HyaAd8BQ>
    <xmx:9XYNaR89Q0hbsRYa82Iqw9u5TWBJqzmmWt6b4lNz-4qQ4_UssnxAMg>
    <xmx:9XYNaSm1PO8lkS01zK8jRqWGJGxLdTTXZ4RkU7peHUo-ca6RMC550Q>
    <xmx:9XYNafpC1crq4m9wrBsXvJ7BnQ1ZbicK90J0jM5Kbvfohpw76Gdbz68b>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 23:35:00 -0500 (EST)
Date: Thu, 6 Nov 2025 21:34:59 -0700
From: Alex Williamson <alex@shazbot.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson
 <alex.williamson@redhat.com>, Longfang Liu <liulongfang@huawei.com>, David
 Matlack <dmatlack@google.com>, Josh Hilke <jrhilke@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] vfio: Fixes in iommufd vfio token handling
Message-ID: <20251106213459.3c2a59a8.alex@shazbot.org>
In-Reply-To: <20251031170603.2260022-1-rananta@google.com>
References: <20251031170603.2260022-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Oct 2025 17:06:01 +0000
Raghavendra Rao Ananta <rananta@google.com> wrote:

> Hello,
> 
> The series includes a couple of bug fixes that were accidentally
> introduced as a part of VFIO's vf_token management for iommufd.
> 
> Patch-1: Fixes ksize arg while copying user struct in
> vfio_df_ioctl_bind_iommufd.
> 
> Patch-2: Adds missing .match_token_uuid callback in
> hisi_acc_vfio_pci_migrn_ops.
> 
> Thank you.
> Raghavendra
> 
> Raghavendra Rao Ananta (2):
>   vfio: Fix ksize arg while copying user struct in
>     vfio_df_ioctl_bind_iommufd()
>   hisi_acc_vfio_pci: Add .match_token_uuid callback in
>     hisi_acc_vfio_pci_migrn_ops
> 
>  drivers/vfio/device_cdev.c                     | 2 +-
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787

Applied to vfio next branch for v6.19.  Thanks,

Alex

