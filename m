Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D223152487
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 02:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgBEBlX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Feb 2020 20:41:23 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2938 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726653AbgBEBlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 20:41:22 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id DBBB9D97AE31E2D920E4;
        Wed,  5 Feb 2020 09:41:19 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 5 Feb 2020 09:41:19 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 5 Feb 2020 09:41:19 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 5 Feb 2020 09:41:19 +0800
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
Subject: Re: [PATCH v3 1/3] selftests: KVM: Replace get_gdt/idt_base() by
 get_gdt/idt()
Thread-Topic: [PATCH v3 1/3] selftests: KVM: Replace get_gdt/idt_base() by
 get_gdt/idt()
Thread-Index: AdXbxSnc8TQ+7K53fkOGc15JYLEBpQ==
Date:   Wed, 5 Feb 2020 01:41:19 +0000
Message-ID: <e4672d9990dd4ce3a5c59cb6cd8ec3a9@huawei.com>
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
> get_gdt_base() and get_idt_base() only return the base address of the descriptor tables. Soon we will need to get the size as well.
> Change the prototype of those functions so that they return the whole desc_ptr struct instead of the address field.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Looks good for me. Thanks.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com
>
