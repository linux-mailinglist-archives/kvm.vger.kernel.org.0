Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528F06B3646
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 06:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCJFun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 00:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCJFu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 00:50:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F95FAFA4;
        Thu,  9 Mar 2023 21:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678427389; x=1709963389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3oMSNGf6A4lRHWp3I80z0B4hWEAAvfbHidD8BbCSlr8=;
  b=At0plS5LLv59QEy0Vu5cCqLYlLZhgEkiOB/xQecY/zCbTgIWygSMjHb7
   uBgVcJplnF3I+Kd6Scgo6jdyK4txQiv8HyCOqcyIoquG7Fgt8D96RDYZL
   WT7GypkHXM5bi5Ji9OwJ6rQVn8y0jvvLMDOGzGqA9bgCBl0ygG+nOj1Pt
   S9pz42NQOHTfbLeTdiJeqYQgyrKHKJi89TIwPjray4TL85tVE6MdsKw56
   wF5DvRCZ8x5cPdtZinAu1ioVUF9Yx8mM4K07YkrBDzlhpiPIRY37svGsO
   iddmVIx+C9jQDk2bxGRBuUjV6AnD3d8xNRB4C/bZeuF9hOGzyaNR7ISKD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336672344"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="336672344"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 21:49:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="851784278"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="851784278"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 09 Mar 2023 21:49:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:49:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 21:49:47 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 21:49:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF6LMi8GOle7aTyXLYNUxa0CMRav5/3mYkhKjSKGhPgRGk99zRAY4GVgxcKNwhHcK6p6YAJopTrdxld7nlduyABQrEz3vlSawBjucFYmCoDEWtKlLIFAAxKBDiLXPkF3lmhqjR1b2uHRQSoR6D+IKLDh5x+p3hhK0v91KB0d7huK0hsLGPr3qVGI9tXDF6e1mB+CQgMg7cpAUkiYpXPhurb2UVL9v0RvGYl1M7FqPNcr/j0M98CS2JAOfdG68IfI7AAZBIHGknlD+QkAVS/E0eiQ1JlI82DPnn6ejk6oAl1VxLKR8SZmMGFF4qzd8/C4mmqXU51FbRjoGgUH52IZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oMSNGf6A4lRHWp3I80z0B4hWEAAvfbHidD8BbCSlr8=;
 b=cm0L9wzXVwUN9f3v38eOg09WTxpmd7nX+oxV/ZSrbFXGhj67ozArvIFrEO4DVnmhLMa4jtjnp6bHhNqY5UkTC6QHPIHuSmvXO1OmZYKMtJm2kKPtJZnBfbYI+9QDv0An2iFGks8ckMeaH48P6sytLJfhYLelb9UIN/QYe9dGqe41t3HDLZ+zDWeQsiSyaUJPHigAFqw2P4EJTlBWSxMcoA14FrrSWRL9I3JI1TIRNAzLtVk51EF4AcgqfmcLOFbrKbx94BoKt5eEAY0xa9UNm2yAXmnDURag1+78xXZX5hXizI7XFClSovJvsIeAJiIOLR3UopxP0x98lrKPhsi1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO6PR11MB5651.namprd11.prod.outlook.com (2603:10b6:5:356::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 05:49:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 05:49:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alexey Kardashevskiy <aik@amd.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxP1elsXPP8bE2Y+PYEE7Tlg67zXcoAgAAy5sA=
Date:   Fri, 10 Mar 2023 05:49:39 +0000
Message-ID: <DS0PR11MB7529196EF7B563B6F1F438A5C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <95639de5-cf0c-0c8c-5a75-b34447e1b03b@amd.com>
In-Reply-To: <95639de5-cf0c-0c8c-5a75-b34447e1b03b@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CO6PR11MB5651:EE_
x-ms-office365-filtering-correlation-id: b6804da7-8706-4f40-4c36-08db212b3d32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCf7nkt12PTdxec7tgyByeFsbrsyG60g/v66PEEAdM7itiui9nKY6SGCZNAsjL2GDwnMRHfcZmxWOoN2MFxzBX/S2U6n9FIbhq9vFAEagCNtfbgzbbu26VfYwHlIxzW6GBMbVIxx5XXyLvra0VClRTNxrjq7kuD080l7oOSy1Uv4wpF7jjZGH7Bs6cVpYj9e9HhoXsmsc8yyrgb0pmIBavY3fTR9F62kWALFpUhubdM+Fo+mhaVBRaJvTyqxwS8ASpphlfucYXixxwwCIfJftiPVqrtAdn7yg+1aFwiuJucFVsyHtHxLu41y9VmbktKTc2y7iFIRo/3XT0xZFHls61YlgQiRueuXAjjTyu7dZeCYACuxEZ8eZWiB30QeLdVi2Y1FXSA62Yp64xgTUPtaeVvD2b9Qh29HqdYxrS+7ljwa3LnsA3UzTrNqJX95iK/O1BjTa2tsa0LBOTAgG4tl+7xypjArJLAYYPwI7ev+VoiFv+8rgE84RKTW3p2eGwWuIHJLpjUDUZB1Jdrs02fdb0AqxS3dYYqQlq1RaxZalPOk9sedSyVWEh9jVnW9JC1PH/0igTyZ36dKstYLLlRnfFdpQjriZP1crTyh/hP7i+2jOiBBElYGnDRnxUzXejYIks6ZikLCFU9RE30WntpWV/TKQ+WMC7cehJ9Lm5luzgMjy7lmRubmuKtvROch1Wkl2O0YP9cCMQ52dmAA0LCWww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199018)(38070700005)(66946007)(2906002)(7416002)(5660300002)(26005)(8676002)(8936002)(52536014)(4326008)(33656002)(66446008)(66556008)(64756008)(110136005)(66476007)(55016003)(76116006)(316002)(54906003)(6636002)(86362001)(71200400001)(7696005)(478600001)(966005)(122000001)(38100700002)(82960400001)(53546011)(41300700001)(6506007)(9686003)(186003)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmErV09pY052Ry8zSDFTa3V1U1pHc1c2NXJnRnVpS3QvaXVsUFJIbFhTU1Qw?=
 =?utf-8?B?Q1F0Tm1BY05nNlZqR1NxS2RsUEluS2ZhWGN0YXk3dGxBSlMrM3JtTjhsUlNX?=
 =?utf-8?B?UEpIbUxLak9pOFBaYXhEZzBmci9iUG01MHo2SWlTM1czTEMraWROMnM0dWlj?=
 =?utf-8?B?Z1NzQ1k3ZndlQjFUN09hbVdJMmhFQWpFZDRCZnFXa2oxd2JORXRma1AzZ2FY?=
 =?utf-8?B?a1ZZT1NyNzFhU00xYmJvbElvSjVrYkduZ2EveXNyaUUyc2RzUmlVNEI5YTU5?=
 =?utf-8?B?QVEwS2FaTWRCUUJndWRPKy9BMzhYS3VZVGJRVFh6c3ZMbnlOZE11OG1CcnNX?=
 =?utf-8?B?WktpZ2ZXc1luMXlGQlpuclVyaWZkVTR0M1Y4NlJkSFkwVjJPaGx4N2lvQ29R?=
 =?utf-8?B?OE93dm44V3lUdEZsQmxBZEswWjVsSkJLZ3ZaUWtzZ05CRTdPNjVnT2w0Ui84?=
 =?utf-8?B?eDhRZHdhUWJSdkFRb2IrUnhZMHdnbTd4cncrUEZhdTc2TEcwT2cxdW81cWJl?=
 =?utf-8?B?cTJabUFiV0RTRmlqbU1vbXl0QXZReENKVTN5NG94alBGZldKWnpPSjdickN1?=
 =?utf-8?B?cUxCNnErSWQ0cm9OVVI3Si9PdnhNcUZibG1Fbjg4S2lyZFB0WDVUcmdKOVFw?=
 =?utf-8?B?RlBuRDh4Wmw0eUE2WW53dUNjT2JQZXppSW1MckF2K2cxeWlJMy83UXoyVHBu?=
 =?utf-8?B?ZGNHcW9ZYUEvTlROMXNWR0hiVWdnaWhNTXVFRy84VEFDdk9QZVBPcEdKaC9r?=
 =?utf-8?B?cmcxbGlCc016TWlQOTIyNCtNS1ZPcmRoY0hMTnBaN3BCVDRRNTFTNGVOK3F6?=
 =?utf-8?B?T3FZWnZTRkVxUnpFdVo1ZVViakIzdmtwWTNMSTFlZE5JMVMzakpVZXljN1lB?=
 =?utf-8?B?MkY4WlQwcmF6aTVsV01qRWh4cHV5KzhXcjYvalJ4R2lDbG02bTdPUW1WTi91?=
 =?utf-8?B?N25RWm1aZ3FYWWJLdFJPSFh6WDFvNzJuUlJaYjFJd3RDMnFOK3ZDVWltVGYv?=
 =?utf-8?B?b3ozOEVyK0tuU3NrRC9oUWNiVWkweldqUHlLbmNXeTAvenVqQjl6d21iQjhZ?=
 =?utf-8?B?THdLUWlTdWYxSTdHdEtIQkxHQmZpSUl3U0JGeHhJSFkyNlVzNW8yMnE4RzRY?=
 =?utf-8?B?V3l4MWZMSnhtNEl1bnlkc1J2Z0tCTVI5cVRtbFlBM3RkRWMwWEREUEVKQ1Fx?=
 =?utf-8?B?WFp6eEJtS0pTNWdjYzdwOHowMjFrKzFXTkt4UHBuSTk3dmE3cW5NR21CRFZL?=
 =?utf-8?B?aU5LWi9ieWtKY1laTFhCV0QySnBPeDdpaTdqTjcxSWxQa3ViR3dMQ1dRSWty?=
 =?utf-8?B?SW95eUZQSFhZOGwxZVFVcDdsdW1PTEFKQ25pRHlidExoenpsZ1orN2ZTOWVh?=
 =?utf-8?B?OWRNSVgvejNlNEcyZ1FscjNNblY5aWtDeUE0MVdld0tVRi9mc0lSVStCQTVk?=
 =?utf-8?B?Y1AreUM2S0FyczV0bHR2NXpUYjJkbnNOOFNqaEI3VzNhSS9XTno0WDNxSGpp?=
 =?utf-8?B?d0ppaW9IQkcvS3Zsb0pBbm9HY0xyWFFwRmJzaGtVbmM3bk45c2ZtN3d1VWtx?=
 =?utf-8?B?OEtZOXM2V2Roc2V2UzFoYXRNRHdGOEM4bWxGR3kxVUFxcjhtemVvSWtjREtQ?=
 =?utf-8?B?UWNvVlVLRHljY1NiOHZ3TXd2TVpvU0IyRy9zeGxtb0tnUks4bm52Sm53WlZx?=
 =?utf-8?B?cDR0VVU1Umh3bjBGZmh6VkcxREJpbXdGUFNOMHZESW5mc2F1ZjRaZnpKY0tj?=
 =?utf-8?B?VHMwR0VLcy9TNFNsS2tTNWZqN3NTd1E1WmZBa29BRmpJb1pzc2p6R2JreHl4?=
 =?utf-8?B?VFdLcStLcUdxR0lOeXpnRmcrMWpRMFJkTmltckZ2TWdwdXFaMjIrdm5UdUlV?=
 =?utf-8?B?WGY2SmUyWk1XbkdWY2Q0NXZXZnpBOUxtY210cXJyMUVac3JOV3BzNnNsMlFk?=
 =?utf-8?B?WEhHVWFFNyt3a1oxV0Mxb1dBRVdZa0pKc29tbWVjWDJWWEJGZzFLN21MMkUy?=
 =?utf-8?B?WmNGdmZ6N3RHS1ppekE4bEV1bXZlY2cwK2hSejc5MTEwczBwcFh2UWdndXBw?=
 =?utf-8?B?UkNXd3VmVmVQb0gzOEJ3YlRPK29nV3kxcTdWWWpZMjMyZDREdjJZdUM0VHlM?=
 =?utf-8?Q?my0j+vKIVTaJfaXwgGaSx/pIn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6804da7-8706-4f40-4c36-08db212b3d32
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 05:49:39.6762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhjP4UWrQkQhkNC2bsE1MMkUODFrgt+hSb6pS+zSQtasenx3AxdC6gf393PcsWik8TRLisGxiIFtQay5FYVS7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5651
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQGFtZC5jb20+DQo+IFNlbnQ6IEZyaWRh
eSwgTWFyY2ggMTAsIDIwMjMgMTA6MzkgQU0NCj4gDQo+IE9uIDI3LzIvMjMgMjI6MTEsIFlpIExp
dSB3cm90ZToNCj4gPiBUaGlzIGFkZHMgaW9jdGwgZm9yIHVzZXJzcGFjZSB0byBiaW5kIGRldmlj
ZSBjZGV2IGZkIHRvIGlvbW11ZmQuDQo+ID4NCj4gPiAgICAgIFZGSU9fREVWSUNFX0JJTkRfSU9N
TVVGRDogYmluZCBkZXZpY2UgdG8gYW4gaW9tbXVmZCwgaGVuY2UgZ2Fpbg0KPiBETUENCj4gPiAJ
CQkgICAgICBjb250cm9sIHByb3ZpZGVkIGJ5IHRoZSBpb21tdWZkLiBvcGVuX2RldmljZQ0KPiA+
IAkJCSAgICAgIG9wIGlzIGNhbGxlZCBhZnRlciBiaW5kX2lvbW11ZmQgb3AuDQo+ID4gCQkJICAg
ICAgVkZJTyBubyBpb21tdSBtb2RlIGlzIGluZGljYXRlZCBieSBwYXNzaW5nDQo+ID4gCQkJICAg
ICAgYSBuZWdhdGl2ZSBpb21tdWZkIHZhbHVlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkg
TGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3ZmaW8vZGV2
aWNlX2NkZXYuYyB8IDE0Ng0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gICBkcml2ZXJzL3ZmaW8vdmZpby5oICAgICAgICB8ICAxNyArKysrLQ0KPiA+ICAgZHJp
dmVycy92ZmlvL3ZmaW9fbWFpbi5jICAgfCAgNTQgKysrKysrKysrKysrLS0NCj4gPiAgIGluY2x1
ZGUvbGludXgvaW9tbXVmZC5oICAgIHwgICA2ICsrDQo+ID4gICBpbmNsdWRlL3VhcGkvbGludXgv
dmZpby5oICB8ICAzNCArKysrKysrKysNCj4gPiAgIDUgZmlsZXMgY2hhbmdlZCwgMjQ4IGluc2Vy
dGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
ZmlvL2RldmljZV9jZGV2LmMgYi9kcml2ZXJzL3ZmaW8vZGV2aWNlX2NkZXYuYw0KPiA+IGluZGV4
IDllMmMxZWNhYWY0Zi4uMzdmODBlMzY4NTUxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZp
by9kZXZpY2VfY2Rldi5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL2RldmljZV9jZGV2LmMNCj4g
PiBAQCAtMyw2ICszLDcgQEANCj4gPiAgICAqIENvcHlyaWdodCAoYykgMjAyMyBJbnRlbCBDb3Jw
b3JhdGlvbi4NCj4gPiAgICAqLw0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L3ZmaW8uaD4NCj4gPiAr
I2luY2x1ZGUgPGxpbnV4L2lvbW11ZmQuaD4NCj4gPg0KPiA+ICAgI2luY2x1ZGUgInZmaW8uaCIN
Cj4gPg0KPiA+IEBAIC00NSw2ICs0NiwxNTEgQEAgaW50IHZmaW9fZGV2aWNlX2ZvcHNfY2Rldl9v
cGVuKHN0cnVjdCBpbm9kZQ0KPiAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlcCkNCj4gPiAgIAly
ZXR1cm4gcmV0Ow0KPiA+ICAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHZmaW9fZGV2aWNlX2dl
dF9rdm1fc2FmZShzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+ID4gK3sNCj4gPiArCXNw
aW5fbG9jaygmZGYtPmt2bV9yZWZfbG9jayk7DQo+ID4gKwlpZiAoIWRmLT5rdm0pDQo+ID4gKwkJ
Z290byB1bmxvY2s7DQo+ID4gKw0KPiA+ICsJX3ZmaW9fZGV2aWNlX2dldF9rdm1fc2FmZShkZi0+
ZGV2aWNlLCBkZi0+a3ZtKTsNCj4gPiArDQo+ID4gK3VubG9jazoNCj4gPiArCXNwaW5fdW5sb2Nr
KCZkZi0+a3ZtX3JlZl9sb2NrKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArdm9pZCB2ZmlvX2Rldmlj
ZV9jZGV2X2Nsb3NlKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiArew0KPiA+ICsJ
c3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsNCj4gPiArCW11
dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4gKwkvKg0KPiA+ICsJICogQXMg
ZGYtPmFjY2Vzc19ncmFudGVkIHdyaXRlciBpcyB1bmRlciBkZXZfc2V0LT5sb2NrIGFzIHdlbGws
DQo+ID4gKwkgKiBzbyB0aGlzIHJlYWQgbm8gbmVlZCB0byB1c2Ugc21wX2xvYWRfYWNxdWlyZSgp
IHRvIHBhaXIgd2l0aA0KPiA+ICsJICogc21wX3N0b3JlX3JlbGVhc2UoKSBpbiB0aGUgY2FsbGVy
IG9mIHZmaW9fZGV2aWNlX29wZW4oKS4NCj4gPiArCSAqLw0KDQpkZXZpY2UtPm9wZW5fY291bnQg
aXMgc3VyZSB0byBiZSBub24temVybyBpZiBkZi0+YWNjZXNzX2dyYW50ZWQNCmlzIHRydWUuIE90
aGVyd2lzZSwgaXQgbWVhbnMgdGhpcyBkZXZpY2UgZmlsZSBoYXMgbm90IG9wZW5lZCBkZXZpY2UN
CnN1Y2Nlc3NmdWxseSwgc28gbm8gbmVlZCB0byBkbyBmdXJ0aGVyIHRpZHkgdXAuDQoNCj4gPiAr
CWlmICghZGYtPmFjY2Vzc19ncmFudGVkKSB7DQo+ID4gKwkJbXV0ZXhfdW5sb2NrKCZkZXZpY2Ut
PmRldl9zZXQtPmxvY2spOw0KPiA+ICsJCXJldHVybjsNCj4gPiArCX0NCj4gPiArCXZmaW9fZGV2
aWNlX2Nsb3NlKGRmKTsNCj4gPiArCXZmaW9fZGV2aWNlX3B1dF9rdm0oZGV2aWNlKTsNCj4gPiAr
CWlmIChkZi0+aW9tbXVmZCkNCj4gPiArCQlpb21tdWZkX2N0eF9wdXQoZGYtPmlvbW11ZmQpOw0K
PiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsJdmZpb19k
ZXZpY2VfdW5ibG9ja19ncm91cChkZXZpY2UpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMg
c3RydWN0IGlvbW11ZmRfY3R4ICp2ZmlvX2dldF9pb21tdWZkX2Zyb21fZmQoaW50IGZkKQ0KPiA+
ICt7DQo+ID4gKwlzdHJ1Y3QgZmQgZjsNCj4gPiArCXN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVm
ZDsNCj4gPiArDQo+ID4gKwlmID0gZmRnZXQoZmQpOw0KPiA+ICsJaWYgKCFmLmZpbGUpDQo+ID4g
KwkJcmV0dXJuIEVSUl9QVFIoLUVCQURGKTsNCj4gPiArDQo+ID4gKwlpb21tdWZkID0gaW9tbXVm
ZF9jdHhfZnJvbV9maWxlKGYuZmlsZSk7DQo+ID4gKw0KPiA+ICsJZmRwdXQoZik7DQo+ID4gKwly
ZXR1cm4gaW9tbXVmZDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArbG9uZyB2ZmlvX2RldmljZV9pb2N0
bF9iaW5kX2lvbW11ZmQoc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmLA0KPiA+ICsJCQkJICAg
IHVuc2lnbmVkIGxvbmcgYXJnKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmRl
dmljZSA9IGRmLT5kZXZpY2U7DQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2VfYmluZF9pb21tdWZk
IGJpbmQ7DQo+ID4gKwlzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQgPSBOVUxMOw0KPiA+ICsJ
dW5zaWduZWQgbG9uZyBtaW5zejsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJbWluc3og
PSBvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19kZXZpY2VfYmluZF9pb21tdWZkLCBvdXRfZGV2aWQp
Ow0KPiA+ICsNCj4gPiArCWlmIChjb3B5X2Zyb21fdXNlcigmYmluZCwgKHZvaWQgX191c2VyICop
YXJnLCBtaW5zeikpDQo+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKw0KPiA+ICsJaWYgKGJp
bmQuYXJnc3ogPCBtaW5zeiB8fCBiaW5kLmZsYWdzKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0K
PiA+ICsNCj4gPiArCWlmICghZGV2aWNlLT5vcHMtPmJpbmRfaW9tbXVmZCkNCj4gPiArCQlyZXR1
cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlyZXQgPSB2ZmlvX2RldmljZV9ibG9ja19ncm91cChk
ZXZpY2UpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiAr
CW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4gKwkvKg0KPiA+ICsJICog
SWYgYWxyZWFkeSBiZWVuIGJvdW5kIHRvIGFuIGlvbW11ZmQsIG9yIGFscmVhZHkgc2V0IG5vaW9t
bXUNCj4gPiArCSAqIHRoZW4gZmFpbCBpdC4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKGRmLT5pb21t
dWZkIHx8IGRmLT5ub2lvbW11KSB7DQo+ID4gKwkJcmV0ID0gLUVJTlZBTDsNCj4gPiArCQlnb3Rv
IG91dF91bmxvY2s7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogaW9tbXVmZCA8IDAgbWVhbnMg
bm9pb21tdSBtb2RlICovDQo+ID4gKwlpZiAoYmluZC5pb21tdWZkIDwgMCkgew0KPiA+ICsJCWlm
ICghY2FwYWJsZShDQVBfU1lTX1JBV0lPKSkgew0KPiA+ICsJCQlyZXQgPSAtRVBFUk07DQo+ID4g
KwkJCWdvdG8gb3V0X3VubG9jazsNCj4gPiArCQl9DQo+ID4gKwkJZGYtPm5vaW9tbXUgPSB0cnVl
Ow0KPiA+ICsJfSBlbHNlIHsNCj4gPiArCQlpb21tdWZkID0gdmZpb19nZXRfaW9tbXVmZF9mcm9t
X2ZkKGJpbmQuaW9tbXVmZCk7DQo+ID4gKwkJaWYgKElTX0VSUihpb21tdWZkKSkgew0KPiA+ICsJ
CQlyZXQgPSBQVFJfRVJSKGlvbW11ZmQpOw0KPiA+ICsJCQlnb3RvIG91dF91bmxvY2s7DQo+ID4g
KwkJfQ0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBCZWZvcmUgdGhlIGRldmlj
ZSBvcGVuLCBnZXQgdGhlIEtWTSBwb2ludGVyIGN1cnJlbnRseQ0KPiA+ICsJICogYXNzb2NpYXRl
ZCB3aXRoIHRoZSBkZXZpY2UgZmlsZSAoaWYgdGhlcmUgaXMpIGFuZCBvYnRhaW4NCj4gPiArCSAq
IGEgcmVmZXJlbmNlLiAgVGhpcyByZWZlcmVuY2UgaXMgaGVsZCB1bnRpbCBkZXZpY2UgY2xvc2Vk
Lg0KPiA+ICsJICogU2F2ZSB0aGUgcG9pbnRlciBpbiB0aGUgZGV2aWNlIGZvciB1c2UgYnkgZHJp
dmVycy4NCj4gPiArCSAqLw0KPiA+ICsJdmZpb19kZXZpY2VfZ2V0X2t2bV9zYWZlKGRmKTsNCj4g
PiArDQo+ID4gKwlkZi0+aW9tbXVmZCA9IGlvbW11ZmQ7DQo+ID4gKwlyZXQgPSB2ZmlvX2Rldmlj
ZV9vcGVuKGRmLCAmYmluZC5vdXRfZGV2aWQsIE5VTEwpOw0KPiANCj4gDQo+IFRoaXMgaXMgdW5y
ZWxhdGVkIHRvIHRoaXMgcGF0Y2ggYnV0IHJlbWluZGVkIG1lIC0gd2hpbGUgZGVidWdnaW5nIFFF
TVUsDQo+IHZmaW9fYXNzZXJ0X2RldmljZV9vcGVuKCkga2VwdCBmaXJpbmcgYXMgSSB3YXMga2ls
bGluZyBRRU1VICh3aGljaCBpbg0KPiB0dXJuIG1hZGUgdGhlIGtlcm5lbCBjbG9zZSBhbGwgZmRz
KSwgZGV2aWNlLT5vcGVuX2NvdW50PT0wIGFzIFFFTVUgd2FzDQo+IGR5aW5nIGJlZm9yZSBjYWxs
aW5nIGlvY3RsKFZGSU9fREVWSUNFX0JJTkRfSU9NTVVGRCkgd2hpY2ggd291bGQgY2FsbA0KPiB0
aGlzIHZmaW9fZGV2aWNlX29wZW4oKSBqdXN0IGFib3ZlLiBIYXMgdGhpcyBiZWVuIHJlcG9ydGVk
L2ZpeGVkLCBqdXN0DQo+IGN1cmlvdXM/DQoNClRoYW5rcywgSSB0aGluayB0aGlzIHdhcyBmaXhl
ZCBieSB0aGUgY29kZSBJIG1hcmtlZCBhYm92ZS4gSSB0aGluaw0KaXQgd2FzIHJhaXNlZCBpbiB2
MiByZXZpZXcuIFNob3VsZCBoYXZlIGJlZW4gZml4ZWQgYWZ0ZXIgdGhhdC4gSGF2ZQ0KdHJpZWQg
djUgb3IgdjY/IElmIHN0aWxsIGhhdmUgaXNzdWUsIHBsZWFzZSBmZWVsIGZyZWUgbGV0IG1lIGtu
b3cgaXQuDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9ZK0hJV1JNJTJGVGpXY3VUNklA
eXpoYW81Ni1kZXNrLnNoLmludGVsLmNvbS8NCg0KUmVnYXJkcywNCllpIExpdQ0K
