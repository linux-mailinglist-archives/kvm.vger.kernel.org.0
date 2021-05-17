Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2925B3822E9
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbhEQCxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 22:53:13 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:44152 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234039AbhEQCxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 16 May 2021 22:53:12 -0400
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H2gHWJ022933;
        Sun, 16 May 2021 19:50:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=jMJOjLHQ+qG3793sDXS91eew9gMIbERany3yZo7gM+k=;
 b=2PRbfPrQU2V2gesgYD5c8oD0Dm8rA/Ll0rYV4JfTxHtNXcwjRISBCXppt1HBArsqRkNr
 NLxvQ2wFEV8x6atXkWMttaPulBWaM/EMF7LFMUqRimGOP0GdcoVvEtqy9Lyceo8Vux1w
 XSeGcHYceLSUzV7vuYxSYFMnIqv1wWIqVf3Fn9n9ua2SiJ+YHetJgXwZVr9BZXFIl9md
 FCq/GzzO6po2yoHYJ0oUM9PaQ9eoWNPT9ucuvXC4PzVNO/lM22uBkEQEirBFIxQ19Rbo
 I+xaYYoFSRRNpT5zkrnymDuMu3wSRt2qakQj29UBhvTY+T1dFyozf9+7l+sRQ0nFtJUv XA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38jdv0t65a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 May 2021 19:50:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGfg8H/QeaqmviOTDXwbOfuDrRl+MXFJHUxWy2ATCNEDWIAphViXw5rUWI+Nik8O9Sk6HcGm0VBBv+/aJrcZ705WVTsIZjt2uZIonzwgmqeu/iJ9zqw2DINtW6PLpzbA2j0JEbFzPDNVRbsrdpb0wavz5O3CG8CbFbPAtHmZX/Xtigo45AiLawz0/GcDp/mRbWxdtgg4ioQeneFW4Hq65GkK1AhFVnSIZN14jHHWnPtnsISmvC3nQ4S085qnUVu1MlmnmIEVXJJLkyVIgf/tkJONKPrT412yttSMPHMPh6z8YMniDJfPAYg2uAdl8C+eTnhfAN3/TliexUc30VW9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMJOjLHQ+qG3793sDXS91eew9gMIbERany3yZo7gM+k=;
 b=TDIDhirN8YOEJPrRc+SBpyAwNA6HcOQeZqoUDaHGHAfJ4w4q7AdaSXS4+0Pg1dWd1TfDhLFXNLYJPamIWAvxo15xZcv1NT/dx2dRLfDygbcaSYdANLylNTigBi5CKcyvRrlm8l7ty5CvsDYJF+c/XxD8WKV1oy6VqpeA4JINumtedyeLi+nwm7fqx/MgsODlV+TqqKqy+7IykiO9fb90/4JTUmer+LDn0gk6eOee105DrCwv1JVuS3qWqGpDFNEu6OPh57lbJNQaXWYDae+IAAduHpOf5nG52DJTjnP6j6KirMvMMxRR9HzdCHwUzTIMfo7EGy3YYWf80496SSeqJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB3682.namprd02.prod.outlook.com (2603:10b6:207:47::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 02:50:25 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 02:50:25 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Thread-Topic: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Thread-Index: AQHXQ2BcR+stRakKBECUXHbkspHLPqrieHgAgASPjYA=
Date:   Mon, 17 May 2021 02:50:25 +0000
Message-ID: <02D65AFF-2DD0-493A-91CA-997450404826@nutanix.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
In-Reply-To: <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:b901:d8fa:aa1f:a5d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a7ef5a1-c1c6-40c0-b7c1-08d918de85fc
x-ms-traffictypediagnostic: BL0PR02MB3682:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB36825F88E3848129E63EE4A4AF2D9@BL0PR02MB3682.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6UcIZxjFwqJ55Ioa3e1iV2CfGd2RtQDylszJt6s6xr2paN/wW2bPoIV9qdYjMQqCMNAuFpwoJcAbMVCMaVRgnzh0cUowv6oHJCbpKsuW4y4vWOdDT11C9tOYlpV08tpT/jhbtMBkq23DtQP7+JnbA10Qr7gkGlKi2HMDRGs+KbEhSpu120IUmvFheomd9I8YpdkqeWB5PtNMBx6gfkLRBxYTtWluyGH77yQOcVEsV9/2urIzMoRaVLgWFyUnSWs+DMu86rnIZjl/tSoTha3RKshB35dIkLYPVh07qqoTwfbDbNCZCAaBl6hkD+ntuXAdnSVcc6LEorm1GGQZVl55FimxAgZyCxQCTEz4/VsYudHxNuJV5i0gl2gsB0UrUf/Ef2hEr/ThqpiufNX8EGZBFcL6yungn/eeho9OIv2N6vK5vzxVMexmlPapL1UPLbWMaEM2EsKixja0A9IEVvqnY0ib/dZ9NDiLMAG7sY9+P9vMa3TzB9ELia2GnTMqLay5eB+jr7C/kQY8Xe2Gwhyc1j7w/vkbT4DCuNpzC1EPP+TaxgwznW9JbKiDNPt7eCOq3j6ruEWu3f96gR3pKm5pmTpOhZpJdOos2wDvvFrCCJRbb960iqQ8leu+fEUa3/SsVc3C6F+4IEeDJIFSZvJPKSSPpVsM4GfjW2wup2MGf/k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39850400004)(186003)(36756003)(316002)(83380400001)(7416002)(7406005)(64756008)(71200400001)(54906003)(38100700002)(6486002)(76116006)(8936002)(2906002)(53546011)(4326008)(6512007)(6506007)(86362001)(66556008)(8676002)(2616005)(66446008)(33656002)(5660300002)(6916009)(66946007)(66476007)(91956017)(478600001)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ald5cm45UVRVY1hiNGgwNGRrdkdReDErSEYrMkovcVA0YURxMWF4Umh0ZnNV?=
 =?utf-8?B?R0ZqTng0QnE3NXlhWFBQNStnR2szTm00NUJoTzIzTU1oQVlDNk1SMGZZaEtm?=
 =?utf-8?B?cCtBMmM1NThlSk1MQVpFMWR3dytlUGRGRGF4SnV2NmVuRU9oT2hlTkxkRGdw?=
 =?utf-8?B?ZTE1S2Vpa3NDdndtR25ubEF0Sjk4MFlROEY4bHlXWEdtajhyUitDQjl6TG52?=
 =?utf-8?B?UjJyR2pzY1NZSnpMTWdYdDhkbTRleWY0dktmV3FxckdZbVJZUGxBMG8yZkVu?=
 =?utf-8?B?SVlXNUNDaUs4VTFUOEZ4cW4yZ0U5Y2pXalpZaGZ2emlEa0NValo1VHJZRWkr?=
 =?utf-8?B?ZkFoQkROeHF6MkRFM1kwRVYvRWc2cTNQWVJVZmVyUVI4SFVFZVBpRmNJeXRw?=
 =?utf-8?B?VTE2RFdWTDhDcVViUGpnaEptbk04N2ZZNU1hd1BoUUJtNkdxbnIxZzJEWXNk?=
 =?utf-8?B?MUxhV2ZXS2lPMGRuWjU2V082RW1Id1JudG1DNEpaOGRHaS8vSXpGTHd4VHhD?=
 =?utf-8?B?RzMzL1dQTWZFNDY3VVB5dFFWc0tyOEUrclFqREFaTGN3cUszRk01aHhtM0ZS?=
 =?utf-8?B?Rk5hdWVMMDN0RlBUV1k4K1FZSTRVdkVVZXNKYlFJLzBDbG9qWFYxYlFobHlh?=
 =?utf-8?B?Y0ZoY2VRSnJLclh1MDJzeFQyK1kvSXlSSE01SDBqaGJ2QU56aVgwSXdzQUtu?=
 =?utf-8?B?dENnWUpMa3BKRmZLa0kzeGZRNFpwYU85Q2RVc3JVNEl0d3diZGEwMFZhTi9n?=
 =?utf-8?B?bWx6QytsU1VWT3ZRQXMyaUJvUko1eGJ5SDNYb3V1bC9ZQWhPRnMvMXdVYkN0?=
 =?utf-8?B?Nmw1cTFKZklXYzc3bEkwTHcvQ0hIQTBZNnVVamRXZEg1MkdjbHJpMTdTNTdK?=
 =?utf-8?B?T1dsS01VaVBMWnpwejcxOVlzSXVod3VoWWU4cjNUVjM1SDN0Nks0NFJsSGtF?=
 =?utf-8?B?UzFRdWwzaktzL09WSVFNenc4YXdZM0lPU1RIcS9lRzFwMDdVM3g5ODMreGdQ?=
 =?utf-8?B?MEJ5OVhId2RLcm5RaWRLQklVMmE3ZkhvZnNkMng2NjROWldyekFtcVZ6WVF4?=
 =?utf-8?B?ak15bTByOGpwRWVTeGlGTm5lK0VJSHIzUUlYT2pHUjZrR1Roa0t6dUFjS1BV?=
 =?utf-8?B?YmFEWlJpVjlxK09CcHFTUTFJdVRZMEZWUFJrMGIwQUJiaEl3RzFyK0oyVUI2?=
 =?utf-8?B?OCtyV3FHZ1pFZVNKd1lvUDJWVTRjZHlEWUpQcG43QlRJSnZHc3k5RzVqRlVR?=
 =?utf-8?B?Ym5kTCtzM01IQ2V5NnR5QllGc3FuU21LR0NMYW9lWnUxZXFlSzlvL0YvK1hy?=
 =?utf-8?B?NlFTTHVwSVNZNlBsY0s1MDMvVnY2Z2wyd3g2dlVOYmpjWTBRdmxNU3lWalBp?=
 =?utf-8?B?UklCMUVhY2dsblV6YWhiN3pDMlY0U3hodU1mWFVtYTNua0dZeXBpOUs2K05o?=
 =?utf-8?B?czBsbEdnUjJKRFVGaWxGblo0aUdTdkYya2pDUEE3TzgxYkRlVUloRURKT3Yr?=
 =?utf-8?B?V1dQdldXZFltcGo3dm9LMEVyYllnM2k3Z2lrT1FYRzRoTXpkcDhjb1NwVm5T?=
 =?utf-8?B?RW9HM3AzSzlsNFM3ZXJVcGhuRVc5MTRLbnlOQWhvVGpFa01mRFd5bmRuWkln?=
 =?utf-8?B?emE1VTNacjBhU3V0b3FwOEE1QVErRzRDUlZMT0xkby9pRitKaFNnaUZZRDFo?=
 =?utf-8?B?Z2c5TTNQVmpySVpGejdlZnJvU040d045d2oyR2FPMzVOSUZmVEhSRnplcmZW?=
 =?utf-8?B?Q0tvUEhmVVVNeUFwUDJySTZrUnlObkRFMEFQSC9xMGxOVWxEN0NkRUNDQ3VB?=
 =?utf-8?B?Um1yRzZGa0Q4SHRLMDVWUnVyUEYvNU1oem4vcTFQMU5lcEdLZEF1QUNhU3pw?=
 =?utf-8?Q?KjI5VlhGgf6ZC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99103C5A9D3BF448AE6F6CAB6550F0E4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7ef5a1-c1c6-40c0-b7c1-08d918de85fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 02:50:25.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wXoR3bWahgvltmLnNn+bHHxrN2R1l3ODqpLsJY1BCnu3NgSjYxw5EEm7tCVcqoRkCZM81x46hjYzMbk5nnUn8cGDd0/huGLsz3qiv3B8qOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3682
X-Proofpoint-GUID: roLi8nf3kH2YNKneOKRl6OoBZVfLC3e_
X-Proofpoint-ORIG-GUID: roLi8nf3kH2YNKneOKRl6OoBZVfLC3e_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_01:2021-05-12,2021-05-17 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDE0LCAyMDIxLCBhdCAxOjExIEFNLCBBbmR5IEx1dG9taXJza2kgPGx1dG9A
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIE1heSA3LCAyMDIxIGF0IDk6NDUgQU0g
Sm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPiB3cm90ZToNCj4+IA0KPj4ga3ZtX2xvYWRfaG9z
dF94c2F2ZV9zdGF0ZSBoYW5kbGVzIHhzYXZlIG9uIHZtIGV4aXQsIHBhcnQgb2Ygd2hpY2ggaXMN
Cj4+IG1hbmFnaW5nIG1lbW9yeSBwcm90ZWN0aW9uIGtleSBzdGF0ZS4gVGhlIGxhdGVzdCBhcmNo
LnBrcnUgaXMgdXBkYXRlZA0KPj4gd2l0aCBhIHJkcGtydSwgYW5kIGlmIHRoYXQgZG9lc24ndCBt
YXRjaCB0aGUgYmFzZSBob3N0X3BrcnUgKHdoaWNoDQo+PiBhYm91dCA3MCUgb2YgdGhlIHRpbWUp
LCB3ZSBpc3N1ZSBhIF9fd3JpdGVfcGtydS4NCj4gDQo+IFRoaXMgdGhyZWFkIGNhdXNlZCBtZSB0
byByZWFkIHRoZSBjb2RlLCBhbmQgSSBkb24ndCBnZXQgaG93IGl0J3MgZXZlbg0KPiByZW1vdGVs
eSBjb3JyZWN0Lg0KPiANCj4gRmlyc3QsIGt2bV9sb2FkX2d1ZXN0X2ZwdSgpIGhhcyB0aGlzIGRl
bGlnaHQ6DQo+IA0KPiAgICAvKg0KPiAgICAgKiBHdWVzdHMgd2l0aCBwcm90ZWN0ZWQgc3RhdGUg
Y2FuJ3QgaGF2ZSBpdCBzZXQgYnkgdGhlIGh5cGVydmlzb3IsDQo+ICAgICAqIHNvIHNraXAgdHJ5
aW5nIHRvIHNldCBpdC4NCj4gICAgICovDQo+ICAgIGlmICh2Y3B1LT5hcmNoLmd1ZXN0X2ZwdSkN
Cj4gICAgICAgIC8qIFBLUlUgaXMgc2VwYXJhdGVseSByZXN0b3JlZCBpbiBrdm1feDg2X29wcy5y
dW4uICovDQo+ICAgICAgICBfX2NvcHlfa2VybmVsX3RvX2ZwcmVncygmdmNwdS0+YXJjaC5ndWVz
dF9mcHUtPnN0YXRlLA0KPiAgICAgICAgICAgICAgICAgICAgflhGRUFUVVJFX01BU0tfUEtSVSk7
DQo+IA0KPiBUaGF0J3MgbmljZSwgYnV0IGl0IGZhaWxzIHRvIHJlc3RvcmUgWElOVVNFW1BLUlVd
LiAgQXMgZmFyIGFzIEkga25vdywNCj4gdGhhdCBiaXQgaXMgbGl2ZSwgYW5kIHRoZSBvbmx5IHdh
eSB0byByZXN0b3JlIGl0IHRvIDAgaXMgd2l0aA0KPiBYUlNUT1IoUykuDQoNClRoYW5rcywgQW5k
eSAtIEFkZGluZyBUb20gTGVuZGFja3kgdG8gdGhpcyB0aHJlYWQgYXMgdGhhdA0KUGFydGljdWxh
ciBzbmlwcGV0IHdhcyBsYXN0IHRvdWNoZWQgaW4gfjUuMTEgaW4gZWQwMmIyMTMwOThhLg0KDQo+
IA0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYu
Yw0KPj4gaW5kZXggY2ViZGFhMWUzY2Y1Li5jZDk1YWRiZDE0MGMgMTAwNjQ0DQo+PiAtLS0gYS9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4gQEAgLTkx
MiwxMCArOTEyLDEwIEBAIHZvaWQga3ZtX2xvYWRfZ3Vlc3RfeHNhdmVfc3RhdGUoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQ0KPj4gICAgICAgIH0NCj4+IA0KPj4gICAgICAgIGlmIChzdGF0aWNfY3B1
X2hhcyhYODZfRkVBVFVSRV9QS1UpICYmDQo+PiAtICAgICAgICAgICAoa3ZtX3JlYWRfY3I0X2Jp
dHModmNwdSwgWDg2X0NSNF9QS0UpIHx8DQo+PiAtICAgICAgICAgICAgKHZjcHUtPmFyY2gueGNy
MCAmIFhGRUFUVVJFX01BU0tfUEtSVSkpICYmDQo+PiAtICAgICAgICAgICB2Y3B1LT5hcmNoLnBr
cnUgIT0gdmNwdS0+YXJjaC5ob3N0X3BrcnUpDQo+PiAtICAgICAgICAgICAgICAgX193cml0ZV9w
a3J1KHZjcHUtPmFyY2gucGtydSk7DQo+PiArICAgICAgICAgICB2Y3B1LT5hcmNoLnBrcnUgIT0g
dmNwdS0+YXJjaC5ob3N0X3BrcnUgJiYNCj4+ICsgICAgICAgICAgICgodmNwdS0+YXJjaC54Y3Iw
ICYgWEZFQVRVUkVfTUFTS19QS1JVKSB8fA0KPj4gKyAgICAgICAgICAgIGt2bV9yZWFkX2NyNF9i
aXRzKHZjcHUsIFg4Nl9DUjRfUEtFKSkpDQo+PiArICAgICAgICAgICAgICAgX193cml0ZV9wa3J1
KHZjcHUtPmFyY2gucGtydSwgZmFsc2UpOw0KPiANCj4gUGxlYXNlIHRlbGwgbWUgSSdtIG1pc3Np
bmcgc29tZXRoaW5nIChlLmcuIEtWTSB2ZXJ5IGNsZXZlcmx5IG1hbmFnaW5nDQo+IHRoZSBQS1JV
IHJlZ2lzdGVyIHVzaW5nIGludGVyY2VwdHMpIHRoYXQgbWFrZXMgdGhpcyByZWxpYWJseSBsb2Fk
IHRoZQ0KPiBndWVzdCB2YWx1ZS4gIEFuIGlubm9jZW50IG9yIG1hbGljaW91cyBndWVzdCBjb3Vs
ZCBlYXNpbHkgbWFrZSB0aGF0DQo+IGNvbmRpdGlvbiBldmFsdWF0ZSB0byBmYWxzZSwgdGh1cyBh
bGxvd2luZyB0aGUgaG9zdCBQS1JVIHZhbHVlIHRvIGJlDQo+IGxpdmUgaW4gZ3Vlc3QgbW9kZS4g
IChPciBpcyBzb21ldGhpbmcgZmFuY3kgZ29pbmcgb24gaGVyZT8pDQo+IA0KPiBJIGRvbid0IGV2
ZW4gd2FudCB0byB0aGluayBhYm91dCB3aGF0IGhhcHBlbnMgaWYgYSBwZXJmIE5NSSBoaXRzIGFu
ZA0KPiBhY2Nlc3NlcyBob3N0IHVzZXIgbWVtb3J5IHdoaWxlIHRoZSBndWVzdCBQS1JVIGlzIGxp
dmUgKG9uIFZNWCAtLSBJDQo+IHRoaW5rIHRoaXMgY2FuJ3QgaGFwcGVuIG9uIFNWTSkuDQoNClBl
cmhhcHMgQmFidSAvIERhdmUgY2FuIGNvbW1lbnQgb24gdGhlIGV4aXRpbmcgbG9naWMgaGVyZT8g
QmFidSBkaWQNCnNvbWUgYWRkaXRpb25hbCB3b3JrIHRvIGZpeCBzYXZlL3Jlc3RvcmUgb24gMzc0
ODYxMzVkM2EuDQoNCkZyb20gdGhpcyBjaGFuZ2VzIHBlcnNwZWN0aXZlLCBJ4oCZbSBqdXN0IHRy
eWluZyB0byBnZXQgdG8gdGhlIHJlc3VsdGFudA0KZXZhbHVhdGlvbiBhIGJpdCBxdWlja2VyLCB3
aGljaCB0aGlzIGNoYW5nZSAoYW5kIHRoZSB2Mykgc2VlbXMgdG8gZG8NCm9rIHdpdGg7IGhvd2V2
ZXIsIGlmIEnigJl2ZSByYW4gbXkgc2hpcCBpbnRvIGEgbGFyZ2VyIGljZSBiZXJnLCBoYXBweSB0
bw0KY29sbGFib3JhdGUgdG8gbWFrZSBpdCBiZXR0ZXIgb3ZlcmFsbC4NCg0KPiANCj4+IH0NCj4+
IEVYUE9SVF9TWU1CT0xfR1BMKGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKTsNCj4+IA0KPj4g
QEAgLTkyNSwxMSArOTI1LDExIEBAIHZvaWQga3ZtX2xvYWRfaG9zdF94c2F2ZV9zdGF0ZShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgICAgICAgICAgICAgICByZXR1cm47DQo+PiANCj4+ICAg
ICAgICBpZiAoc3RhdGljX2NwdV9oYXMoWDg2X0ZFQVRVUkVfUEtVKSAmJg0KPj4gLSAgICAgICAg
ICAgKGt2bV9yZWFkX2NyNF9iaXRzKHZjcHUsIFg4Nl9DUjRfUEtFKSB8fA0KPj4gLSAgICAgICAg
ICAgICh2Y3B1LT5hcmNoLnhjcjAgJiBYRkVBVFVSRV9NQVNLX1BLUlUpKSkgew0KPj4gKyAgICAg
ICAgICAgKCh2Y3B1LT5hcmNoLnhjcjAgJiBYRkVBVFVSRV9NQVNLX1BLUlUpIHx8DQo+PiArICAg
ICAgICAgICAga3ZtX3JlYWRfY3I0X2JpdHModmNwdSwgWDg2X0NSNF9QS0UpKSkgew0KPj4gICAg
ICAgICAgICAgICAgdmNwdS0+YXJjaC5wa3J1ID0gcmRwa3J1KCk7DQo+PiAgICAgICAgICAgICAg
ICBpZiAodmNwdS0+YXJjaC5wa3J1ICE9IHZjcHUtPmFyY2guaG9zdF9wa3J1KQ0KPj4gLSAgICAg
ICAgICAgICAgICAgICAgICAgX193cml0ZV9wa3J1KHZjcHUtPmFyY2guaG9zdF9wa3J1KTsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgIF9fd3JpdGVfcGtydSh2Y3B1LT5hcmNoLmhvc3RfcGty
dSwgdHJ1ZSk7DQo+PiAgICAgICAgfQ0KPiANCj4gU3VwcG9zZSB0aGUgZ3Vlc3Qgd3JpdGVzIHRv
IFBLUlUgYW5kIHRoZW4sIHdpdGhvdXQgZXhpdGluZywgc2V0cyBQS0UgPQ0KPiAwIGFuZCBYQ1Iw
W1BLUlVdID0gMC4gIChPciBhcmUgdGhlIGludGVyY2VwdHMgc3VjaCB0aGF0IHRoaXMgY2FuJ3QN
Cj4gaGFwcGVuIGV4Y2VwdCBvbiBTRVYgd2hlcmUgbWF5YmUgU0VWIG1hZ2ljIG1ha2VzIHRoZSBw
cm9ibGVtIGdvIGF3YXk/KQ0KPiANCj4gSSBhZG1pdCBJJ20gZmFpcmx5IG15c3RpZmllZCBhcyB0
byB3aHkgS1ZNIGRvZXNuJ3QgaGFuZGxlIFBLUlUgbGlrZQ0KPiB0aGUgcmVzdCBvZiBndWVzdCBY
U1RBVEUuDQoNCknigJlsbCBkZWZlciB0byBEYXZlL0JhYnUgaGVyZS4gVGhpcyBjb2RlIGhhcyBi
ZWVuIHRoaXMgd2F5IGZvciBhIGJpdCBub3csDQpJ4oCZbSBub3Qgc3VyZSBhdCBmaXJzdCBnbGFu
Y2UgaWYgdGhhdCBzaXR1YXRpb24gY291bGQgb2NjdXIgaW50ZW50aW9uYWxseQ0Kb3IgYWNjaWRl
bnRhbGx5LCBidXQgdGhhdCB3b3VsZCBldmFsdWF0ZSB0aGUgc2FtZSBib3RoIGJlZm9yZSBhbmQN
CmFmdGVyIHRoaXMgY2hhbmdlLCBubz8NCg0K
