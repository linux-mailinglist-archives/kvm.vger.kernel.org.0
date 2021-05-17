Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D05B3822F5
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 04:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhEQDA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 23:00:58 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:32258 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233809AbhEQDA5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 16 May 2021 23:00:57 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H2w3dd020687;
        Sun, 16 May 2021 19:58:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=ABn6OSANBdyqSmmxueR353hlRr57f9CTb3y9a+JHaXU=;
 b=w6NFk5QEsuHDYCtyqdkVD65pZCqxIMgFtXvZXqJDdo3pjUrgRAzi5zEI7DLLxydFjYbU
 nNrFQm1bS7wMTJr8wqjmzg9U1l7KE0PExbC6yIP/stRTSUi+2SmSCIYBB/y7Cs6agdjT
 qD8+wgb/hC1mzrUc94oNU8uj3mPgAjWqfUDvNaC8z/QAeQEFttSbK7E3hY2hytPvcoAH
 vlF5Zk/aYP6xm4vz719dcHcNBICX3qxqqQ0qHehCpm7KA1+caaHnBSyob2Z3jML+a6cn
 JdpChb5t79nUrw+A+peuDd3k0v5a0e/oBTeXx2qFhj4fzYr41Pbv5lsC4mLCOyfHZGfA gw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38kfx7g0h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 May 2021 19:58:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd9gi4iOoHvCj0pO3/vi8CiTkjaX0AA+TJYzcC+YFzUDhZPn3nnX0RTbQtqi7uHj45y1DYVKJ+7OT6gMtmD1kJ7aTm+8dv6Mjd0DgMwyjQvL91bymuN/lQH8ZQOLklvNZwJUvopU2gFnfZe5itbRuIRVzg//EvqeYxcyYMIH2ysOKWHdJrfR1yJ8jcLYS2PNHEzN6jZwx5WozJmcIaAVzfnn5JXtzH8C1Gtf/z7u1pdQ6/0/zFEWIA/CE5dfRgXPvIowUhGU0D4velVyoO4okzvSilyqf79Ex0CGdxwUa0dvJLGUuoJXbrCpFMYmlUVNbiOPyCvywY/Piue2z2NQHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABn6OSANBdyqSmmxueR353hlRr57f9CTb3y9a+JHaXU=;
 b=KIV4LQ8sTQPkCOMEN+jU0noHZqotHG9nEiV+XeYhzk1pUnYOhokrDlSE2dOtCS9zO+5VEb2YzDvxUa7xO2+IkbHjoJ/00NH1UfJCNpycEC8jsSMYqQYwV3a65iOwVt6ioDh66uuihl9dJTziShEPQTIBYIC8Pv+f5ylPZl4YDh/JWs8/izT9oZnw61QoCPwliYFUuOIFyoP3mXHKU/6Gy+54elIZn8fwXRnnpbuPbN8sErBu9MUtkAOvyprWwRSbVGUGZtRRCwiVmvtnA2rNW6cnxp0CZW2tRhPXU3sGehKxQGyLGXK44VPTN83zWorz4OapXmeRL168Lfi3ND7EYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB3809.namprd02.prod.outlook.com (2603:10b6:207:48::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 02:58:25 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 02:58:25 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Dave Jiang <dave.jiang@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Topic: [PATCH v3] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Index: AQHXRofYIalsAP9fFUG+2GLE3/0de6rfd04AgAC2M4CAAj21gIAEmLyA
Date:   Mon, 17 May 2021 02:58:25 +0000
Message-ID: <2FD095E7-5C74-4B58-953F-3195BA97ABEF@nutanix.com>
References: <20210511170508.40034-1-jon@nutanix.com>
 <YJuGms6UnRVpP7U/@hirez.programming.kicks-ass.net>
 <25d39a79-d8d8-9798-a930-ccdace304bac@intel.com>
 <1bde6f22-166b-8552-e7f3-5731508182ea@kernel.org>
In-Reply-To: <1bde6f22-166b-8552-e7f3-5731508182ea@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:b901:d8fa:aa1f:a5d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6abd7e78-5617-4d90-8f16-08d918dfa3d6
x-ms-traffictypediagnostic: BL0PR02MB3809:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB3809C9550C8BDDE7CC279E55AF2D9@BL0PR02MB3809.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WgwE+wrIM5ZHq8Jb+rCYA+h1BH+h5hao660EbI0SFJnB9lbkm0jR4tbJKJbzlQ22c9g/U0IPZ2MiIJoVJ8tEG4FNTodGKRiIDMYgeyIEqX6NKQkHJ0QA/u+Ma/HZpcbo/wp4Jws8RasemANmXnjBmJy4Ke7rF0J0Pwa2uMD2jSFoSwTD0l35WRpiAUCiUx56cFpSqNvjCKiR+rCni+NyEkYr6OIDpKSNkOoG0/pKQzB18SjTr54oKTaIIz7sDr/bNoE3DjQ0QtGbzcuEBKqM6oJjSUtaNIcpEwFgUMevBxSafqOb2LtinYi43s8enVddr/wWMRVsmmzwN/HzPds9snRkMmzZ1FrAo3wlow10KxxT+GUnkwjuhAytdcFJHCehrzAg2CP/NX3/8o4ZRIWztD+UB/cpF6Ny09dw/Yq8R2J2ytNoZBg2dgpOvaQTSxyQvXTFOjwOnS6CP2JQ4JX8S66+hrqsmnKFEDSy02IiroWJM2+kl0TW7AQp0rf/rJoX/UThxbZhLMWaSLkQa8zVq4GqjEL/KHwDbC0dRR5y/WoOHTq7OeaW4xgnriKiT04OERvacqFbC3ObMk1FcIIFKCvM/oaSXgrvcHF0I2qzT/nq/kuHCrDmvnzXIn3QUlBIFUtFEPMDaSkp47K1GaCIyZH/rjNVHAy6hIQXm8bCPR0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39850400004)(366004)(396003)(376002)(6486002)(6512007)(66946007)(76116006)(33656002)(4326008)(53546011)(186003)(7406005)(6506007)(8936002)(8676002)(2906002)(83380400001)(54906003)(6916009)(5660300002)(316002)(38100700002)(122000001)(2616005)(66556008)(66446008)(64756008)(71200400001)(91956017)(86362001)(478600001)(7416002)(36756003)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXBFL29mVmZVVFBQTWtHdXJaTmY2emV5ellrRzY4NWo2dFFCODN4OWtuYlJi?=
 =?utf-8?B?RWZVK1hvTzVqbWNZeW8zb1g1VTNtOTdPY0lPdTM3YS9yN0ozd3lUb3hadXFT?=
 =?utf-8?B?WmdMQ281NmRpRUliWXptcXVmOG1sT2hYYlhERnlOVkJkMTVGWHZ4L2VUWDRN?=
 =?utf-8?B?V2tGdkZNU0xzWUhubnhPQVo5ejQ4NGpORmZ5dkUyRXR3aXJqRFFCbGQ5SkZx?=
 =?utf-8?B?REEvY1hXUUx5RWZ0NVg0TUhKWkRKT3oreGRjbFgvNW5vV1pKQTJTbUJKU2x2?=
 =?utf-8?B?Z0tIVEszOThma0RHemN2ODBLSUIvdTBkZG4vSzdkM1BrWEFkKzgrVFlvaTd0?=
 =?utf-8?B?SndZcVRCc1lxaURNNHBUbURhZG41OEYzY3NERFFLYkk0bVhHYkZ6V0svZGhm?=
 =?utf-8?B?TG1mbGVjajdjRVE3Q2lUbGJPNGdqQ1I2MjRPRWVGTnBNYiszVlNiTC9SU2tm?=
 =?utf-8?B?N1lyQzFmSDJQMzNKVjlYSHFYeFA5UExLZUwyUlA3SkhVRnZoUDk4RWVFZStW?=
 =?utf-8?B?bDBJbldncTJYTEtaWnN4clpuVHRHckVmSzBTMDFpRjlPYlFnZVlZZjZNdXNq?=
 =?utf-8?B?QkNxL0xSbDJpZTNLWnpiR0JKaUgwNFc5L0d4Qlk5dFp1Q0EzVVZjeVJjWFQ2?=
 =?utf-8?B?QjJvUUxkQ2Y3eWUxMUsyY2hQdHYrUXBwN3ZreTRuMlNqbmZ3aTVmQUtOcGFq?=
 =?utf-8?B?WUE2N1BnY3FqbE9xZitSUGdDcnJockRPUDdXYjFXMXNkalpQY2ZyWUI2YXUx?=
 =?utf-8?B?bEpwQnBTVEtmYnFJT0liY1NBa0VBM3FaQXRyMXBoYmIwbEd4ZVpxbklUMFhB?=
 =?utf-8?B?R1ZmKy9rYVhOdVlkNTFrUXRTSHJXOW5ZQVJ0OUQxZ3dNTjFCc3Y5emEvU1Y4?=
 =?utf-8?B?T3oxNlJ5YWZBZE1neTV6Q3Q4ZnNaRE95T3h3VVZET0NLQ1JxazY0eDVVUFpi?=
 =?utf-8?B?ZWdWSXJIbGk2TGZETXkxQmJRMHQ0ZDZWbVV4TmQ3d1BZNkppc3gzT3ROVk5V?=
 =?utf-8?B?V0UySHpObVMrUjB2TE9ESTZqcnBiVFdVbHZ5QVRsVnVncWN2cmRQZk1iT052?=
 =?utf-8?B?Nnh6b1dFNk1Od0tHcGt5RTVKK3VKTUpNT0x5U3pwZ2tsZmpoQ2MrRUsyL0FJ?=
 =?utf-8?B?aDR0RXcrTHVWNnJxeUIyVGxncDNjbEJMZDF6YWFKb2I5azVMUXIzUmU0R2lh?=
 =?utf-8?B?RFp0RnVhNXgrUi96bzFSa244SXdJN2c4RlZacWVJRGZjTlkwZVZtcE5ZL2Js?=
 =?utf-8?B?RnFtQWJuZHM5ZjQrK1lweUtqMkJIclF4emJ0aWpLLzR0dzB6ekJYRTJYSHZM?=
 =?utf-8?B?aWVVV1VJUjJoenI0L09qbXRJalJLSFBNOU5UWm84L2M2K0UrT2RPMFQ1ajhF?=
 =?utf-8?B?dUhQckgrYVk1MWJoTFN6WmE5SDhXTHAraVNnMjRaVTVvTUtiYnRuQURFZUtY?=
 =?utf-8?B?eXdSNGZscWR1MXBXQysweU96S2k2dDIvbWZxbWRFUG1zMWZlZGtQc1U2bG4v?=
 =?utf-8?B?OXZvZlJwaWZPUjYvYUdDT2xzaVQ2SEdIb0oxK01IRVdEVzNIS2x3S3BMd3pC?=
 =?utf-8?B?MkZiSFBtYnphdzVlcTlJSzl3SDNma3JTNXJBS2tzUEVnbHZhMEV3bUtCbEhz?=
 =?utf-8?B?a1NnQ0x3TXZ5T2hZK0dZTnhhQ0pHOXpTcDBGQkxMVEQvSlF4Z1NmYmtjeDRF?=
 =?utf-8?B?QzZuYmVoODJRL0w3TGFObEYzT21EMzdBcXlxZ2NlMEFTWDF5bTNVRlNFaTJU?=
 =?utf-8?B?aE1ERnVlWlU1YUE1bkZjdWg4clMwM0hYZEx6ZG1vMU9aaytQUlVzT2RidjZB?=
 =?utf-8?B?SFhtMnBrU01hWG5pbExtSklJOHZ0RW5HNnh6NE1RTlpHdklqRUtrWlB4cnJ2?=
 =?utf-8?B?ZndnQit4RkFxMHo4bUdPaGE5TUtYSjBDRzhxQkVpKzFONlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <284FADD1F3926D449FE6FF6BA8AEE4F6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abd7e78-5617-4d90-8f16-08d918dfa3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 02:58:25.4267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjSv/Ur5/fdoD0BQhHXpxPaqFxH8sm8zGjibUnE+XymLt9FRfPJ+WPXsxmI+zciWTyxVE7WjK0CywI+3UAxlrLQV6SpfWAQlR9k7aSs7b18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3809
X-Proofpoint-ORIG-GUID: nfn7XBzk9sZs_EQr_VNxSQQwGusLCBQL
X-Proofpoint-GUID: nfn7XBzk9sZs_EQr_VNxSQQwGusLCBQL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_01:2021-05-12,2021-05-17 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDE0LCAyMDIxLCBhdCAxMjo0NiBBTSwgQW5keSBMdXRvbWlyc2tpIDxsdXRv
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gDQo+IA0KPiBPbiBXZWQsIE1heSAxMiwgMjAyMSwg
YXQgMTE6MzMgQU0sIERhdmUgSGFuc2VuIHdyb3RlOg0KPj4gT24gNS8xMi8yMSAxMjo0MSBBTSwg
UGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+PiA+IE9uIFR1ZSwgTWF5IDExLCAyMDIxIGF0IDAxOjA1
OjAyUE0gLTA0MDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiA+PiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vZnB1L2ludGVybmFsLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUv
aW50ZXJuYWwuaA0KPj4gPj4gaW5kZXggOGQzM2FkODA3MDRmLi41YmM0ZGYzYTRjMjcgMTAwNjQ0
DQo+PiA+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUvaW50ZXJuYWwuaA0KPj4gPj4g
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vZnB1L2ludGVybmFsLmgNCj4+ID4+IEBAIC01ODMs
NyArNTgzLDEzIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBzd2l0Y2hfZnB1X2ZpbmlzaChzdHJ1Y3Qg
ZnB1ICpuZXdfZnB1KQ0KPj4gPj4gIGlmIChwaykNCj4+ID4+ICBwa3J1X3ZhbCA9IHBrLT5wa3J1
Ow0KPj4gPj4gIH0NCj4+ID4+IC0gX193cml0ZV9wa3J1KHBrcnVfdmFsKTsNCj4+ID4+ICsNCj4+
ID4+ICsgLyoNCj4+ID4+ICsgKiBXUlBLUlUgaXMgcmVsYXRpdmVseSBleHBlbnNpdmUgY29tcGFy
ZWQgdG8gUkRQS1JVLg0KPj4gPj4gKyAqIEF2b2lkIFdSUEtSVSB3aGVuIGl0IHdvdWxkIG5vdCBj
aGFuZ2UgdGhlIHZhbHVlLg0KPj4gPj4gKyAqLw0KPj4gPj4gKyBpZiAocGtydV92YWwgIT0gcmRw
a3J1KCkpDQo+PiA+PiArIHdycGtydShwa3J1X3ZhbCk7DQo+PiA+IEp1c3Qgd29uZGVyaW5nOyB3
aHkgYXJlbid0IHdlIGhhdmluZyB0aGF0IGluIGEgcGVyLWNwdSB2YXJpYWJsZT8gVGhlDQo+PiA+
IHVzdWFsIHBlci1jcHUgTVNSIHNoYWRvdyBhcHByb2FjaCBhdm9pZHMgaXNzdWluZyBhbnkgJ3Nw
ZWNpYWwnIG9wcw0KPj4gPiBlbnRpcmVseS4NCj4+IA0KPj4gSXQgY291bGQgYmUgYSBwZXItY3B1
IHZhcmlhYmxlLiAgV2hlbiBJIHdyb3RlIHRoaXMgb3JpZ2luYWxseSBJIGZpZ3VyZWQNCj4+IHRo
YXQgYSByZHBrcnUgd291bGQgYmUgY2hlYXBlciB0aGFuIGEgbG9hZCBmcm9tIG1lbW9yeSAoZXZl
biBwZXItY3B1DQo+PiBtZW1vcnkpLg0KPj4gDQo+PiBCdXQsIG5vdyB0aGF0IEkgdGhpbmsgYWJv
dXQgaXQsIGFzc3VtaW5nIHRoYXQgJ3Bya3VfdmFsJyBpcyBpbiAlcmRpLCBkb2luZzoNCj4+IA0K
Pj4gY21wICVnczoweDEyMzQsICVyZGkNCj4+IA0KPj4gbWlnaHQgZW5kIHVwIGJlaW5nIGNoZWFw
ZXIgdGhhbiBjbG9iYmVyaW5nIGEgKnBhaXIqIG9mIEdQUnMgd2l0aCByZHBrcnU6DQo+PiANCj4+
IHhvciAgICAlZWN4LCVlY3gNCj4+IHJkcGtydQ0KPj4gY21wICVyYXgsICVyZGkNCj4+IA0KPj4g
SSdtIHRvbyBsYXp5IHRvIGdvIGZpZ3VyZSBvdXQgd2hhdCB3b3VsZCBiZSBmYXN0ZXIgaW4gcHJh
Y3RpY2UsIHRob3VnaC4NCj4+IERvZXMgYW55b25lIGNhcmU/DQoNClN0cmljdGx5IGZyb20gYSBw
cm9maWxpbmcgcGVyc3BlY3RpdmUsIG15IG9ic2VydmF0aW9uIGlzIHRoYXQgdGhlIHJkcGtydQ0K
aXMgcHJldHR5IHF1aWNrLCBpdHMgdGhlIHdycGtydSB0aGF0IHNlZW1zIGhlYXZpZXIgdW5kZXIg
dGhlIGNvdmVycywgc28NCmFueSBzcGVlZHVwIGluIHJkcGtydSB3b3VsZCBsaWtlbHkgZ28gdW5u
b3RpY2VkIGJ5IGNvbXBhcmlzb24uIE5vdw0KdGhhdCBzYWlkIGlmIHRoaXMgcGVyIGNwdSB2YXJp
YWJsZSB3b3VsZCBzb21laG93IGdldCByaWQgb2YgdGhlIHVuZGVybHlpbmcNCmluc3RydWN0aW9u
IGFuZCBqdXN0IGVtdWxhdGUgdGhlIHdob2xlIHRoaW5nLCB0aGF0IG1pZ2h0IGJlIGludGVyZXN0
aW5nLg0KDQpGcm9tIGFuIGluY3JlbWVudGFsIGNoYW5nZSBwZXJzcGVjdGl2ZSB0aG91Z2gsIHRo
aXMgcGF0Y2ggcHV0cw0KdXMgaW4gYSBiZXR0ZXIgc3BvdCwgaGFwcHkgdG8gdGFrZSBhIGxvb2sg
YXQgZnV0dXJlIHdvcmsgaWYgeeKAmWFsbCBoYXZlDQpzb21lIHRpcHMgb24gdG9wIG9mIHRoaXMu
DQoNCj4gDQo+IFJEUEtSVSBnZXRzIGJvbnVzIHBvaW50cyBmb3IgYmVpbmcgaW1wb3NzaWJsZSB0
byBnZXQgb3V0IG9mIHN5bmMuDQoNCg==
