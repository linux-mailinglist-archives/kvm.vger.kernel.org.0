Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBC1617FB
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 17:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgBQQcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 11:32:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43980 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728778AbgBQQcK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 11:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581957127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DgjkXbrR+aTgzwFOwaNUb/pGw0eTRC9dHf2eJzgmD4=;
        b=MGmxuWOcsqMKJVPUrVb4LEV0S476PvQRPOMfpe4AY7XMauSURQgMeG1C/t9Dtyj2fBUdZg
        /eD791wU57UfPU4SUMKFGIInR5Ab+p7Cw49vBto/Aht7KQRNe9E5+beXwko6/Kw10mcwfQ
        I5bma4IzGEyg4G/0may3QRGTHqRuRfM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-hRpPpvkfMKeTKLgBk1OTag-1; Mon, 17 Feb 2020 11:32:05 -0500
X-MC-Unique: hRpPpvkfMKeTKLgBk1OTag-1
Received: by mail-wr1-f69.google.com with SMTP id p8so9200936wrw.5
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 08:32:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DgjkXbrR+aTgzwFOwaNUb/pGw0eTRC9dHf2eJzgmD4=;
        b=tFaFJXKni8vuTVytKXdciIiV7USVGIKwzy3IsqieBjCsE0rCdSQREA7ap29EcVI8t1
         Iy4KLl/UPzSvvD/2yPh38O1vnxm48rHo/WRY3h1QSqQe0SL/ObvfW+FH9hmyPCV6dPH7
         6Z0k7nkSZydoSNzp6fayMocrjU+nFd9JaOJiJyIJjPYl3EHO7e76xjEg5QPCsis5/c7v
         Orb9YVWXkwJ6A9A9nPCUtkjCPDecCdszA4zHju/vvHiSyd4KAn1KE+NBHGMhvN8knWE4
         CQa19Wewds5vPjrKI0B8PemQdkqi3QwF/dojj+ceTh1AXafaaW6S0MgGsoOC5g5ihNaU
         Cj6w==
X-Gm-Message-State: APjAAAW7sI+4dQ2XSh+rWz0kMeOf+REMqqrZqqAvdUPULaNynYbAlRw/
        UYTZkNQbZ2ng8STRbA+vI7RIUPvmIBBMKQupaJgFUI4PLfoFAzfOanIrd+banIuRPmet3ppXoAg
        Ewaso1X1QcRlr
X-Received: by 2002:adf:806c:: with SMTP id 99mr22067824wrk.328.1581957124418;
        Mon, 17 Feb 2020 08:32:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzIkRaqPRA5fxC/o142XfHpQPvCWt4G7Lm0VpbLP9NAmGgM9VPdSXcXhEE/8ug60zSKhzy02w==
X-Received: by 2002:adf:806c:: with SMTP id 99mr22067803wrk.328.1581957124159;
        Mon, 17 Feb 2020 08:32:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id c141sm1087609wme.41.2020.02.17.08.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 08:32:03 -0800 (PST)
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
To:     Qian Cai <cai@lca.pw>, Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
 <20200214165923.GA20690@linux.intel.com> <1581700124.7365.70.camel@lca.pw>
 <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
 <1581707646.7365.72.camel@lca.pw>
 <28680b99-d043-ee02-dab3-b5ce8c2e625b@redhat.com>
 <1581950844.7365.82.camel@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <030ced86-5ef0-0a2e-7c66-dbfb1416b8b5@redhat.com>
Date:   Mon, 17 Feb 2020 17:32:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581950844.7365.82.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 15:47, Qian Cai wrote:
> On Fri, 2020-02-14 at 20:33 +0100, Paolo Bonzini wrote:
>> On 14/02/20 20:14, Qian Cai wrote:
>>>> It seems misguided to define a local variable just to get an implicit
>>>> cast from (void *) to (fastop_t). Sean's first suggestion gives you
>>>> the same implicit cast without the local variable. The second
>>>> suggestion makes both casts explicit.
>>>
>>> OK, I'll do a v2 using the first suggestion which looks simpler once it passed
>>> compilations.
>>>
>>
>> Another interesting possibility is to use an unnamed union of a
>> (*execute) function pointer and a (*fastop) function pointer.
>>
> 
> This?

Yes, perfect.  Can you send it with Signed-off-by and all that?

Thanks,

Paolo

> diff --git a/arch/x86/include/asm/kvm_emulate.h
> b/arch/x86/include/asm/kvm_emulate.h
> index 03946eb3e2b9..2a8f2bd2e5cf 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -292,6 +292,14 @@ enum x86emul_mode {
>  #define X86EMUL_SMM_MASK             (1 << 6)
>  #define X86EMUL_SMM_INSIDE_NMI_MASK  (1 << 7)
>  
> +/*
> + * fastop functions are declared as taking a never-defined fastop parameter,
> + * so they can't be called from C directly.
> + */
> +struct fastop;
> +
> +typedef void (*fastop_t)(struct fastop *);
> +
>  struct x86_emulate_ctxt {
>  	const struct x86_emulate_ops *ops;
>  
> @@ -324,7 +332,10 @@ struct x86_emulate_ctxt {
>  	struct operand src;
>  	struct operand src2;
>  	struct operand dst;
> -	int (*execute)(struct x86_emulate_ctxt *ctxt);
> +	union {
> +		int (*execute)(struct x86_emulate_ctxt *ctxt);
> +		fastop_t fop;
> +	};
>  	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
>  	/*
>  	 * The following six fields are cleared together,
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index ddbc61984227..dd19fb3539e0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -191,25 +191,6 @@
>  #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
>  #define FASTOP_SIZE 8
>  
> -/*
> - * fastop functions have a special calling convention:
> - *
> - * dst:    rax        (in/out)
> - * src:    rdx        (in/out)
> - * src2:   rcx        (in)
> - * flags:  rflags     (in/out)
> - * ex:     rsi        (in:fastop pointer, out:zero if exception)
> - *
> - * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
> - * different operand sizes can be reached by calculation, rather than a jump
> - * table (which would be bigger than the code).
> - *
> - * fastop functions are declared as taking a never-defined fastop parameter,
> - * so they can't be called from C directly.
> - */
> -
> -struct fastop;
> -
>  struct opcode {
>  	u64 flags : 56;
>  	u64 intercept : 8;
> @@ -311,8 +292,19 @@ static void invalidate_registers(struct x86_emulate_ctxt
> *ctxt)
>  #define ON64(x)
>  #endif
>  
> -typedef void (*fastop_t)(struct fastop *);
> -
> +/*
> + * fastop functions have a special calling convention:
> + *
> + * dst:    rax        (in/out)
> + * src:    rdx        (in/out)
> + * src2:   rcx        (in)
> + * flags:  rflags     (in/out)
> + * ex:     rsi        (in:fastop pointer, out:zero if exception)
> + *
> + * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
> + * different operand sizes can be reached by calculation, rather than a jump
> + * table (which would be bigger than the code).
> + */
>  static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>  
>  #define __FOP_FUNC(name) \
> @@ -5683,7 +5675,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  
>  	if (ctxt->execute) {
>  		if (ctxt->d & Fastop)
> -			rc = fastop(ctxt, (fastop_t)ctxt->execute);
> +			rc = fastop(ctxt, ctxt->fop);
>  		else
>  			rc = ctxt->execute(ctxt);
>  		if (rc != X86EMUL_CONTINUE)
> 

