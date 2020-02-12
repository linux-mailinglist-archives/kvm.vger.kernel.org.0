Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBE159ECA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 02:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgBLBx5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 11 Feb 2020 20:53:57 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2567 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727414AbgBLBx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 20:53:57 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 7195D545F67EA7F14871;
        Wed, 12 Feb 2020 09:53:52 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 09:53:51 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 12 Feb 2020 09:53:51 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 12 Feb 2020 09:53:51 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: do not reset microcode version on INIT or RESET
Thread-Topic: [PATCH] KVM: x86: do not reset microcode version on INIT or
 RESET
Thread-Index: AdXhRwyKxWVnO1x5Mka/BR4rIXLd5Q==
Date:   Wed, 12 Feb 2020 01:53:51 +0000
Message-ID: <713f14e711fc493f8a8de4adf2f4b6f5@huawei.com>
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
> The microcode version should be set just once, since it is essentially a CPU feature; so do it on vCPU creation rather than reset.
>
> Userspace can tie the fix to the availability of MSR_IA32_UCODE_REV in the list of emulated MSRs.
>
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good. Thanks.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

