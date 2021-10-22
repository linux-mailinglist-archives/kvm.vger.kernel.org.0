Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DB64371A4
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJVGUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:20:46 -0400
Received: from mx24.baidu.com ([111.206.215.185]:37872 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229609AbhJVGUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 02:20:45 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 46A56CB43680EB4A075F;
        Fri, 22 Oct 2021 14:18:26 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 22 Oct 2021 14:18:26 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Fri, 22 Oct 2021 14:18:25 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBLVk06IHg4NjogZGlyZWN0bHkgY2FsbCB3?=
 =?utf-8?Q?binvd_for_local_cpu_when_emulate_wbinvd?=
Thread-Topic: [PATCH][v2] KVM: x86: directly call wbinvd for local cpu when
 emulate wbinvd
Thread-Index: AQHXwBaxxg5nBZNTvUWIcXVUwDFNd6vedoUg//+OmQCAAJOGUA==
Date:   Fri, 22 Oct 2021 06:18:25 +0000
Message-ID: <fddee808e9f44cae885c533c12c754fa@baidu.com>
References: <1634118172-32699-1-git-send-email-lirongqing@baidu.com>
 <4857464fb9684af8a485ce9eb790fd75@baidu.com>
 <ABB2D0B2-A280-499B-96F8-69F8FC543605@gmail.com>
In-Reply-To: <ABB2D0B2-A280-499B-96F8-69F8FC543605@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.4]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBLVk0gaXMgbm9uZSBvZiBteSBidXNpbmVzcywgYnV0IG9uX2VhY2hfY3B1X21hc2soKSBzaG91
bGQgYmUgbW9yZSBlZmZpY2llbnQNCj4gc2luY2UgaXQgd291bGQgcnVuIHdiaW52ZCgpIGNvbmN1
cnJlbnRseSBsb2NhbGx5IGFuZCByZW1vdGVseSAodGhpcyBpcyBhIHJlbGF0aXZlbHkNCj4gcmVj
ZW50IGNoYW5nZSBJIG1hZGUpLiANCg0KVGhhbmtzLCBJIHNlZQ0KDQotTGkNCg==
