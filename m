Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929F1638260
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 03:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKYC1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 21:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYC1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 21:27:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BCC2657;
        Thu, 24 Nov 2022 18:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669343254; x=1700879254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SHX6hfoGmduvzTa+h74encaVLpr8MMP3Y39ylyhnZoI=;
  b=f3eCXb88hFQiVPR+YpMR9SHNBu3Eu5ajk0M7lziKje/hjdvqeWhp5Emv
   GiDbW8nXRdSqAsgP0VqQTLVWw9J0eITwrgYgK6AIDoU6ds3RYp/ahjIwb
   oQhYtjtmBWsTaEjnhRo2kVKNYxsKgOwmk+bJcvKdT9zJqrSx15AwRrZsg
   qsuvVHL8RYWofNnmVO3tqIm1/F5IUsCUzhs+l9IgCd7E5ZwMccIEazp5X
   Nxcx0EuCNVnqekHXyhQ4yxbHdP14ZIGUipbF7TtQfyuDw6Q21bR5LyhyT
   5xANL/BxDmVqncCY8nxeoOGQ5KB5An+iEoHCVECBQ2Z9dn5ztD1F4GuQa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="301967104"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="301967104"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 18:27:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="971418961"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="971418961"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 24 Nov 2022 18:27:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 18:27:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 18:27:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 18:27:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2i999LTCN6bOWxfz+LJc8pqThY7P5+aVV25tqTMpBRwdAV4Ju3QWHZR3AUUAkS0XgVBJeMx/ROVneV8NUBlIaCoLn8TImPCAMQCtttojv4R6ja7zBo1qgrSBgzKB4xrlzrWaFA0DAkejWlkhvStUDaMi6hle9kZYMZDYXzShpFJWzD5lttu8q/CX+OSaD4+dQELfy3F8b00C46CJe0ix5+q1PEYsIigvAC98B4a6I1A+i6SdjNgDwZmXZwrgG0I1y9WgiKaYspm93qmi2ULwO5fxC765O10hxK8PYXMazsyldur6pZOMX7LEhNE9e2J6sbhWFNnrm25jqMRaO+RAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHX6hfoGmduvzTa+h74encaVLpr8MMP3Y39ylyhnZoI=;
 b=XRlxbo61bW5+gY/Wl1geWORxqLSp9cc5Aw6YCjiS6JExQDDpD9nH3a/UkDwfQ2/QwGGMApu7I9dVX7vqd1ZfZu76FPyf3GBpUnh0Ti57kLacmdpzykbYxnQPnQv5YzPy5vkggm7HZiGDZcthEj4XqmRexWmdWI6hd+5atMkKmE8A1nADfxhCRo8FKgQzShJu7cas/59qo1u6ExoARGTh6IEO1v+oIVpgqZMokQ0wzQFl+BLlxespJyFNMTOzo7hhdolJnuz+G50bTOSMf6XCbqvrXz1/+PVYb28jYZg8Lb9UvK4kzyueO3uNGM9s3edykj0JsVVVgxaiI5Zmy6s1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 25 Nov
 2022 02:27:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 02:27:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 18/20] x86/virt/tdx: Initialize all TDMRs
Thread-Topic: [PATCH v7 18/20] x86/virt/tdx: Initialize all TDMRs
Thread-Index: AQHY/T3LwJsDsvnUkkqlNOoQtK62O65NQLiAgAGvqYA=
Date:   Fri, 25 Nov 2022 02:27:19 +0000
Message-ID: <e57b46c157461778c401425774bafe9795528c17.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <2337c8e9086a006aaa2c4b99caf478420d1fc640.1668988357.git.kai.huang@intel.com>
         <4e19a7e1-9088-21d6-d521-a76c340d8179@intel.com>
In-Reply-To: <4e19a7e1-9088-21d6-d521-a76c340d8179@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7044:EE_
x-ms-office365-filtering-correlation-id: 0c9434d0-df2a-49ca-da6d-08dace8c9381
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3dhNiNaWkI3teGZQL+0Iov537v+ExfTsnJROEp/dURQS00zHzQahGX9A8Oq13wpx276SdEqMqmarmwkjFH1DBVXbv7oEZF3sDMvAp31/gobkEYHKejlOnAIsY4UZWUnuSu4/NmXOxbz3OKc6vpzmEEMSKOKzoWVcyHgq1XoMykkRNTJz3XTXKe+aiwfyi1s3eVZn6zwsMOdV7IskzcbgKa8/CmbwBpLjpah5OKFUPa/XKrfaX/Jlhcx+pauAok5NuhE0Jhdi/d4qr9txL+X34g3b94VvttJt13Idyuz5Z/s+6OsHJw7n/1xZitMXnTlkVbXW6p/BESZRfDyW/n+WnA9ddyy9I/CtZX6ftut9g5v3kN8Y8Keq3P5DPVIh8QMeQ6vMLdH1NngL65kC+lkFuCABuCBB18Jh4M+jQeBYDorxSe9oS7imvYQT8VuDy/F/ECS3nU2kJURa018ljf5CPETW7OxWhqxMjPkvZ2DAMStAsSA/gzdGfl58qy6nl7nx+AflsDph1VQtpzkYFJygU0kIalVh61kMHvAX/uslHleIaj0ibNltDZrLYVAgFqU11WRWQL14nA5T9p2npScN+H/Ab/ItBy0ZEsi49iT3IKpqDtMkDdbUvzopU5W5vbKvvaRJRrtVV2dthVKgXD/Zddu/ydoQqr9d0XQrpi+cbZ87bHhHwFyf04rkZhHMCRcCHPF0Q7o1vKA6/Eka+Mj4/BKKOP/9o/Nf+LsiD/3MqUY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(36756003)(71200400001)(122000001)(38070700005)(82960400001)(6512007)(2906002)(83380400001)(4001150100001)(86362001)(478600001)(7416002)(66946007)(5660300002)(2616005)(26005)(8936002)(38100700002)(186003)(53546011)(64756008)(76116006)(66446008)(91956017)(6506007)(316002)(4326008)(8676002)(66556008)(54906003)(41300700001)(66476007)(6486002)(110136005)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YitLVGt5L0E1Z3FGSjdjWTl2bFdITHpQY094T09wZ1FmbWIvSzhlWlo5NWJk?=
 =?utf-8?B?VEo0Z3V1anNNeDJKNDFJZTFwcUpqWVB1cnhHYW1GeU4xQmx1VzNjZ1VFMEhm?=
 =?utf-8?B?S1o3WFFZcVdPNVJ2UkN0cUNuVVhJQnpnMEoycHlxUFJqci9EYjRnbkdWNjlK?=
 =?utf-8?B?a29lcmVSa3Y5cTRhYlBYZUxTN29EZE4zTFdRdGlCaTVxYmtGNEtXNzRzTjd2?=
 =?utf-8?B?K2pSNjBETVpTTEVpRnhma0Uxa1BEUTFZNXRUSXhUaE16VkhPT2xQaGxxTkd5?=
 =?utf-8?B?bnVQMHRoMUdNOTB2VlIxOUNod2NiaGtYTjN2MjBjUFBXSDN0T2trOTRwdk9x?=
 =?utf-8?B?a3ZyV2p3Z1hrTkQxMUROaCsxbTAvSmVUenJERWJyNUYxOFZDOERtM05ZdXlk?=
 =?utf-8?B?VHJLcTR1Y21hVEVEeU5NbmdyOEwyb1kxM3MxRnVvZmpodVVpTkxGckp1NDVH?=
 =?utf-8?B?dktxbytwbml0VzBKUS9QT0hNck81SHVnTjVoTWlvQzFuZk01aFlWV3EzSVli?=
 =?utf-8?B?UUNiT1BHR29UVTAyTHFhVjZzdUt6TU5HUDJKSmZDeVJIYVZtZzFxL3BOVGFi?=
 =?utf-8?B?WitCNkdjWnV6alA3dGhBT1IvdFFtWEowanFWeFlvRDc5alQxR2RlMlZCNndk?=
 =?utf-8?B?MFFnVVA2L1Z4bFRSUnJHY0hLckdHWXNWdCtKbjR4V2h2OTRYVlF5QzU0am82?=
 =?utf-8?B?VzhJbW5vaEJFQ3lrWmxpSTJNNFdpdENrN2owN1FEYjRNVzBJR0draEpvcS9j?=
 =?utf-8?B?VVdBbzlIYnovbzhmUDNkTXZnOVZIY28xZy9YV2tQUjhVc3NwVzlaMU0rUVRV?=
 =?utf-8?B?MHR1b2VpaGtBNzl2b3N4THdFR0lSTi91c3ZubVovQnlVSkxJQmU0SEFlNUZG?=
 =?utf-8?B?NnU1NXppczJlTmoxTk84ZUV2eFJmRmE0Y2VpOTZDRmRoTlJvNU5ta1F4bSth?=
 =?utf-8?B?aS80Q08yUnh0Q1BPU2k4RER2QmJKK2NQMDVuUWRpVG8rZmNtcExJRnp2ck1r?=
 =?utf-8?B?Wk1aVjVUT05zam50Y1F4cGhBUHdVYXJXWTdtbkYrd3VuWUh1TlNNU2duQkxD?=
 =?utf-8?B?L0xQbEkxL2FSUWRsOTlaT0w1MlNLRndVaHZFbFAzZUNvdlN2TC9aWGZjZWJ0?=
 =?utf-8?B?VUlYWEc0Y28ydmw3ZWNLdVA3anNFTWt1T05nVkY3ZVpIZDNwUHhpZ0dYSGE5?=
 =?utf-8?B?QTBpbklGV3pFcCs3YUxFZVp6SDF2SU5ta0tRZ0N0ZnJXSlhoQjVheWlsTkhi?=
 =?utf-8?B?TTNyT2pVOWcxczlLUEtGR2h1cHdRdnZldEEzZE5jdFBlZmx4cVpKay9LVWJy?=
 =?utf-8?B?U01IN1owU1VWSzhGQVdrQ1VrNkVwa1Izb2RiVy9VTDFTZmJOWWtqZmJXaHlF?=
 =?utf-8?B?akJmQy9BWWpZQlZTRStVeEgrdjhzd3BPQmcxaXF0blVYRlRBb01zQlViMXo0?=
 =?utf-8?B?RkVyN2kxZWljRkJhZHZFY0x1MzRKQ2pab2RCMWRDUjhGZXpkcGxjV2tvMUJ4?=
 =?utf-8?B?dDZoK3gyZ1VEcVZ1UzFHY3prZStKWEZ3WVl4dHR5YjVCVVB4K2JENnR0MVow?=
 =?utf-8?B?KzBQbWwwNndJSm5VMXBKbzJjY1d3akpKcFB0KzhubDBhVkZuSGV2TjAzQlRt?=
 =?utf-8?B?QTdzeXhlK25CQ2hEUEJpUmJDOElFZkpxYXFPK1QrQzhkanp4RFZIeXV5VTBi?=
 =?utf-8?B?aUdOeUYzVHpiVVg0VDVhR1JlTC9JaVFUVnRCdDFNbzFMaGxkNTZXcG9BWFA3?=
 =?utf-8?B?N3RSV0d1MnBMdW1xcG5DakFsbGJ2SU9senZwUC94MXVMeUxuVE5WSENwY3ZB?=
 =?utf-8?B?Y1NGeWwrZ0FpSnhUdlowUk42UitLbkQyOUpxeXVCc01uWkNBYTZCWDh1bjhQ?=
 =?utf-8?B?QlZOZlJRa2Fhd2RXTVNhbXZuY2UwVGVXQkdGQ3lsRVU2a2FVQUU3MTFwOG1I?=
 =?utf-8?B?Z2trYWlmVFFrZXFrc1VKajc1Y05XbE5MbjNFSGFhdDJFaG03Y28vdFd6M1dt?=
 =?utf-8?B?UGYzK1RUb1lJNjFKUGFBZlFSNGlibytrTFNUaitLd1BON1dveUR6WFo3ZGZO?=
 =?utf-8?B?VlcwSUdpeStuTlZ5TW9aSVBSZTFleEp6dlNsbFhIVHVJUVFKczJiVE5jM0k5?=
 =?utf-8?B?enRzb2hjZzN5S2V4bHkzNHNlRDhuMmtYaDlSY2ZldTdzNTZ5MEVCc3FKUDBo?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86A62CF5AE198642B26600C82DCDA61E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9434d0-df2a-49ca-da6d-08dace8c9381
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 02:27:19.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UOuMatbJRkq6DrL5Ri8k392fNhPVMBW9o4Oy7zbz0w+83+gxYrhnjqOpMxqqkK0KtQ1w0VPGfoMCQ/XQyxTJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
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

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE2OjQyIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBJbml0aWFsaXplIFRETVJz
IHZpYSBUREguU1lTLlRETVIuSU5JVCBhcyB0aGUgbGFzdCBzdGVwIHRvIGNvbXBsZXRlIHRoZQ0K
PiA+IFREWCBpbml0aWFsaXphdGlvbi4NCj4gPiANCj4gPiBBbGwgVERNUnMgbmVlZCB0byBiZSBp
bml0aWFsaXplZCB1c2luZyBUREguU1lTLlRETVIuSU5JVCBTRUFNQ0FMTCBiZWZvcmUNCj4gPiB0
aGUgbWVtb3J5IHBhZ2VzIGNhbiBiZSB1c2VkIGJ5IHRoZSBURFggbW9kdWxlLiAgVGhlIHRpbWUg
dG8gaW5pdGlhbGl6ZQ0KPiA+IFRETVIgaXMgcHJvcG9ydGlvbmFsIHRvIHRoZSBzaXplIG9mIHRo
ZSBURE1SIGJlY2F1c2UgVERILlNZUy5URE1SLklOSVQNCj4gPiBpbnRlcm5hbGx5IGluaXRpYWxp
emVzIHRoZSBQQU1UIGVudHJpZXMgdXNpbmcgdGhlIGdsb2JhbCBLZXlJRC4NCj4gPiANCj4gPiBU
byBhdm9pZCBsb25nIGxhdGVuY3kgY2F1c2VkIGluIG9uZSBTRUFNQ0FMTCwgVERILlNZUy5URE1S
LklOSVQgb25seQ0KPiA+IGluaXRpYWxpemVzIGFuIChpbXBsZW1lbnRhdGlvbi1zcGVjaWZpYykg
c3Vic2V0IG9mIFBBTVQgZW50cmllcyBvZiBvbmUNCj4gPiBURE1SIGluIG9uZSBpbnZvY2F0aW9u
LiAgVGhlIGNhbGxlciBuZWVkcyB0byBjYWxsIFRESC5TWVMuVERNUi5JTklUDQo+ID4gaXRlcmF0
aXZlbHkgdW50aWwgYWxsIFBBTVQgZW50cmllcyBvZiB0aGUgZ2l2ZW4gVERNUiBhcmUgaW5pdGlh
bGl6ZWQuDQo+ID4gDQo+ID4gVERILlNZUy5URE1SLklOSVRzIGNhbiBydW4gY29uY3VycmVudGx5
IG9uIG11bHRpcGxlIENQVXMgYXMgbG9uZyBhcyB0aGV5DQo+ID4gYXJlIGluaXRpYWxpemluZyBk
aWZmZXJlbnQgVERNUnMuICBUbyBrZWVwIGl0IHNpbXBsZSwganVzdCBpbml0aWFsaXplDQo+ID4g
YWxsIFRETVJzIG9uZSBieSBvbmUuICBPbiBhIDItc29ja2V0IG1hY2hpbmUgd2l0aCAyLjJHIENQ
VXMgYW5kIDY0R0INCj4gPiBtZW1vcnksIGVhY2ggVERILlNZUy5URE1SLklOSVQgcm91Z2hseSB0
YWtlcyBjb3VwbGUgb2YgbWljcm9zZWNvbmRzIG9uDQo+ID4gYXZlcmFnZSwgYW5kIGl0IHRha2Vz
IHJvdWdobHkgZG96ZW5zIG9mIG1pbGxpc2Vjb25kcyB0byBjb21wbGV0ZSB0aGUNCj4gPiBpbml0
aWFsaXphdGlvbiBvZiBhbGwgVERNUnMgd2hpbGUgc3lzdGVtIGlzIGlkbGUuDQo+IA0KPiBBbnkg
Y2hhbmNlIHlvdSBjb3VsZCBzYXkgVERILlNZUy5URE1SLklOSVQgYSBmZXcgbW9yZSB0aW1lcyBp
biB0aGVyZT8gOykNCg0KSSBhbSBhIGJhZCBjaGFuZ2Vsb2cgd3JpdGVyLg0KDQo+IA0KPiBTZXJp
b3VzbHksIHBsZWFzZSB0cnkgdG8gdHJpbSB0aGF0IGRvd24uICBJZiB5b3UgdGFsayBhYm91dCB0
aGUNCj4gaW1wbGVtZW50YXRpb24gaW4gZGV0YWlsIGluIHRoZSBjb2RlIGNvbW1lbnRzLCBkb24n
dCBjb3ZlciBpdCBpbiBkZXRhaWwNCj4gaW4gdGhlIGNoYW5nZWxvZyB0b28uDQoNClllcyB3aWxs
IHVzZSB0aGlzIHRpcCB0byB0cmltIGRvd24uICBUaGFua3MgZm9yIHRoZSB0aXAuDQoNCj4gDQo+
IEFsc28sIHRoaXMgaXMgYSBtb21lbnRvdXMgcGF0Y2gsIHJpZ2h0PyAgSXQncyB0aGUgbGFzdCBw
aWVjZS4gIE1heWJlDQo+IHdvcnRoIGNhbGxpbmcgdGhhdCBvdXQuDQoNClllcyB0aGlzIGlzIHRo
ZSBsYXN0IHN0ZXAgb2YgaW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLiAgSXQgaXMgc29ydCBv
Zg0KbWVudGlvbmVkIGluIHRoZSBmaXJzdCBzZW50ZW5jZSBvZiB0aGlzIGNoYW5nZWxvbmc6DQoN
CglJbml0aWFsaXplIFRETVJzIHZpYSBUREguU1lTLlRETVIuSU5JVCBhcyB0aGUgbGFzdCBzdGVw
IHRvIGNvbXBsZXRlIHRoZQ0KCVREWCBpbml0aWFsaXphdGlvbi4NCg0KQnV0IHBlcmhhcHMgaXQg
Y2FuIGJlIG1vcmUgZXhwbGljaXRseS4NCg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gaW5k
ZXggOTlkMWJlNTk0MWE3Li45YmNkYjMwYjdhODAgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5j
DQo+ID4gQEAgLTEwNjYsNiArMTA2Niw2NSBAQCBzdGF0aWMgaW50IGNvbmZpZ19nbG9iYWxfa2V5
aWQodm9pZCkNCj4gPiAgCXJldHVybiBzZWFtY2FsbF9vbl9lYWNoX3BhY2thZ2Vfc2VyaWFsaXpl
ZCgmc2MpOw0KPiA+ICB9DQo+ID4gIA0KPiA+ICsvKiBJbml0aWFsaXplIG9uZSBURE1SICovDQo+
IA0KPiBEb2VzIHRoaXMgY29tbWVudCBhZGQgdmFsdWU/ICBFdmVuIGlmIGl0IGRvZXMsIGl0IGlz
IGJldHRlciB0aGFuIG5hbWluZw0KPiB0aGUgZGFuZyBmdW5jdGlvbiBpbml0X29uZV90ZG1yKCk/
DQoNClNvcnJ5IHdpbGwgdHJ5IGJlc3QgdG8gYXZvaWQgc3VjaCB0eXBlIG9mIGNvbW1lbnRzIGlu
IHRoZSBmdXR1cmUuDQoNCj4gDQo+ID4gK3N0YXRpYyBpbnQgaW5pdF90ZG1yKHN0cnVjdCB0ZG1y
X2luZm8gKnRkbXIpDQo+ID4gK3sNCj4gPiArCXU2NCBuZXh0Ow0KPiA+ICsNCj4gPiArCS8qDQo+
ID4gKwkgKiBJbml0aWFsaXppbmcgUEFNVCBlbnRyaWVzIG1pZ2h0IGJlIHRpbWUtY29uc3VtaW5n
IChpbg0KPiA+ICsJICogcHJvcG9ydGlvbiB0byB0aGUgc2l6ZSBvZiB0aGUgcmVxdWVzdGVkIFRE
TVIpLiAgVG8gYXZvaWQgbG9uZw0KPiA+ICsJICogbGF0ZW5jeSBpbiBvbmUgU0VBTUNBTEwsIFRE
SC5TWVMuVERNUi5JTklUIG9ubHkgaW5pdGlhbGl6ZXMNCj4gPiArCSAqIGFuIChpbXBsZW1lbnRh
dGlvbi1kZWZpbmVkKSBzdWJzZXQgb2YgUEFNVCBlbnRyaWVzIGluIG9uZQ0KPiA+ICsJICogaW52
b2NhdGlvbi4NCj4gPiArCSAqDQo+ID4gKwkgKiBDYWxsIFRESC5TWVMuVERNUi5JTklUIGl0ZXJh
dGl2ZWx5IHVudGlsIGFsbCBQQU1UIGVudHJpZXMNCj4gPiArCSAqIG9mIHRoZSByZXF1ZXN0ZWQg
VERNUiBhcmUgaW5pdGlhbGl6ZWQgKGlmIG5leHQtdG8taW5pdGlhbGl6ZQ0KPiA+ICsJICogYWRk
cmVzcyBtYXRjaGVzIHRoZSBlbmQgYWRkcmVzcyBvZiB0aGUgVERNUikuDQo+ID4gKwkgKi8NCj4g
DQo+IFRoZSBQQU1UIGRpc2N1c3Npb24gaGVyZSBpcywgSU1OSE8gc2lsbHkuICBJZiB0aGlzIHdl
cmUgYWJvdXQNCj4gaW5pdGlhbGl6aW5nIFBBTVQncyB0aGVuIGl0IHNob3VsZCBiZSByZW5hbWVk
IGluaXRfcGFtdHMoKSBhbmQgdGhlDQo+IFNFQU1DQUxMIHNob3VsZCBiZSBjYWxsZWQgUEFNVF9J
TklUIG9yIHNvZW10aGluZy4gIEl0J3Mgbm90LCBhbmQgdGhlIEFCSQ0KPiBpcyBidWlsdCBhcm91
bmQgdGhlIFRETVIgYW5kICppdHMqIGFkZHJlc3Nlcy4NCg0KQWdyZWVkLg0KDQo+IA0KPiBMZXQn
cyBjaG9wIHRoaXMgY29tbWVudCBkb3duOg0KPiANCj4gCS8qDQo+IAkgKiBJbml0aWFsaXppbmcg
YSBURE1SIGNhbiBiZSB0aW1lIGNvbnN1bWluZy4gIFRvIGF2b2lkIGxvbmcNCj4gCSAqIFNFQU1D
QUxMcywgdGhlIFREWCBtb2R1bGUgbWF5IG9ubHkgaW5pdGlhbGl6ZSBhIHBhcnQgb2YgdGhlDQo+
IAkgKiBURE1SIGluIGVhY2ggY2FsbC4NCj4gCSAqLw0KPiANCj4gVGFsayBhYm91dCB0aGUgbG9v
cGluZyBsb2dpYyBpbiB0aGUgbG9vcC4NCg0KQWdyZWVkLiBUaGFua3MuDQoNCj4gDQo+ID4gKwlk
byB7DQo+ID4gKwkJc3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0IG91dDsNCj4gPiArCQlpbnQgcmV0
Ow0KPiA+ICsNCj4gPiArCQlyZXQgPSBzZWFtY2FsbChUREhfU1lTX1RETVJfSU5JVCwgdGRtci0+
YmFzZSwgMCwgMCwgMCwgTlVMTCwNCj4gPiArCQkJCSZvdXQpOw0KPiA+ICsJCWlmIChyZXQpDQo+
ID4gKwkJCXJldHVybiByZXQ7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBSRFggY29udGFpbnMgJ25l
eHQtdG8taW5pdGlhbGl6ZScgYWRkcmVzcyBpZg0KPiA+ICsJCSAqIFRESC5TWVMuVERNUi5JTlQg
c3VjY2VlZGVkLg0KPiA+ICsJCSAqLw0KPiA+ICsJCW5leHQgPSBvdXQucmR4Ow0KPiA+ICsJCS8q
IEFsbG93IHNjaGVkdWxpbmcgd2hlbiBuZWVkZWQgKi8NCj4gDQo+IFRoYXQgY29tbWVudCBpcyBh
IHdlZSBiaXQgc3VwZXJmbHVvdXMsIGRvbid0IHlvdSB0aGluaz8NCg0KSW5kZWVkLg0KDQo+IA0K
PiA+ICsJCWNvbmRfcmVzY2hlZCgpOw0KPiANCj4gCQkvKiBLZWVwIG1ha2luZyBTRUFNQ0FMTHMg
dW50aWwgdGhlIFRETVIgaXMgZG9uZSAqLw0KPiANCj4gPiArCX0gd2hpbGUgKG5leHQgPCB0ZG1y
LT5iYXNlICsgdGRtci0+c2l6ZSk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4g
PiArDQo+ID4gKy8qIEluaXRpYWxpemUgYWxsIFRETVJzICovDQo+IA0KPiBEb2VzIHRoaXMgY29t
bWVudCBhZGQgdmFsdWU/DQoNCk5vLiAgV2lsbCByZW1vdmUuDQoNCj4gDQo+ID4gK3N0YXRpYyBp
bnQgaW5pdF90ZG1ycyhzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2FycmF5LCBpbnQgdGRtcl9udW0p
DQo+ID4gK3sNCj4gPiArCWludCBpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBJbml0aWFs
aXplIFRETVJzIG9uZS1ieS1vbmUgZm9yIHNpbXBsaWNpdHksIHRob3VnaCB0aGUgVERYDQo+ID4g
KwkgKiBhcmNoaXRlY3R1cmUgZG9lcyBhbGxvdyBkaWZmZXJlbnQgVERNUnMgdG8gYmUgaW5pdGlh
bGl6ZWQgaW4NCj4gPiArCSAqIHBhcmFsbGVsIG9uIG11bHRpcGxlIENQVXMuICBQYXJhbGxlbCBp
bml0aWFsaXphdGlvbiBjb3VsZA0KPiA+ICsJICogYmUgYWRkZWQgbGF0ZXIgd2hlbiB0aGUgdGlt
ZSBzcGVudCBpbiB0aGUgc2VyaWFsaXplZCBzY2hlbWUNCj4gPiArCSAqIGJlY29tZXMgYSByZWFs
IGNvbmNlcm4uDQo+ID4gKwkgKi8NCj4gDQo+IFRyaW0gZG93biB0aGUgY29tbWVudDoNCj4gDQo+
IAkvKg0KPiAJICogVGhpcyBvcGVyYXRpb24gaXMgY29zdGx5LiAgSXQgY2FuIGJlIHBhcmFsbGVs
aXplZCwNCj4gCSAqIGJ1dCBrZWVwIGl0IHNpbXBsZSBmb3Igbm93Lg0KPiAJICovDQoNClRoYW5r
cy4NCg0KWy4uLl0NCg0KDQo=
