Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767E67BA396
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjJEP6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjJEP5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:57:01 -0400
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2050.outbound.protection.outlook.com [40.107.135.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AC11B6;
        Thu,  5 Oct 2023 06:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhzrVdLOyo6Yx0w8Idk3vQBYkyofeYodDT8w+vOykS39mObnRfl8W9Vj/zhf7nLu7/vHF9P0bWmNKAbAfwhz5bTnyWVlDVvVV1UY0QVqbUd5gPnTaQh65Vs+HJQD0PwawtCUEyUPky+iLI5EDvU4UOel4qDLE+68cnlOTOCUVOf1IRgDaHpyiFM6PazLUcIJCU8I5YY3ODXt5jW1+5UG8GZx6JMEIDJHtUVgsRQDf/RrIQeaDe8ds+qF44QfUpHQr3IyuaAfWQvXZtOdeTvUDYyhFCkYaae7SQwcT8WS3LTI3Q3lY/oEGL/mDD0PJq4LpRqvSZJ+EoVy0Z4AcG+xMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcS7efuc83YWnyfCrWh1DHMRnhAdhZnxL9r07/Tq47Q=;
 b=gIKWBo+KuNjchnrZ9Lv8ogoGYQWoah96bfH0MSzN5SvG2Y51GLkj6Ru1t3Osz8vRMSyOfS5O6KI/f0emPNrV1RIRbkgBV1tB3E2vdfEk5CsI97LeJXuJLamrHRvVEa+CyqQvz1dHjqAKLTuB2u34rh0ZCMBhYlE/lCWLqsrVUGPV5FD7tzsnv+JCQmkYmh7iadu7IklbMDdZWrIlBoZ3y8ApMIHi1Z4PVU0wI+Z1vY8/Ntb7MTY/d4UApkOO1zANGgfrC0o2pPrrg+A/nwSzHBQ9UNYcdqBulgFCriudnPNMNOd1dl9ThZ9EvxecT7ApyZ572s8r1K2Qf5jMqzM6Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcS7efuc83YWnyfCrWh1DHMRnhAdhZnxL9r07/Tq47Q=;
 b=okRFIdOyvewlj/VL+XGihaPiziJg9ztqkNB1Hf7y7DcafuOgi02/zlv9YnC+nZVxnyeDZXUxSDC6x1kYSV7hjphx2DZgjR/lJu5zguiohf+m0Up8vzZ496N0qI20FkW4m8ltG4S2UPEofeD8ih5e0oNxeETyHYvxKwvcO0tpPdoijMNDSbHA7yPRuTrFdInwGZz2Zd4gXFze1UXb27Ur+fIhCntPWQOUwFuwhHNgr4eHQl1QkJES0WfDEaPbMyJtdIYzCTeiFTT4ZdlZ10vRKSbhOWDiOMVYR6QEIA5mjuUQ3QVSqEwW9af77XFn7oCrLUTJaG02ywgkbrJ7vfpJDQ==
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by BEZP281MB2503.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.28; Thu, 5 Oct
 2023 13:48:30 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 13:48:30 +0000
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Fix partially uninitialized integer in
 emulate_pop
Thread-Topic: [PATCH 1/2] KVM: x86: Fix partially uninitialized integer in
 emulate_pop
Thread-Index: AQHZ9sgUMiwno/GkWkCKUcl7BrM7o7A5u0sAgAF8YoA=
Date:   Thu, 5 Oct 2023 13:48:30 +0000
Message-ID: <1b0252b29c19cc08c41e1b58b26fbcf1f3fb06e4.camel@cyberus-technology.de>
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
         <ZR1_lizQd14pbXbg@google.com>
In-Reply-To: <ZR1_lizQd14pbXbg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR3P281MB1567:EE_|BEZP281MB2503:EE_
x-ms-office365-filtering-correlation-id: 447fac78-9168-4938-7f9c-08dbc5a9c276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5oAYxJSzlkz+pATNl9UQJAwi1eBb4Cc3zXMPLE0DahObg/uuE2At7zt4Aq2u55PfApLpUBxyqnWZ79rq4J97Fbke8X2NEe+eE9I7LPJWfl5Ghhz2SDMlz8V4zwGJ61KXzCA7R4216jGv573qkM8X245oAniZYn+kYDT1XECg/1N1RKPRFe33MCF+w7CqC0cenLTX0W5beNNFtBhWlwE/ER4JVLFrMwfAwLmcHixiWBqRzStYw1Y//YCYNQUC3lWDeSjRyz3BzFV+ssQZSrA60x9Q/hw3aFJD0KDpNStduqGI3aS3JR/2c1GuBZqNP4OZ4wvxnpgdlddOsVKOWaBj78MKMNu66Q4J3mGaBN5eHDhghNiWmTdXMFYXiS/iG7jCMojTc3ImLFtuPXVOXAaOrWmqRJWWt+t4H/3bS6OB6l2nYkMJernDtkkS11mVbCGuq4biTfPYOYZR4vkkOLvHlFs5IcXJNY4g9oXVK4Zz6vmS9YjTuIvEMPkGSbXBH+TuEsFk98NlJl2Yq9IV1jmnwqgC4NFK6gWdSwQI4IkXcMeYVcOpi8zzpDtSiFWa8249SWLkST9QQ1PRCEObpCBIp5b/KLt+qlovxrUfKJ38d0ry+gR9CGJ84Z2YyJ9X3JoLMR9xGrWKFPm5oUxD325HQV9hb8LuInGVhcVo5Kj6l24=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(396003)(136003)(39830400003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6916009)(122000001)(44832011)(316002)(2906002)(41300700001)(5660300002)(7416002)(8676002)(8936002)(66556008)(4326008)(64756008)(26005)(6512007)(86362001)(6506007)(54906003)(6486002)(66476007)(2616005)(71200400001)(91956017)(66446008)(66946007)(38100700002)(478600001)(38070700005)(36756003)(76116006)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aytHemRwak1lN3RoclNuS05DVVd2OUZJNEJ3MkdYdm5RSEQwT2Y4UnYyKzh3?=
 =?utf-8?B?RmR6MGFIdFRHeVV1b0tJWittT1RxSi93NzErV3VHVWNocXFYSmtsbHlqSGQ4?=
 =?utf-8?B?VSs2cnVXaDAxUUZTRGc3cFZuOFZLRE5VWXAxVU5TTE1pQnBXTlRUaXNxcHNm?=
 =?utf-8?B?Rll0NWpqUkJnZ2VYS284TEVma3Q4QmlkRDRxVFc4SGYyNktZQmZQUFh5S2Qv?=
 =?utf-8?B?N2xFQTVCSnpJcm8vdXJkc0ZvK0RRSE9ERHozOWVwKzdqak1EUU1uUUY2MVBh?=
 =?utf-8?B?K1o3eGN6K0FGbHp4eUlmcmx2ckpqOG4ycmRicUlSMGlQcXFTWXROZXBjdmky?=
 =?utf-8?B?L0xNT3pWK29BWWZ2VGl5QXYzYUR6NVNwK1laQ3N6NW5uaWQ2ajVsSEdnQUJI?=
 =?utf-8?B?Mk5PeXA4Y0dkRS9nR2h1dVRGQ29UR0RKS01NWkhQNmFpbVIwbnhGVUVnQmMv?=
 =?utf-8?B?S29kalFjbXFSZHRBRXFLWGl6MGJkNm9ERFFxdVp6Tk9Gc3ZzMWkzbFcrdENZ?=
 =?utf-8?B?TGFNcFJrUWd1NFZrWkYxQ2twNFVURDcxYmoyTU1raXFnL3R0ZWVMSkdmb1R1?=
 =?utf-8?B?enZUQStSVE9saUl2cEx6MDNXelplczAxcndCaGxxdmVBbWVqTkZLV0ZvOVJj?=
 =?utf-8?B?NjgyWmk0ZEFkUmtTUXBydUlMa1pEaCtSSWs5NkduNmdrYlZ5bjNvNWQvdk1U?=
 =?utf-8?B?WlJMZHZ3d2ltRHZKK3Nxa3FUUVFVT3J0VW12Y0hPNVEwWHRld21RbVRDUDBP?=
 =?utf-8?B?SEo3OFFtRC95V090ZDdsU0JDc1pNRTE1dXE4VnJQNlhaVkF6OVBLUlByblVj?=
 =?utf-8?B?UExSYVFNZkVDUmFJbjZMdmxiYndYN1pjUDFiOWN4QTVQV2VGNTRnQmRNcmJa?=
 =?utf-8?B?Y0RQUEYraEptcW9GSjJLZDZrZmI4TG9xTENoR2NPRU15YlRFamttZVdzWnRo?=
 =?utf-8?B?ZzlKVmlKbUdMWHhlci9ObXd1UklONFRvU0ZWa1hUNUFIMHprd2lqNHRWZ2Np?=
 =?utf-8?B?VXduK2FEVitONjF4d0RjTzN1N2FrU1NhVTZ1Yi9GOE1ZOWJtN1hXSHh2Mktl?=
 =?utf-8?B?Mkw3MWRvVzc0TnpsM1h1a1MyMmQySklwczlSZjBaaFhab2pnUzFqRjlYOWNT?=
 =?utf-8?B?c3owNGMydlAyY2lBbGJSTCtHblRLdnRuT3VhaEgzUCtzNUJ4a052VnBjV0FP?=
 =?utf-8?B?aXFSZmZub3BPMCtiVEdPckt3em5hZHdoa3BKMWExSG5hamU4VHc1SG42c3VN?=
 =?utf-8?B?MXVPTXROaFgrUUV3NzVuWld4TXo5U2c3UVdXWEZEOHQrNUJDL1dLMjNjM0Zz?=
 =?utf-8?B?VkZKQ2llUDVpUmd1dlRBUk9xdmt3Z2FjWEllYXg1U2s4RVJZM1lZdUNvMmFt?=
 =?utf-8?B?Z3NPQm1oVkVYVHI2dHR0OTlhTXpzNkVxMmVKdWRTV0pEYUJWb3ZHSVZZWG5a?=
 =?utf-8?B?alNDalZnZjFGdEFOVGI5WlFLQVowUHkyMlMvMVFZQ0RHSW1xYUxKdTlDRWhT?=
 =?utf-8?B?WGkyY1dzQUdCbWVCbjl6amk4dk9mNFk3OEtvaWtsMHFQQnZoMUVYeXA3eWZG?=
 =?utf-8?B?KzdpNXBhb3h2NElrdEFJRTUvcnpyaUtFa2FMdnA4M3pId1YzMGZNU2Q3bk5L?=
 =?utf-8?B?Uk5JRzBvcnlGd0xjYkZ3TTMvV0h6amJieVNrNWNrQ0tTMVpkTHNjSmFwNVIw?=
 =?utf-8?B?ZDhmb0ZIOXovR1BwN252U3dZWFVSYi9zTTV6cU1mM3VxcmZuRTh1VHpiNlJm?=
 =?utf-8?B?TU92MU5TOTdJWkpoSDhSZGhTa0dSMmt2TjlQSlBPQXlGQUpPeWg3NTI0VkNS?=
 =?utf-8?B?Z3ZsL3UrMjlWRGwrd0Z2SDVYMkRpMXNqajc4SFYraCs2VU96anREUXp6aktH?=
 =?utf-8?B?eTF5aTJ2MGQ5cysxMkFvak5QZDVMVXFvZHVEY3lXQWNTMFdhWERHaW1LaEFw?=
 =?utf-8?B?cEt0ZUVjZmZ1bUhCeGphVzZwU3ByQzBRZW00dm50UGIyQ1U0dW5BcUZKSFVv?=
 =?utf-8?B?ZktOUkhEZ1VQVVFFSFdBU2liZ0doeDQrMFl1U0FnekJMQUV3SW4vS3Z6ZmRN?=
 =?utf-8?B?azUxRXNkeUxtYW1xMjdOQXcrSW9mUE5GTkRtSG0zZnVCUUtXM3hlMFRXcVVU?=
 =?utf-8?B?bC9BSTNhY0VJOWlWQjRMaFkyZmxPYlNNTSszekxsTjZBVUg5aTJzNXpvNE9U?=
 =?utf-8?Q?VOkr4aPPLcHl/wVkOhDMn3Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBD1346642811F4CB4846ABFA2ED0F01@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 447fac78-9168-4938-7f9c-08dbc5a9c276
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2023 13:48:30.5468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHhzdvlOhj00aNIoV/3ssblMv1YR83ARQPRnLckYunEXvubyhm6CvBFtImjd5PSQzGI5vppkIimQaMrH/ZKu+dxDi+wtPBPBBzvQeYbbU1vBjnwjEHfSQnQILDuzm2FC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2503
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTA0IGF0IDA4OjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE9jdCAwNCwgMjAyMywgSnVsaWFuIFN0ZWNrbGluYSB3cm90ZToNCj4g
PiBNb3N0IGNvZGUgZ2l2ZXMgYSBwb2ludGVyIHRvIGFuIHVuaW5pdGlhbGl6ZWQgdW5zaWduZWQg
bG9uZyBhcyBkZXN0IGluDQo+ID4gZW11bGF0ZV9wb3AuIGxlbiBpcyB1c3VhbGx5IHRoZSB3b3Jk
IHdpZHRoIG9mIHRoZSBndWVzdC4NCj4gPiANCj4gPiBJZiB0aGUgZ3Vlc3QgcnVucyBpbiAxNi1i
aXQgb3IgMzItYml0IG1vZGVzLCBsZW4gd2lsbCBub3QgY292ZXIgdGhlDQo+ID4gd2hvbGUgdW5z
aWduZWQgbG9uZyBhbmQgd2UgZW5kIHVwIHdpdGggdW5pbml0aWFsaXplZCBkYXRhIGluIGRlc3Qu
DQo+ID4gDQo+ID4gTG9va2luZyB0aHJvdWdoIHRoZSBjYWxsZXJzIG9mIHRoaXMgZnVuY3Rpb24s
IHRoZSBpc3N1ZSBzZWVtcw0KPiA+IGhhcm1sZXNzLCBidXQgZ2l2ZW4gdGhhdCBub25lIG9mIHRo
aXMgaXMgcGVyZm9ybWFuY2UgY3JpdGljYWwsIHRoZXJlDQo+ID4gc2hvdWxkIGJlIG5vIGlzc3Vl
IHdpdGgganVzdCBhbHdheXMgaW5pdGlhbGl6aW5nIHRoZSB3aG9sZSB2YWx1ZS4NCj4gPiANCj4g
PiBGaXggdGhpcyBieSBleHBsaWNpdGx5IHJlcXVpcmluZyBhIHVuc2lnbmVkIGxvbmcgcG9pbnRl
ciBhbmQNCj4gPiBpbml0aWFsaXppbmcgaXQgd2l0aCB6ZXJvIGluIGFsbCBjYXNlcy4NCj4gDQo+
IE5BSywgdGhpcyB3aWxsIGJyZWFrIGVtX2xlYXZlKCkgYXMgaXQgd2lsbCB6ZXJvIFJCUCByZWdh
cmRsZXNzIG9mIGhvdyBtYW55DQo+IGJ5dGVzDQo+IGFyZSBhY3R1YWxseSBzdXBwb3NlZCB0byBi
ZSB3cml0dGVuLsKgIFNwZWNpZmljYWxseSwgS1ZNIHdvdWxkIGluY29ycmVjdGx5DQo+IGNsb2Ji
ZXINCj4gUkJQWzMxOjE2XSBpZiBMRUFWRSBpcyBleGVjdXRlZCB3aXRoIGEgMTYtYml0IHN0YWNr
Lg0KDQpUaGFua3MsIFNlYW4hIEdyZWF0IGNhdGNoLiBJIGRpZG4ndCBzZWUgdGhpcy4gSXMgdGhl
cmUgYWxyZWFkeSBhIHRlc3Qgc3VpdGUgZm9yDQp0aGlzPw0KDQo+IEkgZ2VuZXJhbGx5IGxpa2Ug
ZGVmZW5zZS1pbi1kZXB0aCBhcHByb2FjaGVzLCBidXQgemVyb2luZyBkYXRhIHRoYXQgdGhlIGNh
bGxlcg0KPiBkaWQgbm90IGFzayB0byBiZSB3cml0dGVuIGlzIG5vdCBhIG5ldCBwb3NpdGl2ZS4N
Cg0KSSdsbCByZXdyaXRlIHRoZSBwYXRjaCB0byBqdXN0IGluaXRpYWxpemUgdmFyaWFibGVzIHdo
ZXJlIHRoZXkgYXJlIGN1cnJlbnRseQ0Kbm90LiBUaGlzIHNob3VsZCBiZSBhIGJpdCBtb3JlIGNv
bnNlcnZhdGl2ZSBhbmQgaGF2ZSBsZXNzIHJpc2sgb2YgYnJlYWtpbmcNCmFueXRoaW5nLg0KDQpK
dWxpYW4NCg==
