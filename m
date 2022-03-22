Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9578F4E4044
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiCVONi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiCVONE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:13:04 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740465EBD9
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:11:37 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r64so11156903wmr.4
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jZyHXiiRUKBPSug4zRfvxJ4vQfPiNJq+efCZBx4jhfA=;
        b=DlB4BIKJo6TzVJCw9sMT8OqwzzRRr1l6+FFZvCNpAFXJrnyXvCpEtr7Vw5SFQEmgrm
         eHSi2sBClyk1O1b93bdUhAslDp6gVl/9RgCm6VLfp+EJzRCc0o9WqWvvihYr5xIuymEB
         Ya9oFjVxDh3lTFtErvC3svUt3eRk9CKhAENa7By1Xxb22qq0YKwwNNJKJ+h1cxxJxnHN
         3VbgLPj6RO2tt2JPObUIPC3HX+Fua+xy85A6zmCgswNdkZsmDZZckGNXOVgdph7tKClP
         oXKz3NRZuLngJtenZVFwTEKVukJmhstB18ZnbMbNhSCV3nwSTBpXC2hguyJfXQKzh9+w
         JGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jZyHXiiRUKBPSug4zRfvxJ4vQfPiNJq+efCZBx4jhfA=;
        b=hdwMThjT4t49GBCsYNff0o4rCE5xktzEDtlcJNL4sdq8hcrQh7zATPBo1kteqnSjCX
         NDeViS/+0Ym1Nbr1HyFQTo9pPSPsTthSsnBHR5gHAg/ekF6zsjMOJXXX7osfREY2R08t
         RK8G7u+CXqeZLkqa53S100zux0fTb39K3faMfwMo4IslGUyZyoQbG+WBoOgihyoyH23J
         uVs/eNc8F8F/kxUgmlI0BL7kSkbknBsw56BoufJLS+yf7USU1zaajUSkGbIzDdptaqSg
         Mv/DdCcznOOVNgmQTxqme+a5DAoR9QaHWnetqDAqYvzmhaTowqH+hGi3Ba5fglP9j3TD
         hGeg==
X-Gm-Message-State: AOAM531T91jGgsZVT21cB8pcBwGQrgz8Msh88UhMPKcsA6iqDkVrECy2
        gft++6tF38dbc/AveiYoY6g=
X-Google-Smtp-Source: ABdhPJwiLRJOyCSrZGigL9EUS+F9+c+h9NYg009qlbPibZaGiOsn11fwhgL6wff6JxREyS3zB3TJNw==
X-Received: by 2002:a05:600c:154c:b0:389:fb24:f36c with SMTP id f12-20020a05600c154c00b00389fb24f36cmr4163047wmg.51.1647958295996;
        Tue, 22 Mar 2022 07:11:35 -0700 (PDT)
Received: from [192.168.1.33] (198.red-83-50-65.dynamicip.rima-tde.net. [83.50.65.198])
        by smtp.gmail.com with ESMTPSA id l12-20020a056000022c00b00203ee262d12sm12392042wrz.116.2022.03.22.07.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 07:11:35 -0700 (PDT)
Message-ID: <4967c8c2-36be-fa58-d111-bf33342fe3cd@gmail.com>
Date:   Tue, 22 Mar 2022 15:11:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when
 destroying vCPU
Content-Language: en-US
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Mark Kanda <mark.kanda@oracle.com>
References: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
 <20220322145629.7e0b3b8c@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220322145629.7e0b3b8c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/3/22 14:56, Igor Mammedov wrote:
> On Tue, 22 Mar 2022 13:05:22 +0100
> Philippe Mathieu-Daudé         <philippe.mathieu.daude@gmail.com> wrote:
> 
>> From: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>
>> Fix vCPU hot-unplug related leak reported by Valgrind:
>>
>>    ==132362== 4,096 bytes in 1 blocks are definitely lost in loss record 8,440 of 8,549
>>    ==132362==    at 0x4C3B15F: memalign (vg_replace_malloc.c:1265)
>>    ==132362==    by 0x4C3B288: posix_memalign (vg_replace_malloc.c:1429)
>>    ==132362==    by 0xB41195: qemu_try_memalign (memalign.c:53)
>>    ==132362==    by 0xB41204: qemu_memalign (memalign.c:73)
>>    ==132362==    by 0x7131CB: kvm_init_xsave (kvm.c:1601)
>>    ==132362==    by 0x7148ED: kvm_arch_init_vcpu (kvm.c:2031)
>>    ==132362==    by 0x91D224: kvm_init_vcpu (kvm-all.c:516)
>>    ==132362==    by 0x9242C9: kvm_vcpu_thread_fn (kvm-accel-ops.c:40)
>>    ==132362==    by 0xB2EB26: qemu_thread_start (qemu-thread-posix.c:556)
>>    ==132362==    by 0x7EB2159: start_thread (in /usr/lib64/libpthread-2.28.so)
>>    ==132362==    by 0x9D45DD2: clone (in /usr/lib64/libc-2.28.so)
>>
>> Reported-by: Mark Kanda <mark.kanda@oracle.com>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> Based on a series from Mark:
>> https://lore.kernel.org/qemu-devel/20220321141409.3112932-1-mark.kanda@oracle.com/
>>
>> RFC because currently no time to test
>> ---
>>   target/i386/kvm/kvm.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index ef2c68a6f4..e93440e774 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2072,6 +2072,8 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
>>       X86CPU *cpu = X86_CPU(cs);
>>       CPUX86State *env = &cpu->env;
>>   
>> +    g_free(env->xsave_buf);
>> +
>>       if (cpu->kvm_msr_buf) {
>>           g_free(cpu->kvm_msr_buf);
>>           cpu->kvm_msr_buf = NULL;
> 
> 
> shouldn't we do the same in hvf_arch_vcpu_destroy() ?

Yeah HVF needs a similar patch (at least hvf_caps needs to be released
too, but I had no time to review it carefully yet).

