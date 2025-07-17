Return-Path: <kvm+bounces-52728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC04B08963
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5982E16EDB4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B3F28A1CB;
	Thu, 17 Jul 2025 09:36:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EBD635;
	Thu, 17 Jul 2025 09:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752744978; cv=none; b=k1SdoATqzonBfK/CDePTWY3/ujREVPxKNehnBzgxSDuFCoboKhLWZyhViURGmd1Fy0D+MjU8Ew8k6HFooxgyv9LWQTvFE6XMpbOuDtMBeLAfPEYR8MDkDMx74eoMv71sDQixd4TW+24kvq8pJYHP7xjzJvAgre4kA9kHyoE5x7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752744978; c=relaxed/simple;
	bh=lV9s8cQGdVlk8KLLMG2fK07Zh33dA0ZZGXO2SRPaGBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6YS36PcFtrduAJC3E9D87lWdsTXLdDEhUGqFUEHlJItSuhRPb3ZPR1U9IpIIZ5f4r6oE8kAJrqWtcvFMCoJearUW6Xgig+MtxK0tJMseJkKRalfCEkwalC/s4zN2w6ZNfF5BqZckBSDSQSo1C/e0lu2XJQMFAy4JlYEKwmKXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [10.69.1.138] (unknown [180.111.100.227])
	by APP-05 (Coremail) with SMTP id zQCowAC3SVoFxHhoW9PDBA--.4361S2;
	Thu, 17 Jul 2025 17:36:06 +0800 (CST)
Message-ID: <3eabf9a8-d518-4d22-bb66-cc891176d820@iscas.ac.cn>
Date: Thu, 17 Jul 2025 17:24:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: riscv: selftests: Add common supported test
 cases
To: Andrew Jones <ajones@ventanamicro.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <cover.1749810735.git.zhouquan@iscas.ac.cn>
 <7e8f1272337e8d03851fd3bb7f6fc739e604309e.1749810736.git.zhouquan@iscas.ac.cn>
 <20250624-d7b4b9ba702fcaf2f42695b1@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20250624-d7b4b9ba702fcaf2f42695b1@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:zQCowAC3SVoFxHhoW9PDBA--.4361S2
X-Coremail-Antispam: 1UD129KBjvJXoWxArWfGF1Dur17Xr1fCryrtFb_yoWrCF43p3
	WFyFyjkF4kCF17Jw1fGrsrZFWxK395KF48Kr1Yg3yUZr1UJF4xJrn3Kayakrnaqws0vr1S
	ka4agF4a9ayDtw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkIb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWxJVW8Jr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAI
	w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJw
	CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
	z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1m0PDUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAUGBmh4vWsbGQAAsN



On 2025/6/24 22:10, Andrew Jones wrote:
> On Fri, Jun 13, 2025 at 07:30:13PM +0800, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Some common KVM test cases are supported on riscv now as following:
>>
>>      access_tracking_perf_test
>>      demand_paging_test
>>      dirty_log_perf_test
>>      dirty_log_test
>>      guest_print_test
>>      kvm_binary_stats_test
>>      kvm_create_max_vcpus
>>      kvm_page_table_test
>>      memslot_modification_stress_test
>>      memslot_perf_test
>>      rseq_test
>>      set_memory_region_test
> 
> Half this list is already build for riscv since they're common. See
> TEST_GEN_PROGS_COMMON. If the other half can be built and run then
> please send a separate patch, not something tacked onto this series,
> since they're all unrelated to the series.
> 
>>
>> Add missing headers for tests and fix RISCV_FENCE redefinition
>> in `rseq-riscv.h` by using the existing macro from <asm/fence.h>.
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>   tools/testing/selftests/kvm/Makefile.kvm             | 12 ++++++++++++
>>   .../testing/selftests/kvm/include/riscv/processor.h  |  2 ++
>>   tools/testing/selftests/rseq/rseq-riscv.h            |  3 +--
>>   3 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>> index 38b95998e1e6..565e191e99c8 100644
>> --- a/tools/testing/selftests/kvm/Makefile.kvm
>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
>> @@ -197,6 +197,18 @@ TEST_GEN_PROGS_riscv += arch_timer
>>   TEST_GEN_PROGS_riscv += coalesced_io_test
>>   TEST_GEN_PROGS_riscv += get-reg-list
>>   TEST_GEN_PROGS_riscv += steal_time
>> +TEST_GEN_PROGS_riscv += access_tracking_perf_test
>> +TEST_GEN_PROGS_riscv += demand_paging_test
>> +TEST_GEN_PROGS_riscv += dirty_log_perf_test
>> +TEST_GEN_PROGS_riscv += dirty_log_test
>> +TEST_GEN_PROGS_riscv += guest_print_test
>> +TEST_GEN_PROGS_riscv += kvm_binary_stats_test
>> +TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
>> +TEST_GEN_PROGS_riscv += kvm_page_table_test
>> +TEST_GEN_PROGS_riscv += memslot_modification_stress_test
>> +TEST_GEN_PROGS_riscv += memslot_perf_test
>> +TEST_GEN_PROGS_riscv += rseq_test
>> +TEST_GEN_PROGS_riscv += set_memory_region_test
>>   
>>   TEST_GEN_PROGS_loongarch += coalesced_io_test
>>   TEST_GEN_PROGS_loongarch += demand_paging_test
>> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
>> index 162f303d9daa..4cf5ae11760f 100644
>> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
>> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
>> @@ -9,7 +9,9 @@
>>   
>>   #include <linux/stringify.h>
>>   #include <asm/csr.h>
>> +#include <asm/vdso/processor.h>
>>   #include "kvm_util.h"
>> +#include "ucall_common.h"
> 
> These should be included directly from the tests that need them.
> 
>>   
>>   #define INSN_OPCODE_MASK	0x007c
>>   #define INSN_OPCODE_SHIFT	2
>> diff --git a/tools/testing/selftests/rseq/rseq-riscv.h b/tools/testing/selftests/rseq/rseq-riscv.h
>> index 67d544aaa9a3..06c840e81c8b 100644
>> --- a/tools/testing/selftests/rseq/rseq-riscv.h
>> +++ b/tools/testing/selftests/rseq/rseq-riscv.h
>> @@ -8,6 +8,7 @@
>>    * exception when executed in all modes.
>>    */
>>   #include <endian.h>
>> +#include <asm/fence.h>
>>   
>>   #if defined(__BYTE_ORDER) ? (__BYTE_ORDER == __LITTLE_ENDIAN) : defined(__LITTLE_ENDIAN)
>>   #define RSEQ_SIG   0xf1401073  /* csrr mhartid, x0 */
>> @@ -24,8 +25,6 @@
>>   #define REG_L	__REG_SEL("ld ", "lw ")
>>   #define REG_S	__REG_SEL("sd ", "sw ")
>>   
>> -#define RISCV_FENCE(p, s) \
>> -	__asm__ __volatile__ ("fence " #p "," #s : : : "memory")
>>   #define rseq_smp_mb()	RISCV_FENCE(rw, rw)
>>   #define rseq_smp_rmb()	RISCV_FENCE(r, r)
>>   #define rseq_smp_wmb()	RISCV_FENCE(w, w)
>> -- 
>> 2.34.1
> 
> tools/testing/selftests/rseq isn't under KVM's purview, so this should be
> a separate patch CC'ing the appropriate people and lists.
> 
> Thanks,
> drew

Thanks so much for your review, I'll split and modify this set of patches.

Regards,
Quan


