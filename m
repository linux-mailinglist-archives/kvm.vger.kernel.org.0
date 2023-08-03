Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA71776E2BF
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjHCIQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjHCIQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:16:24 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A6C4494;
        Thu,  3 Aug 2023 01:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691050179; x=1722586179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bXhCQcdNJllHCxuTTizWv1Sk+yY653CEic0B7uq3W90=;
  b=ktZYVjBXmb4lFP8bgxjzLxB1a0BySzeYjGz7OolxHPvlf5Kx/qRh6sum
   Kk1StXTiJratadLLvHK7545dJx+tnW67LLlL54x4sdMhLn66o3IQwzRvk
   LpLQX98r/xN30seHKzVb646hi4/ff68DW2XWsu6jzAijIZYhBiavrCZ9P
   fBZ7CSZ4jwiiLp7RA2jthGC9lGrD84wlTgFwhtlDWrtISWHqv2qVk4gID
   HGrJCzDEn3HmC03QEXYjzneVPXUVj2dWGPvx3m6StdTZe6kZhfsEGiLRd
   1/QYqjpUgjHwIML9OdQfg+/k0vKyhN/V03keYbBAvNIZoo6iir6LgDZSJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="372541209"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="372541209"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 01:09:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="843499378"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="843499378"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2023 01:09:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 01:09:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 01:09:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 01:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ys2p5LeD8anTs19rhp8WywXq/IP2KiyNBLXkEl6TOX0xjGpEHnbQrZfXtkzAVRhJfq4KC47wxXIBA8MPLNK3vbpkWLl3QSHTrikCDoM4WpCKbx1YJj0Zc4TOlkBiubX1/FpWiBSPaRbAcguJrkay8WXwQPZxD9cpya8lPvCEeH6XQrVTsHjDbJByGSH/8HRc7FsSgmtROU+2IOKkiQ0cFjlqLH7FcfdOEikObIyBKd3zXQzcb4+lYHXsDXTPc0f5nI23R+OqLXu+XazpY8XcNh7fqX+CVQhicB36v2KdN47VtZ98xv/g5s5X2jf10mX27u1Wxils08BFpnIEgc4nBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXhCQcdNJllHCxuTTizWv1Sk+yY653CEic0B7uq3W90=;
 b=AOEKhluciFwTvxro2cSiwRyyromKK2dR1qmLfcMWhyvw36hQfRQ/zLLmROr/QgjyvY/xkeGP3/Ey0+ZkzKZlX0UxxhgrYchngeM6V/1qBiH337devP8GTsyxqh+hk7Ttpejiq8s8qyMRIM+xADgOY6SZKGM+aMkdOATUGtWrha+86JYt4f8rfLqvshatzOKD+AJjljaEQYjsVdjasZp4HY7kDVR4Ko5Ah6JXBXBMCyRQnu65H1w230k13JfgCWQvwgk7dwTXMGZ/1XzoKbi3mGO0fDSFM8f+ECjFCtFk2iiIy89Bq3F0vyme0b/d/WixFgQvGQEODti6p4zcAk3fXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6346.namprd11.prod.outlook.com (2603:10b6:208:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 08:09:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 08:09:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 07/12] iommu: Remove
 iommu_[un]register_device_fault_handler()
Thread-Topic: [PATCH v2 07/12] iommu: Remove
 iommu_[un]register_device_fault_handler()
Thread-Index: AQHZwE5eqASGTA3dZkymA7ydIAzlXK/YQvvw
Date:   Thu, 3 Aug 2023 08:09:33 +0000
Message-ID: <BN9PR11MB5276347D34BB07C99414B1008C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-8-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-8-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6346:EE_
x-ms-office365-filtering-correlation-id: bc169b3f-ae17-4e3e-8c57-08db93f8f8ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GamyHheTMsPP1VB8v2Hpq/vAh3vP1PftSDS5a2iNZCThY6ieND0CHIGC9OIkEtlqeqSq3Vwi1mXjKf0nJvKKyAOzyZ+pXjPoOEve6lvR/VDe/Pt2liNNFVb6taPqQcaAaNWWeR+Qouh8pqLVlhayektNaLvM6uYNBHnoLrdqL/z9lPXvHD/RQGq+gxoQNXsWp7z1+zvSWa4b2Qkd1CtAkyZ4rk1+TOt0MGRtk/DViahqNAmvSz1wTpEAf/KZYqRrgcyLnJSzGH13NGKI0FRh2UZgUP+vLDQgC5rQheBr3x2ysHE2VX54A+MMiv2tKvsPvoQdGdcTs2lcHq8xYU/ojMKDlzJMBy6VnWFb4utvgsv9bg5jI34X5MBlTvsQcTGXri0g/ShXMKu/6AvLPyVQucGc6omK50G2BsjB29bVAxzmN/c5Z4xHKRl5Cwvu0LMiNKYGpVeQH3XUS6FidwcdBggWVmPsmfboeftc2T4Bz7k6axJm5YNf5iMUQaIbrLeZ3iKI5Z38I56+3XpVKV2CaxxeLwp8Y0+1fLpjgpr6NaVZ4lZd7jC8n9ctun6sI9ZcntmeY5kMYprkTfAY9qHoq4vUxo5AlxeiI0zpHqM/dYirIz4B/EUGxAtGgXgf+kw7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(7416002)(5660300002)(8676002)(122000001)(82960400001)(38100700002)(41300700001)(186003)(316002)(8936002)(26005)(6506007)(64756008)(4326008)(86362001)(66946007)(66556008)(52536014)(76116006)(66476007)(558084003)(66446008)(2906002)(9686003)(7696005)(71200400001)(38070700005)(478600001)(33656002)(54906003)(110136005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z5/kxaCxvq4NHuyVSofp0yxTnbbaoX9Eh60F9cOp34yRHh56COyJA1h0VfUb?=
 =?us-ascii?Q?IRly2lrTQx8RfxTtHPtRgouYp6mNokVzMxud4PpWx+24s9wSlHZXYPRraxJU?=
 =?us-ascii?Q?OYwJ0s9XAtKav2OePgJrgxRbG9iMiJGuSt8ZHv1c/UOSMKdBBEwPzcxeEEzO?=
 =?us-ascii?Q?C6Zpl2Dn+jgvfzfQlIAJTTSIOdWLtI7bHLMYvd0n9sCyAQ7tFHHB2DJi0pia?=
 =?us-ascii?Q?9AQo06GzYaHei4gWes8KWMo1TwMQfu64E7yFQCUZxrcqjUcZ7ric7mJdCM7d?=
 =?us-ascii?Q?WX4sw4OBZNVOMgw062Cp4NOpF6wJhdTQJ1rJ+CDjILInpxjYObr5Ryoh0Tg2?=
 =?us-ascii?Q?oZjVnlgASXmSVNJ9uYMHz/5ONj03xUaUk00maWFnvYVRyPGQ4kcIko8Fpsdy?=
 =?us-ascii?Q?5nDhwUKEriVJG+NF4DvVpH6k2e192QuZycIAfJEERju9mUKBccg+D7zB5njo?=
 =?us-ascii?Q?sV8QkOpQhXfhH+yuzDR842hhQ8KHe6NJVhlO3mPAGd0F9pClSVp8puvnu1fd?=
 =?us-ascii?Q?/A+8Kh6/zfB4LpmemeqPmMRhAMPAUV9yjmfjA3yDlqYAClyGA+M8NWUtDQvK?=
 =?us-ascii?Q?Hyo1N24eKD2R23BRbL3QFcqTIVa+nXfPQl5g+wokefvLpxJrY+rrlkbQWnPE?=
 =?us-ascii?Q?bbCbNL8p5dDR8SGppkmW5/TBVAuXZaBwqdBxr4roNOnFksIrjgcuXyuIxfMr?=
 =?us-ascii?Q?WmwWmp8aDJzBr05tPWGW00Xn/ULJ3Sl+8ZPqWrVPBlETf0kM3MPT+PWCi6ih?=
 =?us-ascii?Q?H8bmoEHpcCEj9EPLwE0fbY0AaVctUMhKxjLk8geHm6cKj74K1I0n4cTImBMO?=
 =?us-ascii?Q?PypvrM6/q1CkvKfsZDHmx/tuGRVcbEol4g5xcEpmgwIV+LRdtiwkGEjjwBHH?=
 =?us-ascii?Q?JfQdstRRv6E0pO0OGaUkwGi3Z7q4KmMd4XAzANQcVD8be2hr2v+Uz4X2TlzI?=
 =?us-ascii?Q?2CPvQC0NV6MG9qcDmb9MGojvAFxatkyAnlFojH/ZcSxrRY9ECkSc971zWRup?=
 =?us-ascii?Q?O0egbkwcM1aAPTdI0chnG2bkHzOFuX/IByhrZqurhEuYROYg6uHeoP6WovuQ?=
 =?us-ascii?Q?lDBMMSFiUOGz5gC6bw8aowr+4zD+ZJ7Cpc9+5k83Tv/3t0kc1ksCrLGDT/5F?=
 =?us-ascii?Q?SShZ9tXU3cuaySspISgc2S9OftGQGSvEdED/gs8AFZYFnWAjeWYpXVheBzj9?=
 =?us-ascii?Q?IZjpBPUSw6D+VIVuwehZCa7nqdRwkVBi+c1pGY5DZvVG3U77BBZLoAX6l74n?=
 =?us-ascii?Q?bE6kUSL0ZUam+RYrW3iRIxuLxdaiHmuWJjk+yJQhcWJW0x7uSXNXtXl8ECEl?=
 =?us-ascii?Q?J5S4fTMyZcEbVyRXkEX9wM/zofiJWh5AU/+iJZvAHSDpIfJL5yBLSPicRY/L?=
 =?us-ascii?Q?R9ozo1Es8cMDQADQlG5tzUcSTiIPZzawV7vR0jOeqCi30F0J6s7vglWyY//E?=
 =?us-ascii?Q?XzVmoyS9DFGLDZ5VdoDVDvMVPRQ7KDhgUz7ETO7gPxyBdV5rRGzhEWPywnEp?=
 =?us-ascii?Q?/MZQ5FZcKcFtVdwd9gqTxCuClBqLBRKHSQRJeyXqjLHGP+euNHqQgBoLSPID?=
 =?us-ascii?Q?g3v8Z89pd4SgO40Fdwtzytn/MpUd0W4qn+hXhPIO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc169b3f-ae17-4e3e-8c57-08db93f8f8ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 08:09:33.6163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tWAIYkzED/aUeepf6dYG9Ww1erdtTMa9iq/PUaMzWiwMIv8C73hTou8YJTpNqIW5zeXncef9RJsTNyTPa1U6Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6346
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:49 PM
>=20
> The pair of interfaces are not used anywhere in the tree. Remove it to
> avoid dead code.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
