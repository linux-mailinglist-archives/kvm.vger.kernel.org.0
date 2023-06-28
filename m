Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E5F741742
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjF1ReB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:34:01 -0400
Received: from mail-westcentralusazon11011010.outbound.protection.outlook.com ([40.93.199.10]:38387 "EHLO CY4PR02CU007.outbound.protection.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230526AbjF1Rdy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 13:33:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4e162BqC2+AyENZJSyAUHP96ljS6TuoxP11OJoqXPdb79gre2CLk1LRWAMzXs0kwdd8WvAIg1w8PePLdLzp0KawXKqU/xjpt8oOMDwWyv1Hr/uthfz/ny4YIBix/Sq40IjoZsLcXzOzuSxVxUtlxSm53bV/esMRGvVwdTJ1EwmoD4alfYKN8Bs99gYxTSTtZ6IhrFAxawEu4Le8UwOOnu4Oo/3YdH/phv4oEvQ36WJwhtMdgrzqKrWFi+TxN40cfoYqvbsD9IzJPfW5RSThSzc4v+E5y6JSqjDMRklY9HT+hxaph1IFcmWObnsiD2NNjE35OIZljYx2hFAO1k1kPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yabjuDzllfilhXnpTJMXOzyrSsjHMXo3/FxgSrt1sYc=;
 b=PjwQ0y9tNIqAXRRxPtBy993/fVKJU49XGnkW5hGHaI51NPU35HSKahkJpUxxuZ8WOvrql3QOi3lTwyGoMAej+IB5FmPxJeb88tX8FRzNr/dR+TGANCuzoPLtXBKQW2QzWmSovqMQcCX+2N683RDrpGPQ1kL07Kl2VHjN1V1xiWi9PFgecdjjBRem/2HRZLeRVIYHuD0cAv85HZvOoc73AWW4BBlJH4ZEgL6vib4j+33IqPMX++ZGmPOr/X8IiNj/LyNXCfIrN/ZvBwDNcIDesv0ukxRj4lgUPW6zEOigFK65XPobK5LSKxfqThmMB+TgBrshyT/rJ4eVsfL7P+M7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yabjuDzllfilhXnpTJMXOzyrSsjHMXo3/FxgSrt1sYc=;
 b=uyLt/+qEcD/X55mzBmUKhHNmDQPUlnqCb4nKlDGVc/Y62vlGZbyF5I4dSerHzFNUSt6s0HKXZdmAaWVv64dON63tf04/4OrHjm/FbjIQQf03X7Ss3EwWAroKnpxpUbnL2yyZUM/BYgNmcT0rNB11aARIONZeWAgknZbZqhf7r04=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by CY8PR05MB10130.namprd05.prod.outlook.com (2603:10b6:930:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 17:33:52 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 17:33:52 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Thread-Topic: [PATCH] .debug ignore - to squash with efi:keep efi
Thread-Index: AQHZqVWDf5w4tNQCEUqmflxCd5u7pw==
Date:   Wed, 28 Jun 2023 17:33:52 +0000
Message-ID: <1377A285-1B0B-4D35-9C01-FE71EB5760FB@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628-646da878865323f64fc52452@orel>
 <20230628-b2233c7a1459191cc7b0c9c0@orel>
 <848CBDF7-51AB-4277-9217-B43B566CF60A@vmware.com>
In-Reply-To: <848CBDF7-51AB-4277-9217-B43B566CF60A@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|CY8PR05MB10130:EE_
x-ms-office365-filtering-correlation-id: bd8bcea6-f3ce-42d5-ef93-08db77fdd75f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 99yKV6XqciSppM1MKRaxtw19tFNHNsGaH1y5uTnDHrBFGmrsQohO47i9UNRnpZCvur7NEBXZTEgDO5Eerecg9Ed2lSn3CqXeoTOxqFdEpqsTPzK0kzfg+Gsisrw0gNhkzVHBpQ92aBlq4PMKGWaTTA4MZSgSFcAJMGibnX7xVZ83WLYFUeDo4DsnifZannhF2PLRK+dg4UOYQLFqRPXMw2Zh1IxOJO5ZcEfRkPRX21wa7CE10g9T67OTfjcXXOIQ8tSiiIeBXEiwNlkY+2pcXoCsGr6dWvRufr8TLLHysuaw/agKzcKR5KhzufHN3v4iYdFtS/kr2rlyeLBrkQEy3UyF58eTJkWSN3uZEulSBA8Q7B35ww8SyHysEJunoPPtHe/9bRgpFiyrz7+64A6pk1/cOI0FUtSNy9vSxXD5rQn4Tcthh+oKK6/7NUoelF3HUNALpCRMEIcgvyX4bkH9LLePZV8T9ggmKRCl7SwxV4GOSA+f/eyoyaDIKofDxOG+Z40U4fmTx5RQIp/0HdgRNoR8qIJ3IVJPoFiEI6Ekp2Oujb7ZrG62pWelUHuzhOK3z8z/xsuRhPfWC0ofDouZFfQ8S72kJIrFHk8Bi1bmNR7nDWP/O/sFIgcBfSZ07EHyeIBL0M+4qdVRF7cDURpmhGs/7+ahTSFn8zsK8zKOz3WrpV9UiPEv0P8XnXmk0EKQ0owhHePqTCWW+68nBxdPqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(38100700002)(122000001)(38070700005)(36756003)(33656002)(86362001)(2616005)(54906003)(8936002)(6486002)(66556008)(41300700001)(71200400001)(66446008)(66946007)(64756008)(76116006)(66476007)(8676002)(316002)(53546011)(6916009)(26005)(6512007)(4744005)(4326008)(186003)(6506007)(478600001)(2906002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFNib0x5UmNyUXlVS3I0RHFuNFdRZksxRmMyRFZUR0ZuSzJwNUV4c01DMEZC?=
 =?utf-8?B?dEFVcm9LT2lWdmF2SGRkK2RjaEZEWmxZRmp3b0QxbVBGVnlxK0d4eTVSYk01?=
 =?utf-8?B?ZjJjTDY2N1MvL0t5ZElQNlVldVNxQlBWR2czeDRvdTFDN1V2MWVmUXJ1c05T?=
 =?utf-8?B?bXMyRDRaTEZsYUJ5UEcyMHo1dUM5Rmg0VUU5SjIrSnBYcTVrdDRyN0VGQmlF?=
 =?utf-8?B?MHJ4SFVWbi9JbDF3c3JMTkMvWm1CTVU4dTgwb2pSR0lsNUhzcnlLd1NlVWdv?=
 =?utf-8?B?WW9mNFg0UjJ6RzlQQ3ZnS3BhclFzVTJDcGVzV3lJMEYrYWI3UithbURMdkNt?=
 =?utf-8?B?VUdIemZaTEVuL2xaeStvM3prWlo2VWlmTWMzbDl6RU1wTS91QmlyUE40Q1Ni?=
 =?utf-8?B?ejl2Nkc1R0lyTHljc1R1V0p0MG5KaXd0cGFUbVZ3SEMrNnJTQnR1bnIxemhK?=
 =?utf-8?B?OGxKOExmOWFyb0c2dERNdVR0NTk5MDg4L084S2NEaFQ3WXp6Z1FIK1Q0Z0o5?=
 =?utf-8?B?K2RVZGpZUjJ5NktiNjNBN0RLbGQ1Ni9ya3RydEkrTWF5cnRHZkVoYytFd0pK?=
 =?utf-8?B?RmNpYTJybE52ZlVKUk1URGFhN3M5Qm96S0dZU1RZbVJwVlNDaG5ENy9EUUNB?=
 =?utf-8?B?UXVkVGN5NEFnWHlPV25ibTh1NDJXVkNhcHRoWFU2UmdBNDRiamxYT3ZhM1NY?=
 =?utf-8?B?S3E0ajMyanJic0Zsa1RWMG5PblJxWng2RlRKUTg2MGJOa3NSTHVFcTdVQk9K?=
 =?utf-8?B?ajF0Uk1tenFGR0FmMnBMTkRMam0vOC9jQUEzanhRTEZMREdqbUtZWlhEVXNL?=
 =?utf-8?B?RDVSZEFKbnJyNDJ2RHU1Vk1wRitYbXpMeWZUaS9RTnJJUS9UNXRYQ1Z2Nktr?=
 =?utf-8?B?M2Ruc2JsZDE3RGpWdjkwVGdNa21mRGd0YXl6MVVaQysrdmxOZ3JvS29xMjVF?=
 =?utf-8?B?YndQNW9hemc0VkdaeS9FVzYveWpPT0VtWGIvcUlTcm1vMzloRERNb1RLOHFP?=
 =?utf-8?B?Uk8xZnhmdHVTTEJXb1VYa1QvVmZRdWpnV2pTak1KOVQyelpyR3YrWjgwTTN2?=
 =?utf-8?B?ZnF3QmFjaDBDTHV3dWR5UCtHUFpzOGpOQzZ3NkNKaktlUnFlSkJFUXZNaXJ1?=
 =?utf-8?B?dUtXQ1JhNlovYnZ4aVlMalIyVFlYeVNCWmFGdmRxYmlCdWo2U0pIY0o5akRS?=
 =?utf-8?B?bkw2bld2cEErNDhSMXd6bEJxSm9pSU92SlFLT3h1QjVhMkk4Uyt6b0cxZ1ZY?=
 =?utf-8?B?QS9pTWV2YnYwZStnV0xLQUM5VjVrRmZrK2hubDlrNUVGZjVsTFNVdUlaUDlT?=
 =?utf-8?B?WEI2WlI1S0RaK2xRUjVXcCt0QXpuM0UvNFFxdmpobnNZaFg2OUNhVERFSEV4?=
 =?utf-8?B?WDU4SDNQZDgvTUxSSFpRcDZZeW5TSzVZd0Y1WVZvNDdlY3JteUl4YmVZS1lZ?=
 =?utf-8?B?ekUvM1U3MmJWVER3T3RNMmtBQmx2M3pnSzNvaXNTeWUvT3lsT2hqK0dNZXVE?=
 =?utf-8?B?cFR0Qk9UR1liWW9rc25WL0lsQjZod1BDSzdLYWRFcWtZVDRpUEl1SElUV2R0?=
 =?utf-8?B?S2hWYzA0TlpITXBZd2hYNktuTDFiYlpwa1FXbnMzZnZ4eUcwc3NNdVNPYUZy?=
 =?utf-8?B?THJvNnVVWFEwM21PY0JqN1R1dDFGSmxIeXJhU1U4NnptemdrR1pUcjhobjIv?=
 =?utf-8?B?QU1FYjJ3L1NzMzlqRlFTYitkNWp4WURRclF5TzBQOHYzTktZVnRZV24xU3ZL?=
 =?utf-8?B?dFVGV01iRjkwc1hpNkdTRXU4Q2NqTEl6dVVZUm9jdncrMWI2MzJORk1YTkdL?=
 =?utf-8?B?aTB0elY0ekdSQ0hUUW5jeGpqUkUrK3MyYm5DeGovYmlmNStrZXZ2UVc3c093?=
 =?utf-8?B?N3JML0pUSDUzNXBNVW9oRTVQOGg5MGRrS2JkMEZDeU8xYlBEUjZINEZ2ZmpO?=
 =?utf-8?B?QWhJN2lTNk00Q29BYytob3ZiQjFZcWVBWEVSa3MyaUtFTXErVU9ZMHFlWFQ1?=
 =?utf-8?B?aEQyNnJlOENlcS80Wi9YemNnZytudGVEV0N1MU1ncGkzMlNWQm40emhXVGZE?=
 =?utf-8?B?aWxCSWhwV3FkWkdDRjVQSEtnY2s2SVZxSEF4YmozaTQraHZLNEZMK2wvQmcy?=
 =?utf-8?Q?7E4SKi2lOYqfYk9ZZl07VsD88?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7AD9327D22D7C4AB01346C6C52A2C86@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8bcea6-f3ce-42d5-ef93-08db77fdd75f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 17:33:52.6579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebWH0E/6BvuXz3zpmgjLRs+u+d4+sXVPbKLRpa+mh/DsDRNGzf3nXK3+u5NTGsdm+jAtlj2TLdV7ZLju+h++3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR05MB10130
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDI4LCAyMDIzLCBhdCAxMDozMCBBTSwgTmFkYXYgQW1pdCA8bmFtaXRAdm13
YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBKdW4gMjgsIDIwMjMsIGF0IDE6MjIg
QU0sIEFuZHJldyBKb25lcyA8YW5kcmV3LmpvbmVzQGxpbnV4LmRldj4gd3JvdGU6DQo+PiANCj4+
IE9LLCBJIHNlZSB0aGUgLmdpdGlnbm9yZSBodW5rIGluIHBhdGNoIDEsIHdoaWNoIGlzIGdvb2Qs
IHNpbmNlIGl0DQo+PiBjZXJ0YWlubHkgZG9lc24ndCBuZWVkIGl0cyBvd24gcGF0Y2guIEknbGwg
anVzdCBpZ25vcmUgdGhpcyAicGF0Y2jigJ0uDQo+IA0KPiBFbWJhcnJhc3NpbmfigKYgV2lsbCBz
ZW5kIHY0Lg0KDQpNeSBkb3VibGUgbWlzdGFrZS4gU28gSSBzZWUgdGhpcyBwYXRjaCB3YXMgbm90
IHN1cHBvc2VkIHRvIGJlIHNlbnQsIGJ1dCBvdGhlcg0KdGhhbiB0aGF0IC0geW91IHNob3VsZCBo
YXZlIHRoZSBzZXJpZXMuIExldCBtZSBrbm93IGlmIGFueXRoaW5nIGlzIHdyb25nDQooYXMgb3Ro
ZXJ3aXNlIEkgd29u4oCZdCBzZW5kIHY0KS4=
