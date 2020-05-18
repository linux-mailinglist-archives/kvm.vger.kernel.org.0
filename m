Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964271D7571
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgERKpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:45:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25164 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726274AbgERKpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 06:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589798732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9AVgpVMcraOwUFv1UEKjf5OKjBzgFxVL20xBl8eYBW0=;
        b=NbmwU+TIyoyURIAZBWG9Nsqo+hK9+5m6TSnQ2MqHyw9d9Fa7ZW3Hzttaf+3JBaK20s9/yY
        /DjWQ004xlMl29cEVU/XkA1iwsbptS9PVt5Uf3lePpVZfOGhgLhojYXEVbtC7XofdS0wLC
        q8mIISdeZAAXI/JyERPEy/3xyKjfQ08=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-tTHuHphcPJimDhI8OKJF3A-1; Mon, 18 May 2020 06:45:30 -0400
X-MC-Unique: tTHuHphcPJimDhI8OKJF3A-1
Received: by mail-wm1-f72.google.com with SMTP id p24so3977989wmc.5
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 03:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AVgpVMcraOwUFv1UEKjf5OKjBzgFxVL20xBl8eYBW0=;
        b=uK7iC7WIF/cgvgDBFubZiAODnF9gU9DTh/4Vz3E9WOHbA/mcICX+yThg6hxPhQPMBe
         RMSutqmzDE6KBPvB+QcrTMetXUVPq0qQ6vtSdjmB4BNzmNY2UaZ04TJvI37ygNXtCFRx
         VrWRrRsTngaNLKmTCtPBfQqDj8rQ4DRbbhFpcVe6Mk2IFRQ2sFde4rOsULFRDpAFigSb
         ZvavYVFOO56K7kWQE8UDARuJjXK70vdWYDb7xAemWWnkEKfaAQOmWji6A1jfeeZVmNcl
         P4J1YFOAtrHN9J2NzTHP6YihLfZmEgVJTRB4ozepPhQ5Q1CUP3VC1CsXMhNWRf9Hqi2d
         4/3g==
X-Gm-Message-State: AOAM533xX3Stno9ofAIPDPbl/AnMjFs9tl/7td2DeWYs744uFPmr1K8T
        PA00i7DJ3wzl0PnviuYPqBwt40YMhwOkku45nqF81ncdQoR7qqfG5b7D97k/Fz1W3acTa5iZnFT
        uLxZtoqFUQi/X
X-Received: by 2002:a1c:2302:: with SMTP id j2mr18425618wmj.18.1589798729431;
        Mon, 18 May 2020 03:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGk/xypKDxWUoutE/dClx2MBwlj5we5zBso3NzS2NUVIVx1m9Poou5+UBeQN1BBbHjWpEq6A==
X-Received: by 2002:a1c:2302:: with SMTP id j2mr18425589wmj.18.1589798729147;
        Mon, 18 May 2020 03:45:29 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id f5sm16143455wrp.70.2020.05.18.03.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 03:45:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: realmode: Test interrupt delivery
 after STI
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Cameron Esfahani <dirty@apple.com>
References: <20200329071125.79253-1-r.bolshakov@yadro.com>
 <20200516211917.GA75422@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9be03165-5167-d1b5-12d7-c5aec666d257@redhat.com>
Date:   Mon, 18 May 2020 12:45:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200516211917.GA75422@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/20 23:19, Roman Bolshakov wrote:
> n Sun, Mar 29, 2020 at 10:11:25AM +0300, Roman Bolshakov wrote:
>> If interrupts are disabled, STI is inhibiting interrupts for the
>> instruction following it. If STI is followed by HLT, the CPU is going to
>> handle all pending or new interrupts as soon as HLT is executed.
>>
>> Test if emulator properly clears inhibition state and allows the
>> scenario outlined above.
>>
>> Cc: Cameron Esfahani <dirty@apple.com>
>> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
>> ---
>>  x86/realmode.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/x86/realmode.c b/x86/realmode.c
>> index 31f84d0..3518224 100644
>> --- a/x86/realmode.c
>> +++ b/x86/realmode.c
>> @@ -814,6 +814,26 @@ static void test_int(void)
>>  	report("int 1", 0, 1);
>>  }
>>  
>> +static void test_sti_inhibit(void)
>> +{
>> +	init_inregs(NULL);
>> +
>> +	*(u32 *)(0x73 * 4) = 0x1000; /* Store IRQ 11 handler in the IDT */
>> +	*(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
>> +
>> +	MK_INSN(sti_inhibit, "cli\n\t"
>> +			     "movw $0x200b, %dx\n\t"
>> +			     "movl $1, %eax\n\t"
>> +			     "outl %eax, %dx\n\t" /* Set IRQ11 */
>> +			     "movl $0, %eax\n\t"
>> +			     "outl %eax, %dx\n\t" /* Clear IRQ11 */
>> +			     "sti\n\t"
>> +			     "hlt\n\t");
>> +	exec_in_big_real_mode(&insn_sti_inhibit);
>> +
>> +	report("sti inhibit", ~0, 1);
>> +}
>> +
>>  static void test_imul(void)
>>  {
>>  	MK_INSN(imul8_1, "mov $2, %al\n\t"
>> @@ -1739,6 +1759,7 @@ void realmode_start(void)
>>  	test_xchg();
>>  	test_iret();
>>  	test_int();
>> +	test_sti_inhibit();
>>  	test_imul();
>>  	test_mul();
>>  	test_div();
>> -- 
>> 2.24.1
>>
> 
> Hi,
> 
> Should I resend the patch?
> And this one: https://patchwork.kernel.org/cover/11449525/ ?
> 
> Thanks,
> Roman
> 

Queued both, thanks.

Paolo

