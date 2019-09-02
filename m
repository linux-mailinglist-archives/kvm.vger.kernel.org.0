Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39906A552E
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 13:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfIBLmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 07:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbfIBLmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 07:42:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72607356CE;
        Mon,  2 Sep 2019 11:42:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF06E19C5B;
        Mon,  2 Sep 2019 11:42:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: Use interrupts in SCLP and add
 locking
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-2-frankja@linux.ibm.com>
 <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <ef136fcb-67e5-2530-33fe-84b91f5860b2@redhat.com>
Date:   Mon, 2 Sep 2019 13:42:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 02 Sep 2019 11:42:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/2019 14.21, David Hildenbrand wrote:
> On 29.08.19 14:14, Janosch Frank wrote:
>> We need to properly implement interrupt handling for SCLP, because on
>> z/VM and LPAR SCLP calls are not synchronous!
>>
>> Also with smp CPUs have to compete for sclp. Let's add some locking,
>> so they execute sclp calls in an orderly fashion and don't compete for
>> the data buffer.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/interrupt.h |  2 ++
>>  lib/s390x/interrupt.c     | 12 +++++++--
>>  lib/s390x/sclp-console.c  |  2 ++
>>  lib/s390x/sclp.c          | 54 +++++++++++++++++++++++++++++++++++++--
>>  lib/s390x/sclp.h          |  3 +++
>>  5 files changed, 69 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index 013709f..f485e96 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -11,6 +11,8 @@
>>  #define _ASMS390X_IRQ_H_
>>  #include <asm/arch_def.h>
>>  
>> +#define EXT_IRQ_SERVICE_SIG	0x2401
>> +
>>  void handle_pgm_int(void);
>>  void handle_ext_int(void);
>>  void handle_mcck_int(void);
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index cf0a794..7832711 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -12,6 +12,7 @@
>>  #include <libcflat.h>
>>  #include <asm/interrupt.h>
>>  #include <asm/barrier.h>
>> +#include <sclp.h>
>>  
>>  static bool pgm_int_expected;
>>  static struct lowcore *lc;
>> @@ -107,8 +108,15 @@ void handle_pgm_int(void)
>>  
>>  void handle_ext_int(void)
>>  {
>> -	report_abort("Unexpected external call interrupt: at %#lx",
>> -		     lc->ext_old_psw.addr);
>> +	if (lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
>> +		report_abort("Unexpected external call interrupt: at %#lx",
>> +			     lc->ext_old_psw.addr);
>> +	} else {
>> +		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
>> +		lc->sw_int_cr0 &= ~(1UL << 9);
>> +		sclp_handle_ext();
>> +		lc->ext_int_code = 0;
>> +	}
>>  }
>>  
>>  void handle_mcck_int(void)
>> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
>> index bc01f41..a5ef45f 100644
>> --- a/lib/s390x/sclp-console.c
>> +++ b/lib/s390x/sclp-console.c
>> @@ -17,6 +17,7 @@ static void sclp_set_write_mask(void)
>>  {
>>  	WriteEventMask *sccb = (void *)_sccb;
>>  
>> +	sclp_mark_busy();
>>  	sccb->h.length = sizeof(WriteEventMask);
>>  	sccb->mask_length = sizeof(unsigned int);
>>  	sccb->receive_mask = SCLP_EVENT_MASK_MSG_ASCII;
>> @@ -37,6 +38,7 @@ void sclp_print(const char *str)
>>  	int len = strlen(str);
>>  	WriteEventData *sccb = (void *)_sccb;
>>  
>> +	sclp_mark_busy();
>>  	sccb->h.length = sizeof(WriteEventData) + len;
>>  	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>>  	sccb->ebh.length = sizeof(EventBufferHeader) + len;
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index b60f7a4..257eb02 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -14,6 +14,8 @@
>>  #include <asm/page.h>
>>  #include <asm/arch_def.h>
>>  #include <asm/interrupt.h>
>> +#include <asm/barrier.h>
>> +#include <asm/spinlock.h>
>>  #include "sclp.h"
>>  #include <alloc_phys.h>
>>  #include <alloc_page.h>
>> @@ -25,6 +27,8 @@ static uint64_t max_ram_size;
>>  static uint64_t ram_size;
>>  
>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>> +static volatile bool sclp_busy;
>> +static struct spinlock sclp_lock;
>>  
>>  static void mem_init(phys_addr_t mem_end)
>>  {
>> @@ -41,17 +45,61 @@ static void mem_init(phys_addr_t mem_end)
>>  	page_alloc_ops_enable();
>>  }
>>  
>> +static void sclp_setup_int(void)
>> +{
>> +	uint64_t mask;
>> +
>> +	ctl_set_bit(0, 9);
>> +
>> +	mask = extract_psw_mask();
>> +	mask |= PSW_MASK_EXT;
>> +	load_psw_mask(mask);
>> +}
>> +
>> +void sclp_handle_ext(void)
>> +{
>> +	ctl_clear_bit(0, 9);
>> +	spin_lock(&sclp_lock);
>> +	sclp_busy = false;
>> +	spin_unlock(&sclp_lock);
>> +}
>> +
>> +void sclp_wait_busy(void)
>> +{
>> +	while (sclp_busy)
>> +		mb();
>> +}
>> +
>> +void sclp_mark_busy(void)
>> +{
>> +	/*
>> +	 * With multiple CPUs we might need to wait for another CPU's
>> +	 * request before grabbing the busy indication.
>> +	 */
>> +retry_wait:
>> +	sclp_wait_busy();
>> +	spin_lock(&sclp_lock);
>> +	if (sclp_busy) {
>> +		spin_unlock(&sclp_lock);
>> +		goto retry_wait;
>> +	}
>> +	sclp_busy = true;
>> +	spin_unlock(&sclp_lock);
> 
> while (true) {
> 	sclp_wait_busy();
> 	spin_lock(&sclp_lock);
> 	if (!sclp_busy) {
> 		sclp_busy = true
> 		spin_unlock(&sclp_lock);
> 		break;
> 	}
> 	spin_unlock(&sclp_lock);
> }

I'd also prefer this without "goto".

> Or can we simply switch to an atomic_t for sclp_busy and implement
> cmpxchg using __sync_bool_compare_and_swap/ __sync_val_compare_and_swap ?
> 
> I guess then we can drop the lock. But maybe I am missing something :)
> 
>> +}
>> +
>>  static void sclp_read_scp_info(ReadInfo *ri, int length)
>>  {
>>  	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
>>  				    SCLP_CMDW_READ_SCP_INFO };
>> -	int i;
>> +	int i, cc;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(commands); i++) {
>> +		sclp_mark_busy();
>>  		memset(&ri->h, 0, sizeof(ri->h));
>>  		ri->h.length = length;
>>  
>> -		if (sclp_service_call(commands[i], ri))
>> +		cc = sclp_service_call(commands[i], ri);
>> +		if (cc)
>>  			break;
>>  		if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
>>  			return;
>> @@ -66,12 +114,14 @@ int sclp_service_call(unsigned int command, void *sccb)
>>  {
>>  	int cc;
>>  
>> +	sclp_setup_int();
>>  	asm volatile(
>>  		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
>>  		"       ipm     %0\n"
>>  		"       srl     %0,28"
>>  		: "=&d" (cc) : "d" (command), "a" (__pa(sccb))
>>  		: "cc", "memory");
>> +	sclp_wait_busy();
>>  	if (cc == 3)
>>  		return -1;
>>  	if (cc == 2)
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index 583c4e5..63cf609 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -213,6 +213,9 @@ typedef struct ReadEventData {
>>  } __attribute__((packed)) ReadEventData;
>>  
>>  extern char _sccb[];
>> +void sclp_handle_ext(void);
>> +void sclp_wait_busy(void);
>> +void sclp_mark_busy(void);
> 
> I wonder if we can find better names ...
> 
> sclp_prepare()
> sclp_finalize()
> 
> or sth like that.

IMHO "mark_busy" / "wait_busy" is more logical than "prepare" /
"finalize". With "busy" in the name, I can figure out the meaning, while
with "prepare" and "finalize", I'd rather wonder what it is about, I think.

 Thomas
