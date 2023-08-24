Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F17378798E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 22:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbjHXUrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 16:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243400AbjHXUrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 16:47:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CECD1B0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 13:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692910060; x=1724446060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WkLQuMBnsyJgNdk/rcKUDIVCaoZ4SV570OyHlYr5Xrk=;
  b=WD5BMnvg2DzMFeznMVxRz4Uj909w4KzzwLL3nkoVjoK2BfArzKTCmLWk
   HuB/4FdlwtlLE1TZ3oR1xoV73yFFM1QJ34zfWyyD29W/SvGSbI7AYemsi
   2d5e73Z2Lh0oQnleE6ined9ChCOHIe+OCSfc45JBiX+O801ruasFxip0K
   4xZxo+PnFaGatl+UwMMiQiK2kAJZkBA9QcENh5FRfe024KY/cmptL4bdT
   d1SMD08KN4cYXfQCkLvC72wGHjNXpFYQwnNExLDmfRtBSqa+k7A7hkIzv
   rgaLeDh+kHkbFbBfVLN4mMXaQq6QrU9Zm5478+4yXfnuHhevHc9BDQ62U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="460913259"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="460913259"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 13:47:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="714099421"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="714099421"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 24 Aug 2023 13:47:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 13:47:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 13:47:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 13:47:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOKIkreIfwwE52J83ai+p6vfg54O2SSZBF4SoZK/TJ/vaILcJkU0UaBml5Wafvoe5V1+IwFUTyKP/9M3ZUQXIgwPCeLazxslYk2QRqqXSuFrfRWxFG0gEJvLnao+kj2y0cv+e8B75FT6Lv86ZXVhcGngsgEyqV4gorgTh+p/eTVafUa+6Kpw1gWt1abUXVGrIOJImpqd+pnu746szkTygvpoKqNSQE5xE/KpaMSxyYwXcI3X/h+AR5XnLQH7dX5sgVbQIybdVQYQ8LQjVRhkwSn6YJBpDUf42hipS+SFoAaJ81b/1T4YhdyLy3VCppoe59oTsD7GtT90HL70ohMkCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkLQuMBnsyJgNdk/rcKUDIVCaoZ4SV570OyHlYr5Xrk=;
 b=hRE1kW2EnJGJfaW+Dt01BlpymvU4u5OifCYQwEtuI6Vsf0XnktleTTisW82QyFmM0pOlZQNtVlBSgv371gOpLaAYeOyd0WBFG1kQvjOnhLnZoTLuUCW8iGqUxRvcJhReHg+921go17Qo//tWQ4WlmfT8bgWZSYKuzzJ+eqmMWqJIUoMQXvmR/jVyuraF/jTQvO97qcXJGkbqn6lgCrFrIdnoEbGB2PpzGv4oQXbfUJ1O4tgXAiUlyR1egLTUtJnh3BDjhNxn7YztQzFy1DgkN5yTC+h3tnju+aCK8tK2cFAySCr14rRt028Xn3WLqC5Uo6l3Xd7w+IDsAD7E8bK8NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6)
 by LV2PR11MB6021.namprd11.prod.outlook.com (2603:10b6:408:17e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 20:47:35 +0000
Received: from CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::144a:72f:f163:f466]) by CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::144a:72f:f163:f466%2]) with mapi id 15.20.6699.027; Thu, 24 Aug 2023
 20:47:35 +0000
From:   "Neiger, Gil" <gil.neiger@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
Thread-Topic: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
Thread-Index: AQHZ1lwonmIvJ36G/ECjTFxMCvhMv6/5oI2AgABIUpA=
Date:   Thu, 24 Aug 2023 20:47:35 +0000
Message-ID: <CO1PR11MB510788E4185D0BF8A48288D1911DA@CO1PR11MB5107.namprd11.prod.outlook.com>
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com>
 <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
 <ZMvfxFgHlWMyrvbq@google.com>
 <e8bfb368-2869-6ad3-35de-8f7ee5568661@intel.com>
 <ZOeC3XYT7kCy/Ukn@google.com>
In-Reply-To: <ZOeC3XYT7kCy/Ukn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5107:EE_|LV2PR11MB6021:EE_
x-ms-office365-filtering-correlation-id: 025dea66-cebc-4b8c-0f88-08dba4e35871
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lIXRCmkPXSSOs59XBnDOFoC3LuEG2OGJwoH98vof7jUup85fkbhovLK70+7pZRLCYqQC4xmbC5GFLU1Hxc9amic3gh4I/Zcq6KSH00kYq+qPe3bDuTyGqk+5PqjcE4pHa1kOKEkk1d7roPXkSOTnFeEo8TX77/NA0KxhwCm5DR5vbOTm9E4bWWYidLMXsn4/dhvFxhkBPFQiAl3IR6fMUrqXihJoLCoHGlxP3PStrc6oY+BeygH7rHluKiVTvOEKiJvVDSAyRiekpzzvtbkWTRT9/fcPKDjYrUIZvfDkGlMZmD2/+hkf3LQej/fy/FGuQrd2BJtXldT5GFxwreJRQb4+G+PW1YIOL1AMNZhCyhm03VqCKPU/Z7yjy6y2HGX4HHo9cSpGgZ4NnFkQsuuVwlr1hF41xcOHjBm5IxhAD9LLaOysuUNGZBKp3VfHLryDo1vuC9vR+5UR/tQXNbTpbu27hy1Ji3ds12rZOzHN/frIrXgHL2zC1g5SRS4mJfgpSZZjpA2LmWFZnkjcRaENeB6JiVoPnqu9mt9aHjwB2ALlFqfZ7kU1CHZRD/dxuMOoPLa9WHS7xkIUxpv7C6AxAWc5jwqdIeHgn2o1K8yzt7f6vTs+QpxDS0qTd1DtMDVH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199024)(186009)(1800799009)(64756008)(54906003)(6636002)(6506007)(66446008)(76116006)(66556008)(66946007)(66476007)(316002)(82960400001)(122000001)(478600001)(110136005)(55016003)(26005)(38100700002)(38070700005)(71200400001)(41300700001)(7696005)(86362001)(9686003)(2906002)(53546011)(8936002)(8676002)(4326008)(52536014)(5660300002)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkJFSGtUMjRsSjJCc2FhLzhMeDdkZEJuOHY3T0VnZjZhb2FHTlFDMFlCcVlI?=
 =?utf-8?B?Y1I1ekl6ZUtKMDRlT3VTOENTeUhlcTBOVmZoNDZpTk5QSWtkQ2QvNzRoMDZr?=
 =?utf-8?B?TCsyd2lEOWE1RGM3Z1RpbVJ5MFFEQ3QyL3NvRmR2VlBRQXRIcVBtNE9yZVNO?=
 =?utf-8?B?NlBCNjNBV3RqVzc0b3EwUEZ4UnI5cU83Y1BZRUZvRzVsdWZCWWRaZGQzL3ZQ?=
 =?utf-8?B?YWZSZzJkVmNRVUp6STdObmc1WnJEMDkvUWprcVBmYkNmV2pPMVA0V0p5RnRL?=
 =?utf-8?B?S054ZnRwQXRMTWhpaTFRRmMybERIWVA1eUlKbnhmRG01SU5LSkpnWVVPRytj?=
 =?utf-8?B?cXh4Q2h5WlBaRnkxSkY0Y1BLRS8zV2lHSk5sa2pxZnduREJuY3ZDejhjK0RU?=
 =?utf-8?B?dXdLQytsb3NwK0VJK1JHMDd1Y2dTZmx6WmJ3dmk4NjZna3QvMUcrK09UMGlM?=
 =?utf-8?B?c3RZakN0ZlB6am42Ui90T3pVSzZVZ2NULzR6VGNET2UrODUxZUlEV0U2WTBo?=
 =?utf-8?B?OVVzRkF2aUNjd0dXbHNMa003TFNsKy9GS2FpUk9GaFhmTzlMWlBUdXdZTVRE?=
 =?utf-8?B?c1ZNMVh2RldmOExLU2I3SGNmTlg3S0FDM2pEdmZxZTFuRzh6bDhEYk0vY1VD?=
 =?utf-8?B?T1E3d1pMRGd2b05aRkV0S1BrR2x1WkJWVDhZeU9uNE80UGJ3Ykt5cWZaQmR6?=
 =?utf-8?B?djNBRDhhUTRCUFVFenVRcU1NTjI3dXlqRklveXlISmFyL0hUYUJCYjkxbTZG?=
 =?utf-8?B?MjhPVmpuODdSbmE2Y3pQWi85S3VrOS9GL1hIelNWU0pmWG5rY2hnVzI0Uy83?=
 =?utf-8?B?WExQc3JtMHdJWmdEQ2d0VVNOUXBNM0Q4RW5UUWpjUG80TlJQakx4d3pJbVRB?=
 =?utf-8?B?eW10cWZpVzNDdHhHRTl2TW5OQXIrNWJVcG9IUmszVlovRTlqMFdXRitLY0FV?=
 =?utf-8?B?MjVIZVVMZE0zVUU1eTY2T040cDRjSnBvUXp4emJlM1AwanZESU1hazdCcXhV?=
 =?utf-8?B?R252RjAwRnhsUCtOU0NQbDMzWHJ0Wm1mRWVrSGFSSDVpa3lZc3YvZGk3N2tI?=
 =?utf-8?B?cHNTSzBqSi91UU1ST0FkejlNc0tYaGpBS3J1MkFsWFBTMDVrbUhVSXZRQ08r?=
 =?utf-8?B?V3ZVd3doK3JncnZncHczU3ZhNVZIMzJ1TmNxc0tmc1FkVzZhTXdCVm92OWZG?=
 =?utf-8?B?cDc2OE5CK1I1b2dBZWZZRDB3cFVQcVg2WWo5TkxUYXNJRXlTZ0JmdDNqaWZh?=
 =?utf-8?B?S2x3U2sxS0dzN3h4SnNOK0x5RWVvT25UdVh3Z0ROREpTMFZLSEtNYUVJMXg5?=
 =?utf-8?B?b085bFhGTm83SGtONTVMdk56RGUxMmpYS2M0QWkrRHEwVXZEbm1JTWJvMlFa?=
 =?utf-8?B?RHZBSEFGY0d4Qk52T0VZQ2FSeXpYNG9qR3M3Q1hxMUx2bUNrS0ZoUVdTWnps?=
 =?utf-8?B?UG5rZnFqc1FVVDJaaHdjM1E2SzJyTHFCdFpDWE84c0hDczgyeUp0LzUwRHVD?=
 =?utf-8?B?Vnd1WkJ5L1RIb1lrS3lHRW9jL0R1UnNvRFVzZTY4Q1VHZ3M1dCtXeTdEKzE4?=
 =?utf-8?B?ZlVrK09rYWttUEE4TGpHQkZQRCsrMTNPSzdLUXZ2QnFjUjZNZU5ZU2NORURl?=
 =?utf-8?B?VSt3NVJBYktMR0pxa1o0R051ODFpK1NvNDFpRm5OcjVHdERyeHdpb1kxS1R2?=
 =?utf-8?B?RzFQUmRsb2tzdVhSUDFmVk5tV1ZrRVlVbE5Sdm5PQ1ZLUW5xN0tPSHRsRE42?=
 =?utf-8?B?cWMybU1ZMElNWkRYd2VMU2xhNHhyNHJld3dLT1hEbnFCZFVjeHZuZnByemVH?=
 =?utf-8?B?Sjc5b1QxckdJZ1MwOTJjSmF0bjhuREZSbkI3WTU4SnoyRE5wYnRQQUdpaU1m?=
 =?utf-8?B?bFAxVzdtRVVWSFdlZnV4Uy9yTXNCeTRJa2Jkejc5MWZiYUJsNXVTV3FNVzkx?=
 =?utf-8?B?UEZRT2NCY1BlSzFKVHlGVmRrVWZaWmJyQTJ1U1ppYUwwYkFjNk5MOTVzUEJX?=
 =?utf-8?B?TndJR3pkNlFCNlpJL3FOekRWeTdZOXRWWm1VZCtGTVJ4OG1UVmI2Uk03VWlT?=
 =?utf-8?B?WXJvaUZZVGtMWWQ5N1hudERyc3FpWkhZS1N6T3NmRVFJTW03U3lEejNpN0dI?=
 =?utf-8?Q?WEpELjgSejfaIWy+6IzbLDLwz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025dea66-cebc-4b8c-0f88-08dba4e35871
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 20:47:35.0943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mgNNK8icjwmMZHOlmz57+ZAwW4WCBBIu4OBaZljrZKdV1KEbcRzyJTxy6jy7fOlAxQt5Hmr/TjtsDPvHzwZNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6021
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

PiBPbiBUaHUsIEF1ZyAyNCwgMjAyMywgV2VpamlhbmcgWWFuZyB3cm90ZToNCj4gPiBPbiA4LzQv
MjAyMyAxOjExIEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBB
dWcgMDMsIDIwMjMsIFdlaWppYW5nIFlhbmcgd3JvdGU6DQo+ID4gPiA+ID4gVGhpcyBpcyB3cm9u
Zywgbm8/ICBUaGUgY29uc2lzdGVuY3kgY2hlY2sgaXMgb25seSBza2lwcGVkIGZvcg0KPiA+ID4g
PiA+IFBNLCB0aGUgYWJvdmUgQ1IwLlBFIG1vZGlmaWNhdGlvbiBtZWFucyB0aGUgdGFyZ2V0IGlz
IFJNLg0KPiA+ID4gPiBJIHRoaW5rIHRoaXMgY2FzZSBpcyBleGVjdXRlZCB3aXRoICFDUFVfVVJH
LCBzbyBSTSBpcyAiY29udmVydGVkIg0KPiA+ID4gPiB0byBQTSBiZWNhdXNlIHdlIGhhdmUgYmVs
b3cgaW4gS1ZNOg0KPiA+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wg
dXJnID0gbmVzdGVkX2NwdV9oYXMyKHZtY3MxMiwNCj4gPiA+ID4gU0VDT05EQVJZX0VYRUNfVU5S
RVNUUklDVEVEX0dVRVNUKTsNCj4gPiA+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBib29sIHByb3RfbW9kZSA9ICF1cmcgfHwgdm1jczEyLT5ndWVzdF9jcjAgJg0KPiA+ID4gPiBY
ODZfQ1IwX1BFOyAuLi4NCj4gPiA+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoIXByb3RfbW9kZSB8fCBpbnRyX3R5cGUgIT0NCj4gPiA+ID4gSU5UUl9UWVBFX0hBUkRfRVhD
RVBUSU9OIHx8DQo+ID4gPiA+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAhbmVzdGVkX2NwdV9oYXNfbm9faHdfZXJyY29kZSh2Y3B1KSkgew0KPiA+ID4gPiAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBWTS1lbnRyeSBpbnRl
cnJ1cHRpb24taW5mbyBmaWVsZDoNCj4gPiA+ID4gZGVsaXZlciBlcnJvciBjb2RlICovDQo+ID4g
PiA+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNob3Vs
ZF9oYXZlX2Vycm9yX2NvZGUgPQ0KPiA+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50cl90eXBlID09DQo+ID4gPiA+
IElOVFJfVFlQRV9IQVJEX0VYQ0VQVElPTiAmJg0KPiA+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJvdF9tb2RlICYm
DQo+ID4gPiA+IHg4Nl9leGNlcHRpb25faGFzX2Vycm9yX2NvZGUodmVjdG9yKTsNCj4gPiA+ID4g
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKENDKGhh
c19lcnJvcl9jb2RlICE9DQo+ID4gPiA+IHNob3VsZF9oYXZlX2Vycm9yX2NvZGUpKQ0KPiA+ID4g
PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7DQo+ID4gPiA+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfQ0KPiA+ID4gPg0KPiA+ID4gPiBzbyBvbiBwbGF0Zm9ybSB3aXRoIGJhc2ljLmVy
cmNvZGUgPT0gMSwgdGhpcyBjYXNlIHBhc3Nlcy4NCj4gPiA+IEh1aC4gIEkgZ2V0IHRoZSBsb2dp
YywgYnV0IElNTyBiYXNlZCBvbiB0aGUgU0RNLCB0aGF0J3MgYSB1Y29kZSBidWcNCj4gPiA+IHRo
YXQgZ290IHByb3BhZ2F0ZWQgaW50byBLVk0gKG9yIGFuIFNETSBidWcsIHdoaWNoIGlzIG15IGJl
dCBmb3IgaG93DQo+IHRoaXMgZ2V0cyB0cmVhdGVkKS4NCj4gPiA+DQo+ID4gPiBJIHZlcmlmaWVk
IEhTVyBhdCBsZWFzdCBkb2VzIGluZGVlZCBnZW5lcmF0ZSBWTS1GYWlsIGFuZCBub3QNCj4gPiA+
IFZNLUV4aXQoSU5WQUxJRF9TVEFURSksIHNvIGl0IGRvZXNuJ3QgYXBwZWFyIHRoYXQgS1ZNIGlz
IG1ha2luZw0KPiA+ID4gc3R1ZmYgKGZvciBvbmNlKS4gIEVpdGhlciB0aGF0IG9yIEknbSBtaXNy
ZWFkaW5nIHRoZSBTRE0gKGRlZmluaXRlDQo+IHBvc3NpYmlsaXR5KSwgYnV0IHRoZSBvbmx5IHJl
bGV2YW50IGNvbmRpdGlvbiBJIHNlZSBpczoNCj4gPiA+DQo+ID4gPiAgICBiaXQgMCAoY29ycmVz
cG9uZGluZyB0byBDUjAuUEUpIGlzIHNldCBpbiB0aGUgQ1IwIGZpZWxkIGluIHRoZQ0KPiA+ID4g
Z3Vlc3Qtc3RhdGUgYXJlYQ0KPiA+ID4NCj4gPiA+IEkgZG9uJ3Qgc2VlIGFueXRoaW5nIGluIHRo
ZSBTRE0gdGhhdCBzdGF0ZXMgdGhlIENSMC5QRSBpcyBhc3N1bWVkIHRvDQo+ID4gPiBiZSAnMScg
Zm9yIGNvbnNpc3RlbmN5IGNoZWNrcyB3aGVuIHVucmVzdHJpY3RlZCBndWVzdCBpcyBkaXNhYmxl
ZC4NCj4gPiA+DQo+ID4gPiBDYW4geW91IGJ1ZyBhIFZNWCBhcmNoaXRlY3QgYWdhaW4gdG8gZ2V0
IGNsYXJpZmljYXRpb24sIGUuZy4gdG8gZ2V0IGFuDQo+IFNETSB1cGRhdGU/DQo+ID4gPiBPciBq
dXN0IHBvaW50IG91dCB3aGVyZSBJIG1pc3NlZCBzb21ldGhpbmcgaW4gdGhlIFNETSwgYWdhaW4u
Li4NCj4gPg0KPiA+IFNvcnJ5IGZvciB0aGUgZGVsYXllZCByZXNwb25zZSEgQWxzbyBhZGRlZCBH
aWwgaW4gY2MuDQo+IA0KPiBIZXkgR2lsISAgVGhhbmtzIGZvciBodW1vcmluZyBtZSBhZ2Fpbi4N
Cj4gDQo+ID4NCj4gPiBJIGdvdCByZXBseSBmcm9tIEdpbCBhcyBiZWxvdzoNCj4gPg0KPiA+ICJJ
IGFtIG5vdCBzdXJlIHdoZXRoZXIgeW91IChvciBTZWFuKSBhcmUgcmVmZXJyaW5nIHRvIGd1ZXN0
IHN0YXRlIG9yDQo+IGhvc3Qgc3RhdGUuDQo+IA0KPiBUaGUgcXVlc3Rpb24gaXMgd2hldGhlciB0
cnlpbmcgdG8gZG8gVk1MQVVOQ0gvVk1SRVNVTUUgd2l0aCB0aGlzIHNjZW5hcmlvDQo+IA0KPiAg
IDEuIHVucmVzdHJpY3RlZCBndWVzdCBkaXNhYmxlZA0KPiAgIDIuIEdVRVNUX0NSMC5QRSA9IDAN
Cj4gICAzLiAjR1AgaW5qZWN0aW9uIF93aXRob3V0XyBhbiBlcnJvciBjb2RlDQo+IA0KPiBzaG91
bGQgVk0tRmFpbCBkdWUgaW5qZWN0aW5nIGEgI0dQIHdpdGhvdXQgYW4gZXJyb3IgY29kZSwgb3Ig
Vk0tDQo+IEV4aXQoSU5WQUxJRF9TVEFURSkgZHVlIHRvIENSMC5QRT0wIHdpdGhvdXQgdW5yZXN0
cmljdGVkIGd1ZXN0IHN1cHBvcnQuDQo+IA0KPiBIYXJkd2FyZSAoSSBwZXJzb25hbGx5IHRlc3Rl
ZCBvbiBIYXN3ZWxsKSBzaWduYWxzIFZNLUZhaWwsIHdoaWNoIGRvZXNuJ3QNCj4gbWF0Y2ggd2hh
dCdzIGluIHRoZSBTRE06DQo+IA0KPiAgIFRoZSBmaWVsZCdzIGRlbGl2ZXItZXJyb3ItY29kZSBi
aXQgKGJpdCAxMSkgaXMgMSBpZiBlYWNoIG9mIHRoZQ0KPiBmb2xsb3dpbmcgaG9sZHM6DQo+IA0K
PiAgICAoMSkgdGhlIGludGVycnVwdGlvbiB0eXBlIGlzIGhhcmR3YXJlIGV4Y2VwdGlvbjsNCj4g
ICAgKDIpIGJpdCAwIChjb3JyZXNwb25kaW5nIHRvIENSMC5QRSkgaXMgc2V0IGluIHRoZSBDUjAg
ZmllbGQgaW4gdGhlDQo+IGd1ZXN0LXN0YXRlIGFyZWE7DQo+ICAgICgzKSBJQTMyX1ZNWF9CQVNJ
Q1s1Nl0gaXMgcmVhZCBhcyAwIChzZWUgQXBwZW5kaXggQS4xKTsgYW5kICg0KSB0aGUNCj4gdmVj
dG9yIGluZGljYXRlcw0KPiAgICAgICAgb25lIG9mIHRoZSBmb2xsb3dpbmcgZXhjZXB0aW9uczog
I0RGICh2ZWN0b3IgOCksICNUUyAoMTApLCAjTlANCj4gKDExKSwgI1NTICgxMiksDQo+ICAgICAg
ICAjR1AgKDEzKSwgI1BGICgxNCksIG9yICNBQyAoMTcpLg0KPiANCj4gU3BlY2lmaWNhbGx5ICMy
IGRvZXNuJ3Qgc2F5IGFueXRoaW5nIGFib3V0IHRoZSBjaGVjayB0cmVhdGluZyBHVUVTVF9DUjAu
UEUNCj4gYXMgJzEnDQo+IGlmIHVucmVzdHJpY3RlZCBndWVzdCBpcyBkaXNhYmxlZC4NCg0KVGhh
bmtzIGZvciBjbGFyaWZ5aW5nIHRoYXQgdGhlIGNhc2UgaW4gcXVlc3Rpb24gaW5jbHVkZSBpbmpl
Y3Rpb24gb2YgYW4gZXZlbnQgd2l0aCBlcnJvciBjb2RlLg0KDQpUaGlzIGlzIGEgcXVpcmt5IHNp
dHVhdGlvbiwgYW5kIGl0IGhhcHBlbnMgKGNvaW5jaWRlbnRhbGx5KSB0aGF0IEkgYW0gd29ya2lu
ZyBzaW1pbGFyIHF1ZXN0aW9ucyByaWdodCBub3cgaW50ZXJuYWxseS4NCg0KSW4gZ2VuZXJhbCwg
Vk0gZW50cnkgZmFpbHMgImVhcmx5IiAoVk0tRmFpbCkgaWYgdGhlcmUgaXMgYSBwcm9ibGVtIHdp
dGggaG9zdCBzdGF0ZSBvciBjb250cm9scyBhbmQgZmFpbHMgImxhdGUiIChWTS1FeGl0KElOVkFM
SURfU1RBVEUpKSBpZiBpdCBkb2Vzbid0IGZhaWwgZWFybHkgYnV0IHRoZXJlIGlzIGEgcHJvYmxl
bSB3aXRoIGd1ZXN0IHN0YXRlLg0KDQpUaGlzIGRpc3RpbmN0aW9uIGV4aXN0cyB0byBhbGxvdyB0
aGUgQ1BVIHRvIGxvYWQgYW5kIGNoZWNrIGd1ZXN0IHN0YXRlIGluIG9uZSBwYXNzOiAgb25jZSBW
TSBlbnRyeSBzdGFydHMgdG8gbG9hZCBzdGF0ZSwgYW55IGZhaWx1cmUgd2lsbCByZWxvYWQgcmVn
aXN0ZXJzIHdpdGggIlZNLUV4aXQoSU5WQUxJRF9TVEFURSkiLg0KDQpUaGUgb3JpZ2luYWwgY2hl
Y2tzIG9uIHRoZSBpbmplY3Rpb24gY29udHJvbHMgKGluY2x1ZGluZyB0aGUgZXJyb3IgY29kZSBi
aXQpIHdlcmUgYWxsIGRvbmUgZWFybHkgYXMgdGhleSB3ZXJlIGp1c3QgY2hlY2tzIG9uIGNvbnRy
b2xzLiAgQXQgdGhhdCB0aW1lLCB0aGVyZSB3YXMgbm8gY29uZGl0aW9uaW5nIG9uIENSMC5QRSBi
ZWNhdXNlICJ1bnJlc3RyaWN0ZWQgZ3Vlc3QiIGRpZCBub3QgZXhpc3QgeWV0Lg0KDQpXaGVuICJ1
bnJlc3RyaWN0ZWQgZ3Vlc3QiIHdhcyBhZGRlZCwgdGhvc2UgY2hlY2tzIGJlY2FtZSBjb25kaXRp
b25hbCBvbiB0aGUgZ3Vlc3QgdmFsdWUgb2YgQ1IwLlBFLiAgV2UgY29uc2lkZXIgdGhlIHBvc3Np
YmlsaXR5IG9mIG1vdmluZyB0aG9zZSBjaGVja3MgdG8gYmUgImxhdGUiIChiZWNhdXNlIHRoZXkg
ZGVwZW5kIG9uIGd1ZXN0IHN0YXRlKSwgYnV0IHRoYXQgd291bGQgaGF2ZSByZXF1aXJlZCBtb3Jl
IGNoYW5nZXMgdG8gdGhlIFZNLWVudHJ5IGltcGxlbWVudGF0aW9uIHRoYW4gc2VlbWVkIGp1c3Rp
ZmllZC4gIEluc3RlYWQsIHRoZSBjaGVja3Mgd2VyZSBsZWZ0ICJlYXJseSIuICAoVGhlIGd1ZXN0
IENSMC5QRSB3YXMgY29uc3VsdGVkLCBidXQgaXQgd2FzIG5vdCBhY3R1YWxseSBsb2FkZWQgaW50
byB0aGUgQ1IwIHJlZ2lzdGVycywgc28gVk0tRmFpbCB3YXMgT0suKQ0KDQpUaGF0IGhhcyBsZWZ0
IHRoaXMgYXJjaGl0ZWN0dXJhbCBhbm9tYWx5IHRoYXQgd2UgaGF2ZSBvbmUgZWFybHkgY2hlY2sg
dGhhdCBkZXBlbmRzIG9uIGd1ZXN0IHN0YXRlIC0gYW5kIGl0IGlzIGd1ZXN0IHN0YXRlIHRoYXQg
bWF5IGxhdGVyIGNhdXNlIGEgbGF0ZSBjaGVjayB0byBmYWlsLg0KDQpBcyBJIHNhaWQsIEkgYW0g
d29ya2luZyB0aGlzIGlzc3VlIGludGVybmFsbHkgdG8gSW50ZWwgc28gdGhhdCBldmVyeW9uZSBo
YXMgYSBjb25zaXN0ZW50IHZpZXcgb2YgaG93IHRoaXMgYWxsIHNob3VsZCB3b3JrLiAgSSB3aWxs
IGZvbGxvdyB1cCAob3Igd29yayB0aHJvdWdoIFdlaWppYW5nKSBhcyB0aGluZ3MgZGV2ZWxvcC4N
Cg0KCQkJCQktIEdpbA0K
