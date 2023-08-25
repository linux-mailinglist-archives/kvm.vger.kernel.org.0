Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D70788149
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 09:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbjHYHxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 03:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243250AbjHYHxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 03:53:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9DF1FEA;
        Fri, 25 Aug 2023 00:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692949996; x=1724485996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5m7VMdyYue8rDSoGsko3GnbRd6JYE8AA5ivtzqWO8I8=;
  b=Y/44ijGK7wiBa/DkAHCCCo60lG8cAah6sLeofhtQ5BXdLHsEVNnN9+kZ
   djjNxUaxmxj/KVV0bRjavtSNMIdp+Z1lsCsObZbd/xBZpyCvzp0Rp8FyR
   PcUKcdLeCD1tmx1FHuRJajktpTsz5JEBDfZ+SOwIv/U92T6QQges/S8kb
   8UcT9vMhsl5NuORl73dZmUDARfxavrh4mDxFtMi2YtcQqCQMlrB0DTuvk
   r5frwwZ9LW8m3mRY5QoalxeieEEBBjA4Fig0GwTQs7s9NI3q+UG7JSHSv
   w10YiqS5/xWXXnGvlbEzWpu3uCxJUmOSdKPv10WMc5hpUm/aG3GJKpdKd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354987140"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354987140"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 00:53:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="1068154072"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1068154072"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2023 00:53:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:53:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 00:53:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 00:53:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7+2JcG7mtruSoIYOkFlxyfxFAuF1wtyoP0+JYZopsCVFlzna6qCXX2zeeE3tNACRGqOecvJieoTbikrDDiNivL2tj6cHfhLWmXu3YB/93rzpX8KvLgTlJMxp+54IMLYQho5DdFNQBBbCQgKO5z5/j79cjei5lKZjFF+gCNWHYKoJJJz42YFBo/Xo/u4RSyGcfaJ3gBupPiGXmx3MucJeu6YIDNamKtKLW8wlJDsCg+aqS4SnSm9iGF9Doajw+uvlwg7974benKwX/bM3S8MH//vluIdijP6xMXkJxg9wGHqi9oJ0CrCzmDY+z5eUqVSKSraOE6ZXGNTycTDVjIINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5m7VMdyYue8rDSoGsko3GnbRd6JYE8AA5ivtzqWO8I8=;
 b=EKZxvcXDrrMJBGIo4mk3twCjb3o+IYKkA/PfoLWvOOYbvMX7COmqM62kTEjiUrvZhtMXII272l9zHz5NyJ2yzATBWluT2j4w3wrttEl4YscLI7iKam4nAI4kWB2i10yb+Ieqj9J4UefVr5vyM7hI3G3WBYfYlHMr+UzpZESVhsHlEOCcSGnXnvWqdI2pgHdCYll30ryhh9vgqDPdCpZfD3mNZryBTFcY8Y99ajBYJj2OJNI3Cm6RpGObLKt0Hr044owkTyJ92csWOOuskpPgNejuRXDmXXRLsbbNAdCDUShcF3vPj/QrIDS0JwufJBHnxPHlfE4vL0XYTQNZ80pgPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8700.namprd11.prod.outlook.com (2603:10b6:408:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 07:53:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 07:53:13 +0000
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
Subject: RE: [PATCH v4 02/10] iommu/arm-smmu-v3: Remove unrecoverable faults
 reporting
Thread-Topic: [PATCH v4 02/10] iommu/arm-smmu-v3: Remove unrecoverable faults
 reporting
Thread-Index: AQHZ1vyPumXO6j/0GUeT7UHR2B5ML6/6pFug
Date:   Fri, 25 Aug 2023 07:53:13 +0000
Message-ID: <BN9PR11MB52769F94C7023F1320A10F148CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-3-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-3-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8700:EE_
x-ms-office365-filtering-correlation-id: 54900d32-523f-4f94-9437-08dba5405596
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: somE2yKo98mPWsZAYNnunKzZv0Y4grSrjFPjqkW7kmIafTj1QRPhxbO8saSMMBlYRZ4atHJKDL/Nu0QH9Mv1INTu9r1vAX2LMeWtGeUsvlP50LHzNxnW5pEZqMvTOQ1ajo1Ol8r+070SZZSy2B9yF9d/bybY0kv13Esiq527ynD9PmEM6nBCAs5k02I+AEBRoeVJFvFMkSVXCWq17Qlso2WlXU+qrhdG44X2aMhJ34w20UWjcyPEdnClMCACTk/FI1JL7Snjo7IOC4D3BjQSQ+40scjIFupbtOlRWXkke8VuEbbCKjg7L0ohrt3t/+jIYFQOEgepjc30BJeqznQq/lk9jl2b27gRCM1aH8I1ApaJfZwK+Q011te1CK8EnvNTojLwOESg8p8X45m0oFdnIWSUDVRE3AUSw/U9gJG3oiW1xncjgWm9VmdzTqdfeOu3ukpQvIRxmCvckaGTXhd/uSmXwp/uPWCoBxHOOeyij0B8RMt5MrhMCnXk8ikjJWZGX3UJv1fDMo1iEaChCp6niAoN9mA62Y4j2qbRX57zzfmr97DpXiDhEtxRY9st61UuRuII++Vxh6QhyFHqay35iP3T2z2tLli2YFQj/TFwOlc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(396003)(136003)(346002)(186009)(451199024)(1800799009)(66946007)(9686003)(41300700001)(7416002)(66556008)(66446008)(66476007)(54906003)(316002)(76116006)(2906002)(5660300002)(4326008)(52536014)(8936002)(8676002)(110136005)(478600001)(6506007)(71200400001)(7696005)(55016003)(26005)(64756008)(558084003)(82960400001)(33656002)(122000001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R1yMKcFjWvCBmtZHylOf+cERVzpcPUmv4wAP8UPvYoi2DJD0qb/Z/JxFgEtM?=
 =?us-ascii?Q?Ls2Ed+SL4v0txAFHuUZ0Fe7+BGXcI5IPpqhLy0Rx6uMCYZLEhsHt91aPYlv7?=
 =?us-ascii?Q?ScKLs/Tffcz077MwXx8QYG2+hOWFz7GsnE5J+syVOe9vyNsalLvE1XDeTmEw?=
 =?us-ascii?Q?KXZOmTC7DGuCO+FFkH1E84Eq/FCI7oxEgNSgPiMBmhtqO9sJefKbf0/rFGIe?=
 =?us-ascii?Q?G1U0ZiynPH8XTfq70a7K6OlZq0/N1dPTB0lJCNQet118GVO/gAFbTmDMv9dg?=
 =?us-ascii?Q?8LYcqYuonPQFep1v9ilV6k5I9H4eqJ6FIUmVGLEas64MJ1KLo1cDF08YKrW9?=
 =?us-ascii?Q?sBVrZyL7SzsntcfuxMfvx0T+vAj98tKgsCAWLsODvIGTD0BBZM1azGIXE3hu?=
 =?us-ascii?Q?57cYu/b2V17vo6zhT6cglDIopxdYNUtw77Pzps8yC7jZbXoLS+Q+R4X6+gC5?=
 =?us-ascii?Q?p9Ec5vNsiJoEIM6OkMPQ+pEF/33A0buhOd+r+3B6xOvZqolImlM7sTrn0EBo?=
 =?us-ascii?Q?wTQ1ACmhRedLYQ+ZvV4xRhQYkZo00ZPbG2/AOqIOg2uuQWVFSlw8fke4gRel?=
 =?us-ascii?Q?JNyUqUws1K+Os4DeNLxeBU7mo62OYqwGr8MUKxV+ijR9zUmhz9f6wE8xb6IN?=
 =?us-ascii?Q?hv5PzUprznfz+D2t71UIOETXQiaKhb4mdBm5CQOFh+EV88zAkPypO12ysALz?=
 =?us-ascii?Q?iYtCkVztZpzb9kYEUKs1nNGRx7CWfts7MKwZG2QnHBL5y/cgK6geHE+qr/+e?=
 =?us-ascii?Q?TtqFSNSYNubEFfmBM65Y0zQRT1HEFbdVIgjKeEg3AwqMvci5fN+zofD7tpvt?=
 =?us-ascii?Q?7POzf278z6u59mo4YLtGz+67WmSy7hJKQxMZeO5mhsQ5pc5EbgwDxDrYWskg?=
 =?us-ascii?Q?SltaQY2QT4yzx/avOAqFYC85VWIrez6+2v4o5k3zRuaJU0qCnCFbxiVP48AB?=
 =?us-ascii?Q?iINAmoTw41z8936P8bYCsogI6qTxplt0Nvniwha59Zr2Ztnsqks09hGeIWIj?=
 =?us-ascii?Q?G6QfB1eaxvIufJXLikfF6uH9c8aW6r5ZR5nDhmII5kjW7rJtSqLu81IW1iaE?=
 =?us-ascii?Q?19zLgzHmKEj5q0oQxUBh0QUwZsft7AU7yCJzrExKrJTHyngTMflu1CBieFYn?=
 =?us-ascii?Q?kCqFG8YYPDbaOYcUBdbMbvvYTF80WZltlPUMvX6IjrhpT8VsSAZp3En3tuqY?=
 =?us-ascii?Q?MI1keGkBtLu0F+AGhR+UVO9Mi0yhczOrDF8G83LT4PlZqCJb+gVN+Aa4rH1M?=
 =?us-ascii?Q?j6fJxZ8QOT8K3SDQ/fvv5bd2qYv5lnmh37oATVe3rCB9+efkAduwkS+t08KT?=
 =?us-ascii?Q?mh7f5GjUb9f26P7+0GNTHvV+Fbf+VkPR1u/BwT1Xjv7O9lb+oylnHAQhj3HC?=
 =?us-ascii?Q?qto3jWBZQzKUG1HampETlyPQzpVhwOL+DrCrvPuAxhoYiWnuuiKBADVbW3x+?=
 =?us-ascii?Q?zyQFecp2oXqrrlb6T1lmS+38cD7yohGJQ85ECQOBXT+DGN8HcviIs0zjlAG3?=
 =?us-ascii?Q?kSehfWz7uNUR/Q0azuawQ27KrravZCmbNSjM4bS9t7bDQ9iDwUlYpjzIiEGl?=
 =?us-ascii?Q?Au2KOpLF0Mx3PEglRvtihYvSzjWs7Fq7vsNo48ae?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54900d32-523f-4f94-9437-08dba5405596
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 07:53:13.5353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEXHKf4alX7fclTckxyzQkX4/K2xOoTbw6ruLwEgQuqgybuqgAEetUNjbOFklbl3roYwkvt6nuFkbA7IiXC59w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8700
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> No device driver registers fault handler to handle the reported
> unrecoveraable faults. Remove it to avoid dead code.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
