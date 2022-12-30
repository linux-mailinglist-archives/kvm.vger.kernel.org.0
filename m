Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF38D659951
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 15:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiL3OW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 09:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiL3OW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 09:22:26 -0500
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DCCD13F58
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 06:22:24 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 232D772C983;
        Fri, 30 Dec 2022 17:22:23 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 0D4714A46F4;
        Fri, 30 Dec 2022 17:22:23 +0300 (MSK)
Date:   Fri, 30 Dec 2022 17:22:22 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@csgraf.de>
Cc:     Alexey Shabalin <shaba@basealt.ru>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT handler:
 Success
Message-ID: <20221230142222.r3ahbntnlvj7jpc2@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

QEMU 7.2.0 when run on 32-bit x86 architecture fails with:

  i586$ qemu-system-i386 -enable-kvm
  qemu-system-i386: Could not install MSR_CORE_THREAD_COUNT handler: Success
  i586$ qemu-system-x86_64 -enable-kvm
  qemu-system-x86_64: Could not install MSR_CORE_THREAD_COUNT handler: Success

Minimal reproducer is `qemu-system-i386 -enable-kvm'. And this only
happens on x86 (linux32 personality and binaries on x86_64 host):

  i586$ file /usr/bin/qemu-system-i386
  /usr/bin/qemu-system-i386: ELF 32-bit LSB pie executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=0ba1d953bcb7a691014255954f060ff404c8df90, for GNU/Linux 3.2.0, stripped
  i586$ /usr/bin/qemu-system-i386 --version
  QEMU emulator version 7.2.0 (qemu-7.2.0-alt1)
  Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

Thanks,

