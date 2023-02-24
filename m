Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0D6A2236
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBXTRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 14:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBXTRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 14:17:00 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDBC6A7A5
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 11:16:55 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id j2so181154wrh.9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 11:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QIvROxK7/8vuDS3ZSZwNTP+/1drouqpIfPCvWGBrCro=;
        b=CbIVWMWJ0yofnSLE+R2+ScMCuKUJ1LhLZpFdu/Al8dB8qV/CXR3cZsluM/bUOpXk7b
         KMmSjTJilrs+6uuS3l2Pvut5U41qFUVmsUUYEiL9A4qcB1QgSN9ws6wgmAXSWZecZMws
         TvBYgexsAmlz0zQhzBSG850qlrzl50mzOfX7uhCPue4XJ3uQiS/FpzwiyjRDzliq7bz9
         TzV0ik7uy8MhNGhgJlt9zckjCJ7OWcWkjRd0Xd6FxQymPxJsbWIvJkWrBdFH9SkMNuD5
         HBGvLzJlqGRAc/O+qkcl4ju3a6Y0v57dicAReFn0rRcG87Hc3eQrFg5IpMA5d/opzyH9
         D5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QIvROxK7/8vuDS3ZSZwNTP+/1drouqpIfPCvWGBrCro=;
        b=RUGPJlHWXBtuBHTeHDoLcMmjnhkrD1ZISG0E45L6ewu508RZYIM0cEGjvUbjn396Sk
         hObAdT1QWZbaUtJxTcnNYBCQAjwU3xR1tpIjVgQ9WsBjK/vGlk01rl/yQmn7PR9EPxHw
         rfH1JvX3OZ49d+yX1PcEmFooHvZrhYr0kK5tNcRdHAr2Y6oxFy6U2NnPYH7V/mAC/TfI
         hgm9yC4CHaiQOpbVWJFPMW1CdIGQrzJdtdIHbyQFU5fauwK9eOMHhDjDFtbkXnf/NFPR
         VvDHQ/aXpVigT/6e1ReI+YW7hoPQq2jnSPvlWQMGmEAz1C3o8KzcajRmPX2Dcq9Y0N4i
         4EVA==
X-Gm-Message-State: AO0yUKUUeQuIWU6mlJ2weHO3PcRKStAAc85A3JWcJ40V9O96JIBIqzr/
        2ms1UkKyvu5Ge3Bqfe1aOCTLzw==
X-Google-Smtp-Source: AK7set/02h3YlwsWe/pf28HdxebjVuV3Yjul52q1beuvK6hlUdLQcymkaxuWZF/P2tRNF+V8Qgaqjw==
X-Received: by 2002:adf:dc91:0:b0:2c7:d6a:d7fa with SMTP id r17-20020adfdc91000000b002c70d6ad7famr9023126wrj.25.1677266214333;
        Fri, 24 Feb 2023 11:16:54 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:d12b:5d7b:42ef:d31a? ([2a02:6b6a:b566:0:d12b:5d7b:42ef:d31a])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c229500b003e1f2e43a1csm58102wmf.48.2023.02.24.11.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:16:53 -0800 (PST)
Message-ID: <05e27a7a-1faa-944e-2764-6ab4d620fb8f@bytedance.com>
Date:   Fri, 24 Feb 2023 19:16:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v10 6/8] x86/smpboot: Support parallel
 startup of secondary CPUs
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     tglx@linutronix.de, kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230221223352.2288528-1-usama.arif@bytedance.com>
 <20230221223352.2288528-7-usama.arif@bytedance.com>
 <20230224055941.fbr6wenbdsnzjf7q@yy-desk-7060>
 <481bce9d04e5e36303cf14dffdf46f844aefd11a.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <481bce9d04e5e36303cf14dffdf46f844aefd11a.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/02/2023 15:46, David Woodhouse wrote:
> On Fri, 2023-02-24 at 13:59 +0800, Yuan Yao wrote:
>>
>>> +        * Make sure only one CPU fiddles with the realmode stack
>>> +        */
>>> +.Llock_rm:
>>> +       btl     $0, tr_lock
>>> +       jnc     2f
>>> +       pause
>>> +       jmp     .Llock_rm
>>> +2:
>>> +       lock
>>> +       btsl    $0, tr_lock
>>> +       jc      .Llock_rm
>>> +
>>
>> Looks these changes should be applied to trampoline_start64()
>> yet, which is used for boot up APs when apic->wakeup_secondary_cpu_64
>> is available, e.g when ACPI_MADT_TYPE_MULTIPROC_WAKEUP is available.
>>
>> One case I know is the INTEL TD guest, which using the MADT wakeup
>> for AP wake up now.
> 
> Yeah.
> 
> I think we could probably pull that all out into a separate asm
> "load_realmode_esp" function which takes the lock and actually does the
> 'movl $rm_stack_end, %esp'.
> 
> Then we call it from all the places which currently use $rm_stack_end,
> including sev_es_trampoline_start (even though we currently disable
> parallel startup there because CPUID doesn't work that early).
> 
> Oh... except of course it can't be a function because we haven't got a
> stack, have we? It's a macro.
> 
> Usama, are you happy using .macro in gas?

Yes, makes sense. I guess something like below should be ok?
It makes sense to add it for sev as well.

diff --git a/arch/x86/realmode/rm/trampoline_64.S 
b/arch/x86/realmode/rm/trampoline_64.S
index e38d61d6562e..3a724d8d85b9 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -38,6 +38,25 @@
         .code16

         .balign PAGE_SIZE
+
+.macro LOAD_REALMODE_ESP
+       /*
+        * Make sure only one CPU fiddles with the realmode stack
+        */
+.Llock_rm\@:
+       btl     $0, tr_lock
+       jnc     2f
+       pause
+       jmp     .Llock_rm\@
+2:
+       lock
+       btsl    $0, tr_lock
+       jc      .Llock_rm\@
+
+       # Setup stack
+       movl    $rm_stack_end, %esp
+.endm
+
  SYM_CODE_START(trampoline_start)
         cli                     # We should be safe anyway
         wbinvd
@@ -49,8 +68,7 @@ SYM_CODE_START(trampoline_start)
         mov     %ax, %es
         mov     %ax, %ss

-       # Setup stack
-       movl    $rm_stack_end, %esp
+       LOAD_REALMODE_ESP

         call    verify_cpu              # Verify the cpu supports long mode
         testl   %eax, %eax              # Check for return code
@@ -93,8 +111,7 @@ SYM_CODE_START(sev_es_trampoline_start)
         mov     %ax, %es
         mov     %ax, %ss

-       # Setup stack
-       movl    $rm_stack_end, %esp
+       LOAD_REALMODE_ESP

         jmp     .Lswitch_to_protected
  SYM_CODE_END(sev_es_trampoline_start)
@@ -177,7 +194,7 @@ SYM_CODE_START(pa_trampoline_compat)
          * In compatibility mode.  Prep ESP and DX for startup_32, then 
disable
          * paging and complete the switch to legacy 32-bit mode.
          */
-       movl    $rm_stack_end, %esp
+       LOAD_REALMODE_ESP
         movw    $__KERNEL_DS, %dx

         movl    $(CR0_STATE & ~X86_CR0_PG), %eax


