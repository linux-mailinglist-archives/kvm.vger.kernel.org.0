Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF768806
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 13:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfGOLRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 07:17:10 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46373 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbfGOLRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 07:17:10 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so16496934ote.13
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 04:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXa3Ixp0lyTib79hLb+eS/E3mz0+aAEKJsrTvZWNNo4=;
        b=iXRmHb3MwCS2ZFWcAnJWvTPi49kT68Ifh3vni1395E+tAwMyrCqiuRKEBwIgTC+9cn
         BXhSdlrPKPOrbzA2x6L83SU7kLNbIO6QiM745iijYlz6MvWk+0pyCRkePplcXotDrhwM
         17f5lNLmkZO6hAsPgQL2w7gi0fqkUlUotPltn8j9fHNGwRzIT4TaM+eqIhBNjc93mnfQ
         1BjxmY8lQgSgQUJq41x4QQg8GBgC2c7uWGWXpTQ8lq0+RDx7DuSzxao9MUcxTn7El8ku
         Ifhv0QjTq8Z+Sd/NPpnHNJdHd4LbgK4sRBqVeMRbEFsHPuUi8UV1HSnyRvddw5+ovris
         rhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXa3Ixp0lyTib79hLb+eS/E3mz0+aAEKJsrTvZWNNo4=;
        b=GjbXqkF2oSyO2OY09cbc4VjLhX0q0hUEIsmvDrMTNKusN3S4XzbSqwLWxyLLCZThY4
         cuxW18JKfMFsrcvV8CN8Mjz/okB0jrzXdGuXBaU0uK82H57yIQVzHeRcHDbtWIzAoWOS
         o7EG5/zc/o87Mq1fenM3wPB83umEY55ScJBvNo6WiDRfPYbBPVtZs1GRviaqgk4wKRTC
         gjeREOBzamafVqi5pUia6+y1dnhegMH2cX/7oB9eFB8wutvkc4xgorRF5YCmN0z4plK5
         GnKCARetd4s3guSdlZkNNd0PttFPfRr4rYmq4OpxKJI5r0aMkkHhkLPO8q6yPhKTL2DT
         Ww9Q==
X-Gm-Message-State: APjAAAUAYyxA/xCuig5TpmZTAdLpS0dP2MILU9Dwh2d7bpJjy7riTOD3
        tonqWflXy3wQmNcKWYPcvOh+sO86WZ8A3ajjiVm1PQ==
X-Google-Smtp-Source: APXvYqzF+cB18RQlYSXomt3XydDlXqWrsBDR6vQi7C2WcgOZsPLJ4fs1ZOWBxk9XwY5TTyVke0mjPmby1iFNUOv3W6Q=
X-Received: by 2002:a9d:6a0f:: with SMTP id g15mr14607701otn.135.1563189429057;
 Mon, 15 Jul 2019 04:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190712143207.4214-1-quintela@redhat.com> <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
In-Reply-To: <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 15 Jul 2019 12:16:57 +0100
Message-ID: <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019 at 17:33, Peter Maydell <peter.maydell@linaro.org> wrote:
> Still fails on aarch32 host, I'm afraid:
>
> MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
> QTEST_QEMU_BINARY=aarch64-softmmu/qemu-system-aarch64
> QTEST_QEMU_IMG=qemu-img tests/migration-test -m=quick -k --tap <
> /dev/null | ./scripts/tap-driver.pl --test-name="migration-test"
> PASS 1 migration-test /aarch64/migration/deprecated
> PASS 2 migration-test /aarch64/migration/bad_dest
> PASS 3 migration-test /aarch64/migration/fd_proto
> PASS 4 migration-test /aarch64/migration/postcopy/unix
> PASS 5 migration-test /aarch64/migration/postcopy/recovery
> PASS 6 migration-test /aarch64/migration/precopy/unix
> PASS 7 migration-test /aarch64/migration/precopy/tcp
> PASS 8 migration-test /aarch64/migration/xbzrle/unix
> malloc(): memory corruption
> Broken pipe
> qemu-system-aarch64: load of migration failed: Invalid argument
> /home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
> terminate QEMU process but encountered exit status 1
> Aborted
> ERROR - too few tests run (expected 9, got 8)
> /home/peter.maydell/qemu/tests/Makefile.include:899: recipe for target
> 'check-qtest-aarch64' failed

A run with valgrind:

(armhf)pmaydell@mustang-maydell:~/qemu/build/all-a32$
QTEST_QEMU_BINARY='valgrind aarch64-softmmu/qemu-system-aarch64'
tests/migration-test -v -p '/aarch64/migration/multifd/tcp'
/aarch64/migration/multifd/tcp: ==4034== Memcheck, a memory error detector
==4034== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==4034== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==4034== Command: aarch64-softmmu/qemu-system-aarch64 -qtest
unix:/tmp/qtest-4033.sock -qtest-log /dev/null -chardev
socket,path=/tmp/qtest-4033.qmp,id=char0 -mon
chardev=char0,mode=control -machine accel=qtest -display none -machine
virt,accel=kvm:tcg,gic-version=max -name vmsource,debug-threads=on
-cpu max -m 150M -serial file:/tmp/migration-test-mSLr4A/src_serial
-kernel /tmp/migration-test-mSLr4A/bootsect
==4034==
==4040== Memcheck, a memory error detector
==4040== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==4040== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==4040== Command: aarch64-softmmu/qemu-system-aarch64 -qtest
unix:/tmp/qtest-4033.sock -qtest-log /dev/null -chardev
socket,path=/tmp/qtest-4033.qmp,id=char0 -mon
chardev=char0,mode=control -machine accel=qtest -display none -machine
virt,accel=kvm:tcg,gic-version=max -name vmdest,debug-threads=on -cpu
max -m 150M -serial file:/tmp/migration-test-mSLr4A/dest_serial
-kernel /tmp/migration-test-mSLr4A/bootsect -incoming tcp:127.0.0.1:0
==4040==
==4034== Thread 5 multifdsend_0:
==4034== Syscall param sendmsg(msg.msg_iov[0]) points to uninitialised byte(s)
==4034==    at 0x5299F06: __libc_do_syscall (libc-do-syscall.S:47)
==4034==    by 0x5298FCB: sendmsg (sendmsg.c:28)
==4034==    by 0x60135D: qio_channel_socket_writev (channel-socket.c:544)
==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
==4034==    by 0x26BA73: multifd_send_initial_packet (ram.c:711)
==4034==    by 0x26BA73: multifd_send_thread (ram.c:1085)
==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
==4034==    by 0x5290613: start_thread (pthread_create.c:463)
==4034==    by 0x53487FB: ??? (clone.S:73)
==4034==  Address 0x2320048d is on thread 5's stack
==4034==  in frame #5, created by multifd_send_thread (ram.c:1077)
==4034==
==4034== Thread 6 multifdsend_1:
==4034== Invalid write of size 4
==4034==    at 0x26BB7C: multifd_send_fill_packet (ram.c:806)
==4034==    by 0x26BB7C: multifd_send_thread (ram.c:1101)
==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
==4034==    by 0x5290613: start_thread (pthread_create.c:463)
==4034==    by 0x53487FB: ??? (clone.S:73)
==4034==  Address 0x224ed668 is 0 bytes after a block of size 832 alloc'd
==4034==    at 0x4841BC4: calloc (vg_replace_malloc.c:711)
==4034==    by 0x5018269: g_malloc0 (in
/usr/lib/arm-linux-gnueabihf/libglib-2.0.so.0.5600.4)
==4034==
==4034== Invalid write of size 4
==4034==    at 0x26BB82: multifd_send_fill_packet (ram.c:806)
==4034==    by 0x26BB82: multifd_send_thread (ram.c:1101)
==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
==4034==    by 0x5290613: start_thread (pthread_create.c:463)
==4034==    by 0x53487FB: ??? (clone.S:73)
==4034==  Address 0x224ed66c is 4 bytes after a block of size 832 alloc'd
==4034==    at 0x4841BC4: calloc (vg_replace_malloc.c:711)
==4034==    by 0x5018269: g_malloc0 (in
/usr/lib/arm-linux-gnueabihf/libglib-2.0.so.0.5600.4)
==4034==
==4034== Invalid read of size 4
==4034==    at 0x5FF1DA: qio_channel_writev_full (channel.c:86)
==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
==4034==    by 0x26BBD9: multifd_send_thread (ram.c:1111)
==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
==4034==    by 0x5290613: start_thread (pthread_create.c:463)
==4034==    by 0x53487FB: ??? (clone.S:73)
==4034==  Address 0x30 is not stack'd, malloc'd or (recently) free'd
==4034==
==4034==
==4034== Process terminating with default action of signal 11 (SIGSEGV)
==4034==  Access not within mapped region at address 0x30
==4034==    at 0x5FF1DA: qio_channel_writev_full (channel.c:86)
==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
==4034==    by 0x26BBD9: multifd_send_thread (ram.c:1111)
==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
==4034==    by 0x5290613: start_thread (pthread_create.c:463)
==4034==    by 0x53487FB: ??? (clone.S:73)
==4034==  If you believe this happened as a result of a stack
==4034==  overflow in your program's main thread (unlikely but
==4034==  possible), you can try to increase the size of the
==4034==  main thread stack using the --main-stacksize= flag.
==4034==  The main thread stack size used in this run was 8388608.
==4034==
==4034== HEAP SUMMARY:
==4034==     in use at exit: 5,994,911 bytes in 23,588 blocks
==4034==   total heap usage: 87,487 allocs, 63,899 frees, 17,732,188
bytes allocated
==4034==
==4034== LEAK SUMMARY:
==4034==    definitely lost: 56 bytes in 1 blocks
==4034==    indirectly lost: 64 bytes in 2 blocks
==4034==      possibly lost: 1,620 bytes in 26 blocks
==4034==    still reachable: 5,993,171 bytes in 23,559 blocks
==4034==         suppressed: 0 bytes in 0 blocks
==4034== Rerun with --leak-check=full to see details of leaked memory
==4034==
==4034== For counts of detected and suppressed errors, rerun with: -v
==4034== Use --track-origins=yes to see where uninitialised values come from
==4034== ERROR SUMMARY: 66 errors from 4 contexts (suppressed: 6 from 3)
Broken pipe
qemu-system-aarch64: load of migration failed: Input/output error
==4040==
==4040== HEAP SUMMARY:
==4040==     in use at exit: 4,893,269 bytes in 19,702 blocks
==4040==   total heap usage: 86,196 allocs, 66,494 frees, 17,438,183
bytes allocated
==4040==
==4040== LEAK SUMMARY:
==4040==    definitely lost: 0 bytes in 0 blocks
==4040==    indirectly lost: 0 bytes in 0 blocks
==4040==      possibly lost: 1,160 bytes in 5 blocks
==4040==    still reachable: 4,892,109 bytes in 19,697 blocks
==4040==         suppressed: 0 bytes in 0 blocks
==4040== Rerun with --leak-check=full to see details of leaked memory
==4040==
==4040== For counts of detected and suppressed errors, rerun with: -v
==4040== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 6 from 3)
/home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
terminate QEMU process but encountered exit status 1
Aborted

thanks
-- PMM
