Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8063270EB2B
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbjEXCMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbjEXCMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:12:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDB9C1;
        Tue, 23 May 2023 19:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684894338; x=1716430338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ksibu6q4IsThUnNFaImn4BlTUs31kXzPxY62MJZSxmk=;
  b=aVHS5T6/8vrX+FN942OQlxWxf0lDHrmZ8B8jlYu9lzLD3mkGNtjqi+va
   WxRrgt3YSSOKfK1LDfPSlZFN5vfxGG3nbUrNi/bel4Zy7F4KpTGrWRhfP
   l+QJEPEeCJ/ImCmTlHjiP76iLEhvcHfmKuqO//lfWsDEDQ5nq5oeQUfZK
   jyCXo/zwJorqrgWPrgnBatnRUfGdtDK8NhI2hmzJ3peTURh8XYTtw5Z+J
   Js9omHb6NJgpCc3lXXRSpEUuto639qUlt63m5GspuUH1XSI1nYRwnDM4l
   i9r19hgPw7A1OUpe8u3UNzNSH8yMBIzNQ79CKrFViB2OGo/R0nyuScD/T
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333044609"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="333044609"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="816379556"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="816379556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2023 19:12:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:12:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:12:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:12:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEa4WIB9VRNUBnJiotzAYCg/Cjau8K/W7dKTxgx7+71UeZeUogI38gzzGSoMEwccaPI9Z5ckQbAORyQIyatuIHTvnNK0Y8qTJn1QtvwBUp25VEMTEGgdoMxn2Yhj1JUMLD1fRqAS+hHvbyUq5XUR7vP0Al9Btjz1tXbR5kTDD1KLnlYrNVOWmV+zkD84VONYJo2HHBgCMNT6iBkmAB5OWcbCygn6cIRjB0W6bSURvugiZJiWGMwY8pNBDRiCEIKNppDIjd7g6W+m4Aj5Sm6F/cIp7Mtf7F92AE6whHz6FTnK6wq4he8BJRNIjqwPj4nx0hmtH6l0FM3uV6JMlfO/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrSXJ+A29ZeCt1dsuac4Tyzt0PJzy/rmUS9eSj00jAg=;
 b=GHn19DtfTxZ21j++MSQ309RbSkneTXBm6X1NcM7q01hBZKQGQJRTCpjhUnLjHplFozSOk0HPFqLrBR1zbk+E41rLQojAey/5O5Pj20BXq/6sNWecA4FiqTxafjya4BFOFxYyD2ktajronX55LLQjGfl3LuXIomgZRVlAipaSjqAmaxDVPTvJeyJGJWeqxvkwFveWxCqCDp6OXUfhrUcu2Irq/qAlLY4a9ubW6yU4JM5juVoq8hwZK7d8oSEEr5fybQfhTgeVgRtMtyRoAHatVHQQHlFYevP32Me2hPC6DuJ2MKdwwqugJ6u7vfX4Shz7mJl3IRdu8rCJjSfmIYAsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8228.namprd11.prod.outlook.com (2603:10b6:8:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:12:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 02:12:14 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Index: AQHZhZ7iKUbaAh4TKEGwflpEYDXvra9m6p0AgAAxWMCAAPVhgIAAqe5Q
Date:   Wed, 24 May 2023 02:12:14 +0000
Message-ID: <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
        <20230522161534.32f3bf8e.alex.williamson@redhat.com>
        <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095025.1898297c.alex.williamson@redhat.com>
In-Reply-To: <20230523095025.1898297c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB8228:EE_
x-ms-office365-filtering-correlation-id: 93c20da6-2a4d-4607-9251-08db5bfc4a68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8pO7vHk4qnK48ZhUUirIU6FWs5IgBbStQlMJEiLl6s/qm438teUu+TOKtJf5PVUrXOvw4k7zze+hQl7b0GVwsuNWCggx3ifN0gcX8ltIGX8zc01VTQVXXBNtu5s2V4Yt9A9EoJTNItFGj/oLcgyKaLSTl5xvTvfEXUFb06JBMVWL7Dh03xCXW4alMDr74VNtnn/2zvWLCqH1w3aoPjq9vjDfuIgyVpuGAWdFp377lRtLSwMPdmH3c/YgF3dGa28jdXRr+mCQ3xXI6vOS0YLhDkEdWNTPeyNNYQX3EnNgXYDZWhWJKw/5iJ9MIXkYbKoBLvtIPJ4aPZ8eTQTfDmCdOHOhZoUxpHHQKiSION/48YkUFJF/aE3ZNTLsUDUEwDNduml4g/MG6Gt37F72ZD2mwuM8SJmghG5pjri1HBI/kkZEFxU0F8hppdx1Xz9yRaOoQZjVskcb0esKNxw+hJ8zC/AwbU48VDyt7OJqDdGOQeIO+B7L7ygt0ddfROMma1NvtJv40qEDd5pb5HWQ1CNHgWmkgRRII2IOGlZ22NDuucIzBJgDYRdKSwBmoucvjSw3bqvG2tWsoY58GpdlJFlqG100o8BqL+QZvpRqiibxucGXQwQ1YPXxpOhVvSy2woYwg+lPXbwoute0MbnZeJU6SrNnAp3ukk34LybRTVoXE1w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(38100700002)(54906003)(41300700001)(7696005)(478600001)(71200400001)(316002)(4326008)(6916009)(76116006)(86362001)(64756008)(66946007)(66556008)(66476007)(66446008)(52536014)(5660300002)(38070700005)(8936002)(8676002)(2906002)(82960400001)(6506007)(26005)(122000001)(33656002)(186003)(9686003)(7416002)(83380400001)(55016003)(13296009)(83133001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?slq4tT+NL9iQ7Y99QS6bGxoU++JtOlo4nh3e7IOyZrO7vUaecJwNDDXsxCNG?=
 =?us-ascii?Q?V1BS1QvO3m84QJuNaL0PWsgHP3mSUrkBeIR1LHNS7p5uEEqtAYyIChE/ig62?=
 =?us-ascii?Q?QAZHLOSZyELtkaonZu5/L+QARmr+dZC4nOaA14ACuBqcSn0q+ABz3Qe2gv9U?=
 =?us-ascii?Q?/u0gicAd6jdLWQDQbo71frv5TwdAGcarrQoiqLVHwf+/aMCShAKO2MB68imc?=
 =?us-ascii?Q?jzVWcEHbLgWM1ekUowKk8dXp5dqKsvTAEMnGIvCXfaYEGjlRUyBY5e/s/sSh?=
 =?us-ascii?Q?feTJ1hp03BVNWUH8RT5gReN0pTPbaiGZm/KmG1FPXepkLVMQP2dhWJ0aoqOy?=
 =?us-ascii?Q?/N9iIv9QrPP2NesiZktBw9+s23RaQzKJEALXPiFshG+eBdpgWxwsaqd6Sg1P?=
 =?us-ascii?Q?qP6VoaTL7lbL5xAEfTPiJEM6Tl4TYRMsTv3LDiZkwNQDhhB5f7MU2PpAVd8H?=
 =?us-ascii?Q?HyYEwNVdvLAs3/soJclQJXged2NqAKdG4XRHPNAGGaTMcS65rGQo8PCv+1IN?=
 =?us-ascii?Q?BbNPQOhqEfGV+y0N0xgXFlrYZMC8NPiqGPpKtTK92VK31f/OYb+7LjykOawM?=
 =?us-ascii?Q?wzgz0gI0PbJS8UT6iUDWV5MhI9kAI6jOqKWlT/85jNNo9pKBnxWOCjhMnbyj?=
 =?us-ascii?Q?qa0g72497jAIh+nRs51uRVj4sazcYKs9pACTp8VircnxXrqcTN725zAeuxkC?=
 =?us-ascii?Q?stb2JmVHxDyVttv0zjjokqVLiwI1qfXn6txqcWS/slS6bMhB//UKQUqonit5?=
 =?us-ascii?Q?sRGpFJTKUQytYqlAzHK65/4Q2AwEPg4HJpCjMLRHE5j7m9EROLXeA5Eo8yy/?=
 =?us-ascii?Q?MkoZi68VwnR1ytK4N6W+rOchvRMYjXNbld9fXG015gtjtcOfJIEAOh+rDldZ?=
 =?us-ascii?Q?IVRSUNIbv+FVdPQnx0vqGxxGDPN/Iv7lPd+usQL8fIIRF8mhYtMiVndsBxDc?=
 =?us-ascii?Q?OkcI9dwuOSBJG1hzi/mTfH8kCugLtUgcUEy1qdAv6l39HF+s7KL1Be1xnmqB?=
 =?us-ascii?Q?r1+dDVm5KJ4LsANEVMX1V0hbBMClXqCdLfzF+K+Wot8Y6KI8ONmIM/Cwguic?=
 =?us-ascii?Q?V4pTKA996cvi7V7Xn6ucGNW7fnAM/UUTM2cudIhaMJT5EQMFxEgCtRlOjXG9?=
 =?us-ascii?Q?4bsvJFBpW/dmr3lhrNdcEjsKvsETFovchtkszKmPp3DN2hm1h4bKUMoGRpu0?=
 =?us-ascii?Q?3ns9ucDlVLtjjKdQHjYPWQAYiWHodMZ3ySIAnh9D9ITubAM93dle9c3Sp39e?=
 =?us-ascii?Q?KiSMQFpwM27TtieOGv4tGZghF56RuB2aCifXvQSR9mSzSDcEeGrSWVEgc9GE?=
 =?us-ascii?Q?pvoBWH6QmaAFND0UTJkGD+eUYKeLgRsjpsBTSmyFFBoecON/jwKfTujABaUz?=
 =?us-ascii?Q?2DaVv12SBHaKQ5DbQKmL3w96TvQchEX6TbFpAgoMFNoQTNfnmC0SgSyQBajc?=
 =?us-ascii?Q?uoif+nKxV8m0gZ/C65ppQsB23JyR/tmEwqn0jIRhamBwg6CToW4rzfZz5+ov?=
 =?us-ascii?Q?IvL1/IIhEorlTz8BxOEGGDb9T3C8yMaQUvvsuMtOFm5ZVzrCIWOSM3zV9Sea?=
 =?us-ascii?Q?oZBjBZtVzhLIAk8stcT+bDIkwC5AgXpAmdHN+Emi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c20da6-2a4d-4607-9251-08db5bfc4a68
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 02:12:14.0899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RmaUhVtvOW5s5Es6RDbFeoDuXkJ3dsNp4rOWQmdyKTiS44Sj5+q5z5z2e5775mzJN8JvBz28JGrDQKuUSZV/4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 23, 2023 11:50 PM
>=20
> On Tue, 23 May 2023 01:20:17 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, May 23, 2023 6:16 AM
> > >
> > > On Sat, 13 May 2023 06:28:24 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > This adds ioctl for userspace to attach device cdev fd to and detac=
h
> > > > from IOAS/hw_pagetable managed by iommufd.
> > > >
> > > >     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_p=
agetable
> > > > 				   managed by iommufd. Attach can be
> > > > 				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
> > > > 				   or device fd close.
> > > >     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the curr=
ent
> attached
> > > > 				   IOAS or hw_pagetable managed by iommufd.
> > > >
> > > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/device_cdev.c | 66 ++++++++++++++++++++++++++++++++++=
++++
> > > >  drivers/vfio/iommufd.c     | 18 +++++++++++
> > > >  drivers/vfio/vfio.h        | 18 +++++++++++
> > > >  drivers/vfio/vfio_main.c   |  8 +++++
> > > >  include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++++++
> > > >  5 files changed, 162 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.=
c
> > > > index 291cc678a18b..3f14edb80a93 100644
> > > > --- a/drivers/vfio/device_cdev.c
> > > > +++ b/drivers/vfio/device_cdev.c
> > > > @@ -174,6 +174,72 @@ long vfio_device_ioctl_bind_iommufd(struct
> vfio_device_file
> > > *df,
> > > >  	return ret;
> > > >  }
> > > >
> > > > +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> > > > +			     struct vfio_device_attach_iommufd_pt __user *arg)
> > > > +{
> > > > +	struct vfio_device *device =3D df->device;
> > > > +	struct vfio_device_attach_iommufd_pt attach;
> > > > +	unsigned long minsz;
> > > > +	int ret;
> > > > +
> > > > +	minsz =3D offsetofend(struct vfio_device_attach_iommufd_pt, pt_id=
);
> > > > +
> > > > +	if (copy_from_user(&attach, arg, minsz))
> > > > +		return -EFAULT;
> > > > +
> > > > +	if (attach.argsz < minsz || attach.flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	/* ATTACH only allowed for cdev fds */
> > > > +	if (df->group)
> > > > +		return -EINVAL;
> > > > +
> > > > +	mutex_lock(&device->dev_set->lock);
> > > > +	ret =3D vfio_iommufd_attach(device, &attach.pt_id);
> > > > +	if (ret)
> > > > +		goto out_unlock;
> > > > +
> > > > +	ret =3D copy_to_user(&arg->pt_id, &attach.pt_id,
> > > > +			   sizeof(attach.pt_id)) ? -EFAULT : 0;
> > > > +	if (ret)
> > > > +		goto out_detach;
> > > > +	mutex_unlock(&device->dev_set->lock);
> > > > +
> > > > +	return 0;
> > > > +
> > > > +out_detach:
> > > > +	vfio_iommufd_detach(device);
> > > > +out_unlock:
> > > > +	mutex_unlock(&device->dev_set->lock);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> > > > +			     struct vfio_device_detach_iommufd_pt __user *arg)
> > > > +{
> > > > +	struct vfio_device *device =3D df->device;
> > > > +	struct vfio_device_detach_iommufd_pt detach;
> > > > +	unsigned long minsz;
> > > > +
> > > > +	minsz =3D offsetofend(struct vfio_device_detach_iommufd_pt, flags=
);
> > > > +
> > > > +	if (copy_from_user(&detach, arg, minsz))
> > > > +		return -EFAULT;
> > > > +
> > > > +	if (detach.argsz < minsz || detach.flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	/* DETACH only allowed for cdev fds */
> > > > +	if (df->group)
> > > > +		return -EINVAL;
> > > > +
> > > > +	mutex_lock(&device->dev_set->lock);
> > > > +	vfio_iommufd_detach(device);
> > > > +	mutex_unlock(&device->dev_set->lock);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static char *vfio_device_devnode(const struct device *dev, umode_t=
 *mode)
> > > >  {
> > > >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > > index 83575b65ea01..799ea322a7d4 100644
> > > > --- a/drivers/vfio/iommufd.c
> > > > +++ b/drivers/vfio/iommufd.c
> > > > @@ -112,6 +112,24 @@ void vfio_iommufd_unbind(struct vfio_device_fi=
le *df)
> > > >  		vdev->ops->unbind_iommufd(vdev);
> > > >  }
> > > >
> > > > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> > > > +{
> > > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > > > +
> > > > +	if (vfio_device_is_noiommu(vdev))
> > > > +		return 0;
> > >
> > > Isn't this an invalid operation for a noiommu cdev, ie. -EINVAL?  We
> > > return success and copy back the provided pt_id, why would a user not
> > > consider it a bug that they can't use whatever value was there with
> > > iommufd?
> >
> > Yes, this is the question I asked in [1]. At that time, it appears to m=
e
> > that better to allow it [2]. Maybe it's more suitable to ask it here.
>=20
> From an API perspective it seems wrong.  We return success without
> doing anything.  A user would be right to consider it a bug that the
> attach operation works but there's not actually any association to the
> IOAS.  Thanks,

The current version is kind of tradeoff based on prior remarks when
I asked the question. As prior comment[2], it appears to me the attach
shall success for noiommu devices as well, but per your remark it seems
not in plan. So anyway, we may just fail the attach/detach for noiommu
devices. Is it?

btw. Should we document it somewhere as well? E.g. noiommu userspace
does not support attach/detach? Userspace should know it is opening
noiommu devices.

Regards,
Yi Liu
