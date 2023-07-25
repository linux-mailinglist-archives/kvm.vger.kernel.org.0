Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751D8760963
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 07:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjGYFiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 01:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjGYFiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 01:38:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A88BE54;
        Mon, 24 Jul 2023 22:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690263481; x=1721799481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W4Jx6Qzi+TtjFrpBwJCXx+SJgRCZ1fUARlSosx3Qf0A=;
  b=RIHTvRMxxRXEPhFpU8rg9WjdjWwhOSiT7xtJ4uOOkg+wTv/XGqj/NU5I
   cqk36p7qablThW9LdseAQfMW0NIa7Xz0YrqVfLLvMl1tuOpYb0b2dnpU5
   oWz5rqwIyl+vzwJUk0YVCmvQSPSpOMoDE6WI9ygy8oNh7CoXkELOPGYln
   sXb+Dycr8/55pobUZIWDFq9y9SoBXhgChIsR8AuYTq4xR1oB0DXW2gx4o
   F9xv/rLlBMT/pgYZmeyJDU9Ukuy7LcnhKHZQl9sDWrwPG5QMwvVJr7jsc
   oBUTDye/3Ku4n/Oatn8Ud3JES5CSQ+tiA7ohvx/1G17PHeA/p9LYt4v9M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="347895843"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="347895843"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 22:38:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="729204600"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="729204600"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jul 2023 22:38:00 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 22:38:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 22:38:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 22:38:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCR27xr27IQVSpkozH7g3ARnRH4Zpve8kWaKa6PMdeGjBztcrOVHDE8Vn8hM3MJuG+nOK9JVEbY1NRTslBHbgLUm11U8ngArLvLtJMbR+mH25WuWlYpcmPaJtT473Gf2UJv+iAqgifE+kfmBTaDX+Nc9uLnAGW3wZL2bgiEIv67NQJe3sReeY/h7k/rpAu/8ozcsTlecinenAWr3WIZk4FMkLmZM3Oc/y52vlrtSQbTmag6MHNo/XcpkS/brTOWJrewqswjjmTj311feMiUVt7Zs7nT4xxe2LYcFgcZUyZm+LARIyPfP8TaS7ZBJhTcqC2YQycBPRUaiSM0Mx31TuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4Jx6Qzi+TtjFrpBwJCXx+SJgRCZ1fUARlSosx3Qf0A=;
 b=ftpPdl0ZBgGxOS96TsmNOG+ySAZfb6tZ7u9BQoplJSL4unBAswn/A+obicqc5kNyVnGVWpNJwoxfiF1ZTIKE8rEERsaWX0xdgwFJimBAiIrlLsEP3G1mc1o2y+LMVRmPDl01cP2QM7WIrcDXKL516juIXu5LVpThNaKO1lKr82K1TQBweKA6/L7aHP/1ezPHg6dRTUeG3TdaSJDuyP3ETo6Ag085sxLvTdCuk/r5urMzvAKxy/warTyAr8+pfZCN109YY+ozVFpAqE5rV0ytch2ArjzDnrzEypSLVDfjyinfyogW+Xo2EIqoV1eOZHiUB3ip4u33OszaiQZkKLZH3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4SPRMB0075.namprd11.prod.outlook.com (2603:10b6:303:20d::13)
 by MN2PR11MB4646.namprd11.prod.outlook.com (2603:10b6:208:264::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 05:37:52 +0000
Received: from MW4SPRMB0075.namprd11.prod.outlook.com
 ([fe80::98e5:837d:71bb:d61f]) by MW4SPRMB0075.namprd11.prod.outlook.com
 ([fe80::98e5:837d:71bb:d61f%4]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 05:37:52 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v9 00/10] Enhance vfio PCI hot reset for vfio cdev device
Thread-Topic: [PATCH v9 00/10] Enhance vfio PCI hot reset for vfio cdev device
Thread-Index: AQHZs5/OQ/3fU+POj0u9cBsabd4ura/KDPaQ
Date:   Tue, 25 Jul 2023 05:37:52 +0000
Message-ID: <MW4SPRMB007518A8FF3240C2E73CBB85E803A@MW4SPRMB0075.namprd11.prod.outlook.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
In-Reply-To: <20230711023126.5531-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4SPRMB0075:EE_|MN2PR11MB4646:EE_
x-ms-office365-filtering-correlation-id: 09a371a4-48bb-4263-e7f5-08db8cd14a6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5CSJwEXc7x68ifr5rWulBAuSn8GEJNI92syivQiK4ptQ0o+DMxIr55CzPXBp70LyrAWAntHUzP7icB8qSavJEpO75h2BK6fwcMBpOL3tzIEH1Tz7/xsdsJGV5IMa5fwJfxJA3/5rmo3//UNgk1qAAPgcDqSK2alCqKgR526M2vQQCkr8OQ/EZ0aLD8+fICupnYnMywc+w1WzygahBdB4WmtIH/lMOvb8Rd/feDRO/Dij82hIxhZJ0wxbpa+AmV3v4pmur6xEL2CYnsolLGS5onYV7yJphs8uskkUdY1/UEndNWdto9SsSl7ce844qcMfBMELoS8qP50djCrvOVw9PLrTqA6ctDiNbV4RA/WFWZ3Af2EghH6CJkwnnsJsgkvJMP+xPL10afdvPnBuMUtridgFa9wJhdxW0er8sWhJDajzlp3Qqnjz+aUQQmLrz7OUoCCvgK68aL1LMQYRLT7ChH7VTKNCNnur5RiMQ6wzVZ3tFNcf9rHsn02hfRiuolFkF+yWS6VpcwC9eNCnp4KKAXQ6HoGvSUnA3pt2yZATSVv7mdzSqDB8oeNRa2v9dgkjfF4GsjkcSLbumtlqJQFfjf559vgBJ9RYcIApLmpw/ps=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4SPRMB0075.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199021)(55016003)(186003)(26005)(71200400001)(6506007)(64756008)(83380400001)(66946007)(66556008)(316002)(6636002)(76116006)(66476007)(4326008)(66446008)(7416002)(52536014)(41300700001)(7696005)(8676002)(8936002)(966005)(5660300002)(9686003)(2906002)(4744005)(110136005)(54906003)(478600001)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2R3WSt2QzhPS1ZSRGR1aEgrQ0pTQTRqU2NzeDFGV1BpN1BWa3FXTy9sekZJ?=
 =?utf-8?B?V3I4UUdNRmwvUzNoNFBZdWVqVTE3bkpMeUROc2ZPMC85ZmVMa3NWNnFtMnhC?=
 =?utf-8?B?Z3Y2NkJ0TVlHUHAxT1d2ZWtjOXFFeUhqRnpmYjlXNmV1akdRbFJEWnRrSXY3?=
 =?utf-8?B?MGQwSzJ2NVBtK3ZvTmhlZ2oyOVBsQ3JkQlhmLzZJVVVpZVRrdW55RTNTUG8x?=
 =?utf-8?B?aE9TcWpkbmlDcUp3NVFvYVAzeTVjeVZsNUxzNmxpVzh2VU55NlNTa09HMFJH?=
 =?utf-8?B?Nmx3L2JyNnRZVzBxWkhKUzNDakR3Vmd3Yzc3ZlFpelNteC8xWm0rNS82WlJU?=
 =?utf-8?B?blJhdXVscTU2elZ2Y1ZpNGljbnFKcVNVc3EwWjg2bzFscmt0bUU2cGNUamtq?=
 =?utf-8?B?REQ0SDJocENLZnB5bkx0dHorUldaNk0rQjV2T1ZKZ3NPWDgvUDVEMENWdE8w?=
 =?utf-8?B?c1kwckk3d2FBaEs3T29wdVZyVnM0TGxEb2dFcnBUYmxTR3VXS2pIclZVakhL?=
 =?utf-8?B?eEZuaWJFSUFFQis5TkV5YVFaQ1RoWW56Z1ZZS2Ezb3ZPYm1zQkFwdmZWR3pp?=
 =?utf-8?B?WHIzUit6a3lIZ2ZGMnV4NkFtMk1saGRkR3VSOE81YjdFejE3dHJ0dVVNb2VJ?=
 =?utf-8?B?NEI3L3pZK0gwOUlOVXVZbEV1V1JjcXh5dFpJb2RGQzRLcVVhdEJFM0QzOTY3?=
 =?utf-8?B?a2ZRT0Y2LzFpR05vN2ZyMEwxZEt2TE9sZ0pwVW1JZzQrVUtINDk1cHpCYzBx?=
 =?utf-8?B?VDRLNVBmNnpzN2E5a1R1Z0R5YWp4cVdJcFlGYzZwK3R3TjNYdVovUDd5S1Bl?=
 =?utf-8?B?cjFGZERCT0VTRnlHMER1cEFPbmh3dHBkU2NZb0oxamN1bm5LVExrM2xRTkEr?=
 =?utf-8?B?M0pCaUc1MzllN2J3cXlZMHBuc1BPeCsxa2xWc01JSklQUW1ZczVVYVpsc01U?=
 =?utf-8?B?QXp5MjhwdU5HQldmZHNmM1lYa2RLRVUwRWptZXZLbmpWNC8yV2NvQ2lrcVNR?=
 =?utf-8?B?bkJBQ0VrWFhhZk5Xcy91NStJSHFOcmxBcEN1Ti9tTU54b0w1WFR6b29kOVlE?=
 =?utf-8?B?djREWGR3T1ZIdkhMaFFySVpLd3hhejIrMGc2L3UxQXplTVVpTHNUaXRpWkd0?=
 =?utf-8?B?UEs1UHowdkhtd1o2M3RTUjk2RDBJR2hkU1dSTFEvcytaQ21YVVBURTFGcjBH?=
 =?utf-8?B?K3RoZ1pUdFZIQnJIbTE5MHp5bklqNmR3bkd6QzVTQmFsQ1hCd1JvYXh6Y2ps?=
 =?utf-8?B?emJNNTlPbDhwSTN6TlhIaG9kNUJIL2ZCRXAzTWdaTlRvVStseURvd080U3pt?=
 =?utf-8?B?MktGb1lIalUvVE5QeDM2MFNueVUwV3FGWjVndE9uUWJVMlNPaUhPTVhOL3FY?=
 =?utf-8?B?WlVkK2pQZ2FWK21GNjdzNXdHVHdTY1Q5aEZlMUxxRU1MMFRUMFVmMjZjRDRq?=
 =?utf-8?B?dXZnY0xJamtXV3lQUG1HWUxRTFVxMGpyV1VQRXpmNmNtT2hwNWVLZWVNcUk0?=
 =?utf-8?B?MnA1aThDZ0orWFRaWW1FQXNWSnFYcnduRDFRR0p1K2hXQzREK3F5SjVOZzlx?=
 =?utf-8?B?NHIwZ2JtU0hlK2NOVndMYXVrODhwRi8xanJZYWpTMjhscXA5aHJvMmlzY2Vv?=
 =?utf-8?B?TktHYm5na3luekxPL0xNelBoZkdTZ0lTMnNJMmZhVGFFdGJtajlydkxEelZD?=
 =?utf-8?B?YW9zaFJEQUJzaUVvdXZOL1JmQ2F1ZkF4NmFFZlhDNFZEcHo4VHozMlA4RHAr?=
 =?utf-8?B?S2huUTJGVjhFVld6N2h6TldydlZUa3lkbUlZYm9pYU11c2NYbGplWW1yMkVX?=
 =?utf-8?B?YklKTlJXMjR4MmluWjIvaUhGTlpmUzdPTFVCbngvV2QzY1NRVWV1WVV3ODlT?=
 =?utf-8?B?Tm43K3RnNnBoOE8zcGtNUUpDSitwTFpoWlNZcFRmZ1Vnd0p2U3o5ZGV1ZTdV?=
 =?utf-8?B?RURUQmpqcFZnb0hVT1NVOHZTTXI3UHJGa2MyaFVRZGxNcnh3L0MvUGV2elBB?=
 =?utf-8?B?d3p2MzJOVjNqN3lmNmFGUUc2VytaUnBjd3hSQjNIL3hyc0wzTDhTMlVQUUhE?=
 =?utf-8?B?cFA3WU03bFZmTVRwOEwrMVlrazY0SUg4RWM1SmNqY1ZsOW5ESjRIdHlyeXRz?=
 =?utf-8?Q?1KfsAF2rDcGrTDi9+UQx/zuUp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4SPRMB0075.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a371a4-48bb-4263-e7f5-08db8cd14a6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2023 05:37:52.7676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TZLErOkpys9+6WpxNbFP7P2JxBubB/paC5bSyW5N/LVsgQ3aQJqHf2a0txlIFONWSAQxSlJmID6httaXkWPKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4646
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

PiANCj4gVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCByZXF1aXJlcyB1c2VyIHRvIHBhc3MgYW4g
YXJyYXkgb2YgZ3JvdXAgZmRzIHRvDQo+IHByb3ZlIHRoYXQgaXQgb3ducyBhbGwgZGV2aWNlcyBh
ZmZlY3RlZCBieSByZXNldHRpbmcgdGhlIGNhbGxpbmcgZGV2aWNlLiBXaGlsZSBmb3INCj4gY2Rl
diBkZXZpY2VzLCB1c2VyIGNhbiB1c2UgYW4gaW9tbXVmZC1iYXNlZCBvd25lcnNoaXAgY2hlY2tp
bmcgbW9kZWwgYW5kDQo+IGludm9rZSBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VUIHdpdGggYSB6
ZXJvLWxlbmd0aCBmZCBhcnJheS4NCj4gDQo+IFRoaXMgc2VyaWVzIGV4dGVuZHMgVkZJT19ERVZJ
Q0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTyB0byBjaGVjaw0KPiBvd25lcnNoaXAgYW5kIHJldHVy
biB0aGUgY2hlY2sgcmVzdWx0IGFuZCB0aGUgZGV2aWQgb2YgYWZmZWN0ZWQgZGV2aWNlcyB0byB1
c2VyLg0KPiBJbiB0aGUgZW5kLCBleHRlbmRzIHRoZSBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VU
IHRvIGFjY2VwdCB6ZXJvLWxlbmd0aCBmZA0KPiBhcnJheSBmb3IgaG90LXJlc2V0IHdpdGggY2Rl
diBkZXZpY2VzLg0KPiANCj4gVGhlIG5ldyBob3QgcmVzZXQgbWV0aG9kIGFuZCB1cGRhdGVkIF9J
TkZPIGlvY3RsIGFyZSB0ZXN0ZWQgd2l0aCB0aGUgYmVsb3cNCj4gcWVtdToNCj4gDQo+IGh0dHBz
Oi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvcWVtdS90cmVlL2lvbW11ZmRfcmZjdjQubWlnLnJlc2V0
LnY0X3ZhcjMNCj4gKHJlcXVpcmVzIHRvIHRlc3Qgd2l0aCB0aGUgY2RldiBrZXJuZWwpDQo+IA0K
DQpUZXN0ZWQgTklDIHBhc3N0aHJvdWdoIG9uIEludGVsIHBsYXRmb3JtLg0KUmVzdWx0IGxvb2tz
IGdvb2QgaGVuY2UsDQpUZXN0ZWQtYnk6IFlhbnRpbmcgSmlhbmcgPHlhbnRpbmcuamlhbmdAaW50
ZWwuY29tPg0K
