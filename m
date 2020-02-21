Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A411166FE8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 07:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgBUG4Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 21 Feb 2020 01:56:25 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2589 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbgBUG4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 01:56:25 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id B20BF4D47865EEE93B49;
        Fri, 21 Feb 2020 14:56:14 +0800 (CST)
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Feb 2020 14:56:14 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 21 Feb 2020 14:56:14 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 21 Feb 2020 14:56:14 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] KVM: VMX: Handle INVVPID fallback logic in
 vpid_sync_vcpu_addr()
Thread-Topic: [PATCH 03/10] KVM: VMX: Handle INVVPID fallback logic in
 vpid_sync_vcpu_addr()
Thread-Index: AdXog+GePHLbQPDSiEKWY5ZDsLwSXQ==
Date:   Fri, 21 Feb 2020 06:56:13 +0000
Message-ID: <d438a445fedb4b7aabbcda8dca7e7425@huawei.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:
>Directly invoke vpid_sync_context() to do a global INVVPID when the individual address variant is not supported instead of deferring such behavior to the caller.  This allows for additional consolidation of code as the logic is basically identical to the emulation of the individual address variant in handle_invvpid().
>
>No functional change intended.
>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>---

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

