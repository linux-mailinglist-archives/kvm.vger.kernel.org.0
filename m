Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F606748C30
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjGESs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjGESs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:48:26 -0400
Received: from DM4PR02CU002.outbound.protection.outlook.com (mail-centralusazon11013013.outbound.protection.outlook.com [52.101.64.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB89EE54;
        Wed,  5 Jul 2023 11:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNoFWjS+EiLxZfd8YMrx9gCpyVENyzga8Re2ys6QDwevTO9WVjbSGgE41pzrZ4keL91Nmz5GLljV5vPty2WzlZcybAnXQOqVwKKryoz+sMV6KtFUcAH2XKIuzwJ8ckHo3w7k/QPkaJ7m9Nq110zyztNIetX6F66YWpMGHWNx9CPfG95481+fVZzpm+UXkEou6Qqr5FZN1Yzk96mqhsYYc4t/1oTHE63V+89icYVgWX5lP/MOuX4Efq2mo9p3IpHWu5n7EEXbA7HQP7RVMvCbL0VH/wajJPJrt9bqKE7l8mrKS9fTCMm1Pcp18f4e2p7oyya9+c/gwKi8NjJY/7C/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wR+ieDC7ByAYlnBIo3Rg0Po+mvw/Z3EDSgo9RYxEmg=;
 b=XN1XrETHQUm2C1vJdgk0m3RE8zenRZGcvv0P7xfHddBm6xxjeersj6KQJD2hUBmiumw1OMmV5Ap3gXj5slbRkdYTs4QfJ7ummj8/8tvBI2d6suORQkIkT6euDfoesYID0tulzmgrEaN3Oh9rrPL5TyzhycAFrfeFY2hkt+BeJ/jb7vm2KLz0ogd21fZAAOLekb0ajkq9zxYg/8a0NnqWx63TZZOI6JxZtfhgpW3Z7jJWW7hCFr7tE5CEjMCEgpJx794btwlyuTr2xeP3LBw+EgFiaHPQbGaYRb6TkloRrtyOhZF8YADCz2ai2k4gqWeXJysS7GTl283F4+ZKexEJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wR+ieDC7ByAYlnBIo3Rg0Po+mvw/Z3EDSgo9RYxEmg=;
 b=m/Ecshg1mytKShtZeTSVvDB0yCW3llMk/E2pQVBpobYrVGe3rUt40KoxNEl+m/Iw85YsKjoi929/8YWA1WEfUfdVLXeFqnpGmJFKTK7GaroRksMO/6OTXxbkHCs8+fqUSXiw1Fpt5yPysa4n7EaV1i2XlrYFXZey4sh3/+nZA3Q=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SA3PR05MB10388.namprd05.prod.outlook.com (2603:10b6:806:3a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 18:48:19 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 18:48:19 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Valentin Schneider <vschneid@redhat.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        =?utf-8?B?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 00/14] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Thread-Topic: [RFC PATCH 00/14] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Thread-Index: AQHZr2y+GfzO+CWIH0G9pNH2IIyk2K+rg6EA
Date:   Wed, 5 Jul 2023 18:48:19 +0000
Message-ID: <57D81DB6-2D96-4A12-9FD5-6F0702AC49F6@vmware.com>
References: <20230705181256.3539027-1-vschneid@redhat.com>
In-Reply-To: <20230705181256.3539027-1-vschneid@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|SA3PR05MB10388:EE_
x-ms-office365-filtering-correlation-id: 1694dc4b-d91e-4e8b-e277-08db7d8866a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dCzXCpDeEIUVXsUQEDUiZaECKU3lv1foHvrqv50RWqZI5T27TfP7Rkulwoo9mxozga+5TwySTuujFzhkNTD/JqFc+rDXMUfNBeINMG/dzYlW9QDR6Zgt1rdKpgU3auH3fcmCLtwyCEkJqCpV2rzbpmWZ6ka08mn5Wg4a36E588nhw3/17zaVkMri7kD7nC61QIlyYhrfNhhhgeKHXaesJIiN9x/QkOeRn+JrH37p2M3gzBjclP+8faTZGniS9iN7lyuApHvNnV2jFFsJzQ+I/+QYjdXcuOAMkMdbj9WZAKL63eOd0V/zd68na9rvaTXLb9Gf+MkFNNm5O/lhqa6L4FI0rKisu10sJElLnaa/pinUI1tPi42+Y60no/OIFYggGT31IkAmlZPgf1OKkmFpGYdllcAHBrFPvYFVw2akE0UhVruJs2B3dczf0+DpsYjNul9s742WYJqkg5weBy+08gJWrJNYh8GymVKUblHxTte3pKUtD/ryRwufEZCBVeIXlRSsBlJdrJIgv7tfmlYcZNzO+/IRFM5Z87T1qmKg7sk7tWzZTsNKIUAYvuMblCpzYty5gnD3txcG9PdDeul9IK0VWIDJtVy3yMl24gggE+TgWVzbjBBv86KnjuU0jAUHVLTQUCaC6B27RqDIcIkRJZTStoJS3Fu/SEc4dNi+shOBOrl9B8AmLzmrqcn3DrYT8xFnEn1JX8rSgNUIaKS6Kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(2906002)(41300700001)(7416002)(7406005)(8676002)(5660300002)(38070700005)(33656002)(36756003)(8936002)(86362001)(71200400001)(6486002)(76116006)(38100700002)(83380400001)(478600001)(186003)(6512007)(2616005)(53546011)(6506007)(26005)(122000001)(6916009)(64756008)(66946007)(66446008)(66556008)(316002)(4326008)(66476007)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2FLRkZDV1dZSmd6UmxzS2VqOVFkRTB3eVhTVkZVR1RSaHNLczVVUlJtL0xu?=
 =?utf-8?B?SStlZ3FwNS9VMDlpbGZBWDZ0MjM0enRFb01FZ2VjQVZkekg3UnN2QjVMNC9Y?=
 =?utf-8?B?NkpJMkR6dHpjMTZDeDdjRVVoM2JoYmxNY0RLT1IvZmtUdlpsTkVRVzdySzlm?=
 =?utf-8?B?R0Ntd1BlenRKc2t2ZkJoc1ZIS1NJUmk1ZUtBWHdOQmxCMEpNSk1lY0ZEb0x2?=
 =?utf-8?B?MVAwM1Nuam9GdUxyMmVtRWtDR1VkcjZ0cFNYK0VqMXpOblVOUFY0cWpUQlo4?=
 =?utf-8?B?eGlveXVtVHlTQnYzZnpFajVCbG4yUU53bWc1V3BZQ2VqQTBEMEZzYWQ1SzM5?=
 =?utf-8?B?SW1rNEtnSUtEb3JRZmllcnJoZmZyamZXUm80N2ZtUDd4cm9CWGc3ZFBzT2g4?=
 =?utf-8?B?aDJjdnRUaXJ5Q2NnZVNhbXFFNWcxWDJQdkkybFQ3eGJ6dkpRdllMNFcrTCtK?=
 =?utf-8?B?WjlkSnRKQVlyNjAwWktqMFF4MkkzdU5ORWg4L2JscUZ1UDk0R2FRUVRMdTdC?=
 =?utf-8?B?R29GNU14R3huRGlGaEZKdGVkYlUvRlc2d0lveFY3SllVdVA3a1VjTlRZM1JE?=
 =?utf-8?B?Q1NnZTJFZWh0dFEvcWtONWVSYjU2NXNGb3NBWVdQUDJCcjdpdzBrRkFZc0xS?=
 =?utf-8?B?bWhiejA2SUFzUEVsc29QbVZLRFJxb1Y2MVdGMzIxVHlPaEdvY0RvYXh2ZjND?=
 =?utf-8?B?UW9EUkhmdUhPVVFWSzVuNkZkbCtlVEdvM3hMN0UyblEvUHVRaTJBNi9nZDdi?=
 =?utf-8?B?TGNqT2oxWWQyR2VDYXh1bVFLNklBUGhvYk4vWTRzNkgyNGVCZzdqcXg5aDgx?=
 =?utf-8?B?NHRmM2N3bitVZFQyZ0ZITHlEb0hMY1E5OXQxS2x0S1ZEaURNekdJaG9wUXIx?=
 =?utf-8?B?dFNVazlKNU1uYmxNMXF6NG9paSt0b0NGNUNHdThkVk5weDhaSktGT05tYUZQ?=
 =?utf-8?B?ZzNwOHNBVm4zdFR6U1l2Sk1jYzR6UTZHeTM5UTdsLzhYZTI3ZEJNQnJYbTJl?=
 =?utf-8?B?eWZ5YmpDOHdHT1VGTDY2eHdrckVFTkZ6dU1xWUlWbnB2eGl5ZmprNEhFVy9o?=
 =?utf-8?B?Rm1MMFgzbW9reTZ3YlpZMUNuYVkwamR6QnZya0JTWmtXQWF3MXYvMzZXNkV6?=
 =?utf-8?B?TFRNRTAvbnBTcm1CTzAzYXJvTFZyWWxXT240eU14cGVEWjBoaExlcHd5ZTdp?=
 =?utf-8?B?TFNWcXJyN2ZyallWWS9ISFRCNzhpdWpPSEE4M3Y5Yk1SaVRaNFoyQ3gxekxN?=
 =?utf-8?B?SnZWOHYvbUVUMWs5WjgvRThRbGltMDBrcE53cG1CSlhCb1MrSXRJMndVTjJz?=
 =?utf-8?B?Qkh3MEozTlNNcjJ1WE1GRjV1ZTJ1bUxkK3IwWWUyU2lReDhmaWhkYmFEa24w?=
 =?utf-8?B?NEdqOE1UK2o3YnRZakVxSERGWERPY0l2cHNDWU1WS1J4Mm1xc21nekU4Y3I0?=
 =?utf-8?B?bTVvUjZwcnJvWW9tOXBRQm9FV0RUR2t4OS9VTVRtMlBVWnJTS0kvc3N1SXNG?=
 =?utf-8?B?NWlPSUZRQUdPNmRJNVhJcjdHSzh6RXA4VlpsR1JWME56c3pIcm1iajdVVlZV?=
 =?utf-8?B?R05BVTBPQ0JqcVJjWi84TThkSlVHODdpVmdCNm5vYmNwSkw1amVpZTM1YWUv?=
 =?utf-8?B?Tmxxcy9yazVxejFUYVhaS0JKcU8wK1kwdThrY1diMnVKMlFwMDYxQ3FkYzNO?=
 =?utf-8?B?a0RpS3JjMzZlWStsbDFSK0RmM0tpVDh3S3R3Q0J3Qy9JR3lTQTZsc3Q0aFN0?=
 =?utf-8?B?Y3FEOVBWbFN1YUQ0ZFUvVjBHc2xkTHJxbHVnV1o0RW4xa2VIL0FUSXZCdENT?=
 =?utf-8?B?OFRQMi96OUMzRHEyZVc3VnNHcFJldnhxNHBTTDhBTzR1aVk4aGFiTXBoQUh2?=
 =?utf-8?B?WEV6WGI3Wld0eExKMEVXRC95QWVUNkl6cThXYWgzTCtpOUZLd1dteS9JZ1Ez?=
 =?utf-8?B?U3BEM1kzWjArMnM2b2NZM1ZZSWNpM0RZR3B2RDQ3Y3N2anBMSFJQT2VlRmdU?=
 =?utf-8?B?d0F3ZDJvV2VleU5NbUNFMDFTelN3WVIzZVpDMXh3SXNyWFRTQmZud1Z5cEg1?=
 =?utf-8?B?TGlZcHdOeHZDSU1iRWlJMVFyOFdPT1EwMVRsS081Nkt4THNZeXZrNWh1aTg1?=
 =?utf-8?Q?FqjDJk/PxSnvFMvUw1lSjLIOi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80C6D9ED9F6D2449991F50E082880550@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1694dc4b-d91e-4e8b-e277-08db7d8866a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 18:48:19.4372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SMiNmCMlWQImaIiWVxta+w2m8+Pn/AtJXTl090Yacy4uV7SOKliTS6uqQ+YGSnQtPx5UNIc71Ec++jf+E/jMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR05MB10388
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVsIDUsIDIwMjMsIGF0IDExOjEyIEFNLCBWYWxlbnRpbiBTY2huZWlkZXIgPHZz
Y2huZWlkQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gRGVmZXJyYWwgYXBwcm9hY2gNCj4gPT09
PT09PT09PT09PT09PT0NCj4gDQo+IFN0b3JpbmcgZWFjaCBhbmQgZXZlcnkgY2FsbGJhY2ssIGxp
a2UgYSBzZWNvbmRhcnkgY2FsbF9zaW5nbGVfcXVldWUgdHVybmVkIG91dA0KPiB0byBiZSBhIG5v
LWdvOiB0aGUgd2hvbGUgcG9pbnQgb2YgZGVmZXJyYWwgaXMgdG8ga2VlcCBOT0haX0ZVTEwgQ1BV
cyBpbg0KPiB1c2Vyc3BhY2UgZm9yIGFzIGxvbmcgYXMgcG9zc2libGUgLSBubyBzaWduYWwgb2Yg
YW55IGZvcm0gd291bGQgYmUgc2VudCB3aGVuDQo+IGRlZmVycmluZyBhbiBJUEkuIFRoaXMgbWVh
bnMgdGhhdCBhbnkgZm9ybSBvZiBxdWV1aW5nIGZvciBkZWZlcnJlZCBjYWxsYmFja3MNCj4gd291
bGQgZW5kIHVwIGFzIGEgY29udm9sdXRlZCBtZW1vcnkgbGVhay4NCj4gDQo+IERlZmVycmVkIElQ
SXMgbXVzdCB0aHVzIGJlIGNvYWxlc2NlZCwgd2hpY2ggdGhpcyBzZXJpZXMgYWNoaWV2ZXMgYnkg
YXNzaWduaW5nDQo+IElQSXMgYSAidHlwZSIgYW5kIGhhdmluZyBhIG1hcHBpbmcgb2YgSVBJIHR5
cGUgdG8gY2FsbGJhY2ssIGxldmVyYWdlZCB1cG9uDQo+IGtlcm5lbCBlbnRyeS4NCg0KSSBoYXZl
IHNvbWUgZXhwZXJpZW5jZSB3aXRoIHNpbWlsYXIgYW4gb3B0aW1pemF0aW9uLiBPdmVyYWxsLCBp
dCBjYW4gbWFrZQ0Kc2Vuc2UgYW5kIGFzIHlvdSBzaG93LCBpdCBjYW4gcmVkdWNlIHRoZSBudW1i
ZXIgb2YgaW50ZXJydXB0cy4NCg0KVGhlIG1haW4gcHJvYmxlbSBvZiBzdWNoIGFuIGFwcHJvYWNo
IG1pZ2h0IGJlIGluIGNhc2VzIHdoZXJlIGEgcHJvY2Vzcw0KZnJlcXVlbnRseSBlbnRlcnMgYW5k
IGV4aXRzIHRoZSBrZXJuZWwgYmV0d2VlbiBkZWZlcnJlZC1JUElzLCBvciBldmVuIHdvcnNlIC0N
CnRoZSBJUEkgaXMgc2VudCB3aGlsZSB0aGUgcmVtb3RlIENQVSBpcyBpbnNpZGUgdGhlIGtlcm5l
bC4gSW4gc3VjaCBjYXNlcywgeW91DQpwYXkgdGhlIGV4dHJhIGNvc3Qgb2Ygc3luY2hyb25pemF0
aW9uIGFuZCBjYWNoZSB0cmFmZmljLCBhbmQgbWlnaHQgbm90IGV2ZW4NCmdldCB0aGUgYmVuZWZp
dCBvZiByZWR1Y2luZyB0aGUgbnVtYmVyIG9mIElQSXMuDQoNCkluIGEgc2Vuc2UsIGl0J3MgYSBt
b3JlIGV4dHJlbWUgY2FzZSBvZiB0aGUgb3ZlcmhlYWQgdGhhdCB4ODbigJlzIGxhenktVExCDQpt
ZWNoYW5pc20gaW50cm9kdWNlcyB3aGlsZSB0cmFja2luZyB3aGV0aGVyIGEgcHJvY2VzcyBpcyBy
dW5uaW5nIG9yIG5vdC4gQnV0DQpsYXp5LVRMQiB3b3VsZCBjaGFuZ2UgaXNfbGF6eSBtdWNoIGxl
c3MgZnJlcXVlbnRseSB0aGFuIGNvbnRleHQgdHJhY2tpbmcsDQp3aGljaCBtZWFucyB0aGF0IHRo
ZSBkZWZlcnJpbmcgdGhlIElQSXMgYXMgZG9uZSBpbiB0aGlzIHBhdGNoLXNldCBoYXMgYQ0KZ3Jl
YXRlciBwb3RlbnRpYWwgdG8gaHVydCBwZXJmb3JtYW5jZSB0aGFuIGxhenktVExCLg0KDQp0bDtk
ciAtIGl0IHdvdWxkIGJlIGJlbmVmaWNpYWwgdG8gc2hvdyBzb21lIHBlcmZvcm1hbmNlIG51bWJl
ciBmb3IgYm90aCBhDQrigJxnb29k4oCdIGNhc2Ugd2hlcmUgYSBwcm9jZXNzIHNwZW5kcyBtb3N0
IG9mIHRoZSB0aW1lIGluIHVzZXJzcGFjZSwgYW5kIOKAnGJhZOKAnQ0Kb25lIHdoZXJlIGEgcHJv
Y2VzcyBlbnRlcnMgYW5kIGV4aXRzIHRoZSBrZXJuZWwgdmVyeSBmcmVxdWVudGx5LiBSZWR1Y2lu
Zw0KdGhlIG51bWJlciBvZiBJUElzIGlzIGdvb2QgYnV0IEkgZG9u4oCZdCB0aGluayBpdCBpcyBh
IGdvYWwgYnkgaXRzIG93bi4NCg0KWyBCVFc6IEkgZGlkIG5vdCBnbyBvdmVyIHRoZSBwYXRjaGVz
IGluIGRldGFpbC4gT2J2aW91c2x5LCB0aGVyZSBhcmUNCiAgdmFyaW91cyBkZWxpY2F0ZSBwb2lu
dHMgdGhhdCBuZWVkIHRvIGJlIGNoZWNrZWQsIGFzIGF2b2lkaW5nIHRoZQ0KICBkZWZlcnJpbmcg
b2YgSVBJcyBpZiBwYWdlLXRhYmxlcyBhcmUgZnJlZWQuIF0NCg0K
