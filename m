Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14506659B55
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiL3SRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 13:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiL3SRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 13:17:01 -0500
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDFA55F45
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 10:17:00 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2171E72C90B;
        Fri, 30 Dec 2022 21:17:00 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 050D44A5064;
        Fri, 30 Dec 2022 21:17:00 +0300 (MSK)
Date:   Fri, 30 Dec 2022 21:16:59 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Alexander Graf <agraf@csgraf.de>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alexey Shabalin <shaba@basealt.ru>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT
 handler: Success
Message-ID: <20221230181659.obkhfe7g6jn2wkb6@altlinux.org>
References: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
 <13D59483-BE6C-4AB5-AAB8-78B3A03D96E7@csgraf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13D59483-BE6C-4AB5-AAB8-78B3A03D96E7@csgraf.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander,

On Fri, Dec 30, 2022 at 06:44:14PM +0100, Alexander Graf wrote:
> Hi Vitaly,
> 
> This is a kvm kernel bug and should be fixed with the latest stable releases. Which kernel version are you running?

This is on latest v6.0 stable - 6.0.15.

Maybe there could be workaround for such situations? (Or maybe it's
possible to make this error non-fatal?) We use qemu+kvm for testing and
now we cannot test on x86.

Thanks,


> 
> Thanks,
> 
> Alex
> 
> 
> > Am 30.12.2022 um 15:30 schrieb Vitaly Chikunov <vt@altlinux.org>:
> > 
> > ﻿Hi,
> > 
> > QEMU 7.2.0 when run on 32-bit x86 architecture fails with:
> > 
> >  i586$ qemu-system-i386 -enable-kvm
> >  qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT handler: Success
> >  i586$ qemu-system-x86_64 -enable-kvm
> >  qemu-system-x86_64: Could not install MSR_CORE_THREAD_COUNT handler: Success
> > 
> > Minimal reproducer is `qemu-system-i386 -enable-kvm'. And this only
> > happens on x86 (linux32 personality and binaries on x86_64 host):
> > 
> >  i586$ file /usr/bin/qemu-system-i386
> >  /usr/bin/qemu-system-i386: ELF 32-bit LSB pie executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=0ba1d953bcb7a691014255954f060ff404c8df90, for GNU/Linux 3.2.0, stripped
> >  i586$ /usr/bin/qemu-system-i386 --version
> >  QEMU emulator version 7.2.0 (qemu-7.2.0-alt1)
> >  Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> > 
> > Thanks,
> > 
> 
