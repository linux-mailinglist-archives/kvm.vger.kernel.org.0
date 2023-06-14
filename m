Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D636B72FBC6
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbjFNK6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 06:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjFNK6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 06:58:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A719BC;
        Wed, 14 Jun 2023 03:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686740300; x=1718276300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vg3CaN/FkZHI/09hPV4OOb7B4FJbeXR/IPQEOvkcmiE=;
  b=IGotf4fDfaLizGWSJNHAj2emI/k9CIZCFRE9LBN/MJ4fV2ybBbqqlWLf
   8VPtJhSOyZ1E5VQdDsanpMVjVtLrCXXSIGMm0WH5Ch4hFFUJu8DMm69J+
   ngCRXjGYi9Qyk3gtIRLD09CEMC6HNo3UE2jlwcfHlVS/ZOOKgOtTLiijh
   EH1a7S8AymxZJASQNcXQ0ONgDVnnojXw9VxbneE4iX7udXeQT+695mwHy
   zersOO2bVNKBKuQJO0kdSJJJOdqajLGzFzQZq2rMGrLW9Cu3NM5/ZxxAa
   5vn20gB4iyinebMmOnENht02Bhh0hRuitLrt72tkXIcRyKAVnVs+LgeA0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="422183488"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="422183488"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 03:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="836236566"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="836236566"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 14 Jun 2023 03:58:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 03:58:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 03:58:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 03:58:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO2JqPhfwFS+lBP7nNGq5BF4xd56l+EZWGjWuCebssEQqbNR2YNTY6DlCTvZGJs2RTlXXpiHMlI4r5a2G8xB1ZcJHPB9xr3l7r8S36agvTyqMmBMg9zQT21jn+RgNglf39tbV5WHYVGSF7gg97SSVCNMoE1b97Xs4xDRzR6pYadNIpxyNUdDd4ISIncNtnLyCY/u2qVyDdzKEJYnv+c6L53mvARjq8YUiUOLA5hlK5+NoOpsMIBizT94fLh7VsUH5oosp9Bs3fNWG2NrTNuBGfvVQWLB/JuhxPqY6/sGos/NkJvGd04NPWzdw2aHpWkCmLlN15JVkHAiN5DVHk+mAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vg3CaN/FkZHI/09hPV4OOb7B4FJbeXR/IPQEOvkcmiE=;
 b=nkuxURGM952zFLc/Cb4VDDibNGmdkI4zPnp68hykz5n+p9aDBEBG9jKRkpvF2/R4sQ7iyQOqTOaDTQmJLO1+WTsM4JdVkVquoGkgUuj9GSwc0nTdjg36J1QvCWJbymdHMwGCocC4/9T9mBkICGaRwK9BiUnHhocPWZG7jBySjlSNql0PbevOI5Fjq2g5cQGkGdh6Eg2rG2tymCflT9RwVkWMa5N4eAXCYswuh8APW2hbCU6q68QUvYE52GpARFYNArerjTv8HR2i+T60/gsjSm8IJTyzr7R71KHo2TFZaPGsY8X6W+jcvxBhUngMbHm3BlaNSXS51dlNmMKctqO9CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Wed, 14 Jun
 2023 10:58:13 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 10:58:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+KGL6AgAAIHYCAAA98AA==
Date:   Wed, 14 Jun 2023 10:58:13 +0000
Message-ID: <84dcc5ff896f487c95dc1602b627abef8d48432f.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
         <20230614100245.3vehux365zou3ze6@box>
In-Reply-To: <20230614100245.3vehux365zou3ze6@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CY5PR11MB6259:EE_
x-ms-office365-filtering-correlation-id: f47cbf73-fc93-4350-6ed7-08db6cc63fdc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zw/PeyydAewuOSlDmRFnzS+pyC2m7LdOqo3wLT/OlE8VUIUkyppbdRCCvtYjpIn9EtrVJJn5Wnm1unEA+GldrYGgcs8leEFb3zjg4CIG+VcjpBaGh7Im8/ENxgtb6OzULI/zqKvF+KKmfc6mBL0Ol3MgaDWSxOAt6em9tj51pGCMMCVQ3YTwkyT3GB3MzDQrCtLP0cZ4dnkNUiIKJtVDYxAwfFBxu94b8zFx4uUbpLdgLlntqcXqhJkqvAnpnTcabl9x66eRzEvqSX5ogK8pkku8Q/kzXMFdadBLI7jonfKdL8OsXwWcJPmKEfmanbdDFWsCrNO28DPLYZu/yzoFoUed3+OqXkglt2CBFFPyySnHtidoFn8mGpmG6Ee4RI5cBfZgVpgaZo2y1a1U/+AhMcBqGa+hKhvxMrWJfXqdUBNvFvB2pJjV4AqV+4M5bEwVJQXn76Ej5L4CupvKSdKEyxDhs/7G8c/RsMsCe2zBBFpm0L2pv05IuJ2k36Pp4Z1EPHc3JP2Nx8Tvh2SvyeKUItLulqEq0fYckUI0lv85slNK97IQD55tfJgVeIhVEAzniIWtCOUVd1xlFk0Ycb21sauzFtxFZaveI4bsDrJMn1NQz50R6bmoevvACX5pR3y+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(2616005)(86362001)(66946007)(41300700001)(66556008)(71200400001)(64756008)(66476007)(91956017)(36756003)(4326008)(478600001)(316002)(66446008)(6916009)(54906003)(38070700005)(186003)(76116006)(6512007)(26005)(6506007)(83380400001)(7416002)(8936002)(2906002)(8676002)(5660300002)(6486002)(122000001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3g3VDdpTHBQdzF1UEtaTWw1SmhaVDcxRzNCYk9zT1ZYSEJJZm1ZLzV2cDhh?=
 =?utf-8?B?WFJ2aG1sVmNrWFdHYmJCSEtQUXl6TDJIQ0lJVkFMdUJZUmtWMGVJSGR6MnU0?=
 =?utf-8?B?VC81a3hqQWVrRmFXUTB4OTFvM0dFRWtFenBZbjFDSXl4L2ZjbVNMU2NqYVk1?=
 =?utf-8?B?OEN6dGNNTVh4MmxxaFBERWdwOWxpZzB4RjZaTWt3WlNxM2JhRFpsL3NGNHln?=
 =?utf-8?B?M2J3YkZVd2dybW1FcmthSlI2ZTN6ZC84MlZrSzZ6NDZnRElCVDRVWDdBTXU5?=
 =?utf-8?B?eUhDMzUvMkM0SUpMLzFQVXJybUFGZmx3NXNHMThDMlh6MkJHNFVvODJObzBP?=
 =?utf-8?B?K1ZCeW9jaEFKdkhCYi85L1QwcFluMmJibVV1VVNuNWtTd0YxRHl6WEcrNXVP?=
 =?utf-8?B?OVR0ajBPZERwTEc3TTZiSmZlaGZ4d2NKaTVSTU1uYnF6YWNGd1NaVFY0TmZs?=
 =?utf-8?B?Q3U1SWs2SGoyTEJzcFhPbGIvYmwxR3dvK1RFU096ZTJIb1ludWhUOFNmcUxv?=
 =?utf-8?B?SFRNK2RWdTljaWR4L3c2MDh3UFZSQThka2M5QUhRQ0R2VkMwbnBPak1hTTlE?=
 =?utf-8?B?TW13anBkY2VsZDBGTXQ4WVk0SjZaRlVDR3FQeU1leTI3Vy9qNjFHVG1nRjNR?=
 =?utf-8?B?aDFUNjVITC9iRGsvK2w5M0JrZGVabXV0MWpDQ1Rsb0Z2c1pXTytSWTV3NEtL?=
 =?utf-8?B?S21LNXppRDIwc1JsNnY4ZFhMWGxDUzErYkV6UmhjYUlYQ1YwSm4weHdCZGp6?=
 =?utf-8?B?cE9qaVlNVXh3eXdhNkFYODJDNHl5eEwzV2lFL2lLUitNODlyZEpyeUdKSWZB?=
 =?utf-8?B?OWFhOFhZSU42MEJFQzlBSHM0aWxRL3JTd0hFb1NxeWRQWFpNQWFYV2QrUzlV?=
 =?utf-8?B?RG5DWCs5blB6VlpUWnhHMjJPR1kweU8xb3ViVE82UU9SMzM1N0V5S1E0UWMv?=
 =?utf-8?B?c0MzMWVjeUNvZ3o2Nzg5dWhKLzB1VDMzNW5DVFl2TGhHakdhMC81VjdkNXRw?=
 =?utf-8?B?aXFsR01pdkxFSU5JOXY3ZG9WY2pDZTNQZ3VPeU1TTGwzSXErVldPVHBTWWtt?=
 =?utf-8?B?MlNxRnpFZm9YSkZnYXZvY1ZQM2R0OXMvQWhucHRCeTU5TW9xNUk2NGZYVHVS?=
 =?utf-8?B?ejZZLzY5N1FwVStyVllMaHF6Yjc1NlpFRHpyU0JTdTF0aHZVbGo2RWxETVI5?=
 =?utf-8?B?Tk55ZjhrVVl4ZTBLbVVkVTE1NG9XMXV4WGlHVCtoRGJKVnJ0RHFKcGtLeWtJ?=
 =?utf-8?B?MVZ6SHlZbnIxRjdXdUJoQkEraUJnRytqVG9lT29nRlFaYit2MGFsRHRYT2Nk?=
 =?utf-8?B?VXlDYmRBWkVWVG1CaE1kQUErcW01cFRZR0ZXM3VGbDR3SW5IaUM5K2RZR1hk?=
 =?utf-8?B?TmFvWGFTSG9nQ3p1NER3NWMzV2RUSWZad2FmN2REOW1BU2R5V3liRjJmVUlW?=
 =?utf-8?B?WE5Nd3R5WWg4SkNNcENURDVNVVF6eEkydjJKcjg4VGNZa3J0QzhTQ3ROSkUx?=
 =?utf-8?B?eFVXNXdyNFB3TlpZMmtna1k5dHBDMEN0K2E4SzNWYlh4OFBBTlNlRFFhTWJp?=
 =?utf-8?B?a3hoaGpGbWkxbTM3a3BrbE84dzA3RkNSRmk3TU14Y3d0SzdIQXZHbXB6SFlt?=
 =?utf-8?B?L0RlQUJPL3dtb1MwQUZqOTZuVHNQRmFUbTQycGVueDIwdGMzakFXTjN2NHgy?=
 =?utf-8?B?MmFWOGdPc0lkQXJKTjZlWE9MWmN2Q2M1aXJTUU80QW05S1ZHWG9ieWdBbk41?=
 =?utf-8?B?U3hNV2RjcDA1NEJTT1BhMUdNMUJoYTlmUVFQTWlLSUdEVUV2TjV6VW9uOHgz?=
 =?utf-8?B?c2RqN3Z0M0lqL2VnaitIOGF4RDJrbWpVMW93V3JyYlVjbXMyczNjMjlnNDZ2?=
 =?utf-8?B?YUF1MmtOSUcva1pkYmx2YjZGcHF1NkVIN05EV3ZUc2ZuWXFSR24wL2djU3ZD?=
 =?utf-8?B?bWU1RVMxTmxZRTVHR0t1dG9IUkRVL2YyajhCUEw1RmpIWEZGaE8xY09sTERP?=
 =?utf-8?B?MmFJL2FCYU9Xd1Y1Q1JlQXZDTGMzbEhoaXd5UVdsYVhWUlBjYjFIWDQrUTVy?=
 =?utf-8?B?L01YVXdnWlVsNVEvRGZIQm5YNXRRekFjbGZrNnV4bWYzY0hrMFFRQXViYWt0?=
 =?utf-8?Q?6reTBVaHWVB/qqn2uXchD90bS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC7894B2A5361347B6FB2304CDD2E7D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47cbf73-fc93-4350-6ed7-08db6cc63fdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 10:58:13.3638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9E8mh7GWUCksipaYto1GpJu6yF49OjY2rkZ6RuFGPFPOn09gomn8MBqec1eBG7McJ0rDOlntpa9Z4BQq6sNHBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTE0IGF0IDEzOjAyICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBXZWQsIEp1biAxNCwgMjAyMyBhdCAwOTozMzo0NUFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNi0wNSBhdCAwMjoyNyAr
MTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL3JlYm9v
dC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCj4gPiA+IEBAIC03MjAs
NiArNzIwLDcgQEAgdm9pZCBuYXRpdmVfbWFjaGluZV9zaHV0ZG93bih2b2lkKQ0KPiA+ID4gwqAN
Cj4gPiA+IMKgI2lmZGVmIENPTkZJR19YODZfNjQNCj4gPiA+IMKgCXg4Nl9wbGF0Zm9ybS5pb21t
dV9zaHV0ZG93bigpOw0KPiA+ID4gKwl4ODZfcGxhdGZvcm0ubWVtb3J5X3NodXRkb3duKCk7DQo+
ID4gPiDCoCNlbmRpZg0KPiA+ID4gwqB9DQo+ID4gDQo+ID4gSGkgS2lyaWxsL0RhdmUsDQo+ID4g
DQo+ID4gSSBtaXNzZWQgdGhhdCB0aGlzIHNvbHV0aW9uIGRvZXNuJ3QgcmVzZXQgVERYIHByaXZh
dGUgZm9yIGVtZXJnZW5jeSByZXN0YXJ0IG9yDQo+ID4gd2hlbiByZWJvb3RfZm9yY2UgaXMgc2V0
LCBiZWNhdXNlIG1hY2hpbmVfc2h1dGRvd24oKSBpc24ndCBjYWxsZWQgZm9yIHRoZW0uDQo+ID4g
DQo+ID4gSXMgaXQgYWNjZXB0YWJsZT8gIE9yIHNob3VsZCB3ZSBoYW5kbGUgdGhlbSB0b28/DQo+
IA0KPiBGb3JjZSByZWJvb3QgaXMgbm90IHVzZWQgaW4ga2V4ZWMgcGF0aCwgcmlnaHQ/wqANCj4g
DQoNCkNvcnJlY3QuDQoNCj4gQW5kIHRoZSBwbGF0Zm9ybSBoYXMgdG8NCj4gaGFuZGxlIGVycmF0
dW0gaW4gQklPUyB0byByZXNldCBtZW1vcnkgc3RhdHVzIG9uIHJlYm9vdCBhbnl3YXkuDQoNClNv
ICJoYW5kbGUgZXJyYXR1bSBpbiBCSU9TIiBJIHRoaW5rIHlvdSBtZWFuICJ3YXJtIHJlc2V0IiBk
b2Vzbid0IHJlc2V0IFREWA0KcHJpdmF0ZSBwYWdlcywgYW5kIHRoZSBCSU9TIG5lZWRzIHRvIGRp
c2FibGUgIndhcm0gcmVzZXQiLg0KDQpJSVVDIHRoaXMgbWVhbnMgdGhlIGtlcm5lbCBuZWVkcyB0
byBkZXBlbmQgb24gc3BlY2lmaWMgQklPUyBzZXR0aW5nIHRvIHdvcmsNCm5vcm1hbGx5LCBhbmQg
SUlVQyB0aGUga2VybmVsIGV2ZW4gY2Fubm90IGJlIGF3YXJlIG9mIHRoaXMgc2V0dGluZz8NCg0K
U2hvdWxkIHRoZSBrZXJuZWwganVzdCByZXNldCBhbGwgVERYIHByaXZhdGUgcGFnZXMgd2hlbiBl
cnJhdHVtIGlzIHByZXNlbnQNCmR1cmluZyByZWJvb3Qgc28gdGhlIGtlcm5lbCBkb2Vzbid0IGRl
cGVuZCBvbiBCSU9TPw0KDQo+IA0KPiBJIHRoaW5rIHdlIHNob3VsZCBiZSBmaW5lLiBCdXQgaXQg
d29ydGggbWVudGlvbmluZyBpdCBpbiB0aGUgY29tbWl0DQo+IG1lc3NhZ2UuDQo+IA0KDQpBZ3Jl
ZWQuDQo=
