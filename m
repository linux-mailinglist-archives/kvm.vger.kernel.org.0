Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F880455E30
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhKROiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:38:07 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:45825 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233350AbhKROiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:38:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UxDGhjF_1637246094;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxDGhjF_1637246094)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 22:34:56 +0800
Message-ID: <bcfa0e4d-f6ab-037a-9ce1-d0cd612422a5@linux.alibaba.com>
Date:   Thu, 18 Nov 2021 22:34:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct
 map
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-16-jiangshanlai@gmail.com>
 <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/18 19:12, Paolo Bonzini wrote:
> On 11/18/21 12:08, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> When direct map, gpte_is_8_bytes has no meaning, but it is true for all
>> other cases except direct map when nonpaping.
>>
>> Setting gpte_is_8_bytes to true when nonpaping can ensure that
>> !gpte_is_8_bytes means 32-bit gptes for shadow paging.
> 
> Then the right thing to do would be to rename it to has_4_byte_gptes and invert the direction.  But as things stand, 
> it's a bit more confusing to make gpte_is_8_bytes=1 if there are no guest PTEs at all.
> 

I will make the last 3 patches be a separated patchset and will do the rename.
