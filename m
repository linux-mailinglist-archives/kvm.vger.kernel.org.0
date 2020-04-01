Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9D519A569
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 08:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgDAGeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 02:34:20 -0400
Received: from mail.loongson.cn ([114.242.206.163]:36434 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731680AbgDAGeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 02:34:19 -0400
Received: from [10.20.42.25] (unknown [10.20.42.25])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxD97TNYRenW8iAA--.27S3;
        Wed, 01 Apr 2020 14:33:56 +0800 (CST)
Subject: Re: [PATCH] KVM: MIPS: fix compilation
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>
References: <20200331154749.5457-1-pbonzini@redhat.com>
 <20200331160703.GF30942@linux.ibm.com>
 <b2d15996-1e8b-02a5-7abd-3eb380442092@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, peterx@redhat.com
From:   maobibo <maobibo@loongson.cn>
Message-ID: <d9dc4c46-33bc-b3ac-020c-ef0a9931c250@loongson.cn>
Date:   Wed, 1 Apr 2020 14:33:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <b2d15996-1e8b-02a5-7abd-3eb380442092@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxD97TNYRenW8iAA--.27S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWDuryrZr1rJF1DZFyUAwb_yoWrJr4Upr
        Z7AayrtFW8Xr9xurySvas8tFy3Kw43Kr1Dua17JFyYqF1YqF4fuFn29r1rur18ZrW0yFyx
        uayYg3y3ur4Iy37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUklb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjc
        xK6I8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
        0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxv
        r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU56c_DUUUU
        U==
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04/01/2020 12:33 AM, Paolo Bonzini wrote:
> On 31/03/20 18:07, Mike Rapoport wrote:
>> On Tue, Mar 31, 2020 at 11:47:49AM -0400, Paolo Bonzini wrote:
>>> Commit 31168f033e37 is correct that pud_index() & __pud_offset() are the same
>>> when pud_index() is actually provided, however it does not take into account
>>> the __PAGETABLE_PUD_FOLDED case.  Provide kvm_pud_index so that MIPS KVM
>>> compiles.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/mips/kvm/mmu.c | 18 ++++++++++++------
>>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
>>> index 7dad7a293eae..ccf98c22fd2c 100644
>>> --- a/arch/mips/kvm/mmu.c
>>> +++ b/arch/mips/kvm/mmu.c
>>> @@ -25,6 +25,12 @@
>>>  #define KVM_MMU_CACHE_MIN_PAGES 2
>>>  #endif
>>>  
>>> +#if defined(__PAGETABLE_PUD_FOLDED)
>>> +#define kvm_pud_index(gva) 0
>>> +#else
>>> +#define kvm_pud_index(gva) pud_index(gva)
>>> +#endif
>>> +
>>
>> I'd prefer simply making pud_index() always defined. When pud level is
>> folded asm-generic/pgtable-nopud.h will define PTRS_PER_PUD to 1 and
>> pud_index() will evaluate to 0 anyway.
> 
> I won't queue this patch for now, let's wait for the MIPS people to say
> what they prefer.  Thanks!
Hi Paolo,

Thanks for patch, it passes to compile on my loongson64 box. I prefer to
the second method, since pgd_inde/pmd_index is already defined in
pgtable-64.h :)

> 
> Paolo

> 
>> diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
>> index f92716cfa4f4..ee5dc0c145b9 100644
>> --- a/arch/mips/include/asm/pgtable-64.h
>> +++ b/arch/mips/include/asm/pgtable-64.h
>> @@ -172,6 +172,8 @@
>>  
>>  extern pte_t invalid_pte_table[PTRS_PER_PTE];
>>  
>> +#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
>> +
>>  #ifndef __PAGETABLE_PUD_FOLDED
>>  /*
>>   * For 4-level pagetables we defines these ourselves, for 3-level the
>> @@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
>>  	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
>>  }
>>  
>> -#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
>> -
>>  static inline unsigned long p4d_page_vaddr(p4d_t p4d)
>>  {
>>  	return p4d_val(p4d);
>>
>>>  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>>>  				  int min, int max)
>>>  {
>>> @@ -234,8 +240,8 @@ static bool kvm_mips_flush_gpa_pud(pud_t *pud, unsigned long start_gpa,
>>>  {
>>>  	pmd_t *pmd;
>>>  	unsigned long end = ~0ul;
>>> -	int i_min = pud_index(start_gpa);
>>> -	int i_max = pud_index(end_gpa);
>>> +	int i_min = kvm_pud_index(start_gpa);
>>> +	int i_max = kvm_pud_index(end_gpa);
>>>  	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PUD - 1);
>>>  	int i;
>>>  
>>> @@ -361,8 +367,8 @@ static int kvm_mips_##name##_pud(pud_t *pud, unsigned long start,	\
>>>  	int ret = 0;							\
>>>  	pmd_t *pmd;							\
>>>  	unsigned long cur_end = ~0ul;					\
>>> -	int i_min = pud_index(start);				\
>>> -	int i_max = pud_index(end);					\
>>> +	int i_min = kvm_pud_index(start);				\
>>> +	int i_max = kvm_pud_index(end);					\
>>>  	int i;								\
>>>  									\
>>>  	for (i = i_min; i <= i_max; ++i, start = 0) {			\
>>> @@ -896,8 +902,8 @@ static bool kvm_mips_flush_gva_pud(pud_t *pud, unsigned long start_gva,
>>>  {
>>>  	pmd_t *pmd;
>>>  	unsigned long end = ~0ul;
>>> -	int i_min = pud_index(start_gva);
>>> -	int i_max = pud_index(end_gva);
>>> +	int i_min = kvm_pud_index(start_gva);
>>> +	int i_max = kvm_pud_index(end_gva);
>>>  	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PUD - 1);
>>>  	int i;
>>>  
>>> -- 
>>> 2.18.2
>>>
>>

