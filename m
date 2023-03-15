Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A306BA798
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCOGPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCOGP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:15:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910155BD90;
        Tue, 14 Mar 2023 23:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678860927; x=1710396927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NAEDUdeaJvVZ9bimWFrxNGgWnIk4YfNevalxsTp2bZo=;
  b=mf6k19Ju+4WGBMngpXajMduBHenkQ/KgzgVOWEMQKZhOmTuFjLlY8RyS
   /bACKWhzLEnCRYSExwpXIOVK1aNPT/ppWtWjEhZg53vE1CPG3ouyOD/zw
   /Jnsnqsa06OG3AZlFJH3Tha3Giz0tshFNp6dpRNl75ErJA1BAkCGlkiPw
   xg+ofQrkktQJ+zt2cU0qIs/fbM9FMZhQ09i3PqkdBSuOMlSMVbboILUqY
   7UuXBBVgo4iF8FwAikfn3ylFWdo9bgb6GnJI8WDm40WDkmlVVS93dgVrB
   /W06xL4KuoWiJNx9Ohzax+pLluvB/3fafZxjcgN0vL0fe1vlvxVXqvjwS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339163564"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="339163564"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925208212"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925208212"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Mar 2023 23:15:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:15:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:15:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:15:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1hdMlTsLvE2sszZCh4vqI9RqZP2jd2qi+ip+h0m50qHm1yK8E880v/EJopCxdJnulB9DzVB1lqE3WJMu5U8uThBItR+8a9ttuwhuYWJBxCef1uhs92akp44LLhApuIeeXrRy4KOfO87AjSb3xvukBfQ1r1lUIRes7enWMNs+HOlQUidochD59Fc7FdUKyevHQGG/k6GHTpe+g3aqm2cyIgPkPxc1oYzlcdP55yRq+JDi1gZyja8t+j6sly6UIWWp770PHQl500g/J2O5yqgItTAi94A3fadEJzi2ArhM5LQARLH6sy643O7wilT6f6Q/5zxvngTAK4AyM3YTXAZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAEDUdeaJvVZ9bimWFrxNGgWnIk4YfNevalxsTp2bZo=;
 b=cPu0ZJZCF4SDQkZs4ZsUEZcHIag9Z7Or8bg9cSbl8/dVJoFmpfleZtqLtUBjWnWXOj+0/K0dbYEy/T311RxjOn8F/QnZv/GyUiHYfnjbzNCDLL0MQGOomv9U6V49oV4RlZ4jh3ylnz2EaulsckbZH7KSxX0xYmWVSTKanguZUXdvlwT34dh03DHvYY+H6cWJFkzzOCff42gq5LAh8e9ncutjuwkwTa/+Fh/8VJorZPxJXH17eMgN1gDZddsFAEj2ARXY0Yn7C4rKx0gQHaaOXaTpar0x0EuSi7ToiB2pR27GAZmO3HCIftceiGpBjrWu+4xJ5wkpxGW3TspwcsdN9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7889.namprd11.prod.outlook.com (2603:10b6:208:3fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Wed, 15 Mar
 2023 06:15:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 06:15:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq70SikAgAWuFwCAAReSgIAAVgYw
Date:   Wed, 15 Mar 2023 06:15:23 +0000
Message-ID: <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
In-Reply-To: <ZBEY49XtiFUImfe4@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7889:EE_
x-ms-office365-filtering-correlation-id: db58fe1b-2430-47b7-19f4-08db251ca997
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VgNlfqpQF+Mx6n9MGncXTDrLyIjaMokqjsyys9+/I9eyplkc5GffiHa2PJkNR3Q7ctQ7fRIjUTbHR3SgB9xn8NaPEXr9bLiy/l6N4lv4fOlkTdWak0Rp7RcEmy9yQu2YBDU6dWsOvWcbWs99wgRor1ooBlVPWr/gQ/C7S62g6Gltl/IUd5qgWlD0PCbMWEdnUicbsxEdFSHPbhO+EcrBx5wTQKBxIta4dr6h+Pa6CBmSDze4qcCWBQ8pHVeLkPJZtZPuh45lzN4TgFXNnFREkF80mE/MILgtJCbavjCKcGN7aY0NUo0jMzTI3wsJ3aBv8rFGdq29zMk1SQOp/q4Fs39zbM2etsOF6EgDDfe0s3mlviFV77N3y0z/QyRNV02FgYUm5xkJ0/BVWc9eegrEBvedZuvYpcpyDD1fDlbDtEtQoOmc/3g9BVbEw31C0gBmCLXr4zYC0Waro0nBrQCR7XvhdEebICRM4WPMbcT8TD+Xp14fi5OJmCKF7cusjNP8N/6Ym4FsxPT4h7rAAuGXXILMjNRTXioAoXJ+ToKV6XhSObGxrIIg12mRn+NQpOn+q7EpUKaxk9ka+k8/uHuYUumIli8k/aa/TvwfVmrKBGrEbPh9e1MmeDNkytOPTWoS+tiQIi4IkGdCu3Mf+/RvjD7u2RTzy7dR1WcK5HfDVt0k50YPZie/0qQlp1rQTIzjvQbw93dNLVueTMn2v+dWQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(33656002)(83380400001)(82960400001)(7696005)(2906002)(38070700005)(55016003)(26005)(9686003)(66556008)(66446008)(52536014)(64756008)(86362001)(8676002)(66476007)(41300700001)(76116006)(7416002)(4326008)(8936002)(71200400001)(66946007)(316002)(38100700002)(54906003)(478600001)(186003)(5660300002)(6506007)(110136005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LzzDa+/vcymwUhdofAbE3ZiW260Ws6J8nLUh72Xpa7GZYmGhnxSjuSaPy9We?=
 =?us-ascii?Q?9OPL95B3Xb8asd47+Iz69qPavYwCgnYNrx6fAbYdehJ/coBSdVciEeT+zzCA?=
 =?us-ascii?Q?ZXk+aK2qf2F3M+L7H71Zi7qIZG5wwgLr83qYOWm5+2HYGOYgwQqaahhF511p?=
 =?us-ascii?Q?Q8VXC69Dw0XIrPgFNu2VJhfHmHcktEDry1d7JyIJNs9FJhFCPY/18lDE1GsV?=
 =?us-ascii?Q?jswNexRUYowrGUH4bsDyvbihtmXbwMbUllgXIOzbxaQGMklkBpgP2BCYWMGR?=
 =?us-ascii?Q?BiW0AImY8Dm4O47ymkJiOSLkxVEyNfOrV6W7xkdqG2Y0er8/xCYWtVmH7/18?=
 =?us-ascii?Q?9YMwdMRPmV7sE83aGGUwX+IIYoCr0G2k2mzgEA+hLtd4OgVCYXwx/2YpymGj?=
 =?us-ascii?Q?9mVVVvYZ6rT6Ezwdp1VZaNIupFmiLysB6ybUbldal04/PUdnod83NYVijR7q?=
 =?us-ascii?Q?r1/UkW1oOXFyjZ7SX8zniF1SOY4k+sbasPKDENNUuJaMb/RUlJG2yxJwRoAH?=
 =?us-ascii?Q?RVzsSSkjhUNMGwO8JQ58xOTDyBmjQR6WSHLFpM2F/tJyzSLVgTla1FdnLYhH?=
 =?us-ascii?Q?J89X+6aIchBDQiIL1whYgngE/huE4hihOOz9yChNEbjkZzwUKzbUqqgwvWMv?=
 =?us-ascii?Q?EShUSh+fkuDplOaYlItw5snjt8vW3tvPpY+OBlq0fPNe8SyL8nwwg2zu0HWU?=
 =?us-ascii?Q?DLPrPJ3xEDSDVQ9L6DlItI8XQl+mKSPf9eEcavZeDs/f1bHZPELJZfxO2laR?=
 =?us-ascii?Q?sNXkr7jwfkqOhNgPIYXK4MD04fb+Nlciy1arzMVQ1rZ4fS80uCMXkKY+GaMQ?=
 =?us-ascii?Q?8lHDNoeFc1wMydoq3dwfKcI/0lzi1/AblvG5bGJVREL8lxdFb5QgMuJf/zae?=
 =?us-ascii?Q?DPlnGEMyXFAu/V2l7uRC6WwZw7Sz6DCuadXMKt34iWSHsAx89OlaOoRYYO+x?=
 =?us-ascii?Q?7i5q/aHwvWMuNkV7Q/Dhp4vGdzw4JCT5OdOvtyiUHCQXiGS1Iml9G51N5fzd?=
 =?us-ascii?Q?K8bKOEAMGpam+jYE7CTE35J3kqD9c6Mckxpw+la6yr6hxSS8+wytnMzNdDHX?=
 =?us-ascii?Q?LXE6sMrirQuM3tB/7a/u1LvhrYUP3H97osGZRa4Bd9RbGV/bAqqac2G7hzHd?=
 =?us-ascii?Q?ht9ZKx1iF7aktlU/yAvyN/hZP/CnJFD4xA2jKmTuhCcSAjZwvGR8kLUKctK0?=
 =?us-ascii?Q?Xhu6MazXtVtxM+HHXjTqy1CpgFI834+ZJAt/U48stzQWiJtttnUFMX+Aj7UA?=
 =?us-ascii?Q?SBju+QTuELcr0tlh531Huy37xQGBvmxM1NIAlQDwaSytGHt+8ZVqFQm0RX33?=
 =?us-ascii?Q?qJZkeBXDMQYSjWDtpRG9c9aFh9V0yfnSO+9c38ZobtDFVFiLvDM6arqBwU/m?=
 =?us-ascii?Q?0lNehPsmFsZSABMSndmAvWSh1r3jBBdmZwcRwerf7wPRINEbgxyLuJ2eOYWp?=
 =?us-ascii?Q?UIer/2LBl3+LnmREFMDR9tlaSEg0zZzMMjSPCMTAf9DD/ChHYRFfrh3WzQNK?=
 =?us-ascii?Q?/6puR0GpamSolaIcP30imZX3JFuepla3FE6cHodY3x/e1b1AKyc4h5mHbMFk?=
 =?us-ascii?Q?c7r61aqKVC1G0XCTltSz6CJR75HEMBRHs3rf5mw6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db58fe1b-2430-47b7-19f4-08db251ca997
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:15:23.7465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4QjjT+Rj6DQxTSXYNtB74TdCpRu+emM8G88uqbU9iQ+rLWtVweHo+a+ktUpWQfxtuAL5EGNpiQ0nv+ygWMT0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7889
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, March 15, 2023 9:01 AM
>=20
> Hi Jason/Kevin,
>=20
> >
> > Perhaps we can have iommufd_access_attach/detach in this series
> > along with a vfio_iommufd_emulated_detach_ioas, and the locking
> > will come with another patch in replace series?
>=20
> I recall that we previously concluded that the unbind() is safe
> to go without doing access->ops->unmap, because close_device()
> would be called prior to the unbind().
>=20
> But, to add the vfio_iommufd_emulated_detach_ioas() in the cdev
> series, we'd need the access->ops->unmap call, and the locking
> and "ioas_unpin" too in the detach and attach APIs, right?

yes. We need locking since detach can happen any time with=20
cdev while driver is conducting pinning.

>=20
> I tried a bit of some update, across this series, cdev series,
> and the replace series. Though we might be able to simplify a
> bit of this patch/series, yet it doesn't seem to simplify the
> changes overall, particularly in the following cdev series for
> having an unmap() call and the locking.
>=20
> Then the replace API would mostly overlap with the attach API,
> by only having an additional detach(), which means actually we
> only need an iommufd_access_attach API to cover both cases...

there is a subtle difference. to match the physical path:

for attach we expect the existing access->ioas is either NULL or
same as the new ioas.

for replace access->ioas must exist.

they need different condition checks.

