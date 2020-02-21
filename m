Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44D166DC9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 04:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgBUDfV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 20 Feb 2020 22:35:21 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2967 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbgBUDfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 22:35:21 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 1C57FFA6500AAE6364F0;
        Fri, 21 Feb 2020 11:35:16 +0800 (CST)
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Feb 2020 11:35:15 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 21 Feb 2020 11:35:15 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 21 Feb 2020 11:35:14 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] KVM: nVMX: handle nested posted interrupts when
 apicv is disabled for L1
Thread-Topic: [PATCH RFC 2/2] KVM: nVMX: handle nested posted interrupts when
 apicv is disabled for L1
Thread-Index: AdXoZVlfSygJ+8ROSaqBNWx3makmIA==
Date:   Fri, 21 Feb 2020 03:35:14 +0000
Message-ID: <11a51b369e464e8e92c71cd87708e366@huawei.com>
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

Hi:
Vitaly Kuznetsov <vkuznets@redhat.com> write:
>Even when APICv is disabled for L1 it can (and, actually, is) still available for L2, this means we need to always call
>vmx_deliver_nested_posted_interrupt() when attempting an interrupt delivery.
>
>Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Looks good for me. Thanks.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

