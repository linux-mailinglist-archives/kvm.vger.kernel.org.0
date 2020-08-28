Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25162553D1
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 06:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgH1EfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 00:35:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgH1EfG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 00:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598589304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RnwpTP732Li925pryIEZGUcNYhyrcWwboEitIlTDZVY=;
        b=YHkxvXjvjvxWt78k8XnOHoJLH1j/ZgSlwfUZp9ZX/neM+ial6kfIDyjVKmsYWgWdIFC/Cl
        0omIbu5MyPF1ofwN23ItxThGu8cf8SZvBeOuizj88M9wTslj9322CoOneXxq7py7iGiE55
        L/7cE1oxYncyqk7BlntjEnnL68Y63C8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-txyuvuEUPRC98uOOSEE7Tw-1; Fri, 28 Aug 2020 00:34:59 -0400
X-MC-Unique: txyuvuEUPRC98uOOSEE7Tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEFA25202;
        Fri, 28 Aug 2020 04:34:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF27B7C676;
        Fri, 28 Aug 2020 04:34:56 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/7] x86: Replace instruction prefixes with
 spaces
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-3-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c534cf9e-04cb-16be-bf57-f6f98fabf53c@redhat.com>
Date:   Fri, 28 Aug 2020 06:34:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-3-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> There are three kinds of x86 prefix delimiters in GNU binutils:
> '/', '\\' and a space.
> 
> The first works on Linux and few other platforms.  The second one is
> SVR-4 compatible and works on the generic elf target. The last kind is
> universal and works everywhere, it's also used in the GAS manual [1].
> Space delimiters fix the build errors on x86_64-elf binutils:
> 
>   x86/cstart64.S:217: Error: invalid character '/' in mnemonic
>   x86/cstart64.S:313: Error: invalid character '/' in mnemonic
> 
> 1. https://sourceware.org/binutils/docs/as/i386_002dPrefixes.html
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  x86/cstart.S   |  4 ++--
>  x86/cstart64.S |  4 ++--
>  x86/emulator.c | 38 +++++++++++++++++++-------------------
>  3 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index c0efc5f..489c561 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -149,7 +149,7 @@ save_id:
>  ap_start32:
>  	setup_segments
>  	mov $-4096, %esp
> -	lock/xaddl %esp, smp_stacktop
> +	lock xaddl %esp, smp_stacktop
>  	setup_percpu_area
>  	call prepare_32
>  	call reset_apic
> @@ -206,7 +206,7 @@ ap_init:
>  	lea sipi_entry, %esi
>  	xor %edi, %edi
>  	mov $(sipi_end - sipi_entry), %ecx
> -	rep/movsb
> +	rep movsb
>  	mov $APIC_DEFAULT_PHYS_BASE, %eax
>  	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%eax)
>  	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%eax)
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 2d16688..25a296c 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -226,7 +226,7 @@ sipi_end:
>  ap_start32:
>  	setup_segments
>  	mov $-4096, %esp
> -	lock/xaddl %esp, smp_stacktop
> +	lock xaddl %esp, smp_stacktop
>  	setup_percpu_area
>  	call prepare_64
>  	ljmpl $8, $ap_start64
> @@ -323,7 +323,7 @@ ap_init:
>  	lea sipi_entry, %rsi
>  	xor %rdi, %rdi
>  	mov $(sipi_end - sipi_entry), %rcx
> -	rep/movsb
> +	rep movsb
>  	mov $APIC_DEFAULT_PHYS_BASE, %eax
>  	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%rax)
>  	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%rax)
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 98743d1..e46d97e 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -61,71 +61,71 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
>  
>  	rsi = m1; rdi = m3; rcx = 30;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsb"
> +		     "repe cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsb (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 30;
>  	asm volatile("or $1, %[tmp]\n\t" // clear ZF
> -		     "repe/cmpsb"
> +		     "repe cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30,
> -	       "repe/cmpsb (1.zf)");
> +	       "repe cmpsb (1.zf)");
>  
>  	rsi = m1; rdi = m3; rcx = 15;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsw"
> +		     "repe cmpsw"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsw (1)");
> +	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe cmpsw (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 7;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsl"
> +		     "repe cmpsl"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe/cmpll (1)");
> +	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe cmpll (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 4;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsq"
> +		     "repe cmpsq"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe/cmpsq (1)");
> +	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe cmpsq (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 130;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsb"
> +		     "repe cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 29 && rsi == m1 + 101 && rdi == m3 + 101,
> -	       "repe/cmpsb (2)");
> +	       "repe cmpsb (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 65;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsw"
> +		     "repe cmpsw"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 14 && rsi == m1 + 102 && rdi == m3 + 102,
> -	       "repe/cmpsw (2)");
> +	       "repe cmpsw (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 32;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsl"
> +		     "repe cmpsl"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 6 && rsi == m1 + 104 && rdi == m3 + 104,
> -	       "repe/cmpll (2)");
> +	       "repe cmpll (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 16;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
> -		     "repe/cmpsq"
> +		     "repe cmpsq"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
>  	report(rcx == 3 && rsi == m1 + 104 && rdi == m3 + 104,
> -	       "repe/cmpsq (2)");
> +	       "repe cmpsq (2)");
>  
>  }
>  
> @@ -304,8 +304,8 @@ static void test_ljmp(void *mem)
>      volatile int res = 1;
>  
>      *(unsigned long**)m = &&jmpf;
> -    asm volatile ("data16/mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
> -    asm volatile ("rex64/ljmp *%0"::"m"(*m));
> +    asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
> +    asm volatile ("rex64 ljmp *%0"::"m"(*m));
>      res = 0;
>  jmpf:
>      report(res, "ljmp");
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

