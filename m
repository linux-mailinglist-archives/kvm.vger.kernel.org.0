Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABA16A6DC2
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 15:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCAOES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 09:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCAOEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 09:04:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9B22FCE2;
        Wed,  1 Mar 2023 06:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677679454; x=1709215454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AmqNdUcD4zhm40NYbwHiInFsoDDIwZ+oEy/e1YHK2nQ=;
  b=gWrJJBEquKI9LQPopEKbgO5HaDtNAB+6FfvVzr81QfAZa0kRPhyPgo5X
   B47dX/CJZrTpcvSM5v/UeH9rulLcBfDmXrfl/epeZ29q3YvUkqQAU2NVv
   HjG0jcDGDS6AMRrd8xF49ldejkuTTh8UEjLpz2Kr5IeMCMvqBAKsFBntX
   aGjy1ZZW+q/G0wXC/q9sCGk+pV8XDSYlF/q+zaEAy+1CjX6cdYfx+n39f
   fm0TrguE4heN8RnJleOKM6bDCmJ5nNugu3c641XZT4iSMIQojof4Ndc6s
   7TcWoNF4yPs+ZDZ0mwkYyTrygffl3BewQuP49eHQ0XYoHlXbwoKqGZ4Y7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="396982609"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="396982609"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 06:04:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="848655979"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="848655979"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2023 06:04:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 06:04:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 06:04:06 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 06:04:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E33ct2Q4qIsSRcqSP6kqtzlF3mdrSoPhpw65gFxiHCU848bOeI/Yj78cbiQ4y3++svgiB7DMRs2d2tKEVeIr8+8EO9/sCXGoVsSyqx3ARJEqrsqnjPg6XF3GIV7KPylUC+R0+wItf6XjGVtWrX51AxaKhOKwjjCgNEVD1fLH6RPlR1dY3Y4SPu5bCYUXYgnuMXoW23cZi6Z1hogrLpO/dENlvcvfHOkuITy4JrQStJqULdff0McALlceA+g5dLmTr6FRZ/2XNgAUuleNGAEspfO6EF1gkMaObxA/tvPIE8neKRUR7W+WIlicwjwQM5cd/Y+TK05ifWEdo3yyK0GuwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWlywcbhjHURQ3y+PVFQecilCorFvCpdiaQFPDYbnj8=;
 b=ZKFSUsBziOiZusDwJAmfVpIL18FzvY4X3lFCbn6hSIo+Xf34XM8E3lwRmsFDVUcxWiKtvUSit2IhV9GpiC9pi0/bwRMy1hredwv0Tx0P5JhEaQWnuwmfXtAvAvQXPLQ+ryE9ORSzkeOAZ+zANYyzCj5xaz5gQzmRMJFg+iF+Zy59AnLFXdZE6JZf3QgGsPE5aqGf9OHfDEhf0Y2vkOnXd8LyoFvbzyOPqO7T79sluR88gnxQzze4lgjpcZi1Kvb7NsTqjl5XefYA4BqvZpwm+MMC7pWf+TXy8w0tYpsAiLIjlTRSb/cAles+E7KRHiSojysduZfTNaPVEuzICgAlAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6372.namprd11.prod.outlook.com (2603:10b6:208:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 14:04:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 14:04:01 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZAgAAE3oCAAAG0UIAABx8AgAAA9gCAAAQbAIAAAylwgAAMGYCAAYeq8A==
Date:   Wed, 1 Mar 2023 14:04:00 +0000
Message-ID: <DS0PR11MB7529E456C277723146A09E2FC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4FDP8H1qRdgVrL@nvidia.com>
 <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4R2SRFKoRFg4qK@nvidia.com>
In-Reply-To: <Y/4R2SRFKoRFg4qK@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6372:EE_
x-ms-office365-filtering-correlation-id: 20decc64-6704-4231-13bb-08db1a5dcedc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +NF75LyG/aFrtgpF25JAX7Xrhkx3kvzNIinbOs5rTKU3x5b2Wd3uY6EMbnGWZskdvEZdFJ66yA+eQYm+SgMUVn89t41a4zJfBO/4ApRvQoukwvru77LLA8RtuXeJ+4EDvF4j+AvhFcx+KadC62i6pAF5aSwjCvVmWa7MQjrKhCADWzXGc2p9KLigf1DBK7ozEGyOiazVRC/iooLJjwzYI7vjm+Yg9w7mW7JUWeWLUY+83RkQWJvLdhJodU09aAy+GxH+Z6vggatXQS4ap9PWSArg1w0mMsu+5v/xO9OL4ZeaWyqfsBsa11xTdxqpPimXfZd8s9iKPeMHLEGm2uyE8la38YXilAI2Tf4B4IN5W4MKrUCLFBJgIIpYNYYGVk2FE4xV/6bTwnmJXHjRCMS6DNWWbvOngXeKSdSyT2asDxFkbWHUKpqGOtPGWKvH+YPW6wu3264RrR0rVPeiqwMhrymENFHBriS8yugvNzBKdCmjA6BaHU1h6L0v91+0VRZrAWTg4DXETjY9Zfovqr2wMjJxE8Jz+brxP1KPQqQ+1zzsiy7wU3zin3mNq/uRMpI8kDJ1tqRNphkjh/5uZxuqaVPXlrHqS8m7WuJKmbDZMuquFb6eD3u4o3tWInmYiPd3cDdRaFZRHQNSEXFIGxumhy/yScsmlS1sOrfUT7c7/RL2NPrUug5Ixx9Dylv9gZxNikklyWISdYCNojdYoG21JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(38100700002)(38070700005)(82960400001)(33656002)(86362001)(7696005)(66476007)(2906002)(41300700001)(122000001)(8676002)(5660300002)(66556008)(55016003)(66946007)(66446008)(64756008)(6916009)(4326008)(8936002)(7416002)(76116006)(26005)(6506007)(186003)(83380400001)(53546011)(9686003)(478600001)(316002)(52536014)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?thLoQIUS0+n+6lszYIqPG+h8EbFua71ivImt1Sn7g7CBzFLTn/AEZpfkvUBv?=
 =?us-ascii?Q?mabnnZxVtwAOWKG7bjznnyi9nnfFThI/zkDoTAdrvXSSoiXV6GsT85CmIu/M?=
 =?us-ascii?Q?x0f+m0Rtl/Sgry0LAKhSYYHdJl2INNqqsIHCQ2z0EOi9wbj//uzkIrpQVBlA?=
 =?us-ascii?Q?6W+NTc0kgWosLgh+KM1xSY8M6xbMwBc2+cb6qCk2cpmbG2Z+c4Mj+AJy5ye0?=
 =?us-ascii?Q?9l1jgh/Dc0Stg1FURYMzSvcObZ3JyqDktjx+GfZon7yV707xATXWLVt21eLh?=
 =?us-ascii?Q?pC+wR5kDVS8QuHOA0uWThmp44osKXNTzxm5gnXc22t8o6sn9qQMy42p2dwt/?=
 =?us-ascii?Q?G+DiK9idjvkT6QPwuP8caA4v1hjKBsJsCOJKc1f6S1KA2GZEfSm9WarKES72?=
 =?us-ascii?Q?ysKt/ebOjudoEE+ugNePmiq9EEwJzpNHkLB7XfZosVPuYyp43S/7CGKPoJCb?=
 =?us-ascii?Q?TYut15BH96gHZhZ8SvzF8UGkk1rdZUM5MfnNHT+E65odlxVXuTYOCbFkhWXM?=
 =?us-ascii?Q?Wf7djmxFWWo1QJlGXtGWo3iiPbPHGwwdVkkVvXssTZDRgsL87Tvq6isxOFbe?=
 =?us-ascii?Q?ipQUxCA3EgP7nLe+Ke3/FCwK23gXMu/L2kH0vL7hYbDUsaHkWlDDuIUBzQ0Q?=
 =?us-ascii?Q?0UZs7fpFuM8IUweAe3Tq/fuGQm3KV5vWhqBci3tomCShoeWiH+2ZhikMzNFB?=
 =?us-ascii?Q?4eWV79DukklGaogEP2eKk0mroCaqbz5ZEWXSGTxmi68/9uvlGE1JlUyh406g?=
 =?us-ascii?Q?MeP38LRKEc/a3XTCUyBt0sDZutdfYgNwr1N+/+bo3S2jkQSOFJMoFdGp355P?=
 =?us-ascii?Q?ce0ibBT2qMeCgA3KGIZYakz77IXNCl1Zj5x+R2vIwjoZTpLDz3mbb+87ERZl?=
 =?us-ascii?Q?GsXyosXt0cZ6pfu8Zp8/3AjL53d55/SmzRCJvSycatIYguvTiWaWXsdlC4OZ?=
 =?us-ascii?Q?ACio6G6W0fghgsSJ3gAdbcgp1vlHTZNDykchXY3G2k/4gsvcQQZt4tUuTIbo?=
 =?us-ascii?Q?Io2RpbOPgCPXPGg9v0wnP3Aqsl/EZLlle9M1PiV61yJpAPr08p6HlioRXp9R?=
 =?us-ascii?Q?nRX33JUe0nWP0n9hC61JKNmeQBZQto/3ZI7e9yL7N9kOTNWibe0PxcHWP3hG?=
 =?us-ascii?Q?UZtJFiUaIOeSxp+6eOKVw6cSWQKWmCXtm46KQtSxiu1NDFUqI2GaPA3qm65i?=
 =?us-ascii?Q?Uz4L/DKg2cSzjdYYhIy6LUV7lDRAoaJ8UCkaIeW1FJvF+/Y857YndXB4KE1v?=
 =?us-ascii?Q?DYfEbbYAoB/E3FU3oLACmahmI8Dhnv6lJNZC2a3HJbpzH/LEEGUDytB+QGKQ?=
 =?us-ascii?Q?U+Vb22MEYoEEgFSzhFGDXwNq1qA8zCJTqS+Mk2GZS5pnSP9ugn6TIWKRmaW1?=
 =?us-ascii?Q?cO2CJVHRzqsjtnicnLMyR6qFNxMr1rXJ71y8HMV6XFO/O0TmM0rYG5yVisKF?=
 =?us-ascii?Q?V536DmHw/APCovTV4sekCHeTm4h8vASGl59rIPDEtAgGDGwVzb1DOct7iqnS?=
 =?us-ascii?Q?fI7QoX3aKvwSdP1Yh/VGkA3gbhJ8XPIj5cFOMwX46HoI7oYjcf8dLbTnjWet?=
 =?us-ascii?Q?6HaEuTZagrb2H8XA8/44+UVD5kuv4InZ6vRnAl/F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20decc64-6704-4231-13bb-08db1a5dcedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 14:04:00.7242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HJy3auy6kOKW7uJ5h/J/O6SV7xzAF8JZ/wADAqGBDMv2OAfxl2vqssaj+iF9wFBfRQhnE4SebyxQriR1m9fGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 10:38 PM
>=20
> On Tue, Feb 28, 2023 at 02:01:36PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 9:44 PM
> > >
> > > On Tue, Feb 28, 2023 at 01:36:24PM +0000, Liu, Yi L wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Tuesday, February 28, 2023 9:26 PM
> > > > >
> > > > > On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:
> > > > >
> > > > > > > A null iommufd pointer and a bound df flag is sufficient to s=
ee
> that
> > > > > > > it is compat mode.
> > > > > >
> > > > > > Hope df->is_cdev_device suits your expectation.:-) The code wil=
l
> look
> > > > > > like below:
> > > > >
> > > > > Yes, this is better.. However I'd suggest 'uses_container' as it =
is
> > > > > clearer what the special case is
> > > >
> > > > Surely doable. Need to add a helper like below:
> > > >
> > > > bool vfio_device_group_uses_container()
> > > > {
> > > > 	lockdep_assert_held(&device->group->group_lock);
> > > > 	return device->group->container;
> > > > }
> > >
> > > It should come from the df.
> > >
> > > If you have a df then by definition:
> > >   smp_load_acquire(..) =3D=3D false     - Not bound
> > >   df->device->iommufd_ctx !=3D NULL   - Using iommufd
> > >   df->group->containter !=3D NULL     - Using legacy container
> > >   all other cases                   - NO_IOMMU
> > >
> > > No locking required since all these cases after the smp_load_acquire
> > > must be fixed for the lifetime of the df.
> >
> > Do you mean the df->access_granted (introduced in patch 07) or a new
> > flag?
>=20
> yes
>=20
> > Following your suggestion, it seems a mandatory requirement to do the
> > smp_load_acquire(..) =3D=3D false check first, and then call into the
> vfio_device_open()
> > which further calls vfio_device_first_open() to check the iommufd/
> > legacy container/noiommu stuffs. Is it?
>=20
> Figuring out if an open should happen or not is a different operation,
> you already build exclusion between cdev/group so we don't need to
> care about the open path.

Ok.
=20
> > df->group->containter this may need a helper to avoid decoding group
> > field. May be just store container in df?
>=20
> At worst a flag, but a helper seems like a good idea anyhow, then it
> can be compiled out

I add a separate commit as below. vfio_device_group_uses_container() is
added.

From 0ce86e6b71d1884e9f5de30ba23e3aa93cc84db9 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Wed, 1 Mar 2023 02:24:43 -0800
Subject: [PATCH 15/22] vfio: Make vfio_device_first_open() to cover the
 noiommu mode in cdev path

vfio_device_first_open() now covers the below two cases:

1) user uses iommufd (e.g. the group path in iommufd compat mode);
2) user uses container (e.g. the group path in legacy mode);

The above two paths have their own noiommu mode support accordingly.

The cdev path also uses iommufd, so for the case user provides a valid
iommufd, this helper is able to support it. But for noiommu mode, the
cdev path just provides a NULL iommufd. So this needs to be able to cover
it. As there is no special things to do for the cdev path in noiommu
mode, it can be covered by simply differentiate it from the container
case. If user is not using iommufd nor container, it is the noiommu
mode.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     |  5 +++++
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 19 ++++++++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 2a13442add43..ed3ffe7ceb3f 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -777,6 +777,11 @@ void vfio_device_group_unregister(struct vfio_device *=
device)
 	mutex_unlock(&device->group->device_lock);
 }
=20
+bool vfio_device_group_uses_container(struct vfio_device *device)
+{
+	return READ_ONCE(device->group->container);
+}
+
 int vfio_device_group_use_iommu(struct vfio_device *device)
 {
 	struct vfio_group *group =3D device->group;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 68d35e1d7b87..e1f5a0310551 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -95,6 +95,7 @@ int vfio_device_set_group(struct vfio_device *device,
 void vfio_device_remove_group(struct vfio_device *device);
 void vfio_device_group_register(struct vfio_device *device);
 void vfio_device_group_unregister(struct vfio_device *device);
+bool vfio_device_group_uses_container(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device_file *df);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 121a75fadceb..4b5b17e8aaa1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -422,9 +422,22 @@ static int vfio_device_first_open(struct vfio_device_f=
ile *df)
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
=20
+	/*
+	 * The handling here depends on what the user is using.
+	 *
+	 * If user uses iommufd in the group compat mode or the
+	 * cdev path, call vfio_iommufd_bind().
+	 *
+	 * If user uses container in the group legacy mode, call
+	 * vfio_device_group_use_iommu().
+	 *
+	 * If user doesn't use iommufd nor container, this is
+	 * the noiommufd mode in the cdev path, nothing needs
+	 * to be done here just go ahead to open device.
+	 */
 	if (iommufd)
 		ret =3D vfio_iommufd_bind(device, iommufd);
-	else
+	else if (vfio_device_group_uses_container(device))
 		ret =3D vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -439,7 +452,7 @@ static int vfio_device_first_open(struct vfio_device_fi=
le *df)
 err_unuse_iommu:
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (vfio_device_group_uses_container(device))
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -457,7 +470,7 @@ static void vfio_device_last_close(struct vfio_device_f=
ile *df)
 		device->ops->close_device(device);
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (vfio_device_group_uses_container(device))
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
--=20
2.34.1

