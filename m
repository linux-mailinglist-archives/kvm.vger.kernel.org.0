Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D276CA092
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjC0Jy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjC0Jyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:54:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEC249EB;
        Mon, 27 Mar 2023 02:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679910892; x=1711446892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hBbqvXxAdUb+6d31bwYAo4Hf/9b/SubgjYOMPQHm/eI=;
  b=idLw++ex5bppFj8LGYPWfC7SR0AIQkyoNV+15R3uqmPDRcTzJqHedBVM
   UTNmzm2V0sUJa2rutpDtu/yGeCo3/KGNFuTa8qgJqRKednT8HPmP2fcwV
   jpp5aZ0i+cZH1OOVydgNDbThgkLHpspTWcYOqgxa6w/WsHr5BUeeIb9uJ
   O5wt/fnS2N1bWVZ+rxEKizG1U0rmTZpoU2UKe46oW+pzMp8vCigW4pGlR
   4IZtADHEglkduN2bsQdoX1IbgmIJmb0SJz5DXL4yWir+GuVJCf7n5eCjF
   Btl/vfogexaDxF/vpitO1z9/+HPLMeViqKOIW3xwckHUK8NgDItxGDPHF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="367969198"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="367969198"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:54:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="1013049231"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="1013049231"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 27 Mar 2023 02:54:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 02:54:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 02:54:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 02:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQNitW4vkDGNcViAmcrJWYKJKVuoPgN9RfWy6tqSD2MFtViM3zEPilnY9WwY8fwy5X3423RsLH1dDFRB5RnCPf9UKlBg02SOBnBboOVkqL7T6tcmINJNU3nLsHYgUsSb+Fxor6GzrQnptzTEmEIxOQBGX6XnMGSM7YAqVMub6CyXR5HzFW8M/9t+jvGHOrY8awIFFXbusdpviwEqXx9zAjm0l2gfqg4EUHIO8RyBnV87pCppbwICT9Feko9Lfpep21wfKE4IonDsQDMVlkcsK+scrMuF+zToc0ney91iDTPIdqViQ0i+Td0XGRjOla3Lp3a+0qPDICUG6PA5n+Ds1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBbqvXxAdUb+6d31bwYAo4Hf/9b/SubgjYOMPQHm/eI=;
 b=Lt9LKUR7FXwTCtHWFz4S8kaaq18p4lnZgjR1CJfrkKD9jSfWugK05c//Trr6Z+3IWIoRiaIz+NTGzXmiNDYQdofVYB6OnO53VUbRZJSC/ei1EDU1SGHGlk/a2+wwKC2o43KgEYheiFqA9pd3jXFkKOwRd5kTiQwi2eRSOiVj1mLsiFce4g+FdxodMgc1bZepJOWh7ohPACFi5xkLbFsHUkCwtmtUcvrakvKBBgXjYYz9YckkEaZ6+0Wwb31XTUe5Xio1OTwiU3dEyYLkaUbxhCHGI1pgp9Aoj1445Zr267JAWJc/DehI+uy2dWj7iT/mg4o3vtHKas4DzYMYhYG9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7661.namprd11.prod.outlook.com (2603:10b6:510:27b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 09:54:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Mon, 27 Mar 2023
 09:54:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Topic: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Index: AQHZVQw3kEskAU/Ee0qwjXZZkrxQv679PKiAgA2G2QCAA7atAA==
Date:   Mon, 27 Mar 2023 09:54:40 +0000
Message-ID: <a10d63840b02c4bbe1c027e5f230e4799f87ddda.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <cbfaedb652dad85f4020a2dcd74ac4abb5c14ac5.1678643052.git.isaku.yamahata@intel.com>
         <b3198a621a39d4c277ddf540e7a492953dc3637d.camel@intel.com>
         <20230325011200.GB214881@ls.amr.corp.intel.com>
In-Reply-To: <20230325011200.GB214881@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7661:EE_
x-ms-office365-filtering-correlation-id: e85359b4-6992-44a8-252a-08db2ea94883
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7vgXu/yjEapAizru/svsDe1361J50gcFPravRQ9Hp1Ro1HIv3XjZBHzrtM2uFA6F5syJ5pH1fK0Sdr72N9YUW7AK+MkHQ6sL6wiG8PTWfGbOi698uiWJVYgQ+Rn1yiDo9SxjL5iinIC7uwRQSKPZvmfqLlnATHhACnQ93yIdHhoq1XR+tozImjf5l/aiBWgtMUlnOkPAQb2RkrXGAblGL+XGzhbbXKtk8CgSFI+Ke+HelhWS9FF7SyDRMwVEIgbkL6D3EaZo1kJgiyp1l4m85jIEtI+lF2cTlTM8PD9xygBIqlT6ON3N2sOaDS5hEdL2QNRD4eg9qHMBmgWtB4TCkkvsntGGk6rfBqw1qz/8ddH1wcmHBjnd2EaK5isiNlV9UWYMjWknEbE5XbZ1pxvJZOS0dGdygddIWA29RowcDKIKohKuFwq89g+iqKsiBz5wemBKyHS/SUDqV+TNOoRpn315wuZdVDmcM4GtDF50VDbMnF1u+P72CaCtkdBAR+N20bTJ7j/5dZ1usJldbpXV3yUdw2+XnQCAiNih1ioZm21PTyNm/HOom2Zt55vLZ5pza1hzi9tC3abg8TfPNiRH6B8SNZRpny5T8NamgQ5fVgOPZbg+y2e13AIWlROnPu+p
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199021)(36756003)(86362001)(122000001)(38070700005)(6512007)(6506007)(26005)(83380400001)(2616005)(186003)(5660300002)(107886003)(8936002)(82960400001)(41300700001)(6486002)(71200400001)(6916009)(91956017)(76116006)(4326008)(54906003)(38100700002)(2906002)(66946007)(316002)(66556008)(8676002)(64756008)(66476007)(66446008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEVES0N4MGUxYVFMbm9jUGJZVEdiL3oyaytTa2dSWjRadFZjMkY2Umx2cFVK?=
 =?utf-8?B?Wk95dGs1MEJYR3B6aWNaaDdaWm5HSTlpWDA4TGg0MkRkbWRHUkZkcVpPSzV6?=
 =?utf-8?B?dURSNzQ4NXVObFNHVDFETk5QZzZsSVVtMHEramlSOHdXdXltZWo3b2xSRzVt?=
 =?utf-8?B?WitLd2E2VXVDQjBVOUZLWmFPWUp3RVRSeTgyNE1QVHZNcVhoRFoxanRDUHJS?=
 =?utf-8?B?QzhiZitYbWRGQ3hDNy92SWlBVVhKRkJGRXg5VXhVbVBlbjdRNkhMSENiMGht?=
 =?utf-8?B?cGNNb0RQZytocjFiMmVrdDZUMUxPKzZJUFlGcENITm8xY1hQL0lRVUxncTlI?=
 =?utf-8?B?WDNXSDhQS0VKK2tlWVlQTHFiendlbU9HK2hjRXJ0ZVF0V0ZtS240L3FrU3NO?=
 =?utf-8?B?ZzVZc0pBMUVFcDVpUmpnWks2L1phUjhWS3UzSEErelhmVnkxZE03TTJFYnRV?=
 =?utf-8?B?RUVJUU5JZXE4RERXZy9uTzdKWlBNY29NTmdSd2xMWG5xc09CakxoNWluenVX?=
 =?utf-8?B?anhVOVBsMnFCVk9MUlFqWDRQWW5iSXpLWTdkRlVYaFNWOTNhcHMvU3hKeFJm?=
 =?utf-8?B?bG1iYWNJVGhSVlNKT3RPcEtnUlRxTHZGQTgvZnBGbFZLQ2d0SzNQYzFpemU5?=
 =?utf-8?B?ci9VcTNCdENVRG9adTZTYmxoN2cwRnY2NUduKzBSQWdsTS9JazRwTDdWRStJ?=
 =?utf-8?B?WnByeXgwT2FMNHVMbm1wU2R4ckd3dmtYWHRsMWNUZU53bElJeSt2SlFjQTdW?=
 =?utf-8?B?QWhSUjNkQ3VvcXZjRGdzVlF3amNlc1RlbVovZnVPVWVyT0IvV3ZTdWExTVV1?=
 =?utf-8?B?VStUWFAvdXBsSUtrRnpDNm0vOVhHcXZ1ZGNmOHhNaW1GMWJzK0plaW41K0pm?=
 =?utf-8?B?citlSUxoZFJQMngzbXByMXNKUkNZclUzSlpVRW45NS90QjAzY0Q1ejBRL1lS?=
 =?utf-8?B?bGZlWUxHVU55aExjY2l0OXZUbVhxWUxiVjk4allIWmJYRitOTG52MU00Y3Jv?=
 =?utf-8?B?Y25YajhYNUFieUtBcjhQaVJ1UGtyeTFlQ2JtcVVmTUpoanVqYTVwRDBOY3hy?=
 =?utf-8?B?c3dRanJHbTFvWUo3TGpjV1h0THk2eDZJbTY0VEFXSFJUTlVEYjFrR2NxdWdu?=
 =?utf-8?B?UW9vRW9wSGlZSVlmQVF1SGFSVUE2RyswVGhaWGZHMHozdFY4YnR1ZElReUFq?=
 =?utf-8?B?VUtMUHNyVmtCMklUdEpDMEppOTdTbnptTFhnM1JpVWQwb2tDV2lWVUkrcHVx?=
 =?utf-8?B?cFM5ZitNaTFIQ21rQ1dGZmIzWWQ3bnNMRnZudkxIQWtxRjN5VXQvVFBFOXJS?=
 =?utf-8?B?U1A3cEVjeUYzNitGNUtJb2o4UGd2THdXanI3ZkFCZmVHUzNGaEpvWFN1NU1h?=
 =?utf-8?B?MHFNcnNPaG5PUWNhWXVoZklTK1I0RGJnRTZ2Qy84OU5TbDhjb2NJYTRxWnhv?=
 =?utf-8?B?cEZ5VGNJWTUrRTZBanVFLzFOWkZVQzFLWFNreW93cUpuamNHb2ZBdkczdTVu?=
 =?utf-8?B?U0JrYkJXNytQY1RybWVsbkpxYytEUUQ3V2MxYVl2aU1BeGNDR2Mza0Z4c1RK?=
 =?utf-8?B?S2VmdWtUR2wzamw4dmpiVHBuZGV6MUNaOGRXUUZXczJtcXN4MmtEbmtoNXJ0?=
 =?utf-8?B?Q29lLzBYMjdySG9rQjF1VDg2am5vQlFjVTkwdHBBYjdMR1ZMdHlNK2dRYmxh?=
 =?utf-8?B?Z3AyUjJLcjZ4dTZaLzJ6blJYSGo2ZEtPdlNkc2Q4ZURObGVwV3QvaGh3anhJ?=
 =?utf-8?B?cXhHb09vNStLZFczOTFqazdwaHlvakRMcndKWXNkNE5YblFKaldwSVFCSlp2?=
 =?utf-8?B?b3RURFRJN3gxUnk4cEFiTUQ4SUJCemM2OFF5R1JZR05DT2FrS2ovQ0ZFNmVw?=
 =?utf-8?B?bDVDc25WZjVxN3BlRVFxMzJzbWtraGVNd1JLRTVIVHdrWE5nbTY5RCs4eHhM?=
 =?utf-8?B?VG9LbE5POFlHOVAzS0M2MjB1eFIzekEwWGk3ekUzck1mckFDKzBIVGpwOW1y?=
 =?utf-8?B?SEhWZGlqOWxiekplcmJnU0ptRVlTSTQyMm8vKytFRWZNYytWd1gwM0xKdHZI?=
 =?utf-8?B?dWZDeGJwT2F6b3hhQUxmZndGUFNibWR1TkcxNithM3NRdGFvZjVuSUFUZ3Fo?=
 =?utf-8?Q?5T/T5ykgT6Iaz4Mk7wbr0UYRt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0E961C6E64F2D4D8E9262EA5DF7DF43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85359b4-6992-44a8-252a-08db2ea94883
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 09:54:40.3493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QacpCHV6fF1xJvCoD9ms2W+SMxaD0OHQYSfshA9p36uJate2XVHb6L+omejFo/NEXrEcYoeNAuuvZAtaoAFa6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7661
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTI0IGF0IDE4OjEyIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBNYXIgMTYsIDIwMjMgYXQgMTA6Mzg6MDJBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU3VuLCAyMDIzLTAz
LTEyIGF0IDEwOjU2IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3JvdGU6DQo+ID4g
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+ID4g
DQo+ID4gPiBCZWNhdXNlIFREWCB2aXJ0dWFsaXplIGNwdWlkWzB4MV0uRURYW01UUlI6IGJpdCAx
Ml0gdG8gZml4ZWQgMSwgZ3Vlc3QgVEQNCj4gPiA+IHRoaW5rcyBNVFJSIGlzIHN1cHBvcnRlZC4g
IEFsdGhvdWdoIFREWCBzdXBwb3J0cyBvbmx5IFdCIGZvciBwcml2YXRlIEdQQSwNCj4gPiA+IGl0
J3MgZGVzaXJhYmxlIHRvIHN1cHBvcnQgTVRSUiBmb3Igc2hhcmVkIEdQQS4gIEFzIGd1ZXN0IGFj
Y2VzcyB0byBNVFJSDQo+ID4gPiBNU1JzIGNhdXNlcyAjVkUgYW5kIEtWTS94ODYgdHJhY2tzIHRo
ZSB2YWx1ZXMgb2YgTVRSUiBNU1JzLCB0aGUgcmVtaW5pbmcNCj4gPiA+IHBhcnQgaXMgdG8gaW1w
bGVtZW50IGdldF9tdF9tYXNrIG1ldGhvZCBmb3IgVERYIGZvciBzaGFyZWQgR1BBLg0KPiA+ID4g
DQo+ID4gPiBQYXNzIGFyb3VuZCBzaGFyZWQgYml0IGZyb20ga3ZtIGZhdWx0IGhhbmRsZXIgdG8g
Z2V0X210X21hc2sgbWV0aG9kIHNvIHRoYXQNCj4gPiA+IGl0IGNhbiBkZXRlcm1pbmUgaWYgdGhl
IGdmbiBpcyBzaGFyZWQgb3IgcHJpdmF0ZS4gwqANCj4gPiA+IA0KPiA+IA0KPiA+IEkgdGhpbmsg
d2UgaGF2ZSBhbiBYYXJyYXkgdG8gcXVlcnkgd2hldGhlciBhIGdpdmVuIEdGTiBpcyBzaGFyZWQg
b3IgcHJpdmF0ZT8NCj4gPiBDYW4gd2UgdXNlIHRoYXQ/DQo+ID4gDQo+ID4gPiBJbXBsZW1lbnQg
Z2V0X210X21hc2soKQ0KPiA+ID4gZm9sbG93aW5nIHZteCBjYXNlIGZvciBzaGFyZWQgR1BBIGFu
ZCByZXR1cm4gV0IgZm9yIHByaXZhdGUgR1BBLg0KPiA+ID4gdGhlIGV4aXN0aW5nIHZteF9nZXRf
bXRfbWFzaygpIGNhbid0IGJlIGRpcmVjdGx5IHVzZWQgYXMgQ1BVIHN0YXRlKENSMC5DRCkNCj4g
PiA+IGlzIHByb3RlY3RlZC4gIEdGTiBwYXNzZWQgdG8ga3ZtX210cnJfY2hlY2tfZ2ZuX3Jhbmdl
X2NvbnNpc3RlbmN5KCkgc2hvdWxkDQo+ID4gPiBpbmNsdWRlIHNoYXJlZCBiaXQuDQo+ID4gPiAN
Cj4gPiA+IFN1Z2dlc3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+
IA0KPiA+IEkgYW0gbm90IHN1cmUgd2hhdCBpcyBzdWdnZXN0ZWQgYnkgbWU/DQo+ID4gDQo+ID4g
SSB0aG91Z2h0IHdoYXQgSSBzdWdnZXN0ZWQgaXMgd2Ugc2hvdWxkIGhhdmUgYSBkZWRpY2F0ZWQg
cGF0Y2ggdG8gaGFuZGxlIE1UUlINCj4gPiBmb3IgVERYIHB1dHRpbmcgYWxsIHJlbGF0ZWQgdGhp
bmdzIHRvZ2V0aGVyLg0KPiANCj4gU3VyZS4gQWZ0ZXIgbG9va2luZyBhdCB0aGUgc3BlY3MsIG15
IGNvbmNsdXNpb24gaXMgdGhhdCBndWVzdCBURCBjYW4ndCB1cGRhdGUNCj4gTVRSUiByZWxpYWJs
eS4gIEJlY2F1c2UgTVRSUiB1cGRhdGUgcmVxdWlyZXMgdG8gZGlzYWJsZSBjYWNoZShDUjAuQ1I9
MSksIGNhY2hlDQo+IGZsdXNoLCBhbmQgdGxiIGZsdXNoLiAoU0RNIDNhIDEyLjExLjc6IE1UUlIg
bWFpbnRlbmFuY2UgcHJvZ3JhbW1pbmcgaW50ZXJmYWNlKQ0KPiBMaW51eCBpbXBsZW1lbnRzIE1U
UlIgdXBkYXRlIGxvZ2ljIGFjY29yZGluZyB0byBpdC4NCj4gDQo+IFdoaWxlIFREWCBlbmZvcmNl
cyBDUjAuQ0Q9MCwgdHJ5aW5nIHRvIHNldCBDUjAuQ0Q9MSByZXN1bHRzIGluICNHUC4gIEF0IHRo
ZQ0KPiBzYW1lIHRpbWUsIGl0IHJlcG9ydHMgdGhhdCBNVFJSIGlzIGF2YWlsYWJsZSB2aWEgY3B1
aWQuICBTbyBJIGNvbWUgdXAgd2l0aCB0aGUNCj4gZm9sbG93aW5ncy4NCj4gDQo+IC0gTVRSUkNh
cChSTyk6IHJlcG9ydCBubyBmZWF0dXJlIGF2YWlsYWJsZQ0KPiAgIFNNUlI9MDogU01SUiBpbnRl
cmZhY2UgdW5zdXBwb3J0ZWQNCj4gICBXQz0wOiB3cml0ZSBjb21iaW5pbmcgdW5zdXBwb3J0ZWQN
Cj4gICBGSVg9MDogRml4ZWQgcmFuZ2UgcmVnaXN0ZXJzIHVuc3VwcG9ydGVkDQo+ICAgVkNOVD0w
OiBudW1iZXIgb2YgdmFyaWFibGUgcmFuZ2UgcmVnaXRzZXJzID0gMA0KPiANCj4gLSBNVFJSRGVm
VHlwZShSL1cpOiBPbmx5IHdyaXRlYmFjayBldmVuIHdpdGggcmVzZXQgc3RhdGUuDQo+ICAgRT0x
OiBlbmFibGUgTVRSUiAoRT0wIG1lYW5zIGFsbCBtZW1vcnkgaXMgVUMuKQ0KPiAgIEZFPTA6IGRp
c2FibGUgZml4ZWQgcmFuZ2UgTVRSUnMNCj4gICB0eXBlOiBkZWZhdWx0IG1lbW9yeSB0eXBlPXdy
aXRlYmFjaw0KPiAgIEFjY2VwdCB3cml0ZSB0aGlzIHZhbHVlLiBPdGhlciB2YWx1ZSByZXN1bHRz
IGluICNHUC4NCj4gDQo+IC0gRml4ZWQgcmFuZ2UgTVRSUg0KPiAgICNHUCBhcyBmaXhlZCByYW5n
ZSBNVFJScyBpcyByZXBvcnRlZCBhcyB1bnN1cHBvcnRlZA0KPiANCj4gLSBWYXJpYWJsZSByYW5n
ZSBNVFJScw0KPiAgICNHUCBhcyB0aGUgbnVtYmVyIG9mIHZhcmlhYmxlIHJhbmdlIE1UUlJzIGlz
IHJlcG9ydGVkIGFzIHplcm8NCg0KTG9va3Mgc2FuZSB0byBtZS4NCg0KPiAgDQo+IA0KPiA+ID4g
K3U4IHRkeF9nZXRfbXRfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdmbl90IGdmbiwgYm9v
bCBpc19tbWlvKQ0KPiA+ID4gK3sNCj4gPiA+ICsJLyogVERYIHByaXZhdGUgR1BBIGlzIGFsd2F5
cyBXQi4gKi8NCj4gPiA+ICsJaWYgKCEoZ2ZuICYga3ZtX2dmbl9zaGFyZWRfbWFzayh2Y3B1LT5r
dm0pKSkgew0KPiA+ID4gKwkJLyogTU1JTyBpcyBvbmx5IGZvciBzaGFyZWQgR1BBLiAqLw0KPiA+
ID4gKwkJV0FSTl9PTl9PTkNFKGlzX21taW8pOw0KPiA+ID4gKwkJcmV0dXJuICBNVFJSX1RZUEVf
V1JCQUNLIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+
ID4gKwkvKiBEcm9wIHNoYXJlZCBiaXQgYXMgTVRSUiBkb2Vzbid0IGtub3cgYWJvdXQgc2hhcmVk
IGJpdC4gKi8NCj4gPiA+ICsJZ2ZuID0ga3ZtX2dmbl90b19wcml2YXRlKHZjcHUtPmt2bSwgZ2Zu
KTsNCj4gPiA+ICsNCj4gPiA+ICsJLyogQXMgVERYIGVuZm9yY2VzIENSMC5DRCB0byAwLCBwYXNz
IGNoZWNrX2NyMF9jZCA9IGZhbHNlLiAqLw0KPiA+ID4gKwlyZXR1cm4gX192bXhfZ2V0X210X21h
c2sodmNwdSwgZ2ZuLCBpc19tbWlvLCBmYWxzZSk7DQo+ID4gPiArfQ0KPiA+IA0KPiA+IA0KPiA+
IERvIHlvdSBrbm93IHdoZXRoZXIgdGhlcmUncyBhbnkgdXNlIGNhc2Ugb2Ygbm9uLWNvaGVyZW50
IGRldmljZSBhc3NpZ25tZW50IHRvDQo+ID4gVERYIGd1ZXN0Pw0KPiA+IA0KPiA+IElNSE8sIHdl
IHNob3VsZCBqdXN0IGRpc2FsbG93IFREWCBndWVzdCB0byBzdXBwb3J0IG5vbi1jb2hlcmVudCBk
ZXZpY2UNCj4gPiBhc3NpZ25tZW50LCBzbyB0aGF0IHdlIGNhbiBqdXN0IHJldHVybiBXQiBmb3Ig
Ym90aCBwcml2YXRlIGFuZCBzaGFyZWQuDQo+ID4gDQo+ID4gSWYgd2Ugc3VwcG9ydCBub24tY29o
ZXJlbnQgZGV2aWNlIGFzc2lnbm1lbnQsIHRoZW4gaWYgZ3Vlc3Qgc2V0cyBwcml2YXRlIG1lbW9y
eQ0KPiA+IHRvIG5vbi1XQiBtZW1vcnksIGl0IGJlbGlldmVzIHRoZSBtZW1vcnkgdHlwZSBpcyBu
b24tV0IsIGJ1dCBpbiBmYWN0IFREWCBhbHdheXMNCj4gPiBtYXAgcHJpdmF0ZSBtZW1vcnkgYXMg
V0IuDQo+ID4gDQo+ID4gV2lsbCB0aGlzIGJlIGEgcHJvYmxlbSwgaS5lLiBpZiBhc3NpZ25lZCBk
ZXZpY2UgY2FuIERNQSB0byBwcml2YXRlIG1lbW9yeQ0KPiA+IGRpcmVjdGx5IGluIHRoZSBmdXR1
cmU/DQo+IA0KPiBNVFJSIGlzIGxlZ2FjeSBmZWF0dXJlIGFuZCBQQVQgcmVwbGFjZWQgaXQuICBX
ZSBjYW4gcmVseSBvbiBndWVzdCB0byB1c2UgUEFULg0KPiBIZXJlIGlzIHRoZSBuZXcgcGF0Y2gg
Zm9yIE1UUlIuDQo+IA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiArKysgYi9h
cmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBAQCAtMjI5LDYgKzIyOSwxNCBAQCBzdGF0aWMgdm9p
ZCB2dF9sb2FkX21tdV9wZ2Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBocGFfdCByb290X2hwYSwN
Cj4gIAl2bXhfbG9hZF9tbXVfcGdkKHZjcHUsIHJvb3RfaHBhLCBwZ2RfbGV2ZWwpOw0KPiAgfQ0K
PiAgDQo+ICtzdGF0aWMgdTggdnRfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBn
Zm5fdCBnZm4sIGJvb2wgaXNfbW1pbykNCj4gK3sNCj4gKwlpZiAoaXNfdGRfdmNwdSh2Y3B1KSkN
Cj4gKwkJcmV0dXJuIHRkeF9nZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiArDQo+
ICsJcmV0dXJuIHZteF9nZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiArfQ0KPiAr
DQo+ICBzdGF0aWMgaW50IHZ0X21lbV9lbmNfaW9jdGwoc3RydWN0IGt2bSAqa3ZtLCB2b2lkIF9f
dXNlciAqYXJncCkNCj4gIHsNCj4gIAlpZiAoIWlzX3RkKGt2bSkpDQo+IEBAIC0zNDksNyArMzU3
LDcgQEAgc3RydWN0IGt2bV94ODZfb3BzIHZ0X3g4Nl9vcHMgX19pbml0ZGF0YSA9IHsNCj4gIA0K
PiAgCS5zZXRfdHNzX2FkZHIgPSB2bXhfc2V0X3Rzc19hZGRyLA0KPiAgCS5zZXRfaWRlbnRpdHlf
bWFwX2FkZHIgPSB2bXhfc2V0X2lkZW50aXR5X21hcF9hZGRyLA0KPiAtCS5nZXRfbXRfbWFzayA9
IHZteF9nZXRfbXRfbWFzaywNCj4gKwkuZ2V0X210X21hc2sgPSB2dF9nZXRfbXRfbWFzaywNCj4g
IA0KPiAgCS5nZXRfZXhpdF9pbmZvID0gdm14X2dldF9leGl0X2luZm8sDQo+ICANCj4gZGlmZiAt
dSBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IC0t
LSBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHgu
Yw0KPiBAQCAtMzQ3LDYgKzM0NywyNSBAQA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICt1
OCB0ZHhfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBnZm5fdCBnZm4sIGJvb2wg
aXNfbW1pbykNCj4gK3sNCj4gKwkvKiBURFggcHJpdmF0ZSBHUEEgaXMgYWx3YXlzIFdCLiAqLw0K
PiArCWlmICghKGdmbiAmIGt2bV9nZm5fc2hhcmVkX21hc2sodmNwdS0+a3ZtKSkpIHsNCg0KQXJl
IHlvdSBzdGlsbCBwYXNzaW5nIGEgInJhdyIgR0ZOPyAgQ291bGQgeW91IGV4cGxhaW4gd2h5IHlv
dSBjaG9vc2UgdGhpcyB3YXk/DQoNCj4gKwkJLyogTU1JTyBpcyBvbmx5IGZvciBzaGFyZWQgR1BB
LiAqLw0KPiArCQlXQVJOX09OX09OQ0UoaXNfbW1pbyk7DQo+ICsJCXJldHVybiAgTVRSUl9UWVBF
X1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQoNCkkgZ3Vlc3MgaXQncyBiZXR0ZXIg
dG8gaW5jbHVkZSBWTVhfRVBUX0lQQVRfQklUIGJpdC4NCg0KPiArCX0NCj4gKw0KPiArCWlmIChp
c19tbWlvKQ0KPiArCQlyZXR1cm4gTVRSUl9UWVBFX1VOQ0FDSEFCTEUgPDwgVk1YX0VQVF9NVF9F
UFRFX1NISUZUOw0KPiArDQo+ICsJaWYgKCFrdm1fYXJjaF9oYXNfbm9uY29oZXJlbnRfZG1hKHZj
cHUtPmt2bSkpDQo+ICsJCXJldHVybiAoTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQ
VEVfU0hJRlQpIHwgVk1YX0VQVF9JUEFUX0JJVDsNCj4gKw0KPiArCS8qIFREWCBlbmZvcmNlcyBD
UjAuQ0QgPSAwIGFuZCBLVk0gTVRSUiBlbXVsYXRpb24gZW5mb3JjZXMgd3JpdGViYWNrLiAqLw0K
PiArCXJldHVybiBNVFJSX1RZUEVfV1JCQUNLIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4g
K30NCj4gKw0K
