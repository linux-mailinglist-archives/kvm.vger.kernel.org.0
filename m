Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4016D4E7E77
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 02:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiCZBzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 21:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiCZBzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 21:55:06 -0400
X-Greylist: delayed 920 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 18:53:31 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1278080203;
        Fri, 25 Mar 2022 18:53:30 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22PNJ8Gb016099;
        Fri, 25 Mar 2022 18:37:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=KzdfDOIgwAjAu+zkR2qeO3H86CyWhTQ4EGBoJAa5NWo=;
 b=sbHyNaBxPI6FQhXgtBGb7UYgjHuxrcle5rF+9oW30Agmu8lZZnqGUGnTtk6g5l3NGfeU
 xZcQz9MXKDv66HhzyrMvffhxhHHPfSj2yNW3TqnlmnueRlrpAqbuahxG1EkWjvBKbpWl
 1Ltn6B9PCN2Kstprj2TNkunPa5iYUOVoW6piUk2UUFt7XSqxLU7B9Uj10OwTTbEhcs/Z
 ItfcEgQVEuzWEvrofn/e9Ca6VH9HAX8CaAnkrM5/n4l3yKCESbt9VqpUpcqD29iHnZ/w
 UguRVRY4oGQbaY5G9gT9bYLyPBMfWrGRCPKeKpLBbbZPu3VSjO7Actwmu7r4e4d54Gcr Jw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ewb3771g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 18:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvnzPTuOyUYInz0OMIvPY8CBbbJou1gARc18/MnFYqwDenoz8ZkqMMjW0oDd2iqYxhu/XrokyAOVoiGfqEZ0rR9BtlTEzx5h8F6ecRTppa5YQoTXfEThk/Oqib5usrq7r1zoMGxH9sM/niWsXuVcg1P4TcYBg8Vj5sKuinyJdfZH4YIwGw2Jg/5C6mtQKAitbeTMX6BzyNPaV+pbC4HB5Zgu5eZadcWACVwi/VK2t8TmldVngCQIt9VdFe1p6QW7PaeZLdF7gVUNftQ+meCaTzOvMTEmnj24zv6PkNzPusobYGUyXP0Zt0z1CbE/ql4bpmgmu2OaCUdpAYeAvEz8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzdfDOIgwAjAu+zkR2qeO3H86CyWhTQ4EGBoJAa5NWo=;
 b=KPQThBQBKzwS8EnYN3E1PTX3nzl99U7VA+REEwl6uhr8RPtcv//V+jvhTJP4YwRRhIgFNAoajkzMmRmHt/fm4H6ZrbOmkAkNeyPDnoGKgPuKIsE7j25anlxgzplTYGemN2jhmiMUMVCkH0ikB5E+niftSMwA4OeiNNp3lYLUDeJAn6cguvmdLHldJSMqBsJ7U2HGj6DDoWRP7Il10jofIgreWcukOo5IKeNEd/I8GDnkDOLU/oWcbX24UAPTn9g0J5naTXJrj8vQ2pk1zZRnFGUEUAPEMx1n3EyA4PjLSChs3OLO7MmQqooHhQjPsaqHwSVUc+MVygJVRsk5W+D6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH0PR02MB8044.namprd02.prod.outlook.com (2603:10b6:610:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Sat, 26 Mar
 2022 01:37:04 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5102.019; Sat, 26 Mar 2022
 01:37:04 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Thread-Topic: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Thread-Index: AQHYPxhn3Sr6qShuh02J8mIqjF/gfqzQzueAgAAW5YA=
Date:   Sat, 26 Mar 2022 01:37:03 +0000
Message-ID: <387E8E8B-81B9-40FF-8D52-76821599B7E4@nutanix.com>
References: <20220324004439.6709-1-jon@nutanix.com>
 <Yj5bCw0q5n4ZgSuU@google.com>
In-Reply-To: <Yj5bCw0q5n4ZgSuU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 510eb9f0-4279-4171-a452-08da0ec92197
x-ms-traffictypediagnostic: CH0PR02MB8044:EE_
x-microsoft-antispam-prvs: <CH0PR02MB80442042BE2DA8A65C142887AF1B9@CH0PR02MB8044.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkKPw2rWy86XzVz8/A94Fe6xdDUAA0ezsNSXf8PaC5lM4brpV3eVhg4DW4f3VvEQ0i/rzpc4/A9LGDpqAUlOWixEiwRJV6gEK/c6WPG7ceIfWu7txktarFhh+FI0lTmbOE1QuDy5pGGjUfhoQzn+Bgad9e+WflRmJvxQAzJWqOpAMaxRwv1mm03XsPLgwo5wNfBPjM9s82ickO+JKA4teCNl88CEtfBqp4zS+geoxJhmXGkutog0k3HpseVoaAoh9Vl7vTbswuGDpLfoYotrJHo5kz9qZDV+4OcwV+zLzNbbu4Yddv7b4yKPcQ2ASAqEzNIa1Bubv+4AMFjSujcoLtesWhZM/j/VwwagU/eR4QkMB/ab7GDBrwtXRPlZvrU3n9JfrRQsjYCtFJRPVNXENJpQ4zZImG2h9vPoAHWGMUD5MQzafaUbFMf1r5icq1/JqjVOPms9gPBUff+0JHSRzwGM/Hr/vHUd73naQHjOeIteu+vK7f3tWc7YF5tsrxTex54tENz3fLZZPP9EYLcdePRR+jiVpoIHa5/KVFkyfZfAlh0X10CsKcBwGtcNSk4zUwYdiNzxR+xIMYAp+JoS0rNWLFqfZ8d3/ssOxuXzcodL+30HyUqUA96mOavYFa5OIlKDgvbE4k01dP66KtUrPDs3RiyUFO53QUJWHZDcaH7g14EKL8X/0AkPgdcucHMjeBAmjwhzoYUwzsWpLT/C5nocPAH+TkLsadWzd9B3g+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(8936002)(71200400001)(122000001)(83380400001)(2906002)(2616005)(508600001)(86362001)(64756008)(66476007)(76116006)(66556008)(33656002)(4326008)(66946007)(66446008)(8676002)(6506007)(53546011)(38100700002)(6512007)(186003)(316002)(6916009)(54906003)(7416002)(36756003)(38070700005)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGcwR2Vmb05LMlRlaHZRS2FsM3ZVMzhocEhqZXh4UHIwcGs1cmR0cTczS0o4?=
 =?utf-8?B?WEVYVzl5aHg2MlA0Y3htOWdiQkM1ZUR2TXU1c09qb1N1R3FFTmtLK0hLK1ZT?=
 =?utf-8?B?dkU3dlRCVUZjSW4vMmNCeWZBdzNkeGlrTWQ5L09CR1diNmx3bVJuVGZiTFQw?=
 =?utf-8?B?bzlzTEpkdTFKcUFodjQ5NzVQN1l2cXdqUDVJaFJETWlBN0VvVFdKbUJWci9i?=
 =?utf-8?B?cFQ5VnZ4UkdnUVRVblI0MjcybnJnVUg5SGdpdXRDWGtnRnRmV0NsZ0l6dWFi?=
 =?utf-8?B?Mk9neW1UVFh4RFh1KzA5b3VLRGN1RE0ybVlra3JQMjUxYXlYVDlZbHc4L0dD?=
 =?utf-8?B?cGdKaUlnb3p5Y3hHQVNkSSt3cDlib2o4T3I4ajRQT0VXejJhL25VWm1Lcm92?=
 =?utf-8?B?Y0NPRDF5cW1XaUxLdXg0enQzdTAwQ0dyVEUwVEdGa2pSTmVQZndWMVoraGNx?=
 =?utf-8?B?Mm1ac0FObmI0WmFqdUNVT2kweWZXM0RGTXlvWXlua1RBSTFFU0hlaFNzRUJi?=
 =?utf-8?B?U3ZOakpVL2srOThXQnArZHlDTVU2ZzcvQWRFWUlqdmEyS2NGekkveG0zUVZj?=
 =?utf-8?B?b1hWQTI0MjJFdmR4b20rWHZ3WUdERDl2MVNFbU1PYkltNituZDlDMUFjYXRS?=
 =?utf-8?B?NXp0dE9sVU5EOFdJRkVNQXMwSUpPOHZKendaK29RWnZtZW9BeXZ2M1RSeHJi?=
 =?utf-8?B?QVQ3TzBYN1lTWnBvcy9FeFhtamQzUW04N3E3cGxxVEZHQTlQMnB0T24wQ09p?=
 =?utf-8?B?Q3V3bXg0c0JrSGpLelluUHNGVFdQMWFqRXMwOUJhRkpDbCs1aDRybkRCYWVW?=
 =?utf-8?B?YXVPNzRxb3FZenFzSUpFSEZQeFQzbjQ4QVhjR28zRFNaWkxLb1V4M3ZTRWpB?=
 =?utf-8?B?YitVRjZWZFhrSW92eVArTGdwV2dXQks2bk52ZnUySWZSaEFDM3NyaXhZVHlm?=
 =?utf-8?B?RXhyM21NaUg5d0FmeVJVcnppVXIyWVNQd2dPeXYzMEgyWkdadE54dk95VTRQ?=
 =?utf-8?B?dGJHalZrZStkODczQWxtYVkxejJyYkVZS0JGZ21ybDdsb1loZmFRaG9ZRG5n?=
 =?utf-8?B?MkVGRXhuSUpvYUwxeUZNakhjTG5GZTJmY25aWTRMVndsTmpkN2ZqaFJEUE1u?=
 =?utf-8?B?TEgyOVFFc2ZBZldZQmpDMWVyMlF3SE1kdlFrWTc1Zmdpb1RydWh6R3A2NVV1?=
 =?utf-8?B?bTBUbzBNVjlWbjFiUjJNOWoyckZKS1lwdkxHTmpIUGxjWE5ubXhlMVZYdG9k?=
 =?utf-8?B?ZjRpNzJoMFBuK3hBUGkyKzRHWVpXT0tKMll2ZFFhOWJOcEtRc1ZiU0wzRHYy?=
 =?utf-8?B?cGxZaCt0ZjdiRUZJZDFHeE0veVdWY1RXVm9ENnRZdjg0Q3krSXJWcXFvNlhV?=
 =?utf-8?B?UTJiL1UrcTdNWWNpYXBhWkZBWkVKR1hqQjcxeDVzTkc5TlFzenBPK1dHSk1E?=
 =?utf-8?B?dVpuQ0xiYnFnVGJoS2FEbEhxcWNiajNabWZIeVVMWDJYV2lNQ2hDK0lQYVN3?=
 =?utf-8?B?R1k3NlpCZUVlSkYydEw3NmVidDIzNHVhSUs3L2xCb0hTU0VvZDRtSG9Scksv?=
 =?utf-8?B?clIxS0xLeVNsSEc2bjF4ZDRxa2lWUXFjZ2JNMDdKQXVuREJHaW9GR05NdHUx?=
 =?utf-8?B?RE1sOHVhc0hjNnRXWDlkVnBOK0l1VWs5S25FbjVTdmlnaGptYU5mRnRpb29a?=
 =?utf-8?B?QzFuNHdCMWdwVGtQU3BtU3Jza2JJekFraDcrY05GbitqMnNVWC95cnZZREZF?=
 =?utf-8?B?N0JHN1hGUnFwK0J3eWRuQ2pZSnJSdEF3eHNIN3dpWEJYOStkZ0kraHg5VnZQ?=
 =?utf-8?B?WGV2cEl1OUE5MEx3SWtRZGlZeVZrT1ArTWhLK041TXY4bW4zb25WMTZzV1Rj?=
 =?utf-8?B?blRaeUw2NEFybDdqYWVsVitEaDhtaTdrM05LdFF3M1JrSjh0cUZaeWRSQ2ls?=
 =?utf-8?B?dGdWOG9heENidG5saFp2dGdGZ3hxdS9US3Y5cEQ3ME9wWDNGQjROOFY2ekNW?=
 =?utf-8?B?bnRoK1RnUzJ1QThhYU4zRTBqbXVlR1RzZjBVRVo3RjBlSDU1NlZWRmI3bUxL?=
 =?utf-8?B?QXVLVk1OQUhrcTRHVDVoNFdyR2x5ZEJQWHlPbEw1THY2c1VqVjhCVFprN3hC?=
 =?utf-8?B?SHJySGhJZFBCUStYNG5oTHA4TTZHRlpWbS8wd0FOTUhCQUZ5U3dVYncrVVdS?=
 =?utf-8?B?b2lTcDF1b1EybU44SnRUeWFQMTlkZXRVZjFDR2dIZkhZeVZuc0RMcmVOZUQx?=
 =?utf-8?B?QjRVUnRkakxIRUpRb0hsdEsxOFp1aEY0TldiY3Q5Zkd2RENYamVUeHA1UG9v?=
 =?utf-8?B?cWt4ZnRGNWlMWERBd2N1Zm45a0M5bkI5UlByMng4ZTk2dGlNb08wT0YwTElB?=
 =?utf-8?Q?gCU4dU55hL4qY8kBDEPyy3CLE4p1KVBYsn2Yl39hCMo91?=
x-ms-exchange-antispam-messagedata-1: ZjCefw0wbFCt+MPRuychKt+xYkkgz460Y1Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED8B9A307D4745499128BE2EA5B03913@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510eb9f0-4279-4171-a452-08da0ec92197
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2022 01:37:03.9116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLVKJn37dA1zjr2RU8fUHWaa1oTfNpAzmTyvUw/HPusjURybntowalVxXkhihNfKovn28V2RnKbK9ILKbNZ4p9iKr6UJTMRFXLosisUJbVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8044
X-Proofpoint-GUID: 3B7cQnw2pl_ysWnwQgIbaVvasakY7N-6
X-Proofpoint-ORIG-GUID: 3B7cQnw2pl_ysWnwQgIbaVvasakY7N-6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_08,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIE1hciAyNSwgMjAyMiwgYXQgODoxNSBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXIgMjMsIDIwMjIsIEpvbiBL
b2hsZXIgd3JvdGU6DQo+PiBrdm1fbG9hZF97Z3Vlc3R8aG9zdH1feHNhdmVfc3RhdGUgaGFuZGxl
cyB4c2F2ZSBvbiB2bSBlbnRyeSBhbmQgZXhpdCwNCj4+IHBhcnQgb2Ygd2hpY2ggaXMgbWFuYWdp
bmcgbWVtb3J5IHByb3RlY3Rpb24ga2V5IHN0YXRlLiBUaGUgbGF0ZXN0DQo+PiBhcmNoLnBrcnUg
aXMgdXBkYXRlZCB3aXRoIGEgcmRwa3J1LCBhbmQgaWYgdGhhdCBkb2Vzbid0IG1hdGNoIHRoZSBi
YXNlDQo+PiBob3N0X3BrcnUgKHdoaWNoIGFib3V0IDcwJSBvZiB0aGUgdGltZSksIHdlIGlzc3Vl
IGEgX193cml0ZV9wa3J1Lg0KPj4gDQo+PiBUbyBpbXByb3ZlIHBlcmZvcm1hbmNlLCBpbXBsZW1l
bnQgdGhlIGZvbGxvd2luZyBvcHRpbWl6YXRpb25zOg0KPj4gMS4gUmVvcmRlciBpZiBjb25kaXRp
b25zIHByaW9yIHRvIHdycGtydSBpbiBib3RoDQo+PiAgICBrdm1fbG9hZF97Z3Vlc3R8aG9zdH1f
eHNhdmVfc3RhdGUuDQo+PiANCj4+ICAgIEZsaXAgdGhlIG9yZGVyaW5nIG9mIHRoZSB8fCBjb25k
aXRpb24gc28gdGhhdCBYRkVBVFVSRV9NQVNLX1BLUlUgaXMNCj4+ICAgIGNoZWNrZWQgZmlyc3Qs
IHdoaWNoIHdoZW4gaW5zdHJ1bWVudGVkIGluIG91ciBlbnZpcm9ubWVudCBhcHBlYXJlZA0KPj4g
ICAgdG8gYmUgYWx3YXlzIHRydWUgYW5kIGxlc3Mgb3ZlcmFsbCB3b3JrIHRoYW4ga3ZtX3JlYWRf
Y3I0X2JpdHMuDQo+IA0KPiBJZiBpdCdzIGFsd2F5cyB0cnVlLCB0aGVuIGl0IHNob3VsZCBiZSBj
aGVja2VkIGxhc3QsIG5vdCBmaXJzdC4gIEFuZCBpZg0KDQpTZWFuIHRoYW5rcyBmb3IgdGhlIHJl
dmlldy4gVGhpcyB3b3VsZCBiZSBhIGxlZnQgaGFuZGVkIHx8IHNob3J0IGNpcmN1aXQsIHNvDQp3
b3VsZG7igJl0IHdlIHdhbnQgYWx3YXlzIHRydWUgdG8gYmUgZmlyc3Q/DQoNCj4ga3ZtX3JlYWRf
Y3I0X2JpdHMoKSBpcyBtb3JlIGV4cGVuc2l2ZSB0aGVuIHdlIHNob3VsZCBhZGRyZXNzIHRoYXQg
aXNzdWUsIG5vdA0KPiB0cnkgdG8gbWljcm8tb3B0aW1pemUgdGhpcyBzdHVmZi4gIFg4Nl9DUjRf
UEtFIGNhbid0IGJlIGd1ZXN0LW93bmVkLCBhbmQgc28NCj4ga3ZtX3JlYWRfY3I0X2JpdHMoKSBz
aG91bGQgYmUgb3B0aW1pemVkIGRvd24gdG86DQo+IA0KPiAJcmV0dXJuIHZjcHUtPmFyY2guY3I0
ICYgWDg2X0NSNF9QS0U7DQoNCk9rIGdvb2QgdGlwLCB0aGFuayB5b3UuIEnigJlsbCBkaWcgaW50
byB0aGF0IGEgYml0IG1vcmUgYW5kIHNlZSB3aGF0IEkgY2FuIGZpbmQuIFRvIGJlDQpmYWlyLCBr
dm1fcmVhZF9jcjRfYml0cyBpc27igJl0IHN1cGVyIGV4cGVuc2l2ZSwgaXTigJlzIGp1c3QgbW9y
ZSBleHBlbnNpdmUgdGhhbiB0aGUNCmNvZGUgSSBwcm9wb3NlZC4gVGhhdCBzYWlkLCBJ4oCZbGwg
c2VlIHdoYXQgSSBjYW4gZG8gdG8gc2ltcGxpZnkgdGhpcy4NCg0KPiANCj4gSWYgdGhlIGNvbXBp
bGVyIGlzbid0IHNtYXJ0IGVub3VnaCB0byBkbyB0aGF0IG9uIGl0cyBvd24gdGhlbiB3ZSBzaG91
bGQgcmV3b3JrDQo+IGt2bV9yZWFkX2NyNF9iaXRzKCkgYXMgdGhhdCB3aWxsIGJlbmVmaXQgbXVs
dGlwbGUgY29kZSBwYXRocy4NCj4gDQo+PiAgICBGb3Iga3ZtX2xvYWRfZ3Vlc3RfeHNhdmVfc3Rh
dGUsIGhvaXN0IGFyY2gucGtydSAhPSBob3N0X3BrcnUgYWhlYWQNCj4+ICAgIG9uZSBwb3NpdGlv
bi4gV2hlbiBpbnN0cnVtZW50ZWQsIEkgc2F3IHRoaXMgYmUgdHJ1ZSByb3VnaGx5IH43MCUgb2YN
Cj4+ICAgIHRoZSB0aW1lIHZzIHRoZSBvdGhlciBjb25kaXRpb25zIHdoaWNoIHdlcmUgYWxtb3N0
IGFsd2F5cyB0cnVlLg0KPj4gICAgV2l0aCB0aGlzIGNoYW5nZSwgd2Ugd2lsbCBhdm9pZCAzcmQg
Y29uZGl0aW9uIGNoZWNrIH4zMCUgb2YgdGhlIHRpbWUuDQo+IA0KPiBJZiB0aGUgZ3Vlc3QgdXNl
cyBQS1JVLi4uICBJZiBQS1JVIGlzIHVzZWQgYnkgdGhlIGhvc3QgYnV0IG5vdCB0aGUgZ3Vlc3Qs
IHRoZQ0KPiBlYXJseSBjb21wYXJpc29uIGlzIHB1cmUgb3ZlcmhlYWQgYmVjYXVzZSBpdCB3aWxs
IGFsbW9zdCBhbHdheXMgYmUgdHJ1ZSAoZ3Vlc3QNCj4gd2lsbCBiZSB6ZXJvLCBob3N0IHdpbGwg
bm9uLXplcm8pLCANCg0KSW4gYSBtdWx0aSB0ZW5hbnQgZW52aXJvbm1lbnQgd2l0aCBhIHZhcmll
dHkgb2YgaG9zdHMgYW5kIGN1c3RvbWVyIGNvbnRyb2xsZWQNCmd1ZXN0cywgd2XigJl2ZSBzZWVu
IHRoaXMgYmUgYSBtaXhlZCBiYWcuIEnigJlkIGJlIG9rIG1vdmluZyB0aGlzIGJhY2sgdG8gdGhl
IHdheQ0KaXQgaXMgY3VycmVudGx5LCBJIGNhbiBkbyB0aGF0IG9uIHRoZSBuZXh0IHJldmlzaW9u
IHRvIHNpbXBsaWZ5IHRoaXMuDQoNCj4gDQo+PiAyLiBXcmFwIFBLVSBzZWN0aW9ucyB3aXRoIENP
TkZJR19YODZfSU5URUxfTUVNT1JZX1BST1RFQ1RJT05fS0VZUywNCj4+ICAgIGFzIGlmIHRoZSB1
c2VyIGNvbXBpbGVzIG91dCB0aGlzIGZlYXR1cmUsIHdlIHNob3VsZCBub3QgaGF2ZQ0KPj4gICAg
dGhlc2UgYnJhbmNoZXMgYXQgYWxsLg0KPiANCj4gTm90IHRoYXQgaXQgcmVhbGx5IG1hdHRlcnMs
IHNpbmNlIHN0YXRpY19jcHVfaGFzKCkgd2lsbCBwYXRjaCBvdXQgYWxsIHRoZSBicmFuY2hlcywN
Cj4gYW5kIGluIHByYWN0aWNlIHdobyBjYXJlcyBhYm91dCBhIEpNUCBvciBOT1Aocyk/ICBCdXQu
Li4NCg0KVGhlIHJlYXNvbiBJ4oCZdmUgYmVlbiBwdXJzdWluZyB0aGlzIGlzIHRoYXQgdGhlIGd1
ZXN0K2hvc3QgeHNhdmUgYWRkcyB1cCB0bw0KYSBiaXQgb3ZlciB+MSUgYXMgbWVhc3VyZWQgYnkg
cGVyZiB0b3AgaW4gYW4gZXhpdCBoZWF2eSB3b3JrbG9hZC4gVGhpcyBpcyANCnRoZSBmaXJzdCBp
biBhIGZldyBwYXRjaCB3ZeKAmXZlIGRydW1tZWQgdXAgdG8gdG8gZ2V0IGl0IGJhY2sgdG93YXJk
cyB6ZXJvLiANCknigJlsbCBzZW5kIHRoZSByZXN0IG91dCBuZXh0IHdlZWsuDQoNCj4gDQo+ICNp
ZmRlZmZlcnkgaXMgdGhlIHdyb25nIHdheSB0byBoYW5kbGUgdGhpcy4gIFJlcGxhY2Ugc3RhdGlj
X2NwdV9oYXMoKSB3aXRoDQo+IGNwdV9mZWF0dXJlX2VuYWJsZWQoKTsgdGhhdCdsbCBib2lsIGRv
d24gdG8gYSAnMCcgYW5kIG9taXQgYWxsIHRoZSBjb2RlIHdoZW4NCj4gQ09ORklHX1g4Nl9JTlRF
TF9NRU1PUllfUFJPVEVDVElPTl9LRVlTPW4sIHdpdGhvdXQgdGhlICNpZmRlZiB1Z2xpbmVzcy4N
Cg0KR3JlYXQgaWRlYSwgdGhhbmtzLiBJ4oCZbGwgdHVuZSB0aGlzIHVwIGFuZCBzZW5kIGEgdjIg
cGF0Y2guDQoNCj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5j
b20+DQo+PiAtLS0NCj4+IGFyY2gveDg2L2t2bS94ODYuYyB8IDE0ICsrKysrKysrKy0tLS0tDQo+
PiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4gDQo+
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+
PiBpbmRleCA2ZGIzYTUwNmI0MDIuLjJiMDAxMjNhNWQ1MCAxMDA2NDQNCj4+IC0tLSBhL2FyY2gv
eDg2L2t2bS94ODYuYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiBAQCAtOTUwLDEx
ICs5NTAsMTMgQEAgdm9pZCBrdm1fbG9hZF9ndWVzdF94c2F2ZV9zdGF0ZShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQo+PiAJCQl3cm1zcmwoTVNSX0lBMzJfWFNTLCB2Y3B1LT5hcmNoLmlhMzJfeHNz
KTsNCj4+IAl9DQo+PiANCj4+ICsjaWZkZWYgQ09ORklHX1g4Nl9JTlRFTF9NRU1PUllfUFJPVEVD
VElPTl9LRVlTDQo+PiAJaWYgKHN0YXRpY19jcHVfaGFzKFg4Nl9GRUFUVVJFX1BLVSkgJiYNCj4+
IC0JICAgIChrdm1fcmVhZF9jcjRfYml0cyh2Y3B1LCBYODZfQ1I0X1BLRSkgfHwNCj4+IC0JICAg
ICAodmNwdS0+YXJjaC54Y3IwICYgWEZFQVRVUkVfTUFTS19QS1JVKSkgJiYNCj4+IC0JICAgIHZj
cHUtPmFyY2gucGtydSAhPSB2Y3B1LT5hcmNoLmhvc3RfcGtydSkNCj4+ICsJICAgIHZjcHUtPmFy
Y2gucGtydSAhPSB2Y3B1LT5hcmNoLmhvc3RfcGtydSAmJg0KPj4gKwkgICAgKCh2Y3B1LT5hcmNo
LnhjcjAgJiBYRkVBVFVSRV9NQVNLX1BLUlUpIHx8DQo+PiArCSAgICAga3ZtX3JlYWRfY3I0X2Jp
dHModmNwdSwgWDg2X0NSNF9QS0UpKSkNCj4+IAkJd3JpdGVfcGtydSh2Y3B1LT5hcmNoLnBrcnUp
Ow0KPj4gKyNlbmRpZiAvKiBDT05GSUdfWDg2X0lOVEVMX01FTU9SWV9QUk9URUNUSU9OX0tFWVMg
Ki8NCj4+IH0NCj4+IEVYUE9SVF9TWU1CT0xfR1BMKGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRl
KTsNCj4+IA0KPj4gQEAgLTk2MywxMyArOTY1LDE1IEBAIHZvaWQga3ZtX2xvYWRfaG9zdF94c2F2
ZV9zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAJaWYgKHZjcHUtPmFyY2guZ3Vlc3Rf
c3RhdGVfcHJvdGVjdGVkKQ0KPj4gCQlyZXR1cm47DQo+PiANCj4+ICsjaWZkZWYgQ09ORklHX1g4
Nl9JTlRFTF9NRU1PUllfUFJPVEVDVElPTl9LRVlTDQo+PiAJaWYgKHN0YXRpY19jcHVfaGFzKFg4
Nl9GRUFUVVJFX1BLVSkgJiYNCj4+IC0JICAgIChrdm1fcmVhZF9jcjRfYml0cyh2Y3B1LCBYODZf
Q1I0X1BLRSkgfHwNCj4+IC0JICAgICAodmNwdS0+YXJjaC54Y3IwICYgWEZFQVRVUkVfTUFTS19Q
S1JVKSkpIHsNCj4+ICsJICAgICgodmNwdS0+YXJjaC54Y3IwICYgWEZFQVRVUkVfTUFTS19QS1JV
KSB8fA0KPj4gKwkgICAgIGt2bV9yZWFkX2NyNF9iaXRzKHZjcHUsIFg4Nl9DUjRfUEtFKSkpIHsN
Cj4+IAkJdmNwdS0+YXJjaC5wa3J1ID0gcmRwa3J1KCk7DQo+PiAJCWlmICh2Y3B1LT5hcmNoLnBr
cnUgIT0gdmNwdS0+YXJjaC5ob3N0X3BrcnUpDQo+PiAJCQl3cml0ZV9wa3J1KHZjcHUtPmFyY2gu
aG9zdF9wa3J1KTsNCj4+IAl9DQo+PiArI2VuZGlmIC8qIENPTkZJR19YODZfSU5URUxfTUVNT1JZ
X1BST1RFQ1RJT05fS0VZUyAqLw0KPj4gDQo+PiAJaWYgKGt2bV9yZWFkX2NyNF9iaXRzKHZjcHUs
IFg4Nl9DUjRfT1NYU0FWRSkpIHsNCj4+IA0KPj4gLS0NCj4+IDIuMzAuMSAoQXBwbGUgR2l0LTEz
MCkNCj4+IA0KDQo=
