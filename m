Return-Path: <kvm+bounces-73-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE8B7DBCEA
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F7211C20A9B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 15:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA17A18C11;
	Mon, 30 Oct 2023 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ibwNRkuP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D275818C08
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 15:51:45 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E63BC5
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 08:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+bCSEQBMt4JRCYQtQgxuyMmFoW0l30ufcsqET7BSspCJq+ACnbrO3H/aOPmoZL1Wy8NgNtrJ/wCHumChIKIGIVazzVgsl1URKO7HTt3ZWAePMjwL5yrTjFZMFf2zRzCNse6wt1rB+ekLUubFTxH86YuHDv05XTaHF06iViu17sQGjaNIDNue4logdYRemaUkg7WzocwvgSqv3GfJG86zGysVrZ3alheQ06FSgud3yND4elWijYivp34ssqgbpmpTedLgipjqJWwem+nHaCirym2rV6flYh+U5b9Szi8EdoiKL2jcc7ddqpXXan9OXneLrzJpXOFo22tIZHMbmyrtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnhwi80NzQ8VDHjJwsD8X6FtsI5yPwq0DgRXrGbK9i0=;
 b=kkqR8QD5EfMsJXgfABPa4rqiaYII7DBcDb1/irgn8ZM8NGgTwscitNBj6nggQ0SZoI19NiQj/MziVoJQZAGDYvLsyd+FVbwAiF5n86dvq9yscYhwpwJhT3SEuNF0ACjp8RI30Aoo8E+chFOwMvs1b+BIJPYGRQDPE8oTotAbeuR79LrO5J8aA3v56Ur2k66TDZbp+MlowYvI5jXIXZFlZAUoLPBw+6RGMn13pWAvKbFwik0TVPSMPfz/BetWuJNTxo1hQAA4/F0CJiX+W6xOi6gtyhdX7IzXTK0Fe5xBY17iW1gE56RldZ76AFS+AnnVjhGhr7srxCSVLUOfJXEOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnhwi80NzQ8VDHjJwsD8X6FtsI5yPwq0DgRXrGbK9i0=;
 b=ibwNRkuP9FICpu9PVNzPmeDcHgvYgYW9/bnCviLe1zTffTX9vAyNYNfe7zztj5r2taqwRKANoHR9GWakM2rOb8WhLmWWVgjgeBsqLRcypdbKbkh1sM4RhG9xSv38cGtFBhpn762OvMZRAWx5u26jRWlG5y/ag/1toMphW0iqXimPpyjsPYqYZcZBOF2bWDFgjuccXn1/EGemVWn/inaaFiHgh06kjdwkZV89EHw8PZFiLVWwu88empUA9oi/5ueqmYeg+1xtZ19odfaCakwiFgwONCj7D7jncPqo2MD0n5DlgduMMyAJJC9Qi4LADaJawGWd/VFDDWn5I+z5d0J+mg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 15:51:40 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c%4]) with mapi id 15.20.6933.028; Mon, 30 Oct 2023
 15:51:40 +0000
From: Parav Pandit <parav@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Yishai Hadas <yishaih@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, Leon Romanovsky
	<leonro@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Thread-Topic: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Thread-Index: AQHaCoENkpIXTr9HoESn9KiFa24lo7BhNkgAgAFFedA=
Date: Mon, 30 Oct 2023 15:51:40 +0000
Message-ID:
 <PH0PR12MB54810E45C628DE3A5829D438DCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-3-yishaih@nvidia.com>
 <20231029161909-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231029161909-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|BY5PR12MB4212:EE_
x-ms-office365-filtering-correlation-id: 20eac121-911a-4769-8ecd-08dbd9601b60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 PdWLPxjjZiH9xMkBbbbwfTePS3WyTw0w+NwRQCGBmd6ayAqXuNIMRq6fWWghhy51rGi/8IxwB0FY/rqbOaLyaxAIYQa/I7/W8H+1I/owRwN+aGBpHV2KPVFXkyEJ4+jVuDTNXYR9JWjviLoaTAWefuvkDB64aZnIsm0QxxscmQpmdYkS6Wk8hVdsyAe6yaTqzf5Qz4O1aCk3LmJQEZ/YAhVY9q8DH3ezUWOjEm28Su1vIDrlnkWwK5SYk5bESmery0uoy+plYvjTEpxluyAQdclCqqWINpBwMSKTzd6SuS01HVP1umr6EDrY7U5LMaeB2lGXZcl2B34YvUiR0Mki4pbc8hd3jZMULOil/+G4TWdu4XrxZxICTYj8fVVs6NSNAweeweemib8SwDbzFSD6Up9yg2nBO5zsk9nUfu7nVeILe2VyaylMWwfjYxUS+lLcl3eYS/xus8G7pEllJq7WQT4ADGKEpxBpdHJ4EtQervMSEeQ/av9ek10wIweCm8XHKOdf9DrjXowNJzRlrsTC9hxGxoumOWsY8+G6KwBxQObvkOWnTd7pouNUzKVG+zSWai+oFLbrrZ13xK1E0eD4Ubt4Qu7kaU8rJ6/2o/VLQsamhjuv0YAWou7YG79UdyWI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(64756008)(55236004)(6506007)(7696005)(71200400001)(9686003)(478600001)(83380400001)(26005)(107886003)(30864003)(2906002)(5660300002)(66946007)(41300700001)(66476007)(54906003)(66556008)(66446008)(6636002)(52536014)(76116006)(110136005)(8936002)(4326008)(8676002)(38070700009)(316002)(86362001)(33656002)(38100700002)(122000001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zfBThOJcSMOKgpDLAQun0hCDTqLEnv969+ZvO7N6GBk2mt/2KdnzYUY6qi15?=
 =?us-ascii?Q?h80uM2PqGgUauE++25Wyh6Mu5LlMe0BGaRq4fBpMfuXzuK0s2Y3bFBl/hUoT?=
 =?us-ascii?Q?xC9VwUuX0qrzy82+xVstdJOfu+qINSU39shpVag1sTggWirzc/wGmf2A3u4o?=
 =?us-ascii?Q?MopzOWDMrBFHeG2uYXrnJ0NJwY1Z6AlP1UZyEXqG8w6SDqdDSMankHYyR2x+?=
 =?us-ascii?Q?W09/2syiOHxTXnFzle7G3K0XkLweUAoSXpvyr+6q3QCVqdPTu0hRQrRK+yok?=
 =?us-ascii?Q?LYY2G21ebeLkF16VWPdkCrtefsuldsQFvz323QUT3nl6I1iGCLQuqhtlH0UP?=
 =?us-ascii?Q?UrEohScucR//L1qpqaMK5mItNOxRw2CG6SUthEwm/osEx0zQGTve/t6RvBJE?=
 =?us-ascii?Q?ARnS4BzjhjHaTMJueth6zrDxU32PsxmpP4W1IoueXXHuH4g96nDHTMgvXF4B?=
 =?us-ascii?Q?LRHwUgLttMzLkV00ZjR2+frpnp6uVZRjoY2C8OmvmnLFl8mTg0PeijkFpgFX?=
 =?us-ascii?Q?l4CqVNcu14V/g0NZ5lZ53WaDRxcYcwU7NEzXW0k3vNdHPqes1TENvNyxirII?=
 =?us-ascii?Q?kIrCum6JgrJJR21YmE76ZsfVjU7UQbahSFijZOFfHo72/Ylvf05GCZDbvo2O?=
 =?us-ascii?Q?iHbSr8F8Y7ugSec3eQT/wu9id75FSb5tx/Ukn4QYFVP7UzvmD7RLei1igz4M?=
 =?us-ascii?Q?eIvMohQTrLjL6lx++2NcqZkdBzFp4Uhv9i4qnwcHjHccmg91PQMMlkA8QtQ+?=
 =?us-ascii?Q?c3hocLZ3saScd8/H4a6/XD0W2gM0UwnFjRXT/yswV24ac2/bup6sVEXH1yle?=
 =?us-ascii?Q?uXbIbh7gJ277llxkpFxMeZQeNKzbubF6QV604aBEPP3GFeA1mgH4QurdkXqY?=
 =?us-ascii?Q?ucFAJvkZzab9CSRE7R8IcNXf0bkXrw0mAsYxhVzYq/5EVlGBOHWa8k29bHRC?=
 =?us-ascii?Q?NFhTugznlXNj2awUYv0NyKGblLgTLiDhxiJoHe7TBjpEyty73xZ/++iXzjsq?=
 =?us-ascii?Q?/u15P3R6EjL9jEM4DkbCIukqkgk74rCfI/4b52EXwpUMs395luveF7bxUBId?=
 =?us-ascii?Q?Gz+8jTPIc+Q+ACLXecUrveElqzQmmboVSxF51h7j0sEtTWdgKnzEpg5+uLLr?=
 =?us-ascii?Q?Vplcb3E5jDCnCr7mifuXqFu9VVK0UG6Apx2P+Yl7F8axQN7MsLBiPy69CVnq?=
 =?us-ascii?Q?ZP4puj15aalUnrdpQ9rM8Hiqs1P9QTOWtwxnCJI2te2KgAyeXz3lZe0Uf55C?=
 =?us-ascii?Q?7UeQ7MyarqATuubLRIKAXY/WOKrDfQPDJO7D2K5YWvZFf534CrLksCUd8mc+?=
 =?us-ascii?Q?DWhTbuYMaSbduz4mB9fkAUc0gcPsWY8xOcWF8Rje6iVJpJApbiuRNm9Jioj2?=
 =?us-ascii?Q?RL94mKV03QpAZ5x66Bu35TExwSw2TF4bOf8VUDtDirwcNH301a8+Kh8LnVgD?=
 =?us-ascii?Q?VDcmoubPTmBwbNgxiXltxHveRRtr4Haw+iDmhyuffop3ZRtvoG8AX3KkdHFJ?=
 =?us-ascii?Q?AltOUxnmV2kDOe9MRjEBRJnLPIhKjrEMeCCfPORe1UjBqzw5tgk+KHNaW/BJ?=
 =?us-ascii?Q?XvzoIkpEIvH4cEm5wjY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20eac121-911a-4769-8ecd-08dbd9601b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2023 15:51:40.1916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STuvGtCo8NnA8A+x00X6p33JLFKPEDKlhRPD74bTOgVqi4Wgk4RvcthGNxP8Mf7qRgNkCYu3cBRv59ktX2jZlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Monday, October 30, 2023 1:53 AM
>=20
> On Sun, Oct 29, 2023 at 05:59:45PM +0200, Yishai Hadas wrote:
> > From: Feng Liu <feliu@nvidia.com>
> >
> > Introduce support for the admin virtqueue. By negotiating
> > VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates one
> > administration virtqueue. Administration virtqueue implementation in
> > virtio pci generic layer, enables multiple types of upper layer
> > drivers such as vfio, net, blk to utilize it.
> >
> > Signed-off-by: Feng Liu <feliu@nvidia.com>
> > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > ---
> >  drivers/virtio/virtio.c                | 37 ++++++++++++++--
> >  drivers/virtio/virtio_pci_common.c     |  3 ++
> >  drivers/virtio/virtio_pci_common.h     | 15 ++++++-
> >  drivers/virtio/virtio_pci_modern.c     | 61 +++++++++++++++++++++++++-
> >  drivers/virtio/virtio_pci_modern_dev.c | 18 ++++++++
> >  include/linux/virtio_config.h          |  4 ++
> >  include/linux/virtio_pci_modern.h      |  5 +++
> >  7 files changed, 137 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c index
> > 3893dc29eb26..f4080692b351 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
> >  	if (err)
> >  		goto err;
> >
> > +	if (dev->config->create_avq) {
> > +		err =3D dev->config->create_avq(dev);
> > +		if (err)
> > +			goto err;
> > +	}
> > +
> >  	err =3D drv->probe(dev);
> >  	if (err)
> > -		goto err;
> > +		goto err_probe;
> >
> >  	/* If probe didn't do it, mark device DRIVER_OK ourselves. */
> >  	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
>=20
> Hmm I am not all that happy that we are just creating avq unconditionally=
.
> Can't we do it on demand to avoid wasting resources if no one uses it?
>
Virtio queues must be enabled before driver_ok as we discussed in F_DYNAMIC=
 bit exercise.
So creating AQ when first legacy command is invoked, would be too late.

>=20
> > @@ -316,6 +322,10 @@ static int virtio_dev_probe(struct device *_d)
> >  	virtio_config_enable(dev);
> >
> >  	return 0;
> > +
> > +err_probe:
> > +	if (dev->config->destroy_avq)
> > +		dev->config->destroy_avq(dev);
> >  err:
> >  	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> >  	return err;
> > @@ -331,6 +341,9 @@ static void virtio_dev_remove(struct device *_d)
> >
> >  	drv->remove(dev);
> >
> > +	if (dev->config->destroy_avq)
> > +		dev->config->destroy_avq(dev);
> > +
> >  	/* Driver should have reset device. */
> >  	WARN_ON_ONCE(dev->config->get_status(dev));
> >
> > @@ -489,13 +502,20 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
> >  int virtio_device_freeze(struct virtio_device *dev)  {
> >  	struct virtio_driver *drv =3D drv_to_virtio(dev->dev.driver);
> > +	int ret;
> >
> >  	virtio_config_disable(dev);
> >
> >  	dev->failed =3D dev->config->get_status(dev) &
> VIRTIO_CONFIG_S_FAILED;
> >
> > -	if (drv && drv->freeze)
> > -		return drv->freeze(dev);
> > +	if (drv && drv->freeze) {
> > +		ret =3D drv->freeze(dev);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (dev->config->destroy_avq)
> > +		dev->config->destroy_avq(dev);
> >
> >  	return 0;
> >  }
> > @@ -532,10 +552,16 @@ int virtio_device_restore(struct virtio_device *d=
ev)
> >  	if (ret)
> >  		goto err;
> >
> > +	if (dev->config->create_avq) {
> > +		ret =3D dev->config->create_avq(dev);
> > +		if (ret)
> > +			goto err;
> > +	}
> > +
> >  	if (drv->restore) {
> >  		ret =3D drv->restore(dev);
> >  		if (ret)
> > -			goto err;
> > +			goto err_restore;
> >  	}
> >
> >  	/* If restore didn't do it, mark device DRIVER_OK ourselves. */ @@
> > -546,6 +572,9 @@ int virtio_device_restore(struct virtio_device *dev)
> >
> >  	return 0;
> >
> > +err_restore:
> > +	if (dev->config->destroy_avq)
> > +		dev->config->destroy_avq(dev);
> >  err:
> >  	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> >  	return ret;
> > diff --git a/drivers/virtio/virtio_pci_common.c
> > b/drivers/virtio/virtio_pci_common.c
> > index c2524a7207cf..6b4766d5abe6 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -236,6 +236,9 @@ void vp_del_vqs(struct virtio_device *vdev)
> >  	int i;
> >
> >  	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> > +		if (vp_dev->is_avq(vdev, vq->index))
> > +			continue;
> > +
> >  		if (vp_dev->per_vq_vectors) {
> >  			int v =3D vp_dev->vqs[vq->index]->msix_vector;
> >
> > diff --git a/drivers/virtio/virtio_pci_common.h
> > b/drivers/virtio/virtio_pci_common.h
> > index 4b773bd7c58c..e03af0966a4b 100644
> > --- a/drivers/virtio/virtio_pci_common.h
> > +++ b/drivers/virtio/virtio_pci_common.h
> > @@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
> >  	unsigned int msix_vector;
> >  };
> >
> > +struct virtio_pci_admin_vq {
> > +	/* Virtqueue info associated with this admin queue. */
> > +	struct virtio_pci_vq_info info;
> > +	/* Name of the admin queue: avq.$index. */
> > +	char name[10];
> > +	u16 vq_index;
> > +};
> > +
> >  /* Our device structure */
> >  struct virtio_pci_device {
> >  	struct virtio_device vdev;
> > @@ -58,9 +66,13 @@ struct virtio_pci_device {
> >  	spinlock_t lock;
> >  	struct list_head virtqueues;
> >
> > -	/* array of all queues for house-keeping */
> > +	/* Array of all virtqueues reported in the
> > +	 * PCI common config num_queues field
> > +	 */
> >  	struct virtio_pci_vq_info **vqs;
> >
> > +	struct virtio_pci_admin_vq admin_vq;
> > +
> >  	/* MSI-X support */
> >  	int msix_enabled;
> >  	int intx_enabled;
> > @@ -86,6 +98,7 @@ struct virtio_pci_device {
> >  	void (*del_vq)(struct virtio_pci_vq_info *info);
> >
> >  	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
> > +	bool (*is_avq)(struct virtio_device *vdev, unsigned int index);
> >  };
> >
> >  /* Constants for MSI-X */
> > diff --git a/drivers/virtio/virtio_pci_modern.c
> > b/drivers/virtio/virtio_pci_modern.c
> > index d6bb68ba84e5..01c5ba346471 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -26,6 +26,16 @@ static u64 vp_get_features(struct virtio_device *vde=
v)
> >  	return vp_modern_get_features(&vp_dev->mdev);
> >  }
> >
> > +static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
> > +{
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > +
> > +	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> > +		return false;
> > +
> > +	return index =3D=3D vp_dev->admin_vq.vq_index; }
> > +
> >  static void vp_transport_features(struct virtio_device *vdev, u64
> > features)  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev); @@ -37,6
> > +47,9 @@ static void vp_transport_features(struct virtio_device *vdev,
> > u64 features)
> >
> >  	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> >  		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> > +
> > +	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
> > +		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
> >  }
> >
> >  /* virtio config->finalize_features() implementation */ @@ -317,7
> > +330,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device
> *vp_dev,
> >  	else
> >  		notify =3D vp_notify;
> >
> > -	if (index >=3D vp_modern_get_num_queues(mdev))
> > +	if (index >=3D vp_modern_get_num_queues(mdev) &&
> > +	    !vp_is_avq(&vp_dev->vdev, index))
> >  		return ERR_PTR(-EINVAL);
> >
> >  	/* Check if queue is either not available or already active. */ @@
> > -491,6 +505,46 @@ static bool vp_get_shm_region(struct virtio_device
> *vdev,
> >  	return true;
> >  }
> >
> > +static int vp_modern_create_avq(struct virtio_device *vdev) {
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > +	struct virtio_pci_admin_vq *avq;
> > +	struct virtqueue *vq;
> > +	u16 admin_q_num;
> > +
> > +	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> > +		return 0;
> > +
> > +	admin_q_num =3D vp_modern_avq_num(&vp_dev->mdev);
> > +	if (!admin_q_num)
> > +		return -EINVAL;
>=20
>=20
> We really just need 1 entry ATM. Limit to that?
>
Above check is only reading and validating that number of admin queues bein=
g nonzero from the device.
It is ok if its > 1.=20
Driver currently using only 1 aq of default depth (entries) reported by the=
 device.

Did I misunderstand your question about 1 entry?
=20
> > +
> > +	avq =3D &vp_dev->admin_vq;
> > +	avq->vq_index =3D vp_modern_avq_index(&vp_dev->mdev);
> > +	sprintf(avq->name, "avq.%u", avq->vq_index);
> > +	vq =3D vp_dev->setup_vq(vp_dev, &vp_dev->admin_vq.info, avq-
> >vq_index, NULL,
> > +			      avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
> > +	if (IS_ERR(vq)) {
> > +		dev_err(&vdev->dev, "failed to setup admin virtqueue,
> err=3D%ld",
> > +			PTR_ERR(vq));
> > +		return PTR_ERR(vq);
> > +	}
> > +
> > +	vp_dev->admin_vq.info.vq =3D vq;
> > +	vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index,
> true);
> > +	return 0;
> > +}
> > +
> > +static void vp_modern_destroy_avq(struct virtio_device *vdev) {
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > +
> > +	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> > +		return;
> > +
> > +	vp_dev->del_vq(&vp_dev->admin_vq.info);
> > +}
> > +
> >  static const struct virtio_config_ops virtio_pci_config_nodev_ops =3D =
{
> >  	.get		=3D NULL,
> >  	.set		=3D NULL,
> > @@ -509,6 +563,8 @@ static const struct virtio_config_ops
> virtio_pci_config_nodev_ops =3D {
> >  	.get_shm_region  =3D vp_get_shm_region,
> >  	.disable_vq_and_reset =3D vp_modern_disable_vq_and_reset,
> >  	.enable_vq_after_reset =3D vp_modern_enable_vq_after_reset,
> > +	.create_avq =3D vp_modern_create_avq,
> > +	.destroy_avq =3D vp_modern_destroy_avq,
> >  };
> >
> >  static const struct virtio_config_ops virtio_pci_config_ops =3D { @@
> > -529,6 +585,8 @@ static const struct virtio_config_ops virtio_pci_confi=
g_ops
> =3D {
> >  	.get_shm_region  =3D vp_get_shm_region,
> >  	.disable_vq_and_reset =3D vp_modern_disable_vq_and_reset,
> >  	.enable_vq_after_reset =3D vp_modern_enable_vq_after_reset,
> > +	.create_avq =3D vp_modern_create_avq,
> > +	.destroy_avq =3D vp_modern_destroy_avq,
> >  };
> >
> >  /* the PCI probing function */
> > @@ -552,6 +610,7 @@ int virtio_pci_modern_probe(struct virtio_pci_devic=
e
> *vp_dev)
> >  	vp_dev->config_vector =3D vp_config_vector;
> >  	vp_dev->setup_vq =3D setup_vq;
> >  	vp_dev->del_vq =3D del_vq;
> > +	vp_dev->is_avq =3D vp_is_avq;
> >  	vp_dev->isr =3D mdev->isr;
> >  	vp_dev->vdev.id =3D mdev->id;
> >
> > diff --git a/drivers/virtio/virtio_pci_modern_dev.c
> > b/drivers/virtio/virtio_pci_modern_dev.c
> > index 9cb601e16688..4aab1727d121 100644
> > --- a/drivers/virtio/virtio_pci_modern_dev.c
> > +++ b/drivers/virtio/virtio_pci_modern_dev.c
> > @@ -714,6 +714,24 @@ void __iomem *vp_modern_map_vq_notify(struct
> > virtio_pci_modern_device *mdev,  }
> > EXPORT_SYMBOL_GPL(vp_modern_map_vq_notify);
> >
> > +u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev) {
> > +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> > +
> > +	cfg =3D (struct virtio_pci_modern_common_cfg __iomem *)mdev-
> >common;
> > +	return vp_ioread16(&cfg->admin_queue_num);
> > +}
> > +EXPORT_SYMBOL_GPL(vp_modern_avq_num);
> > +
> > +u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev) {
> > +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> > +
> > +	cfg =3D (struct virtio_pci_modern_common_cfg __iomem *)mdev-
> >common;
> > +	return vp_ioread16(&cfg->admin_queue_index);
> > +}
> > +EXPORT_SYMBOL_GPL(vp_modern_avq_index);
> > +
> >  MODULE_VERSION("0.1");
> >  MODULE_DESCRIPTION("Modern Virtio PCI Device");
> MODULE_AUTHOR("Jason
> > Wang <jasowang@redhat.com>"); diff --git
> > a/include/linux/virtio_config.h b/include/linux/virtio_config.h index
> > 2b3438de2c4d..da9b271b54db 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -93,6 +93,8 @@ typedef void vq_callback_t(struct virtqueue *);
> >   *	Returns 0 on success or error status
> >   *	If disable_vq_and_reset is set, then enable_vq_after_reset must als=
o be
> >   *	set.
> > + * @create_avq: create admin virtqueue resource.
> > + * @destroy_avq: destroy admin virtqueue resource.
> >   */
> >  struct virtio_config_ops {
> >  	void (*get)(struct virtio_device *vdev, unsigned offset, @@ -120,6
> > +122,8 @@ struct virtio_config_ops {
> >  			       struct virtio_shm_region *region, u8 id);
> >  	int (*disable_vq_and_reset)(struct virtqueue *vq);
> >  	int (*enable_vq_after_reset)(struct virtqueue *vq);
> > +	int (*create_avq)(struct virtio_device *vdev);
> > +	void (*destroy_avq)(struct virtio_device *vdev);
> >  };
> >
> >  /* If driver didn't advertise the feature, it will never appear. */
> > diff --git a/include/linux/virtio_pci_modern.h
> > b/include/linux/virtio_pci_modern.h
> > index 067ac1d789bc..0f8737c9ae7d 100644
> > --- a/include/linux/virtio_pci_modern.h
> > +++ b/include/linux/virtio_pci_modern.h
> > @@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
> >
> >  	__le16 queue_notify_data;	/* read-write */
> >  	__le16 queue_reset;		/* read-write */
> > +
> > +	__le16 admin_queue_index;	/* read-only */
> > +	__le16 admin_queue_num;		/* read-only */
> >  };
> >
> >  struct virtio_pci_modern_device {
> > @@ -121,4 +124,6 @@ int vp_modern_probe(struct
> > virtio_pci_modern_device *mdev);  void vp_modern_remove(struct
> > virtio_pci_modern_device *mdev);  int vp_modern_get_queue_reset(struct
> > virtio_pci_modern_device *mdev, u16 index);  void
> > vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16
> > index);
> > +u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev);
> > +u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev);
> >  #endif
> > --
> > 2.27.0


