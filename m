Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20933633103
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiKUX4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiKUX4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:56:06 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415B85F63;
        Mon, 21 Nov 2022 15:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669074964; x=1700610964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NDFuNzR6nu5nJHuD3GRS85zbbJYsI5Rk7kyCwXrS2lk=;
  b=aq8rLVYYEThbNqRV9wjm3gVsTMa3x4q+EraksStA+hPxLoCsf/nUn13q
   ljDk/JV/SGg3IOEIYCfBrwjZjrjw7u1l6cD/N9RKUYYAjQG3bLy5R5gC2
   n7iALHGX4mwsA5RVcSuEHlBZ4LJlVc6SQX3CuCM5MUW7US5L19EmUGVrJ
   9TxA5oSv9dYUDm27V97xBpRgISLGEWpPz7zDIYKYPuEFgMk8f1WSpWauo
   ar1jLFRNVB1hec40vY/hIVIOafzxJxHMEMuBxxFw6rCSAjhfazWRQ9mjO
   g4u/CW9We5kCXp44Z8v7bUYF7qdyVLl3Szg2GsZactk5MUPR6Co8sJJJT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311319315"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="311319315"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:56:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="635351874"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="635351874"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2022 15:56:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 15:56:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 15:56:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 15:56:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy5SzY9I0zreh1AalrHOlkndolgHWa5YuW1gOiPML9j+R/Hm539P1Lhqa/mNpL32tcCKldgtInz1tuSei/C2E3OlCxpZltC8nD5Aw2mYoV7WzIRssJ0XA5AkmFtqURExMyGix11Nzky/n/38HNZURQjAZ/1hPJ692XsupLF6sUkbuCoWc+Hkc5Ykrm4XY8gcvc/yyupglmyEEQaMguSZ4ePYDo7Wxbnz2pQHnG6Pkfi5cvTcMSi8Zmv0oYEtb2pwUs0sSHiMbl6sBjtwJnwlPu/8awVK6cILsyeg+LyMWLwDchO5FumQsDAti4bJN3cTD9CkBKj8EWbOPYoQ6qErXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDFuNzR6nu5nJHuD3GRS85zbbJYsI5Rk7kyCwXrS2lk=;
 b=Ye8AYJrFk+fchx8XqOQO+Z+nLpfHzemTu3a2vALhXM84J/ajCoq6/X7yfoNZ8+E0nx+6b58IGHGoQ6U1/LEET/vR18cY066M+wmecjCX2o/OZJayjRZu4/CXTxr8GzAINX0NQosDcFQazIjTkUhVVt92p5QAMRHz6XkUxxW5hGZqU1xG8jAQ4znUBPlk2ECntbL6XIPuU8dp8a0RKhXZcCske2Tj+ncMfLRCCIjlcDyW9ai7mwUqpYtWTIWiN+yb+YYr/aWeQGOkJkndNUverpfELNuxaRwST857QjENkR4Hh/XZWy9KaoS+piaDhoVdSLARWuLC+ufuEkLrJUISuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6414.namprd11.prod.outlook.com (2603:10b6:930:36::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 23:55:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 23:55:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 056/108] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Thread-Topic: [PATCH v10 056/108] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Thread-Index: AQHY7CiYmy+NZsCui0WKLCRu9CH+ba5KMUeA
Date:   Mon, 21 Nov 2022 23:55:58 +0000
Message-ID: <e813c4791d3b0a6d14f344dfd881d65a2060764a.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f0f134dcf59f901e4b8960c7b3f242dcd42b1c40.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <f0f134dcf59f901e4b8960c7b3f242dcd42b1c40.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6414:EE_
x-ms-office365-filtering-correlation-id: eff94c03-54e5-4449-d72b-08dacc1beff0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AK48/OSzWIIM7x7aZmiApHLaX2ABXR1Duyk/pyOoItHKc3DDBLMAByPnedHcO9Ac+9JjkUduGIf1OsPVAfBoUgpEQ957meMBV42J0PdYIiiMV1tFDaKzPMEwjDfSZt+vDTtODNm5JiZZ5O43IUEeCZzRwGF0ckXBBT0nq4HV5BExi3p7GyEigIaX9oVDFUVu/7yt7O+gPv2WtcZVwfVeH0NYaJmKS/rLwqm4+zBSboW+vCT2i65d6rmsZaPRBqcDT5BxPVVAIj0i3lKduHPKJQlwW/vRpTt3mSD6x+6P/lYgQc9zTRA9mHeWkHYkxKDECMUuiRGElLaVVey2hzhr6CZLbkZ6gFbEAWr4KmDO4rz5+YXdkUWFcU3tCDP26z6hDkX0XHukWftb2M7PwLCdRtL3DoXJwFjPa4wYVXmU4NnooVpHowiXOx28MwDzlWt/c3dmH7gOaPmKsHEVntXSH4sTInpjBW3d3Y9nNAu4WiFPhInRxvYUK6Z5sE/zjqSYIblC+doITnrcbHAbUwoukk+QKr52vTl3GH3zscStmsLvLTVAxamQ7Uoorv4JqtyGXh/HXSYB6KwA+emWu7s3nsa6xxM8FcsCk0xYU5BsKIJoZ9hjwir97ZpgP5c+OL37Pn5OeGUYHE0/mlYLmyvBJvI6HV1ZXUBjQmpDZHjvjd+8PrRr57EnpZx15yXrWz7SS/wTYQFgRSaQpQGXOG2F+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199015)(71200400001)(8676002)(38100700002)(36756003)(83380400001)(2616005)(186003)(110136005)(4326008)(66446008)(86362001)(91956017)(66556008)(76116006)(478600001)(6486002)(38070700005)(5660300002)(41300700001)(122000001)(64756008)(66476007)(66946007)(82960400001)(8936002)(4001150100001)(54906003)(6636002)(2906002)(6506007)(316002)(6512007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWNOSExGOXZwUjMwbW44bTJYNkc1QTROVWNtazlMMDlDUnBXK1pLWEJVTFhJ?=
 =?utf-8?B?d2l0YVA1dGFMRnkxUWx3dDhoMzRKU3dXL1RVdXZoRUxSdTN5RDJjTGtieFA5?=
 =?utf-8?B?bUhGaW9zRVQ5WWpRNXZTN0VuYW9tS3hCc2d6UkUyM0JsTWZDUWhscURBZ2M2?=
 =?utf-8?B?a01Vb1A5QlcxNEk0ZzRMdzFZcEZsOGJlbXQ2NVpPSkRMSEJObk1VVE51Tm5M?=
 =?utf-8?B?L0R1TDFHYmlxL3lQdHd6eWYxNlMvd05ENmpSMG04OXdiMTZZZnFITDgxNy9Z?=
 =?utf-8?B?YzR2a3hPN3J4bHZZMmJ5N1JFZmQya2xZZFJPY210a1FJcExEbjRvaE91WU1J?=
 =?utf-8?B?akRncmxjYXg1UGpCQ1BHQ0czWmVVS3FZcmxJakJ0NjdtbytLQTd3amRYWSsy?=
 =?utf-8?B?WHBVS1JFZk1ISnJPTEtQMTdHRkdVM0s4Zm1iTkJJUlkyYWUrdkJNUXYyN2Fq?=
 =?utf-8?B?V1pZSGh0YTBkN0NQeUs5cGxSWlZnZzVMdFY5YnRKbFl5RDhGc1NrM3VhRitp?=
 =?utf-8?B?NDFkRVJsZ3JBSTdYcVB0eWdFWFVQd1NmdXVsL1IwU05acnlEN2VuYnRGVk9C?=
 =?utf-8?B?bUNEUi9ubkErR3hqWHpBdjhtZ1pIblppUWpkU3B6MktFYzlQMkxhaXR1cW8z?=
 =?utf-8?B?aGsvWmpYdWs3Nm8yV3UxS2QrdmhNcDF5Q3RxSjROSHFsTmZ3WkVHc3FPTmJB?=
 =?utf-8?B?emx4S2hoRmRoVTZaaUhtNWp4ZWZZV0ozU210S1Y5cXJqNkNoNHBmdUZndlg5?=
 =?utf-8?B?WWxDVUhBNTE2am5TYjhYODl0MVhrT2VJWUhhaVFiZ3Zza21WTUlVRHlHTExt?=
 =?utf-8?B?QnU4WThmWVgxM3k4WWhZSGlHb2ZpMSs4M0I5WXVCekJZOGs2Y1hFcFJjY01l?=
 =?utf-8?B?YTl5djMvR3Q0Njl3Um4vNEIycUhNakRTNmQrM0lMY09vMGM5MlRCd3kyN1hG?=
 =?utf-8?B?UjRpSlBWaG1lSnl0MWVFV293ZUYrTExkSVFaYUppV2NHSnRBNWFzblFBbXRs?=
 =?utf-8?B?b08vZGIzVURQY3NyaHZpcW1obGVDZ21OM3JpKzRPREtibGQ1K0hkM0xkamUz?=
 =?utf-8?B?TDMwNERNcWhTeCsxSEN2cldXQmxpNGFQZjcxT09pdkVvWlpFTE5vMi9JQlpo?=
 =?utf-8?B?WnlCMis0bGJnb2pQNU1wMVhTS2MwZ3g0QVJ6S1NTUk93aElaYk1NclR2T1lz?=
 =?utf-8?B?ZkxSMUlsRGQ3cWhGcU0zOGpKUXQ3akVJajJMbVk5ZGFBUjFRN05VTHZlSUMv?=
 =?utf-8?B?STN1Wkd5Vm1XaHlXMXVaYXFZTzFVTjAyVE5scEdGa3ZLemt0VS9oQVRHZkdU?=
 =?utf-8?B?aXRIR2dydjdITkVYWlFVWXAwWFdPeWxRQi9scmJEbDAxaFNMZkJXNUFZSUZj?=
 =?utf-8?B?NkYwSXZ4TVpnOGJuQ1VLNy9PYS96TXRXbVVsQXgxK0pCRmk2V2w1d3lFREMw?=
 =?utf-8?B?RjZNUmdzeERsNDJCRVFXb1llYVNWWXR2OExuNzBqbUVXT3E0bm1vN1ZhOThy?=
 =?utf-8?B?TlVyNGg2cUhxMnE2djJRRVhXd0dxTGRkL1RCU2VVNDE0ZHVUZ0RnMmVveDBO?=
 =?utf-8?B?MFVXMm1vd1NVWGVNNUdwZytPMmZsVE1KajF3UzhKYnkyUzUvZlBqQy80Z053?=
 =?utf-8?B?UWJnU25Oc1B6M1N2bk1jNkd0cG8rNFJ5N0ZYRnlicXhjZnRHVGo1Tm8yUTdU?=
 =?utf-8?B?MG9qK3l5WkQyc1NSTjRta3BPYjhhN3VxSXAwbFFzYWRHdTNTc1NZbmlVQmJk?=
 =?utf-8?B?VkxDN0VwVVhBbTQ1TS84dFl6SWJKb3d2YW95SzFKWHBOSHEwY2k2RC95M0ho?=
 =?utf-8?B?Q2FMUnk2MDk3bkthdlFiNzJLNUZGa1krT3hRTFhKcXRKQ1QwWFhHSmx6c0s1?=
 =?utf-8?B?Rm1VYUY4U3BkT3g1dFRLTmxxSWlianQ0SGVhQXZpSVcvZzl1MDUyQzRZRmVR?=
 =?utf-8?B?a004cXMxOW5OTFBncjYyMGtyWlVXaFNNaW82aHVRU21pdWxjWERRR1Z2K0Nj?=
 =?utf-8?B?dm8wSUlFRXp4ZW53bjg4T0VidmhaTGVlZm1RRksxU3JNdzBMbTBGQXdBL0VN?=
 =?utf-8?B?WlQyK1dHbWMvcitwMGp6VW93eW1QQWJZSk92MC9VRHZwclBaZkZlcFAvaStO?=
 =?utf-8?B?M3Q3bldrbDZWaTYxbUgvNXJsUjQ0TXFCOW0wOE5YZ3NGQTErekVEYVp6cVZw?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <132F5C08AAF3F548875C51642D75D2E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff94c03-54e5-4449-d72b-08dacc1beff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 23:55:58.7599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uDKqjY8oaj7zMvOUan+1ZumOK7psUEGxw2LpCW6s9aciqjMbAr2qyrqun7Qe5Rq2IlrEOOkL0KIszcPUqvahGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6414
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggZG9lc24ndCBuZWVkIEFQSUMgcGFnZSBkZXBlbmRpbmcgb24gdmFwaWMg
YW5kIGl0cyBjYWxsYmFjayBpcw0KPiBXQVJOX09OX09OQ0UoaXNfdGR4KS4gIFRvIGF2b2lkIHVu
bmVjZXNzYXJ5IG92ZXJoZWFkIGFuZCBXQVJOX09OX09OQ0UoKSwNCj4gc2tpcCByZXF1ZXN0aW5n
IEtWTV9SRVFfQVBJQ19QQUdFX1JFTE9BRCB3aGVuIFRELg0KPiANCj4gICBXQVJOSU5HOiBhcmNo
L3g4Ni9rdm0vdm14L21haW4uYzo2OTYgdnRfc2V0X2FwaWNfYWNjZXNzX3BhZ2VfYWRkcisweDNj
LzB4NTAgW2t2bV9pbnRlbF0NCj4gICBSSVA6IDAwMTA6dnRfc2V0X2FwaWNfYWNjZXNzX3BhZ2Vf
YWRkcisweDNjLzB4NTAgW2t2bV9pbnRlbF0NCj4gICBDYWxsIFRyYWNlOg0KPiAgICB2Y3B1X2Vu
dGVyX2d1ZXN0KzB4MTQ1ZC8weDI0ZDAgW2t2bV0NCj4gICAga3ZtX2FyY2hfdmNwdV9pb2N0bF9y
dW4rMHgyNWQvMHhjYzAgW2t2bV0NCj4gICAga3ZtX3ZjcHVfaW9jdGwrMHg0MTQvMHhhMzAgW2t2
bV0NCj4gICAgX194NjRfc3lzX2lvY3RsKzB4YzAvMHgxMDANCj4gICAgZG9fc3lzY2FsbF82NCsw
eDM5LzB4YzANCj4gICAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhZQ0K
PiANCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVs
LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgfCA0ICsrKy0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggMzg2ODYw
NTQ2MmVkLi41ZGFkZDBmOWExMGUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0K
PiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTEwNDg3LDcgKzEwNDg3LDkgQEAgdm9p
ZCBrdm1fYXJjaF9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9yYW5nZShzdHJ1Y3Qga3ZtICprdm0s
DQo+ICAJICogVXBkYXRlIGl0IHdoZW4gaXQgYmVjb21lcyBpbnZhbGlkLg0KPiAgCSAqLw0KPiAg
CWFwaWNfYWRkcmVzcyA9IGdmbl90b19odmEoa3ZtLCBBUElDX0RFRkFVTFRfUEhZU19CQVNFID4+
IFBBR0VfU0hJRlQpOw0KPiAtCWlmIChzdGFydCA8PSBhcGljX2FkZHJlc3MgJiYgYXBpY19hZGRy
ZXNzIDwgZW5kKQ0KPiArCS8qIFREWCBkb2Vzbid0IG5lZWQgQVBJQyBwYWdlLiAqLw0KPiArCWlm
IChrdm0tPmFyY2gudm1fdHlwZSAhPSBLVk1fWDg2X1REWF9WTSAmJg0KPiArCSAgICBzdGFydCA8
PSBhcGljX2FkZHJlc3MgJiYgYXBpY19hZGRyZXNzIDwgZW5kKQ0KPiAgCQlrdm1fbWFrZV9hbGxf
Y3B1c19yZXF1ZXN0KGt2bSwgS1ZNX1JFUV9BUElDX1BBR0VfUkVMT0FEKTsNCj4gIH0NCj4gIA0K
DQpJbiBwYXRjaCAiW1BBVENIIHYxMCAxMDUvMTA4XSBLVk06IFREWDogQWRkIG1ldGhvZHMgdG8g
aWdub3JlIGFjY2Vzc2VzIHRvIENQVQ0Kc3RhdGUiLCB5b3UgaGF2ZToNCg0KK3N0YXRpYyB2b2lk
IHZ0X3NldF9hcGljX2FjY2Vzc19wYWdlX2FkZHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KK3sN
CisJaWYgKFdBUk5fT05fT05DRShpc190ZF92Y3B1KHZjcHUpKSkNCisJCXJldHVybjsNCisNCisJ
dm14X3NldF9hcGljX2FjY2Vzc19wYWdlX2FkZHIodmNwdSk7DQorfQ0KDQpJZiB5b3UgZHJvcCB0
aGUgV0FSTl9PTl9PTkNFKCkgYWJvdmUsIHlvdSBjYW4ganVzdCBkcm9wIHRoaXMgcGF0Y2guDQoN
CkZvciB0aGlzIHBhcnRpY3VsYXIgY2FzZSwgSSBkb24ndCBmaW5kIGl0IGlzIHF1aXRlIG5lY2Vz
c2FyeSB0byBjaGFuZ2UgdGhlDQpjb21tb24geDg2IGNvZGUgYXMgZG9uZSBpbiB0aGlzIHBhdGNo
LiAgSW4gZmFjdCwgU1ZNIGRvZXNuJ3QgaGF2ZSBhDQpzZXRfYXBpY19hY2Nlc3NfcGFnZV9hZGRy
KCkgY2FsbGJhY2sgd2hpY2ggaXMgY29uc2lzdGVudCB3aXRoIGp1c3QgcmV0dXJuIGlmIFZNDQpp
cyBURCBpbiB2dF9zZXRfYXBpY19hY2Nlc3NfcGFnZV9hZGRyKCkuDQoNCkFsc28sIEkgZG9uJ3Qg
cGFydGljdWxhcmx5IGxpa2UgdGhlIGlkZWEgb2YgaGF2aW5nIGEgbG90IG9mICJpc190ZChrdm0p
IiBpbiB0aGUNCmNvbW1vbiB4ODYgY29kZSBhcyBpZiBzaW1pbGFyIHRlY2hub2xvZ3kgaGFwcGVu
cyBpbiB0aGUgZnV0dXJlLCB5b3Ugd2lsbCBuZWVkIHRvDQpoYXZlIGFub3RoZXIgImlzX3RkX3Np
bWlsYXJfdm0oa3ZtKSIgdGhpbmcuDQoNCklmIG1vZGlmeWluZyBjb21tb24geDg2IGNvZGUgaXMg
bmVjZXNzYXJ5LCB0aGVuIGl0IHdvdWxkIG1ha2UgbW9yZSBzZW5zZSB0bw0KaW50cm9kdWNlIHNv
bWUgY29tbW9uIGZsYWcsIGFuZCBtYWtlIFREIGd1ZXN0IHNldCB0aGF0IGZsYWcuDQoNCkJ0dywg
dGhpcyBwYXRjaCBqdXN0IGNvbWVzIG91dCBvZiBibHVlIGZyb20gdGhlICBtaWRkbGUgb2YgYSBi
dW5jaCBvZiBNTVUNCnBhdGNoZXMuICBTaG91bGRuJ3QgaXQgYmUgbW92ZWQgdG8gInBhdGNoZXMg
d2hpY2ggaGFuZGxlcyBpbnRlcnJ1cHQgcmVsYXRlZA0Kc3RhZmYiPw0KDQpCdHcyLCBieSBzYXlp
bmcgYWJvdmUsIGRvZXMgaXQgbWFrZSBzZW5zZSB0byBzcGxpdCBwYXRjaCAiW1BBVENIIHYxMCAx
MDUvMTA4XQ0KS1ZNOiBURFg6IEFkZCBtZXRob2RzIHRvIGlnbm9yZSBhY2Nlc3NlcyB0byBDUFUg
c3RhdGUiIGJhc2VkIG9uIGNhdGVnb3J5IHN1Y2ggYXMNCk1NVS9pbnRlcnJ1cHQsIGV0Yz8gIFBh
cnRpY3VsYXJseSwgaW4gdGhhdCBwYXRjaCwgc29tZSBjYWxsYmFja3MgaGF2ZSBXQVJOKCkgb3IN
CktWTV9CVUdfT04oKSBhZ2FpbnN0IFREIGd1ZXN0LCBidXQgc29tZSBkb24ndC4gIFRoZSBsb2dp
YyBiZWhpbmQgdGhvc2UgZGVjaXNpb25zDQpoaWdobHkgZGVwZW5kIG9uIHByZXZpb3VzIHBhdGNo
ZXMuICBUbyBtZSwgaXQgbWFrZXMgbW9yZSBzZW5zZSB0byBqdXN0IG1vdmUNCmxvZ2ljIHJlbGF0
ZWQgdGhpbmdzIHRvZ2V0aGVyLg0K
