Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D638161EDF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 03:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgBRCM5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 21:12:57 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3013 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbgBRCM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 21:12:57 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id EDE149D79A4CF291A6A8;
        Tue, 18 Feb 2020 10:12:54 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 10:12:54 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 18 Feb 2020 10:12:54 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 18 Feb 2020 10:12:54 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 1/2] KVM: Introduce pv check helpers
Thread-Topic: [PATCH RESEND v2 1/2] KVM: Introduce pv check helpers
Thread-Index: AdXmAHn+IJnfnTTZ8EeW+4liPWUcOg==
Date:   Tue, 18 Feb 2020 02:12:54 +0000
Message-ID: <c83aaa5530724ede8036bbb2f1730d00@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:
>From: Wanpeng Li <wanpengli@tencent.com>
>
>Introduce some pv check helpers for consistency.
>
>Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>---

It seems all of my Reviewed-by tags are dropped for this patch set. But as I didn't figure anything important out, it's ok. :)

