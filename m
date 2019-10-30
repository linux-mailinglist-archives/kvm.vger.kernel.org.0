Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11C6EA2D1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 18:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfJ3Rxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 13:53:37 -0400
Received: from mail4.protonmail.ch ([185.70.40.27]:42991 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbfJ3Rxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 13:53:36 -0400
Date:   Wed, 30 Oct 2019 17:53:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1572458014;
        bh=60M7E2g4xJeSCgR1q9JOY6FXDzcayF8Snu7ZJe8noIM=;
        h=Date:To:From:Cc:Reply-To:Subject:Feedback-ID:From;
        b=fPsvUBNw8yXLnCmrZRGj4gVkXh9CGF+ABXJkIsyiRsIUw/W2iaoV7PcqLP6Je0zpR
         LtJj47kqFpvio4EoehRW7NR5ch2QILrLghrU4NmraGMCme2HBVSkFhfBc5aH7ksVtY
         mbyKZbt53Xqy9LhCWUivqgAIvpI2mZn40/bCBHRs=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   Mathieu Tarral <mathieu.tarral@protonmail.com>
Cc:     "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        "patrick.colp@oracle.com" <patrick.colp@oracle.com>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>
Reply-To: Mathieu Tarral <mathieu.tarral@protonmail.com>
Subject: Talk publication - Leveraging KVM as a Debugging Platform
Message-ID: <sl3TLCS0smnynp96Xa7kv5gHsbFIjQ9gzxPC1O5BYVb_QtXi6ZFQNR73zmrWSbicaUlBq54De6vAMkbIg0U2uWxEAUd1Q4-vaxn5mbc8LKE=@protonmail.com>
Feedback-ID: 7ARND6YmrAEqSXE0j3TLm6ZqYiFFaDDEkO_KW8fTUEW0kYwGM1KEsuPxEPVWH5YuEnR43INtqwIKH-usvnxVQQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I wanted to publish a talk that I did last week at hack.lu 2019 conference =
in Luxembourg.

The talk was about showing the new introspection capabilities of KVM, still=
 in development,
and plugging a "smart" GDB stub on top that would understand the guest exec=
ution context.

There are 2 demos:
1. I demonstrate the integration in LibVMI (intercepting CR3, memory events=
 and MSR)
2. I demonstrate debugging Microsoft Paint inside a Windows 10 VM, setting =
a breakpoint
   on NtWriteFile in the kernel, and avoid other processes's hits.

Abstract:
https://cfp.hack.lu/hacklu19/talk/MLPXAF/

Slides:
https://drive.google.com/file/d/1nFoCM62BWKSz2TKhNkrOjVwD8gP51VGK/view

Video:
https://www.youtube.com/watch?v=3DU-wDpvItPUU

Project:
https://github.com/Wenzel/pyvmidbg

I thought it might be interesting to share it with the KVM community.

Thanks.

