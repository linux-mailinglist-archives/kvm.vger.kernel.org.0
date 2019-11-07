Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD7EF399F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 21:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfKGUig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 15:38:36 -0500
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:45510
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbfKGUif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 15:38:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrBpOEy560EdZrrTG04WwLBK5Idjdz0p6QlN8i/igOGlDK55UvKMMz3Pxx22tpIeEOstegQ0AalZeotSDBaRcfhhlIcikWHqPYPOQEiNc7iCm1wrTptgddxPgVfv5oDpGEvXjUDiwFgCFIo/qipGqu5KifVIp9G/82Sg3wtbYHi1rgoaCC0AUc6loCK5hZlJHCZ+P80iLrHOn/qv+YTaNeq5oKZh24HT9qwMiYmRog8xZakWl0ZLLvupn3WNKI1WE80cfI8RD1ewKiWGawqnEtOw8cVDpj4tacQGVu+BMpKdi8uvJ4VAMjOx/Jy1xI3c3f32Z7AsA0OSzHPQcR3alA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0JnrqRlrUyzvtcMsGpG/tZRFDaHdLuEZITIB0eiUvY=;
 b=L7lcTpr064qxbF9LQ/iRdUUx8H99DlZgEsv1o26v5S14PIDIMgQ+Okv9XgCf2Z9VGUEEXU5iyAIxPG1vxKTQgdhvkVYOXiTQAfcifSzxWxRZoohuF7GBrt0i7QF7KVMZL+PWw72qmHNr50EBVwn9oI+c7fk7oQbnkoC/UK5mPTpmQBPXeK+a7aXTJ6NAjXjDljiCzS5qBAD9h65aVjGcIB0n9+Lizqb67Ou5n3D3AQH5ARurjqkhlo67cdb0kRw7orBbL82nnJ6pd3riu5uk7FiiyZrZfyl1D4Y9Lg5JBUfFEOVl6NBw0qoXJ1a8AlRt6SxKnUWrp3OK7deceg6QcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0JnrqRlrUyzvtcMsGpG/tZRFDaHdLuEZITIB0eiUvY=;
 b=SjPimkv19z/hBCyAncej1RNTq4rGlwQ3LtfQjpKsQyU+7IzuhHRZb4V3BRqm0wyCUHgL3lqi9d1abs5k/0ArSKXgsSjXEHmpNs8n6481VkspKlB+i/cdY2c556vjbXgq3tJE/gccjbd05G7ArdJ5gutZ4nk4T0mM5kink1y0tP0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6436.eurprd05.prod.outlook.com (20.179.34.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 20:37:50 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 20:37:50 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikX93ntAS7QxEa+ZUX9CByqKKeAQaYw
Date:   Thu, 7 Nov 2019 20:37:49 +0000
Message-ID: <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dfb09258-c2c3-4983-a5c4-08d763c25b23
x-ms-traffictypediagnostic: AM0PR05MB6436:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <AM0PR05MB6436D68DB7ADF3191F06B569D1780@AM0PR05MB6436.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(366004)(376002)(346002)(13464003)(189003)(199004)(316002)(11346002)(486006)(110136005)(5660300002)(66066001)(966005)(446003)(14454004)(8936002)(81156014)(81166006)(54906003)(76116006)(76176011)(66476007)(186003)(66946007)(64756008)(102836004)(8676002)(476003)(7696005)(66446008)(33656002)(25786009)(478600001)(66556008)(99286004)(26005)(2501003)(229853002)(7736002)(305945005)(6116002)(6506007)(55016002)(2906002)(53546011)(86362001)(6306002)(6436002)(4326008)(71200400001)(71190400001)(256004)(3846002)(74316002)(9686003)(14444005)(6246003)(52536014)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6436;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lc7PyYe34MRtGCX5OxeqK7MpUCWaZcCfLaKWXhCFXArwL3o2Wo8g14mAm89o8O49+6PBQko7/7vuVMPplD4lE7CdME2R9kdtON8MbwEJscL2K43BRCyGMeazECHapJQVAOe264x4pb5VG9vAxhWG//CWCFbSiQrK2PQXDicB2l1bbiVymR61C0iEZl4hADdIE8FQW3/N1IOFwK9NwoQQn8vnUEgSVSFSpcplFD7N34TxxUZHTo6NsTRW/6n0q2jm5T3EMJ5y/Bk8TdsHsxlxZaQQAoz423Cvw9IW3mh2jeiDAuFsFOCM4OVHn4ymD9h90ReurY7XEqDTH1s7On4up9EZefppWAB1q5sTebTcc6ZsmtJEZbu/B7EWS/EvtiqabFmPpEqp0Gzpafg6fkT0jItzYEwf4/70SR3xH8Ug330+gBAlak2hzVRbeYpvMWKYFS08/1d8zG1snnzEO3VgWtQF1V0WGGm0oy7fkcBhjpE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb09258-c2c3-4983-a5c4-08d763c25b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 20:37:49.9363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mctpbe5Xc6jpAq0x4cRrCeUQWIZNI8eNutQ44Cm/+pPa8SveFPtrSTd/S72yye5OARruJJWMUbQ17Rr8tjvpvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6436
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Zhenyu Wang
> Sent: Thursday, October 24, 2019 12:08 AM
> To: kvm@vger.kernel.org
> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> kevin.tian@intel.com; cohuck@redhat.com
> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
>=20
> Hi,
>=20
> This is a refresh for previous send of this series. I got impression that=
 some
> SIOV drivers would still deploy their own create and config method so sto=
pped
> effort on this. But seems this would still be useful for some other SIOV =
driver
> which may simply want capability to aggregate resources. So here's refres=
hed
> series.
>=20
> Current mdev device create interface depends on fixed mdev type, which ge=
t
> uuid from user to create instance of mdev device. If user wants to use
> customized number of resource for mdev device, then only can create new
Can you please give an example of 'resource'?
When I grep [1], [2] and [3], I couldn't find anything related to ' aggrega=
te'.

> mdev type for that which may not be flexible. This requirement comes not =
only
> from to be able to allocate flexible resources for KVMGT, but also from I=
ntel
> scalable IO virtualization which would use vfio/mdev to be able to alloca=
te
> arbitrary resources on mdev instance. More info on [1] [2] [3].
>=20
> To allow to create user defined resources for mdev, it trys to extend mde=
v
> create interface by adding new "aggregate=3Dxxx" parameter following UUID=
, for
> target mdev type if aggregation is supported, it can create new mdev devi=
ce
> which contains resources combined by number of instances, e.g
>=20
>     echo "<uuid>,aggregate=3D10" > create
>=20
> VM manager e.g libvirt can check mdev type with "aggregation" attribute
> which can support this setting. If no "aggregation" attribute found for m=
dev
> type, previous behavior is still kept for one instance allocation. And ne=
w sysfs
> attribute "aggregated_instances" is created for each mdev device to show
> allocated number.
>=20
> References:
> [1] https://software.intel.com/en-us/download/intel-virtualization-techno=
logy-
> for-directed-io-architecture-specification
> [2] https://software.intel.com/en-us/download/intel-scalable-io-virtualiz=
ation-
> technical-specification
> [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
>=20
> Zhenyu Wang (6):
>   vfio/mdev: Add new "aggregate" parameter for mdev create
>   vfio/mdev: Add "aggregation" attribute for supported mdev type
>   vfio/mdev: Add "aggregated_instances" attribute for supported mdev
>     device
>   Documentation/driver-api/vfio-mediated-device.rst: Update for
>     vfio/mdev aggregation support
>   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev
>     aggregation support
>   drm/i915/gvt: Add new type with aggregation support
>=20
>  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
>  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
>  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
>  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
>  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
>  drivers/vfio/mdev/mdev_private.h              |  6 +-
>  drivers/vfio/mdev/mdev_sysfs.c                | 79 ++++++++++++++++++-
>  include/linux/mdev.h                          | 19 +++++
>  10 files changed, 294 insertions(+), 17 deletions(-)
>=20
> --
> 2.24.0.rc0

