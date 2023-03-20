Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF56C24C9
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjCTWgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCTWg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:36:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB5F30B17
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679351788; x=1710887788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e3INf+y/paPQvNFed7TAXmI6kXN52NWLmLuum0gXDcg=;
  b=fb5huJKHpV9ihMtchiC0zFbQkTpI2G/8tebuOG1+Bt9Dr9Fu3FPcDJFe
   L9G2xXUsKvUdsjdgHcCrqtQR2o5pt4vm9BxR6d6IhbX5HsgMLfcUuwTOH
   WFKcihKrGd9LOaW77xZamzoK+dVq+VJ9hDZPxliH+ElaCVOl0cYfFNOhH
   6mtqBnUYMTX4wlIrbdkHy3moLVUW/1K7iF3bTWs4OcJNWjKKkDBh/01px
   yQ2tiEH8JuNxspTEPb781xVJCgSAkhJpobpFvKfQBmNkc+ZYYw+GRRFIL
   4RT8S6SNOs65R0OrULX1ldjQL1k0MrUOqQ6bheU8tHvYBGnG/0pp7CqCb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="338823410"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="338823410"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 15:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="927137142"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="927137142"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2023 15:36:23 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 15:36:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 15:36:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 15:36:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TA2+oYCWryifWWJNBOjc6Y57xVXi/Od1NAkvzgcD70zrZlPNOzcxbQoMMSOQ9AYxlACzoZ0jWhMcxYVZLPSSpugCZpt01XKOgsfgTzlAnlYCq9Z890X5ED36p1rsz2l5PbStpJSfg8dxCY4a4wKgJe8vnZzu0OAkCYGm8b62L91jUoFkjqU4a6l/8Nw9H7SuHCA0XaVVQ7LTJD5kS+Q7stkrf4BnoZ6e8wiiL9HrRxgaOQm1d6ElKcA6qoVK1U3JrnZmjl1GzqiNnygdv7m6wH0E2UusI7MjvYzt9xIXjsCMACJiv1d/KIyZTa/7zTJFNvCoqaCTzUbUOEbXniGJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3INf+y/paPQvNFed7TAXmI6kXN52NWLmLuum0gXDcg=;
 b=UNSAl9A3AsGq1gi3LkVJaCAfgnpn6P06X/WIIW9hv6Bzb1UOHH/zokRo08B4HE7oREZ7clYcIVa7Kqiq7O9ap3G2P1A0QgHpzUV3fwAORfNX3Y0BQqi8gz7qLMFPvOshX0nQT6wpb2Ot9H8C0fqtA8sKuHdQupCwqDgWb5h2NmO+XhBnFr7pkanRdpisGrqpJf1hCrN1ZCa/E7SLY/sErVvGPJHZjmRZSPrwepMIcf/u/BELRrtctGmhir89ihir880OdBV3QhoRYpSMHb7sZnFKc7E1726uV4Hsl8/npnaubwiryNtu8MNg43JYWUDKWhZ2e1FNUdXOvvh6grcTRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7448.namprd11.prod.outlook.com (2603:10b6:510:26c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 22:36:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 22:36:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8ERECA
Date:   Mon, 20 Mar 2023 22:36:15 +0000
Message-ID: <38d7494ba654a45fc9c582de3d7a1de5e6c7e2d3.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
In-Reply-To: <20230319084927.29607-3-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7448:EE_
x-ms-office365-filtering-correlation-id: f881782b-2fb6-4274-b132-08db2993841e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7pj+rpsskQwgYYXuPKf5xt2Blf+UnPi+MGyph9mkJU6Iknjt+M4uVsUB/IZrLo5b+nrP3+HQwFyVYKA5lDLo9QIGjhlvsNeLXquWlei0MP1WKnGBO7T9wVEdeey5y4UxOWXy8NDRdSDnY3YQQcOnU6Yq0GW9TcnOcbNqA/AYa+XvvL/GHLB4qArV8wtRt2Igv6Pt7lg2JLw80NviEXtmvpL8CanOAHFGCl54dyxLKxYIGoeR/CQWFagZby77sjUMVQVFdTgZCbMJtGtO5JR8cw4vIQH+R/qzA9TXtFQ0Lx6mT5qiikq/EvQUYv+BBhF+TaWSE7ms4xnPBKxWc5KtOqPnGHza1wsY7UU020Y2YN9xiWiRY5eOw9kOUmUtJsnnwt2GCykxgXE2hVHh2PQuLG3xlO2T0UbYpeX/5Y8wP+Xht6zMTyMtInApEpcd8tNXTC6zzMFoER8yv+nC6kzbSM/s3pGxCtmRYdNB69vpEjTyb/khnqdRZWgkLWuscHmO7kQ2QjKouBNp3cX+BtFE+Bp2bz0UyTZxmjXn/tSuoXa8taoa0p0VwIvKx8Vj+TxaBt6iiydoF9+eFJEd2/Z+FyB0DkHRJEd+LEVJnHchxAYLBdc593m7A+Akj4Ice1/SGOjyI01JRFYzj5r3H8sl3g1rbFuSbflI15B6JjFckEpKHtxJaTwJax7N9fpWrdalT7ZHW9OWRgpDttSOlWO7qA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199018)(38100700002)(186003)(5660300002)(86362001)(83380400001)(8936002)(41300700001)(2906002)(38070700005)(54906003)(82960400001)(110136005)(316002)(478600001)(2616005)(71200400001)(26005)(6506007)(6512007)(36756003)(64756008)(76116006)(66946007)(66446008)(4326008)(8676002)(6486002)(91956017)(66556008)(66476007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUF1SkJ1dlNEdlc0U1JpeUlhenFkUG5QNnQ0clR5VHJPOEJ2dkNlcy9QeEhq?=
 =?utf-8?B?QlBjR0RPQ3pPT1pHa1NnWlZ6cHpwVzM0ZU5tS3ltSDBWQUozN21EOXRrWjVt?=
 =?utf-8?B?dEkrVDI2YUJpZUJQMzZnVGdmWVQ2TDFjYlhzUW9xSU5jTVFWV3pLMjJ6cjdF?=
 =?utf-8?B?aFVEY3ZLeDJMSDJlandlc1hRdUdYTnpwZjA1VmQxV0JvdlFvQ0l6cVQwK2da?=
 =?utf-8?B?bWRQYzN1cHd5a3o3ekRkSzJLdHBSUGxuaWh4R2VOSTZaMnhnOCsya3BSUDFK?=
 =?utf-8?B?ckF0d2tITytOSjJuTXFBYUQ2cDhQY1VNL29xMnpLUjQ2K3d0ZHU1K0Y5cHFK?=
 =?utf-8?B?N0FaMnNCSkI2TTBENUZGYlh1WTMrSUQwdXdXcmFMb3ByM0Q3S1creE9GeENi?=
 =?utf-8?B?WXBRWEdSYkdNdkN2WHdTR0JzTnlTbmJOQzB3VnVWbEFFZ0pUdU8xRmJGb1VU?=
 =?utf-8?B?YXBVcnN2Zzk2RDZTd2MwV1g4OEU5QWFsTDBHKy90VmxLNnpKTDFlQ3Q5elE5?=
 =?utf-8?B?eGJyRnZzRlV1YTdacjhjaG84dy9NQWJPcEVvZWNFcGJGM2YzL3RINnA1TU1J?=
 =?utf-8?B?R1JNV2k0MWQrTTBRZVBEMUE5NUcxYmQxb3poVjVlTGhQODd2RzV0NkpZZXJB?=
 =?utf-8?B?MDVVOVcrNkNJM24wTXYrRkhCSmNTYkpiL3R5Kzg2dDh6UmVkTnBIK2V5bTdP?=
 =?utf-8?B?SGZ5YWxKRnFxamhPeThSS1hNUWJyRTdhajdHNk9XSFpnUnZUVGNwdmRJMit2?=
 =?utf-8?B?aGgydmxCa3JNUmE1djBqZFdhaHJtNWJQWEZvZXBxY3dhWXZvdGFsTG5MNklK?=
 =?utf-8?B?Rm5oR1pMczBLU0VzZlM1R0hzRjZIdEoxUWxNdUsrc0NCQjFoSlovZ0I2MGQ4?=
 =?utf-8?B?Vis1V3JCN0dFZG14SmRwSHpWa05FRUNxenpmaHRFU2hJbllmamJoZ3ZkS3or?=
 =?utf-8?B?QVNTMldXYXlqNG1nUUZTc3VFQ1JJVGYybERuSGpxbXFXNjdQT2NRakRyYSsx?=
 =?utf-8?B?ekl2TksyUERmeXJXM2tjRHJneE5vdWdaaFV1Qk5Ld1JXbEhKeC9uVU9lT3E5?=
 =?utf-8?B?bk5jc2xMVHV5Mi9uL0ZsWmw5RVVjdllGbVRXaVdEeXlDSUxwUC9oUnNZSnIx?=
 =?utf-8?B?OUFwNnF5cU5vYW1NZW5lc1F5NXhwK2o0M3NFRW1ISlNhNWxNakQwVE1IVFp4?=
 =?utf-8?B?eVM4YXdETzFTWkVkYmVSQ2VOdjZ2eHVYUlhMa2NCWUkyK0M3a3l5ZXRxemFL?=
 =?utf-8?B?cUxLbkowNGFZbEVzV0xSNHprZE9kM1dZQ1FndXhXV28wRnR1cFR3TUlMVnZ4?=
 =?utf-8?B?VUpEdUc5a0pNSkliTS9aUXNweFZTSWRqUTgzQ1ZSTWNxSlJwUXh2RE5na0FF?=
 =?utf-8?B?MEFZVVpYTmpjWjdGWmZaRXdwZ1d5dDBrRk9tVEc1QWtqQXBlUkl1UjdpS0ZL?=
 =?utf-8?B?MWN5cFFtNUd3SUJaT20rNUlCUWpGWE9OS1BDRGpOSzlvbDA2TytWUDJIMjB1?=
 =?utf-8?B?VUxPMjE3QldQSm9oMFA5VHp6Zy9QNVZ4MlUwRkg5ZmF5SzdiODlhTnZGZTla?=
 =?utf-8?B?THQrbzhyNjhOUEdRZEdOczU3R3Y5QUM3dm9yN20yeVZtYjdIclhVRldGUDda?=
 =?utf-8?B?Y0VGa3UzK0t4TG1XS1A2OFNXek9YZVdCTU5vZVVnZFZqa1RnUEEwUmxBVUd6?=
 =?utf-8?B?V2RML1F2cW9zaFBrWGdZNW9ya1VsY1dIYStjWDBYVENyYVNSelBmUndGZlEw?=
 =?utf-8?B?UzNoQXk4bTh2N0tlK3hiSC9EVXdCcGg4M2hUNTRCQ29CUTBZa0ttZk1xUGt1?=
 =?utf-8?B?LzNrS0hYUmhNNEhKV0tGNVVrZFU0RHpHWXRSZm5FZDMzaGt4c3Z1Y1pmM0h5?=
 =?utf-8?B?RTZOVVp6UkdHZGRpOFFEeXNHRzdPeUFSbGFZWFlqbFpqOVBHSGdtV0RnaDR5?=
 =?utf-8?B?cnh6bk0wMHlXUmZpV0lXekJEL201bEJwUnNkZVEyV3I5elEzTkwxSUY1TW0z?=
 =?utf-8?B?VWIzSnBWZnZ1KytZSVB4bytkNnFnVGdWaENpWXBMeTF2MGlQRlV2UnM1SU5O?=
 =?utf-8?B?N1gzQnVQMEIvTzd0R2loZW54ekZhcDUyelBNd0djdW9YaVB6d2d6ZkhDMEY0?=
 =?utf-8?B?TEpXZERLNUlFNGJycTVsVU5ha21xZ3dVY2FNRnQvR2p0QlJ4Zmg4RGFEREha?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1F436C77493DC48A3C09B9B0B0AC657@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f881782b-2fb6-4274-b132-08db2993841e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 22:36:15.6123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXvgmUskAlth44wP0uBnQZc9rviA5zt1yFWcsz9zAlQctUM2dZ1DeTIuwnm/mxumxe7h7uPI7tWRRQc92gHr3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTE5IGF0IDE2OjQ5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IGdl
dF92bXhfbWVtX2FkZHJlc3MoKSBhbmQgc2d4X2dldF9lbmNsc19ndmEoKSB1c2UgaXNfbG9uZ19t
b2RlKCkNCj4gdG8gY2hlY2sgNjQtYml0IG1vZGUuIFNob3VsZCB1c2UgaXNfNjRfYml0X21vZGUo
KSBpbnN0ZWFkLg0KPiANCj4gRml4ZXM6IGY5ZWI0YWY2N2M5ZCAoIktWTTogblZNWDogVk1YIGlu
c3RydWN0aW9uczogYWRkIGNoZWNrcyBmb3IgI0dQLyNTUyBleGNlcHRpb25zIikNCj4gRml4ZXM6
IDcwMjEwYzA0NGI0ZSAoIktWTTogVk1YOiBBZGQgU0dYIEVOQ0xTW0VDUkVBVEVdIGhhbmRsZXIg
dG8gZW5mb3JjZSBDUFVJRCByZXN0cmljdGlvbnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBCaW5iaW4g
V3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3Zt
eC9uZXN0ZWQuYyB8IDIgKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvc2d4LmMgICAgfCA0ICsrLS0N
Cj4gIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgYi9hcmNoL3g4Ni9rdm0v
dm14L25lc3RlZC5jDQo+IGluZGV4IDU1N2I5YzQ2ODczNC4uMGY4NGNjMDVmNTdjIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvbmVzdGVkLmMNCj4gQEAgLTQ5NTksNyArNDk1OSw3IEBAIGludCBnZXRfdm14X21lbV9hZGRy
ZXNzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgbG9uZyBleGl0X3F1YWxpZmljYXRp
b24sDQo+ICANCj4gIAkvKiBDaGVja3MgZm9yICNHUC8jU1MgZXhjZXB0aW9ucy4gKi8NCj4gIAll
eG4gPSBmYWxzZTsNCj4gLQlpZiAoaXNfbG9uZ19tb2RlKHZjcHUpKSB7DQo+ICsJaWYgKGlzXzY0
X2JpdF9tb2RlKHZjcHUpKSB7DQo+ICAJCS8qDQo+ICAJCSAqIFRoZSB2aXJ0dWFsL2xpbmVhciBh
ZGRyZXNzIGlzIG5ldmVyIHRydW5jYXRlZCBpbiA2NC1iaXQNCj4gIAkJICogbW9kZSwgZS5nLiBh
IDMyLWJpdCBhZGRyZXNzIHNpemUgY2FuIHlpZWxkIGEgNjQtYml0IHZpcnR1YWwNCj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2t2bS92bXgvc2d4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3NneC5jDQo+
IGluZGV4IGFhNTNjOTgwMzRiZi4uMDU3NDAzMGIwNzFmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L3NneC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvc2d4LmMNCj4gQEAgLTI5
LDE0ICsyOSwxNCBAQCBzdGF0aWMgaW50IHNneF9nZXRfZW5jbHNfZ3ZhKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgdW5zaWduZWQgbG9uZyBvZmZzZXQsDQo+ICANCj4gIAkvKiBTa2lwIHZtY3MuR1VF
U1RfRFMgcmV0cmlldmFsIGZvciA2NC1iaXQgbW9kZSB0byBhdm9pZCBWTVJFQURzLiAqLw0KPiAg
CSpndmEgPSBvZmZzZXQ7DQo+IC0JaWYgKCFpc19sb25nX21vZGUodmNwdSkpIHsNCj4gKwlpZiAo
IWlzXzY0X2JpdF9tb2RlKHZjcHUpKSB7DQo+ICAJCXZteF9nZXRfc2VnbWVudCh2Y3B1LCAmcywg
VkNQVV9TUkVHX0RTKTsNCj4gIAkJKmd2YSArPSBzLmJhc2U7DQo+ICAJfQ0KPiAgDQo+ICAJaWYg
KCFJU19BTElHTkVEKCpndmEsIGFsaWdubWVudCkpIHsNCj4gIAkJZmF1bHQgPSB0cnVlOw0KPiAt
CX0gZWxzZSBpZiAobGlrZWx5KGlzX2xvbmdfbW9kZSh2Y3B1KSkpIHsNCj4gKwl9IGVsc2UgaWYg
KGxpa2VseShpc182NF9iaXRfbW9kZSh2Y3B1KSkpIHsNCj4gIAkJZmF1bHQgPSBpc19ub25jYW5v
bmljYWxfYWRkcmVzcygqZ3ZhLCB2Y3B1KTsNCj4gIAl9IGVsc2Ugew0KPiAgCQkqZ3ZhICY9IDB4
ZmZmZmZmZmY7DQoNCkZvciBTR1ggcGFydCwNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCg==
