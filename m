Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEA6E57D4
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 05:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDRDY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 23:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRDYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 23:24:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F25F1FDF;
        Mon, 17 Apr 2023 20:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681788293; x=1713324293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7QWtpMHqt4WrI9K018QpnpP1kF3TWGvSNCqw9blE2Kw=;
  b=jru1Ao3YjUjYi/TyyT3AAOnfKzsrmbFcoPrEQ068bd7XTwWp502PzT4H
   yi8c49rMTC4a+iRIwDxpau7omfLZIN0cNoXRwwa4DXV0rBYevF4UKhoZJ
   v4rKZupBQS/HGxgHA8b5mOpTimbiqW+pQ/dcThLgnSdlAEqAp6WErMH3Z
   Y36P7EPsUiJ1avfJ8aNt5LgRsMKE3yQlm4ihjIWj/IDTcrdnebYISaoqR
   2VAzLSE38NnHX93w13EcdAhbfFpRSTm2b89mdY80RGqZBJYns9QYarKlE
   9zNpiPVaqZeFUtxlGnkZe4F7pCi16iJO9+xj4rvFw8kliS106npw7Bnp/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="407959812"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="407959812"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 20:24:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="834694574"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="834694574"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2023 20:24:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 20:24:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 20:24:51 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 20:24:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+mu6VnJHxtNcnMqi7t2z997KD64Zp/oHpq6q4Zqc1WL/aANab94HU+7QzmJiGix3x+x2AhP5DaMf+x1M1R01wji3gL5ONqiylMSn2vgBcveZpSwp/hDB1Qdev/vKmhDJvJshg1+iddydEE3bMcRNrfw49thdQvBzK7PUDbLAmVVSRTrVhBBhwi726IpKeMwiUE+ZDd8hMyAGeao5GgnXz64NMDu0J5mbprHD2NiAsOX1eC8Mk08v6M+5UjYCLbNxBO2PRY9QdZGqW5P3/UelWEnSVLL5lWR97elgqL6bo/YgKgrqQR8C+MBx5aSjFc973PhcM6+kNr/W8LZf+NgMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVTpGwvfwy+E5QYzSAkUj5Eg6BgnmhD++9jn4t6bOYs=;
 b=CiZ4CMoPuCgqUg4hTApYiG4wA9lmN0d0cwzWW9iJKqDcDniggV3VayQ+AgRnADNKVbSjl6eA2a2AWaMWvYxLglcw2nK/ZenxX22BdVxGsCfWJQ8OPtgVLJ4knMxDg6WxjQZp3NlyRPEyD/mc7gJdYq8FvU5HtpCAr1xAFLh8lBV5NW38XnRvWgaj9I7wXRrqtVMqbeqCh6HEPK/oHoDgHyZD+0S9IUM3F7uzIoicUCBvjN3T7CQr8rOGIIeZe0FW1lKyvxxNRQtQIJPVgSSWOmzcZsIFsG1sr8T6yqA+m/3o6iEScRW0kqzscJgjlKTSe8l76ehSHSQgAsMAdWHcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5006.namprd11.prod.outlook.com (2603:10b6:a03:2db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 03:24:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 03:24:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAMsIYIAAPMKAgABpLgCAAPe5MIAALfsAgABc2YCAA9/IgIAA9jYAgAAIdQCAAAm2AIAAdrUw
Date:   Tue, 18 Apr 2023 03:24:46 +0000
Message-ID: <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
 <20230417140642.650fc165.alex.williamson@redhat.com>
In-Reply-To: <20230417140642.650fc165.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5006:EE_
x-ms-office365-filtering-correlation-id: 1bb6b0e2-0b80-416c-3011-08db3fbc75d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vOLTd1E9JqyL7ahXpDlA/hkuZncaolgpPNrWPkeJzH0JTghgJpNjmR6aYyJnh5JNhgJxgWJ6Ms5fwB/LjNdQGNfMjFa00Buua21WIcaqyBmbJzVi4X/NQ2q/i2ZkPOM9aSAUv/bsLLloreot9P6jwQyEGPqrwOZpJgg/xx/+zsNgwdiPaZI9pZ4rM/4hujtWMxvw+bIz/T9Fk1CjZ6XfQwwABKnBi5H/3FvqP97FIRpv2UaQOCTAoZimZQbM9JMVRPGhHgNwBvNALe+uhDPqb++VYRR4Soh8SoiSAFNJu79Gr57c5BQ0D4ypGw+iZtUzLUyx8B0uCN+/yTuYW3aqJpvY6awiRAw7oWvriKs/aO5PFZmUvGJzKic3dN4Z/Tc3yfIMXRfsm+mM9c/3WMTz9/1I/wt+QyxKDQQqpkUYI3IofU6aII+P4WshD2TuHWlRFvN0UGrlAQu1TLJfU9OjXF/GWHs/NmXThBKCkL1QsylJ0t17pAzdfIYP83FGVx3AKwX1mNNAusGPD7bwyHiRbTIyn6E//6vp7qvpDrFfYO7ANZmtVy5h5Sd9UiW0uD9MPpc5226Wj2Atsdi9dhCoK1WIwQzMlPx5gUY3/J2s1X66jeL7wgRBZsR0EUsfnH3z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(7696005)(478600001)(86362001)(110136005)(55016003)(71200400001)(26005)(83380400001)(33656002)(9686003)(6506007)(186003)(82960400001)(38070700005)(38100700002)(122000001)(64756008)(76116006)(66556008)(66946007)(66476007)(316002)(66446008)(2906002)(4326008)(8936002)(5660300002)(8676002)(7416002)(52536014)(41300700001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?19sW/vDjnms7Ug7ZzQFIrOGRvCEKjUFatjDi1w74H3YQvBVeyFpWUoUZ+o1T?=
 =?us-ascii?Q?iDLR7Ect9ECEqPPNZAU+SSKoe0gZ+yfUh7uogGys3jjLuokp1qlLL8YJGFQt?=
 =?us-ascii?Q?y2zLMLb0I+wAh8HlUGCyukeFryvD6ZlY+HRDVzM5wTdVc1Xprk13d7NmFjEh?=
 =?us-ascii?Q?UfSwT6fT8xyUXA8IiH4dvGfp+s2Nd3ckJOiCEgxm2OBshGsFAMLWC35h52kM?=
 =?us-ascii?Q?SSn7ZMTpDxfJKDCPaeSMIPLxxRN0fCqzEIKg0xMYxjVbDhb48zgv74pHrS/D?=
 =?us-ascii?Q?CtQJZ1G9GwBk45LPqyeIk0kKUlTWG7eidDYNRKzIkcObDRg5FK9XUGdfgHWF?=
 =?us-ascii?Q?tnh3xNwKk8Cuw1JO6dLPdiKtE/KwAYUJ3EcFe2cKeyxWS456tyDMgUgw/D+j?=
 =?us-ascii?Q?WuO3+nRwXn5Ni7/SxCKnlVBhXtmHeX0rDr+y2I1tIJnnA9ewYqqUeaQniQMA?=
 =?us-ascii?Q?xWtshoR0P5Dy2kcJi70EvadnlflmPpIViOlUSl8L8obWW1Lf7uUfa7loh2NY?=
 =?us-ascii?Q?f1x+tSSmKRnxPRLk+5lgRS1uBVr+aHiBtUPJHwqKhrBYGGB5lf4UyNmR6bTb?=
 =?us-ascii?Q?48NehD3dMmOWIKik9VuhGRcOYO8UEquRXi9Rs6rrZBl8Qxgjubu7v6PgDMiO?=
 =?us-ascii?Q?u8R8Gw+LJBzl9yfI1OUPpDyPCACQcOozeDIQH+F+ozxSvQlHApxnbADbhnem?=
 =?us-ascii?Q?1A5G2ZbizQFKQks7cqz2YqTXThMCYMlJIjX8dD0lGvYVzr4A5pG0+yw9DMJo?=
 =?us-ascii?Q?gZDDcOClkI1K9eVXkhMCWLElR3hcrprKbiIadRavX/FBfIekXkbMsiahiJdj?=
 =?us-ascii?Q?1iMeLW9hIx9jC6VRPiy9MMihaecGRQDedfNrz0QnhNAxmv6LaMUb4wZWtsPy?=
 =?us-ascii?Q?oS9/GSOiohg8QCbLsK6NK3D62ZzdUp2L9X8AUfbkVi81LIXYVx2JAG7UMkLE?=
 =?us-ascii?Q?qtzoyD+aMK5txaYKHLQKOdsF7/U5nE2Wo2DWjisLfXKDOsw3CLyOoHAt8rax?=
 =?us-ascii?Q?burfHM7sxPJSaQZtoPrQD3vDYejyQjnERUwOfewXJcOJMe2mQwWMwLGQNw7R?=
 =?us-ascii?Q?q4NGhQ5pho0StARo7FlGGh/Do9eKcblitZwaCc9/qrD9Z/42e8tGK+0QLzBF?=
 =?us-ascii?Q?Z24El44W9JH+A1HKaCHgNPSuFdf8p1+So5WTyn7lZb4VMfVAoTjjlnZ1VEBt?=
 =?us-ascii?Q?u99RVCyNkzEkQhxQmZyKvFYw5oQqc7v23ruWnu/gY+s8wApEBr2ZbI9ny8xC?=
 =?us-ascii?Q?ArfSgnbA3xXxCKe9/UNWmz4i4F3nfILjYbJXolfQykZQI4r/r5bfpiqrjZe3?=
 =?us-ascii?Q?6BgCrqOsXf8qZwA7NDCmCxGwV3PT+5REC1okc+h8HV3EMO1Vj+sM0IxvksNS?=
 =?us-ascii?Q?ln4E2fXA9VbWcbSQK9FhUVPaJ5i3GnwVCwoJPUKOXrgyo7BomkA0Ne1Oz8R4?=
 =?us-ascii?Q?kjCxZLaXgAHWObkLq91b1aTbveHYRZ1EO0++2qdaXsSlTCGanJIQawWD5gp2?=
 =?us-ascii?Q?O7WB+Dd7fEoKxvXMBn2q+3xRh06mEGiHDPthaZ3kctlYrZHf0vxqelVWyDgs?=
 =?us-ascii?Q?BMdxphsZMJaMdUupjee4T4Tya1xt1Hidd4cgT858?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb6b0e2-0b80-416c-3011-08db3fbc75d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 03:24:46.5823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qabZBh2YqQlRYilvBpuoZwdoI5mMG7WpsgFZFavnvz6lzpjlToG/cxJinGbkz+vA6B2/2+WE3URe9S1gvk78w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 18, 2023 4:07 AM
>=20
> On Mon, 17 Apr 2023 16:31:56 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> > > Yes, it's not trivial, but Jason is now proposing that we consider
> > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> > > this means that regardless of which device calls INFO, there's only o=
ne
> > > answer (assuming same set of devices opened, all cdev, all within sam=
e
> > > iommufd_ctx).  Based on what I explained about my understanding of
> INFO2
> > > and Jason agreed to, I think the output would be:
> > >
> > > flags: NOT_RESETABLE | DEV_ID
> > > {
> > >   { valid devA-id,  devA-BDF },
> > >   { valid devC-id,  devC-BDF },
> > >   { valid devD-id,  devD-BDF },
> > >   { invalid dev-id, devE-BDF },
> > > }
> > >
> > > Here devB gets dropped because the kernel understands that devB is
> > > unopened, affected, and owned.  It's therefore not a blocker for
> > > hot-reset.
> >
> > I don't think we want to drop anything because it makes the API
> > ill suited for the debugging purpose.
> >
> > devb should be returned with an invalid dev_id if I understand your
> > example. Maybe it should return with -1 as the dev_id instead of 0, to
> > make the debugging a bit better.
> >
> > Userspace should look at only NOT_RESETTABLE to determine if it
> > proceeds or not, and it should use the valid dev_id list to iterate
> > over the devices it has open to do the config stuff.
>=20
> If an affected device is owned, not opened, and not interfering with
> the reset, what is it adding to the API to report it for debugging
> purposes?  I'm afraid this leads into expanding "invalid dev-id" into an

consistent output before and after devB is opened.

> errno or bitmap of error conditions that the user needs to parse.
>=20

Not exactly.

If RESETABLE invalid dev_id doesn't matter. The user only use the
valid dev_id list to iterate as Jason pointed out.

If NOT_RESETTABLE due to devE not assigned to the VM one can
easily figure out the fact by simply looking at the list of affected BDFs
and the configuration of assigned devices of the VM. Then invalid
dev_id also doesn't matter.

If NOT_RESETTABLE while devE is already assigned to the VM then it's
indication of mixing groups, cdevs or multiple iommufd_ctxs. Then
people should debug with other means/hints to dig out the exact
culprit.
