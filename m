Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4D2687D7
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbfGOLFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 07:05:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:64019 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbfGOLFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 07:05:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 04:05:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="194476127"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.128.226]) ([10.238.128.226])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jul 2019 04:05:18 -0700
Subject: Re: [PATCH v1] KVM: x86: expose AVX512_BF16 feature to guest
To:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1562824197-13658-1-git-send-email-jing2.liu@linux.intel.com>
 <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
 <CANRm+CzOp6orH+7sqCQjLuxsYRccfq7H-o4QBcgxGfT-=RaJ-w@mail.gmail.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <332e8951-e6bb-8394-490d-26c8154712b9@linux.intel.com>
Date:   Mon, 15 Jul 2019 19:05:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANRm+CzOp6orH+7sqCQjLuxsYRccfq7H-o4QBcgxGfT-=RaJ-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/2019 2:06 PM, Wanpeng Li wrote:
> On Sat, 13 Jul 2019 at 18:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 11/07/19 07:49, Jing Liu wrote:
>>> AVX512 BFLOAT16 instructions support 16-bit BFLOAT16 floating-point
>>> format (BF16) for deep learning optimization.
>>>
>>> Intel adds AVX512 BFLOAT16 feature in CooperLake, which is CPUID.7.1.EAX[5].
>>>
>>> Detailed information of the CPUID bit can be found here,
>>> https://software.intel.com/sites/default/files/managed/c5/15/\
>>> architecture-instruction-set-extensions-programming-reference.pdf.
>>>
>>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>>> ---
>>>
[...]
> /home/kernel/data/kvm/arch/x86/kvm//cpuid.c: In function ‘do_cpuid_7_mask’:
> ./include/linux/kernel.h:819:29: warning: comparison of distinct
> pointer types lacks a cast
>     (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>                               ^
> ./include/linux/kernel.h:833:4: note: in expansion of macro ‘__typecheck’
>     (__typecheck(x, y) && __no_side_effects(x, y))
>      ^
> ./include/linux/kernel.h:843:24: note: in expansion of macro ‘__safe_cmp’
>    __builtin_choose_expr(__safe_cmp(x, y), \
>                          ^
> ./include/linux/kernel.h:852:19: note: in expansion of macro ‘__careful_cmp’
>   #define min(x, y) __careful_cmp(x, y, <)
>                     ^
> /home/kernel/data/kvm/arch/x86/kvm//cpuid.c:377:16: note: in expansion
> of macro ‘min’
>     entry->eax = min(entry->eax, 1);
>                  ^
> 
Thanks for the information.

This warning would be fixed by changing to
entry->eax = min(entry->eax, (u32)1);

@Paolo, sorry for trouble. Would you mind if I re-send?

Jing

