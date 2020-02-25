Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3504216B7EF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 04:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBYDLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 22:11:05 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:57366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbgBYDLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 22:11:05 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id EE70A373B8B4353000C6;
        Tue, 25 Feb 2020 11:11:02 +0800 (CST)
Received: from dggeme751-chm.china.huawei.com (10.3.19.97) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Feb 2020 11:11:02 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Feb 2020 11:11:02 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Tue, 25 Feb 2020 11:11:02 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Oliver Upton <oupton@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: nVMX: Consolidate nested MTF checks to helper
 function
Thread-Topic: [PATCH] KVM: nVMX: Consolidate nested MTF checks to helper
 function
Thread-Index: AdXriRYDIxTHsvR8q0SvVdFa+ndV3g==
Date:   Tue, 25 Feb 2020 03:11:02 +0000
Message-ID: <a3621a87c93b4b01ba10dd3907ddebac@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T2xpdmVyIFVwdG9uIDxvdXB0b25AZ29vZ2xlLmNvbT4gd3JpdGVzOg0KPmNvbW1pdCA1ZWY4YWNi
ZGQ2ODcgKCJLVk06IG5WTVg6IEVtdWxhdGUgTVRGIHdoZW4gcGVyZm9ybWluZyBpbnN0cnVjdGlv
biBlbXVsYXRpb24iKSBpbnRyb2R1Y2VkIGEgaGVscGVyIHRvIGNoZWNrIHRoZSBNVEYgVk0tZXhl
Y3V0aW9uIGNvbnRyb2wgaW4gdm1jczEyLiBDaGFuZ2UgcHJlLWV4aXN0aW5nIGNoZWNrIGluDQo+
bmVzdGVkX3ZteF9leGl0X3JlZmxlY3RlZCgpIHRvIGluc3RlYWQgdXNlIHRoZSBoZWxwZXIuDQo+
DQo+U2lnbmVkLW9mZi1ieTogT2xpdmVyIFVwdG9uIDxvdXB0b25AZ29vZ2xlLmNvbT4NCj4tLS0N
Cg0KUmV2aWV3ZWQtYnk6IE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPg0KDQo=
