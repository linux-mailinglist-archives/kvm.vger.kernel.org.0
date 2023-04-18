Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC936E5673
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 03:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDRB3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 21:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjDRB26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 21:28:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445F6524C;
        Mon, 17 Apr 2023 18:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681781326; x=1713317326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V0Hcu9CbAqx1VoGXPfu8pLacl8HwmCcatNlUpbK1JuE=;
  b=nlv8maz4kjCQp22qEhIqzHKL9w7z95RwbFSeEhcl51OYT4B+4muG5zRR
   84hxDl2DyvTjyNGhOofTMuBcXuOSsGOVas7CVGEkzlWVDsg468Wry4ClM
   wTP/4cOUzm7rSzt9iEF9Kb8q8C8PtkBjPRrXAEMoZqTcy/2g9KEUtcHap
   Kbdv7z+4TDabslvBndvXJhof2fbkJYhEbbVj+b9KfOF2pxH/Moo0DGII1
   fVb6neTFECw0Na208jPaDs9oPAzNKpKB0mtPO8M+wucrjmb7fp7Kor8/M
   UZYwSkDr4oGY94bhW1qA9d8VHVWglA8lkSjQjbQknDhtTa2uc/P0r8H0K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="333845359"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="333845359"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 18:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="641173196"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="641173196"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 18:28:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 18:28:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 18:28:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 18:28:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXN4tqSAsc1ue5xklLAMuw8FOnLfNalAf46b0jbPXmyyormGGfg4px6+fugzmOYov9hCesSTebUrU2lT+wpYqWh56wNxE3leUbYWPUKkuILdP9sHJfJR5ZdTUSitewgBtNoUvBn0lWjnfwbpzwpRpgMmLYejbPz+dj22qW2A8auNGkXfRDsGpSQa2Vu8vXbxR3A8VWMVlflOOTd9tR7pRSZhieCttaXkljy3dmUkN3y6WAh4Xtk1RCeS60DH5n9J5IzdvVrRhC/JFzmxJoJB8Mz0WQ2gaPFY2AyJWxKyYGu32eGJhz4+Qk4GDiT3WpEDNiQaD3QIFXVVh3cSEvknCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0Hcu9CbAqx1VoGXPfu8pLacl8HwmCcatNlUpbK1JuE=;
 b=f5W7vivfNn0eIWzKDRmJwBfQPbapJEv5SOn4mQN4+fnxm4xL04sJHMJKh+l9Vc8P0tdUQZbx9BVvo9V/N8p2ZJZSy9tAxjVZ8K4vtWbZmiLVF+8aqO9/iwz4/jv7nNqguT4EZNxTKqh1EmJPbW8AZ0y5/afffXrFd3Wx/YETEioNx4GSFA5h14QBLnMR8zJIXEQ17mBWjehVwOoJqK1ZHn3JfZExSxW24Pvjp1rv6XB/UbO9sr4VkyyWDflZvx8L29MEbsY5T4jU2cytVKnNCwGURFsByxrltBVboMX+DWyKlUFElEWUhkHHgTIqmPjQxd1RdrCPWrliY9MUOCRdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8083.namprd11.prod.outlook.com (2603:10b6:8:15e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 01:28:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 01:28:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAMsIYIAAPMKAgABpLgCAAPe5MIAFBsSAgADFkWA=
Date:   Tue, 18 Apr 2023 01:28:12 +0000
Message-ID: <BN9PR11MB52764ECBAE117EE159CECC598C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZD1MCc6fD+oisjki@nvidia.com>
In-Reply-To: <ZD1MCc6fD+oisjki@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8083:EE_
x-ms-office365-filtering-correlation-id: 9d5a9092-dabe-4fce-b36e-08db3fac2d19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ccOZ6g7zXGs1GQgIEhlUcnsQZ0CpEIXollX+VUy/snxRS3yYVaLUquNNlmKScj9sFXHxnmliOPt/6j75RLEzUjNiFCqytwoa2EhNm0i4zLSQ2TX71q2J/JIpu4nscI/koQj3FUk3peTExu4kLCa7Hjsrdrht5RVOQ1NjgQzYCFUrC747FA6E+DOdYriMG7ZC2GDCglsty0oZmAkm1QhIMxR0Ux6M+IaAYnkHH7iKVM3Ue05kjPzYOsYkN7m6pEPI8dsmyVV1e284vkVNMy/DY86H9/XgKAmjgpE4RCqdV5Vr6Ap8ocKOoJ5bq1Ja6ZuWZPUZm+qfr8d/dFftxGtObGgseRXuoRr4juOA1Kso1Fo8dmdHTDZNwh7msp3/ydtLxJcXOtaQ1E2xnWwzD1s6nOWz/ewuo3ORdZWWjEyNMjq3YID4ybLJ258ScxxN2Jd5vfWz02DyAst0EeRGDTAYHa9fOTZCrh4mLIGy6Rs2w5HgfG6NnX2HIj4DYsIelhdGgV+4VdiT/1S6WIbKPFNSqhApeA9zRyNsjweiM3Rs/bnXhsnN2hp5IoZ8rYTSuqgGehujKptDq31EEFPyxhbcNoRXPGksAk4sRjhB8jl2gObVpZyfcXa/bTAYb9IaXUKP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(5660300002)(71200400001)(7696005)(76116006)(6916009)(66556008)(66476007)(2906002)(66946007)(64756008)(66446008)(4326008)(7416002)(33656002)(86362001)(8936002)(38070700005)(122000001)(41300700001)(38100700002)(478600001)(316002)(52536014)(8676002)(82960400001)(55016003)(54906003)(9686003)(26005)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HYSRYsjtT6rW5tVq9VPSxJ3SQlq6awPCdf0aApiL8B8F8pHtRVdZr0ayZZO/?=
 =?us-ascii?Q?rCF82FwaWZOOPwwqduJRXDjW+5U9iOkSS05EPOVvlSQpKjGkCtUj3XbgT7wX?=
 =?us-ascii?Q?MiUPr6TPw9ioZxChmt3LsgxEJ/8NWJhgVhOg/mdeGlsf8Dze9el/Z7SqbxNx?=
 =?us-ascii?Q?XfIM4RrdQHB7MGFiCoM54sMSPmgw3nbsfpa8AsBxewUvDjUeonYSYdXu59VI?=
 =?us-ascii?Q?rcdLNeR83WkI8i9it8z7tGe0i9xriT0+5JrWnkeIa6PIqZ6Ylex3zcNl6ZN1?=
 =?us-ascii?Q?qXrfEncgznTv688FRU4LK2g9cccCnYpH1EBcttqaVDfLU4YguS3peTvJlhv+?=
 =?us-ascii?Q?UEVnUGSQRX8YGxGGwXbCQ076cYiANQL7yaPV1xwmngVEoE77vz6uaRFZDSRM?=
 =?us-ascii?Q?GapMm2l/LhfFBq5C/6TmFdmEXbrKvPtJeiFsbGqvUmSxym409meZfjfDOmyO?=
 =?us-ascii?Q?hyXOk19wi9toPpUT5eFRtxaoN9vnW+AwJm/PNB+E0D0/0VDcpL3WskRcsR7d?=
 =?us-ascii?Q?MEYf/AAR8y4DP9x++jBy+XLMCZ1Z3qydWzojOk5dqhXEmaLAKUPxH00JPfEv?=
 =?us-ascii?Q?koHGYJD1Dv0LmbUpLrtJ0Km6kstOZu/0C5XKZVMD6K9dRF/J0wEwcIcpwNf+?=
 =?us-ascii?Q?SRhy6lxIipO6Euv3gV/pqXV3t00HeDru9iFGxVkDXYaUt8DSK2S0DLTjeXjS?=
 =?us-ascii?Q?qio7zcdZFrsSPAzhbbVlFqJUffoBSm1PFzZ7CW8RViUajrvh94M24+gDyHIN?=
 =?us-ascii?Q?DjVxABiCbYk5YY0dB+HkQIf+eaI5Ej7Zg3iE+H0cnwdD0pUnhKRwsF+HEfnU?=
 =?us-ascii?Q?hUMKBsz6dBA92ad496X4U85Jp1bYW9SfjWbsNF+2SEzEfLpQvPZS4LxeH//h?=
 =?us-ascii?Q?a8x2B+gxxNalObmbc0EHJQ2iAM/dhaVOZhSkqMAW7b+LpO0g6/uy7xMWe0CI?=
 =?us-ascii?Q?XjUKsMrcF0HCEfrZUgpXgQ7PtGgqfEPQ+s9+xoEJ3g457UBpsAiHKPnwhWuG?=
 =?us-ascii?Q?EynrsyhWeNlgoPeESBtJHJOcF2yzd03/Allk4SWTBYD/Kkk7/sFyQdduJpLK?=
 =?us-ascii?Q?UAv8yHTYuWyfCBSxVCZiWp4nhIo//Tg8+Hl0kET7aZaxdESkPC+dMspNi2OB?=
 =?us-ascii?Q?VMDGLgPm6HY7tdxggeiEvuIy/of4PKGtmTWA/jccglXf88Ih2UIEs23CGt0d?=
 =?us-ascii?Q?Mf2a6eu4L6BwVTwzRjwrhGdVnwCqL0C8jPdP+jqulqJP4wWi96/uvmhu/jrf?=
 =?us-ascii?Q?3Y0xX1NPlRjiJfy0TnQZEmcuAYhPOsfUpeYRaGwFHplFzfo2F7EEsAv/c7C7?=
 =?us-ascii?Q?klmq2GonvTkIMU2nwf4Wbt/xh2j3iJ/KPqAAHE0D4ocOsG/ZkXzQApSt0LjT?=
 =?us-ascii?Q?IOMujxvAuW09MDe3fwuT+l+vVHsBuz1PfCCcfPyJeNmLJPcFpHJJ4feSZKdY?=
 =?us-ascii?Q?+yyNlyjm8qBLEAPfCBZsksGbxLUtYX5HqBjC8L2oziuHa62a6eYou2hLXk0/?=
 =?us-ascii?Q?FoulASiRVnqvQRrnMN+gsw8UApn5jgt6+Mw/a08qwO4wc22hXyYRrXTnn49f?=
 =?us-ascii?Q?Q73bcvZZwHehHYhXTnkkuUDby4rGlts4ZkTrWJ7j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5a9092-dabe-4fce-b36e-08db3fac2d19
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 01:28:12.6187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mJ0nvDVCI7sBbnbi0DXHI6NPFt5mGoL94fyhu/p9SMU/XcfEGcbDU82gYuzNICKPAl8l5UcQOyljSKM9SUanvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8083
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Monday, April 17, 2023 9:39 PM
>=20
> On Fri, Apr 14, 2023 at 09:11:30AM +0000, Tian, Kevin wrote:
>=20
> > The only corner case with this option is when a user mixes group
> > and cdev usages. iirc you mentioned it's a valid usage to be supported.
> > In that case the kernel doesn't have sufficient knowledge to judge
> > 'resettable' as it doesn't know which groups are opened by this user.
>=20
> IMHO we don't need to support this combination.
>=20
> We can say that to use the hot reset API the user must put all their
> devices into the same iommufd_ctx and cover 100% of the known use
> cases for this.

Make sense.

>=20
> There are already other situations, like nesting, that do force users
> to put everything into one iommufd_ctx.
>=20
> No reason to make things harder and more complicated.
>=20
> I'm coming to the feeling that we should put no-iommu devices in
> iommufd_ctx's as well. They would be an iommufd_access like
> mdevs. That would clean up the complications they cause here.

This certainly simplifies the matter a lot!

>=20
> I suppose we should have done that from the beginning - no-iommu is an
> IOMMUFD access, it just uses a crazy /proc based way to learn the
> PFNs. Making it a proper access and making a real VFIO ioctl that
> calls iommufd_access_pin_pages() and returns the DMA mapped addresses
> to userspace would go a long way to making no-iommu work in a logical,
> usable, way.
>=20

Yes. This would provide a more reliable/clean way to learn PFNs for
noiommufd case.
