Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC142659B1B
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 18:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiL3Rxs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 30 Dec 2022 12:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiL3Rxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 12:53:47 -0500
X-Greylist: delayed 559 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Dec 2022 09:53:46 PST
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DE8C6401
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 09:53:46 -0800 (PST)
Received: from smtpclient.apple (dynamic-095-117-127-254.95.117.pool.telefonica.de [95.117.127.254])
        by csgraf.de (Postfix) with ESMTPSA id 0CE8760803E4;
        Fri, 30 Dec 2022 18:44:25 +0100 (CET)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Alexander Graf <agraf@csgraf.de>
Mime-Version: 1.0 (1.0)
Subject: Re: qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT handler: Success
Date:   Fri, 30 Dec 2022 18:44:14 +0100
Message-Id: <13D59483-BE6C-4AB5-AAB8-78B3A03D96E7@csgraf.de>
References: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alexey Shabalin <shaba@basealt.ru>,
        "Dmitry V. Levin" <ldv@altlinux.org>
In-Reply-To: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
To:     Vitaly Chikunov <vt@altlinux.org>
X-Mailer: iPhone Mail (20C65)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

This is a kvm kernel bug and should be fixed with the latest stable releases. Which kernel version are you running?

Thanks,

Alex


> Am 30.12.2022 um 15:30 schrieb Vitaly Chikunov <vt@altlinux.org>:
> 
> ﻿Hi,
> 
> QEMU 7.2.0 when run on 32-bit x86 architecture fails with:
> 
>  i586$ qemu-system-i386 -enable-kvm
>  qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT handler: Success
>  i586$ qemu-system-x86_64 -enable-kvm
>  qemu-system-x86_64: Could not install MSR_CORE_THREAD_COUNT handler: Success
> 
> Minimal reproducer is `qemu-system-i386 -enable-kvm'. And this only
> happens on x86 (linux32 personality and binaries on x86_64 host):
> 
>  i586$ file /usr/bin/qemu-system-i386
>  /usr/bin/qemu-system-i386: ELF 32-bit LSB pie executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=0ba1d953bcb7a691014255954f060ff404c8df90, for GNU/Linux 3.2.0, stripped
>  i586$ /usr/bin/qemu-system-i386 --version
>  QEMU emulator version 7.2.0 (qemu-7.2.0-alt1)
>  Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> 
> Thanks,
> 
