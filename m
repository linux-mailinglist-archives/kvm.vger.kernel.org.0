Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657F11449CD
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 03:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAVC2e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Jan 2020 21:28:34 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2562 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726584AbgAVC2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 21:28:33 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 024A1CB1B413457A8B03;
        Wed, 22 Jan 2020 10:28:32 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jan 2020 10:28:31 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 22 Jan 2020 10:28:31 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 22 Jan 2020 10:28:31 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: inline memslot_valid_for_gpte
Thread-Topic: [PATCH] KVM: x86: inline memslot_valid_for_gpte
Thread-Index: AdXQy3d7kkTwSV2yF0iqcap3dyBxwg==
Date:   Wed, 22 Jan 2020 02:28:31 +0000
Message-ID: <b9e84ce9f1ca457bb0835549d6fd5e51@huawei.com>
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
Paolo Bonzini <pbonzini@redhat.com> wrote:
>The function now has a single caller, so there is no point in keeping it separate.
>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>---
> arch/x86/kvm/mmu/mmu.c | 17 ++++-------------
> 1 file changed, 4 insertions(+), 13 deletions(-)


It looks fine for me. Thanks!
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

