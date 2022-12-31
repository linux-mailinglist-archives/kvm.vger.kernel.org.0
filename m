Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5051465A35A
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiLaJ21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 04:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLaJ2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 04:28:24 -0500
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BB685FFB
        for <kvm@vger.kernel.org>; Sat, 31 Dec 2022 01:28:23 -0800 (PST)
Received: from [192.168.106.127] (dynamic-095-117-083-145.95.117.pool.telefonica.de [95.117.83.145])
        by csgraf.de (Postfix) with ESMTPSA id 24C706080317;
        Sat, 31 Dec 2022 10:28:22 +0100 (CET)
Message-ID: <e71675a2-e95d-8190-a9ee-32f02b96c60c@csgraf.de>
Date:   Sat, 31 Dec 2022 10:28:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT
 handler: Success
Content-Language: en-US
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alexey Shabalin <shaba@basealt.ru>,
        "Dmitry V. Levin" <ldv@altlinux.org>
References: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
 <13D59483-BE6C-4AB5-AAB8-78B3A03D96E7@csgraf.de>
 <20221230181659.obkhfe7g6jn2wkb6@altlinux.org>
From:   Alexander Graf <agraf@csgraf.de>
In-Reply-To: <20221230181659.obkhfe7g6jn2wkb6@altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 30.12.22 19:16, Vitaly Chikunov wrote:
> Alexander,
>
> On Fri, Dec 30, 2022 at 06:44:14PM +0100, Alexander Graf wrote:
>> Hi Vitaly,
>>
>> This is a kvm kernel bug and should be fixed with the latest stable releases. Which kernel version are you running?
> This is on latest v6.0 stable - 6.0.15.
>
> Maybe there could be workaround for such situations? (Or maybe it's
> possible to make this error non-fatal?) We use qemu+kvm for testing and
> now we cannot test on x86.

I'm confused what's going wrong for you. I tried to reproduce the issue 
locally, but am unable to:

$ uname -a
Linux server 6.0.15-default #1 SMP PREEMPT_DYNAMIC Sat Dec 31 07:52:52 
CET 2022 x86_64 x86_64 x86_64 GNU/Linux
$ linux32 chroot .
$ uname -a
Linux server 6.0.15-default #1 SMP PREEMPT_DYNAMIC Sat Dec 31 07:52:52 
CET 2022 i686 GNU/Linux
$ cd qemu
$ file ./build/qemu-system-i386
./build/qemu-system-i386: ELF 32-bit LSB shared object, Intel 80386, 
version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, 
for GNU/Linux 3.2.0, 
BuildID[sha1]=f75e20572be5c604c121de4497397665c168aa4c, with debug_info, 
not stripped
$ ./build/qemu-system-i386 --version
QEMU emulator version 7.2.0 (v7.2.0-dirty)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
$ ./build/qemu-system-i386 -nographic -enable-kvm
SeaBIOS (version rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org)
[...]


Can you please double check whether your host kernel version is 6.0.15? 
Please paste the output of "uname -a".


Alex

