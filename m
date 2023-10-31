Return-Path: <kvm+bounces-187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BF07DCC9E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 13:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D967A1C20C4B
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 12:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFB31DA41;
	Tue, 31 Oct 2023 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uXkP8ogr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86464110E
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 12:11:39 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E822991
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 05:11:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ec3/se91ZrS/aCSfs+YQowDvY9RvGmbn3rnSY2Ie5aHGIEN/mSjx7fQzpmitFby4tU2VB9SDh4RbX1Sf2lST73eeUbUxdCroD0M9QF6IJbdVVv/1yYw+FUcpdI6O6292HHWMiM6Yt0cc2gmAk/qenhzyZQUoBZ9csj7yyEHumF7DqI+OCpjJ36N4CfDEgmatTQWiCcjaCYK86hPTEgWx0KVDwi32D/nM6BRxyZYqaod0ZqeVuzDVMyHWNYpurxnn/8QCRTQGkhzsfPQtbMYyzOcaZSmI22y2CX9ZcAC8FOPjhoJFKgNbVes0cCJM1WcTsdAiSmdZY6zuQMEGbW2C8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrwZ3jo1bVCDLyyermtLPlwIjJR82tpyaOrCanpwM3E=;
 b=e8zuGbGDGeQkP7m9PdqcFuPVLedYwWd6SkBSJbE2HYtwCETf+DvzA8X7+0OcpQfVR/ZrPYYxANPQajU94IbjooMGIcJ8F8+6nmoj9T5hDNAluANVgWAh8IJmmAkPtKnbCWPGjtLYnIuZwyhgB7frZocAanSUo60MKnRYln7jfaPL3x2Jv1yZMY2J4YfVYvfwjSYS7ajQp8u4pjjW+WvEQfWWTGeQ+4F4IXHv6fzZEZCN6VyVXLIo1ocX8XEjQkZwdHeGwAWswv9EjjBu+4Y0FkKifHygdvqQ/UavFPSemXSWwa3adGEX9JXi13Ei/yQo18KZEUd7qTmZEnXfESToAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrwZ3jo1bVCDLyyermtLPlwIjJR82tpyaOrCanpwM3E=;
 b=uXkP8ogrZuyM0NXKHigz/mn4j/nx+bIizre83/bCVJOXOrrvyw+M14p3fblvj3ftdzMIp5GgSq+ExI+Gl1xejMXZbh1jrSoiyvpwXcrEip+ysFBAcjw4RCxYcBmNFTsWDtkTExAOa2UCThOQmSjc4E0AQwkvCbfDi3My8GMeBuGEpGs6SzeTdAjwkHDJH7/EQFztsKV/A6Lsp+dr/WqGI1zTqNOCIf8xPG3LOG4X6MoVOTNCbV3MOjgWbCRDpj9O3F1Zl8dl1gduSbBw+F8ClO6XoT+FWF3p5qm6aK6SpxC0+/+vRduz6CVUVckrqwCY7fqRrlMwa4DLaXsV+YK1cg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA0PR12MB8327.namprd12.prod.outlook.com (2603:10b6:208:40e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 12:11:34 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c%4]) with mapi id 15.20.6933.028; Tue, 31 Oct 2023
 12:11:34 +0000
From: Parav Pandit <parav@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, Leon Romanovsky
	<leonro@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Thread-Topic: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Thread-Index:
 AQHaCoENkpIXTr9HoESn9KiFa24lo7BhNkgAgAFFedCAAANWgIAAI7/QgABanACAADw/IIAAUYgAgABCCrA=
Date: Tue, 31 Oct 2023 12:11:34 +0000
Message-ID:
 <PH0PR12MB54810728B89DCF1F958E9274DCA0A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-3-yishaih@nvidia.com>
 <20231029161909-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54810E45C628DE3A5829D438DCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231030115759-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548197CD7A10D5A89B7213CDDCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231030193110-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481F2851BF40C5BBD59909CDCA0A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231031034833-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231031034833-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|IA0PR12MB8327:EE_
x-ms-office365-filtering-correlation-id: f2f5e49d-8033-415d-1f4f-08dbda0a86bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 VlNbfQhiq/eYlDv3St4OMHgz82O/DmuJUssynT7wQvj/1v6HdHYkfYRLmfUe52p3t9gv/w3NFGWhIsxtl84bwYF7ZGVfnLAXRA19wpvh6zQ9WmLPuYNgp7R9XTve/eJME8HNy0WpL+8HqzT07JSJ9oAIKX6yOg6ST9DmzqhW8LyoTvlTTzNru7mheXqMOLpfPMabalGL5jkcqf8eGPEMAjKljjKslRjNQk6EhwbmpisWArbufsTEFJH4VM4CFwGrPJvXkX9Sl7BPgh7E+VrBxjxtc1yx8gvVjgHnsShjwEBAjFL8d0dpEmsGI4/i5w9ajSXtxBImwlEoYmFJOLbxipOY5MO+duwYK1ixCTMM4WwnJQrowB2WFWvE3aMpZkkOTrg8089KviCkWeUfGGTnfH6aLE0ue4K7fo24KISYyyDTSJQlHn9wYi8oxODFvTJmY93+ZD1844HUHC+SjqrbcW6W6ss9qzurX65U1WxoUu0gR+ckW+GgWLPtbjFiDmNq52WKkZ+q5oNhy43Txiv+tZuDF0aaD++W7d7brycuAml7okDahDxr6pypPDIG9s4vdsgDCVXkQJj1xGYev06LXDl6pOKM9ITv8e/+pvSp2I/n/GS/GEQEgcC/OV4yjUUH
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(39860400002)(136003)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(38100700002)(478600001)(9686003)(122000001)(6506007)(7696005)(55016003)(33656002)(83380400001)(107886003)(71200400001)(26005)(54906003)(66446008)(64756008)(66556008)(66476007)(76116006)(66946007)(6916009)(316002)(66899024)(5660300002)(41300700001)(2906002)(86362001)(8936002)(8676002)(4326008)(52536014)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?knEGi//h5B46ciWPpd4L9jSKL8lklQ+hnUbHoyEt3JfIV9MyzuxILo+vkclD?=
 =?us-ascii?Q?KBZEqYzRjzmREA/hCARX9uCBjFZ45wGqJSVO8jgob3EMyOU3z4HoQZ8M4lF4?=
 =?us-ascii?Q?/k8RwE3Nbn70umGbssuc3tPw0+O4ODPXUZLocxcq1Bt4xn7+2kaL5eVq+tl1?=
 =?us-ascii?Q?/TdqJXuVIh1NxZqASHcHCUt2jpenQSeKTI4a+eBU+VxM2cCG6SUq5hUVvFq+?=
 =?us-ascii?Q?tgubPdtIVVc9Qy32U4rZ2RiY+jUy5kMcwhBdJqbxZW/SsbiB/Omi6gLVV5Ub?=
 =?us-ascii?Q?3oTkITMruXrvUqVg/1uc1x/ltEsEHsn0ViqjTbkZqre518ojWtMlvzBQI3YZ?=
 =?us-ascii?Q?g7bTpaafEAGrq+0eDJmwhevfwcP+nBT9J95YpOs/SjoRzhyYa/CpU2FATYpW?=
 =?us-ascii?Q?o0JEfbqLmfmPHgGXkzR25MapgglOKT0EOMLvP8qJOku9FarrIpQEoTYy66md?=
 =?us-ascii?Q?fQvQgmWvJgcqS9gg3qobPKNzDLITg3WAEtjDRfrq18VyXyefWL24G1EjeNU5?=
 =?us-ascii?Q?/X+dYUEi9Uj22k6XKS8+D6HnZGo50b8FiJLPv1dgLrxVpi2SX1JzRQMQu5kB?=
 =?us-ascii?Q?fG5qU/BbQTGOWe/fjQn7jr0Eta6k7cRqemYZV6HCcU88d/MCGiLYfM6UDAQo?=
 =?us-ascii?Q?S4fmtbGFecDlgp5Y/v1a+4luBTuej7E6l9AXcCxCJhJpIr+sO3pi/nzV50QD?=
 =?us-ascii?Q?OQ14d8LosWRzOn2KlTg14orZ95yyT19xiLZH7bQmqykx4BKBidfBGK9tH8NH?=
 =?us-ascii?Q?QUVzccNkm+lFmgQVAjdAqJdnQuMUhxCqcgDIYU/WPj5oCkkrsvdJVt9ZbzvM?=
 =?us-ascii?Q?v/eLOuD1FUlGJZJiO7nz8F/syxgNwjl7+FDLls2dsWtPN5Xar4Msw7LWhLOn?=
 =?us-ascii?Q?oTAPjjMkhIaS7TX6iZC65afHKRMrnh0OwTIaeSCmMV8t30Ng1iaMcYtByRVK?=
 =?us-ascii?Q?VZgQOHbrG0MUmC0smYFscrsK+2kKQfL7aZAsUQeiirZso3J7ucCD5MDPlSvS?=
 =?us-ascii?Q?/JnX8vCsDO4PRDT8RqdgPnuInT/sECJJ8EJ47tEsP8nVSXOiASyFvZdWxBdn?=
 =?us-ascii?Q?5TWe8yoAC3t0HZle/zZT4I54Y4pih92E/zuX573oVbzVgcMzEhG/bhdjEkKx?=
 =?us-ascii?Q?QLFryETkQncyvdGrmI6JYsbz7gypUn3sY/Sob+Mvt3KlL45n6UK/pR8wjrFX?=
 =?us-ascii?Q?ssBF+OkaI2+oQrujoPXW7KuzgtgzNpMxqER8Xq3HklBPKcS6pm8IfBX7QDE9?=
 =?us-ascii?Q?wEoJjRW7wgTtQOkpTNoO7hCkHcBIDjSS2X4KLxV0/rMJt4l0NvTEgJ9BUX8b?=
 =?us-ascii?Q?qzNxtXUylbqD3O/GNgrjU8B49Lze1susoN4ahIyNVu40kGHVrSGbqXYpDy50?=
 =?us-ascii?Q?Y62Rpc5yeJsz06KmJA7Q/RQptiSib3uUZJwK9BCZOmBbDVGM1a8/enricnTm?=
 =?us-ascii?Q?/TLB2qlwr5EZ6/QZYetKo4lafvVPiSlF7s6rbGjc6Fb4+b7P+yfZ5lxXwlRB?=
 =?us-ascii?Q?A0rdwA6ySL262r0NuN1aPeh978du8vLmKIhryzJU2fllY9RwOuhovjgLGFP5?=
 =?us-ascii?Q?DjCWa5L1pDb5jbbPs2A=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f5e49d-8033-415d-1f4f-08dbda0a86bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 12:11:34.7616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWcLPq3wolg9L+9sukceVF9viriftGA5PtzoqJUcKRNsW11Hks4GTblO7oIwy9dznncN3cLdEpXn+iYnNnm4Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8327


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Tuesday, October 31, 2023 1:29 PM
>=20
> On Tue, Oct 31, 2023 at 03:11:57AM +0000, Parav Pandit wrote:
> >
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Tuesday, October 31, 2023 5:02 AM
> > >
> > > On Mon, Oct 30, 2023 at 06:10:06PM +0000, Parav Pandit wrote:
> > > >
> > > >
> > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > Sent: Monday, October 30, 2023 9:29 PM On Mon, Oct 30, 2023 at
> > > > > 03:51:40PM +0000, Parav Pandit wrote:
> > > > > >
> > > > > >
> > > > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > Sent: Monday, October 30, 2023 1:53 AM
> > > > > > >
> > > > > > > On Sun, Oct 29, 2023 at 05:59:45PM +0200, Yishai Hadas wrote:
> > > > > > > > From: Feng Liu <feliu@nvidia.com>
> > > > > > > >
> > > > > > > > Introduce support for the admin virtqueue. By negotiating
> > > > > > > > VIRTIO_F_ADMIN_VQ feature, driver detects capability and
> > > > > > > > creates one administration virtqueue. Administration
> > > > > > > > virtqueue implementation in virtio pci generic layer,
> > > > > > > > enables multiple types of upper layer drivers such as vfio,=
 net, blk
> to utilize it.
> > > > > > > >
> > > > > > > > Signed-off-by: Feng Liu <feliu@nvidia.com>
> > > > > > > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > > > > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > > > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > > > > > ---
> > > > > > > >  drivers/virtio/virtio.c                | 37 ++++++++++++++=
--
> > > > > > > >  drivers/virtio/virtio_pci_common.c     |  3 ++
> > > > > > > >  drivers/virtio/virtio_pci_common.h     | 15 ++++++-
> > > > > > > >  drivers/virtio/virtio_pci_modern.c     | 61
> > > +++++++++++++++++++++++++-
> > > > > > > >  drivers/virtio/virtio_pci_modern_dev.c | 18 ++++++++
> > > > > > > >  include/linux/virtio_config.h          |  4 ++
> > > > > > > >  include/linux/virtio_pci_modern.h      |  5 +++
> > > > > > > >  7 files changed, 137 insertions(+), 6 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/virtio/virtio.c
> > > > > > > > b/drivers/virtio/virtio.c index
> > > > > > > > 3893dc29eb26..f4080692b351 100644
> > > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > > @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct dev=
ice
> *_d)
> > > > > > > >  	if (err)
> > > > > > > >  		goto err;
> > > > > > > >
> > > > > > > > +	if (dev->config->create_avq) {
> > > > > > > > +		err =3D dev->config->create_avq(dev);
> > > > > > > > +		if (err)
> > > > > > > > +			goto err;
> > > > > > > > +	}
> > > > > > > > +
> > > > > > > >  	err =3D drv->probe(dev);
> > > > > > > >  	if (err)
> > > > > > > > -		goto err;
> > > > > > > > +		goto err_probe;
> > > > > > > >
> > > > > > > >  	/* If probe didn't do it, mark device DRIVER_OK ourselves=
. */
> > > > > > > >  	if (!(dev->config->get_status(dev) &
> > > > > > > > VIRTIO_CONFIG_S_DRIVER_OK))
> > > > > > >
> > > > > > > Hmm I am not all that happy that we are just creating avq
> > > unconditionally.
> > > > > > > Can't we do it on demand to avoid wasting resources if no one=
 uses
> it?
> > > > > > >
> > > > > > Virtio queues must be enabled before driver_ok as we discussed
> > > > > > in
> > > > > F_DYNAMIC bit exercise.
> > > > > > So creating AQ when first legacy command is invoked, would be t=
oo
> late.
> > > > >
> > > > > Well we didn't release the spec with AQ so I am pretty sure
> > > > > there are no devices using the feature. Do we want to already
> > > > > make an exception for AQ and allow creating AQs after DRIVER_OK
> > > > > even without
> > > F_DYNAMIC?
> > > > >
> > > > No. it would abuse the init time config registers for the dynamic
> > > > things like
> > > this.
> > > > For flow filters and others there is need for dynamic q creation
> > > > with multiple
> > > physical address anyway.
> > >
> > > That seems like a completely unrelated issue.
> > >
> > It isn't.
> > Driver requirements are:
> > 1. Driver needs to dynamically create vqs 2. Sometimes this VQ needs
> > to have multiple physical addresses 3. Driver needs to create them
> > after driver is fully running, past the bootstrap stage using tiny
> > config registers
> >
> > Device requirements are:
> > 1. Not to keep growing 64K VQs *(8+8+8) bytes of address registers +
> > enable bit 2. Ability to return appropriate error code when fail to
> > create queue 3. Above #2
> >
> > Users of this new infrastructure are eth tx,rx queues, flow filter queu=
es, aq, blk
> rq per cpu.
> > AQs are just one of those.
> > When a generic infrastructure for this will be built in the spec as we =
started
> that, all above use cases will be handled.
> >
> > > > So creating virtqueues dynamically using a generic scheme is
> > > > desired with
> > > new feature bit.
>=20
> Reducing config registers and returning errors should be handled by a new
> transport.
> VQ with multiple addresses - I can see how you would maybe only support t=
hat
> with that new transport?
>=20
PCI is the transport that offers unified way to create and destroy dynamic =
VQs. And modify/query VQ attributes.
Unified across PFs, VFs.

So no need for some grand transport. Virtio spec already underlying infrast=
ructure that can be extended for PCI.
For example,

VQ attributes are already modified and queried by CVQ for net already.

Such create/destroy commands can easily be supported on cvq.
(cvq already exists on 6 out of 18 virtio devices).
Rest 12 devices are so small which will unlikely need dynamic vqs.

All will be neatly tied to single interface between driver and device for V=
Q create/destroy/modify/query.

Anyway, this is the work OASIS currently doing for 1.4-timeline.
This patch is based on 1.3 standard update.

>=20
> I think I can guess why you are tying multiple addresses to dynamic VQs -=
 you
> suspect that allocating huge half-megabyte VQs dynamically will fail if t=
riggered
> on a busy system. Is that the point?
Yes, it is likely. I don't have the link right now, but Eric S and/or Saeed=
 had some links to it.

>=20
>=20
> In that case I feel it's a good argument to special-case admin VQs becaus=
e
> there's no real need to make them huge at the moment - for example this
> driver just adds one at a time.
> No?
In current form creating a VQ with single outstanding command with 4 descri=
ptors =3D 64 bytes is not that huge resource wastage either.

So Linux driver can adapt to dynamic aq and with multiple PAs can be done i=
n future when OASIS adapts to it.

