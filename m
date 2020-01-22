Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250201449E6
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 03:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVCf5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Jan 2020 21:35:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2931 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbgAVCf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 21:35:57 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id BEE2DE29A543EB539133;
        Wed, 22 Jan 2020 10:35:54 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jan 2020 10:35:54 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 22 Jan 2020 10:35:53 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 22 Jan 2020 10:35:54 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: list MSR_IA32_UCODE_REV as an emulated MSR
Thread-Topic: [PATCH] KVM: x86: list MSR_IA32_UCODE_REV as an emulated MSR
Thread-Index: AdXQzHZRTIagUDob5kefwabjIx0yNA==
Date:   Wed, 22 Jan 2020 02:35:53 +0000
Message-ID: <3acc389b66324380adcbab302a924ce0@huawei.com>
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
>Even if it's read-only, it can still be written to by userspace.  Let them know by adding it to KVM_GET_MSR_INDEX_LIST.
>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

This make sense for me. Thanks!

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

