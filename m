Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDE7D034B
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 22:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346573AbjJSUp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 16:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346564AbjJSUpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 16:45:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D74136;
        Thu, 19 Oct 2023 13:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697748320; x=1729284320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HjCCyy0ydoIHequIgX9d/xvRL4MdnPPUZMnJAjuHsv8=;
  b=e5flEot00iwS1/6Blef4Dx3Kq9+zT6W7MSWpy5JDFEIU5/SJFIBmI4Nm
   7debMwvgVUJ5sdUJ42FgBV5lmsUYTDRHM5xqhw/QEeIR9QTyy17E3lgvF
   YRDkOPWYXh/ua0OrvSAtAqf4Mr8a/J9LVzd+QZKTB4Tm7D5VPFKcjkmyH
   uhJy/9SojW0MB4titangW9EO9A7Ms3Y3LN8OayOk0Kgb7W1r7x79f75by
   vhEPzsbLFLlIvHzchkxeYLpQInjaeFB5nYWbjeiu+Q8f1eu3utNLD61j2
   Z3I8zKYiwfMX8weRoBiMJhH/YbLcjn7pZ2oQ5sSZHLh0+W0753q3a/DqY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="366598518"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="366598518"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 13:45:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="760790158"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="760790158"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 13:45:19 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 13:45:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 13:45:18 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 13:45:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvGAiMhoYRYpd0UeOurofTgQ3hjjmbWCnWjOBfHvhc7Q86M9KbNzYkZtQWvqgJX6WQqErhgfI57FMsjt2trQrWKQHOlY5jVeId/usseiEB9ZkYHN3OsFDfpmO5uLi5xaCJDT8Wb4gHRxLMRyMEgiG4FQDjOYIGLx7Zt/yn8Biv0JfiehcCMEKNTJ3C73ZYmst++Wy5H9BEXw317ClIjCUPEgB19HAiv4AYojb26+NR83RD9BFr4G2RHwoR09v7/xqMR4N8YtBz4dncPLW2VyCHQOkrw3Oh+/PJ3pdVGVwOEnBWMogW9xrX+1BQXXcCx9AufwqjS/xrGYfMrftgmNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjCCyy0ydoIHequIgX9d/xvRL4MdnPPUZMnJAjuHsv8=;
 b=XtEneWUyB2TBUr+Gj98C1KVcJdVVjJgr2TOOHtnQgiLeDV+Sgl2eNqUS48zp9KfHCsP1R4Rm7mx7Phj0B0AJPKt5bRml2/vq1lGOH2MjooW+y83Zjb3PV3uBPH+wchLiLzBQBITTatBNF0HPHEDNkHM8Vq8iuUPAO+P+WbfrzsUuHWAW6drFSFsFbNHGSg0hsT2qjcPcj1weownNT27AoQDKFJ0X+PNe2LTTcDgZqWdt0VNErkM6mW+fpwVJiQNMvwy9GThBG7aIRpvhlfSW54zmiq8GCCWnAV4F00GBIBdA1+IWITLDMYjKlU6hxekEgRpC2xCgVTzjZXFPm/HuaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4534.namprd11.prod.outlook.com (2603:10b6:208:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Thu, 19 Oct
 2023 20:45:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 20:45:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "rafael@kernel.org" <rafael@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Topic: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Index: AQHaAOAHZhhRpZBgMkGcIwyiZNScqbBNzo0AgAEURgCAAHOagIAACd+AgAAArQCAAjeVgA==
Date:   Thu, 19 Oct 2023 20:45:14 +0000
Message-ID: <a663370374f56c05a9241918473adb72accd2054.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
         <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
         <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
         <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com>
         <1c118d563ead759d65ebd33ecee735aaff2b7630.camel@intel.com>
         <CAJZ5v0jy0MR-VyQHQt9-zAhHoTDp-xHtFnDOre3BPmT+FNgjCQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0jy0MR-VyQHQt9-zAhHoTDp-xHtFnDOre3BPmT+FNgjCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4534:EE_
x-ms-office365-filtering-correlation-id: 0738d1ac-d560-4eb5-8716-08dbd0e44be9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UePP/E3rIeGrGLU+sRWlh0cKSumMfsdBuy0EF32LnCLTRcMuo6tMzNEq7+jlbRk3HgQZqHKDjoqwI2hmq/qZqxS0nX/ulYzqD2/Apf3MG1K2OAGXVIGP5wgLQ6RrIZj+bzXP+ah6BQQDFen8UHk7wVc90ZqkurKf3JqR/ZucDqMxMWVhgU0VfnearlPGoxaMZdffLx51pQnhpflQ9YNgT+pnurXDUk4KUZqHcGKkdJ4YTtZWVQJseEdCsbfa81JrZEV6QIGm2aPgkBZcUlRaV8t5/dhD16+UJbsOw7PVXyizA9KWtV5f5VoVZ1BnS279vPUeO18voLEqr/1pZ1dPWqZI2C33t6HecmvIiE7wq80L8w1h//SOKoLn7O+GB67J2xWw3SiecWgGD8KvunIWrgs7oHJtwtAyPiQpL0b00+ae+Kc4MaiFw9dOMLB6wR0DAx60mgDEnuQFt6TXeF70dcC3L812vWKB2n6YFEaDvFaEvZeaMX4grToA38EXlXvF8M/F1tKuU4HXB1sFzf9+1eBvR+gR/GU0lmKil1DO5Prsa689jkh3mmcxMqKOsoJzcCCtS3ZU48ZqpbBUi7rt3qSEYsgI/co/H3P5lKKEXY5HbvJdo57DpAzKG1K+kHw3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(38070700009)(2616005)(26005)(53546011)(71200400001)(66476007)(6512007)(76116006)(83380400001)(7416002)(2906002)(5660300002)(8676002)(4326008)(478600001)(8936002)(41300700001)(54906003)(6486002)(64756008)(66946007)(91956017)(66446008)(6916009)(66556008)(122000001)(316002)(38100700002)(82960400001)(86362001)(6506007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnVQR1M1VEY0UzNuamFsbDZIckErNFNmUWtGTWc3ZXQ3QWxENytGMlJQeEV3?=
 =?utf-8?B?SGpUSndhbFBPU3VaRzJid3R0WnFLdncreXdYMFZsUzg0SWwxQmdhVFdyUTB3?=
 =?utf-8?B?TzZ2djVFQTh5NThXekRGUER5L0VkUmgraExEelphcTNnRXJneDBpdGNSazAx?=
 =?utf-8?B?N2pRY2xFK1p5S0VQdHhvUW1yKzc4cEZVeGNRN1RPbXBqelJ3WmlUN2dPSEc5?=
 =?utf-8?B?NitqVk11VUNjSk5KWEdUcXlmZC9IeWFDc052bnFrYnh5QzNZT1dublJnR01t?=
 =?utf-8?B?TnF6N0d0Y1FkTnZLT0dMYWhzS0Vyc0REeXBzRjZ4QWR6Wmk3S1FlVzh1VVht?=
 =?utf-8?B?R2Z5NnVHREE5a1dxWVJJMnhyQ3VqRWxPRFM3alN4eEtxemN3YnV3REh3eWda?=
 =?utf-8?B?M0pub3plMDJhNktRZVJKODFjcGZFbWV6VVpUNVIyK0FlYlg2bW82SXZoUENN?=
 =?utf-8?B?WEJxWkRMblJyZ3NuaVU5eWV6QnoyZzRmYVgyUVEvWFpXQitmMDVBSkM2UEdS?=
 =?utf-8?B?WDdCcXVITWkrdjEzK0kvSXlnQW1rZCtrN3RsRGxPczdlK3d6YVgrNGdlYy9L?=
 =?utf-8?B?T3pZdm12aTJ2TlpvbndabXFRZTRiNS9rc0U4OGlRNUpUNjB6VGxuOE14aVh4?=
 =?utf-8?B?dXRzcnkrT0c2NEJqRTl6OXZaMjkwMHFjSjNQWHFJT25oVGZ1TjhPN3VSakp6?=
 =?utf-8?B?L1paMHR0TnRpSW5jZURmVytnSnQwZ3lIdjdiTnhIUUVXdXFUTmhOd2tWR1JZ?=
 =?utf-8?B?RWZuSlhYS3FYQWpwR2ZvTWthaDRSWTJRYlUra3NQSjZta0lxeDRYRnJxRVdk?=
 =?utf-8?B?WW12TWZwNTNEVTV5UUVOYnE1T1FEYVIyMllFcFRTaEhDbDEvMDEzMXh1azRj?=
 =?utf-8?B?V2l3dW1VTU4xU05WTEtvaTZNUFU2L0dRV3YvcjZLRWw1RHV0RHgrV1J0SzE5?=
 =?utf-8?B?YUJTcldkMlFvdFRjeXNyb3czQnI3anVhOXNIYUxvVU85SzFGWWhZei9ZakR1?=
 =?utf-8?B?bU54bEQ0QWxTOW45VDdWdHJyeUF4SksxTEg1WlFhbmRTalNmeHljYXFHZ25x?=
 =?utf-8?B?U0hwWitGa3Y4a2c0OXJacElrQ0xsZGJ6eGxLNXV3akZGRjAvT0x0TzlZS0Rp?=
 =?utf-8?B?T1dScWNEbkl5bm1wcGl5QlBZQi82dTNrZTFHZFAxWjBxMDRpanI4QnRlQzky?=
 =?utf-8?B?SmdTTWVpNXBkZVZ2MW5oUVJvQXQwZW5XNkdFODBEZXZYNDJFQjZZN0NvWmVj?=
 =?utf-8?B?cUcvWXJwa3V3bmQ3Tk8rZ2EycnFpZzhOSjdBVyttZlhoSUQxMVpPL3hGZzB0?=
 =?utf-8?B?NVBGU1lvZUgyZkRTTUQxWmZRTEs2OVVjVzlOQy91eDlQeGhaRGxubFhQUGhN?=
 =?utf-8?B?WnRGYVAreXlrZDNEQzV4OFBwM0ViVHYrUW9rWmdkRnROeUkxN01iVUVPc0xJ?=
 =?utf-8?B?QVE0NUlkV0lEZUkzbVNoNlVubmdDY0FwWTdEcmVFQmxWZk1hL05lRitJSm0y?=
 =?utf-8?B?RTd3UVI2VEt4UnZrZWVPWW5oMHBJWXFEZ0Y5RDBiZU9PbXV6WHBaZ0pLazh4?=
 =?utf-8?B?Z2ZrTDdmQnQ4T1JOWTJqOHF6TDdLaDl4NWRkcHJFb0U1elgwaStaem4wL3pZ?=
 =?utf-8?B?cFU5L3RTdGNnVFlFVkpFekRlc3V2NmgrdnZJQXE2cnBJdHovVUJCTVR3dnI2?=
 =?utf-8?B?ajdYU3R5NWNYSEFxSnUxSHUvTUR4aStydk4xUVNKM1hudkdpUWxOS3V3U3l5?=
 =?utf-8?B?bWVLMXhmOFNldUxmOHVDUndPU1l3QXZGb1h0a3JtK0NTbXhIejJvalJ0VDBI?=
 =?utf-8?B?eVJDSTBNNnRMZjhOSWZERVd2RFg1NDlrSlE4MER1UlovamhubVNJcmVKQVJW?=
 =?utf-8?B?eTlpeUYvM2M2aHdsVGtPWlozNzQ2NGIvK2VZbTFXdkFXd3I4NG5zMDdldkhJ?=
 =?utf-8?B?dnc4YkVheENqZkcrVjNNMldyQ1NIZGhvZkliSHQ5bnhNRTNkbW85dFdTL2E0?=
 =?utf-8?B?OER1Z1FGSCtwTG9XcmNsdlNWUFk3aWlQTWU2Y2JmN05DNVFkOUw2NUNRdFhq?=
 =?utf-8?B?eUE1cE5kbm5TTkV2cUlyRjR4bXJyOWM0dWtuWTVkeGV4b28yTDc4OEl3aHNy?=
 =?utf-8?B?YVZKVHJ1bkloTzFleEVqQXE5TldqU01CY3JYbmpzSUdGNzdlZmZqTEJhalJY?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <971D2706A9337E4FAC682A1949E71830@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0738d1ac-d560-4eb5-8716-08dbd0e44be9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2023 20:45:14.7503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VioPwrl9zH8BIVnI43MSJFf4HaJXz9qRzk89RwWa75Jb+ltjgMUE3m66zfo0WFxpeM8NVbm2H2ig1yKZZyy7/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4534
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

PiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gLS8qIExvdy1sZXZlbCBzdXNwZW5kIHJvdXRpbmUuICov
DQo+ID4gPiA+IC1leHRlcm4gaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKTsNCj4g
PiA+ID4gK3R5cGVkZWYgaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsX3QpKHZvaWQpOw0KPiA+
ID4gPiArDQo+ID4gPiA+ICsvKiBTZXQgdXAgbG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4gKi8N
Cj4gPiA+ID4gK3ZvaWQgYWNwaV9zZXRfc3VzcGVuZF9sb3dsZXZlbChhY3BpX3N1c3BlbmRfbG93
bGV2ZWxfdCBmdW5jKTsNCj4gPiA+IA0KPiA+ID4gSSdtIG5vdCBzdXJlIGFib3V0IHRoZSB0eXBl
ZGVkZiwgYnV0IEkgaGF2ZSBubyBzdHJvbmcgb3BpbmlvbiBhZ2FpbnN0IGl0IGVpdGhlci4NCj4g
PiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gIC8qIFBoeXNpY2FsIGFkZHJlc3MgdG8gcmVzdW1lIGFm
dGVyIHdha2V1cCAqLw0KPiA+ID4gPiAgdW5zaWduZWQgbG9uZyBhY3BpX2dldF93YWtldXBfYWRk
cmVzcyh2b2lkKTsNCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jv
b3QuYyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0KPiA+ID4gPiBpbmRleCAyYTBlYTM4
OTU1ZGYuLjk1YmUzNzEzMDVjNiAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvYXJjaC94ODYva2VybmVs
L2FjcGkvYm9vdC5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0K
PiA+ID4gPiBAQCAtNzc5LDExICs3NzksMTcgQEAgaW50ICgqX19hY3BpX3JlZ2lzdGVyX2dzaSko
c3RydWN0IGRldmljZSAqZGV2LCB1MzIgZ3NpLA0KPiA+ID4gPiAgdm9pZCAoKl9fYWNwaV91bnJl
Z2lzdGVyX2dzaSkodTMyIGdzaSkgPSBOVUxMOw0KPiA+ID4gPiANCj4gPiA+ID4gICNpZmRlZiBD
T05GSUdfQUNQSV9TTEVFUA0KPiA+ID4gPiAtaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2
b2lkKSA9IHg4Nl9hY3BpX3N1c3BlbmRfbG93bGV2ZWw7DQo+ID4gPiA+ICtzdGF0aWMgaW50ICgq
YWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKSA9IHg4Nl9hY3BpX3N1c3BlbmRfbG93bGV2ZWw7
DQo+ID4gPiA+ICAjZWxzZQ0KPiA+ID4gPiAtaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2
b2lkKTsNCj4gPiA+ID4gK3N0YXRpYyBpbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQp
Ow0KPiA+ID4gDQo+ID4gPiBGb3IgdGhlIHNha2Ugb2YgY29uc2lzdGVuY3ksIGVpdGhlciB1c2Ug
dGhlIHR5cGVkZWYgaGVyZSwgb3IgZG9uJ3QgdXNlDQo+ID4gPiBpdCBhdCBhbGwuDQo+ID4gDQo+
ID4gQWggcmlnaHQuDQo+ID4gDQo+ID4gU2luY2UgeW91IGRvbid0IHByZWZlciB0aGUgdHlwZWRl
ZiwgSSdsbCBhYmFuZG9uIGl0Og0KPiA+IA0KPiA+IEUuZyw6DQo+ID4gDQo+ID4gdm9pZCBhY3Bp
X3NldF9zdXNwZW5kX2xvd2xldmVsKGludCAoKnN1c3BlbmRfbG93bGV2ZWwpKHZvaWQpKQ0KPiA+
IHsNCj4gPiAgICAgICAgIGFjcGlfc3VzcGVuZF9sb3dsZXZlbCA9IHN1c3BlbmRfbG93bGV2ZWw7
DQo+ID4gfQ0KPiA+IA0KPiA+IExldCBtZSBrbm93IHdoZXRoZXIgdGhpcyBsb29rcyBnb29kIHRv
IHlvdT8NCj4gDQo+IFllcywgdGhpcyBpcyBmaW5lIHdpdGggbWUuDQo+IA0KDQpIaSBSYWZhZWws
DQoNClNvcnJ5IGZvciB0aGUgYmFjayBhbmQgZm9ydGggb24gdGhpcy4NCg0KV2l0aCB0aGUgcGF0
Y2ggd2hpY2ggcHJvdmlkZXMgdGhlIGhlbHBlciwgTEtQIHJlcG9ydGVkIGJ1aWxkIGVycm9yOg0K
DQogICBkcml2ZXJzL2FjcGkvc2xlZXAuYzogSW4gZnVuY3Rpb24gJ2FjcGlfc3VzcGVuZF9lbnRl
cic6DQo+PiBkcml2ZXJzL2FjcGkvc2xlZXAuYzo2MDA6MjI6IGVycm9yOiAnYWNwaV9zdXNwZW5k
X2xvd2xldmVsJyB1bmRlY2xhcmVkIChmaXJzdA0KdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQg
eW91IG1lYW4gJ2FjcGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwnPw0KICAgICA2MDAgfCAgICAgICAg
ICAgICAgICAgaWYgKCFhY3BpX3N1c3BlbmRfbG93bGV2ZWwpDQogICAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KICAgICAgICAgfCAgICAgICAgICAg
ICAgICAgICAgICBhY3BpX3NldF9zdXNwZW5kX2xvd2xldmVsDQoNClR1cm5zIG91dCBJIGRpc2Fi
bGVkIGJvdGggc3VzcGVuZC9oaWJlcm5hdGlvbiBpbiBteSBvd24ga2VybmVsIGJ1aWxkIHRlc3Qs
IHNpZ2guDQoNClRoZSBjb21tb24gQUNQSSBzbGVlcCBjb2RlIHJlcXVpcmVzIHRoZSBBUkNIIHRv
IGRlY2xhcmUgJ2FjcGlfc3VzcGVuZF9sb3dsZXZlbCcNCmluIDxhc20vYWNwaS5oPiwgYW5kIGRl
ZmluZSBpdCBzb21ld2hlcmUgaW4gdGhlIEFSQ0ggY29kZSAgdG9vLg0KDQpTbyBzYWRseSBJIGNh
bm5vdCByZW1vdmUgdGhlIGFjcGlfc3VzcGVuZF9sb3dsZXZlbCB2YXJpYWJsZSBkZWNsYXJhdGlv
biBpbg0KPGFzbS9hY3BpLmg+LiAgQW5kIHRoZSBlbmRpbmcgcGF0Y2ggd291bGQgaGF2ZSBib3Ro
IGJlbG93IGluIDxhc20vYWNwaS5oPjoNCg0KICAgLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGlu
ZS4gKi8NCiAgIGV4dGVybiBpbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQpOw0KDQog
ICsvKiBUbyBvdmVycmlkZSBAYWNwaV9zdXNwZW5kX2xvd2xldmVsIGF0IGVhcmx5IGJvb3QgKi8N
CiAgK3ZvaWQgYWNwaV9zZXRfc3VzcGVuZF9sb3dsZXZlbChpbnQgKCpzdXNwZW5kX2xvd2xldmVs
KSh2b2lkKSk7DQogICsNCg0KVGh1cyBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQgc3RpbGwgYSBn
b29kIGlkZWEgdG8gaGF2ZSB0aGUgaGVscGVyPw0KDQpBbnkgY29tbWVudHM/ICBUaGFua3MhDQoN
CkJlbG93IGlzIHRoZSBmdWxsIHBhdGNoIHRoYXQgSSBlbmQgdXAgZm9yIHlvdXIgcmVmZXJlbmNl
Og0KDQpGcm9tIDkzNzJlMDI3OGUyYTE0NDE5ZDA4ZThkZjM2ZTQ3NGRjNzJkOTM3ODQgTW9uIFNl
cCAxNyAwMDowMDowMCAyMDAxDQpGcm9tOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+
DQpEYXRlOiBUaHUsIDE5IE9jdCAyMDIzIDE0OjM3OjE5ICsxMzAwDQpTdWJqZWN0OiBbUEFUQ0hd
IHg4Ni9hY3BpOiBBZGQgYSBoZWxwZXIgdG8gb3ZlcnJpZGUgQUNQSSBsb3dsZXZlbCBzdXNwZW5k
DQogZnVuY3Rpb24NCg0KQUNQSSBTMyBzdXNwZW5kIGNvZGUgcmVxdWlyZXMgYSB2YWxpZCAnYWNw
aV9zdXNwZW5kX2xvd2xldmVsJyBmdW5jdGlvbg0KcG9pbnRlciB0byB3b3JrLiAgRWFjaCBBUkNI
IG5lZWRzIHRvIHNldCB0aGUgYWNwaV9zdXNwZW5kX2xvd2xldmVsIHRvDQppdHMgb3duIGltcGxl
bWVudGF0aW9uIHRvIG1ha2UgQUNQSSBTMyBzdXNwZW5kIHdvcmsgb24gdGhhdCBBUkNILiAgWDg2
DQppbXBsZW1lbnRzIGEgZGVmYXVsdCBmdW5jdGlvbiBmb3IgdGhhdCwgYW5kIFhlbiBQViBkb20w
IG92ZXJyaWRlcyBpdA0Kd2l0aCBpdHMgb3duIHZlcnNpb24gZHVyaW5nIGVhcmx5IGtlcm5lbCBi
b290Lg0KDQpJbnRlbCBUcnVzdGVkIERvbWFpbiBFeHRlbnNpb25zIChURFgpIGRvZXNuJ3QgcGxh
eSBuaWNlIHdpdGggQUNQSSBTMy4NCkFDUEkgUzMgc3VzcGVuZCB3aWxsIGdldHMgZGlzYWJsZWQg
ZHVyaW5nIGtlcm5lbCBlYXJseSBib290IGlmIFREWCBpcw0KZW5hYmxlZC4NCg0KQWRkIGEgaGVs
cGVyIGZ1bmN0aW9uIHRvIG92ZXJyaWRlIHRoZSBhY3BpX3N1c3BlbmRfbG93bGV2ZWwgYXQga2Vy
bmVsDQplYXJseSBib290LCBzbyB0aGF0IHRoZSBjYWxsZXJzIGRvbid0IG1hbmlwdWxhdGUgdGhl
IGZ1bmN0aW9uIHBvaW50ZXINCmRpcmVjdGx5LiAgQ2hhbmdlIHRoZSBYZW4gY29kZSB0byB1c2Ug
dGhlIGhlbHBlci4gIEl0IHdpbGwgYmUgdXNlZCBieQ0KVERYIGNvZGUgdG8gZGlzYWJsZSBBQ1BJ
IFMzIHN1c3BlbmQgdG9vLg0KDQpObyBmdW5jdGlvbmFsIGNoYW5nZSBpcyBpbnRlbmRlZC4NCg0K
U2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KLS0tDQogYXJj
aC94ODYvaW5jbHVkZS9hc20vYWNwaS5oIHwgMyArKysNCiBhcmNoL3g4Ni9rZXJuZWwvYWNwaS9i
b290LmMgfCA5ICsrKysrKystLQ0KIGluY2x1ZGUveGVuL2FjcGkuaCAgICAgICAgICB8IDIgKy0N
CiAzIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hY3BpLmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9hY3BpLmgNCmluZGV4IGM4YTdmYzIzZjYzYy4uNjAwMWRmODc1MjZlIDEwMDY0NA0KLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYWNwaS5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9hY3BpLmgNCkBAIC02Myw2ICs2Myw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBhY3BpX2Rpc2Fi
bGVfcGNpKHZvaWQpDQogLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4gKi8NCiBleHRlcm4g
aW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKTsNCg0KKy8qIFRvIG92ZXJyaWRlIEBh
Y3BpX3N1c3BlbmRfbG93bGV2ZWwgYXQgZWFybHkgYm9vdCAqLw0KK3ZvaWQgYWNwaV9zZXRfc3Vz
cGVuZF9sb3dsZXZlbChpbnQgKCpzdXNwZW5kX2xvd2xldmVsKSh2b2lkKSk7DQorDQogLyogUGh5
c2ljYWwgYWRkcmVzcyB0byByZXN1bWUgYWZ0ZXIgd2FrZXVwICovDQogdW5zaWduZWQgbG9uZyBh
Y3BpX2dldF93YWtldXBfYWRkcmVzcyh2b2lkKTsNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tl
cm5lbC9hY3BpL2Jvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0KaW5kZXggMmEw
ZWEzODk1NWRmLi5lOTE0M2E4YTAzNTAgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvYWNw
aS9ib290LmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0KQEAgLTc3OSwxMSAr
Nzc5LDE2IEBAIGludCAoKl9fYWNwaV9yZWdpc3Rlcl9nc2kpKHN0cnVjdCBkZXZpY2UgKmRldiwg
dTMyIGdzaSwNCiB2b2lkICgqX19hY3BpX3VucmVnaXN0ZXJfZ3NpKSh1MzIgZ3NpKSA9IE5VTEw7
DQoNCiAjaWZkZWYgQ09ORklHX0FDUElfU0xFRVANCi1pbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2
ZWwpKHZvaWQpID0geDg2X2FjcGlfc3VzcGVuZF9sb3dsZXZlbDsNCitzdGF0aWMgaW50ICgqYWNw
aV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKSA9IHg4Nl9hY3BpX3N1c3BlbmRfbG93bGV2ZWw7DQog
I2Vsc2UNCi1pbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQpOw0KK3N0YXRpYyBpbnQg
KCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQpOw0KICNlbmRpZg0KDQordm9pZCBfX2luaXQg
YWNwaV9zZXRfc3VzcGVuZF9sb3dsZXZlbChpbnQgKCpzdXNwZW5kX2xvd2xldmVsKSh2b2lkKSkN
Cit7DQorICAgICAgIGFjcGlfc3VzcGVuZF9sb3dsZXZlbCA9IHN1c3BlbmRfbG93bGV2ZWw7DQor
fQ0KKw0KIC8qDQogICogc3VjY2VzczogcmV0dXJuIElSUSBudW1iZXIgKD49MCkNCiAgKiBmYWls
dXJlOiByZXR1cm4gPCAwDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vYWNwaS5oIGIvaW5jbHVk
ZS94ZW4vYWNwaS5oDQppbmRleCBiMWUxMTg2MzE0NGQuLjgxYTFiNmVlOGZjMiAxMDA2NDQNCi0t
LSBhL2luY2x1ZGUveGVuL2FjcGkuaA0KKysrIGIvaW5jbHVkZS94ZW4vYWNwaS5oDQpAQCAtNjQs
NyArNjQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgeGVuX2FjcGlfc2xlZXBfcmVnaXN0ZXIodm9p
ZCkNCiAgICAgICAgICAgICAgICBhY3BpX29zX3NldF9wcmVwYXJlX2V4dGVuZGVkX3NsZWVwKA0K
ICAgICAgICAgICAgICAgICAgICAgICAgJnhlbl9hY3BpX25vdGlmeV9oeXBlcnZpc29yX2V4dGVu
ZGVkX3NsZWVwKTsNCg0KLSAgICAgICAgICAgICAgIGFjcGlfc3VzcGVuZF9sb3dsZXZlbCA9IHhl
bl9hY3BpX3N1c3BlbmRfbG93bGV2ZWw7DQorICAgICAgICAgICAgICAgYWNwaV9zZXRfc3VzcGVu
ZF9sb3dsZXZlbCh4ZW5fYWNwaV9zdXNwZW5kX2xvd2xldmVsKTsNCiAgICAgICAgfQ0KIH0NCiAj
ZWxzZQ0KLS0gDQoyLjQxLjANCg0KDQoNCg==
