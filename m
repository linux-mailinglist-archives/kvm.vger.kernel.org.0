Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2D716B33
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 19:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjE3RgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 13:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjE3Rf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 13:35:59 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B11998
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:35:56 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75b0df81142so548515985a.2
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vultr.com; s=google; t=1685468155; x=1688060155;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:reply-to:user-agent:mime-version:date:message-id:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sK54f6qHysiXeD+8nB5SFeVEbShzrT204J51fGNACGM=;
        b=rAKD4s5byEB9THzGqLlllpXXTUIPtiroJFrlCGDGvHI3vKI9olLbm4LeMilyOLRgWW
         TYjzryFm8uSxJ3NwIYa6iZhe+z/CLDbuJFr7Aqr+MGAqjlJyH++azkZmkl82mZZuq7O7
         /cy+WW+59n+rzM6Ifu/AAuBYvdkTtp3BfEpyCra88/PTzE8wJX7Hdw8GQpTft4kVg4BM
         6iB2Y2sc+dyVMDqFOL6PnoQnU0s3Ke73LihmAEnLx0dGlno63LXPJwMeoxO/MrObm+Hq
         fByUtEbXH3+Iq5KabiJ3qu+9aNonhAQdx0QfMkqyAMHy1mawpO8AOHXD9WXvYh+uX2Z8
         DLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685468155; x=1688060155;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:reply-to:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sK54f6qHysiXeD+8nB5SFeVEbShzrT204J51fGNACGM=;
        b=FXqMxiTQB/N0lFDFQqOEGekIds7XMrDtmtvu/9cHbfcC/zJSgfLPxQovFKl8Fz4wnt
         L1iR7VZzbPXE/DJvwfHz5b0tY9MHOQzwzCEC1FftT1hOHt1M5pgwqORh+p5A4RPkQ7f9
         frn3NfcHHjRAbKaEHQC2irYwfuM0JQyMD9fZeobQ46if6sgGJzAvG1/4Ldn4IGQfqxyJ
         U4XXFG+GDMsQ1l9ioINEEvqJxQ3Jyxo1glZki7WkooGhTuR/1wVaxcmWwXBY9q20s9HM
         dAEOBxyIpE6zctf5j2Wx82eO4ecdHVdhg0V/DPSREmxlgEuhGF0A7zV0/kES7MtOOWz7
         mhvA==
X-Gm-Message-State: AC+VfDz+KKeSkCDD2NASIESG/mUISI+bVjJltcV1C5UQfTLIELOhXFyU
        OxYQR1Jp6GkN8wblxi68/2HCF/SpQY161P+UKUE=
X-Google-Smtp-Source: ACHHUZ5ROFlduERbj/aubvyLsgBCwcIL0G/QNqs3Y8VzQO8Crhj6yxQ/QaVcBX2EkL15Ej9vY/996A==
X-Received: by 2002:a05:620a:8908:b0:75b:23a0:dec0 with SMTP id ql8-20020a05620a890800b0075b23a0dec0mr2783388qkn.62.1685468155411;
        Tue, 30 May 2023 10:35:55 -0700 (PDT)
Received: from [10.7.101.16] ([208.167.225.210])
        by smtp.gmail.com with ESMTPSA id g26-20020ae9e11a000000b0075cbd92c4b4sm3349682qkm.91.2023.05.30.10.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 10:35:54 -0700 (PDT)
From:   Brian Rak <brak@vultr.com>
X-Google-Original-From: Brian Rak <brak@gameservers.com>
Message-ID: <9fa11f06-bd55-b061-d16a-081351f04a13@gameservers.com>
Date:   Tue, 30 May 2023 13:35:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Reply-To: brak@gameservers.com
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
 <ZGzoUZLpPopkgvM0@google.com>
 <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
 <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com>
 <ZHEefxsu5E3BsPni@google.com>
Content-Language: en-US
In-Reply-To: <ZHEefxsu5E3BsPni@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/26/2023 5:02 PM, Sean Christopherson wrote:
> On Fri, May 26, 2023, Brian Rak wrote:
>> On 5/24/2023 9:39 AM, Brian Rak wrote:
>>> On 5/23/2023 12:22 PM, Sean Christopherson wrote:
>>>> The other thing that would be helpful would be getting kernel stack
>>>> traces of the
>>>> relevant tasks/threads.ï¿½ The vCPU stack traces won't be interesting,
>>>> but it'll
>>>> likely help to see what the fallocate() tasks are doing.
>>> I'll see what I can come up with here, I was running into some
>>> difficulty getting useful stack traces out of the VM
>> I didn't have any luck gathering guest-level stack traces - kaslr makes it
>> pretty difficult even if I have the guest kernel symbols.
> Sorry, I was hoping to get host stack traces, not guest stack traces.  I am hoping
> to see what the fallocate() in the *host* is doing.

Ah - here's a different instance of it with a full backtrace from the host:

(gdb) thread apply all bt

Thread 8 (Thread 0x7fbbd0bff700 (LWP 353251) "vnc_worker"):
#0  futex_wait_cancelable (private=0, expected=0, 
futex_word=0x7fbddd4f6b2c) at ../sysdeps/nptl/futex-internal.h:186
#1  __pthread_cond_wait_common (abstime=0x0, clockid=0, 
mutex=0x7fbddd4f6b38, cond=0x7fbddd4f6b00) at pthread_cond_wait.c:508
#2  __pthread_cond_wait (cond=cond@entry=0x7fbddd4f6b00, 
mutex=mutex@entry=0x7fbddd4f6b38) at pthread_cond_wait.c:638
#3  0x00005593ea9a232b in qemu_cond_wait_impl (cond=0x7fbddd4f6b00, 
mutex=0x7fbddd4f6b38, file=0x5593eaa152b4 "../../ui/vnc-jobs.c", 
line=248) at ../../util/qemu-thread-posix.c:220
#4  0x00005593ea4bfc33 in vnc_worker_thread_loop (queue=0x7fbddd4f6b00) 
at ../../ui/vnc-jobs.c:248
#5  0x00005593ea4c08f8 in vnc_worker_thread 
(arg=arg@entry=0x7fbddd4f6b00) at ../../ui/vnc-jobs.c:361
#6  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbd0bfcf30) at 
../../util/qemu-thread-posix.c:505
#7  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#8  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 7 (Thread 0x7fbbd85ff700 (LWP 353248) "CPU 3/KVM"):
#0  0x00007fbddf11d237 in ioctl () at ../sysdeps/unix/syscall-template.S:120
#1  0x00005593ea844007 in kvm_vcpu_ioctl (cpu=cpu@entry=0x7fbddd42f7c0, 
type=type@entry=44672) at ../../accel/kvm/kvm-all.c:3035
#2  0x00005593ea844171 in kvm_cpu_exec (cpu=cpu@entry=0x7fbddd42f7c0) at 
../../accel/kvm/kvm-all.c:2850
#3  0x00005593ea8457ed in kvm_vcpu_thread_fn 
(arg=arg@entry=0x7fbddd42f7c0) at ../../accel/kvm/kvm-accel-ops.c:51
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbd85fcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 6 (Thread 0x7fbbd97ff700 (LWP 353247) "CPU 2/KVM"):
#0  0x00007fbddf11d237 in ioctl () at ../sysdeps/unix/syscall-template.S:120
#1  0x00005593ea844007 in kvm_vcpu_ioctl (cpu=cpu@entry=0x7fbddd4213c0, 
type=type@entry=44672) at ../../accel/kvm/kvm-all.c:3035
#2  0x00005593ea844171 in kvm_cpu_exec (cpu=cpu@entry=0x7fbddd4213c0) at 
../../accel/kvm/kvm-all.c:2850
#3  0x00005593ea8457ed in kvm_vcpu_thread_fn 
(arg=arg@entry=0x7fbddd4213c0) at ../../accel/kvm/kvm-accel-ops.c:51
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbd97fcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 5 (Thread 0x7fbbda9ff700 (LWP 353246) "CPU 1/KVM"):
#0  0x00007fbddf11d237 in ioctl () at ../sysdeps/unix/syscall-template.S:120
#1  0x00005593ea844007 in kvm_vcpu_ioctl (cpu=cpu@entry=0x7fbddd6f5e40, 
type=type@entry=44672) at ../../accel/kvm/kvm-all.c:3035
#2  0x00005593ea844171 in kvm_cpu_exec (cpu=cpu@entry=0x7fbddd6f5e40) at 
../../accel/kvm/kvm-all.c:2850
#3  0x00005593ea8457ed in kvm_vcpu_thread_fn 
(arg=arg@entry=0x7fbddd6f5e40) at ../../accel/kvm/kvm-accel-ops.c:51
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbda9fcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 4 (Thread 0x7fbbdbbff700 (LWP 353245) "CPU 0/KVM"):
#0  0x00007fbddf11d237 in ioctl () at ../sysdeps/unix/syscall-template.S:120
#1  0x00005593ea844007 in kvm_vcpu_ioctl (cpu=cpu@entry=0x7fbddd6a8c00, 
type=type@entry=44672) at ../../accel/kvm/kvm-all.c:3035
#2  0x00005593ea844171 in kvm_cpu_exec (cpu=cpu@entry=0x7fbddd6a8c00) at 
../../accel/kvm/kvm-all.c:2850
#3  0x00005593ea8457ed in kvm_vcpu_thread_fn 
(arg=arg@entry=0x7fbddd6a8c00) at ../../accel/kvm/kvm-accel-ops.c:51
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbdbbfcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 3 (Thread 0x7fbbdcfff700 (LWP 353244) "IO mon_iothread"):
#0  0x00007fbddf11b96f in __GI___poll (fds=0x7fbbdc209000, nfds=3, 
timeout=-1) at ../sysdeps/unix/sysv/linux/poll.c:29
#1  0x00007fbddf6eb0ae in ?? () from 
target:/lib/x86_64-linux-gnu/libglib-2.0.so.0
#2  0x00007fbddf6eb40b in g_main_loop_run () from 
target:/lib/x86_64-linux-gnu/libglib-2.0.so.0
#3  0x00005593ea880509 in iothread_run 
(opaque=opaque@entry=0x7fbddd51db00) at ../../iothread.c:74
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbbdcffcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 2 (Thread 0x7fbdddfff700 (LWP 353235) "qemu-kvm"):
#0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
#1  0x00005593ea9a29aa in qemu_futex_wait (val=<optimized out>, 
f=<optimized out>) at ./include/qemu/futex.h:29
#2  qemu_event_wait (ev=ev@entry=0x5593eb1a21a8 <rcu_call_ready_event>) 
at ../../util/qemu-thread-posix.c:430
#3  0x00005593ea9abd80 in call_rcu_thread (opaque=opaque@entry=0x0) at 
../../util/rcu.c:261
#4  0x00005593ea9a17e9 in qemu_thread_start (args=0x7fbdddffcf30) at 
../../util/qemu-thread-posix.c:505
#5  0x00007fbddf51bea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
#6  0x00007fbddf127a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

Thread 1 (Thread 0x7fbdde874680 (LWP 353228) "qemu-kvm"):
#0  0x00007fbddf11ba66 in __ppoll (fds=0x7fbbd39b9f00, nfds=21, 
timeout=<optimized out>, timeout@entry=0x7fff9ff32c90, 
sigmask=sigmask@entry=0x0) at ../sysdeps/unix/sysv/linux/ppoll.c:44
#1  0x00005593ea9b70f1 in ppoll (__ss=0x0, __timeout=0x7fff9ff32c90, 
__nfds=<optimized out>, __fds=<optimized out>) at 
/usr/include/x86_64-linux-gnu/bits/poll2.h:77
#2  qemu_poll_ns (fds=<optimized out>, nfds=<optimized out>, 
timeout=timeout@entry=2429393072) at ../../util/qemu-timer.c:351
#3  0x00005593ea9b4955 in os_host_main_loop_wait (timeout=2429393072) at 
../../util/main-loop.c:315
#4  main_loop_wait (nonblocking=nonblocking@entry=0) at 
../../util/main-loop.c:606
#5  0x00005593ea64ca91 in qemu_main_loop () at ../../softmmu/runstate.c:739
#6  0x00005593ea84c8e7 in qemu_default_main () at ../../softmmu/main.c:37
#7  0x00007fbddf04fd0a in __libc_start_main (main=0x5593ea497620 <main>, 
argc=109, argv=0x7fff9ff32e58, init=<optimized out>, fini=<optimized 
out>, rtld_fini=<optimized out>, stack_end=0x7fff9ff32e48) at 
../csu/libc-start.c:308
#8  0x00005593ea498dda in _start ()

and trace with -e all from that same guest:

              CPU-353246 [041] 5473778.770320: write_msr:            
1d9, value 4000
              CPU-353248 [027] 5473778.770321: write_msr:            
1d9, value 4000
              CPU-353246 [041] 5473778.770321: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc726140 info 683 0
              CPU-353248 [027] 5473778.770321: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353245 [039] 5473778.770321: kvm_entry:            
vcpu 0, rip 0xffffffffbc7648b0
              CPU-353246 [041] 5473778.770321: kvm_page_fault:       
vcpu 1 rip 0xffffffffbc726140 address 0x00000001170aaff8 error_code 0x683
              CPU-353247 [019] 5473778.770321: write_msr:            
1d9, value 4000
              CPU-353248 [027] 5473778.770321: kvm_page_fault:       
vcpu 3 rip 0xffffffffbc7648b0 address 0x0000000274300ff8 error_code 0x683
              CPU-353245 [039] 5473778.770321: rcu_utilization:      
Start context switch
              CPU-353247 [019] 5473778.770321: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353245 [039] 5473778.770322: rcu_utilization:      End 
context switch
              CPU-353246 [041] 5473778.770322: kvm_entry:            
vcpu 1, rip 0xffffffffbc726140
              CPU-353247 [019] 5473778.770322: kvm_page_fault:       
vcpu 2 rip 0xffffffffbc7648b0 address 0x000000026e580ff8 error_code 0x683
              CPU-353248 [027] 5473778.770322: kvm_entry:            
vcpu 3, rip 0xffffffffbc7648b0
              CPU-353246 [041] 5473778.770322: rcu_utilization:      
Start context switch
              CPU-353246 [041] 5473778.770322: rcu_utilization:      End 
context switch
              CPU-353248 [027] 5473778.770322: rcu_utilization:      
Start context switch
              CPU-353248 [027] 5473778.770322: rcu_utilization:      End 
context switch
              CPU-353247 [019] 5473778.770323: kvm_entry:            
vcpu 2, rip 0xffffffffbc7648b0
              CPU-353245 [039] 5473778.770323: write_msr:            
1d9, value 4000
              CPU-353245 [039] 5473778.770323: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353247 [019] 5473778.770323: rcu_utilization:      
Start context switch
              CPU-353246 [041] 5473778.770323: write_msr:            
1d9, value 4000
              CPU-353245 [039] 5473778.770323: kvm_page_fault:       
vcpu 0 rip 0xffffffffbc7648b0 address 0x0000000263670ff8 error_code 0x683
              CPU-353246 [041] 5473778.770323: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc726140 info 683 0
              CPU-353247 [019] 5473778.770323: rcu_utilization:      End 
context switch
              CPU-353248 [027] 5473778.770324: write_msr:            
1d9, value 4000
              CPU-353246 [041] 5473778.770324: kvm_page_fault:       
vcpu 1 rip 0xffffffffbc726140 address 0x00000001170aaff8 error_code 0x683
              CPU-353248 [027] 5473778.770324: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353245 [039] 5473778.770324: kvm_entry:            
vcpu 0, rip 0xffffffffbc7648b0
              CPU-353248 [027] 5473778.770324: kvm_page_fault:       
vcpu 3 rip 0xffffffffbc7648b0 address 0x0000000274300ff8 error_code 0x683
              CPU-353246 [041] 5473778.770324: kvm_entry:            
vcpu 1, rip 0xffffffffbc726140
              CPU-353245 [039] 5473778.770324: rcu_utilization:      
Start context switch
              CPU-353246 [041] 5473778.770325: rcu_utilization:      
Start context switch
              CPU-353247 [019] 5473778.770325: write_msr:            
1d9, value 4000
              CPU-353245 [039] 5473778.770325: rcu_utilization:      End 
context switch
              CPU-353246 [041] 5473778.770325: rcu_utilization:      End 
context switch
              CPU-353247 [019] 5473778.770325: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353248 [027] 5473778.770325: kvm_entry:            
vcpu 3, rip 0xffffffffbc7648b0
              CPU-353247 [019] 5473778.770325: kvm_page_fault:       
vcpu 2 rip 0xffffffffbc7648b0 address 0x000000026e580ff8 error_code 0x683
              CPU-353248 [027] 5473778.770325: rcu_utilization:      
Start context switch
              CPU-353248 [027] 5473778.770326: rcu_utilization:      End 
context switch
              CPU-353245 [039] 5473778.770326: write_msr:            
1d9, value 4000
              CPU-353246 [041] 5473778.770326: write_msr:            
1d9, value 4000
              CPU-353245 [039] 5473778.770326: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353247 [019] 5473778.770326: kvm_entry:            
vcpu 2, rip 0xffffffffbc7648b0
              CPU-353246 [041] 5473778.770326: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc726140 info 683 0
              CPU-353245 [039] 5473778.770326: kvm_page_fault:       
vcpu 0 rip 0xffffffffbc7648b0 address 0x0000000263670ff8 error_code 0x683
              CPU-353246 [041] 5473778.770326: kvm_page_fault:       
vcpu 1 rip 0xffffffffbc726140 address 0x00000001170aaff8 error_code 0x683
              CPU-353247 [019] 5473778.770326: rcu_utilization:      
Start context switch
              CPU-353247 [019] 5473778.770327: rcu_utilization:      End 
context switch
              CPU-353248 [027] 5473778.770327: write_msr:            
1d9, value 4000
              CPU-353246 [041] 5473778.770327: kvm_entry:            
vcpu 1, rip 0xffffffffbc726140
              CPU-353248 [027] 5473778.770327: kvm_exit:             
reason EPT_VIOLATION rip 0xffffffffbc7648b0 info 683 0
              CPU-353245 [039] 5473778.770327: kvm_entry:            
vcpu 0, rip 0xffffffffbc7648b0
              CPU-353246 [041] 5473778.770327: rcu_utilization:      
Start context switch
              CPU-353246 [041] 5473778.770328: rcu_utilization:      End 
context switch

> Another datapoint that might provide insight would be seeing if/how KVM's page
> faults stats change, e.g. look at /sys/kernel/debug/kvm/pf_* multiple times when
> the guest is stuck.

It looks like pf_taken is the only real one incrementing:

# cd /sys/kernel/debug/kvm/353228-12

# tail -n1 pf*; sleep 5; ; echo "======"; tail -n1 pf*
==> pf_emulate <==
12353

==> pf_fast <==
56

==> pf_fixed <==
27039604264

==> pf_guest <==
0

==> pf_mmio_spte_created <==
12353

==> pf_spurious <==
2348694

==> pf_taken <==
74486522452
======
==> pf_emulate <==
12353

==> pf_fast <==
56

==> pf_fixed <==
27039604264

==> pf_guest <==
0

==> pf_mmio_spte_created <==
12353

==> pf_spurious <==
2348694

==> pf_taken <==
74499574212
# tail -n1 *tlb*; sleep 5; echo "======"; tail -n1 *tlb*
==> remote_tlb_flush <==
1731549762

==> remote_tlb_flush_requests <==
3092024754

==> tlb_flush <==
8203297646
======
==> remote_tlb_flush <==
1731549762

==> remote_tlb_flush_requests <==
3092024754

==> tlb_flush <==
8203297649


> Are you able to run modified host kernels?  If so, the easiest next step, assuming
> stack traces don't provide a smoking gun, would be to add printks into the page
> fault path to see why KVM is retrying instead of installing a SPTE.
We can, but it can take quite some time from when we do the update to 
actually seeing results.  This problem is inconsistent at best, and even 
though we're seeing it a ton of times a day, it's can show up anywhere.  
Even if we rolled it out today, we'd still be looking at weeks/months 
before we had any significant number of machines on it.
