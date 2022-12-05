Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E88642B13
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiLEPKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLEPKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:10:33 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AE11B8;
        Mon,  5 Dec 2022 07:10:31 -0800 (PST)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B59Lqix025970;
        Mon, 5 Dec 2022 07:10:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=SBhh4ABMfIaASxQz0lmBW/E3tTadcWsXUMAVmd8Sr2g=;
 b=wPK2rFYmgjmy0kZ/4nKqh2njjUTRH0bgqkM/QZ60ko33Z3wTUno5uTvDKuP0qrO07TuK
 gsLX/S7fS/lCRPzwQ2+XCPZ7cre/NPWuXBC3+ImoZybgFgB12xGlEeHdiA9dtfmnkkDj
 XxAuPpJtz8cef8G72jesr5qtyKU3+MUTsi2DlnEgub6sZAiY54OGrJzkLdOwR+e6eyaE
 U/JJSz3ExzAVHTgZ4l+X0tZSZmTh6arBCyzhEzc6EsIXu/0gPIIfcB0xjmqFzT5SgZZ7
 rULMwvjGHEBBvB8c68TcRFaP6t4Z2kS6hOhp8/kWUMXKaG7U4vK1+yQhMtxTcbJ+krhu EQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m84ve49ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 07:09:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqX3OzkM6346mz8+5YrAomDqVysgvC5W9vu38+2rf6Y6fY7ABto7t6bItCutP9fNJxqk9duWKZzOmlpz/2mUV4HMWs0INyzUgALh1UJvv+GfSksWguZVSpISrENvvKy0PheGR9xsnbdhopBVugDVsN1JaL3/xSUtNMzSAfyMkRz0yybfZ5vxYmO5io+tekFmfI2o1jMmL6Is+ekVuTlzQ6Jz7dTAPMlmEuMhGtpbA2vZkA17HMtV+81NGai60vxj+ZZFcQ/znKGwNU+L+Z9pK5F6rHJcXP/0l4Oftc744HGvkkg+LoDP4KhNsUXtKBPr8gcVM4s5skxxoPMT6i1YxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBhh4ABMfIaASxQz0lmBW/E3tTadcWsXUMAVmd8Sr2g=;
 b=FtqSEKR6nSCy7lgKNYb9vUPfnAMrX+P6CJiyX06tysuP6HsOkm2r7dAuUMVVr9ln5Qh7dJBKhFl6JyFra7GgvT/FXznaik/RSjDd7vlH5lzlIa0WMd/nZf3uQng7rDH5ZFIvHfl7hKzpckaV/z44p4jb5w0PdqdNtKq0Wu6D1hFsGcrfQzVy5N4Br5b/O1q/vfoKs7NLJauGtUXEfkBGVCJcAAGFR3WqyTEVwjB4mMV3TSJJwU06WXwJEaOu7Cc9bVW+lsaZi6n1LOJT2XORBxpvdBbtDz58KhM10dF8xMFboYiA4O09hCqtsIMCPlEg2gsws9q3swdUGmlfbHeOOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBhh4ABMfIaASxQz0lmBW/E3tTadcWsXUMAVmd8Sr2g=;
 b=NIONQoKbkjGb8lsK80JagfwvQJdM8qAqtW0o5mudSWNaCEsDGMTe93S3EKjaTmgziXWN3Xv3QNAjx2mQc5TWdOcF0t55v6XFv7Arpemf8395CJ2eMkU538gvynfka3zS9pSRNjxQCuORvslIFYV2mky7FlNFvMUb4wLuCmC2g+RJ9Z7pITSNJpaPbU1QzU+PPYGcENlux8ZBnB/jTjCtV6YbaCFA/KFzLu/2K6lj4I0yJ7DM0Vw8LrmZKEwouMmMrgQVClX50r8+6/m/Pqzh39jW6HrmyiZwCz02pkNDO+3Hwfv7ksCmSJmZ6UhOSMYIHmvCQusr3vgMHS9oSn+WhA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by IA0PR02MB9512.namprd02.prod.outlook.com (2603:10b6:208:409::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 15:09:58 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::aecc:4b4a:421c:da1b]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::aecc:4b4a:421c:da1b%7]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 15:09:57 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Topic: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Index: AQHZBB+UbwHM6Ykv6ESmts8I/MP46K5ZasuAgAYEOgA=
Date:   Mon, 5 Dec 2022 15:09:57 +0000
Message-ID: <B9071742-7C64-40F4-8A93-D61DC1FD4CE5@nutanix.com>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4j9u6YEpJ/px6kj@google.com>
In-Reply-To: <Y4j9u6YEpJ/px6kj@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|IA0PR02MB9512:EE_
x-ms-office365-filtering-correlation-id: 430163b5-9ea3-4b00-d6d5-08dad6d2c5d7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: npBCg3So190cjI47vZBQCMAbGQIxdbHm3QCJD+sc/Tk2bBEEVB75zL0RBieFtXL6BFXfII4oEzqvVqIAC/n6+Op31D4QAqWl4AUMdSzZt2ZJvXD74JDf5mNdM/7a2o0sfGqVRGWwl63hjmRL0z5WlBL+THuy/79yqhSObxd59nvrhvHtJNUvRAhF69hksKdzPfHRrAiLCUpyL1066dGUO1I/kFza0grpDBTzYw3jzeWmVigWGwGHVCjJB6UctMTxiXYEWW60iyOyY18ZQcKbD3pYAoUcAXcZsd+PAmfKgKBJEC9Gasc5rRdKhyKtlAWWgFBeXzGYc3nUwIQMmkXYSZeAHDZ4tI2mpvie9uNPZNE7MnUWzqRloLsLIm4XxOl73dlxOc1BvgxCwI3wKLGyJdCdgdK4o95kkxtPUB7LobGQztoT+VEwktGf8b5b5C09PChQ6oTRPdOc1jVSsWECTkC7oz2H2H1yb8B7Qm1GwvEJai6i6/zpJEaFT4tsXhcy07zgIQgmGhP27NnplikhNdwsrhaF42E9H+8qZ71XWFrLC1pp030j8vVeYVDvuWgHEyAsnImEYxE60agY6Er3Le3HzI4f0G86ZP3X/u8MKTR7i6x87fQjdrBEnmqNOaBfrKRWp5SORHqd+RDJUIfMnHHP9GXavGz3Kvfvuz0QORMWwLvtJddwGZOlmGW/4SNAYXe6/gEmmnb/HxJdFuR1KLSvWENATU4CRi3+UmGw3AY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199015)(2906002)(6486002)(4326008)(38070700005)(478600001)(33656002)(316002)(53546011)(36756003)(6506007)(54906003)(91956017)(6916009)(86362001)(66946007)(8676002)(71200400001)(66446008)(66476007)(64756008)(66556008)(76116006)(83380400001)(6512007)(186003)(2616005)(38100700002)(5660300002)(7416002)(122000001)(41300700001)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2U3aEgwYjAxSno4T1ZLTVEySDl5ZmxZMjlrcTlzMEIzSXZOYVVQUjl4WExS?=
 =?utf-8?B?US9hN052VU51em5uODBwV1o2M3EvZUtGUWV0VHh1L3NxaWtWbndjS3FkLzBK?=
 =?utf-8?B?bjNsMW9tUFpFM21lL1BnMEtISnZoNUxPYlpnYlFWMXZJU0hpNzFOanNzbjFD?=
 =?utf-8?B?QloxSWdSY0pVeGxEM05pYVBiMGQ0b2FTRGl4WHdaYUZiVmwvRGY0YmExMHRv?=
 =?utf-8?B?TExYUG1oMzM0WWlmVFBaNnpReXZ6bmhUN1BqTWVBYzRpTE85a2EvbUxrdDZL?=
 =?utf-8?B?TkhkRkx4WjZwOExhRnVYM1M2bzFoVlZSQWJmVzMxZnUreTRKQUlPeU1Pb0lB?=
 =?utf-8?B?R3VWSnJZeTVNVDZDWmJvVDJ3VmwvWGk1UHYwUWpnbm42anZ0UHorR0piQThW?=
 =?utf-8?B?MXhLaVNPaVROSzQrTjJoVTNxc2sycHZhQ2VGeUxyWGJGM21KZnVaT0ZSQUw1?=
 =?utf-8?B?aTV3NXZ3QXhOYUsxWVVDVERxdS8wRHRpaVUwcWRqQ29obFI2T3VQQlRrN0Yx?=
 =?utf-8?B?NTYwaWpYWkxzZUsxYmNxTlZTWFhHN3R0Vnl0YW90UGpqb3VuTS9UTUtCVWFL?=
 =?utf-8?B?K1RJUXpaSTA1Sk9ZOGNnbzUrRjR2dkRLb2ZDb3RXN0pEQWdwZDFvK21QUEdB?=
 =?utf-8?B?S3pSbUlKYjE2SjJ5QnNMbGNMaktER2ZINy9WM3pVUEI0N0R6WW1kZC9EbFlX?=
 =?utf-8?B?RVJmdEpKNGNodVkxSEprYURDdExLbUludlVLMGJoN3lVdG45NFh2bHVTSEQw?=
 =?utf-8?B?cElWVnk2YTB1QWhHUVV3MXVlZDlXbWhia3Y3T2s5UTF2OTE5VmVzMnVTOWNB?=
 =?utf-8?B?aXNiUUpuQjZ5enQ3b1dQcWlGZ3JrNGVsV2NRQzBtSTBKRzBidUpTRkpvVG5u?=
 =?utf-8?B?Sy9VSzRsWEZDY1JYOGZ3VHNibk9IWlRCdDNXNno0UlljTGtXVHBjaWJqS3Iv?=
 =?utf-8?B?VkVvS0xVeVE0WXdveWdWMlJzLy9XSjJ0ZlQwRlNSdlFaWGxyYmF6b043ZHp2?=
 =?utf-8?B?UXBGUVJNUWpDRjZIRk1oSGJ3bTZSUEdjTWtUVkh4bjAvUHVON1ZlQmdhMC9P?=
 =?utf-8?B?WGpBMVExdFRTYzE3UVd4S3FGT2R0dytMZDJReVp3RnR6QmlPdHlvbmlBYW9D?=
 =?utf-8?B?UmoxaFk1TmI0R0pZNFJsZk8rL3NmY3FlV3RFMzQvcDh6TUlBVDk3SXNIa0xm?=
 =?utf-8?B?ekhSUi9iVmpUMzVVRk5OWXpwcC9qZEx5SjZySXZ0cE1LS0hsb2JMeUhqK25H?=
 =?utf-8?B?aFpISjdKM1BRcFYxRSs3V3p2eUw0emJNbkQvNmU3OVZpMDV5Vnd1T0l1VlhB?=
 =?utf-8?B?TmlJRndlSmd3VjZJRWpSdGExd1REcEI3bW9CeHhoT0R0MVJRUHVzS3A3ekV5?=
 =?utf-8?B?RDFpdldqMzVBQlh0VWFsSFNHUXNEa253L3BFU3M2U1pBRVVPSmlJR21mejdq?=
 =?utf-8?B?LzNIeWZsSWpYWjNXQUhkWG9JR05KeHRBN2YwbzlWSW1vNkRKSmdISzhOWnZP?=
 =?utf-8?B?WGxMQVA3S1YwdVhzdlVzNVh6YVp1M0N2d1pUMkNRbHY3VGROaFE3MmVmUFRq?=
 =?utf-8?B?b0s3QjUxaDBpZTc4NEdYTGNzcnhaZUVhcW05bk9zdUxkN2hVcGtVcW5rU280?=
 =?utf-8?B?RjlxWS9ITUFmeFhPS3dqZmZLeW5jOFozT3NiQkVGN0diajgrR0NXOG1NalJl?=
 =?utf-8?B?WGNvcE0vaFVQNTEzR25paHBmT0dudXpHSXV5ZzNMd0xhNmFYWGdBWDdQMk1U?=
 =?utf-8?B?Y1NzKzNkd0FXK1RxdHFuUW4xRmFFL3FHV2ZaRE1FYmppTGNicnBGTkg5dkRY?=
 =?utf-8?B?Z3Zqd0pNTWl1dHltY1lBNnZEcE1peXFlNTF6WU1xbkdWd3RGcUtuZ2pycnN1?=
 =?utf-8?B?UEV0OCtJdU05b3o0TDZqNXJBbFRnNTN2SmczbkJ4SDlGc21KVk5EM0ZnaWMr?=
 =?utf-8?B?SWk2c1ZJN2hWSnZWWGxwdHJXaEFoNDR3WENOK3h5UjJ4TG9MWEJWWTFiK042?=
 =?utf-8?B?Y2dMNTN5V3pLUkNUQ0gyS2puRnN4TGdReS9lMmxSOFAxNlFyOXlsZnFpQy9l?=
 =?utf-8?B?ZmJ1KzFka0Z4WFJJOG5Iend1VUNkZTlvOWw0WUR5Q0VIeXRjNy9pbTE1dUZU?=
 =?utf-8?B?YzF4dGg0NEFMV2N4RUJZQXJKdmFPM1NWTktBMzlMRnBjSFdxRVFLS3pKbktV?=
 =?utf-8?B?R3dFSEsxR1A1bmhxSzZCVEorUjlVa1daMExOa2xlTnZrV0JiSkNmUVdsVzcx?=
 =?utf-8?B?RUszRCthNWMxRkgrZkY0bmQ0aW1nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5134C5ED93CE447A53CB698D0FB53B4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430163b5-9ea3-4b00-d6d5-08dad6d2c5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 15:09:57.6454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vXmD+EIwrfa4Gm8/XHRkiIfYIN+jocR0HSVv5YR0mHd1bmqeHhgyCx/EUV6dlrvcFWUeUoFKQqcjVhTq2wVIygXuADDGojdK+zFgfnbP7+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9512
X-Proofpoint-GUID: wZSGTRAEDL-u0VN-syIMjng468AO69Ys
X-Proofpoint-ORIG-GUID: wZSGTRAEDL-u0VN-syIMjng468AO69Ys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gRGVjIDEsIDIwMjIsIGF0IDI6MTcgUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgTm92IDI5LCAyMDIyLCBKb24g
S29obGVyIHdyb3RlOg0KPj4gU2V0IHZjcHUtPm1vZGUgdG8gRVhJVElOR19HVUVTVF9NT0RFIGFz
IHNvb24gdkNQVSBleGl0cyB0byByZWZsZWN0DQo+PiB0aGF0IHdlIGFyZSBpbmRlZWQgZXhpdGlu
ZyBndWVzdCBtb2RlLCBidXQgbm90IHF1aXRlIG91dCBvZiBndWVzdA0KPj4gbW9kZSB5ZXQuIE5v
dGU6IFRoaXMgaXMgZG9uZSBsYXppbHkgd2l0aG91dCBhbiBleHBsaWNpdCBtZW1vcnkNCj4+IGJh
cnJpZXIgc28gdGhhdCB3ZSBkbyBub3QgcmVncmVzcyB0aGUgY29zdCBpbiB0aGUgY3JpdGljYWwg
cGF0aA0KPj4gb2YgZ29pbmcgZnJvbSB0aGUgZXhpdCB0byB0aGUgZXhpdCBoYW5kbGVyLg0KPiAN
Cj4gVGhpcyBpcyBub3QgcmVtb3RlbHkgc3VmZmljaWVudCBqdXN0aWZpY2F0aW9uLiAgTWVtb3J5
ICJiYXJyaWVycyIgYXJlIGp1c3QgY29tcGlsZXINCj4gYmFycmllcnMgb24geDg2LCBzbyB0aGUg
b2RkcyBvZiByZWdyZXNzaW5nIHRoZSBWTS1FbnRlci9WTS1FeGl0IGNvc3Qgd2l0aG91dA0KPiBp
bnRyb2R1Y2luZyBhIGJ1ZyBhcmUgbWluaXNjdWxlLg0KDQpJIHdhcyB0YWxraW5nIGFib3V0IGhh
cmR3YXJlIG1lbW9yeSBiYXJyaWVycywgbm90IGNvbXBpbGVyIG1lbW9yeSBiYXJyaWVycy4gSeKA
mWxsDQp0dW5lIHRoYXQgdXAgYW5kIHRha2UgYSBkaWZmZXJlbnQgYXBwcm9hY2ggb24gdjIuDQoN
Cj4gDQo+PiBGbGlwIGJhY2sgdG8gSU5fR1VFU1RfTU9ERSBmb3IgZXhpdHMgdGhhdCB1c2UNCj4+
IEVYSVRfRkFTVFBBVEhfUkVFTlRFUl9HVUVTVCwgc3VjaCB0aGF0IHdlIGFyZSBJTl9HVUVTVF9N
T0RFIHVwb24NCj4+IHJlZW50cnkuDQo+PiANCj4+IENoYW5naW5nIHZjcHUtPm1vZGUgYXdheSBm
cm9tIElOX0dVRVNUX01PREUgYXMgZWFybHkgYXMgcG9zc2libGUNCj4gDQo+IEV4Y2VwdCB0aGlz
IGlzbid0IGFzIGVhcmx5IGFzIHBvc3NpYmxlLiAgSWYgd2UncmUgZ29pbmcgdG8gYm90aGVyIGRv
aW5nIHNvbWV0aGluZw0KPiBsaWtlIHRoaXMsIG15IHZvdGUgaXMgdG8gbW92ZSBpdCBpbnRvIGFz
c2VtYmx5Lg0KDQpJbiB2bWVudGVyLlMsIHRhY2tpbmcgb24gdG8gY2FsbCB2bXhfc3BlY19jdHJs
X3Jlc3RvcmVfaG9zdCBzZWVtZWQgbGlrZSB0aGUNCm1vc3QgbG9naWNhbCBwbGFjZSBhZnRlciBo
YW5kbGluZyBhbGwgb2YgdGhlIHN0YXRlIHNhdmVzIGFuZCBSU0Igd29yay4gQXJlIHlvdQ0Kc2F5
aW5nIHB1dCBpdCBldmVuIGNsb3NlciB0byB0aGUgZXhpdCwgbWVhbmluZyBiZWZvcmUgdGhlIEZJ
TExfUkVUVVJOX0JVRkZFUj8NCg0KPiANCj4+IGdpdmVzIElQSSBzZW5kZXJzIGFzIG11Y2ggcnVu
d2F5IGFzIHBvc3NpYmxlIHRvIGF2b2lkIHJpbmdpbmcNCj4+IGRvb3JiZWxsIG9yIHNlbmRpbmcg
cG9zdGVkIGludGVycnVwdCBJUEkgaW4gQU1EIGFuZCBJbnRlbCwNCj4+IHJlc3BlY3RpdmVseS4g
U2luY2UgdGhpcyBpcyBkb25lIHdpdGhvdXQgYW4gZXhwbGljaXQgbWVtb3J5DQo+PiBiYXJyaWVy
LCB0aGUgd29yc3QgY2FzZSBpcyB0aGF0IHRoZSBJUEkgc2VuZGVyIHNlZXMgSU5fR1VFU1RfTU9E
RQ0KPj4gc3RpbGwgYW5kIHNlbmRzIGEgc3B1cmlvdXMgZXZlbnQsIHdoaWNoIGlzIHRoZSBiZWhh
dmlvciBwcmlvcg0KPj4gdG8gdGhpcyBwYXRjaC4NCj4gDQo+IE5vLCB3b3JzdCBjYXNlIHNjZW5h
cmlvIGlzIHRoYXQga3ZtX3ZjcHVfZXhpdGluZ19ndWVzdF9tb2RlKCkgc2VlcyBFWElUSU5HX0dV
RVNUX01PREUNCj4gYW5kIGRvZXNuJ3Qga2ljayB0aGUgdkNQVS4gIEZvciAia2lja3MiIHRoYXQg
c2V0IGEgcmVxdWVzdCwga3ZtX3ZjcHVfZXhpdF9yZXF1ZXN0KCkNCj4gd2lsbCBwdW50IHRoZSB2
Q1BVIG91dCBvZiB0aGUgdGlnaHQgcnVuIGxvb3AsIHRob3VnaCB0aGVyZSBtaWdodCBiZSBvcmRl
cmluZyBpc3N1ZXMuDQo+IA0KPiBCdXQgd2hldGhlciBvciBub3QgdGhlcmUgYXJlIG9yZGVyaW5n
IGlzc3VlcyBpcyBhIG1vb3QgcG9pbnQgc2luY2UgdGhlcmUgYXJlIHVzZXMNCj4gb2Yga3ZtX3Zj
cHVfa2ljaygpIHRoYXQgYXJlbid0IGFjY29tcGFuaWVkIGJ5IGEgcmVxdWVzdCwgZS5nLiB0byBw
dXJnZSB0aGUgUE1MDQo+IGJ1ZmZlcnMuICBJbiBvdGhlciB3b3Jkcywga3ZtX3ZjcHVfa2ljaygp
IGFic29sdXRlbHkgY2Fubm90IGhhdmUgZmFsc2UgbmVnYXRpdmVzLg0KPiBXZSBjb3VsZCBtb2Rp
ZnkgS1ZNIHRvIHJlcXVpcmUgYSByZXF1ZXN0IHdoZW4gdXNpbmcga3ZtX3ZjcHVfa2ljaygpLCBi
dXQgdGhhdCdzDQo+IGEgYml0IG9mIGEgaGFjaywgYW5kIGFsbCBvZiB0aGUgcG9zc2libGUgb3Jk
ZXJpbmcgcHJvYmxlbXMgaXMgc3RpbGwgYSBwaWxlIG9mDQo+IGNvbXBsZXhpdHkgSSdkIHJhdGhl
ciBhdm9pZC4NCj4gDQo+IE5vIHNtYWxsIHBhcnQgb2YgbWUgdGhpbmtzIHdlJ2QgYmUgYmV0dGVy
IG9mZiBhZGRpbmcgYSBkZWRpY2F0ZWQgZmxhZyB0byB2ZXJ5DQo+IHByZWNpc2VseSB0cmFjayB3
aGV0aGVyIG9yIG5vdCB0aGUgdkNQVSBpcyB0cnVseSAiaW4gdGhlIGd1ZXN0IiBmb3IgdGhlIHB1
cnBvc2VzDQo+IG9mIHNlbmRpbmcgSVBJcy4gIFRoaW5ncyBsaWtlIGtpY2tzIGhhdmUgZGlmZmVy
ZW50IHJlcXVpcmVtZW50cyBhcm91bmQgSU5fR1VFU1RfTU9ERQ0KPiB0aGFuIHNlbmRpbmcgaW50
ZXJydXB0cywgZS5nLiBLVk0gbWFudWFsbHkgcHJvY2Vzc2VzIHRoZSBJUlIgb24gZXZlcnkgVk0t
RW50ZXIgYW5kDQo+IHNvIGxhY2sgb2YgYW4gSVBJIGlzIGEgbm9uLWlzc3VlLCB3aGVyZWFzIG1p
c3NpbmcgYW4gSVBJIGZvciBhIGtpY2sgaXMgcHJvYmxlbWF0aWMuDQo+IEluIG90aGVyIHdvcmRz
LCBFWElUSU5HX0dVRVNUX01PREUgcmVhbGx5IG5lZWRzIHRvIG1lYW4gImV4aXN0aW5nIHRoZSBy
dW4gbG9vcCIuDQoNCkRvIHlvdSBtZWFuOg0K4oCcb25lIHNtYWxsIHBhcnTigJ0gKGFzIGluIGdp
dmUgdGhpcyBhIHNob3QsIG1heWJlKSwgDQpvciANCuKAnG5vIHNtYWxsIHBhcnTigJ0gKGFzIGlu
IGdvb2QtZ29kLWRvbuKAmXQtZG8tdGhpcyEpDQoNCknigJltIGFzc3VtaW5nIHlvdSBtZWFudCBv
bmUgc21hbGwgcGFydCA6KSBzdXJlLCBob3cgYWJvdXQgc29tZXRoaW5nIGxpa2U6DQoNClRvIG15
IGVhcmxpZXIgY29tbWVudCBhYm91dCB3aGVuIHRvIGRvIHRoaXMgd2l0aGluIGEgZmV3IGluc3Ry
dWN0aW9ucywgSSBkb27igJl0IHdhbnQNCnRvIGNsb2JiZXIgb3RoZXIgc3R1ZmYgaGFwcGVuaW5n
IGFzIHBhcnQgb2YgdGhlIGVudGVyL2V4aXQsIHdoYXQgaWYgd2UgcmVwdXJwb3NlZC9yZW5hbWVk
DQp2bXhfdXBkYXRlX2hvc3RfcnNwIGFuZCB2bXhfc3BlY19jdHJsX3Jlc3RvcmVfaG9zdCB0byBt
YWtlIHRoZW0g4oCcZG8gc3R1ZmYgYmVmb3JlDQplbnRyeeKAnSBhbmQg4oCcZG8gc3R1ZmYgcmln
aHQgYWZ0ZXIgZW50cnkgcmV0dXJuc+KAnSBmdW5jdGlvbnMuIFRoYXQgd2F5IHdlIHdvdWxkbuKA
mXQgaGF2ZSB0bw0KYWRkIGFub3RoZXIgb3RoZXIgZnVuY3Rpb24gY2FsbHMgb3IgY2hhbmdlIHRo
ZSBleGlzdGluZyBjb250cm9sIGZsb3cgYWxsIHRoYXQgbXVjaC4NCg0KSW4g4oCcZG8gYmVmb3Jl
4oCdIHdlIGNvdWxkIHNldCBzb21ldGhpbmcgbGlrZSB2Y3B1LT5ub25fcm9vdF9tb2RlID0gdHJ1
ZQ0KSW4g4oCcZG8gYWZ0ZXLigJ0gd2UgY291bGQgc2V0IHZjcHUtPm5vbl9yb290X21vZGUgPSBm
YWxzZQ0KDQpPciBwZXJoYXBzIHNvbWV0aGluZyBsaWtlIChyZXNwZWN0aXZlbHkpDQp2Y3B1LT5v
cGVyYXRpb25hbF9zdGF0ZSA9IE5PTl9ST09UX01PREUNCnZjcHUtPm9wZXJhdGlvbmFsX3N0YXRl
ID0gUk9PVF9NT0RFDQoNClVzaW5nIHRoZSByb290L25vbi1yb290IG1vbmlrZXIgd291bGQgcHJl
Y2lzZWx5IHRyYWNrIHdoZW4gdGhlIHdoZXRoZXIgdGhlIA0KdkNQVSBpcyBpbiBndWVzdCwgYW5k
IGFsaWducyB3aXRoIHRoZSBsYW5ndWFnZSB1c2VkIHRvIGRlc2NyaWJlIHN1Y2ggYSBzdGF0ZQ0K
ZnJvbSB0aGUgU0RNLg0KDQpUaG91Z2h0cz8NCg0KDQo+IA0KPiBFLmcuIHRvZ2dsZSB0aGUgZGVk
aWNhdGVkIGZsYWcgd2l0aGluIGEgZmV3IGluc3RydWN0aW9ucyBvZiBWTS1FbnRlciBhbmQNCj4g
Vk0tRXhpdCBmb3IgbWF4aW11bSBlZmZpY2llbmN5IGZvciBpbnRlcnJ1cHRzLCBhbmQgYXZvaWQg
aGF2aW5nIHRvIG1ha2UgdmNwdS0+bW9kZQ0KPiBtb3JlIGNvbXBsZXggdGhhbiBpdCBhbHJlYWR5
IGlzLg0KPiANCj4gVG8gYWRkIGNsYXJpdHksIHdlIGNvdWxkIGV2ZW4gcmVuYW1lIElOX0dVRVNU
X01PREUgYW5kIEVYSVRJTkdfR1VFU1RfTU9ERSB0bw0KPiBzb21ldGhpbmcgbGlrZSBJTl9SVU5f
TE9PUCBhbmQgRVhJVElOR19SVU5fTE9PUC4NCg0KWWVhLCB0aGlzIGZlZWxzIGxpa2UgYSBnb29k
IGlkZWEgdG8gcmVkdWNlIGNvbmZ1c2lvbi4gTGV04oCZcyBuYWlsIHRoaXMgdGhyZWFkIGRvd24s
IHRoZW4gSSANCmNhbiBwcm9wb3NlIGEgd2lkZXIgY2xlYW51cD8NCg0KPiANCj4+IFNpZ25lZC1v
ZmYtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IC0tLQ0KPj4gYXJjaC94ODYv
a3ZtL3N2bS9zdm0uYyB8ICA3ICsrKysrKysNCj4+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAy
MyArKysrKysrKysrKysrKysrKysrKysrKw0KPj4gYXJjaC94ODYva3ZtL3g4Ni5jICAgICB8ICA4
ICsrKysrKysrDQo+PiAzIGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKykNCj4+IA0KPj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2
bS5jDQo+PiBpbmRleCBjZTM2MmU4OGE1NjcuLjVmMGMxMThhM2ZmZCAxMDA2NDQNCj4+IC0tLSBh
L2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMN
Cj4+IEBAIC0zOTA3LDYgKzM5MDcsMTMgQEAgc3RhdGljIG5vaW5zdHIgdm9pZCBzdm1fdmNwdV9l
bnRlcl9leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBzcGVjX2N0cmxfaW4NCj4+IAll
bHNlDQo+PiAJCV9fc3ZtX3ZjcHVfcnVuKHN2bSwgc3BlY19jdHJsX2ludGVyY2VwdGVkKTsNCj4+
IA0KPj4gKwkvKiBPcHRpbWl6ZSBJUEkgcmVkdWN0aW9uIGJ5IHNldHRpbmcgbW9kZSBpbW1lZGlh
dGVseSBhZnRlciB2bWV4aXQNCj4gDQo+IAkvKg0KPiAJICogQmVjYXVzZSBLVk0gaXNuJ3QgdGhl
IGNyYXp5IGxhbmQgb2YgbmV0LyBibG9jayBjb21tZW50cyBzaG91bGQgbGlrZQ0KPiAJICogdGhp
cy4gDQo+IAkgKi8NCg0KQWNrLCB3aWxsIGNoYW5nZSBpbiB2Mg0KDQo+IA0KPj4gKwkgKiB3aXRo
b3V0IGEgbWVtbW9yeSBiYXJyaWVyIGFzIHRoaXMgYXMgbm90IHBhaXJlZCBhbnl3aGVyZS4NCj4+
ICsJICogaXMgd2lsbCBiZSBzZXQgdG8gT1VUU0lERV9HVUVTVF9NT0RFIGluIHg4NiBjb21tb24g
Y29kZSB3aXRoIGEgbWVtb3J5DQo+PiArCSAqIGJhcnJpZXIsIGFmdGVyIHRoZSBob3N0IGlzIGRv
bmUgZnVsbHkgcmVzdG9yaW5nIHZhcmlvdXMgaG9zdCBzdGF0ZXMuDQo+PiArCSAqLw0KPj4gKwl2
Y3B1LT5tb2RlID0gRVhJVElOR19HVUVTVF9NT0RFOw0KPj4gKw0KPj4gCWd1ZXN0X3N0YXRlX2V4
aXRfaXJxb2ZmKCk7DQo+PiB9DQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14
L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gaW5kZXggNjMyNDdjNTdjNzJjLi4y
NDNkY2I4N2M3MjcgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+PiAr
KysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+PiBAQCAtNTg3OCw2ICs1ODc4LDE3IEBAIHN0
YXRpYyBmYXN0cGF0aF90IGhhbmRsZV9mYXN0cGF0aF9wcmVlbXB0aW9uX3RpbWVyKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4+IA0KPj4gCWlmICghdm14LT5yZXFfaW1tZWRpYXRlX2V4aXQgJiYN
Cj4+IAkgICAgIXVubGlrZWx5KHZteC0+bG9hZGVkX3ZtY3MtPmh2X3RpbWVyX3NvZnRfZGlzYWJs
ZWQpKSB7DQo+PiArCQkvKiBSZXNldCBJTl9HVUVTVF9NT0RFIHNpbmNlIHdlJ3JlIGdvaW5nIHRv
IHJlZW50ZXINCj4+ICsJCSAqIGd1ZXN0IGFzIHBhcnQgb2YgdGhpcyBmYXN0IHBhdGguIFRoaXMg
aXMgZG9uZSBhcw0KPj4gKwkJICogYW4gb3B0aW1pemF0aW9uIHdpdGhvdXQgYSBtZW1vcnkgYmFy
cmllciBzaW5jZQ0KPj4gKwkJICogRVhJVElOR19HVUVTVF9NT0RFIGlzIGFsc28gc2V0IHdpdGhv
dXQgYSBtZW1vcnkNCj4gDQo+IEhlaCwganVzdGlmeWluZyB0aGUgbGFjayBvZiBhIG1lbW9yeSBi
YXJyaWVyIGJ5IHNheWluZyBwb2ludGluZyBvdXQgdGhlIG90aGVyDQo+IGNvZGUgeW91IGFkZGVk
IGRvZXNuJ3QgdXNlIGEgbWVtb3J5IGJhcnJpZXIgaXMgaW50ZXJlc3RpbmcsIHRvIHB1dCBpdCBw
b2xpdGVseS4NCg0KTWVzc2FnZSByZWNlaXZlZCEgV2lsbCBtb3AgaXQgdXAuDQoNCj4gDQo+PiAr
CQkgKiBiYXJyaWVyLiBUaGlzIGFsc28gbmVlZHMgdG8gYmUgcmVzZXQgcHJpb3IgdG8NCj4+ICsJ
CSAqIGNhbGxpbmcgYXBpY190aW1lcl9leHBpcmVkKCkgc28gdGhhdA0KPj4gKwkJICoga3ZtX3Vz
ZV9wb3N0ZWRfdGltZXJfaW50ZXJydXB0KCkgcmV0dXJucyB0aGUgcHJvcGVyDQo+PiArCQkgKiB2
YWx1ZS4NCj4+ICsJCSAqLw0KPj4gKwkJaWYgKHZjcHUtPm1vZGUgPT0gRVhJVElOR19HVUVTVF9N
T0RFKQ0KPj4gKwkJCXZjcHUtPm1vZGUgPSBJTl9HVUVTVF9NT0RFOw0KPiANCj4gSXQncyBmYXIg
ZWFzaWVyLCBsaWtlbHkgbW9yZSBwZXJmb3JtYW50LCBkb2N1bWVudHMgd2h5IHRoaXMgaGFzIGEg
Y2hhbmNlIG9mIHdvcmtpbmcsDQo+IGFuZCBzaWduaWZpY2FudGx5IGxlc3MgZXJyb3IgcHJvbmUg
dG8gZG8gdGhpcyB1bmNvbmRpdGlvbmFsbHkgaW4gZWl0aGVyIGFzc2VtYmx5DQo+IG9yIGFmdGVy
IHRoZSBFWElUX0ZBU1RQQVRIX1JFRU5URVJfR1VFU1QgY2hlY2sgaW4gdmNwdV9lbnRlcl9ndWVz
dCgpLg0KDQpBY2ssIHdpbGwgZG8gdGhhdCB0aGVyZS4NCg0K
