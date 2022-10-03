Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04045F2771
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 03:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJCBBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Oct 2022 21:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJCBBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Oct 2022 21:01:38 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFA333A17;
        Sun,  2 Oct 2022 18:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664758897; x=1696294897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WT056J34RdPuFS5OGkPwetYiBhK65nr/emmHpd1AIpc=;
  b=Eklpq0o72MORp9gm+Qdnfh0OV1cWseqwiUHbCDow3ezqxau/fAhmWQte
   l6Y7NVKhCEOFOsDZNt5yPqYJHN/2GKOtrI6iThppm8cv4Nz9dzusDu/Uv
   0QWzFD4FvGmznbN8xJylPv7grh28WSu5DCT+Cl9UssgBY/Jl3lyblskUy
   bKIv1tYuXL1WxEzsrcQlQi21HYzIkwBfhAfRqPy08SZuUwYN6oPmyXHBk
   thpFMYEqBRvxNjYCsXQlXfluSzy2qVwwZRKA2GnwZG8jnMZVc2/0Z4Cn+
   v+Ix31o/DI1cOKz044Rg0f/NcvXWKmt1gzaBKpto15XXp3ZOToFYTTNj5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="301246068"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="301246068"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 18:01:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="623364637"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="623364637"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 02 Oct 2022 18:01:36 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 18:01:36 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 18:01:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 2 Oct 2022 18:01:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 2 Oct 2022 18:01:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNZZ2RkrmKI8G9EaaA3F63zapmScaUKd1ZSISwPt2BHLXqf3xyOR92B+OYE6E+J/3jp8u5RtMWe2NcZ2sSZa4SpSMet363sO/S7+0FQ/vUB6h+PNd07LxM7iePrOiW11mn/TbpwygZrfESzAphnM/WgWtlsszEfo95AScRSE2KTyfuvn0nvEWkRnWM+g7pi6zqGdsO59KaUY08q80jml3ASyJBdGmQ+8i8SyqsWW1x6/+qpsBts0+xW2u8ejtwlwsmX1reO/voPRKUGkpuCWeT8l9WIPPwP4mbgaYKDrushkPQWnLms2FajOVNOmjJ7RTJ2RMLZlPI81KmzZAED2UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT056J34RdPuFS5OGkPwetYiBhK65nr/emmHpd1AIpc=;
 b=BB/WbuANDduWQ9aU50iHe7T1M7Z8PDwknnT+wtXmrklZBHYe+V43UB4zGIopajR2HLpge1mu9Cs1yCoIgwrs37889fHXpzFeMpcVbaDBQ6nrCUZ549vdaiB5ehPgvsJKAGdf+O4q2JTFrR35tmv53XAwE4Ro2xlu/Up3+CHKo+om+1UoDis4mfKLMzt0gBCcpxEWG9rCrxXjTNvi1H7p1VrNGVvBQ9WTkTADMzCBBKOhwWUnWaSjrbGWtzdFrIPNvwOogm0GHm7pw8BOBwNYmtcQyzhJ/Szn0aQVPxZLZhebxYz/46il/B65WBU5dMKsHW6N0RViwkEtuHPr+YdX0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6347.namprd11.prod.outlook.com (2603:10b6:208:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Mon, 3 Oct
 2022 01:01:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 01:01:18 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Resume guest immediately when injecting #GP on
 ECREATE
Thread-Topic: [PATCH] KVM: VMX: Resume guest immediately when injecting #GP on
 ECREATE
Thread-Index: AQHY1STSnn0yRNzx1Ee2VZfSg8ga+6373P6A
Date:   Mon, 3 Oct 2022 01:01:18 +0000
Message-ID: <a3b7068c376ba01d4bd715ce549932ce052eca42.camel@intel.com>
References: <20220930233132.1723330-1-seanjc@google.com>
In-Reply-To: <20220930233132.1723330-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6347:EE_
x-ms-office365-filtering-correlation-id: 97e266e0-47c2-4e2f-781d-08daa4dac764
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sj9UxN6/Sc9nFZMj5jCmb0T/tkfMHvxP+i08UPZYdhb82BrMS+T9qNvMOLM0kYPbnpLTIItFVM6/boDH7rDO5Dew90NTTHG2BlACD6ha78ullrtuqU/qp/LlRkfV84Z0NrGg3btakPIsEXnkVGhZgP4L8R4AVLC5MsLX+aqo6aPwwLBwZG7toHChxIEEjE1C3kp0q9BQ4WGt4NYltTKy8A4gVvlqiqQCm4vO9T4iXotQPHiudPc0n4LhWo09Mru7wgq/ojdnO9iJRFfVGnP1EYG5qPT5pqP6576N9SejcV0+706IJtuX3Ae0Yxhj3Z1DZbuqJsRdTkz92KoqW0quWGxxIjjHonP64D5IcKoKpKWFqe/obCvxP9EE7YMPmukvsOio3saNTlH9OOKK0U2XzbE5WFAPelHLgHFLHrRVtx31ZV71BOLojnknzhglqAa2asEdrGBi5Yx8ujbzI8mf/UCrvXm/CrVfWDJdm/V8I6CrGjQ9hlik6HBgWUp87N1XNr6dOxFu+XSAcFx+/edBqOCeP02BiWdiEV8exTZxjHA5MqZN275+/wr6vANDFN2v2e8xEkv4wRH7I2UnQjJAT1ZI0sFYDCO3MsuCBB4tMU9MtqZeJLUnlBpREGx9/sB7DdKbOOTB1OUmJfbdMaloqfTmUosxW9HutF3w4Z5Z9Ftvxln+Axe6COnfv00Rt5b0C08t4c4gQ/D4lvvlTsTWkZvuzu9eKQu76JY4A6tmhSMzIpQpC+Y4T1skRMknw+4nqLBLIpjk+k64JP5af8nndfzCR+QS13WKf53PqKsIYcs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(38070700005)(122000001)(5660300002)(86362001)(71200400001)(186003)(38100700002)(2616005)(8676002)(6506007)(91956017)(4326008)(36756003)(2906002)(8936002)(26005)(76116006)(41300700001)(64756008)(66556008)(83380400001)(66446008)(66476007)(66946007)(54906003)(6512007)(316002)(6486002)(110136005)(478600001)(82960400001)(14773001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akR5YXI5V2Q2eWROZWRwaHE0V2JHcVVOcmhUL0hYYS8rdDNWcmtleiszUTFK?=
 =?utf-8?B?RHZjSDJUam14VWd6a0dWZUM4cGx3VUxmQ2Iwekwxb05HakFhZmdQYzVYWnNL?=
 =?utf-8?B?ZG1yQ3VEcUhuazYrTlNwOHJyN3J4ZEYyNzBhSndSa0tmRzgwNThaWmxzL0RF?=
 =?utf-8?B?WVg5M0YzZGZTTVB5ZzlFK01VR2gwRDRhdDZQL0RweGVyelEwYnk5MStaVWZG?=
 =?utf-8?B?RTJGaG0xNFJMNnR2SDN3SE9PamJxOERlczZRdEU2RkNld05QbmJyMWVyaG9R?=
 =?utf-8?B?RzAzMU11cEdMRllXdEZ5eERQYTI3a29oSEN1YjBIeFN5cEJqWTUxcld6VmEx?=
 =?utf-8?B?eGJzcVZZUnRmZU93cCtlMHlxODMrazg4cVpEVng4NTVBNXA4ZXFzZk9IdlE2?=
 =?utf-8?B?V3lSd0hkbU9yaUs4dXQ2cmRlRFlZMWNDemtrUlM4c2c2ekpzWThXZkpKQXlk?=
 =?utf-8?B?QklaUmNpRi80cjgrS0RzRUZMMkFNZGYzUkdmV1ozY0YzcmxFb1lFcVRwTFRQ?=
 =?utf-8?B?Y0RWNFVyUjF4Q1pKQW1lR1RFbUlWTzJBelpmbUFJS2FNazc5SXRwMk80Q3cv?=
 =?utf-8?B?NE9GMW15L3RqSUE1VmlubnR2YloyQ040U3RaaVcrRmZ0UnJyVkF2bTFZeGxM?=
 =?utf-8?B?TEFkRFpKbVYxUU5SNnJ3WmxTcUVvM3hZd0hoclVKbGphN1NtRFQwQ2VCUm5X?=
 =?utf-8?B?b2pDYUV6QUVlUlRYN1A3WlZjUk1zLzVFUDh3Tmx0NDh6eVVXNm5RRmhOcnhK?=
 =?utf-8?B?amJnUU9xZTNEVWNycHpQazV2OC9FaXR6VHZKZU5ReHY0WHgrK2I1SlpZMjdL?=
 =?utf-8?B?M0hIZlM2UjZGdlczbmN6TGdhSy9Vd3lpNGlvQ3pxK2d6RnhOMUN5ME14NnZB?=
 =?utf-8?B?NlFIWTBKUENyVHhob2l5bjZPOTFzNlpnWStPOFNMRmdLUGxKMFhidnl3S0hk?=
 =?utf-8?B?YTZjQlgrU1JzMlYxUUIwV2pldFhlSEVaRUgxUW04cnRuenF5K1QwbmlNTVdm?=
 =?utf-8?B?SWprZjQ1WHpYNDRqc2VwVThRQ1RzT28wT2ZvaXJaWnhVV2JMOXhKSDlsQjZS?=
 =?utf-8?B?RzNMb0t4OTBmQldBdFREeTU2VDdocVRVZlV2OWtoUm9lUFlWdm51aSt6OEg4?=
 =?utf-8?B?V3kvWXUwSTJXWStXeXJEY2ZBNzZCY05lQmY1Q3Q0WGRxSmt5a2tVeWZCUmhB?=
 =?utf-8?B?dFJPb0NHdkxqUHAza2RHcWNwYTltT0FWRU9Dc05pbk4wOEIxbzdmM0tYQnR0?=
 =?utf-8?B?L3BDMHZXYzE1ZFZDaHNYMFgwWUpBU3lPaHlSNEw5dzVsenc5UXZScjB5K0FJ?=
 =?utf-8?B?OW5UbUw0bkhHRGRCWEpTWldwVTBSaGk5QXk5T3gyeS9QY1NrVnZYZUdKMFdV?=
 =?utf-8?B?d1JGYm1sckFOSjhDTmE3RHRlSzdBV04vc0d4b216WlFDcmtDTTZvVXhtV0ho?=
 =?utf-8?B?b0dKNG5CWlJzSUZmU2ZrTXVkWWF5SHIyMkwrM0xNY29mSjk2Z2EvMW1mcjc3?=
 =?utf-8?B?RTJkYVp4WlJETW82RnkwZUtOR0JJajRTYVY2VFdxM2RuVi9TTlBrekR1VGk4?=
 =?utf-8?B?azRXdU5ReFYxdEZlazJjbTh5QldhU2lrb2lrMWhQblV1V3ZHa0xKZU5Ddzh6?=
 =?utf-8?B?UEJ3bnFFbkVLYjdUbk9laHBBckprR20wamdBcmhJQ2N3d0kraUF5M09mb3k4?=
 =?utf-8?B?U09nZzk2UVQ5Nlg5SWVJaTJVa3d6cWV5MXM5RVAwYjRGQTJqeWptS2Q3VlRT?=
 =?utf-8?B?TERURGJELzZhNGtYRW0xaS9paGpQUmZ4WWFrMEwzNWFqZzFVM1dtN1dmbCtw?=
 =?utf-8?B?cDZoMjM2MnBNNTRuTDRWcmUrbjYrWjVoSFBqMXZnOWtlY1RRdlk4OVd0dWZF?=
 =?utf-8?B?TGxNU0kwSmFKUER6UGxLQlBQbDlBQUNWWWJlbU1SbHp6STlWOUFhaHgrVzVO?=
 =?utf-8?B?NjJ1TisrWTVYVDAyUEY2a0crRnpUWTNEY2NKU1Y5STBUYW1PZmYybXhOalh1?=
 =?utf-8?B?K05naFAwbXI4MUhWV24vVkNSNmZHSExpbStyNXpyWndUSEJVV1dWSE9ucDVX?=
 =?utf-8?B?Qk4wWTNISnBKS1ZQVWxYUHFQaVRiSmNMcjExcit0OGoxdy93b1hYUE4yOEQ3?=
 =?utf-8?B?V0NGNk5EOTFkWDROTDVrQXJldUtIM3ZmMklBWG5DbHJtZG93SzJnQndoL0RQ?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4CC43904FE369489F1D74A68FDC009B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e266e0-47c2-4e2f-781d-08daa4dac764
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 01:01:18.0954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /a7hFN5dj7axtxRh+aU6mpVFxYRDKXZjiUwWbD4KMPb4M+yYEC0/g5GmtfQ3mAIakF4lD/rXjqXnnOkDv7NvKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6347
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTMwIGF0IDIzOjMxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXN1bWUgdGhlIGd1ZXN0IGltbWVkaWF0ZWx5IHdoZW4gaW5qZWN0aW5nIGEgI0dQ
IG9uIEVDUkVBVEUgZHVlIHRvIGFuDQo+IGludmFsaWQgZW5jbGF2ZSBzaXplLCBpLmUuIGRvbid0
IGF0dGVtcHQgRUNSRUFURSBpbiB0aGUgaG9zdC4gIFRoZSAjR1AgaXMNCj4gYSB0ZXJtaW5hbCBm
YXVsdCwgZS5nLiBza2lwcGluZyB0aGUgaW5zdHJ1Y3Rpb24gaWYgRUNSRUFURSBpcyBzdWNjZXNz
ZnVsDQo+IHdvdWxkIHJlc3VsdCBpbiBLVk0gaW5qZWN0aW5nICNHUCBvbiB0aGUgaW5zdHJ1Y3Rp
b24gZm9sbG93aW5nIEVDUkVBVEUuDQo+IA0KPiBGaXhlczogNzAyMTBjMDQ0YjRlICgiS1ZNOiBW
TVg6IEFkZCBTR1ggRU5DTFNbRUNSRUFURV0gaGFuZGxlciB0byBlbmZvcmNlIENQVUlEIHJlc3Ry
aWN0aW9ucyIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENjOiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gDQo+IEVmZmVjdGl2ZWx5IGNvbXBpbGUg
dGVzdGVkIG9ubHksIGZvdW5kIGJ5IGluc3BlY3Rpb24gd2hlbiBhdWRpdGluZyB1c2Ugb2YNCj4g
a3ZtX3NraXBfZW11bGF0ZWRfaW5zdHJ1Y3Rpb24oKS4NCj4gDQo+ICBhcmNoL3g4Ni9rdm0vdm14
L3NneC5jIHwgNCArKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYyBiL2Fy
Y2gveDg2L2t2bS92bXgvc2d4LmMNCj4gaW5kZXggOGY5NWM3YzAxNDMzLi5iMTJkYTJhNmRlYzkg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvc2d4LmMNCj4gKysrIGIvYXJjaC94ODYv
a3ZtL3ZteC9zZ3guYw0KPiBAQCAtMTgyLDggKzE4MiwxMCBAQCBzdGF0aWMgaW50IF9faGFuZGxl
X2VuY2xzX2VjcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiAgCS8qIEVuZm9yY2UgQ1BV
SUQgcmVzdHJpY3Rpb24gb24gbWF4IGVuY2xhdmUgc2l6ZS4gKi8NCj4gIAltYXhfc2l6ZV9sb2cy
ID0gKGF0dHJpYnV0ZXMgJiBTR1hfQVRUUl9NT0RFNjRCSVQpID8gc2d4XzEyXzAtPmVkeCA+PiA4
IDoNCj4gIAkJCQkJCQkgICAgc2d4XzEyXzAtPmVkeDsNCj4gLQlpZiAoc2l6ZSA+PSBCSVRfVUxM
KG1heF9zaXplX2xvZzIpKQ0KPiArCWlmIChzaXplID49IEJJVF9VTEwobWF4X3NpemVfbG9nMikp
IHsNCj4gIAkJa3ZtX2luamVjdF9ncCh2Y3B1LCAwKTsNCj4gKwkJcmV0dXJuIDE7DQo+ICsJfQ0K
PiAgDQo+ICAJLyoNCj4gIAkgKiBzZ3hfdmlydF9lY3JlYXRlKCkgcmV0dXJuczoNCj4gDQo+IGJh
c2UtY29tbWl0OiBjNTlmYjEyNzU4Mzg2OTM1MDI1NjY1NmI3ZWQ4NDhjMzk4YmVmODc5DQo+IC0t
IA0KPiAyLjM4LjAucmMxLjM2Mi5nZWQwZDQxOWQzYy1nb29nDQo+IA0KDQoNClRoYW5rcyBTZWFu
Lg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQotLSAN
ClRoYW5rcywNCi1LYWkNCg0KDQo=
