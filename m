Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE96B95AA
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 14:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjCNNLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 09:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCNNLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 09:11:12 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1b::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0448095445;
        Tue, 14 Mar 2023 06:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz8vFxjkn5sRGdqKIWZJo6fEy+IRblxP7ndOG0d81EDGXB7iLyzfY+Rghc67pazvTkeYE70VMsIeTZxGxlVGCHABiz1EHhLNS4LwNjj3oRR5+80kqewfC6Kea2fpNna5q7uIPwX2LWAqIABBHg7P4cMuiuxxM6Y5WrRwsn1/Kva5ZYx1KPFAvcJT+ZNMWUat1X+CGyU3WC/d1GZVQKndf3MRwHPdaTtuNsvy1VmXYSZ2V2fYdSMwvQWb3bgr0CvEHKjmCwZdGnt+c2YfSaUUiTHoixisGUuc5ligdWYp/Jw56bAgLyB/WqhG9j1sQ5GWOgmSn2r+IQ9efqjvaFID/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pbwh0tm1nsahfDfBw8LNVD2QO9YVl22JJdJQEWoG+jc=;
 b=oUCeEZwCzRZwhkToL2qH5lBPxloQcjhWPUZAQDYgH7QO0tpj1pg2EIrW0inekJ/d0VN8dYeE52qrXGA+0idEODMumUkk3vfBd3sXCf7owjRmEzWRwcZdHrnafm+fQGJ+YhNbm3uXcBy9bN3ktLLj9/mjJWZzTdhupSQLFwomD5HIVn0QS0v1VteXuZmZ71lb5yEuGK9b7rBmc+VIo5e7LgMCHkvdbV1PCjG/sPL6aESHfYCIaqQQVXHs77KWPRQ2TyiTKx8GRT6W72auHnoVPY+umgPsLO8dcx/+l5WRJeUlfz5H8hT3sn9vEQy5CU/naUf6eazOeXeM/yLO+vedXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pbwh0tm1nsahfDfBw8LNVD2QO9YVl22JJdJQEWoG+jc=;
 b=BZ5eskIhG2zE+Hw9RkAiQHAoD9x4byYCUwbcYNBvqTQlwNxEBN0V8U0jlQ2o7hkdJQSpnfi2jAyx5C21a8NjPW8SOtn4b7TuFv4nplEPlU+rNAI4Dp1AIS7bCOx4HTSnVE2h4Ok5if9YtJSo9PyJ47nBE3fZw+7PzLsXFPAcq/4Jadv2y48RX4Z6dB5xETAJNd3fmGyzH56KxJ10VgexyuZK49GxMF/anBWcOWmbrawiCcG8V6mkD+0Efm91rdB+Igm0RNwSAU+cg6Oc5p5tA4ayCUcHxjbfBUVQksdvbXF1OlMxQa0U5Ou6ubjB5L7twHE20HkhdTlbk7pp2BhEaA==
Received: from AS2PR10MB6349.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:550::8)
 by DBAPR10MB3994.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:1cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 13:07:32 +0000
Received: from AS2PR10MB6349.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9360:f59f:3113:9a51]) by AS2PR10MB6349.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9360:f59f:3113:9a51%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 13:07:32 +0000
From:   "Schaffner, Tobias" <tobias.schaffner@siemens.com>
To:     "jszhang@kernel.org" <jszhang@kernel.org>
CC:     "anup@brainfault.org" <anup@brainfault.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Topic: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Index: AQHZVnXvvNC5aUCqNUOKjk0HEk7T8Q==
Date:   Tue, 14 Mar 2023 13:07:32 +0000
Message-ID: <b615dd8b-27f3-702a-3c36-ab18df64d5aa@siemens.com>
References: <20220831175920.2806-1-jszhang@kernel.org>
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS2PR10MB6349:EE_|DBAPR10MB3994:EE_
x-ms-office365-filtering-correlation-id: 249806e9-ad4a-4d11-f88c-08db248d12c1
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2abUuyYZ5yEdFBF/Xe1h/Qg2T9RGRdq/DRq0tIcnXT/6ETf7kSA9EfI/oObRPGKFttu/PdEjeGVAQTL89ylhF/GQICmFBKDxNg9Kqmc2xRtVtTBzoHM9YtIWhKcMHUAN4t0A0pE2oCz2ninsh+cw2Utpp06thgtkZjxWcrgA3H/ISPP00wbdAIjhslFD1oWaLEs4jd6W4h/S7YBPoJ4wJMGBgoVqp04xA2MzrLLsd5pbu18rGCeOhtwcMPib3pKy6XhzFXip0L+13BsS2LqWmbdjbqrtgqNVxQiLImQL8S1SpdhZFUiOF9GcWC9wHuYBjtt0Rrb6OHc+RXhq3h/e9tNTKbYqblBzyQn9a+Q0+Vr8HhWf/sb3E5XeE+/cpz3O1mZn76Un8OQaqNzkyjWgFp5RvDl2iFeEul6G8vuLo/GXXYsDx7zcyCL+n83+iGLi+3dau5n2fJpd7dKFeAUkOrRw9Lh67yCk5cc1qX0i0JjhYF0OO0IINK5ck8Yy6Wp8VMeASk2kbkz4W9Py0v/EQBvF3NOew8qrhbb7tzM6afKw0PmIu735yZt1Hcdt1BBlsXE6TwOO0fgNZ0LGkZdkjwGpf7rjQOGixyDgron+RPEbpBSrjXwISfpWpmBa1f+2OqvhCXoMWaenDmpTkRBSNg1B3O3Ls07H74KcYB901WXMI2H+Gb5N2+i2GybuXoF8tJWIbqn/BowPaGG1XcfrFtY2Dg8PERzael6ssmgrO/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR10MB6349.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199018)(8936002)(7416002)(5660300002)(41300700001)(8676002)(6916009)(4326008)(31696002)(86362001)(36756003)(38070700005)(38100700002)(82960400001)(2906002)(122000001)(966005)(6486002)(83380400001)(478600001)(71200400001)(186003)(26005)(6506007)(2616005)(53546011)(6512007)(31686004)(54906003)(316002)(64756008)(66946007)(66556008)(76116006)(66446008)(66476007)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZWTi9UWGNidi8raWk2Umk3U1J2dkxBYzk2VUMwUm10ME9sVjRYSFlVQ1JV?=
 =?utf-8?B?d3lneksvVHVXWE91Q21yZkRhSDFLSmxUSGRkL1NhYldVMTJoc0VwN2NBR29W?=
 =?utf-8?B?YXd6V0RLV2t5aUY0UUV5T3djTkxkNGNUQzN5ZDc0QU5zNVZMVDRVdllnWlRa?=
 =?utf-8?B?VEc5d2FBeEhEQVFxUVMwSEh0cS9ZT2FwZDB3UlFSc2sxWXJwcGtlbk1hZ2dJ?=
 =?utf-8?B?ZTNpUU8zSStTVGJkNngxNlA5UEZ4dWJqcytBWHY4NnJtaGlJSkpBWWo2czRO?=
 =?utf-8?B?TlFJNGpuS2VIc3Z0QUVDbmplb1NxK0NUUHVOTmhaT3M2ZUZkMUdmaTM4TUJZ?=
 =?utf-8?B?TEVqek43YkdwUkxjSjUyWitHeTdVN0FqYW03NkpBVnVxTkI1TURoSFRMUlR6?=
 =?utf-8?B?d2J6dTJZYUFGK3d2MW9EdVFwemtsa3NhbitIWnhUQUpaSVl5YzVQR0RVcnc2?=
 =?utf-8?B?dUpaeGNmaUo0clRVRmpGbVRhZnUwQlgyVkhoSngyMzVmRjBPbDJMY1FzNEUv?=
 =?utf-8?B?NExKdndnZVNjYTlFUDFlbWNPbHZ4ZVZrelQrdU1WQ1BHMVZKZDZudW9nTmY0?=
 =?utf-8?B?UWw1ckZ6MFhFMkMwMGNoZVZ1NjZocVNjR0pkRmx5L21vNVdxMGlLTmQ4M2ky?=
 =?utf-8?B?L3IyMHpUcjdNSHptYzlZYTlSM243Q1grcitMYTlUM1NsOUdCQkJWYks2MzQ2?=
 =?utf-8?B?aVAvTG55OGxRT1JRUHhMaEZacXVRT2gvUkZqdjYxYU5XaXJoQS8vbTN6Ny93?=
 =?utf-8?B?YlZ2VVovdXRkTlFybHJub3lSd2h4WWd1MlFNRFZaWWE1U29mZmpNNlJwRHFj?=
 =?utf-8?B?SGVCTUlMNVN1cVlwV0VzKzc4MmlZbUVVM3kwOUVpUjFhOHB0MXk3VWw0N2h2?=
 =?utf-8?B?Wlh1aW1MWDhOWjFCQjlEbXRlTnBCNTNHSThWemY2MlR5aDUzUFdDL2xVUm5Q?=
 =?utf-8?B?ejdXeEM3eDAvQ29BN3h1Um9SUzJLSFkrMG1kY0Y1OGo1TnppOXpVWUYxTFFI?=
 =?utf-8?B?SXZjRENUWGNObGx1Z3U0bmRPUXhrM1FSZyt3V2N4ZnB1MmI2OTVnL2JGQUNE?=
 =?utf-8?B?ZFlZdFU5ck5QditHcmFqVXdaQzZScDRYbzhtdGt0dnpvSE0vbThpNmJLbTc3?=
 =?utf-8?B?OGY2aEFYSkRQMzJPNkx4T0ZIY3pSNkpwSytMNEVKMTZFK1VtNXBtSHN4MmpB?=
 =?utf-8?B?ZE1LbHdUNGdGVDZUY2VmL0w4bFhsM2RoMDMvZFRscStkUVAxU1NvQVRINWYz?=
 =?utf-8?B?dFRUR1greXFlTU4rdnJCSkMzaHlOZXpJTjk1REcwNDdqUExxektFaFE4VEtR?=
 =?utf-8?B?YllHV3h3R3RXcTZqOTJiS0k2NkVvellkS1J6c1lQS1E4VkRpV2ZacWhrYTZS?=
 =?utf-8?B?Zmx4OWJ3VjNBdDVSZWtWUmxGMkp6VnRMVzdnL29CWkptbDFLZ0pGWDd6Q21p?=
 =?utf-8?B?M29sU1BwR3BuM0hFanZXY3Y2dmI1bmpySGVTVFNWeHQ2MGM3bjUvb3ZMNFQ2?=
 =?utf-8?B?TmVZZk44SmE2RjJoakovYks3Zzdva3hDNG52aGxBM09JZ1VOUjFXdjRMSVd1?=
 =?utf-8?B?MmVOd0FoUjNMY0NRcTN3Ykc5b3FQWjB1ZGlheVhJWndQdDZGRHZYUGhibkkr?=
 =?utf-8?B?dmJZZDZCeDk0WWtVeE5rQ2hYbGpwZGN2OVZyQ0pqREgvR1FwZU1RcHVqQzlN?=
 =?utf-8?B?eGU4cGZYOGhYQS9pbG1GT3FzSnhLVXpKcW5GajNBZUF6ZnBIdTFmTE0xUWYx?=
 =?utf-8?B?VTJIdEVSenRyUVY0VmovOVovVkE4Qlpzc2M3Z0FvelhybDRtaFYzRGVPdlk3?=
 =?utf-8?B?WStlVDBBa1QzditEcjVaZWs0ZGo5RGhGRDlDNDlsL0dUbEZiSDZMb3lTS0p3?=
 =?utf-8?B?NTZMci9YdFg2WFZFUzNrczBsYWdYMGlLdFR5aFNwQmwxTVJGRThVUlMxd0pv?=
 =?utf-8?B?Mm1oc2oyTkUxcXBlUW8veVo2L3Nsd1ZIK0dJRkQ5NFBQOHo1aWlEQ3lBeDZC?=
 =?utf-8?B?TTd0bWlYRkRqRUltVGoybklwVUVOancvZG5Ob0t1SE1SZnVMS1J0UGhHclNB?=
 =?utf-8?B?TERoV3RGQVNpa2NGWUJHYzBkMU54RHJ0T0IvWVFGK2NTUnYvMlJ1cEFhVzR3?=
 =?utf-8?B?WFVWM0xUQjJMSXc4eXpaZGVtTU52MGQ4WjQ0ajR5djk4dExUVUExam4xV3ly?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <234FEE8A630FAA47AA9E2F3996174779@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS2PR10MB6349.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 249806e9-ad4a-4d11-f88c-08db248d12c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 13:07:32.6591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9An7rtu2C9FqctVV7sAUdZfnVleVtg+Qvv95R/xfLel8/WflRJ4SlIBIlqr3U5RoGf+jW0YB56tzs9K/QI+AyrF6dC0TlExLWiqzc1CEGeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR10MB3994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMzEvMDgvMjAyMiAxODo1OSwgSmlzaGVuZyBaaGFuZyB3cm90ZToNCiA+IFRoaXMgc2VyaWVz
IGlzIHRvIGFkZCBQUkVFTVBUX1JUIHN1cHBvcnQgdG8gcmlzY3Y6DQogPiBwYXRjaDEgYWRkcyB0
aGUgbWlzc2luZyBudW1iZXIgb2Ygc2lnbmFsIGV4aXRzIGluIHZDUFUgc3RhdA0KID4gcGF0Y2gy
IHN3aXRjaGVzIHRvIHRoZSBnZW5lcmljIGd1ZXN0IGVudHJ5IGluZnJhc3RydWN0dXJlDQogPiBw
YXRjaDMgc2VsZWN0IEhBVkVfUE9TSVhfQ1BVX1RJTUVSU19UQVNLX1dPUksgd2hpY2ggaXMgYSBy
ZXF1aXJlbWVudCBmb3INCiA+IFJUDQogPiBwYXRjaDQgYWRkcyBsYXp5IHByZWVtcHQgc3VwcG9y
dA0KID4gcGF0Y2g1IGFsbG93cyB0byBlbmFibGUgUFJFRU1QVF9SVA0KID4NCiA+IEkgYXNzdW1l
IHBhdGNoMSwgcGF0Y2gyIGFuZCBwYXRjaDMgY2FuIGJlIHJldmlld2VkIGFuZCBtZXJnZWQgZm9y
DQogPiByaXNjdi1uZXh0LCBwYXRjaDQgYW5kIHBhdGNoNSBjYW4gYmUgcmV2aWV3ZWQgYW5kIG1h
aW50YWluZWQgaW4gcnQgdHJlZSwNCiA+IGFuZCBmaW5hbGx5IG1lcmdlZCBvbmNlIHRoZSByZW1h
aW5pbmcgcGF0Y2hlcyBpbiBydCB0cmVlIGFyZSBhbGwNCiA+IG1haW5saW5lZC4NCg0KSSB0ZXN0
ZWQgdGhlIGxhc3QgdHdvIHBhdGNoZXMgb24gYSBTdGFyRml2ZSBWaXNpb25GaXZlIFYyIChEVCkg
Ym9hcmQgDQp3aXRoIDYuMS4xMi1ydDctZ2RmYTUyY2MxNGYzYiB0b2RheSBhbmQgdGhlIHJlc3Vs
dHMgbG9va2VkIHByZXR0eSBnb29kIA0KZm9yIGEgZmlyc3QgcnVuLg0KDQpyb290QFN0YXJGaXZl
On4jIGxzY3B1DQpBcmNoaXRlY3R1cmU6ICAgICAgICAgIHJpc2N2NjQNCiAgIEJ5dGUgT3JkZXI6
ICAgICAgICAgIExpdHRsZSBFbmRpYW4NCkNQVShzKTogICAgICAgICAgICAgICAgNA0KICAgT24t
bGluZSBDUFUocykgbGlzdDogMC0zDQoNCnJvb3RAU3RhckZpdmU6fiMgdW5hbWUgLWENCkxpbnV4
IFN0YXJGaXZlIDYuMS4xMi1ydDctZ2RmYTUyY2MxNGYzYiAjMSBTTVAgUFJFRU1QVF9SVCBUaHUs
IDAxIEphbiANCjE5NzAgMDE6MDA6MDAgKzAwMDAgcmlzY3Y2NCBHTlUvTGludXhiDQoNCnJvb3RA
U3RhckZpdmU6fiMgY2F0IC9wcm9jL2NtZGxpbmUNCmluaXRyZD1caW5pdHJkLmltZy02LjEuMTIt
cnQ3LWdkZmE1MmNjMTRmM2IgTEFCRUw9Qm9vdCANCnJvb3Q9UEFSVFVVSUQ9NzE3NjQ3OWYtZWVl
YS00NmFjLWFmYjYtN2VjNDdmZjdjMzkwIGNvbnNvbGU9dHR5MCANCmNvbnNvbGU9dHR5UzAsMTE1
MjAwIGVhcmx5Y29uIHJvb3R3YWl0IGlzb2xjcHVzPTItMyByY3Vfbm9jYnM9Mi0zIA0Kbm9oel9m
dWxsPTItMyBpcnFhZmZpbml0eT0wLTENCg0Kcm9vdEBTdGFyRml2ZTp+IyBjeWNsaWN0ZXN0IC1t
IC1TIC1wIDkwIC1pIDUwIC1kIDAgLXEgLUQgMTBtDQpXQVJOOiBzdGF0IC9kZXYvY3B1X2RtYV9s
YXRlbmN5IGZhaWxlZDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KVDogMCAoICAzNTgpIFA6
OTAgSTo1MCBDOjExOTk5OTk5IE1pbjogICAgIDExIEFjdDogICAxMSBBdmc6ICAgMTEgTWF4OiAN
CiAgICA1NQ0KVDogMSAoICAzNTkpIFA6OTAgSTo1MCBDOjExOTk5MjQxIE1pbjogICAgIDExIEFj
dDogICAxMSBBdmc6ICAgMTEgTWF4OiANCiAgICA2MA0KDQpGZWVsIGZyZWUgdG8gcmVhY2ggb3V0
IGZvciBmdXJ0aGVyIHRlc3RzIG9yIGxvZ3MuDQoNCkJlc3QsDQpUb2JpYXMNCg0KID4gU2luY2Ug
djE6DQogPiAgIC0gc2VuZCB0byByZWxhdGVkIG1haWxsaXN0LCBJIHByZXNzIEVOVEVSIHRvbyBx
dWlja2x5IHdoZW4gc2VuZGluZyB2MQ0KID4gICAtIHJlbW92ZSB0aGUgc2lnbmFsX3BlbmRpbmco
KSBoYW5kbGluZyBiZWNhdXNlIHRoYXQncyBjb3ZlcmVkIGJ5DQogPiAgICAgZ2VuZXJpYyBndWVz
dCBlbnRyeSBpbmZyYXN0cnVjdHVyZQ0KID4NCiA+IEppc2hlbmcgWmhhbmcgKDUpOg0KID4gICBS
SVNDLVY6IEtWTTogUmVjb3JkIG51bWJlciBvZiBzaWduYWwgZXhpdHMgYXMgYSB2Q1BVIHN0YXQN
CiA+ICAgUklTQy1WOiBLVk06IFVzZSBnZW5lcmljIGd1ZXN0IGVudHJ5IGluZnJhc3RydWN0dXJl
DQogPiAgIHJpc2N2OiBzZWxlY3QgSEFWRV9QT1NJWF9DUFVfVElNRVJTX1RBU0tfV09SSw0KID4g
ICByaXNjdjogYWRkIGxhenkgcHJlZW1wdCBzdXBwb3J0DQogPiAgIHJpc2N2OiBBbGxvdyB0byBl
bmFibGUgUlQNCiA+DQogPiAgYXJjaC9yaXNjdi9LY29uZmlnICAgICAgICAgICAgICAgICAgIHwg
IDMgKysrDQogPiAgYXJjaC9yaXNjdi9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgIHwgIDEgKw0K
ID4gIGFyY2gvcmlzY3YvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaCB8ICA3ICsrKysrLS0NCiA+
ICBhcmNoL3Jpc2N2L2tlcm5lbC9hc20tb2Zmc2V0cy5jICAgICAgfCAgMSArDQogPiAgYXJjaC9y
aXNjdi9rZXJuZWwvZW50cnkuUyAgICAgICAgICAgIHwgIDkgKysrKysrKy0tDQogPiAgYXJjaC9y
aXNjdi9rdm0vS2NvbmZpZyAgICAgICAgICAgICAgIHwgIDEgKw0KID4gIGFyY2gvcmlzY3Yva3Zt
L3ZjcHUuYyAgICAgICAgICAgICAgICB8IDE4ICsrKysrKystLS0tLS0tLS0tLQ0KID4gIDcgZmls
ZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQogPg0KID4gLS0N
CiA+IDIuMzQuMQ0KID4NCiA+DQogPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KID4gbGludXgtcmlzY3YgbWFpbGluZyBsaXN0DQogPiBsaW51eC1yaXNj
dkBsaXN0cy5pbmZyYWRlYWQub3JnDQogPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LXJpc2N2DQo=
