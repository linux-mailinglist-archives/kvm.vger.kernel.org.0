Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64851429985
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 00:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhJKWw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 18:52:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49012 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJKWwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 18:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633992654; x=1665528654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WvqX7yEw8Ar/lNIHcWkJetBtMUdS+rMfLIZUrQdBdmk=;
  b=MxgqxTynmEdnEgU6RWj8RStf+KPMBrOfO4HEi7alyZMv/ORW6/twJvx2
   V9KJq1lNARyHomDzyK65XsJly80j1HdzTo5CGhBdViic3+uBdgD6PKLGp
   05cverB7eRHJRDHnyJehSoA+Hz8qHWk5TP1zpfuKugTMH5lsza2HZkWlR
   y6m66851rBXAV2pA/62o6lldyg1sbMond9Dm5rUt+XCLiQHjdZCAhQWzm
   V4rL0IDGNcdzvu9+NubszPby1J1n/XZiXI1B78BGT+yFJPRGoUrn4XKck
   Y8iIgv1OTTquIo1oYmYJh01gI0TVjEBXyk3rHBxY0D2NURfhye/x5sNav
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,365,1624291200"; 
   d="scan'208";a="294265034"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 12 Oct 2021 06:50:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLqZJuZKZTghRbVaFKhl3/7j+iceNtoNiMijpBLSmcWzsqPYbKk8LYSJKquNrEOFmX313oQS09Ai3EniHI5Z9kF3uhwsPK/q7KC1pZ3nujorYslBLokINXS2XM1NakmjHNuOvs5EUBEVLNtusuKSK80F8qdd5eZQIe7DMicPb8L1dJsF3V7GWbyKObLamx5KDldt6wmvhG9Xh37S0mL2XiC9NkglnQ+aHF5toPJvvnELTh2YmbzZzhvPIuZE8b+wEZAHRIrCQ6VSuG9ZBZToRyZg384dwEm0il7Zpiv1uUbGKfCNggG9CNAzX4nRxHPu35RTnIHhVH2aEjXpoaq+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvqX7yEw8Ar/lNIHcWkJetBtMUdS+rMfLIZUrQdBdmk=;
 b=mAbVzk9jTLtoP8NvCUf3KhRFR5QhQ6k36GhuQVbW9ewL2W9hDrU8Azqc9eGOUuNTb7muaGGm62mUa9kDCG7D/yYFY+26KNiGLIO885I7evytq6KaYSwaDk7c3SnSJwGStQEoaFotofKjqirvGJymPmx6cMzT8NugiN/MPHJqyORZip5B7saFzA/rFiej/ecX7BJ1CEMmGUD4xnT3k+bsaW8vpcQOcfvvUpqjrbSWEnoXYYDcBkJnOwQihH1T8OHqEPfZcZu0cH28FP0rsuSRCN5n3ZPF3rJhoHCQRZuvP1SbJ9tvUAw3LGIoktfrMSrij15L0lttXRE8RLtFc+H6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvqX7yEw8Ar/lNIHcWkJetBtMUdS+rMfLIZUrQdBdmk=;
 b=RPSP3x3084QOrS45oaiqQBTccSRLQrOkxIkzjYAmJn6qUoA8XeNdo6lWr9ElKHDLFFTlJ/S12OYgL2dNQCVuGFRMJkXHK9trGjU2luyxndYs0vHQf15OAMrFCnqOVgq4S5U8ao44mQ5eLiAJsNjDml1440WVMCu6g2soBVShqRk=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB4709.namprd04.prod.outlook.com (2603:10b6:a03:55::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Mon, 11 Oct
 2021 22:50:52 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::30:9ac4:b644:a0e4]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::30:9ac4:b644:a0e4%9]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 22:50:52 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "vincent.chen@sifive.com" <vincent.chen@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Thread-Topic: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Thread-Index: AQHXu/N6afAc5oSwwU24PAOY+ZlwW6vJMwEAgARBy4CAAGz6AIAAizGA
Date:   Mon, 11 Oct 2021 22:50:51 +0000
Message-ID: <a762f0263090d7e818e58873d63139d7b6829d87.camel@wdc.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
         <20211008032036.2201971-6-atish.patra@wdc.com>
         <YWBdbCNQdikbhhBq@google.com>
         <0383b5cacb25e9dc293d891284df9f4cbc06ee3a.camel@wdc.com>
         <YWRLBknWXjzPnF1w@google.com>
In-Reply-To: <YWRLBknWXjzPnF1w@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.1 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b148b94-ae37-43a9-4fb1-08d98d0993b5
x-ms-traffictypediagnostic: BYAPR04MB4709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB47093C5AC9ABD06CFECAB816FAB59@BYAPR04MB4709.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62XyCiO3EBgzuSuqvi0S3Qq2+j1LMTC2VCaxuI9uk5OjSXVwqoIo2bdiJKPGacW7Wj5aNiC8HMpgLRSTTgUbM3ZDUm1iyI1+1z1evdSc5kAUdVp8iNvIx8Qa0/sKVfeb4j5SqPDiJjyBBCOEAFlTF0D3I1VHM6iaYQnx4l3JeU+qAbbYC4g/Ff++SqzT6RBBmeOnScmHdd6cKc5+gHjiXMr1U+C5B26puhYql5fpPk/tiPeO/O/lWmbIurp0U4LWrhjrWDYbFtQoE9fCS07fNtIsFM8sKVtOodi0wQhSdycWHELgGhL7pOJ3JJqq/4mJ7Y2Z8eCZMVzPjH/owQ4fWsu9WTL4FxrJpm66PKCR+nB8i86PYdNKANy19lL3I01V91vD/8PslSZSDpVleo3sQB4qYO0R1mJBsGBSzg9IHcTeR94OLn4gjAIlhOIsMecQUfawwIWLdc57qQO0a5B+SrWPzlfdZ8aNcvOLtOS7R9YavaoEVeEw33e1TXWHA6HAfcqC7oP3l6Zc5TAM4Xjy0WoQ2huLBtSN2BtdUkIMjZlPVP2xeibxSbd5hSLm5pLCCEgpKf9c7n2OD9qNQLvev2FWbJBEGrEM6FBHHu/TDmoX2SrDPcQ+XQZLLA9m7fWDacdcfDFKYhuEvUKx1Txp4osY1XtcI3yLUWW2gNf8B420dKxckzxkZaqECZCOx/Zctqubv9XLdzlIUTPz7JCKOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(26005)(54906003)(508600001)(316002)(2906002)(83380400001)(5660300002)(6916009)(4001150100001)(8676002)(6506007)(66946007)(66476007)(71200400001)(76116006)(4326008)(122000001)(66446008)(38070700005)(7416002)(66556008)(36756003)(86362001)(64756008)(38100700002)(8936002)(6512007)(186003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWxnRm1HcFpzOWwzTXh0TGJ1NlhNZEYwaGRicU41YUJMcThVdzdQQ01SVnFH?=
 =?utf-8?B?RlNkcDJ5WFNoc20rdkhRY2R2bHNiY1JmMk5SWjN4RFFtZU1kRTJuaktra2w0?=
 =?utf-8?B?L0lIaTRyWDZDMU5MVGVLZm5qbmcrZEFZT2xqSTdDSFN3enJNTlkvOWlGSzl6?=
 =?utf-8?B?T29yMnROQVFNeTNtWGVQTVlITm05ZjhRYW1sNzBjbndwY2tlUWxnMXE5ZUNB?=
 =?utf-8?B?NzNabHdNN09QM1djd2l3NFZreGx0aE9XWGhIeEczaUVGVXFHOU5MQUNMcVk3?=
 =?utf-8?B?bDFZUSt6VWd6RnhNdmFFTnVUeGw4K3U1bzA1UzBYUlNVeUs5ZHI3N0pmQytW?=
 =?utf-8?B?QTdmQjYvT0JaR0d2c3hoMXZVRDhEK25tckhXZnFYVGxUOGZLTlV2M2RFRnlk?=
 =?utf-8?B?SjgwTWk1K2JjQ3VhVlFkbVQ4Wm00UEw0N3lZSWE3TVhBSS8ybHgzRFlQcmd3?=
 =?utf-8?B?akpwK0YrcCtKOTkzWVMvMmkwVmtMKzdHRnBSSWIySXljcG5BM2hZL0lhVlVW?=
 =?utf-8?B?RmVWMTlOWm4yYnk4My9rTnZPTkIxcW1YNHJBblA3S3NnZTRUYU40TVA4emJt?=
 =?utf-8?B?NTJkamc4WnJyVFdrNHRyQzBqM3lNcjFLa2hwRDRuSjVFL0pGMmsyT1lGNlNU?=
 =?utf-8?B?Q3RZVWdOWVJEYWZHUjdvSjVJY1JQWVJtOGFaZFdCdGtvMytSK3FaSTNTVTlT?=
 =?utf-8?B?bnZUelBuT3RCZk42VFVwRGk4bGV4b1JPUWFpQVo2TUtQcDk4bSt3VlF6WWFI?=
 =?utf-8?B?WVplR0Z3UUp1eG4wNUU1c2JKRGhyd1hLaUxZRkdnaHR1dis3SlJURDIrQWJW?=
 =?utf-8?B?c2VKY2E0NlRsUGZXSlVpTE1ZRG94NmZURWg4Zys4Rzk1a0VnUUtvWmExVkdQ?=
 =?utf-8?B?OXZEV21qZi9rbWpwVE9SSWNHMUlrQjZKWjdMa0VSaDIxOU9ZS0JwYktlVTFo?=
 =?utf-8?B?WUZEK3Z5ak80cUtLUWhwZ0tQZ21EVTR6YlcvU2JGNU5jOTk1a2cwcm1yY1JE?=
 =?utf-8?B?anJ5TCtKMkdPOHFuY2o2aTVxa2NzdzkwV0NPaUQrOURWWGhLeC9OK053M2Rq?=
 =?utf-8?B?dGZYNytuUzdua2hIMnNCR0FDaHdweWtTbUxGTmFlcm44YnZGUks5OS9LTlhp?=
 =?utf-8?B?dDFBZlZXSDc3Y2ptRjhxWThmZ3Fub0JISnV2NXcvN0NlK0YzejV1YVU2c2FG?=
 =?utf-8?B?bVFCOFBqdXFCZEJoRkszZ0ZtWVIwcWpESSsvUWhNak4xLzV0dGdrOGh1YWkz?=
 =?utf-8?B?bjBDUUEyQWtERkVDb0IvRFhSbXJRTTA3RnhqclRDdGFZaTZWajkyUCthSWZr?=
 =?utf-8?B?am83Tzk4alFTOHR1bTM3U01PTDU1RDN6S2t4OEl4cmVZWEwrT2Z4RWJVUHR4?=
 =?utf-8?B?UFlUazdzK1lIZEFTQTRwWVo2RWloOEtCcGUwK1pQbU9WaVRkOHd1MlNXd25k?=
 =?utf-8?B?UGFxNUgycXIyRUpCdmx5WXpHVzg2djI2bFFWTWc1ZnZ0U29aa3VWcUpwaFZ0?=
 =?utf-8?B?UzhUeGI4Q01zRlJ2aFVnSzdCSS8xS3F3bXBscHEwVGY0U3VVSmhCcTJEYzEy?=
 =?utf-8?B?WktMWmVpWDQxRVlsV1ozNGQ1SlM3N3RTWjZsMnRaUlNoNEhTbGo3dnpEZVRW?=
 =?utf-8?B?dFp4U3NJbmg5ZWhpRGIyNHdCU05iYnN1eU00OSsxNHNGWW9ObEZXQnhFTXdw?=
 =?utf-8?B?SWhmaTVycWNRSysrbkZkMzg0NVljMDZ2bDkwTEo5SHFhSFdhOVZqazl0L0Vw?=
 =?utf-8?Q?rlDhG3zOaWJTiGYjhIAEAhhq6A5smDujU5+Y+Xl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E45752565D3794EB54E78A3F583987C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b148b94-ae37-43a9-4fb1-08d98d0993b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 22:50:51.9810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ADYzeAA2WQBjMpFPNq2b9tpVfGSxPHnUwBSvp8RgDjNHPAmdpOJ+2oLodKxatsJQBBagMdbYFuzvIyKSgKxCJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4709
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTEwLTExIGF0IDE0OjMyICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE9jdCAxMSwgMjAyMSwgQXRpc2ggUGF0cmEgd3JvdGU6DQo+ID4gT24g
RnJpLCAyMDIxLTEwLTA4IGF0IDE1OjAyICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPiA+ID4gT24gVGh1LCBPY3QgMDcsIDIwMjEsIEF0aXNoIFBhdHJhIHdyb3RlOg0KPiA+ID4g
PiArwqDCoMKgwqDCoMKgwqBwcmVlbXB0X2Rpc2FibGUoKTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgbG9hZGVkID0gKHZjcHUtPmNwdSAhPSAtMSk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGlm
IChsb2FkZWQpDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fYXJj
aF92Y3B1X3B1dCh2Y3B1KTsNCj4gPiA+IA0KPiA+ID4gT29mLsKgIExvb2tzIGxpa2UgdGhpcyBw
YXR0ZXJuIHdhcyB0YWtlbiBmcm9tIGFybTY0LsKgDQo+ID4gDQo+ID4gWWVzLiBUaGlzIHBhcnQg
aXMgc2ltaWxhciB0byBhcm02NCBiZWNhdXNlIHRoZSBzYW1lIHJhY2UgY29uZGl0aW9uDQo+ID4g
Y2FuDQo+ID4gaGFwcGVuIGluIHJpc2N2IGR1ZSB0byBzYXZlL3Jlc3RvcmUgb2YgQ1NScyBkdXJp
bmcgcmVzZXQuDQo+ID4gDQo+ID4gDQo+ID4gPiDCoElzIHRoZXJlIHJlYWxseSBubyBiZXR0ZXIg
YXBwcm9hY2ggdG8gaGFuZGxpbmcgdGhpcz/CoCBJIGRvbid0DQo+ID4gPiBzZWUgYW55dGhpbmcN
Cj4gPiA+IMKgaW4ga3ZtX3Jpc2N2X3Jlc2V0X3ZjcHUoKSB0aGF0IHdpbGwgb2J2aW91c2x5IGJy
ZWFrIGlmIHRoZSB2Q1BVDQo+ID4gPiBpcw0KPiA+ID4gwqBsb2FkZWQuwqAgSWYgdGhlIGdvYWwg
aXMgcHVyZWx5IHRvIGVmZmVjdCBhIENTUiByZXNldCB2aWENCj4gPiA+IMKga3ZtX2FyY2hfdmNw
dV9sb2FkKCksIHRoZW4gd2h5IG5vdCBqdXN0IGZhY3RvciBvdXQgYSBoZWxwZXIgdG8NCj4gPiA+
IGRvIGV4YWN0bHkNCj4gPiA+IMKgdGhhdD8NCj4gDQo+IFdoYXQgYWJvdXQgdGhlIHF1ZXN0aW9u
IGhlcmU/DQoNCkFyZSB5b3Ugc3VnZ2VzdGluZyB0byBmYWN0b3IgdGhlIGNzciByZXNldCBwYXJ0
IHRvIGEgZGlmZmVyZW50IGZ1bmN0aW9uDQo/DQoNCj4gDQo+ID4gPiANCj4gPiA+ID4gwqANCj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoG1lbWNweShjc3IsIHJlc2V0X2Nzciwgc2l6ZW9mKCpjc3Ip
KTsNCj4gPiA+ID4gwqANCj4gPiA+ID4gQEAgLTE0NCw2ICsxNTEsMTEgQEAgc3RhdGljIHZvaWQg
a3ZtX3Jpc2N2X3Jlc2V0X3ZjcHUoc3RydWN0DQo+ID4gPiA+IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+
ID4gPiDCoA0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgV1JJVEVfT05DRSh2Y3B1LT5hcmNoLmly
cXNfcGVuZGluZywgMCk7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBXUklURV9PTkNFKHZjcHUt
PmFyY2guaXJxc19wZW5kaW5nX21hc2ssIDApOw0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDC
oMKgwqDCoC8qIFJlc2V0IHRoZSBndWVzdCBDU1JzIGZvciBob3RwbHVnIHVzZWNhc2UgKi8NCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGxvYWRlZCkNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGt2bV9hcmNoX3ZjcHVfbG9hZCh2Y3B1LCBzbXBfcHJvY2Vzc29yX2lk
KCkpOw0KPiA+ID4gDQo+ID4gPiBJZiB0aGUgcHJlZW1wdCBzaGVuYW5pZ2FucyByZWFsbHkgaGF2
ZSB0byBzdGF5LCBhdCBsZWFzdCB1c2UNCj4gPiA+IGdldF9jcHUoKS9wdXRfY3B1KCkuDQo+ID4g
PiANCj4gPiANCj4gPiBJcyB0aGVyZSBhbnkgc3BlY2lmaWMgYWR2YW50YWdlIHRvIHRoYXQgPyBn
ZXRfY3B1L3B1dF9jcHUgYXJlIGp1c3QNCj4gPiBtYWNyb3Mgd2hpY2ggY2FsbHMgcHJlZW1wdF9k
aXNhYmxlL3ByZWVtcHRfZW5hYmxlLg0KPiA+IA0KPiA+IFRoZSBvbmx5IGFkdmFudGFnZSBvZiBn
ZXRfY3B1IGlzIHRoYXQgaXQgcmV0dXJucyB0aGUgY3VycmVudCBjcHUuIA0KPiA+IHZjcHVfbG9h
ZCBmdW5jdGlvbiB1c2VzIGdldF9jcHUgYmVjYXVzZSBpdCByZXF1aXJlcyB0aGUgY3VycmVudCBj
cHUNCj4gPiBpZC4NCj4gPiANCj4gPiBIb3dldmVyLCB3ZSBkb24ndCBuZWVkIHRoYXQgaW4gdGhp
cyBjYXNlLiBJIGFtIG5vdCBhZ2FpbnN0IGNoYW5naW5nDQo+ID4gaXQNCj4gPiB0byBnZXRfY3B1
L3B1dF9jcHUuIEp1c3Qgd2FudGVkIHRvIHVuZGVyc3RhbmQgdGhlIHJlYXNvbmluZyBiZWhpbmQN
Cj4gPiB5b3VyDQo+ID4gc3VnZ2VzdGlvbi4NCj4gDQo+IEl0IHdvdWxkIG1ha2UgdGhlIGNvZGUg
YSBiaXQgc2VsZi1kb2N1bWVudGluZywgYmVjYXVzZSBBRkFJQ1QgaXQNCj4gZG9lc24ndCB0cnVs
eQ0KPiBjYXJlIGFib3V0IGJlaW5nIHByZWVtcHRlZCwgaXQgY2FyZXMgYWJvdXQga2VlcGluZyB0
aGUgdkNQVSBvbiB0aGUNCj4gY29ycmVjdCBwQ1BVLg0KDQoNClN1cmUuIEkgd2lsbCBjaGFuZ2Ug
aXQgdG8gZ2V0X2NwdS9wdXRfY3B1IGludGVyZmFjZS4NCg0KPiANCj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgcHJlZW1wdF9lbmFibGUoKTsNCj4gPiA+ID4gwqB9DQo+ID4gPiA+IMKgDQo+ID4gPiA+
IMKgaW50IGt2bV9hcmNoX3ZjcHVfcHJlY3JlYXRlKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQg
aW50IGlkKQ0KPiA+ID4gPiBAQCAtMTgwLDYgKzE5MiwxMyBAQCBpbnQga3ZtX2FyY2hfdmNwdV9j
cmVhdGUoc3RydWN0IGt2bV92Y3B1DQo+ID4gPiA+ICp2Y3B1KQ0KPiA+ID4gPiDCoA0KPiA+ID4g
PiDCoHZvaWQga3ZtX2FyY2hfdmNwdV9wb3N0Y3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkN
Cj4gPiA+ID4gwqB7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoC8qKg0KPiA+ID4gPiArwqDCoMKg
wqDCoMKgwqAgKiB2Y3B1IHdpdGggaWQgMCBpcyB0aGUgZGVzaWduYXRlZCBib290IGNwdS4NCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgICogS2VlcCBhbGwgdmNwdXMgd2l0aCBub24temVybyBjcHUg
aWQgaW4gcG93ZXItb2ZmDQo+ID4gPiA+IHN0YXRlDQo+ID4gPiA+IHNvIHRoYXQgdGhleQ0KPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqAgKiBjYW4gYnJvdWdodCB0byBvbmxpbmUgdXNpbmcgU0JJIEhT
TSBleHRlbnNpb24uDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiA+ID4gPiArwqDCoMKg
wqDCoMKgwqBpZiAodmNwdS0+dmNwdV9pZHggIT0gMCkNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGt2bV9yaXNjdl92Y3B1X3Bvd2VyX29mZih2Y3B1KTsNCj4gPiA+IA0K
PiA+ID4gV2h5IGRvIHRoaXMgaW4gcG9zdGNyZWF0ZT8NCj4gPiA+IA0KPiA+IA0KPiA+IEJlY2F1
c2Ugd2UgbmVlZCB0byBhYnNvbHV0ZWx5IHN1cmUgdGhhdCB0aGUgdmNwdSBpcyBjcmVhdGVkLiBJ
dCBpcw0KPiA+IGNsZWFuZXIgaW4gdGhpcyB3YXkgcmF0aGVyIHRoYW4gZG9pbmcgdGhpcyBoZXJl
IGF0IHRoZSBlbmQgb2YNCj4gPiBrdm1fYXJjaF92Y3B1X2NyZWF0ZS4gY3JlYXRlX3ZjcHUgY2Fu
IGFsc28gZmFpbCBhZnRlcg0KPiA+IGt2bV9hcmNoX3ZjcHVfY3JlYXRlIHJldHVybnMuDQo+IA0K
PiBCdXQga3ZtX3Jpc2N2X3ZjcHVfcG93ZXJfb2ZmKCkgZG9lc24ndCBkb2Vzbid0IGFueXRoaW5n
IG91dHNpZGUgb2YNCj4gdGhlIHZDUFUuwqAgSXQNCj4gY2xlYXJzIHZjcHUtPmFyY2gucG93ZXJf
b2ZmLCBtYWtlcyBhIHJlcXVlc3QsIGFuZCBraWNrcyB0aGUgdkNQVS7CoA0KPiBOb25lIG9mIHRo
YXQNCj4gaGFzIHNpZGUgZWZmZWN0cyB0byBhbnl0aGluZyBlbHNlIGluIEtWTS7CoCBJZiB0aGUg
dkNQVSBpc24ndCBjcmVhdGVkDQo+IHN1Y2Nlc3NmdWxseSwNCj4gaXQgZ2V0cyBkZWxldGVkIGFu
ZCBub3RoaW5nIGV2ZXIgc2VlcyB0aGF0IHN0YXRlIGNoYW5nZS4NCg0KSSBhbSBhc3N1bWluZyB0
aGF0IHlvdSBhcmUgc3VnZ2VzdGluZyB0byBhZGQgdGhpcyBsb2dpYyBhdCB0aGUgZW5kIG9mDQp0
aGUga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSBpbnN0ZWFkIG9mIGt2bV9hcmNoX3ZjcHVfcG9zdGNy
ZWF0ZSgpLg0KDQp2Y3B1X2lkeCBpcyBhc3NpZ25lZCBhZnRlciBrdm1fYXJjaF92Y3B1X2NyZWF0
ZSgpIHJldHVybnMgaW4gdGhlDQprdm1fdm1faW9jdGxfY3JlYXRlX3ZjcHUuIGt2bV9hcmNoX3Zj
cHVfcG9zdGNyZWF0ZSgpIGlzIHRoZSBhcmNoIGhvb2t1cA0KYWZ0ZXIgdmNwdV9pZHggaXMgYXNz
aWduZWQuDQoNCi0tIA0KUmVnYXJkcywNCkF0aXNoDQo=
