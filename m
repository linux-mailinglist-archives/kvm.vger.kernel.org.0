Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7E6E04F8
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 04:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDMC5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 22:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDMC5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 22:57:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C62719;
        Wed, 12 Apr 2023 19:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681354628; x=1712890628;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vouxstjkJCifRXPlmMsOqYNaXcEnSGJneThzVXWyy8I=;
  b=EPLd87kmXkosPUC+NpBUZR//07J7bRPCMnFBVFx9MTYjj3tDNEyXa+pU
   rSLIH7/lCTI4fcML/W7FbOg5uptUwvqz+ud1lAcAurKgOUjEx4NVGyy5c
   MOjYg4EOwergCNrT26wdJ8QfEjdRzleFdkKSAmWlogd59RzQzqa9OCPiu
   jG2UYxSPbAzBtAw93/BndvwOBgx0N7dNeWcrfgu1GEooNys3rdoM1W+wk
   wBwasLLjzQ7SK1mTWI5wZhTJh7bJ0oGeLOCRt9hIFX9DJ1DkjBhACgLaL
   jWsrobqTPsge5eGYTque8xQaE/IGkEz31i82H2jflrd3Cm1Q0OZasx0MU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="328185628"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="328185628"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 19:57:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863550182"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863550182"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 19:57:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 19:57:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 19:57:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 19:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC7O+uyaU+f7Aszo3qy+gsSiZ+l8JOCwGk40V/Gj3JF2A7HRS9/qSDjECaugnImleDu5uhmKMKCCAxmCO6JpGn29IGCz8JRVmJuOqS/WsGhd444Qr4zm0lgtl9oF/hairdBE0Dm0Z+CZJOTtiaohAzLMteSZyrC3bZkHspc0JYIZ0aCkbt2eEJnfB+CO4z/0qiPninRESSQ8aTSwiqwmSBRItEEUa5GOie+qOs/+M1bBo5Y5it6jyCRyDC1mh0aaTWxRLUbwvMJH8aQY0FWvGmhm9/jsjRlLfKN96GTHA3oYKGm6BGabzRVJP9es2btVVZMAWZ01gAt/79PFkN1XqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6SIAn2rNSJzTR/gG+aEINd2N6uefvK9cYmxA7TwQAQ=;
 b=biG1GHhuyWgLiJbWymrnXdIv58XRndKFFIkEuZ3oEGxZybTCuerVBRmyFJS6xGAWXPXNasK2tA8EsOnB+klJgQbrzB+BYz1K5fAQcfv8Hi2B4sLdw/9yhENqvCXA8Ad6neNh6tIfGwTiT5S1dnVeDiMyeavfQd00Af9FSxSDg5bE/v/GAVvuM+nLJ5HKy0bQ7AAjKB6afgJ6dI5i94hOOa8fJIc4keb6B+F0xSqpV1CYCI8q22qUWG5A185rpbrGT7ls1+dCocyw/6FCXipgpu0dvR8oCL1LD77BfEyLoP88+e1u+uYyxNEzkoiuwrad3r5pxIl2JZROtw4SkzkP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7548.namprd11.prod.outlook.com (2603:10b6:a03:4cd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 02:57:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 02:57:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
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
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIAAeYpwgACDPgCAAMYh0A==
Date:   Thu, 13 Apr 2023 02:57:04 +0000
Message-ID: <BN9PR11MB52769BF94646C590315EB2E38C989@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <BN9PR11MB52761A24E435E9EF910766E28C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDbIzvawep4Sk+0M@nvidia.com>
In-Reply-To: <ZDbIzvawep4Sk+0M@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7548:EE_
x-ms-office365-filtering-correlation-id: cbbd32c7-e271-4780-6952-08db3bcac313
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CkDyF91wRkOFFGPBctSDgSYkvbLha/bxEec47sGY5v69Oa8W+1+68o5WVf0GiL2ORl/4V9KF+mNwZjuLQnQhaR5xpKLxP0AaOkZMyfBW+q1IQjQtsN6lTHg9ZfQxwiho7ZEtcEWVEV2muRuHJRSGxt/MpR8AUZclzP5Jb0VswEBf0P3XU5MoPvZ9hFLtGoUFQxDMjEL2f1m9v10An/O2+4wn/ljtpkSz4NHU8ur70MY8w2rhyhx72l/cPZ3OAig62HV+5EPZ8Q9HKiMMINSJ9zD3k9QetBWRx6C4lStidoIvrGT3nPwUDgpVV4HjLk0+/G7B0FdeChvl/TzxaU9HGz6AcDBEhkHYRbWRTm24DhR79pueRvzlYXfL5fHu1AqaClu1phA/mHzVAfUJtHIKk6h38UQUAb/CIhWLuHti1FeY3ztvZyApUSpIN5kkT45Jnk6HBUZYcSNZP7fQxzKavmRxtVnyVSfPk5E501eiF5Zcb1u3qgzXtlzXyCnRYAOUSv9xHwLPnDHQ2H0qNKehWWKdfPaY5pwjnHGP709NUxa/wRDfOPxcMSHH5nmiZNA/f9qkG66qUq3T9ASJEFgmFP1lfGS+GrIIhIHyTLQMZt+JvUsi02AlL3xnI4qJe39y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199021)(316002)(38100700002)(6916009)(4326008)(64756008)(66446008)(66556008)(66946007)(76116006)(66476007)(82960400001)(5660300002)(41300700001)(52536014)(7696005)(71200400001)(86362001)(54906003)(6506007)(26005)(186003)(9686003)(38070700005)(2906002)(7416002)(8676002)(8936002)(55016003)(478600001)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xQoTdfwXbLhCj2wctG/kRqPSskGJyY2au6AOwB4FwJ2bLd9TfTC1UcG244O7?=
 =?us-ascii?Q?Z5NXB4ct7m9iTO6OEcVTbntI/ZI2DeAhRhm0+d928RtSvFevMmKNKbFxY8Oc?=
 =?us-ascii?Q?YbH3e1xItQLKNnJ7hHJNjRdj4BdCe2FTFiRKGGHnmoB+b/59qN/NFxKkmbFS?=
 =?us-ascii?Q?lfjWxAiFK4TrqKPd/XH9C82+yNSGDVIwLGuk7+fDf2CBnXyJGsDrU1DQNeJ9?=
 =?us-ascii?Q?ucGWTHUdKpUoKwj+JQ3claqhcmzJd9QJs+rZjkYYNqqAjBjXHWS1CTqcC4ZM?=
 =?us-ascii?Q?nfT+Y+DyxUmc+A9z0l7irEMO1p/E+XUFRt4ApyBurI5o0OOOgdGTKVmdKk4j?=
 =?us-ascii?Q?wanNtO3kuRa7fOA5WUXqlS18lI8TdWAhMNKCbRUwote6L53fPS3P0rtVQitt?=
 =?us-ascii?Q?/jDvX2H48KzyKrQqNstP/LBewdvhTBfBJc7h1uRZIg8A0YqWDS7mqZ8GDIYt?=
 =?us-ascii?Q?ym4XhiUd8Ey0RZbaxEV+1A0tNpmz8zkN1/Jo2NMYuqvege2tDoBb++FVY1Pb?=
 =?us-ascii?Q?svqjkWnklbjZQQ7bMKclmBJInSGIiTsmVq+hYEa1PU0ZrxylDl+Vt8JQI9lY?=
 =?us-ascii?Q?vaaI7wCt1f9/nhPHv8i0MkjK26jlHd9Fq2lsUJdPzn2GPgBdYHoPTlPXmx7N?=
 =?us-ascii?Q?1X7mRYE87IDVSFCJ4NxUDGvnPLEytqGZkv67axoV62FfmB3XgY5I+TgH6uID?=
 =?us-ascii?Q?hDTCr4oYeMLTL7FZRQutVSbHCtlXbBAVv+w3DE2BPi3QtWJ5YMuuMlVfhSup?=
 =?us-ascii?Q?3dP+pnG2TadcgaOsIBHeFp1oX88vBj8GqTmMayLBVYH2/+/uWFwip51wLT/v?=
 =?us-ascii?Q?Ko2bcOoHgFmfU7DcWeYbX+7l5941m83XFixn0LwWWNzMNC1BX5F1iQPpXS13?=
 =?us-ascii?Q?hhHEXSO3OEWtSXlcuo3Bavfy+hL4YR8D0xEFBq6GqwD6bwiwuSyNF61RawMb?=
 =?us-ascii?Q?DC4ld9MA1CfU6pBvOk/RawTa3cFgtw1NClq3TmLUF7wJ70qUSHr7QgGzj/we?=
 =?us-ascii?Q?lw5w/MPRejfbgq8xFEaNEozeIgNCI/Zed0hxmisoXh1q7EC2v8HLgQuW1h+K?=
 =?us-ascii?Q?OTHNXtf/tfkXB+th89ngZPLB6tr9ebwhMBBR4XpkJUkNAaeUHsSOxjkBhqB1?=
 =?us-ascii?Q?v7VK3BZhZBpL0URk5NOVi11UeoR2vJw7OB5aojIFWJNpU93T3kG+Gj/oEIz4?=
 =?us-ascii?Q?+uFwKYNZhIxh75oO+DWbd4xxd0Gn9nY7u+gOmeKyYkXkHY7fN3PiW7yXponu?=
 =?us-ascii?Q?UgsnAfJmhzFbS5BJb8eOpNpqqQ05VTdrbgRf8HN7TD90AW2tfNgRHjGpPUEs?=
 =?us-ascii?Q?qcLj37qBeTYA13UM781E/aNXXW5M0oBVAwvknSbSETFCdK/tVL7zJfELArJ0?=
 =?us-ascii?Q?KNXqc+lvePc/kryfLnOlf63vy8sZPWTds2pQ8KJnLyVZuwkptHrHQec9m9lY?=
 =?us-ascii?Q?PSXqpu26pEwWv9kCN2Nz356c9Z5Q3OHkNKm7W2+53BZqTo0yML4IQg+ZM2wt?=
 =?us-ascii?Q?+aQHuDGyNIHb/nGO5lYiUnOO+3JZ11ETboNmmbAIBN8VOuqw1qXp14Rr8pdq?=
 =?us-ascii?Q?Y+555TmErLrE3la2CkY5NxC3opb5AClgSv69UDAW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbd32c7-e271-4780-6952-08db3bcac313
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 02:57:04.5088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oxhBOOstsBOi213SqgNcGMuaruSQLm/IDDo8BWXxuS/zikCXKwSFxCn/7Xn+h6oGOqogmiNieY9a8W98y2WoQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7548
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 12, 2023 11:06 PM
>=20
> On Wed, Apr 12, 2023 at 07:27:43AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Wednesday, April 12, 2023 8:01 AM
> > >
> > > I see this problem as a few basic requirements from a qemu-like
> > > application:
> > >
> > >  1) Does the configuration I was given support reset right now?
> > >  2) Will the configuration I was given support reset for the duration
> > >     of my execution?
> > >  3) What groups of the devices I already have open does the reset
> > >     effect?
> > >  4) For debugging, report to the user the full list of devices in the
> > >     reset group, in a way that relates back to sysfs.
> > >  5) Away to trigger a reset on a group of devices
> > >
> > > #1/#2 is the API I suggested here. Ask the kernel if the current
> > > configuration works, and ask it to keep it working.
> > >
> > > #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
> > >
> > > #4 is either INFO and print the BDFs or INFO2 reporting the struct
> > > vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).
> >
> > mdev doesn't have BDF. Of course it doesn't support hot_reset either.
>=20
> It should support a reset.. Maybe idxd doesn't, but it should be part
> of the SIOV model. Our SIOV devices would need it for instance.

yes, supporting VFIO_DEVICE_RESET is assumed. That is required by
the siov spec.

Then no need to support hot_reset.

>=20
> > but it's presented to userspace as a pci device. Is it weird for a pci
> > device which doesn't provide a BDF cap?
>=20
> It is weird for a PCI device, but it is not weird for a VFIO
> device. Leaking the physical labels out of the uAPI is not clean,
> IMHO.

yes. Reporting pasid is also incorrect since it's invisible to user.

>=20
> > from this point the vfio_device IDR# sounds more generic.
>=20
> Yes, I was thinking about this for the SIOV model.
>=20
> Jason
