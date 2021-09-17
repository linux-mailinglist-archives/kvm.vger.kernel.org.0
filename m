Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF94C40FB6E
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhIQPN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 11:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbhIQPN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 11:13:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E08C061767
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:12:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t6so31249044edi.9
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8t6EOdK7NPdMy+YK2ByhMHAlbs+MgoOQl6R4UStrWgw=;
        b=jLwKgKRSCojssX3fFX/7GJlyjrMSQbDjPTFG8CGHDlFY7WePGVb4tONweRQqZCT5Ya
         s6eimcZrDK99N0zJpCidH7g7wugc6lI4NZab5oixecVGESroNc1RqjHjRQKqwAYSLRbY
         mTV6xqaFush4v6u8Eu9V3Ri0UKOPIHGUUVFzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8t6EOdK7NPdMy+YK2ByhMHAlbs+MgoOQl6R4UStrWgw=;
        b=wy/FQuWtFt021hRZkFnR474OsOllFHNYmBn2N1x0pkh9DxMKmU+f1PX4FDSjC28Wwl
         35kYbw9yt7Ous5rfiVBUdZYE2woJeU9EbPZlYJDulJD/g1aVOY7k8wMy00oxS5xTkQhA
         NSR8RBY2Bua0UwLtPaAxjj08U5Tksy7ixcCcBIIW8XooFntvcWqABEqNH1coJ/ga1vkS
         gfoOp1SV+48ufNG+8tgjq4N+IfWlK1DpkBXjNw261cvKJrc1CMExgE3owVo5oLSCpBNP
         yvlcMJJPn/R1JX6G3GXnlffdANx9HOm1eg1iVGT+Vt8agCcbn+VU81RytlzUXl/SyFDq
         B2mg==
X-Gm-Message-State: AOAM5300qgAuTASLt0TMnwYRSwRJryv/Y/BE21PRFNTI6aHatw+NH3cV
        isJAJtL6f7HUuUmskQmu72DZudv0cj0mMXrwI5M2uXYkprxfj+Ey
X-Google-Smtp-Source: ABdhPJz0xKCryNKrH8zY5xCfK14hz5iZTPpyaK5s3JW897i/aq4ZkmlScMnG8r0xze5WK8nAteIGkKpRf/Ze96R2PRU=
X-Received: by 2002:a17:906:3983:: with SMTP id h3mr12700603eje.249.1631891524017;
 Fri, 17 Sep 2021 08:12:04 -0700 (PDT)
MIME-Version: 1.0
From:   Igor Raits <igor@gooddata.com>
Date:   Fri, 17 Sep 2021 17:11:53 +0200
Message-ID: <CA+9S74g1aHB1WUkzYRDXggs-QeHxKCTwwL=uh1UfJZ3yKd0BYQ@mail.gmail.com>
Subject: [ cut here ] without any backtrace
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

We are experiencing some weird kernel panic both on CentOS 8 default
kernel and also on 5.14.1 one (we are yet to test the latest 5.14.x
but I have a feeling that it won't help).

Our setup is quite simple: KVM on a x86_64 server - 5.14.1 kernel on both s=
ides.

After some time, the VM stops responding and in the dmesg there is only:
=E2=80=A6
[14116.119527] weave: port 10(vethwepl8e0f203) entered disabled state
[14116.123641] device vethwepl8e0f203 left promiscuous mode
[14116.124509] weave: port 10(vethwepl8e0f203) entered disabled state
[14134.462172] ------------[ cut here ]------------

No backtrace, no other useful information. VM is inaccessible.

I've dumped the VM's memory with "virsh dump" and was trying to check
what's going on=E2=80=A6 However, it is not really useful as "crash" says t=
hat
"panic task not found".

      KERNEL: /usr/lib/debug/lib/modules/5.14.1-1.gdc.el8.x86_64/vmlinux
    DUMPFILE: stg3-k8s-worker04_int_na_intgdc_com.dump
        CPUS: 6
        DATE: Thu Sep 16 21:51:35 CEST 2021
      UPTIME: 03:55:46
LOAD AVERAGE: 1.58, 1.47, 1.45
       TASKS: 1277
    NODENAME: stg3-k8s-worker04
     RELEASE: 5.14.1-1.gdc.el8.x86_64
     VERSION: #1 SMP Sat Sep 4 09:57:57 CEST 2021
     MACHINE: x86_64  (2992 Mhz)
      MEMORY: 60 GB
       PANIC: ""
         PID: 0
     COMMAND: "swapper/0"
        TASK: ffffffffb7018940  (1 of 6)  [THREAD_INFO: ffffffffb7018940]
         CPU: 0
       STATE: TASK_RUNNING (ACTIVE)
     WARNING: panic task not found

Below I'm pasting "bt -a" output from crash utility, in hope that
somebody could help to figure out what's going on there=E2=80=A6 Sadly I ca=
n't
easily share dump with you as it is 60G big (17G compressed), so just
let me know what other information would be useful for you. Thanks in
advance!

Also apologies for "randomly" choosing lists for this message as I
have absolutely no clue what's going on here. Something about

crash> bt -a
PID: 0      TASK: ffffffffb7018940  CPU: 0   COMMAND: "swapper/0"
    [exception RIP: __pv_queued_spin_lock_slowpath+109]
    RIP: ffffffffb5b434dd  RSP: ffffaf2e00003da8  RFLAGS: 00000046
    RAX: 0000000000000000  RBX: ffff9e5c43c2d0c0  RCX: 0000000000000001
    RDX: 0000000000100003  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff9e5c43cec380   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000006  R11: 0000000000125c00  R12: ffffaf2e00003e80
    R13: 0000000000000000  R14: 0000000000000216  R15: ffff9e4e00972000
    CS: 0010  SS: 0018
 #0 [ffffaf2e00003dc8] _raw_spin_lock at ffffffffb644f79a
 #1 [ffffaf2e00003dd0] raw_spin_rq_lock_nested at ffffffffb5b0fdf2
 #2 [ffffaf2e00003de8] load_balance at ffffffffb5b283d4
 #3 [ffffaf2e00003ec8] rebalance_domains at ffffffffb5b29294
 #4 [ffffaf2e00003f38] _nohz_idle_balance.constprop.0 at ffffffffb5b2959e
 #5 [ffffaf2e00003f90] __softirqentry_text_start at ffffffffb68000c6
 #6 [ffffaf2e00003fe0] __irq_exit_rcu at ffffffffb5ae1ff1
 #7 [ffffaf2e00003ff0] sysvec_call_function_single at ffffffffb6441932
--- <IRQ stack> ---
 #8 [ffffffffb7003dd8] sysvec_call_function_single at ffffffffb6441932
    RIP: 0000000000000000  RSP: 0000000000000000  RFLAGS: ffffffffb644f190
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: ffffffffb7018940  RDI: 0000000000125c00
    RBP: ffffffffb64418cb   R8: 0000000000000000   R9: 0000000000000000
    R10: ffffffffb6600d62  R11: 0000000000000000  R12: ffffffffb6442742
    R13: 0000000000000000  R14: ffffffffb64424e5  R15: ffffffffb5b70ef5
    ORIG_RAX: 0000000000000400  CS: cde18e44de2  SS: 1048b6f2
bt: WARNING: possibly bogus exception frame

PID: 618904  TASK: ffff9e577f7dbf00  CPU: 1   COMMAND: "java"
    [exception RIP: __pv_queued_spin_lock_slowpath+112]
    RIP: ffffffffb5b434e0  RSP: ffffaf2e0446f960  RFLAGS: 00000046
    RAX: 0000000000000001  RBX: ffff9e5c43c6d0c0  RCX: 0000000000000001
    RDX: 0000000000100003  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff9e5c43cec380   R8: 0000000000000001   R9: 0000000000000000
    R10: 0000000000000006  R11: 0000000000125c00  R12: ffffaf2e0446fa38
    R13: 00000000ffffffff  R14: 0000000000000016  R15: 0000000000000000
    CS: 0010  SS: 0018
 #0 [ffffaf2e0446f980] _raw_spin_lock at ffffffffb644f79a
 #1 [ffffaf2e0446f988] raw_spin_rq_lock_nested at ffffffffb5b0fdf2
 #2 [ffffaf2e0446f9a0] load_balance at ffffffffb5b283d4
 #3 [ffffaf2e0446fa80] newidle_balance at ffffffffb5b28aad
 #4 [ffffaf2e0446fae0] pick_next_task_fair at ffffffffb5b28c69
 #5 [ffffaf2e0446fb18] pick_next_task at ffffffffb5b12b0c
 #6 [ffffaf2e0446fb90] __schedule at ffffffffb644a4e7
 #7 [ffffaf2e0446fbe0] schedule at ffffffffb644a944
 #8 [ffffaf2e0446fbf8] schedule_timeout at ffffffffb644e79c
 #9 [ffffaf2e0446fc50] wait_woken at ffffffffb5b336cf
#10 [ffffaf2e0446fc68] sk_wait_data at ffffffffb620791f
#11 [ffffaf2e0446fcc0] tcp_recvmsg_locked at ffffffffb62deb31
#12 [ffffaf2e0446fd50] tcp_recvmsg at ffffffffb62df912
#13 [ffffaf2e0446fdc8] inet6_recvmsg at ffffffffb636918b
#14 [ffffaf2e0446fe00] __sys_recvfrom at ffffffffb6200fe6
#15 [ffffaf2e0446ff30] __x64_sys_recvfrom at ffffffffb6201025
#16 [ffffaf2e0446ff38] do_syscall_64 at ffffffffb643f1b8
#17 [ffffaf2e0446ff50] entry_SYSCALL_64_after_hwframe at ffffffffb660007c
    RIP: 00007fba60377b66  RSP: 00007fba60797860  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 000000000000005f  RCX: 00007fba60377b66
    RDX: 0000000000000004  RSI: 00007fba60797950  RDI: 000000000000005f
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fba60797950
    R13: 0000000000000004  R14: 0000000000000000  R15: 00007fba607aa680
    ORIG_RAX: 000000000000002d  CS: 0033  SS: 002b

PID: 618921  TASK: ffff9e4f2cd00000  CPU: 2   COMMAND: "C2 CompilerThre"
    [exception RIP: __pv_queued_spin_lock_slowpath+109]
    RIP: ffffffffb5b434dd  RSP: ffffaf2e046bfad8  RFLAGS: 00000046
    RAX: 0000000000000002  RBX: ffff9e5c43cad0c0  RCX: 0000000000000001
    RDX: 0000000000100003  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff9e5c43cec380   R8: 0000000000000002   R9: 0000000000000000
    R10: 0000000000000006  R11: 0000000000060900  R12: ffffaf2e046bfbb0
    R13: 00000000ffffffff  R14: 0000000000000016  R15: ffff9e5c43cac380
    CS: 0010  SS: 0018
 #0 [ffffaf2e046bfaf8] _raw_spin_lock at ffffffffb644f79a
 #1 [ffffaf2e046bfb00] raw_spin_rq_lock_nested at ffffffffb5b0fdf2
 #2 [ffffaf2e046bfb18] load_balance at ffffffffb5b283d4
 #3 [ffffaf2e046bfbf8] newidle_balance at ffffffffb5b28aad
 #4 [ffffaf2e046bfc58] pick_next_task_fair at ffffffffb5b28c69
 #5 [ffffaf2e046bfc90] pick_next_task at ffffffffb5b12b0c
 #6 [ffffaf2e046bfd08] __schedule at ffffffffb644a4e7
 #7 [ffffaf2e046bfd58] schedule at ffffffffb644a944
 #8 [ffffaf2e046bfd70] futex_wait_queue_me at ffffffffb5b82463
 #9 [ffffaf2e046bfda0] futex_wait at ffffffffb5b825a9
#10 [ffffaf2e046bfeb8] do_futex at ffffffffb5b853c4
#11 [ffffaf2e046bfec8] __x64_sys_futex at ffffffffb5b85861
#12 [ffffaf2e046bff38] do_syscall_64 at ffffffffb643f1b8
#13 [ffffaf2e046bff50] entry_SYSCALL_64_after_hwframe at ffffffffb660007c
    RIP: 00007fba603746e8  RSP: 00007fba48efda30  RFLAGS: 00000282
    RAX: ffffffffffffffda  RBX: 00007fba5811bc50  RCX: 00007fba603746e8
    RDX: 0000000000000000  RSI: 0000000000000080  RDI: 00007fba5811bc78
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000001
    R10: 00007fba48efda80  R11: 0000000000000282  R12: 00007fba5811bc28
    R13: 00007fba5811bc78  R14: 00007fba48efdb30  R15: 0000000000000002
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 622305  TASK: ffff9e5a1576de80  CPU: 3   COMMAND: "C2 CompilerThre"
    [exception RIP: kvm_wait+55]
    RIP: ffffffffb5a6a927  RSP: ffffaf2e04287880  RFLAGS: 00000046
    RAX: 0000000000000001  RBX: ffff9e5c43ced0c0  RCX: 0000000000000001
    RDX: 0000000000000002  RSI: 0000000000000001  RDI: ffff9e5c43ced0d4
    RBP: ffff9e5c43d2d0c0   R8: 0000000000000003   R9: ffff9e5c43cebd20
    R10: 0000000000000000  R11: 0000000000000000  R12: ffff9e5c43ced0d4
    R13: 0000000000000001  R14: 0000000000000000  R15: 0000000000000001
    CS: 0010  SS: 0000
 #0 [ffffaf2e04287880] pv_wait_node at ffffffffb5b4314d
 #1 [ffffaf2e042878b8] __pv_queued_spin_lock_slowpath at ffffffffb5b435b5
 #2 [ffffaf2e042878e0] _raw_spin_lock at ffffffffb644f79a
 #3 [ffffaf2e042878e8] raw_spin_rq_lock_nested at ffffffffb5b0fdf2
 #4 [ffffaf2e04287900] try_to_wake_up at ffffffffb5b1554d
 #5 [ffffaf2e04287960] __queue_work at ffffffffb5afaad9
 #6 [ffffaf2e042879a8] queue_work_on at ffffffffb5afac70
 #7 [ffffaf2e042879b8] soft_cursor at ffffffffb5fa0874
 #8 [ffffaf2e04287a10] bit_cursor at ffffffffb5fa0433
 #9 [ffffaf2e04287ad8] hide_cursor at ffffffffb6045077
#10 [ffffaf2e04287ae8] vt_console_print at ffffffffb6045eb6
#11 [ffffaf2e04287b50] call_console_drivers.constprop.0 at ffffffffb5b46998
#12 [ffffaf2e04287b78] console_unlock at ffffffffb5b46ff7
#13 [ffffaf2e04287c28] vprintk_emit at ffffffffb5b489f1
#14 [ffffaf2e04287c68] printk at ffffffffb63fe07f
#15 [ffffaf2e04287cc8] __warn_printk at ffffffffb63fa612
#16 [ffffaf2e04287d30] enqueue_task_fair at ffffffffb5b25968
#17 [ffffaf2e04287d90] enqueue_task at ffffffffb5b10ef8
#18 [ffffaf2e04287db8] ttwu_do_activate at ffffffffb5b13e6c
#19 [ffffaf2e04287de0] try_to_wake_up at ffffffffb5b155aa
#20 [ffffaf2e04287e40] hrtimer_wakeup at ffffffffb5b6d9be
#21 [ffffaf2e04287e48] __run_hrtimer at ffffffffb5b6dd39
#22 [ffffaf2e04287e80] __hrtimer_run_queues at ffffffffb5b6deed
#23 [ffffaf2e04287ec0] hrtimer_interrupt at ffffffffb5b6e790
#24 [ffffaf2e04287f20] __sysvec_apic_timer_interrupt at ffffffffb5a5a609
#25 [ffffaf2e04287f38] sysvec_apic_timer_interrupt at ffffffffb6441987
#26 [ffffaf2e04287f50] asm_sysvec_apic_timer_interrupt at ffffffffb6600cc2
    RIP: 00007f0f8496f976  RSP: 00007f0f81aff120  RFLAGS: 00000246
    RAX: 00007f0f5042d7b0  RBX: 0000000000000030  RCX: 0000000000000008
    RDX: 0000000000000100  RSI: 00007f0f5c164f1c  RDI: 0000000032f275e0
    RBP: 00007f0f81aff160   R8: 0000000000000000   R9: 00007f0f5c164ed0
    R10: 0000000000000008  R11: 00007ffc748a4090  R12: 0000000000000000
    R13: 00007f0f50504bd0  R14: 0000000000000040  R15: 00007f0f81aff330
    ORIG_RAX: ffffffffffffffff  CS: 0033  SS: 002b

PID: 49345  TASK: ffff9e505c323f00  CPU: 4   COMMAND: "minio"
    [exception RIP: kvm_wait+55]
    RIP: ffffffffb5a6a927  RSP: ffffaf2e0409baa0  RFLAGS: 00000046
    RAX: 0000000000000003  RBX: 0000000000000001  RCX: 0000000000000008
    RDX: 0000000000000000  RSI: 0000000000000003  RDI: ffff9e5c43cec380
    RBP: ffff9e5c43cec380   R8: ffff9e5c7ffc1d00   R9: 0000000000000000
    R10: ffff9e5c43d2d0c0  R11: 0000000000000001  R12: ffff9e5c43d2d0c0
    R13: 0000000000000100  R14: ffff9e5c7ffc1d00  R15: 0000000000000000
    CS: 0010  SS: 0018
 #0 [ffffaf2e0409baa0] pv_wait_head_or_lock at ffffffffb5b43285
 #1 [ffffaf2e0409bad0] __pv_queued_spin_lock_slowpath at ffffffffb5b43525
 #2 [ffffaf2e0409baf8] _raw_spin_lock at ffffffffb644f79a
 #3 [ffffaf2e0409bb00] raw_spin_rq_lock_nested at ffffffffb5b0fdf2
 #4 [ffffaf2e0409bb18] load_balance at ffffffffb5b283d4
 #5 [ffffaf2e0409bbf8] newidle_balance at ffffffffb5b28aad
 #6 [ffffaf2e0409bc58] pick_next_task_fair at ffffffffb5b28c69
 #7 [ffffaf2e0409bc90] pick_next_task at ffffffffb5b12b0c
 #8 [ffffaf2e0409bd08] __schedule at ffffffffb644a4e7
 #9 [ffffaf2e0409bd58] schedule at ffffffffb644a944
#10 [ffffaf2e0409bd70] futex_wait_queue_me at ffffffffb5b82463
#11 [ffffaf2e0409bda0] futex_wait at ffffffffb5b825a9
#12 [ffffaf2e0409beb8] do_futex at ffffffffb5b853c4
#13 [ffffaf2e0409bec8] __x64_sys_futex at ffffffffb5b85861
#14 [ffffaf2e0409bf38] do_syscall_64 at ffffffffb643f1b8
#15 [ffffaf2e0409bf50] entry_SYSCALL_64_after_hwframe at ffffffffb660007c
    RIP: 00000000004725a3  RSP: 000000c000077e80  RFLAGS: 00000206
    RAX: ffffffffffffffda  RBX: 000000c000068000  RCX: 00000000004725a3
    RDX: 0000000000000000  RSI: 0000000000000080  RDI: 0000000003296bb8
    RBP: 000000c000077ec8   R8: 0000000000000000   R9: 0000000000000000
    R10: 000000c000077eb8  R11: 0000000000000206  R12: 000000000043cb20
    R13: 0000000000000000  R14: 00000000020db914  R15: 0000000000000000
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 106629  TASK: ffff9e5269f9bf00  CPU: 5   COMMAND: "reader#2"
    [exception RIP: kvm_wait+55]
    RIP: ffffffffb5a6a927  RSP: ffffaf2e05397ba8  RFLAGS: 00000046
    RAX: 0000000000000003  RBX: 0000000000000001  RCX: 0000000000000008
    RDX: 0000000000000000  RSI: 0000000000000003  RDI: ffff9e5c43cebd00
    RBP: ffff9e5c43cebd00   R8: ffff9e5c7ffc13c0   R9: 0000000000000000
    R10: ffff9e5c43d6d0c0  R11: 0000000000000001  R12: ffff9e5c43d6d0c0
    R13: 0000000000000100  R14: ffff9e5c7ffc13c0  R15: 0000000000000002
    CS: 0010  SS: 0018
 #0 [ffffaf2e05397ba8] pv_wait_head_or_lock at ffffffffb5b43285
 #1 [ffffaf2e05397bd8] __pv_queued_spin_lock_slowpath at ffffffffb5b43525
 #2 [ffffaf2e05397c00] _raw_spin_lock_irq at ffffffffb644f77b
 #3 [ffffaf2e05397c08] wq_worker_comm at ffffffffb5afd7c9
 #4 [ffffaf2e05397c38] proc_task_name at ffffffffb5df6bc3
 #5 [ffffaf2e05397cb0] do_task_stat at ffffffffb5df7137
 #6 [ffffaf2e05397dc0] proc_single_show at ffffffffb5df07da
 #7 [ffffaf2e05397df0] seq_read_iter at ffffffffb5d7b4ef
 #8 [ffffaf2e05397e48] seq_read at ffffffffb5d7b983
 #9 [ffffaf2e05397ec8] vfs_read at ffffffffb5d4dad5
#10 [ffffaf2e05397f00] ksys_read at ffffffffb5d4e15f
#11 [ffffaf2e05397f38] do_syscall_64 at ffffffffb643f1b8
#12 [ffffaf2e05397f50] entry_SYSCALL_64_after_hwframe at ffffffffb660007c
    RIP: 00007f3c178735d4  RSP: 00007f3c0a7f8b20  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 0000000000000009  RCX: 00007f3c178735d4
    RDX: 0000000000000400  RSI: 00007f3bd4002990  RDI: 0000000000000009
    RBP: 00007f3bd4002990   R8: 0000000000000000   R9: 00007f3bd4011650
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000400
    R13: 00007f3c17b423c0  R14: 0000000000000d68  R15: 00007f3c17b41880
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b
