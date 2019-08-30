Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758A1A36AE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfH3MVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 08:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfH3MVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 08:21:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7845D3083363;
        Fri, 30 Aug 2019 12:21:06 +0000 (UTC)
Received: from [10.36.117.243] (ovpn-117-243.ams2.redhat.com [10.36.117.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A30E60C05;
        Fri, 30 Aug 2019 12:21:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: Use interrupts in SCLP and add
 locking
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-2-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
Date:   Fri, 30 Aug 2019 14:21:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829121459.1708-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 30 Aug 2019 12:21:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.08.19 14:14, Janosch Frank wrote:
> We need to properly implement interrupt handling for SCLP, because on
> z/VM and LPAR SCLP calls are not synchronous!
> 
> Also with smp CPUs have to compete for sclp. Let's add some locking,
> so they execute sclp calls in an orderly fashion and don't compete for
> the data buffer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h |  2 ++
>  lib/s390x/interrupt.c     | 12 +++++++--
>  lib/s390x/sclp-console.c  |  2 ++
>  lib/s390x/sclp.c          | 54 +++++++++++++++++++++++++++++++++++++--
>  lib/s390x/sclp.h          |  3 +++
>  5 files changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 013709f..f485e96 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -11,6 +11,8 @@
>  #define _ASMS390X_IRQ_H_
>  #include <asm/arch_def.h>
>  
> +#define EXT_IRQ_SERVICE_SIG	0x2401
> +
>  void handle_pgm_int(void);
>  void handle_ext_int(void);
>  void handle_mcck_int(void);
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index cf0a794..7832711 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -12,6 +12,7 @@
>  #include <libcflat.h>
>  #include <asm/interrupt.h>
>  #include <asm/barrier.h>
> +#include <sclp.h>
>  
>  static bool pgm_int_expected;
>  static struct lowcore *lc;
> @@ -107,8 +108,15 @@ void handle_pgm_int(void)
>  
>  void handle_ext_int(void)
>  {
> -	report_abort("Unexpected external call interrupt: at %#lx",
> -		     lc->ext_old_psw.addr);
> +	if (lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
> +		report_abort("Unexpected external call interrupt: at %#lx",
> +			     lc->ext_old_psw.addr);
> +	} else {
> +		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
> +		lc->sw_int_cr0 &= ~(1UL << 9);
> +		sclp_handle_ext();
> +		lc->ext_int_code = 0;
> +	}
>  }
>  
>  void handle_mcck_int(void)
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index bc01f41..a5ef45f 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -17,6 +17,7 @@ static void sclp_set_write_mask(void)
>  {
>  	WriteEventMask *sccb = (void *)_sccb;
>  
> +	sclp_mark_busy();
>  	sccb->h.length = sizeof(WriteEventMask);
>  	sccb->mask_length = sizeof(unsigned int);
>  	sccb->receive_mask = SCLP_EVENT_MASK_MSG_ASCII;
> @@ -37,6 +38,7 @@ void sclp_print(const char *str)
>  	int len = strlen(str);
>  	WriteEventData *sccb = (void *)_sccb;
>  
> +	sclp_mark_busy();
>  	sccb->h.length = sizeof(WriteEventData) + len;
>  	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>  	sccb->ebh.length = sizeof(EventBufferHeader) + len;
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index b60f7a4..257eb02 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -14,6 +14,8 @@
>  #include <asm/page.h>
>  #include <asm/arch_def.h>
>  #include <asm/interrupt.h>
> +#include <asm/barrier.h>
> +#include <asm/spinlock.h>
>  #include "sclp.h"
>  #include <alloc_phys.h>
>  #include <alloc_page.h>
> @@ -25,6 +27,8 @@ static uint64_t max_ram_size;
>  static uint64_t ram_size;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
> +static volatile bool sclp_busy;
> +static struct spinlock sclp_lock;
>  
>  static void mem_init(phys_addr_t mem_end)
>  {
> @@ -41,17 +45,61 @@ static void mem_init(phys_addr_t mem_end)
>  	page_alloc_ops_enable();
>  }
>  
> +static void sclp_setup_int(void)
> +{
> +	uint64_t mask;
> +
> +	ctl_set_bit(0, 9);
> +
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +}
> +
> +void sclp_handle_ext(void)
> +{
> +	ctl_clear_bit(0, 9);
> +	spin_lock(&sclp_lock);
> +	sclp_busy = false;
> +	spin_unlock(&sclp_lock);
> +}
> +
> +void sclp_wait_busy(void)
> +{
> +	while (sclp_busy)
> +		mb();
> +}
> +
> +void sclp_mark_busy(void)
> +{
> +	/*
> +	 * With multiple CPUs we might need to wait for another CPU's
> +	 * request before grabbing the busy indication.
> +	 */
> +retry_wait:
> +	sclp_wait_busy();
> +	spin_lock(&sclp_lock);
> +	if (sclp_busy) {
> +		spin_unlock(&sclp_lock);
> +		goto retry_wait;
> +	}
> +	sclp_busy = true;
> +	spin_unlock(&sclp_lock);

while (true) {
	sclp_wait_busy();
	spin_lock(&sclp_lock);
	if (!sclp_busy) {
		sclp_busy = true
		spin_unlock(&sclp_lock);
		break;
	}
	spin_unlock(&sclp_lock);
}

Or can we simply switch to an atomic_t for sclp_busy and implement
cmpxchg using __sync_bool_compare_and_swap/ __sync_val_compare_and_swap ?

I guess then we can drop the lock. But maybe I am missing something :)

> +}
> +
>  static void sclp_read_scp_info(ReadInfo *ri, int length)
>  {
>  	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
>  				    SCLP_CMDW_READ_SCP_INFO };
> -	int i;
> +	int i, cc;
>  
>  	for (i = 0; i < ARRAY_SIZE(commands); i++) {
> +		sclp_mark_busy();
>  		memset(&ri->h, 0, sizeof(ri->h));
>  		ri->h.length = length;
>  
> -		if (sclp_service_call(commands[i], ri))
> +		cc = sclp_service_call(commands[i], ri);
> +		if (cc)
>  			break;
>  		if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
>  			return;
> @@ -66,12 +114,14 @@ int sclp_service_call(unsigned int command, void *sccb)
>  {
>  	int cc;
>  
> +	sclp_setup_int();
>  	asm volatile(
>  		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
>  		"       ipm     %0\n"
>  		"       srl     %0,28"
>  		: "=&d" (cc) : "d" (command), "a" (__pa(sccb))
>  		: "cc", "memory");
> +	sclp_wait_busy();
>  	if (cc == 3)
>  		return -1;
>  	if (cc == 2)
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 583c4e5..63cf609 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -213,6 +213,9 @@ typedef struct ReadEventData {
>  } __attribute__((packed)) ReadEventData;
>  
>  extern char _sccb[];
> +void sclp_handle_ext(void);
> +void sclp_wait_busy(void);
> +void sclp_mark_busy(void);

I wonder if we can find better names ...

sclp_prepare()
sclp_finalize()

or sth like that.

-- 

Thanks,

David / dhildenb
