Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A669376960
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhEGRQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:16:48 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:45790 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234529AbhEGRQq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 13:16:46 -0400
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147H8112028984;
        Fri, 7 May 2021 10:13:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=HZ5QyJV2uK/dZZ25EQTeIPfB0OqUOWiDT5DFJZfB2E0=;
 b=BowGG5+R50prkRC5XilJInTbGEX09GN2dTlF715Y2K0EC2HNcNE0a3gwJH4sQLFSNysP
 FJ1SPu7xzn0XOrfV4WHNO42uUPfdfPfYui4DXEOiZoPEkAWbmqNX/TI8vm613qHTaH5e
 WXdYBB4N0Ojv68RgBEG7ofEUX2GmKSUEqtrH+lZu8pWtXJGvgtEwybtIHA8aRTD9eKFR
 kQaRangLHCHsRm8WnteVZ6YBq8Sju/B3+9NCJeXSYuK0xW0ajVaIM3uMFjFgjZe8d3r4
 D1jwy9uJLelj502hEx2GtOQUiUIUlZR9klATVv14ip2klvCfMGv+TtZu6wvJjqbgs6HD +g== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38csqpsrjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 10:13:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDh9sHUqfGWq3NrjD5cZc4Y3rmOH/l2rxINoyf6I1Q/m6t6FOD2daVuUG5PSz5NjU5BQnNfUSiLn5l3rcXb8vxLGifToHKBdh006micq1+xEFuDLnXEsVJekhbItMX0M42J3xkXrK1Wk+82NiVNNEUVRbRAfkrktTBQxRw1aNFyGNYT9fCEfV0t28CvqIUjchANSPicokYHItuBFPrWOezRL4Ic1Ctx2Qg1dSKMwQxhgSAvvDXPPAGp9RZGH0sKUsAeTYUTxcR54sKhCukJJLMQgOvFC+u8PG1vsP2lvKpeXRBuiVeYldkRft0u2MvfSLv1yunT082fF7p3jjm4M7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ5QyJV2uK/dZZ25EQTeIPfB0OqUOWiDT5DFJZfB2E0=;
 b=Re4yw6jYT/ST1V0n396XhrpWfv2YnhBLRxegCUfg5ls7ZkHaZhDNLIQ31mjxkkCsjaEhGkdRiGxExcSxOEf1+wDAfJ4P/vErSw7qmZRYvQ7paPrd0ZCV1/EcWGx6MlJ/qU+qKmQO9ZlDSPbaHUhlWruCK3bXaYdrXEbsL6jJd92Mf7el0Vi4AhdYvclQsCZ86Wtlp+jrZ3q9R5BqMTHh4VpSU217/dDHfJiW4ntldnQ0gNAAk3iNe8jXkj51vqKpafZQxTnBa8+CljFRFmC7c4XHh0nlmf1S7wlhnGdUY9V6JTdac1bkgFlFm9o6JRlmWi+NavaYQ3D9+kQR3jfZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL3PR02MB8100.namprd02.prod.outlook.com (2603:10b6:208:35f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Fri, 7 May
 2021 17:13:36 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 17:13:36 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, Jon Kohler <jon@nutanix.com>,
        Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Thread-Topic: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Thread-Index: AQHXQ2BcR+stRakKBECUXHbkspHLPqrYO+SAgAABzgCAAAQtgA==
Date:   Fri, 7 May 2021 17:13:36 +0000
Message-ID: <4E9EC06E-4575-44AA-89BC-619439385521@nutanix.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <16af038e-5b30-2509-4e3b-3b3ed9d4b81e@redhat.com>
 <709442d7-68e8-32a8-05b4-8a16748d9f11@intel.com>
In-Reply-To: <709442d7-68e8-32a8-05b4-8a16748d9f11@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88361db1-d561-4b30-e932-08d9117b736b
x-ms-traffictypediagnostic: BL3PR02MB8100:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL3PR02MB8100BFD3214623003E085567AF579@BL3PR02MB8100.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oixjfdwGHngh+RP3iTSMj1HtLzsX3RNnPK077dGa1siTtAELnTfXwMeAke8nWjhur94r9tiGRFgyJ1bNQGfzABXFD17kt2jTFsItYc3KI8kSgKT6h0cpqlqBhEYPBtlpz9ijGcb7HJDcI3hw30R85s1rH24WNRx+8WhRFL1XJV/QtRsUR36YmfwbaNHT4atny7lLBr8GCEWZMqnGwTCGsmOfhHyrqYy6u9hVN+l7vdHh6aQEjEyyzzWSi5c3EZnzJRxsgKtg+TrEofw6kYSNrTk3lsvxQ0hyXSY0cAZQLRNyyQExMwjMRHmHA7/u44JOwDpeU0l9fHVdKf/fTJdZZOrihFsxlR5Po7JVGZoPuIT+kmGvlaDnqncXZlvZEEsQrRh5eVZBhczdvzbOm3UIiKUUFYalnUXXqUUdglHWKvFUX7PW2zLWDjotiHo5ReVEqkLxo3k29Wbg8GWeK3ADrmJeKlQBOBVBVf6ET+r75WoK6ehHFgnWc+oQNoWzSAThuxsN7EcXW62eeVUfndgWhZXADsMgHKIhSltVHi5BwqUvvtXJpy/xWJBw3OgpAUWTm7/R+kWxRXmpi84jrmNGMgrsw9eVfjjaaOi6rc8hOG5H1nPx6OQmdwef1ayAa/smMpTMvUZOCiZcmJ9XQ6bG5QyxY3uFV/CEWSdexeqBoyM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39850400004)(366004)(396003)(136003)(54906003)(71200400001)(316002)(2616005)(186003)(76116006)(66556008)(86362001)(478600001)(6916009)(66446008)(64756008)(6506007)(8676002)(66946007)(38100700002)(122000001)(8936002)(66476007)(53546011)(2906002)(5660300002)(91956017)(33656002)(36756003)(4326008)(6486002)(4744005)(6512007)(7406005)(7416002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2ZrdmZCei9wYmp6bHFGTFowai84cTIzVkZBbkxIQnA4UEplaFNJczU4UkY1?=
 =?utf-8?B?b3kzMVpaZTFhWEpmN0oyWVY5SzhtTkRNaVJFbzBNRXZwbkh3VTBMMHNicExE?=
 =?utf-8?B?WXdCd09KZVVnWE1IRHRxZHg3dUdKbVl1YVZFZ3BnTG4zWElqQTlkSnpienh5?=
 =?utf-8?B?ekxPb3JqeEY1dkNPaGdpZUFQeXI4WkNvOENkN2JXNUx0TnllU1prRldVNytl?=
 =?utf-8?B?Y21TLzRUZ0QxajJRTlJxQmttNTJUZVVGMjU1eUh3TmpxM1lCZERTN3JUWXBr?=
 =?utf-8?B?RkE1S2I4ZnhUVGFYb05GbDk3VDMwNlljMTA4cm9uamVjbzRkamRZcWhwVWJE?=
 =?utf-8?B?SnBGUlhQWm1lYzh4UWxEaDF1NmdrT1pnTnRyT3ptVTVwQ3JreUViMS9MQ21h?=
 =?utf-8?B?N3YvaEtyVGFUbG9NVWY3aEJYQW9oUVJ3dDlUSjFVNjc3OUs4MzNKcURubDBC?=
 =?utf-8?B?UjVLMDhSVmJxakNUcmhQNnpZTC9zSDNpeCs3cWg3eGFsTlQxMFdJYkd3aXVD?=
 =?utf-8?B?SVFqWklkNlVyRlo3cFYvOEcxT1lwMHBWOUtwYlJMYzNwSEZrOTh5UTFOTVkw?=
 =?utf-8?B?MFNKcGszVUd4UWlpdHg3OGptcmdsdUdJSFIvM2s4eXFoVEtnUFZneStqRW93?=
 =?utf-8?B?YzNOUFRPQituejBsRVJPUHJnNE5SK2RjYVZnK0UwTUs4dStPUUdrZ2Jja1or?=
 =?utf-8?B?WXBSeXlrRWE5NkpvbGhpWEI5YndpMVV5cW1SU05uMlBQaU44RVYrdTJ6WXQv?=
 =?utf-8?B?YVYvaE1paTU5bmZ5T3BMdk51dThNbUd5Z05IZ1hzNXAyckZQZ3RvRkI1QUts?=
 =?utf-8?B?U2sweXVVbkFtRWRKZzRhZmlyVC9HWGR1Ti9QY01udkRSQ0RIemx5TlNVamxp?=
 =?utf-8?B?ZURaWHdRVitoTUtranptejE3ZXZFVmhzWEhSVUtmL3lGVmtVSzN6dlgwVmVr?=
 =?utf-8?B?TjBRdUh0dU5xeDVWYTdleTd2bDB6bnA3UHlPUTFIOXgza0YzQUxIMFZvVHZ5?=
 =?utf-8?B?WmNGc1FyK2xJY2pvRmU3T2NkYmZza3g4Sjk3VVNldFVFbGtxZXZrL3FSOU94?=
 =?utf-8?B?SDFTT3VROWpWNU5OWmZwa3p3K1JmdGMvWXBFK1Ftem42d0laTGM3T1ZhRkU3?=
 =?utf-8?B?bnNKeHhibytzZmVHWnIxOCtFZVZIaXNTT1d1cUVvRzUyWDVCalFtU0JvK3k5?=
 =?utf-8?B?TkIzSnBIb1laZEViVDQzS1pFTFQ3VlI3Qm5xOXYxRkh1MVpwRlNMdXo0bHBa?=
 =?utf-8?B?ODdmd3doemNFT0NNR2FGWEFCanNqMUJaNThOcXNIZWRibVJibG9mc2c1R2hH?=
 =?utf-8?B?YkJTUjNPZjg2TzBNZ3diYmhSUlZ4U3ZMZkdodXlqM3FEc2hPdElWNDVSNUhy?=
 =?utf-8?B?R2RJMmZwZHpLOXlZUXdvcUZxU2ZUS3dSaXRFUnVJejgyVmdrSlRMNCtYSW1n?=
 =?utf-8?B?OUZFQWpwRC9xM3hFR1M4SGJ6VWZhRytsTkZkeDlURDk3WWJMRW1ycDdCZ3du?=
 =?utf-8?B?bW1zWmV3ZlUrWWE0OEdSci9LS1NLbENQTnFhSjZMREV5U2wweTB0RzF1Y1Zh?=
 =?utf-8?B?Vk1YeTBtRnk1bCswNlJRR3o0QTBZTzE0WVdSZzN2Wmh6UkdhK3hFaWRvbjhl?=
 =?utf-8?B?S0FRMVFqQTVGYkFiaUxnT0lTcmlCMGlLbWFsLy9XaUxiTzJmc1ltb2JzYkl4?=
 =?utf-8?B?NnhlMnZBa3B5ZmcwNlNPNTIrbWU2dXhWL1kreVNFZnBpVEhaNWswejk0QUtZ?=
 =?utf-8?B?U3lkQVY5eUMvMitqR1pzajhkeHQ4QUxqdk56RlFxSDdhbUc3L3EzRDJKWTYz?=
 =?utf-8?B?R3M2enNGVHRxekxYbmhwWEJ4VFlWRm5BTnZCOUMzTEMySUxJQjM0MzUzRXhN?=
 =?utf-8?Q?iGZ+4fKtcGXhJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81469FE72A7D32448E0C097F01A0C673@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88361db1-d561-4b30-e932-08d9117b736b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 17:13:36.3088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pf+1My568OfBBbf3ZT1NC+65rZl+OWwnwM8YB8GiAlYJBecVsIG+0lXOHf/qK6WrFs8h3Ya6pnpn0Cjmksp6gKC+LRdVgb4CrWyhR641p0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8100
X-Proofpoint-GUID: 3XbVcZOIABGwob2GFqxzResqqBnOo72y
X-Proofpoint-ORIG-GUID: 3XbVcZOIABGwob2GFqxzResqqBnOo72y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_06:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDcsIDIwMjEsIGF0IDEyOjU4IFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDUvNy8yMSA5OjUyIEFNLCBQYW9sbyBCb256
aW5pIHdyb3RlOg0KPj4gVGhpcyBjYW4gYmUgb3B0aW1pemVkIGFzIHdlbGwsIGNhbid0IGl0PyAg
VGhpcyBtZWFucyB0aGF0IHRoZSBvbmx5IGNhc2UNCj4+IHRoYXQgbmVlZHMgdGhlIHJkcGtydSBp
cyBpbiBzd2l0Y2hfZnB1X2ZpbmlzaCwgYW5kIF9fd3JpdGVfcGtydSBjYW4gYmUNCj4+IHJlbW92
ZWQgY29tcGxldGVseToNCj4+IA0KPj4gLSBkbyB0aGUgcmRwa3J1K3dycGtydSBpbiBzd2l0Y2hf
ZnB1X2ZpbmlzaA0KPj4gDQo+PiAtIGp1c3QgdXNlIHdycGtydSBpbiBLVk0NCj4gDQo+IEkgd2Fz
IGdvaW5nIHRvIHN1Z2dlc3QgZXhhY3RseSB0aGUgc2FtZSB0aGluZy4gIEl0IGRvZXNuJ3QgcmVx
dWlyZSB0aGUNCj4gY29tcGlsZXIgdG8gYmUgc21hcnQsIGFuZCB3cnBrcnUoKSBpcyBhdmFpbGFi
bGUgaW4gdGhlIHNhbWUgaGVhZGVyIGFzDQo+IF9fd3JpdGVfcGtydSgpLg0KDQpUaGFua3MgUGFv
bG8sIERhdmUuIEdvb2Qgc3VnZ2VzdGlvbiwgSeKAmWxsIHdvcmsgdXAgYSB2MiBhbmQgc2VuZCBp
dCBvdXQuDQoNCj4gDQo+IEkgYWxzbyBkZXRlc3QgdGhlIG15c3RlcmlvdXMgdHJ1ZS9mYWxzZSBh
cmd1bWVudHMgdG8gZnVuY3Rpb25zIHdoZXJlIHlvdQ0KPiBoYXZlIG5vIGNsdWUgd2hhdCB0aGV5
J3JlIGRvaW5nIGF0IHRoZSBjYWxsIHNpdGUgd2l0aG91dCBjb21tZW50cy4NCg0KTm90ZWQsIG15
IGFwb2xvZ2llcy4gVGhhdHMgYSBnb29kIHBvaW50LCBJIHdvbuKAmXQgbWFrZSB0aGF0IG1pc3Rh
a2UgYWdhaW4uDQoNCg==
