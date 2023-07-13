Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA49751AC2
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjGMIEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjGMIEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:04:02 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1ED2D6A;
        Thu, 13 Jul 2023 01:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689235338; x=1720771338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r1yAH9VQqTbVE+55cI6miiOc+1mfNvv/czLyTtZterM=;
  b=bTvQOQdHSjH/A7xeynI52MQJb3l+bvkwYDivz2+n6kNffU1QrBnT1y32
   AfoSqLLXIHGJwCWp4rd2mEaHDavXLRNw1PDsx6JLL/3kQPzMl7cMtGPTe
   5+2T8ufZDxjei8IKGbFuLBqJuXShPD9iJL44peRMNEE3+fenPnc4vbwId
   F/8d/b+Wjl4RD7TGAvb59ZIleiraodWe2cjhSOBk3RgCARuhDMHLYyyt+
   9WlvVYpVAmHluogxnuANRXIbBnAwrznZr6d2PsPWrRQiOMBNrAUpc3Z40
   hpYtTbgeAQTPwv3IeXZcq7dz33dJvUvaPV5mXV3BxXQ4RWmYTQS8Kz7jn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="355036746"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="355036746"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 01:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="672190416"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="672190416"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Jul 2023 01:01:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:01:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 01:01:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 01:01:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVfW3g6AeAklDL8ApVaHr0+EDqDVP2J/k9x/dZy9E1ysYsPGNYvXzmLvogIyYqCytj945twdMKWQGQfzEaz2KWvnS27RTcXEEQi2K2eMyLDnatpzNvyCeFY79e0GZrYFMw6Zz+cuP7I6NBndXXPcWWenQtofvyLIe60MNeKhNw7n4ySAaJMJjwdsCFiaAmqFtbHkA23eHpn2WeONUrUS79kqp1yR6lrqxxOL8QTiRnN18LJ9W8V1tDUwXfrRVjx/cl6aw2bYT5AsGMxwVQ6PCllmzSuc7SkL/6454UZrv75lUeDRFXa8QDopopKR+68mItFecA9wrVNbK1OVulI3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1yAH9VQqTbVE+55cI6miiOc+1mfNvv/czLyTtZterM=;
 b=b/YcN3HdbDnSanBfrWTaNmngiQOTRVpO+F49xVB2S1iN4ty7dZ4yiPEEtWgbOXvnlXKI3mMU7pgQn5HAl2HPHZyfiyKreKmf42jPUqx2+bgrL5QUXveAvZhmgM3JFEqSm8/EeL0H6Lv6StMDDjIBzvFtOkWzazeKuZuFmLLIelcKTzHNurkmGIcwSEp67aLxeSEKQMesyyKloreSlHJgKqjUfsqUl1K9ottOpkXx9HDeTDxGmqKArGWvkxW5c9M7Os9iEuUgxnbdMXuBtiydJ8vfogZlu6DUt2K/mwFr9qHAyn1Lkn4tf67EOJiw2x3Uvm5Mbed3TOW4qmeSCxbsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7812.namprd11.prod.outlook.com (2603:10b6:208:3f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22; Thu, 13 Jul
 2023 08:01:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 08:01:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Topic: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Index: AQHZs5ROZ0DTU24O6Ue9hKGIoQNDRq+1H7OAgABWtACAAZVBwIAABa6AgABHHcA=
Date:   Thu, 13 Jul 2023 08:01:51 +0000
Message-ID: <BN9PR11MB527682E9AD97033D694A564B8C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-10-baolu.lu@linux.intel.com>
 <20230711150249.62917dad@jacob-builder>
 <e26db44c-ec72-085d-13ee-597237ba2134@linux.intel.com>
 <BN9PR11MB527640E6FBD5271E8AF9D59B8C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cf793119-591f-19b5-b708-45c6f3eadc79@linux.intel.com>
In-Reply-To: <cf793119-591f-19b5-b708-45c6f3eadc79@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7812:EE_
x-ms-office365-filtering-correlation-id: cbcd7358-6237-428c-9c84-08db83776a53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bMgqATjqVIknejSmVf6EPUHnFHwRX5BXWVnZzTEWEZ+bw+hrJqnX0tX08fYL8d6RRt5CH+6ImJLv60r6+GwyxpMG5n3rr3dH18CYW+kcH/QBOtXimJiORDSLOvJQmNteIj8tSbIkU5Q/7WSwhlDoImMFyGbP2zqPq9ZJE21Y2jgmYT3Eokx80tI43Ol625fjnQpEkM+vpxbzk8njMolrJkJxlVeOmfWc+4EY6HMsyMaHWQGu99NDB2kSTZ6kR6xeTewRXNX5MXV/kwnS18gHPqcAbltAgqK2cx0bSF8lBGQ8ub2nFhUGnqzyEfj33NEl6b54nk5/tPVRx1TcXsvYEE3Bc1Oofs1Zgi/FhYX+D2Smb0xzaggC/BqHYbQgM3cuot3hoXZmCCPmFYL4XyDWLqunoA2W5VO547wRK/+mwAt9gikTwiA/NQ+nPOQmvYgWAn4Pr5UwLkslDM3YubAqcW2dfJsmd8tYzKWaa9wrwDKMZFJHB4qq132yQXCqa0Xq0xgcAOzEcu7iAdeoVrwreiWXUcPgS3Z+vGBpW4DrwRMuTRVHlm14pPDK9jKsecW+1cPAX0cskoxE5kJBIJ1a1e3d6+f6+9LDzM3mrSkTsexmiwpKUPQctxzPQxESkOuz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(4326008)(66476007)(64756008)(66446008)(76116006)(66556008)(66946007)(38100700002)(122000001)(86362001)(186003)(38070700005)(26005)(6506007)(53546011)(83380400001)(9686003)(82960400001)(33656002)(478600001)(55016003)(110136005)(7696005)(54906003)(41300700001)(8676002)(8936002)(7416002)(71200400001)(2906002)(316002)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHE4YjFQbTkzcTdiSHVwTjJ0REZIeU42eDFrZFRKYnpPUGtKLytPMEp4OWRj?=
 =?utf-8?B?QlNmS3FDR0d4S3RpRmw4c09UWndUK0VubkNzanZFM2JvR3hwSlpLZWZXcGFD?=
 =?utf-8?B?RVlGQlRMbk5WM3c5WmhwTVFFU25pSm5xQkpMMTRCdG9NK2ozMEMrMG9wclNL?=
 =?utf-8?B?MzU5UTY1SjRjcnQycW1KNUptOXQva0VPU3FKMlFsT3Nhejl5RWRXL2cwWjBR?=
 =?utf-8?B?TXpubDYvaHY1enFWeXA0RStkVlNqSk1vaUJoWjFYSlFpREUyT3RDMTBSTGll?=
 =?utf-8?B?MWpBOGlkd3gzNlN5Sit0eXB4SHNNNUFOMXp4d1Q0TXg3akxyYW1PTUpFc0JC?=
 =?utf-8?B?RnJheVlZKy9WMXF2UWlVRkdaN1VoOFR2WjhUOWtXNm1pdXdPNG1NMXlHVjNJ?=
 =?utf-8?B?OWkvSHY1d1p6dDRFVlppMEVXYUxRb2VPblltVkRiTkt0bDdtTmNjei9xTVZX?=
 =?utf-8?B?N2dwN3BweGlGem9jMGtDQnlvWUNLMFh3NU51S3REVlo4VjdOSnU0TnpGVzRW?=
 =?utf-8?B?OEFMd0xSOTZCUmtHUFVCaCtvcWdNL1BuWmhud0JZQVc3SklCS0lTMFU4TXJQ?=
 =?utf-8?B?cW8rMWxRNmI5UTdUMEhQREY3VEIvcVUvV3VRcUFZdms2YnJZSDdOVjdnYVJx?=
 =?utf-8?B?MmpiWFNCbUd4YlAxT0xNaTRUTWNaNUREeDN4bUlxNE5weGxkZVlHWlpIWlh2?=
 =?utf-8?B?Vk04WXUzeUprZWJkNjBFNzVRTEx6K1JqUHREK2JuZ21pZkFqa0RDZzZVTHl5?=
 =?utf-8?B?WnYxYmVTZGdpenBKeHF1dU11Zm9acUQ1RUZETUIxU0N4cnpTZFc5QnhwWXRP?=
 =?utf-8?B?Um1wZ014Y0hXWmdSWEdiNHBCN1Y0M0xVWU5CNlpNNFA3V1luVXo0UHk5OEhR?=
 =?utf-8?B?QU9XNHB1ZmFoYXM1dzVrQUUvdUFJSXNTZU9lbm5SVnlGbTNaVUhUdGtoamJ3?=
 =?utf-8?B?YlRSbkg1MDhJUElTb2hkTUpxUVYzYk93Y1M1VVBPUjNad1dDdkhNY3J4WGQ4?=
 =?utf-8?B?cUl2cC8vblBTUXB5WnFqdFROekZZV1lvam9VZm43OFUvNkhsalAxUTlJOHFV?=
 =?utf-8?B?V1FQY1hwcDU2QkhreVFqRlhodmhNb0p6UmNRcW5sMFJEdUxJaFRlRTQ0QzJS?=
 =?utf-8?B?a2UwZDRqN3FKczYrd0dGaVgwM2tQeVFxMUNhYlUxWmJYS0F3SHEwaWVjZWs2?=
 =?utf-8?B?MXJWZmRPdTRZQm1GVERmazduNUhWeXovQnJWVmFJcDhSMzUrQ2VQRnZFVlFF?=
 =?utf-8?B?TnhLT3ZjUHY4ZVBBZGVmY0x3dmJEdGp1MVJqUzloT1M1OTBnZ2lDTzlTaW5S?=
 =?utf-8?B?dndBdmZYUFp2SXYranZYYjY5WHFxaG1LYndwV2hzUk95dUhpbVVKMmVWQzAv?=
 =?utf-8?B?TXdSR05RSGlkQ01PWTFzSTQwc2t0N2NwemwyMTZIMzh4UGRmaklvNnpNRnh4?=
 =?utf-8?B?QzI3T2tFNEZPSjUxZWdoT011R0NiWHVVb3FjeWNlcmJoS1kwTCsxN0grUWRs?=
 =?utf-8?B?cTNVU2V6V3R1dmhmZ09pVUZTZk5mSHV4bWVVNDlXVEpkYlBFWUM0azBUZ0Jj?=
 =?utf-8?B?SEtnUThEWFBWb2RVTGEvUXllM25GWmljZDlnSmtFVE8yOW5FbHVrcEdXMkwv?=
 =?utf-8?B?b3V4dEpVQURTUEdSMEF2djZrOGx1Zm5BaTJhQXovcnhvNlRsbENtbTFYUkdS?=
 =?utf-8?B?TkF2ektHaHkvc05EQ0J3SkZJRnlhR0s1bjQ0dHVWUEMrYjlsMTR0TjVVWlV1?=
 =?utf-8?B?NGU2ZzR2QmR4SWZMSFpDZC91R3d3aVdFTXZxV0VtMjBHVVhldkEveWtrVHJ3?=
 =?utf-8?B?MnRBbmVpSGNTR2FzUXJYL3ltQ1JKeDk3OW9qZXhzOGRrVkp4Z3BSYTFpaE4x?=
 =?utf-8?B?ZFhuRDRlbkFhYUhDS1pSL2pkdWxQMXlpMXRJYnhiQ0FCSVF2ejNFaC9zaHBx?=
 =?utf-8?B?SERTM094UTJLbllhdWsxVklVaXBtb1B4a0dkRW16R1FQbi9pSUorVWlBOGJM?=
 =?utf-8?B?d1U4dkIyNGhIZWgxOEN1Qy9FK3phWGdLeEtUVElzazQzdmRoMEFGTWVjM2hn?=
 =?utf-8?B?a1ZMQjhWRWk3ejVoZEMvS3hseGRqaHdkQXZsdmo0UlFWbTB3V0dQeVRvRm9x?=
 =?utf-8?Q?x/4e85ZN2l4dGsELAK2hxCGmf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcd7358-6237-428c-9c84-08db83776a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 08:01:51.1070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9Tdw5+peSy75oVuLdiZZhF/pZzHuH950sF9UNfmtumHJNzAAF9UUIusOyMaT6dB/b0gKYWrGsrMMQy1Yaw6hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7812
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSnVseSAxMywgMjAyMyAxMTo0NCBBTQ0KPiANCj4gT24gMjAyMy83LzEzIDExOjI0LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogQmFvbHUgTHUgPGJhb2x1Lmx1QGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBKdWx5IDEyLCAyMDIzIDExOjEzIEFNDQo+
ID4+DQo+ID4+IE9uIDIwMjMvNy8xMiA2OjAyLCBKYWNvYiBQYW4gd3JvdGU6DQo+ID4+PiBPbiBU
dWUsIDExIEp1bCAyMDIzIDA5OjA2OjQyICswODAwLCBMdSBCYW9sdTxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+PiB3cm90ZToNCj4gPj4+DQo+ID4+Pj4gQEAgLTE1OCw3ICsxNTgsNyBA
QCBpbnQgaW9tbXVfcXVldWVfaW9wZihzdHJ1Y3QgaW9tbXVfZmF1bHQNCj4gKmZhdWx0LA0KPiA+
Pj4+IHN0cnVjdCBkZXZpY2UgKmRldikNCj4gPj4+PiAgICAJICogQXMgbG9uZyBhcyB3ZSdyZSBo
b2xkaW5nIHBhcmFtLT5sb2NrLCB0aGUgcXVldWUgY2FuJ3QgYmUNCj4gPj4+PiB1bmxpbmtlZA0K
PiA+Pj4+ICAgIAkgKiBmcm9tIHRoZSBkZXZpY2UgYW5kIHRoZXJlZm9yZSBjYW5ub3QgZGlzYXBw
ZWFyLg0KPiA+Pj4+ICAgIAkgKi8NCj4gPj4+PiAtCWlvcGZfcGFyYW0gPSBwYXJhbS0+aW9wZl9w
YXJhbTsNCj4gPj4+PiArCWlvcGZfcGFyYW0gPSBpb21tdV9nZXRfZGV2aWNlX2ZhdWx0X2Nvb2tp
ZShkZXYsIDApOw0KPiA+Pj4gSSBhbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgaG93IGRvZXMgaXQg
a25vdyB0aGUgY29va2llIHR5cGUgaXMNCj4gaW9wZl9wYXJhbQ0KPiA+Pj4gZm9yIFBBU0lEIDA/
DQo+ID4+Pg0KPiA+Pj4gQmV0d2VlbiBJT1BGIGFuZCBJT01NVUZEIHVzZSBvZiB0aGUgY29va2ll
LCBjb29raWUgdHlwZXMgYXJlDQo+IGRpZmZlcmVudCwNCj4gPj4+IHJpZ2h0Pw0KPiA+Pj4NCj4g
Pj4NCj4gPj4gVGhlIGZhdWx0IGNvb2tpZSBpcyBtYW5hZ2VkIGJ5IHRoZSBjb2RlIHRoYXQgZGVs
aXZlcnMgb3IgaGFuZGxlcyB0aGUNCj4gPj4gZmF1bHRzLiBUaGUgc3ZhIGFuZCBJT01NVUZEIHBh
dGhzIGFyZSBleGNsdXNpdmUuDQo+ID4+DQo+ID4NCj4gPiB3aGF0IGFib3V0IHNpb3Y/IEEgc2lv
di1jYXBhYmxlIGRldmljZSBjYW4gc3VwcG9ydCBzdmEgYW5kIGlvbW11ZmQNCj4gPiBzaW11bHRh
bmVvdXNseS4NCj4gDQo+IEZvciBzaW92IGNhc2UsIHRoZSBwYXNpZCBzaG91bGQgYmUgZ2xvYmFs
LiBSSUQgYW5kIGVhY2ggcGFzaWQgYXJlIHN0aWxsDQo+IGV4Y2x1c2l2ZSwgc28gSSBkb24ndCBz
ZWUgYW55IHByb2JsZW0uIERpZCBJIG92ZXJsb29rIGFueXRoaW5nPw0KPiANCg0KdGhleSBhcmUg
ZXhjbHVzaXZlIGJ1dCBpdCdzIHdlaXJkIHRvIHNlZSBzb21lIHBhc2lkcyAoZm9yIHN2YSkgb24g
dGhpcw0KZGV2aWNlIGFyZSB0cmFja2VkIGJ5IHNsb3QjMCB3aGlsZSBvdGhlciBwYXNpZHMgKGZv
ciBpb21tdWZkKSBvY2N1cGllcw0KcGVyLXBhc2lkIHNsb3QuDQoNCndoeSBub3QgZ2VuZXJhbGl6
aW5nIHRoZW0gZ2l2ZW4geW91IG5hbWUgaXQgYXMgInBlci1wYXNpZCBmYXVsdCBjb29raWUiPw0K
