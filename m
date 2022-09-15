Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857B65B9D8C
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 16:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiIOOlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiIOOlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 10:41:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A41BB97;
        Thu, 15 Sep 2022 07:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663252786; x=1694788786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6mMtVf2Ey0woD+6ty1dTVxazRoSaZbhpy8DEsUwt/58=;
  b=OR8roGITTeXggVbCSqEL1SbcCbxIxQVGjAPu/XueA97g/kPIk/cq+uOT
   k7rI2mmP+w3zwzAN54AcUSAeKX/nLw0+WFclEBHyfxG3HIUIk0wXWALFF
   kZpvhna5V3GtcdOPd5Htst7030AS3TO1k8+9IOM3bYTt41J31if/7rDJ5
   ccle+mdJy7tpzGTEw02GqTsHlqJZhIfuQsCGzY3FdnRdEnCudkBlj1IAi
   pJeFs4j2WBGo4tO3cqj56Cu2PsX1C6flwvLB8kr4VGgoZRcU5dlSS8qE4
   86XIcjD6BMxOsKJrk4sJSdkDbvzqJihaKOOZiQgh7W59Ux6StifXJ/l/z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="285771018"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="285771018"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 07:39:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="612909817"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 15 Sep 2022 07:39:43 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 07:39:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 07:39:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 07:39:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPr3FMCQksGbJ1Z/+VDKSeVkkaTaq2Zu07MgdIyJaINQcJKe/2Cfj+Nvzc4JZ6GXuZT43X0pWSlB4iz0E4Mb0cY531ryM5PMvGrGnUR2Z2QtUn+3aMPTzmu1/iLTQo6FDWdwmlzdBaEfLAEajhvoH41bhE/KtvFJItAUmuYfE087/6VNwp3hECwInDbjV8UldSR3MSeKYEh466V32YfDEQrI6gR5+J9lZDuk1FoaBQ09DZUAoWAg8tebBndvM3JuCZtZyLs4m8Ge3B8CzZngtzRE5Mr6ihpKyrfD3k97Y0ZIv4e9JlXZlOiMvX5sgHzfNW4gSCfd7Fy+6/R8GOzZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mMtVf2Ey0woD+6ty1dTVxazRoSaZbhpy8DEsUwt/58=;
 b=AGWz/FwAqEv+sUDouNAa9wWi6/HccNMVvd2AS0iJXg/qIc3DRkcXQKguitKOXR8BSjgoCOxlwlpaeRnbB2Qs5jed4nFmVb8jtu+7feeQbq+9MpW68+9T7Zd3Ri0V13QrbUV6rSBKI3bwRAjt1rbH0Y2dpvQVBjVzUd571sOdUastHXGlf75g7ompZ5YQCKPLJ2yNbfADpIXwNYENllkN1ocnNMHvB6sQ4K010jymCGGDhjwGes/x3JkolY4zSIvpSy7oxE0LwToB7Gr+YARtWSR+UY4gpqn6rkWMbNlydjTvJzJog4m9rwWF7CXsbH2s666kG2eaQh3cy+uAOegHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 15 Sep
 2022 14:39:36 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18%4]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 14:39:36 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgBjymACAABFugIAA/X4AgABj1pCAAMFbAIAABJpg
Date:   Thu, 15 Sep 2022 14:39:36 +0000
Message-ID: <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
In-Reply-To: <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6365:EE_|IA1PR11MB6514:EE_
x-ms-office365-filtering-correlation-id: d3218293-4537-422c-5447-08da97281d03
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fD3tcoPbmqpGVRJ7959sZmKO6LvwrsBS4WYcLznDd2Mr9BZGcrt+jgEYBqSiHEHFPM1b55eBXTKYCnkt/cJeY7Z468oSudS9zzt8yzly4BNwGH1nn3dOFk2knDz1oZKd9jWToOFHA68R5VgBVhSK1CawE0KxF+Mklj6BqKBBzndKyrCZbXUdZPe5uAdB1NjwB054+CuBYeyL2mUQVotbhKUxjWnypS+UZ9XayxTsSQtQceziXGV6wWOsgz23U3I9ltOd/jj96DrPgeSUsinUzEK6L0q/yU1NlFbVjXEmx6qoa3xX28WujPjkQGmj6icHT5tMhDVecZRYYjrrbGG4v0JB8FFrAXP/+v/QF5RE1P8kNywiYu97QVIFf5EWW6NhbAgUHCIinxFXaf+0YykjMe1zMQfIwDo5gQSpChmpLFFJ55MzeXraGgwL4l9wHFqe4ttietxqlCqB3cl985nJLZUTH4/2WZ/9gZhqrAY7DoyTv7ljQ6EOVvjWyU90+3+ysMNMOkc7YcAw3f+kWj7Hl9K61MD4KoL/G/bOhzQeYtb+fBzK3XtdSkOTJbO1t0hoGjivgFU1KsQ39MvsnT1hga0fl0qfiYjQ02e081PQYbB9XgWg3gN97PJ7hy0wpWXeK5CczGONnsEyMF1L9r+Mx27yYrpWdZ1aJWoAKCw+NbRrz/u/CtEOsXmP9Pl1dxKm1aSrY6wU7ihE/LOLl+/taz6GOCbSQO/cfLhqeC/XmFI7Tqu41iRQBAsTXzOUILJJHaAPBy1SRJiWd4qhGlQiwh1KmYC2yUB4LcxdDxaZnO8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(110136005)(6636002)(7416002)(66946007)(26005)(54906003)(9686003)(478600001)(53546011)(41300700001)(6506007)(7696005)(33656002)(2906002)(4326008)(66446008)(66556008)(316002)(8936002)(186003)(55016003)(71200400001)(52536014)(66899012)(5660300002)(8676002)(64756008)(76116006)(66476007)(122000001)(38100700002)(83380400001)(38070700005)(82960400001)(921005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amk1Ym5qdmp6UHhscUFWcXJyZjJURGhLcGJRN0l3bldkNFdwWkovR3cyU0Z0?=
 =?utf-8?B?OWJnZ05ET3NyV1VxOXEyTjVPNzI4b29ESWZYcVlsWm4zUWoxWk8zME5SYUEr?=
 =?utf-8?B?cWJvWDZ3ZHg0aHdHVjB4VDgvdi82cjViSjg4ZVpNblAwQUVMcks0OXV6dXFX?=
 =?utf-8?B?R1JoaHVuYmYyMkpvTlRtSGVBanZhTDZoM2VBSXpxYlZ3T28wL0wrOVArSmMw?=
 =?utf-8?B?QlFGWWVsREUxVVZQUDcxNGk1RlRvVzdRYUpMMG45d1U4QTlVclA4L3M1NDVh?=
 =?utf-8?B?bHM1cUcrT2dCYklrbFVNdEhWRUNxYzc4a3E2aXFkT0FzZE5hY05UUjVNdmN6?=
 =?utf-8?B?VVA2T3NBZUJJM0hjcDhyaXBLaHZHZjZPSTZIM2dzaTc0aTl1dU1zR09uN0FL?=
 =?utf-8?B?VnhGM0dSVGtTTHJFR2ovd3hsbGVCYWpUMlg2NFI3UXk4T3IzeHpSZ05TeU5H?=
 =?utf-8?B?L2wyV0V3SEpUTGJTV0ppY241UHZ5VWZveC9ob3ZKaHEwajJlK1N2RFYyd0E2?=
 =?utf-8?B?Tk13a24zdWk4b2t1cEVjajROT1ZsN2IrZ1BuWTUzYVVGalBXNlo1S0lpVDhi?=
 =?utf-8?B?L1JwV214akVVM1hNQytISldrMGVKNmpMOWp0UXg3VC96N1U0R0ZuZG1Db3Rx?=
 =?utf-8?B?QXJMYXlvVEE0QmZwY0RpQ2d2bUVzeDVWbzBzdkxRQm92WGpHU1dEd2hoQnFN?=
 =?utf-8?B?aVJmT2Z0bnh6dEthODJqZ0VHeG9rcXVTRXdBTzhGOXZUUDVxR05uaXFNWXN4?=
 =?utf-8?B?MHBNTnlYYXJYOTRFYm5VRGdJbGlLb1luRDYzaHgzSUlhQnZkYWhuY1BzWDk3?=
 =?utf-8?B?Q0Q3ZFNtaVN0MkhjVVZ3SW1oVXRnZzBncG1XbWMrRjlpTGNSeDBtZWViaWtq?=
 =?utf-8?B?MVpEaHVHeDRuam1OUC9MY0dUQlNxL2VNMW5RcWp5ZWZMazkyMTcwNEpwcWxM?=
 =?utf-8?B?U3pEbzk5WnZzaEpPL0ZmUTNCSVUrQVlndVBTNGNJRDF5Z3lSZlFhditEcWg1?=
 =?utf-8?B?V0NNQ2JiSjZCdjBneVZFZHVTZUNjdWJ6ck42V2g0QyttcENBak1jMkpLd0F6?=
 =?utf-8?B?eDlXU1F2cDFTTXhGUFpPRlFBaHJkdXJzUnNsWTRiam5qV0dla1h3eFN5RDlX?=
 =?utf-8?B?U2U3SjVrMXJ2Szh4NTJYbzllS2QzRHBDSm5QNlppRnhrVlR0TXg4d0NxSjZW?=
 =?utf-8?B?NFhjNkxiNFBkdUtScDY2bW9NT3E2QmJEOGRWMGNDWUFLNzRFTk1JeWJaTHB4?=
 =?utf-8?B?TlZZRzZWZjlqVU5DNWpnVXdHK05jbGpZNWh2YkNGOVorVXRaUktqNGJmODFq?=
 =?utf-8?B?cTdEOUxlWEMyNnlmdkRJUzNyZHZIMHkydTB5Um42UmFRMkhkajh0RVV6RHc4?=
 =?utf-8?B?RkxkOWJrZlVsSk16ang5c0V3cTU0QmpscXpycnE2VHArT0w5aG1NbXZXRXh2?=
 =?utf-8?B?WENuSmJlK3ExNHhiM1Y4T3dveGxPZXVvMDlZcTFNT3ByWWEzdnh0b2VQb2pW?=
 =?utf-8?B?R3BsQm5PUzBlQjhRTG9MbXNCVWVncDZOQklmRUtSMGpTYkloZ2kyOExLVW53?=
 =?utf-8?B?OVR3MU04VnVwc0RHUEpRT3Nya0RSNlh3emtjbUZqYVZXMXZyVmUzN3FzdHJY?=
 =?utf-8?B?QW1ta3lHVlVqMGJ2RUVOeFV4emxEb0pSQXJWNnhTd1h4M1FaS1J3UTkwaEgy?=
 =?utf-8?B?TDAzY2YvT2RsYXQ3bUgzeVE4T0U5S2lGRHhJWWszZ1JvOEM2UGRBcWw0QUV1?=
 =?utf-8?B?Smx2Y0djbFBYOGpkRFl1d1NJZmMvU0ZDZmZzWDZZNTIvK3J6MTc2Njl0eHhy?=
 =?utf-8?B?aGRpbGhzSHh5bDBEa2lDM3d0RkFuanc3enBjOU5QRllMaDVDR29xTUVMTnA2?=
 =?utf-8?B?Ym1SaVdxZjl5SHZUT053OXNvVFNiT0VZUzNwOGY3MmJRMHJ3Z1ptN2FTTkFr?=
 =?utf-8?B?VTVzd0lEbldVemwvOFQ3dkY5VW80Q2xEOVFPbTN0eHBsdzFZZFlta3RyTWxm?=
 =?utf-8?B?bVhraXV4RmxjUWpBVGtOakZZWTZWQmczNlpqekxjUlpGQUN4a1MzVnNxNXNN?=
 =?utf-8?B?cjhqck94TGxKNWZRUVlvNk5wbUFCUHVrai85RGRoTlI0anhYVkxNZWZoWDNS?=
 =?utf-8?Q?DQGtsdQUVKRzEWnbe8iNvlMNu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3218293-4537-422c-5447-08da97281d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 14:39:36.7277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ad4/4ARnpeXhjuNmlFV36EkXqY1im9u6zjxyXbNnmbsSsXAn3pEtV1PKrLQGw512a82QPF6YpXp970EvW5+MYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIFNlcHRlbWJlciAxNSwgMjAyMiA5OjU1IFBNIExpYW5nLCBLYW4gd3JvdGU6
DQo+IE9uIDIwMjItMDktMTQgMTA6NDYgcC5tLiwgV2FuZywgV2VpIFcgd3JvdGU6DQo+ID4gT24g
VGh1cnNkYXksIFNlcHRlbWJlciAxNSwgMjAyMiA0OjI2IEFNLCBMaWFuZywgS2FuIHdyb3RlOg0K
PiA+PiBUaGUgcGVyZl9ldmVudF9kaXNhYmxlKCkgZXZlbnR1YWxseSBpbnZva2VzIHRoZSBpbnRl
bF9wdF9zdG9wKCkuDQo+ID4+IFdlIGFscmVhZHkgZXhwb3NlIHRoZSBpbnRlbF9wdF9zdG9wKCkv
Y3B1X2VtZXJnZW5jeV9zdG9wX3B0KCkgdG8NCj4gPj4gb3RoZXIgbW9kdWxlcy4gSSBkb24ndCB0
aGluayB3ZSBoYXZlIHRvIHVzZSB0aGUgcGVyZl9ldmVudF9kaXNhYmxlKCkuDQo+ID4+IEFsc28s
IHRoZQ0KPiA+PiBwZXJmX2V2ZW50X2Rpc2FibGUoKSByZXF1aXJlcyBleHRyYSBjb2Rlcy4NCj4g
Pj4NCj4gPj4gSSB3ZW50IHRocm91Z2ggdGhlIGRpc2N1c3Npb25zLiBJIGFncmVlIHdpdGggU2Vh
bidzIHN1Z2dlc3Rpb24uDQo+ID4+IFdlIHNob3VsZCBvbmx5IHB1dCB0aGUgbG9naWMgaW4gdGhl
IEtWTSBidXQgYWxsIHRoZSBNU1IgYWNjZXNzDQo+ID4+IGRldGFpbHMgaW50byB0aGUgUFQgZHJp
dmVyLg0KPiA+DQo+ID4gRXZlbiB0aGUgZHJpdmVyIGl0c2VsZiBkb2VzbuKAmXQgZHJpdmUgdGhl
IHNhdmUvcmVzdG9yZSBvZiB0aGUgTVNScywgaXQgaXMgZHJpdmVkDQo+IGJ5IHBlcmYuDQo+IA0K
PiBJdCB0aHJvdWdoIHBlcmZfZXZlbnQsIG5vdCBkcml2ZW4gYnkgcGVyZl9ldmVudC4gVGhlIHBl
cmZfZXZlbnQgZ2VuZXJpYyBjb2RlDQo+IG5ldmVyIGtub3dzIHdoZW4gc2hvdWxkIGludm9rZXMg
ZWFjaCBkcml2ZXIgdG8gc2F2ZS9yZXN0b3JlIGluZm9ybWF0aW9uLiBJdA0KPiBzaG91bGQgYmUg
ZHJpdmVuIGJ5IHRoZSBvdGhlciBzdWJzeXN0ZW0gZS5nLiwgc2NoZWR1bGVyLg0KDQpZZXMuIFRo
ZSBjcHUgc2NoZWR1bGVyIGRvZXMgdGhpcyB2aWEgdGhlIHBlcmYgc3Vic3lzdGVtLCB0aG91Z2gu
DQoNCj4gDQo+IEZvciB0aGlzIGNhc2UsIEtWTSBzaG91bGQgZHJpdmUgdGhlIHNhdmUvcmVzdG9y
ZSwgYW5kIHRoZSBQVCBkcml2ZXIgZXZlbnR1YWxseQ0KPiBkb2VzIGFsbCB0aGUgTVNSIGFjY2Vz
cyBkZXRhaWxzLg0KPiANCj4gPiAxLiBJZiB3ZSBtYWtlIEtWTSBhIHVzZXIgb2YgcGVyZiwgd2Ug
c2hvdWxkIGRvIHRoaXMgdmlhDQo+IHBlcmZfZXZlbnRfZGlzYWJsZS9lbmFibGVfKi4NCj4gPiAy
LiBJZiB3ZSBtYWtlIEtWTSBhbiBhbHRlcm5hdGl2ZSB0byBwZXJmIChpLmUuIGhhdmUgZGlyZWN0
IGNvbnRyb2wNCj4gPiBvdmVyIFBNVSBIVyksIHdlIGNhbiBkbyB0aGlzIHZpYSBkcml2ZXIgaW50
ZXJmYWNlcyBsaWtlIHBlcmYuDQo+ID4gUGVyIG15IGV4cGVyaWVuY2UsIHdlIHNob3VsZCBnbyBm
b3IgMS4gUHJvYmFibHkgbmVlZCBQZXRlcidzIG9waW5pb25zIG9uDQo+IHRoaXMuDQo+ID4NCj4g
DQo+IEZvciAxLCB0aGUgcGVyZl9ldmVudF9kaXNhYmxlL2VuYWJsZV8qIGFyZSBub3QgZW5vdWdo
LiBUaGV5IGRvbid0DQo+IHNhdmUvcmVzdG9yZSBNU1JzLiANCg0KcGVyZl9ldmVudF9kaXNhYmxl
IHdpbGwgZ28gdGhyb3VnaCBwZXJmIHRvIGNhbGwgcHRfZXZlbnRfc3RvcCB3aGljaCBzYXZlcyB0
aGUgcmVsYXRlZCBNU1JzLCByaWdodD8NCihpZiBzbywgd2hhdCBsYXJnZSBjaGFuZ2VzIGRpZCB5
b3UgbWVhbj8pDQoNCj4gSWYgd2UgZ28gdG8gdGhpcyB3YXksIHdlIGhhdmUgdG8gaW50cm9kdWNl
IGEgbmV3IGdlbmVyaWMNCj4gaW50ZXJmYWNlIHRvIGFzayBlYWNoIGRyaXZlciB0byBzYXZlL3Jl
c3RvcmUgdGhlaXIgTVNScyB3aGVuIHRoZSBndWVzdCBpcw0KPiBlbnRlcmluZy9leGl0aW5nLiBX
ZSdkIGJldHRlciBjb21iaW5lIHRoZSBuZXcgaW50ZXJmYWNlIHdpdGggdGhlIGV4aXN0aW5nDQo+
IHBlcmZfZ3Vlc3RfZ2V0X21zcnMoKSBvZiB0aGUgY29yZSBkcml2ZXIuDQo+IEkgdGhpbmsgdGhh
dCdzIGFuIGlkZWFsIHNvbHV0aW9uLCBidXQgcmVxdWlyZXMgYmlnIGNoYW5nZXMgaW4gdGhlIGNv
ZGUuDQo+IA0KPiAyIGlzIHRoZSBjdXJyZW50IEtWTSBpbXBsZW1lbnRhdGlvbi4gU2VlIHB0X3Nh
dmVfbXNyKCkvcHRfbG9hZF9tc3IoKS4gSSBkb24ndA0KPiB0aGluayBpdCdzIGEgcmlnaHQgd2F5
LiBXZSdkIGJldHRlciBmaXggaXQuDQo+IA0KPiBUaGUgc3VnZ2VzdGlvbiBzaG91bGQgYmUgMy4g
VGhlIEtWTSBub3RpZnkgdGhlIFBUIGRyaXZlciB2aWEgdGhlIGludGVyZmFjZQ0KPiBwcm92aWRl
ZCBieSBQVC4gVGhlIFBUIGRyaXZlciBzYXZlL3Jlc3RvcmUgYWxsIHRoZSByZWdpc3RlcnMuDQo+
IEkgdGhpbmsgaXQncyBhbiBhY2NlcHRhYmxlIHNvbHV0aW9uIHdpdGggc21hbGwgY29kZSBjaGFu
Z2VzLg0KDQpUaGlzIGxvb2tzIGxpa2Ugd2UganVzdCByZWxvY2F0ZSB0aGUgc2F2ZS9yZXN0b3Jl
IGZ1bmN0aW9ucyB0byB0aGUgUFQgZHJpdmVyIGFuZCBLVk0gc3RpbGwgZGlyZWN0bHkgY2FsbCB0
aGVtIC0gc3RpbGwgbm90IGdvaW5nIHRocm91Z2ggcGVyZidzIG1hbmFnZW1lbnQuIEltYWdpbmUg
ZXZlcnkgdXNlciBvcGVyYXRlcyBvbiB0aGUgcG11IGgvdyBkaXJlY3RseSBsaWtlIHRoaXMsIHRo
aW5ncyB3b3VsZCBiZSBhIG1lc3MuDQoNClRoYW5rcywNCldlaQ0KDQo=
