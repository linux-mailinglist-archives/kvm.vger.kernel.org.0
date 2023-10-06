Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E7B7BB3C5
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjJFJE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjJFJE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:04:58 -0400
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2060.outbound.protection.outlook.com [40.107.135.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C9A83;
        Fri,  6 Oct 2023 02:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQPPonGXjivErNsWbjqGNUlSTMpa8fb3dTCM/6miL+pUdSI3m0CQyqtcqQxVeta7ZGQ+/HQ8IABbxET3N2+tzfV1zjHg0wBycONSREI7E3HRweZ78r/zD4Z2LxY77Wsna4ryCVs15GaNeDsD7p2sZ8g1O+2RUrOoRmJxEUsvAztp43CAbp3BDXTdI4RG6UOlzvTMjE33zQXzsqHlC7rl6WMDfBVkQ6eNZnQWerUGLBWGv5TY4miZ9RfHKXzsE2i43D9gYUyuXCXrVbSn2600gB2rJPngdjkgYkmwAjL+H+ym9j9gKot4PzI8H53U1OoFeNm7qMYAbk0W8HUSuE4icw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlziEtzvNdV1O83ATNqeYqcWQPgBlUh67XlU/ew6AnI=;
 b=AdhF+dnG6BWwKNq4MSNmN3E84e5w/chJFyXWjtJPD1BhnE9WcZlbWEMqwjShTr8yPEtMhMYxRfu43lpdP+wCj8h2R/Vqg0pM0aaaasImwhlUM9nOluzdS+N292iD7Bp4mSjhMXdWq+Y5oYfZ/sTjBGhy6zvDrIThzC4dxGVfI+2sATx/V4jm3UAijhrdc/ift+ItJMeh4NqHK66FMbxahrCywq7AmtMxW3Cm4VEhQM+aezXzVvn8unC0Ve2/qa+M2G/cgo2WEuGwcZf7vE9YcKClN/LuC9BkZHgylTUkxBwZQSOh0WV73sqXOgNzuQJkkMmyWblDFGaKhXbv81zrLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlziEtzvNdV1O83ATNqeYqcWQPgBlUh67XlU/ew6AnI=;
 b=H8++4EsOuNq8flH0pWUNOZLzROTEmtI4zERn0Loh1KN+CaqB9ur9YbQ35pVTEDxZag6/+fhg9wUa31J8p/fkJGTrZW+QsjlbYIsG6jEnjggPxVGlmfSSoSEJBuBRUAcc95wvWELr3t1JZ7HMswVeXA2rRjkihfqPTjW9sd6drpdLl/zlHpx0rV7xROQVnpuj9thV6wI8nfpKGSsSHqkFReaIVAu0aqzic3Miu00jFLcnMLurzSBJNxH4ZSzLP41nv+DPF5kZcy4BP01nCwMYbmKyDR5xYjRO2NKodkgpjVl/Sk0j5Ox8/DL0y0iy7sZxXT5sc2ckyzBbMah2seToaw==
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by BEZP281MB1846.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.38; Fri, 6 Oct
 2023 09:04:53 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 09:04:53 +0000
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
Thread-Index: AQHZ9sgUMiwno/GkWkCKUcl7BrM7o7A5u0sAgAF8YoCAALrGAIAAiFCA
Date:   Fri, 6 Oct 2023 09:04:53 +0000
Message-ID: <9362077ac7f24ec684d338543e269e83aee7c897.camel@cyberus-technology.de>
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
         <ZR1_lizQd14pbXbg@google.com>
         <1b0252b29c19cc08c41e1b58b26fbcf1f3fb06e4.camel@cyberus-technology.de>
         <ZR9bWv_Fogzx1zwv@google.com>
In-Reply-To: <ZR9bWv_Fogzx1zwv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR3P281MB1567:EE_|BEZP281MB1846:EE_
x-ms-office365-filtering-correlation-id: 653ae8a9-4898-4bca-3d59-08dbc64b4dc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQWlvEL9B+yIwtgr1nOe3W7gVuqqVcMPO38yF7K/W1b8nnmhYLDNfKgZPz4EJ+VbNUTJi7ixQ9i7edxF5hyxAQBiuyKP7C8Ome9i5T+gDz6Nbo2EXrqODNJybfvwqIgVhMIxuRBZXZMY82i33hOcb21tJplExYrPkKOpNRgk8ziZJUpRSMf5eKTj3k9m0TMx2Zry8sY+2wzX+7gzYT2HE1qJUTXfGf4Xa+b+IUHzKKDy+ztESfarY8TQepWgnkft2f1kofyTjZeboqO8MSpnKJVw78u+hDInwEtjEpLsVnOlv7pPxmndMHPlDx+zLhvoifijCQPC+Ytds82iChdIr4B4tXx5q8neh43iy8k1DcsnwOTvBFU0uOS31UtfHVE4kLvRg7wQVaBUrCwlQ6CGMWeJU+4KGH1l0JnkdatGkOfkL9SIKxSXugyG4S/xJVHC352QvF2nufmrYZkhuM6gNr3hbV0ydx2HecIekRVnsWjNfUF9SFg2N79MtjobuEXYlph1OyCQ9p/Kg37f9RVEMzyij3OT1p093uyLBGQYamIRDSW1lY/xvdPopTtkdC9jtzZ+N4uvYrMRyBhpEydB9Nv6fBgIsc6/+VdRhikaEalMZMmOxiZu/+izqjBdLy/W6DwM/CwpTN5jfLSXMpTPYj+gRMsfdLXM2WQGfjewTRw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39830400003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(2906002)(38100700002)(38070700005)(44832011)(5660300002)(7416002)(122000001)(86362001)(36756003)(83380400001)(71200400001)(6506007)(6512007)(26005)(6486002)(478600001)(6916009)(316002)(41300700001)(8936002)(8676002)(4326008)(2616005)(66946007)(66556008)(91956017)(66446008)(66476007)(76116006)(64756008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzhoQ1c5VnZ6dmxpNkRwUG5lOGdQR2lpcllrb1JKMUdJVEZ4a3VGWVN2eXVV?=
 =?utf-8?B?SFJIdDRhMU9qRXFDUGU1bnQvNnJEOEJsZkNZQ0Z0SnlEOG5WRVNqcnUzU2Nj?=
 =?utf-8?B?SnVNTStTUnBqMVJXdlBJSDdrUEx4bnIzcTBhdkZKVmM4M3dZTDlHN2poSUtw?=
 =?utf-8?B?aVZTYk51RUNLTnEwQldYeFk0V2dCOGZEMEtQTU9ZWlYvakVySldHd0UyRDBZ?=
 =?utf-8?B?UlFPL2JkYlpwOStTOGZwV2YwdDYvdk5RMVZ2ZXpkUjBMWTFiSkpHTVliN3Vq?=
 =?utf-8?B?cnlPbjhkZ3JMamdhSEVXSDFHcUdRV20yc3ZoM0phMjJIWnBNZ0hhd05WanI1?=
 =?utf-8?B?OTlGMU42YUJHd2NYaFFoLy9tT1FXMlVPaVBCNFdlNWoySUdtWVVIVEJMZHZl?=
 =?utf-8?B?NkU5VXVxcHRXNjJFSXFGNFI0NWZuSWN2d29LbS92RWYza0QzdEl0VFlXRWFC?=
 =?utf-8?B?eTMxMUZiMmVWa3ovenJLNTdFS2orSUhBQWIzRk1XeDRyUngydGpseTZqbHdI?=
 =?utf-8?B?b0hKNUp1c2pVZlJXMzhGNlhVVW1QSXFLaVFuaDUrcFk0QkNIZ0gvcE9BV3Rz?=
 =?utf-8?B?d014V2ZuY1BSL2ZPOVNLb21PZzJuTk43SGp3TzJ4bklVVkxpREcvVGVJTFF0?=
 =?utf-8?B?aUxBU244blZYUzYwL0ZvWHBaVyt1bnAyamp1YWVjdmViWW5RazF2dlNwUHRt?=
 =?utf-8?B?RS9yd0U2Y2dhcWd4WVFaT1JlOFFkVlVDbUliUGF3bUdIVmZ1NWdSb2ZOUTlO?=
 =?utf-8?B?b0JySjZZZDUzdWN3VkU4cCtLNDI1WDBBdTRBeW1KQTlrQ3JOWkcxU2RmQ016?=
 =?utf-8?B?d1owcm92VThDeDNXVmd2SzhPRDRzdjdvSEZKZ1JqenNTL05zM3FEK20vUEh5?=
 =?utf-8?B?VHdLMkFVMjBrcFMrZnlRQlBIdURndTRRRDBwNmNwbXV0c2Z6dENDVHJLOU53?=
 =?utf-8?B?dEoxcDdCbWM3eTNPMmhEK1FJUlZNNXFoQTNBa05WTDB6S2ZsdFIxNmJqUW9h?=
 =?utf-8?B?T2ExTTBlUGhlQ3ArMVF1U2dXcjloRGhIMHZWWkswS25veFJXaTN3amNxUjVo?=
 =?utf-8?B?K01aVSt2TDl5c053a0d6czRSR0ZEcnRPWGlnVDVUeXpxRGpjRlhIeGxxbEJV?=
 =?utf-8?B?NUpHOWRFWS9hZVRYbkh0T2taRGY2TnZ5Y2JmL29xYzJ0RkVGU1dpMGZFQW9Q?=
 =?utf-8?B?bkwrUDVzMHE4SmVLT3J2NVkzQ2dIL3ZocnRNZ09mUlJPRlNtbmRtU3Iva0pp?=
 =?utf-8?B?Qjh0VFNtUWxwVW5RRGE1S0FQWmV5RU0xN3MrMHUrYVMxeUNjUHdjYzRxRFBp?=
 =?utf-8?B?VWp0aklvR1dPZjNRY1k0a1ltVlR0aTFIS21uU1NNcThpN1lTK0NUb1dWdmlS?=
 =?utf-8?B?SmY2cG40d1IxWWp1TzhCa2pFMytkY3hTYktWUFV3QmtZT1JsNHFkd21uR2Fz?=
 =?utf-8?B?YklSSTlnZWYwblZkQ2ZsM0pxS3EwM2RQYXU3dFZNclc3Ulc0aERHNXBtS1dF?=
 =?utf-8?B?bHJwMVJWYjdwcXM2bFh2bzJMQ08yUUlqQUFhamdtZW4zSFI0M0Yyd01KMmlY?=
 =?utf-8?B?bk9rT2FlK0M1elpySTVEd2RoTU9rY0hIc0xiMzdLV2gxZFoyN0ZNb2hiUm1h?=
 =?utf-8?B?Y0p2N3luREJSZjNhMjVMWGZWWW0rTG9rUGMzSjV5RkJMamp0YnBBbGMxd0lT?=
 =?utf-8?B?WEJ4blJTeUFlQnI1ZTl2Z245bE1vdWNybEtUTWRnOXl6R041Wm51NGc5bzhu?=
 =?utf-8?B?bythRElQN0lHWC81WEtSTEpYYWxtUnFveW9lN280OEJ1ZjJoNHYzekFoKzlV?=
 =?utf-8?B?SkhNeGlCSUk4SThYclpaQ01DNmN5TlRzOGpFMEJ1WEZHMUJqTWFPdHFVUTBo?=
 =?utf-8?B?QURBR1FIcERPNzJyMWlBUk00ZDNON1kxZ3EzVmVFN3htb0cvUE4zMnpOd2I3?=
 =?utf-8?B?cVVGL1JRbnZxQnNqMGozT2hCd1czWkJFUGlsRklPd1ZVcHhORy9CeEh3THV5?=
 =?utf-8?B?SFE4akVVRGNGYTFiZFQvZVcrRlRjVnJlVWMyY0FUUW0waEJzNHh5NWI2eVhW?=
 =?utf-8?B?TEx3cm8zQXIxaHZWODMydmdSVmIzMmd2SXBYTUZwNW9HOXF2QUtsbWFCcUdq?=
 =?utf-8?B?WFhncGhXK0xTdmpxVDlEWmhYOGJ2b2FlMnR4UGNOd0pUOTZyblh4ZUNaSVBF?=
 =?utf-8?Q?sG8l5S06Tjkaguhv/j3QHZU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB8D186B0D2B814EB575EE94D65481DB@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 653ae8a9-4898-4bca-3d59-08dbc64b4dc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2023 09:04:53.2007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJIX8b2xts6c3e/OAp97xPfIdiKcWhVMHmLZStTMiKpD8isKALkJjsEW/7LguGKL9DdcMoPsPSp3fMMSyp55FTTx6e9C0QrQzy45+3Kt0veozuMWm9p4ldf0MYMd/K3/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB1846
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTEwLTA2IGF0IDAwOjU2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE9jdCAwNSwgMjAyMywgSnVsaWFuIFN0ZWNrbGluYSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjMtMTAtMDQgYXQgMDg6MDcgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiANCj4gPiA+IE5BSywgdGhpcyB3aWxsIGJyZWFrIGVtX2xlYXZlKCkgYXMg
aXQgd2lsbCB6ZXJvIFJCUCByZWdhcmRsZXNzIG9mIGhvdyBtYW55DQo+ID4gPiBieXRlcw0KPiA+
ID4gYXJlIGFjdHVhbGx5IHN1cHBvc2VkIHRvIGJlIHdyaXR0ZW4uwqAgU3BlY2lmaWNhbGx5LCBL
Vk0gd291bGQgaW5jb3JyZWN0bHkNCj4gPiA+IGNsb2JiZXINCj4gPiA+IFJCUFszMToxNl0gaWYg
TEVBVkUgaXMgZXhlY3V0ZWQgd2l0aCBhIDE2LWJpdCBzdGFjay4NCj4gPiANCj4gPiBUaGFua3Ms
IFNlYW4hIEdyZWF0IGNhdGNoLiBJIGRpZG4ndCBzZWUgdGhpcy4gSXMgdGhlcmUgYWxyZWFkeSBh
IHRlc3Qgc3VpdGUNCj4gPiBmb3INCj4gPiB0aGlzPw0KPiANCj4gTm8sIEknbSBqdXN0IGV4Y2Vz
c2l2ZWx5IHBhcmFub2lkIHdoZW4gaXQgY29tZXMgdG8gdGhlIGVtdWxhdG9yIDotKQ0KDQpJJ2xs
IGxvb2sgaW50byB3aGV0aGVyIHNvbWUgdGVzdGluZyBjYW4gYmUgYWRkZWQgdG8ga3ZtLXVuaXQt
dGVzdHMgb3IgbWF5YmUgc29tZQ0Kb3RoZXIgdGVzdCBoYXJuZXNzLg0KDQo+IEl0IHBhaW5zIG1l
IGEgYml0IHRvIHNheSB0aGlzLCBidXQgSSB0aGluayB3ZSdyZSBiZXN0IG9mZiBsZWF2aW5nIHRo
ZSBlbXVsYXRvcg0KPiBhcy1pcywgYW5kIHJlbHlpbmcgb24gdGhpbmdzIGxpa2UgZmFuY3kgY29t
cGlsZXIgZmVhdHVyZXMsIFVCU0FOLCBhbmQgZnV6emVycw0KPiB0bw0KPiBkZXRlY3QgYW55IGx1
cmtpbmcgYnVncy4NCg0KSSdtIGhhdmUgYSBmdXp6aW5nIHNldHVwIGZvciB0aGUgZW11bGF0b3Ig
aW4gdXNlcnNwYWNlLiBUaGlzIGlzc3VlIHdhcyBkZXRlY3RlZA0KYnkgTVNBTi4gOikgSSdsbCBt
YWtlIHRoaXMgYXZhaWxhYmxlIHdoZW4gaXQncyBpbiBhIGJldHRlciBzaGFwZS4NCg0KU28gaWYg
eW91IGRvbid0IHN0cm9uZ2x5IG1pbmQgLCBJIHdvdWxkIHN0aWxsIGluaXRpYWxpemUgdGhlIHBs
YWNlcyB3aGVyZSB0aGUNCmZ1enplciBjYW4gc2hvdyB0aGF0IHRoZSBjb2RlIGhhbmRzIHVuaW5p
YWxpemVkIGRhdGEgYXJvdW5kLiBBdCB0aGUgbGVhc3QsIGl0DQp3aWxsIG1ha2Ugb3RoZXIgZnV6
emluZyBlZmZvcnRzIGEgYml0IGVhc2llci4gQnV0IEkgZG8gdW5kZXJzdGFuZCB0aGF0IGNoYW5n
ZXMNCm5lZWQgdG8gYmUgY29uc2VydmF0aXZlLg0KDQpCdHcsIHdoYXQgYXJlIHRoZSBjYXNlcyB3
aGVyZSByZXQgZmFyLCBpcmV0IGV0YyAoYmFzaWNhbGx5IGFueXRoaW5nIHlvdSB3b3VsZG4ndA0K
ZXhwZWN0IGZvciBNTUlPKSBhcmUgaGFuZGxlZCBieSB0aGUgS1ZNIGVtdWxhdG9yIHdpdGhvdXQg
dGhlIGd1ZXN0IGRvaW5nDQphbnl0aGluZyBmaXNoeT8gDQoNCkp1bGlhbg0K
