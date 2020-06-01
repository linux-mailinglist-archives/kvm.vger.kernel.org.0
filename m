Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9D1EA04C
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgFAIrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 04:47:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbgFAIrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 04:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591001261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZ94LbPEcind1QrZo5LUsiK0o5q9EhNyzcaZ6eu8GiU=;
        b=VQzaXfAKIpR7h7dt1vyY/3Zh+yuRygbtbadce/BgA8c45oFCHJKSJxvLGUl9JzRwXN5hE8
        tbMoenyce5iqRKrn935567BKcGbn29t7YU7GOnXDZU4xPybHWK4VGwvcGm3R3UEU5PFEK7
        YZjhREPFpeurjSEHlXv0y6Rp5B/fEIY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-sOkMLW7wM3O6hEIHm2jTwg-1; Mon, 01 Jun 2020 04:47:36 -0400
X-MC-Unique: sOkMLW7wM3O6hEIHm2jTwg-1
Received: by mail-wm1-f69.google.com with SMTP id l26so2421025wmh.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 01:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tZ94LbPEcind1QrZo5LUsiK0o5q9EhNyzcaZ6eu8GiU=;
        b=JAnCdShmW9COMvUYkpp5eeU5Q9cbIj6qWgLKV/8tTbchTjwg+JUpgdqQxbUzjvmTY5
         iVWimaZN0dJmIsm740yK0k+WsHZlI7TwWULOS76rxMyytfB10VCxAd7aNSH7UzXQhW79
         oz5+LEGIMYr8Wub9hpUSrUTzHgbiKwpTjUZSSZJgrbH2TFEgYCry6T3P8uXslRCvBzME
         xHOi4qoZLHm1L+7d1FnhJoN2pD4ZYggFF3bUYK5glo/cVFVQHkgaYiiRYvsd7ZfqECsm
         v0JGKqF23PlPOU9GQOH82aSpXaRO7RDOWmZe3sSQEEbZAEBqfJDTf4aPP05F4sYlpgQa
         4OZw==
X-Gm-Message-State: AOAM5312SENkOXIeGrz78DtasSqZylZXACvlb7Mpg9oU9Iyoin3fZH0r
        qdNEZZY4+S0Itnd+IQcK61BpMMVPqsLV0n8Z/f2Bei58ZJi9FyUIhk7i8tMslb0bjuPlQCU0EGH
        3b4SUOO/qXW6C
X-Received: by 2002:adf:e588:: with SMTP id l8mr22396453wrm.255.1591001255373;
        Mon, 01 Jun 2020 01:47:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTicBdoQgfiOI9kBAQ9qEID/UAUfx22KjKKio/XR2fgR/M2neyvtj5xpheLlx38rvoTuw47Q==
X-Received: by 2002:adf:e588:: with SMTP id l8mr22396431wrm.255.1591001255081;
        Mon, 01 Jun 2020 01:47:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c? ([2001:b07:6468:f312:e044:3d2:1991:920c])
        by smtp.gmail.com with ESMTPSA id a81sm10450838wmd.25.2020.06.01.01.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 01:47:34 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: realmode: Add suffixes for push, pop
 and iret
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
References: <20200529212637.5034-1-r.bolshakov@yadro.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <28bfa900-ef1d-5363-dcfc-e78c7d9bd0b1@redhat.com>
Date:   Mon, 1 Jun 2020 10:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529212637.5034-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 23:26, Roman Bolshakov wrote:
> binutils 2.33 and 2.34 changed generation of PUSH and POP for segment
> registers and IRET in '.code16gcc' [1][2][3][4]. gas also yields the
> following warnings during the build of realmode.c:
> 
> snip.s: Assembler messages:
> snip.s:2279: Warning: generating 32-bit `push', unlike earlier gas versions
> snip.s:2296: Warning: generating 32-bit `pop', unlike earlier gas versions
> snip.s:3633: Warning: generating 16-bit `iret' for .code16gcc directive
> 
> This change fixes warnings and failures of the tests:
> 
>   push/pop 3
>   push/pop 4
>   iret 1
>   iret 3
> 
> 1. https://sourceware.org/bugzilla/show_bug.cgi?id=24485
> 2. https://sourceware.org/git/?p=binutils-gdb.git;h=7cb22ff84745
> 3. https://sourceware.org/git/?p=binutils-gdb.git;h=06f74c5cb868
> 4. https://sourceware.org/git/?p=binutils-gdb.git;h=13e600d0f560
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  x86/realmode.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 3518224..234d607 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -649,24 +649,24 @@ static void test_push_pop(void)
>  	MK_INSN(push_es, "mov $0x231, %bx\n\t" //Just write a dummy value to see if it gets overwritten
>  			 "mov $0x123, %ax\n\t"
>  			 "mov %ax, %es\n\t"
> -			 "push %es\n\t"
> +			 "pushw %es\n\t"
>  			 "pop %bx \n\t"
>  			 );
>  	MK_INSN(pop_es, "push %ax\n\t"
> -			"pop %es\n\t"
> +			"popw %es\n\t"
>  			"mov %es, %bx\n\t"
>  			);
> -	MK_INSN(push_pop_ss, "push %ss\n\t"
> +	MK_INSN(push_pop_ss, "pushw %ss\n\t"
>  			     "pushw %ax\n\t"
>  			     "popw %ss\n\t"
>  			     "mov %ss, %bx\n\t"
> -			     "pop %ss\n\t"
> +			     "popw %ss\n\t"
>  			);
> -	MK_INSN(push_pop_fs, "push %fs\n\t"
> +	MK_INSN(push_pop_fs, "pushl %fs\n\t"
>  			     "pushl %eax\n\t"
>  			     "popl %fs\n\t"
>  			     "mov %fs, %ebx\n\t"
> -			     "pop %fs\n\t"
> +			     "popl %fs\n\t"
>  			);
>  	MK_INSN(push_pop_high_esp_bits,
>  		"xor $0x12340000, %esp \n\t"
> @@ -752,7 +752,7 @@ static void test_iret(void)
>  			"pushl %cs\n\t"
>  			"call 1f\n\t" /* a near call will push eip onto the stack */
>  			"jmp 2f\n\t"
> -			"1: iret\n\t"
> +			"1: iretl\n\t"
>  			"2:\n\t"
>  		     );
>  
> @@ -771,7 +771,7 @@ static void test_iret(void)
>  			      "pushl %cs\n\t"
>  			      "call 1f\n\t"
>  			      "jmp 2f\n\t"
> -			      "1: iret\n\t"
> +			      "1: iretl\n\t"
>  			      "2:\n\t");
>  
>  	MK_INSN(iret_flags16, "pushfw\n\t"
> @@ -1340,10 +1340,10 @@ static void test_lds_lss(void)
>  {
>  	init_inregs(&(struct regs){ .ebx = (unsigned long)&desc });
>  
> -	MK_INSN(lds, "push %ds\n\t"
> +	MK_INSN(lds, "pushl %ds\n\t"
>  		     "lds (%ebx), %eax\n\t"
>  		     "mov %ds, %ebx\n\t"
> -		     "pop %ds\n\t");
> +		     "popl %ds\n\t");
>  	exec_in_big_real_mode(&insn_lds);
>  	report("lds", R_AX | R_BX,
>  		outregs.eax == (unsigned long)desc.address &&
> @@ -1356,28 +1356,28 @@ static void test_lds_lss(void)
>  		outregs.eax == (unsigned long)desc.address &&
>  		outregs.ebx == desc.sel);
>  
> -	MK_INSN(lfs, "push %fs\n\t"
> +	MK_INSN(lfs, "pushl %fs\n\t"
>  		     "lfs (%ebx), %eax\n\t"
>  		     "mov %fs, %ebx\n\t"
> -		     "pop %fs\n\t");
> +		     "popl %fs\n\t");
>  	exec_in_big_real_mode(&insn_lfs);
>  	report("lfs", R_AX | R_BX,
>  		outregs.eax == (unsigned long)desc.address &&
>  		outregs.ebx == desc.sel);
>  
> -	MK_INSN(lgs, "push %gs\n\t"
> +	MK_INSN(lgs, "pushl %gs\n\t"
>  		     "lgs (%ebx), %eax\n\t"
>  		     "mov %gs, %ebx\n\t"
> -		     "pop %gs\n\t");
> +		     "popl %gs\n\t");
>  	exec_in_big_real_mode(&insn_lgs);
>  	report("lgs", R_AX | R_BX,
>  		outregs.eax == (unsigned long)desc.address &&
>  		outregs.ebx == desc.sel);
>  
> -	MK_INSN(lss, "push %ss\n\t"
> +	MK_INSN(lss, "pushl %ss\n\t"
>  		     "lss (%ebx), %eax\n\t"
>  		     "mov %ss, %ebx\n\t"
> -		     "pop %ss\n\t");
> +		     "popl %ss\n\t");
>  	exec_in_big_real_mode(&insn_lss);
>  	report("lss", R_AX | R_BX,
>  		outregs.eax == (unsigned long)desc.address &&
> 

Queued, thanks.

Paolo

