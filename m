Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28824D104E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 07:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbiCHGcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 01:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiCHGcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 01:32:10 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F8E3CFD3;
        Mon,  7 Mar 2022 22:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646721074; x=1678257074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GOd9sXumm0fezdhT7KNfPt2YJ7zrEme4b34BSvCvfl0=;
  b=jDnOghc9ZSM+ax5ykj7Qd6XbVvtjMcnpyFLjgKBXoiLsojgtyVywKuS+
   DYTg3ylG+QQeI709w9kmEYXJtdpZW8GzLEl5UCL0ySSCsE6JZz+J+BPvJ
   XhSj9wVBDLA/0MJ2NWOXJHuOe0kelTv3DaOtpMU9gLexhuHEpQC62zKfJ
   Pt/nMDnogx76obWYDcKJZrGz53r3oLa3U6oLFs2a4+uNqEgTP4XL9Y1nD
   XeacgNxOr8xlBin6dqvfrBxWCr6lDdLUT3ldJ9+LByiWEGQz4nGMNULTw
   odGY/inU263ZyikvHcmPd3yY3LNV1mL1yaGezkLvES6sq91lsuRdl38pn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="235214311"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="235214311"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 22:31:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="632129244"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Mar 2022 22:31:11 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 22:31:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 22:31:11 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 22:31:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVpxGXIRrDs2jDC18VrTChBhjqi5eqXSH2bOSLwWlq3l7k3m2bgAsz0BmWPforSST5JMnmZQOcxAOrerEQMHFIhsfxhdqu9VyzEMwwlWEraWPqKyOkTZ8HKf9HDkp6oW+XH7MZVDKw+PUXEupzoEXhxEek4sYkE2eXMxEPAYswz9OsRxzQPzAbVn+UUybumbGKSDsqvEIOxnY+aq5Ixqd91+ooJZEmyj8+ZYfSdjWWIdnix+BYr52NUZT/OuBo/9GK2XR/k2jPNK0rV/5HPtNp+SxPe4RK7HwSjnkQXEkb7Z23wJIsgvVk/9GzxG3DomCiJk5FkiKnLZ5/ex6h2Xsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOd9sXumm0fezdhT7KNfPt2YJ7zrEme4b34BSvCvfl0=;
 b=JE7Psfm/ysX3AzsN0wyW56ZCiNMICZk3azmLpzGlFVJ+GXFp6vp/PTYt63BTw+PPQ73IlPNoTRcmMrJyxcKvbExOrAwODF8LJHBSpWl8mFg81Blzi2Zfsi/I79Y7SMZliqB5EfJaioXEU1edbWbNAcb9xgSW/1J/5n0O2tQbQt8iK1fPgHPRLtRZsUepxx1PU7NTNv4fv+6jvTP1XTznJhUAonBEmyq+aFKe3E4nmgno4zhnfst2cKaSa5jvRaFP5pQBFloKBLsT0IQzZi/JsjmuelJvyHItT/1gEJ/QfOwtdxMsnqv91sSdJIZPYujo6jUcLt3as3VdjjjEOZJHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 06:31:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 06:31:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state register
Thread-Topic: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state
 register
Thread-Index: AQHYL1LlxS7vDH7cWUS0mnIYI1OsX6y1C9qg
Date:   Tue, 8 Mar 2022 06:31:08 +0000
Message-ID: <BN9PR11MB5276D3F8869BEAB2CBB16B498C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ec9910b-1d74-4981-9c6f-08da00cd3b5c
x-ms-traffictypediagnostic: MW4PR11MB5774:EE_
x-microsoft-antispam-prvs: <MW4PR11MB577424A7DB09D1DE7FCDF82F8C099@MW4PR11MB5774.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e4CrZU06KOJAR4NVH1Lzdywt6szeBSZTz+NYD+fSxj0H/qDwi3OiMSq/HqvTCUj2lqXLVw7EXKjMkUopgjG35M5EL3F8/VIIqO86ynOEACZOlXAjd2QQ6CXyb31U2qHXdb/U60ReiZfjNIpHtD2kYT8uDTzwvrn7229Y0//E9for+g2UMg6P8HZE0YnecqkOIMOY4YFrVIex9YNvQqM0+cIkPe+xCYkQCKYJrEZBTx45ZtY5CoXhnoZWmIYMT+OSvyPOYSaMpoyyb9fDPOLwqrmZCo+QyUx2Z6LUmsx/rvOTTpuP1s4zu+rU7v3oBRMKfKdlYOzS/IzsqAT6LzPqsBsZcrKNDjAPjw6HwlMMlzK5eTnYkYPat9hlTvcL1MOrktac2Cxx25agr+NqTbdMNcf6BIKEmLQ2Mj/9+crNHY4Ii13iKI+cck957LktqjF7uXD5msg8fvWId0y1MxUuRKNz4g8uYDsZRKm6I64dZ9Bwsk9wusENRvJJzOLsoWejTvMzsCAPaL33/kWqN03TIu6XsM/QMS6USoJNMdW2rQg7FAeA15MCYVk0+4rBrpSpUSM+Q9tYwVn1/34cvhelL8zCjBSVQQ8309gh1lg3b1GxtOoS3nCQIdCn2bDkxiteRd4v3oyNVMIAzX2byTFvyt3nc0T/eb3oSgvOLMo3s5OmWlIL6rBC51h7NO4Ezqbhp/arzligTXnPQLia/Vylrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66446008)(66476007)(316002)(66946007)(76116006)(64756008)(122000001)(54906003)(4326008)(71200400001)(5660300002)(110136005)(83380400001)(55016003)(33656002)(8676002)(38070700005)(186003)(26005)(7696005)(9686003)(52536014)(86362001)(8936002)(7416002)(38100700002)(4744005)(508600001)(6506007)(82960400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVNFL0szWWdIRE02M2FUSkVIR3lmeU52QUJPY0IwUFFZUllVbGlEV1VaSlRx?=
 =?utf-8?B?N0hPcE4wa1dRUitDQ3FLaE1xdloxbm04SkZiNkJqMVpSWXBPSjBZbTRMYWth?=
 =?utf-8?B?aVgrV2E3U2VMTmJrUVM3K1V0dnpNOWRGSmZGbGRtU25vWWJuVjVGL0tPV2gz?=
 =?utf-8?B?bGkrMWRHSWJ2WVdsaE0xemNWZWNtVGRraDQ4QVhjRWV0eWxHQlF4QmpyS0hz?=
 =?utf-8?B?S3RGR2MxQWxiZXl6Q1piejVtMFA1MHVsWDVmRXhXNVE3bS9IOXJPa1plVEVp?=
 =?utf-8?B?d3ZUNTM1U0tDYTR5cEhoTSthRUQvcjRHMnJ2cXBSM2ljNHgwTlZPdmk1a3VI?=
 =?utf-8?B?YmlaMTgxL3R1TWtheXlwNGFJd3I4RGlFK0J4WDQ5MnFuMTEvR01Sc21vbE9p?=
 =?utf-8?B?d0piT2RlZHFvczR4REkyQ1pzVjFFQWJvcTFqRWZuQndORmdoRi9iNDU3dnRw?=
 =?utf-8?B?VHovYTFmWWtXdFVIUnRnOUFyUEdPNklBL3BaVW5RNnVjNEtTQ1ZobFR0N0pz?=
 =?utf-8?B?SUx5WE5jWC9QUVlnT0M0ajRYMHBmOUJ2dDN1VFJ5ZU92YkdjenhZSU1vcTU5?=
 =?utf-8?B?Q1V0ajNJSzE1MHBTbWZvWjBhRVpaWVYzWlJWZURCQ2pGSTVDN3pmNVhibFEy?=
 =?utf-8?B?TWh5ckdxVDdnQzV4cUFjcVIrQlJqQWZMZzVQLzVLMW5icTE3Mk45QXl6ejZt?=
 =?utf-8?B?Smg4SDZzYy9rM1pKRFV0K1AxUWZhNjNkbVNwRUs4SThpWDAwbWJjbEM4RW5L?=
 =?utf-8?B?c1FmVzF6czRIZmZ1RW41Y3dCbWI4S1JMcFZDSzV5YXVoVWRHbWJKSWY5MS83?=
 =?utf-8?B?N2lQakRTK3doL3d0MkE4RWJSbWpsb1ZENW9IckZDVC8wOW9iMDRWUVVNcUdF?=
 =?utf-8?B?ak9JY3g1angySHFhU3gvc0JMVkRuSFpTRGhBQ1U0UTlmMHpRUXBibkZxeHlY?=
 =?utf-8?B?SFlZUHNoUUpaZmlkWlByS0JLQWRTa2lQZTFPTjRPWUpZcUVFTisxN01HNHN2?=
 =?utf-8?B?c2toTUxmQ09rVTZPeGNmNXdjcEgya2ovZW5qTTFsejd1dHEvNG5vKzZvdUxo?=
 =?utf-8?B?Z09jVlhJY1JiZkQ4UEZMTmM2Tk5oZ0UxN1JrVUViSnBYRUpJUng0clJDMHVu?=
 =?utf-8?B?aHdFQVppa2dLMSsyR1lITzkvOUJUZWdMZWpkSG9IUXdFY2NDaHRrNi9KZ3RJ?=
 =?utf-8?B?andUVEZTVlQwZFZJTFVZcUt0bk15NEM0VHZmK0l5UlJMbDRoSUhXaEdvU1BQ?=
 =?utf-8?B?Zjc4dmpJTGxMMktuTGpSdkR2MDl6RjRjMGxFUkl5NjMxWkRmTG5LeDgxYktv?=
 =?utf-8?B?VkpnQ1Arai9jOEE3TFpTK0pXNDl4azlhelZweXp3Zm1WekppT3lDS2NPcUQw?=
 =?utf-8?B?UHpFckp1UFkydXFoRjJ2NlFSU3EyVFc4WTZmODE4S3l1UlNIbHc1aEphbStP?=
 =?utf-8?B?TDJlWVphVkx5V3c1REhLbHZiczc4SnM5TlVxQ3NndUNDamEvMUhMUUJDVEh4?=
 =?utf-8?B?SHd4MEJrL0ZRZ3BSa0VZNkZtQ01JTmxZdklNYmRnSlhWOGthYmFva1Ztamk2?=
 =?utf-8?B?QTF3YkwvQ0RlUXNxaGhFalR3SUJHYVA4VEhRNFFnRDk4OXNlblBmQ0lGZ3kv?=
 =?utf-8?B?NmlnS28xc1hGOGlhYjlhT2NOWXF0REtKWTVvNDFhRFV0MWYrU2FuOEs2bVdX?=
 =?utf-8?B?akJqUXlGdStad0VMc3pTWDNFcE1TbzFsVFgvcERQdTlQWlROL0dkNmxrVkJK?=
 =?utf-8?B?bEN6bHFzVGFnTW5jOVlFRE1iMUplSFpZdFRwbWdSWjBmN0QzbUltdjU0a2tw?=
 =?utf-8?B?VWplaU5jd3ZXcW54d1ljQWh4TGtKVlA3S010K3QzZmgwYVBtSzhyRXdtM3NF?=
 =?utf-8?B?TU9PaTlYMnFQbnFSWTNwcEdtQ2pFRnlYcVl4bElneElLVTgxeW5qeGd6R21z?=
 =?utf-8?B?QkljaDJ5bjl0anFsMHMrY0NkS2pFWVpCR3FjZHNCL09vK1k5bHRDTWFBZTNF?=
 =?utf-8?B?azlrMWtCb2FYNmlkQTNwdUgzT3NNMTRjQlV1YWcwWGs0UndSK201bXN0QmxH?=
 =?utf-8?B?bk9hRXkzcVpCR2xDR3VQWVU0ZTBIei9xR0IvV0lGUHpnaVFjVHUwODA1NUJ2?=
 =?utf-8?B?eDlFaUVVbGRvOHIwaUQ5SjdQL3BGUjQzUGRDQkdma0E4RFhXbjhUV1VQeE9E?=
 =?utf-8?Q?MsVi/JmiyuMnHqtKKidtwF0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec9910b-1d74-4981-9c6f-08da00cd3b5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 06:31:08.9786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lIGKSTtLgk+1/7n5kSkHO7GSB9gwhkB3GCllzlpXyr4+hgHk8dq3Uxmm4TIMclcvyKVRUvGnsRp0pM3Ovrsu0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdl
aS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWFyY2ggNCwgMjAyMiA3OjAxIEFNDQo+IA0KPiBGcm9t
OiBMb25nZmFuZyBMaXUgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+DQo+IA0KPiBXZSB1c2UgVkYg
UU0gc3RhdGUgcmVnaXN0ZXIgdG8gcmVjb3JkIHRoZSBzdGF0dXMgb2YgdGhlIFFNIGNvbmZpZ3Vy
YXRpb24NCj4gc3RhdGUuIFRoaXMgd2lsbCBiZSB1c2VkIGluIHRoZSBBQ0MgbWlncmF0aW9uIGRy
aXZlciB0byBkZXRlcm1pbmUgd2hldGhlcg0KPiB3ZSBjYW4gc2FmZWx5IHNhdmUgYW5kIHJlc3Rv
cmUgdGhlIFFNIGRhdGEuDQoNCkNhbiB5b3Ugc2F5IHNvbWV0aGluZyBhYm91dCB3aGF0IFFNIGlz
IGFuZCBob3cgaXQgaXMgcmVsYXRlZCB0byB0aGUgVkYgc3RhdGUNCnRvIGJlIG1pZ3JhdGVkPyBJ
dCBtaWdodCBiZSBvYnZpb3VzIHRvIGFjYyBkcml2ZXIgcGVvcGxlIGJ1dCBub3Qgc28gdG8gdG8g
DQpvdGhlcnMgaW4gdmZpbyBjb21tdW5pdHkgbGlrZSBtZS4g8J+Yig0KDQpUaGFua3MNCktldmlu
DQo=
