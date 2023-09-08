Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F3798586
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 12:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjIHKQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 06:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjIHKQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 06:16:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9E51BC8;
        Fri,  8 Sep 2023 03:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694168187; x=1725704187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nUaIcj3lvYTQucIrqThQVxDviiaczUONlHws025NX/8=;
  b=kVUCtfk3ni4PisQhcB1YenypF4FmeL1bqPtlVBbdYouJlssDWO6h8g7q
   66aVqWypCHrRiXS5QgG7Z9mTzYrkITM7O6KMyDazjlFBee+gC6x6aXOGw
   eAQrs+gobuISlXAoKtlLb6pmqx30nWojWu/F0hVRnvqi4xXrnbPZgl46z
   CGocInRt9BimPYcsK2Oeb7KX3m8yHPNl6UDID4gyep+7ERM0L6EgJGk8b
   vcMSHV3BvJ0Ysto7vN7saeNa4xfaiQzO39kNcv2dGT1thKui58dDgkVna
   RHkLeTrvBYh2tuPp4xCbNkJzsr/W/ZPhqwDVrRa6RaeapyeI4C5B59UB/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="362678059"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="362678059"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 03:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="885618453"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="885618453"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2023 03:16:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 8 Sep 2023 03:16:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 8 Sep 2023 03:16:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 8 Sep 2023 03:16:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2Qgu92LTc0S250bctfoYFVhIG27hQmboXlT8HXJy+UvYwVH3PJkt5T7KBgas+AHHqxNpItQUHyg72SvbA9q6+S8q28vUEdF2FLWwD8BA7azFLfck/MTA/PTbnLfsyj9N+obM91uCEWja4DzfM7Eeb9SgbdqYPQrAVDLBX3v4mdXKMkzoAWHH71BnMx8+FaFg604IVd0zjtNnDug9HFwnCkTh/KnXc2QYKyIBbekyyzFLx+p67WZ+QFLbBZljHIT8YoZoxVukbk3X65+nwwvxfQYF8wLxehxeEy16zykfydWB7+cTMNR39NVIwyilH44eVyxSbuCllrWiFuBpn+iBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUaIcj3lvYTQucIrqThQVxDviiaczUONlHws025NX/8=;
 b=oHK0h/Hy1e1IHTbpuVeW+dP67/Hbh22swOr6mHVl63MbzO9BWs27D6+rcSLo1qe7n8pB9/xNSKsdX+6XcbTR+7jqVwDofFF9wZ0vE9jpegAQv9Cwhmjeovfcbk0wjoSTAzohLJEvvLj4/LcyhPWWWmDjU+8CwiPmNqNgec1mgM+0nwDaMJDqiPbQDoqGRZiPC5MfaojepPcPgcuZkIoMmXdlJyodraOC20MBHarXtrU3NMZ5AMqnT/plhhB9zOLQyKLtm+R3+omjmF/hV+aMIZzYgMRU4cJdYfAiPWqOGERNvZn0yjUXaOY2d2n07tZYEXeMQOOFYCEzhIKMnqjQYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Fri, 8 Sep
 2023 10:16:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Fri, 8 Sep 2023
 10:16:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v13 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZ101FCZAjJYGgZEuzliQLboJOorAPfeoAgAFOf4A=
Date:   Fri, 8 Sep 2023 10:16:22 +0000
Message-ID: <28b9c9cae8a408cece4f00d75deea5aa85a88ecf.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <7d20dd51dac16bf32340d4037ac761d36f0667f8.1692962263.git.kai.huang@intel.com>
         <4a135404-4661-fa80-a3e7-fb131cdf2e6c@suse.com>
In-Reply-To: <4a135404-4661-fa80-a3e7-fb131cdf2e6c@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6269:EE_
x-ms-office365-filtering-correlation-id: fdcbe78e-7a1e-44b5-cb70-08dbb054a6c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aFJtqQ7EAQe16jouzafEKrqVQ837PajMZZjrp5SlxvWuBabeWevDV1Yqg3Uu7zfZEbv6eathp7So9PpuYsSPXXrr7wfhpJEl76dbqAS0t9GanAu0s0TSoYwt/t991iH1mXZgLGzJHm6darATz5VKqU1IfivLpfjIni2dQGPEqt5GXZcRcvmI8AgxbdSdjV9ZAAhJfBCqoTRVaR3WvXEubkENBl5b1+Me5FebmFJMCGSmVs3itaQIaX3wH5u6iUYIoDBMhRvuzIj63wEsYhZNco7QdMAA6VPdrxIDJIhdQhyvXu6Wvi4ex9MN46b6vgZXiCSNDoAbohg4AnhM/ChNJvWWADGpk+8jHvW8yVAlJKdnOHQzjbBD1cEsuCKPYKC8A4zzdKKJNf1NRoYeKqQ3xyKaCOPcjbkwJFikO0G/EKBnTusPtSFzVXfsmqERK/uzghnmTupjd6MuXvqE5DuF15YO00er0uizp4il1yxy9WC1SdUMiNCpEXSZI/CvkeG7DpnA82Mf+b62pN0V6tGbCImRrSN9cPr+4mpYC6wA4UAHyt/7MScPH51vN3ZIyZJKX9iOM7WqyMBN/eqiDEYusMA6P20S102hxGkqGINoawqfuk1apPRy2/ORrqxayGlo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199024)(1800799009)(186009)(6486002)(6506007)(71200400001)(6512007)(478600001)(83380400001)(26005)(2616005)(4744005)(2906002)(66476007)(54906003)(7416002)(110136005)(64756008)(316002)(66446008)(66556008)(66946007)(76116006)(91956017)(8676002)(4326008)(5660300002)(8936002)(41300700001)(82960400001)(86362001)(36756003)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlhlTHZyS0FaRTZSWGtOaXVKR0hKeUxFQlg0ZGhqd3NkMGJJUGhuM29PT2pK?=
 =?utf-8?B?OUtpRWxiZ09JTlNFeE1KYXAxcGNoeEZUVjVCWndmcE9ESjM1Y2JqTUxhUWVV?=
 =?utf-8?B?RXFFeUtGSDgxYWFjQVM4Ym1pWklpUU5wZmU0VEF5UTUwT1lzQlpFNmFkNjJY?=
 =?utf-8?B?aTEzc3Y2MG1EQ1FhcjhQTU5pb280S2FxOTFjSzVnWmpCcTVQMkduYXMwbEVn?=
 =?utf-8?B?RnU3cHdZY2ZpVHpCKzAxM2dxYkllNy95MGJGeFVIWlJ3d2h6QmdpN0ZPdStW?=
 =?utf-8?B?THlhNS93a2dnUk9iTmttOGJEdEhQWjVFNUM2cXd2YkdEdzJmV1VObVpiUDY0?=
 =?utf-8?B?clF6KzErY2RFa3hXSnJSWStYQURjczc0ektjL0JzUXZ5aW0xck1kSStaL0c2?=
 =?utf-8?B?eS9RdldoSVE2dnNsSTNYM2crbVZhNEZSaXE0MlBmNFdHeXl3TEZuUWM5bElR?=
 =?utf-8?B?eWxXd1p3aUVjSGhmOWcwdkRlOVNlQTJHTGxySytucG9ZalJ3aGhydDlmdlRs?=
 =?utf-8?B?U2pSNTFuUWVRNmVFT0tsazBrbUZsbElyOTNPVi9hUHBxVStKTFFaZ2dXWHFl?=
 =?utf-8?B?elJHVGs5Njk2NzJiVXhhd1NKeFFQY0Y0bUV4b3M4UVEzbXJrRXg0bXFLTUM3?=
 =?utf-8?B?TGU0ODhLSldKelE2RldWVFNPVVg3TTNlN0UyV0RvODE2MGVKOHdQVEpDNkd6?=
 =?utf-8?B?Vyt5ZUpzZHdjdlNoUXlCYXJmRVhSUkN3QnpVckVXR0YrK2hCa3llcElOM1B4?=
 =?utf-8?B?cU1idVJvV1JJWXB1amhYY3FtQWpDaWNTOWUyOW5GbUJQL0xiL3NLcnFTbXNO?=
 =?utf-8?B?enI5cHVkZ1ByS3RSSzRkQU9PWElQU09FRE9aUDRibDlOZjdMWno3YWtRdGJR?=
 =?utf-8?B?VThGUTlQZkV5Q0NudFdQcVd1MU9nUVhEMnRSU2dISkNOMzVkMVNjRG55cHU3?=
 =?utf-8?B?VWcwSkkvUUpMTEIvaU9JQk5HNXlOU2tOeXZSZTJyalJXam52SC9hQWNOQUdT?=
 =?utf-8?B?dEVOL1A4RlFvdkMxc0U2V0NsVTJnempDZFh0T0dFOWVFSTAwWmZ1QktNZnZ4?=
 =?utf-8?B?OFByTXVjMW1tc1prVjhhOG1hNWgyTkF6bmFLNjJBWE5tRW1JcG1QZlRIckRh?=
 =?utf-8?B?ZXBGSTFhakJqSjljdHEwQzRRenZhQmp5TDNkQktTSjVieEpVazkvR3hiOGpS?=
 =?utf-8?B?NHdKaCt2VlJXUmh0VnhZb3B0aGRDdHNXRVNHa3NVWldiUEFEdkNrVDhid1k2?=
 =?utf-8?B?Rk1JWFlFMER5YjFrRGw0SEc3NzVKbzBhVUk4U3pHQVFMUGtPYzlHYWZDV2x3?=
 =?utf-8?B?N1I4OXB0QW41OHB4aG9aMEtvbkpRRUZ3QTBMRjJVWFV3MEhCWjVFblN5WUN3?=
 =?utf-8?B?YTRoSTJDYVl5M0pORzluTWFlMWJSeW1IVkl5bmFBOEVENnhOVmRZUTVINnpi?=
 =?utf-8?B?UkNVdG9ndzI1dXZPTUhVWkRVVVBydm9DMEY2eHNCek4rUk5td1AyZ05kd21n?=
 =?utf-8?B?RXdaQVVDTjFZS3ZoV296YkM3Rzc3d25CalYrNTlOZlB1SVo5WGo4ZTRJZEhs?=
 =?utf-8?B?UENRQ085blBVbHo1enQ5UGlUcDRnY2xtYUxveVU2ZGxWd2w1Y2lWeHZMUDhL?=
 =?utf-8?B?V2dJZ045d01RVEc1Zy8xSHVnQW01UUVjeTFmbVZlb0poRDMxSFYvNGk0V3hQ?=
 =?utf-8?B?RVFKSElJYzZVbkl1ZDZFRkpvcFVwdjNjQkZpbDBiZ0dhR2RhcmI1eDhoSk4x?=
 =?utf-8?B?VEZ6bEFhdExweHhuVWtNMjBBdHZaaThsS0FDeFREdStYTzJzczhTMmZRTGFR?=
 =?utf-8?B?NjlNQytVbUtGalF0VDV5VkdncUZqZ3ZneDFoSGR1NUNWYnAwTmI2ZzFNQ3N5?=
 =?utf-8?B?ajJkZEMyRjMxcHNLbHVPak51TG50cG9Mcksyd3BrSzhqa2VpTEJuUU0vMXJR?=
 =?utf-8?B?TWFyZUUyOWRmWkhhRXRXdURRQnRsNFhtSlI0TVFTbEFzSFh5K25mY1ZuWS9v?=
 =?utf-8?B?d0ZPcFUzbURSZWxIL2NjdVhyMEdGUXl2d0NZUU1IcmtGRXFVakRGRmpRaEox?=
 =?utf-8?B?Wmprb1haK0J1ODllSUxUcFZjTVV6eForWW5JYkw2YzJMWTNoelFMLzJOS0M0?=
 =?utf-8?Q?/xV7z/r4fipXPavOY+01PSXGP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CCC364690409240B9AD3C3CD16DD71D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcbe78e-7a1e-44b5-cb70-08dbb054a6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2023 10:16:22.4430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N0cBwrtQMbVlSGxKjczRNnYO+BHwphuOy18Q+AwrI+niep6r7jWLtzJSkyat74/izDd8569lCuqCePRFlAGFnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
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

T24gVGh1LCAyMDIzLTA5LTA3IGF0IDE3OjE5ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gKy8qDQo+ID4gKyAqIERvIHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIGlm
IG5vdCBkb25lIHlldC7CoCBJdCBjYW4gYmUNCj4gPiArICogZG9uZSBvbiBhbnkgY3B1LsKgIEl0
J3MgYWx3YXlzIGNhbGxlZCB3aXRoIGludGVycnVwdHMgZGlzYWJsZWQuDQo+IA0KPiBuaXQ6IEFk
ZCBsb2NrZGVwX2Fzc2VydF9pcnFzX29mZiByYXRoZXIgdGhhbiB0aGUgY29tbWVudCwgdGhlIHNh
bWUgd2F5IA0KPiBpdCdzIGRvbmUgZm9yIHRoZSBscCBlbmFibGUgZnVuY3Rpb24gYmVsb3cuDQoN
ClllYWggY2FuIGRvLiAgVGhhbmtzLiAgSSBkaWRuJ3QgZG8gYmVjYXVzZSB0ZHhfY3B1X2VuYWJs
ZSgpIGFscmVhZHkgZG9lcyBpdC4NCg==
