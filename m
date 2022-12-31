Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8654665A378
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 11:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiLaKRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 05:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLaKRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 05:17:52 -0500
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C135025CE
        for <kvm@vger.kernel.org>; Sat, 31 Dec 2022 02:17:49 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id C5CF872C988;
        Sat, 31 Dec 2022 13:17:47 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id A58284A46F4;
        Sat, 31 Dec 2022 13:17:47 +0300 (MSK)
Date:   Sat, 31 Dec 2022 13:17:47 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Alexander Graf <agraf@csgraf.de>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alexey Shabalin <shaba@basealt.ru>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT
 handler: Success
Message-ID: <20221231101747.2skbmx3ipvr6xbx6@altlinux.org>
References: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
 <13D59483-BE6C-4AB5-AAB8-78B3A03D96E7@csgraf.de>
 <20221230181659.obkhfe7g6jn2wkb6@altlinux.org>
 <e71675a2-e95d-8190-a9ee-32f02b96c60c@csgraf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <e71675a2-e95d-8190-a9ee-32f02b96c60c@csgraf.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander,

On Sat, Dec 31, 2022 at 10:28:21AM +0100, Alexander Graf wrote:
> On 30.12.22 19:16, Vitaly Chikunov wrote:
> > On Fri, Dec 30, 2022 at 06:44:14PM +0100, Alexander Graf wrote:
> > > 
> > > This is a kvm kernel bug and should be fixed with the latest stable releases. Which kernel version are you running?
> > This is on latest v6.0 stable - 6.0.15.
> > 
> > Maybe there could be workaround for such situations? (Or maybe it's
> > possible to make this error non-fatal?) We use qemu+kvm for testing and
> > now we cannot test on x86.
> 
> I'm confused what's going wrong for you. I tried to reproduce the issue
> locally, but am unable to:
> 
> $ uname -a
> Linux server 6.0.15-default #1 SMP PREEMPT_DYNAMIC Sat Dec 31 07:52:52 CET
> 2022 x86_64 x86_64 x86_64 GNU/Linux
> $ linux32 chroot .
> $ uname -a
> Linux server 6.0.15-default #1 SMP PREEMPT_DYNAMIC Sat Dec 31 07:52:52 CET
> 2022 i686 GNU/Linux
> $ cd qemu
> $ file ./build/qemu-system-i386
> ./build/qemu-system-i386: ELF 32-bit LSB shared object, Intel 80386, version
> 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux
> 3.2.0, BuildID[sha1]=f75e20572be5c604c121de4497397665c168aa4c, with
> debug_info, not stripped
> $ ./build/qemu-system-i386 --version
> QEMU emulator version 7.2.0 (v7.2.0-dirty)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> $ ./build/qemu-system-i386 -nographic -enable-kvm
> SeaBIOS (version rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org)
> [...]
> 
> 
> Can you please double check whether your host kernel version is 6.0.15?
> Please paste the output of "uname -a".

Excuse me, I'm incorrectly reported kernel version I tried to boot instead
of host one. Host kernels are quite old, 5.15.59 and even 5.17.15 --
where failure is occurring.

I just tested on 5.15.85 and there is no failure.

  builder@i586:/.in$ uname -a
  Linux localhost.localdomain 5.15.85-std-def-alt1 #1 SMP Wed Dec 21 21:14:40 UTC 2022 i686 GNU/Linux
  builder@i586:/.in$ qemu-system-i386 -nographic -enable-kvm
  SeaBIOS (version 1.16.1-alt1)

Perhaps, one of solutions it to reboot our build fleet to newer kernels.
[This maybe hard, though, since special builder node image should be
created and reboot shall be coordinated through all systems, in compare,
updating QEMU would be easier since chroot is created on every build].

Thanks for your helpful replies!

Thanks,

> 
> 
> Alex
