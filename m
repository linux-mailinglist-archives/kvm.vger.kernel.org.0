Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E3B181F2
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 00:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfEHWOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 18:14:12 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:55044
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbfEHWOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 18:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37HndU7t7sxqn2CHltLNblO8w+v8oHZ0Rtenb5hhSuA=;
 b=PwUDAuJ3ubiN1h9fVk7zHAWgQ8bq0J3jBDqgm4L3EHdXW4ie3HOVTzlLbAfGmROCPVFZXGrZszPziDhxMuiu5FrluSi2f71UZb0JayVSc3KHTF3mefplxeII0eWaJj3iQAUz/+dNo/P60SpUu8eBMDj0EEi8qB3ci3yqXf6QRSU=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2637.eurprd05.prod.outlook.com (10.172.13.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Wed, 8 May 2019 22:13:28 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1878.019; Wed, 8 May 2019
 22:13:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Thread-Topic: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Thread-Index: AQHU/6cN2gCBUIHpe0O+UYvmhXR8xKZhhEWAgABRkCA=
Date:   Wed, 8 May 2019 22:13:28 +0000
Message-ID: <VI1PR0501MB2271E76A8B5E8D00AFEA8D97D1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-10-parav@mellanox.com>
 <20190508191635.05a0f277.cohuck@redhat.com>
In-Reply-To: <20190508191635.05a0f277.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13eed646-7f66-47d7-063c-08d6d40265ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2637;
x-ms-traffictypediagnostic: VI1PR0501MB2637:
x-microsoft-antispam-prvs: <VI1PR0501MB2637AA86E737CC8A62C981CCD1320@VI1PR0501MB2637.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(346002)(396003)(189003)(199004)(13464003)(51444003)(5660300002)(52536014)(7696005)(99286004)(229853002)(478600001)(76176011)(68736007)(8936002)(53546011)(6916009)(11346002)(102836004)(476003)(446003)(9686003)(54906003)(316002)(55016002)(81166006)(81156014)(33656002)(53936002)(8676002)(73956011)(486006)(26005)(6436002)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(14454004)(86362001)(4326008)(66066001)(6246003)(25786009)(186003)(6506007)(2906002)(7736002)(305945005)(256004)(14444005)(71190400001)(71200400001)(6116002)(3846002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2637;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bV9YOyP1JeiEIGz4wAHIHbSd/zOCYPjoyeARGNGHVQqdUxZBrXb9SCLKSG6AGs8g1FiwYVzKvD0pDOnTBW2knAF3QdWiK5w1IVTGGLsjFGrln1U5q75rlCgMlBV8JlNEtyGScYsQTCU04z1b2mSF5bCxei3ixmIPDRM/1Ul8saciqoWMd1GJ68Iq89CliI7lADvwXAzFWnvfQuHuqxzT1aIKB7DHQS2IIKbUqQco6np9WNVA2WZpvtpxWXYe2H8btS9CO8nOvp7/WaX3WazPmGrRq6JBbowUvzadw/CNRFRpiCkZjP2i7y3AB6EjUJZGX4W+q+VwWH8ZSo10N7U/qA/RDOmIr2nmFUiHZpNN+ZOWOykykeGklNJt7zoGpEaNEE7sQy+TnBF6DQ+VxF0hMIJMyzaf6q5w3g32T/z9rIQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13eed646-7f66-47d7-063c-08d6d40265ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 22:13:28.1086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2637
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, May 8, 2019 12:17 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file =
on
> stale device removal
>=20
> On Tue, 30 Apr 2019 17:49:36 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > If device is removal is initiated by two threads as below, mdev core
> > attempts to create a syfs remove file on stale device.
> > During this flow, below [1] call trace is observed.
> >
> >      cpu-0                                    cpu-1
> >      -----                                    -----
> >   mdev_unregister_device()
> >     device_for_each_child
> >        mdev_device_remove_cb
> >           mdev_device_remove
> >                                        user_syscall
> >                                          remove_store()
> >                                            mdev_device_remove()
> >                                         [..]
> >    unregister device();
> >                                        /* not found in list or
> >                                         * active=3Dfalse.
> >                                         */
> >                                           sysfs_create_file()
> >                                           ..Call trace
> >
> > Now that mdev core follows correct device removal system of the linux
> > bus model, remove shouldn't fail in normal cases. If it fails, there
> > is no point of creating a stale file or checking for specific error sta=
tus.
>=20
> Which error cases are left? Is there anything that does not indicate that
> something got terribly messed up internally?
>=20
Few reasons I can think of that can fail remove are:

1. Some device removal requires allocating memory too as it needs to issue =
commands to device.
If on the path, such allocation fails, remove can fail. However such fail t=
o allocate memory will probably result into more serious warnings before th=
is.
2. if the device firmware has crashed, device removal commands will likely =
timeout and return such error upto user.
3. If user tries to remove a device, while parent is already in removal pat=
h, this call will eventually fail as it won't find the device in the intern=
al list.

> >
> > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > sysfs_create_file_ns+0x7f/0x90
> > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > 5.1.0-rc6-vdevbus+ #6
> > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
> > 08/09/2016
> > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > kernel: Call Trace:
> > kernel: remove_store+0xdc/0x100 [mdev]
> > kernel: kernfs_fop_write+0x113/0x1a0
> > kernel: vfs_write+0xad/0x1b0
> > kernel: ksys_write+0x5a/0xe0
> > kernel: do_syscall_64+0x5a/0x210
> > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_sysfs.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > b/drivers/vfio/mdev/mdev_sysfs.c index 9f774b91d275..ffa3dcebf201
> > 100644
> > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -237,10 +237,8 @@ static ssize_t remove_store(struct device *dev,
> struct device_attribute *attr,
> >  		int ret;
> >
> >  		ret =3D mdev_device_remove(dev);
> > -		if (ret) {
> > -			device_create_file(dev, attr);
> > +		if (ret)
>=20
> Should you merge this into the previous patch?
>=20
I am not sure. Previous patch changes the sequence. I think that deserved a=
n own patch by itself.
This change is making use of that sequence.
So its easier to review? Alex had comment in v0 to split into more logical =
patches, so...
Specially to capture a different call trace, I cut into different patch.
Otherwise previous patch's commit message is too long.

> >  			return ret;
> > -		}
> >  	}
> >
> >  	return count;

