Return-Path: <kvm+bounces-9299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 272BC85D73A
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 12:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D85A285076
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 11:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A301246424;
	Wed, 21 Feb 2024 11:37:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEB40C04;
	Wed, 21 Feb 2024 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515449; cv=none; b=Vp6FPHxWgwov8BLkZtg9nOKUhFPHSNd3osbkB0ZU6XBIPpZYSW88ORchZapLzUE07Z7KhBj+Lr9w+db8BgXzEfnTh69teCqn30+5ATMyIP0nCNG+LyD23dhfGIKgepTY9antlAEHK1efpyjR2j5UQuErk5zaTN/zgVVrw5vbQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515449; c=relaxed/simple;
	bh=UDbteaw/i+JCOAl6Fun2vw1m/RM/qsD67b3kyaqjNr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=spQqVdE2kvtLHYBOusIZQk9Y8mHlJIW1lahYO2QLpzk1akDZ8RoeJc48I0UBsK1MjctcXt/uApRtsFW7LahGszyEVXjdlDykz3tm36clr10LXU7phva1j/kfGQXEB12Y3N6/9spYBs/HcYSJvm3nKDsjSXju4SFpJ4Qlf1hT9mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TfvJc0MqXz1FKbt;
	Wed, 21 Feb 2024 19:32:32 +0800 (CST)
Received: from kwepemd500002.china.huawei.com (unknown [7.221.188.104])
	by mail.maildlp.com (Postfix) with ESMTPS id C51BA18005F;
	Wed, 21 Feb 2024 19:37:23 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (7.221.188.251) by
 kwepemd500002.china.huawei.com (7.221.188.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 21 Feb 2024 19:37:23 +0800
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Wed, 21 Feb 2024 19:37:23 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Wed, 21 Feb 2024 19:37:22 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, xudingke <xudingke@huawei.com>,
	"mst@redhat.com" <mst@redhat.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "magnus.karlsson@intel.com"
	<magnus.karlsson@intel.com>
Subject: RE: [PATCH net-next 1/2] xsk: Remove non-zero 'dma_page' check in
 xp_assign_dev
Thread-Topic: [PATCH net-next 1/2] xsk: Remove non-zero 'dma_page' check in
 xp_assign_dev
Thread-Index: AQHaTqj5aHEEh4wXi06uw11VbniHk7EUM/IAgAChCpA=
Date: Wed, 21 Feb 2024 11:37:22 +0000
Message-ID: <0fce8b64808f4c6faa0eb60e44687c36@huawei.com>
References: <1706089058-1364-1-git-send-email-wangyunjian@huawei.com>
 <1708509152.9501102-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1708509152.9501102-1-xuanzhuo@linux.alibaba.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

> -----Original Message-----
> From: Xuan Zhuo [mailto:xuanzhuo@linux.alibaba.com]
> Sent: Wednesday, February 21, 2024 5:53 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; virtualization@lists.linux.dev; xudingke
> <xudingke@huawei.com>; wangyunjian <wangyunjian@huawei.com>;
> mst@redhat.com; willemdebruijn.kernel@gmail.com; jasowang@redhat.com;
> kuba@kernel.org; davem@davemloft.net; magnus.karlsson@intel.com
> Subject: Re: [PATCH net-next 1/2] xsk: Remove non-zero 'dma_page' check i=
n
> xp_assign_dev
>=20
> On Wed, 24 Jan 2024 17:37:38 +0800, Yunjian Wang
> <wangyunjian@huawei.com> wrote:
> > Now dma mappings are used by the physical NICs. However the vNIC maybe
> > do not need them. So remove non-zero 'dma_page' check in
> > xp_assign_dev.
>=20
> Could you tell me which one nic can work with AF_XDP without DMA?

TUN will support AF_XDP Tx zero-copy, which does not require DMA mappings.

Thanks

>=20
> Thanks.
>=20
>=20
> >
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > ---
> >  net/xdp/xsk_buff_pool.c | 7 -------
> >  1 file changed, 7 deletions(-)
> >
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c index
> > 28711cc44ced..939b6e7b59ff 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -219,16 +219,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> >  	if (err)
> >  		goto err_unreg_pool;
> >
> > -	if (!pool->dma_pages) {
> > -		WARN(1, "Driver did not DMA map zero-copy buffers");
> > -		err =3D -EINVAL;
> > -		goto err_unreg_xsk;
> > -	}
> >  	pool->umem->zc =3D true;
> >  	return 0;
> >
> > -err_unreg_xsk:
> > -	xp_disable_drv_zc(pool);
> >  err_unreg_pool:
> >  	if (!force_zc)
> >  		err =3D 0; /* fallback to copy mode */
> > --
> > 2.33.0
> >
> >

