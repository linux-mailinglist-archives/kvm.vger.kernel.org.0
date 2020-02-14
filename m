Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B7915CF79
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 02:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgBNBcG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Feb 2020 20:32:06 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:59296 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727609AbgBNBcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 20:32:05 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 058F7DB771934DBA01EB;
        Fri, 14 Feb 2020 09:32:00 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 14 Feb 2020 09:31:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 14 Feb 2020 09:31:59 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 14 Feb 2020 09:31:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, "cai@lca.pw" <cai@lca.pw>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missing prototypes
Thread-Topic: [PATCH] KVM: x86: fix missing prototypes
Thread-Index: AdXi1eQHoO5Y4NitR1WWf5C14CusCA==
Date:   Fri, 14 Feb 2020 01:31:59 +0000
Message-ID: <d9f098766bf548a6bd2691eca3c8f40d@huawei.com>
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

Paolo Bonzini <pbonzini@redhat.com> wrote:
>Reported with "make W=1" due to -Wmissing-prototypes.
>
>Reported-by: Qian Cai <cai@lca.pw>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>---

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

