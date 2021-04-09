Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B9D359130
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 03:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhDIBOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 21:14:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16421 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhDIBOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 21:14:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGg8H0ThTzkjtK;
        Fri,  9 Apr 2021 09:11:59 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 09:13:38 +0800
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
To:     Sean Christopherson <seanjc@google.com>
References: <20200828081157.15748-1-zhukeqian1@huawei.com>
 <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
 <YGzxzsRlqouaJv6a@google.com>
 <4fb6a85b-d318-256f-b401-89c35086885c@huawei.com>
 <YG8mslDJU8Br1UCx@google.com>
CC:     Ben Gardon <bgardon@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <8a4bd312-1005-e0d3-1840-8e07a947a5c2@huawei.com>
Date:   Fri, 9 Apr 2021 09:13:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YG8mslDJU8Br1UCx@google.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2021/4/8 23:52, Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Keqian Zhu wrote:
>> Hi Ben,
>>
>> Do you have any similar idea that can share with us?
> 
> Doh, Ben is out this week, he'll be back Monday.  Sorry for gumming up the works :-/
Please don't mind. I'm glad we can have some intersection of idea.
