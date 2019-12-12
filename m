Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE84011C2DC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfLLCCU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Dec 2019 21:02:20 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2534 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727584AbfLLCCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 21:02:20 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 31B2679CAB7D093DF318;
        Thu, 12 Dec 2019 10:02:17 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Dec 2019 10:02:16 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 12 Dec 2019 10:02:16 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 12 Dec 2019 10:02:16 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 6/6] KVM: Fix some writing mistakes
Thread-Topic: [PATCH 6/6] KVM: Fix some writing mistakes
Thread-Index: AdWwj3wg8ae1y0yjTKygu5joUnhHkg==
Date:   Thu, 12 Dec 2019 02:02:16 +0000
Message-ID: <64b60a489d1f405285781a6105a06f2d@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson wrote:
>On Wed, Dec 11, 2019 at 02:26:25PM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> Fix some writing mistakes in the comments.
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  	 * This context will save all necessary information to walk page tables
>> -	 * of the an L2 guest. This context is only initialized for page table
>> +	 * of the L2 guest. This context is only initialized for page table
>
>I'd whack "the" instead of "and", i.e. ...walk page tables of an L2 guest, as KVM isn't limited to just one L2 guest.

I'd change this.

>>  	 * walking and not for faulting since we never handle l2 page faults 
>> on
>
>While you're here, want to change "l2" to "L2"?

I do nothing here. :)

>>  	 * the host.
>>  	 */
>> check_user_page_hwpoison(unsigned long addr)
>>  /*
>>   * The fast path to get the writable pfn which will be stored in @pfn,
>>   * true indicates success, otherwise false is returned.  It's also 
>> the
>> - * only part that runs if we can are in atomic context.
>> + * only part that runs if we can in atomic context.
>
>This should remove "can" instead of "are", i.e. ...part that runs if we are in atomic context.  The comment is calling out that hva_to_pfn() will return immediately if hva_to_pfn_fast() and the kernel is atomic context.
>

Many thanks for your explanation, I would change this too. And many thanks for your review.
