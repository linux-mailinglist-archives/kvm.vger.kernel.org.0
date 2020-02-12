Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28C715A966
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBLMrl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 12 Feb 2020 07:47:41 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2568 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbgBLMrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:47:40 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id D3F484EF77AA1CA79DA5;
        Wed, 12 Feb 2020 20:47:38 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 20:47:38 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 12 Feb 2020 20:47:38 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 12 Feb 2020 20:47:38 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "colin.king@canonical.com" <colin.king@canonical.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix WARN_ON check of an unsigned less than zero
Thread-Topic: [PATCH] KVM: x86: fix WARN_ON check of an unsigned less than
 zero
Thread-Index: AdXhoiXW8VIhLjkmJ0K1uSPsR8Cm4A==
Date:   Wed, 12 Feb 2020 12:47:37 +0000
Message-ID: <65768baced1c4d9e87555c9057c2c488@huawei.com>
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

Paolo Bonzini <pbonzini@redhat.com> writes:
> The check cpu->hv_clock.system_time < 0 is redundant since system_time is a u64 and hence can never be less than zero.  But what was actually meant is to check that the result is positive, since kernel_ns and
> v->kvm->arch.kvmclock_offset are both s64.
>
>Reported-by: Colin King <colin.king@canonical.com>
>Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Addresses-Coverity: ("Macro compares unsigned to 0")
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>---

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

