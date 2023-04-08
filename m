Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1056C6DB900
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 07:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjDHFHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 01:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjDHFHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 01:07:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC6D308;
        Fri,  7 Apr 2023 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680930441; x=1712466441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2yHRyvWKgzlE5ATHdB80uINjztdhxg7Q1p6yFgf74Kw=;
  b=F0UWctoKNPt8WIeTR2Y/vw6wbJh2K84EynJ1czjcy8wtfNmwWgp4LBzV
   ZUYyQyzidhaHEVWxStyNWIzUCkovS2PmYWI3s8j+hOwZOQ04FOnchppDi
   TRghxxcta0zkZls3VV6tkFnQeLEExM5NG/g2jv/45QE8u1OfTPvkFsimq
   UI+lI6mp+eQY6OkJZjJojUW6K9HmwRGWcALnsntl9IeDk8akWoDrh8aTG
   NemZEwcFaX/6z4OAggIr3GvF8eCydT4daNiaxvVhF3cGnK9UtxuN7Gx5K
   QttcAmBrD9mShzUnkkjuaxOWgCco9il+pVVGYbpt89SODcYofcc5LmnKI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="405939107"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="405939107"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 22:07:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="687718357"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="687718357"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 22:07:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 22:07:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 22:07:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 22:07:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6oDrYqW40oAAr6SQ8kfwb2r5wRfGaDi/ibq5DIj39h0Qy1YzSLX0NL5GeRBkogQ6kvn01Pag26beEWCV91/LOir7qRlbQG3LXOG8MKohN7semCprrDlKsEFqtpFU9qQiyehyfizOPB09+enZTiCD9m7smvEQXdsSito+y3zVbzchrk8mfSMD/ItUM2goSpmdrqz366P/WuYkcRbW/hMlhKZ/vAjb2r+kB0ux4haQ7asapTg0iDZGIkBY7eqHXndU/r8/tMw2bciJw8aMXO9OLEyC3y5HGu7PnTab31yRjQLssX5McWEqXqvBTHeYoXP+UkKohGVAsed+45STkHZ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QOQxDINAAPwnlik1oNNov0XlmwT/vAYeewvEJwYKZ0=;
 b=VmTvOmUpN3vRP9ZmS/+WKAkV8lgrJnREnSHqzhlRJSMOQXeON36YXZjhNqIxpdNNyauFKKOH1kiPMLXGSI9Am47nB0eFZXdMRlhVnadP/Trb9kHlQ6ANO1rRbIdrD+YcspOZKa820bOnbNo7xOdnsBmWgk12+Y752EwoM3hqXvIMZzWX6mWmZ2IKYKcPe675IrVB8TThkg26D8S59ZBbqlPRx93Cpqu5VJhEtpJw6LO9AE9v/ziDQY9xcNOHkvuMWaOon0mxUniyFJbgniXoFnej8fAQvriDt59WEA3ctBrjlKvpWjGt+3ZHtaQ3sGRvUdC7i4c2WgwL+SWMdMOOEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 05:07:18 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::54f2:e89a:a3fe:904]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::54f2:e89a:a3fe:904%3]) with mapi id 15.20.6254.035; Sat, 8 Apr 2023
 05:07:18 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAAVGHCAAAktgIAAAk+wgAAUoYCAAAeeMIAAWxqAgAB8OEA=
Date:   Sat, 8 Apr 2023 05:07:16 +0000
Message-ID: <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407091401.1c847419.alex.williamson@redhat.com>
        <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407150721.395eabc4.alex.williamson@redhat.com>
In-Reply-To: <20230407150721.395eabc4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB7540:EE_|CO1PR11MB4849:EE_
x-ms-office365-filtering-correlation-id: 5855b584-1a1e-4cbd-7be0-08db37ef1f60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSbtf3xFEaawI5iEbqxKJGhCnz5KY7q2kX5ys0Fh5MOpqywBj9R6IbEOaRHDMjKzWahrvdQcZwomwuyyi13wStdM0vVieHb3sbeC0L+DBA7cVpPNEAYlyy99AHtAByGY3qOE5eO/+9qaJAyNvgsP+eLFCA9+4vEjnLWsAMQBg/JWZjfRYEizI1LKk3JkWC7pF4hvVv0TN7I1zuCMEP0Ja7LtoycuTH7I/ZIeyDEv078lXPWpag1ejhuhjbu1lkN77mfx6AsBMfulkB0Bz2wZMLDsIF5HVr5WdiSA8oCOBHSQ81Fjj9GJKqYTJUe9HXSLq+zhK8nsuB0NWHjMyNopD/XJaY9ls26drkxqe/pdsCoMWQcIlN9Zyz7YXNcMf6VYK24zMqwia+F4zqjR4KdnC/vm64Vwnck9irEwRCRwrQ3mKbkncFkuPZiuPafD14NzqBPX03qKK7yZ2rDRHOU9Bl4gkq9xd3rIgp3oeFozA7V3CNF5rajtQ5PMjX6q2h+rATxSkQFFBhQQg/vOkryYnj1xBj9LpejE6Fu/GBpsmEtKQauIFqxRi4hPsHL24/WoF3Tm4/Ya46dAb7fwKoZTcMzD4CmGyBXoSLrYRkngunc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(86362001)(33656002)(316002)(41300700001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(6916009)(4326008)(966005)(7696005)(54906003)(478600001)(71200400001)(55016003)(5660300002)(7416002)(52536014)(8936002)(2906002)(38070700005)(82960400001)(38100700002)(122000001)(186003)(9686003)(6506007)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EcaWQkye0Lgm0f92ZCejdLgHelIboVYpb2fjeBV71Up1RBv3MqE4rVMF6J12?=
 =?us-ascii?Q?0YJDusFDMqGSVIbiInSurXQ7dr12HMZA4vaqEGH4TftfEJ0Z5fuBBSLoVCt2?=
 =?us-ascii?Q?Yb0AANnI3uS0L7Oejn4BGXngi2PgpQ9eg50GInNs7VR19a7vbwHixcENBCcL?=
 =?us-ascii?Q?3JiHxJmxhMnml5GqXtXliTZzEEJNKsYxnAVFg260C0Wz6o9bRZDcb90WH5Z3?=
 =?us-ascii?Q?J++iN0B8vDU9kT6CBzHflwOTNebzMtCb0E9DXPP1c5JkCaVpxhnRXyLC7s+g?=
 =?us-ascii?Q?/mSHp16D8kkW16bVzkM5ApwGRShnIZ58gdDvupJaP3sR+49SE9OuC5G2Qphr?=
 =?us-ascii?Q?MBVKHLLjo+fFYXBf5X5HfLH8weDiI70yBHjFGVVNclbmQ9utNv9ctfiUX1x0?=
 =?us-ascii?Q?YUCgzrLLKYWslWZDSUItu8Pxbbag/BB6RVGX+UwMmW60CRtcI1udiFUkyi+A?=
 =?us-ascii?Q?P1Dd31wdzFZOTkeYxVFJ8a0yWNnfkwfLwRIv79c94Svgvoqcg/MzycqE9wd6?=
 =?us-ascii?Q?Kyagp/dhoQnIJqxfIWrBideFxs1c0HaNE2upZv323e4JFG2siXT+aSVIxaQC?=
 =?us-ascii?Q?wjQ3fLA3gG4tBfEEmwK8BOW+dmgoBRK5J0q0+uuPyaUwTo1QwIX4Blto0npn?=
 =?us-ascii?Q?TOE9hIvMRAfDU4nlsYQ9He+8ObXHANGyL9yMYm6FywhdxWWen6ASXm4CDhmO?=
 =?us-ascii?Q?EeELJiDeQtAXJgQPoM5hfjvT2c68ZGa7cxhAfLViJNzT5aVaOaefPNqIKpiE?=
 =?us-ascii?Q?GltdhWJfXpOhJlJGIYg7NY7vQ+HEH99z1Dk+BHzYDLVoP1OGdg0esrS9sdUe?=
 =?us-ascii?Q?5bGGSoIflYSHE6XfuTmUXGlkYqbsyaCC6os0wFDMWVYVaLcZQ9NrYPSLpfYW?=
 =?us-ascii?Q?Pl22Oo+zF9I2aadbVXXh/GKnqLF1pC44OkBcdJWoz1OZ/UHGoYEXS+S4jaYK?=
 =?us-ascii?Q?/X7TdbZexOQx+gOAKZJfO+y1rZSxDal04tNas2PLSc3569vy4ZBGKRgeEd62?=
 =?us-ascii?Q?n0nUMfLdmz6D3rqsU8fPkPs40hzVaPKFSqJHF6UpJf7RArp6QULM4iQLMsbf?=
 =?us-ascii?Q?ajI9XjkT/4Bvlu3MssSXdIIgHQ2vJoGBpd+kqSIFYXBB7LMNodn0VGcaqEzB?=
 =?us-ascii?Q?UJXPx1iip8aNgoJcw1n69Qh/MzIoohXOz4wpHB3W/f1iv13oguqkAPlj5JFk?=
 =?us-ascii?Q?gvn0myb+vcVPL9YfOSaS+blYhq8/R2h22LWR2rN1C+2xPMRNKeyJJRAHB9XE?=
 =?us-ascii?Q?gGXR62I2qZpvlJR5L0oWZJ1w9PYuSK+pe4fB59SKoVBagflWJwdKKxnts3JN?=
 =?us-ascii?Q?uMYRtBczlIJxYbgjaTufEiPcb36sU8j96w4eXm1tOCFqHx8jLaS+fYefOLGs?=
 =?us-ascii?Q?45kJXrqo+SpyYf8n0AHD2dk4c5PbxTM2hebMd17CAdRlUtLlxI+civ7ptqT3?=
 =?us-ascii?Q?MVbqd4HfWSV3k3V3Bl6fYadAn0udEbTtGHQNNtDQSPRY+2afwAJtOqO61MLu?=
 =?us-ascii?Q?8Y+g1X5nHKpWtM2Xh2H9ZjJ+gLyp8Vup7UnnB2c+Sgup94votScSYj9MRURA?=
 =?us-ascii?Q?KAhFViEnUU0pPR2shzg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5855b584-1a1e-4cbd-7be0-08db37ef1f60
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 05:07:16.6086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yu6hyrJFGTq+NFUJoowf3FCU0hCFIW55MTdA1j5pix4tOEGaQKjgQPXJgddVzZ858SEF1b7RTeNShJpDVHkwYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4849
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 8, 2023 5:07 AM
>=20
> On Fri, 7 Apr 2023 15:47:10 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 7, 2023 11:14 PM
> > >
> > > On Fri, 7 Apr 2023 14:04:02 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, April 7, 2023 9:52 PM
> > > > >
> > > > > On Fri, 7 Apr 2023 13:24:25 +0000
> > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Sent: Friday, April 7, 2023 8:04 PM
> > > > > > >
> > > > > > > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(st=
ruct pci_dev
> > > *pdev,
> > > > > void
> > > > > > > > > *data)
> > > > > > > > > > >  	if (!iommu_group)
> > > > > > > > > > >  		return -EPERM; /* Cannot reset non-isolated device=
s
> */
> > > > > >
> > > > > > [1]
> > > > > >
> > > > > > > > > >
> > > > > > > > > > Hi Alex,
> > > > > > > > > >
> > > > > > > > > > Is disabling iommu a sane way to test vfio noiommu mode=
?
> > > > > > > > >
> > > > > > > > > Yes
> > > > > > > > >
> > > > > > > > > > I added intel_iommu=3Doff to disable intel iommu and bi=
nd a device to
> vfio-
> > > pci.
> > > > > > > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices=
/noiommu-
> vfio0.
> > > > > Bind
> > > > > > > > > > iommufd=3D=3D-1 can succeed, but failed to get hot rese=
t info due to the
> > > above
> > > > > > > > > > group check. Reason is that this happens to have some a=
ffected
> devices,
> > > and
> > > > > > > > > > these devices have no valid iommu_group (because they a=
re not
> bound to
> > > > > vfio-
> > > > > > > pci
> > > > > > > > > > hence nobody allocates noiommu group for them). So when=
 hot reset
> info
> > > > > loops
> > > > > > > > > > such devices, it failed with -EPERM. Is this expected?
> > > > > > > > >
> > > > > > > > > Hmm, I didn't recall that we put in such a limitation, bu=
t given the
> > > > > > > > > minimally intrusive approach to no-iommu and the fact tha=
t we never
> > > > > > > > > defined an invalid group ID to return to the user, it mak=
es sense that
> > > > > > > > > we just blocked the ioctl for no-iommu use.  I guess we c=
an do the same
> > > > > > > > > for no-iommu cdev.
> > > > > > > >
> > > > > > > > I just realize a further issue related to this limitation. =
Remember that we
> > > > > > > > may finally compile out the vfio group infrastructure in th=
e future. Say I
> > > > > > > > want to test noiommu, I may boot such a kernel with iommu d=
isabled. I
> think
> > > > > > > > the _INFO ioctl would fail as there is no iommu_group. Does=
 it mean we
> will
> > > > > > > > not support hot reset for noiommu in future if vfio group i=
nfrastructure is
> > > > > > > > compiled out?
> > > > > > >
> > > > > > > We're talking about IOMMU groups, IOMMU groups are always pre=
sent
> > > > > > > regardless of whether we expose a vfio group interface to use=
rspace.
> > > > > > > Remember, we create IOMMU groups even in the no-iommu case.  =
Even
> with
> > > > > > > pure cdev, there are underlying IOMMU groups that maintain th=
e DMA
> > > > > > > ownership.
> > > > > >
> > > > > > hmmm. As [1], when iommu is disabled, there will be no iommu_gr=
oup for a
> > > > > > given device unless it is registered to VFIO, which a fake grou=
p is created.
> > > > > > That's why I hit the limitation [1]. When vfio_group is compile=
d out, then
> > > > > > even fake group goes away.
> > > > >
> > > > > In the vfio group case, [1] can be hit with no-iommu only when th=
ere
> > > > > are affected devices which are not bound to vfio.
> > > >
> > > > yes. because vfio would allocate fake group when device is register=
ed to
> > > > it.
> > > >
> > > > > Why are we not
> > > > > allocating an IOMMU group to no-iommu devices when vfio group is
> > > > > disabled?  Thanks,
> > > >
> > > > hmmm. when the vfio group code is configured out. The
> > > > vfio_device_set_group() just returns 0 after below patch is
> > > > applied and CONFIG_VFIO_GROUP=3Dn. So when there is no
> > > > vfio group, the fake group also goes away.
> > > >
> > > > https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel=
.com/
> > >
> > > Is this a fundamental issue or just a problem with the current
> > > implementation proposal?  It seems like the latter.  FWIW, I also don=
't
> > > see a taint happening in the cdev path for no-iommu use.  Thanks,
> >
> > yes. the latter case. The reason I raised it here is to confirm the
> > policy on the new group/bdf capability in the DEVICE_GET_INFO. If
> > there is no iommu group, perhaps I only need to exclude the new
> > group/bdf capability from the cap chain of DEVICE_GET_INFO. is it?
>=20
> I think we need to revisit the question of why allocating an IOMMU
> group for a no-iommu device is exclusive to the vfio group support.

For no-iommu device, the iommu group is a fake group allocated by vfio.
is it? And the fake group allocation is part of the vfio group code.
It is the vfio_device_set_group() in group.c. If vfio group code is not
compiled in, vfio does not allocate fake groups. Detail for this compiling
can be found in link [1].

> We've already been down the path of trying to report a field that only
> exists for devices with certain properties with dev-id.  It doesn't
> work well.  I think we've said all along that while the cdev interface
> is device based, there are still going to be underlying IOMMU groups
> for the user to be aware of, they're just not as much a fundamental
> part of the interface.  There should not be a case where a device
> doesn't have a group to report.  Thanks,

As the patch in link [1] makes vfio group optional, so if compile a kernel
with CONFIG_VFIO_GROUP=3Dn, and boot it with iommu disabled, then there is =
no
group to report. Perhaps this is not a typical usage but still a sane usage
for noiommu mode as I confirmed with you in this thread. So when it comes,
needs to consider what to report for the group field.

Perhaps I messed up the discussion by referring to a patch that is part of
another series. But I think it should be considered when talking about the
group to be reported.

[1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com=
/

Regards,
Yi Liu
