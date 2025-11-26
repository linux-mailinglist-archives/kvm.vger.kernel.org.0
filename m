Return-Path: <kvm+bounces-64596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB50C881B9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B43AE4ECA72
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 04:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6F627056F;
	Wed, 26 Nov 2025 04:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PCkl2Z3n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="adgDSPtZ"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D2F212564;
	Wed, 26 Nov 2025 04:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764132853; cv=none; b=rpXqlSKGDErV1t7HQh508Jh8quG7HMpDi//ZfWCuHOmeHW52AwcmnnIqkYLiUnH0d5rA1vrqpBSN6Z+ZEjfG4mxwp1G/HjGGqzd+RkDeZ7eLLnrJyepXHD5UQPobFHYkreGXUOZ1vUAZ9VxPYRJ+r0jbZr9mFzrfF6QiNXkILYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764132853; c=relaxed/simple;
	bh=azYVioa3PoS1KXDSbFJDNPE7YhRu7rDG6dcHIl5e1jU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NpL/7NJfsiNrMWXRrAvu9s1mZjTvJa7+KoUTb9R40Az+gQVBWDQdLZTQInJdv6+iijs7O7oQaTfHvxw0/VqRswciikO3PEeu/egHnpAZG2ohQbacFLYScKkY21o9167suSYgMdcxSQ0pulMcrWSFfg2n4w55PRiIRHRaHVQh0HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PCkl2Z3n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=adgDSPtZ; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BEEC4140026A;
	Tue, 25 Nov 2025 23:54:07 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 25 Nov 2025 23:54:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764132847;
	 x=1764219247; bh=OJapMed/C+yKNoaqUK0e+pVkzZmShWWGBcRCvt+tEqw=; b=
	PCkl2Z3nrmBIvFDwtTdC1Ab2kugXko8LUJMCqpCKfZsmYha+3hUvTcYSSQ60Yh5B
	I+RtYHz9LpMDX9hGE9Z+VAxLxPddaZVjC6GwcWEFYOp0vOmqolg92oMxc+AB9vuC
	u9ukKOJlAJL9c0iniSwQpUWQCtJ0VCwSFk2VnBnkB12fOGi+u9CXCTZCTo3p1Ssh
	jtuo/vBnOS0TbtZ+hTsG6k1JAeiGuyoOMK/xCbo4iYfxu+Vgaqm0EoJiFg5Qb/WL
	pKJiXjbq3hcj6OLBvJW8FEddBhlaE2pkP64GTos5PixzEx9lhzGDgGM0Ag7GlsOv
	PToxTSOpEpJZsu07oYTbHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764132847; x=
	1764219247; bh=OJapMed/C+yKNoaqUK0e+pVkzZmShWWGBcRCvt+tEqw=; b=a
	dgDSPtZs6ph4YK5E+5pMvWuEkBmrm3PhcZXMbiopnn0wG7OFGNWOqZRANODGjjml
	RZJioK1OWNMi4/ps2cvNyGXSFhbrZE3OzgFJnZwaUv6CLhuwMb52A7hDrF66wQck
	Qj09pCagupdhYN/py1enXKqlifPhg924EGZal8BuQROsEwUj58xISmiw63taSlzq
	sMKQGJcMq2CXysrkNAXLmfiAj+KNTweBw0dh4rcwuLuIQqaM1lBrWs5dMrThaNlB
	tqn62jyzRo4+x8vwpfOyG+5s+1TLTf/k7JAC4uhYfgWePa2Tt2wQodFNKL9eY21F
	VIK4cZGHhET1KAQjn54ig==
X-ME-Sender: <xms:74cmaX6va6Irg8iN8JkG_xVUV1o6-QUobWlFCMW1Yoxjl-NIezvgeQ>
    <xme:74cmaX79iGWrL-qzll8sQHh9KCIhvfRlG0Dhg9IwiDG4bY_7EfghzdvrNgKa6MCxs
    ryuV8n6kGabRzUPyxfGTMmUEKFHcM0F96Et6oBQ3irHtQW_maH3eA>
X-ME-Received: <xmr:74cmaVF1AxLEtRr_0ZSEwdK7gkGr1GVeuK13HkANanx6WwpcGko9pCGbivY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeefgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgfffvdefjeejueevfeetudfhgeetfeeuheetfeekjedvuddvueehffdtgeej
    keetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedvhedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopeihihhshhgrihhhsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehskhholhhothhhuhhmthhhohesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghp
    thhtoheprghnihhkvghtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepvhhsvghthh
    hisehnvhhiughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtgho
    mhdprhgtphhtthhopeihuhhngihirghnghdrlhhisegrmhgurdgtohhm
X-ME-Proxy: <xmx:74cmaVzL1CpYrx01Dx9DazvOHoLzUqiRRMuTmLLHOYEdeJWSSv-t3A>
    <xmx:74cmaV1kEPygFLjEp2gn4wpSecgn_oaht_oeuDL7MXZm0Pb48B4GRg>
    <xmx:74cmaYN4hJFvsHt8BEp-obgEDOtGaOyshS5lkCN3ZXEXPmVBls3dYA>
    <xmx:74cmaRtOu9R_P4JSUJKiG9i-A1JpkhCoVi1VuTPJyXf_FiY45u_dLg>
    <xmx:74cmacn-9bqHDCcQD6Dq_FNYFC7EMR89QK4br8mN-ddT2spwWqtSnMTa>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 23:54:05 -0500 (EST)
Date: Tue, 25 Nov 2025 21:54:04 -0700
From: Alex Williamson <alex@shazbot.org>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>,
 "Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "zhangdongdong@eswincomputing.com" <zhangdongdong@eswincomputing.com>,
 Avihai Horon <avihaih@nvidia.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "pstanner@redhat.com" <pstanner@redhat.com>,
 Alistair Popple <apopple@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>,
 Dan Williams <danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
 Krishnakant Jaju <kjaju@nvidia.com>
Subject: Re: [PATCH v6 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Message-ID: <20251125215404.14c969be@shazbot.org>
In-Reply-To: <SA1PR12MB7199DF7032D570B5C610FD60B0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-6-ankita@nvidia.com>
	<20251125135247.62878956.alex@shazbot.org>
	<SA1PR12MB7199DF7032D570B5C610FD60B0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2025 03:26:54 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >>=C2=A0 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
> >> =20
> > /*
> > =C2=A0* Comment explaining why this can't use lockdep_assert_held_write=
 but
> > =C2=A0* in vfio use cases relies on this for serialization against faul=
ts and
> > =C2=A0* read/write.
> > =C2=A0*/
> > =20
>=20
> In this patch or the next where we actually do the serialization with
> memory_lock?

When the interaction is added would make more sense.  Thanks,

Alex

