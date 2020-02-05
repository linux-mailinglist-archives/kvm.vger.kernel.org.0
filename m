Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C6E1524A8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBECEb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Feb 2020 21:04:31 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727714AbgBECEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 21:04:30 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id CDED2E6D00C4B87923D3;
        Wed,  5 Feb 2020 10:04:28 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 5 Feb 2020 10:04:28 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 5 Feb 2020 10:04:28 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 5 Feb 2020 10:04:28 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Eric Auger <eric.auger@redhat.com>
CC:     "thuth@redhat.com" <thuth@redhat.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH v3 3/3] selftests: KVM: SVM: Add vmcall test
Thread-Topic: [PATCH v3 3/3] selftests: KVM: SVM: Add vmcall test
Thread-Index: AdXbyB4zr7+qb6A1sUeJJzyTAcTB5w==
Date:   Wed, 5 Feb 2020 02:04:28 +0000
Message-ID: <2fb49b67f85740649895a2482a17625d@huawei.com>
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

Eric Auger <eric.auger@redhat.com> writes:
> L2 guest calls vmcall and L1 checks the exit status does correspond.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

