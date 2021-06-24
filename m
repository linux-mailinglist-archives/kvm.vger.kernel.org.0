Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1143B286E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFXHUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:20:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:8319 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhFXHUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 03:20:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G9Wb46W9Zz725G;
        Thu, 24 Jun 2021 15:14:08 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 15:18:16 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 24 Jun 2021 15:18:15 +0800
Subject: Re: [PATCH] KVM: selftests: Speed up set_memory_region_test
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
References: <20210426130121.758229-1-vkuznets@redhat.com>
 <91a2d145-fd3c-6e8d-6478-60f62dff07fe@huawei.com>
 <3dc9bd69-f38a-daed-4ac3-84b280ef5901@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <941fc912-e773-8a04-a8f3-7426596d97b1@huawei.com>
Date:   Thu, 24 Jun 2021 15:18:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3dc9bd69-f38a-daed-4ac3-84b280ef5901@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/6/24 5:45, Paolo Bonzini wrote:
> Can you provide a patch for both?

Sent now.

Zenghui
