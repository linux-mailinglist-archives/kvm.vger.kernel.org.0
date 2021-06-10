Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3AF3A298E
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFJKqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 06:46:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47808 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJKqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 06:46:45 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lrIB6-0001BG-8j
        for kvm@vger.kernel.org; Thu, 10 Jun 2021 10:44:48 +0000
Received: by mail-pl1-f200.google.com with SMTP id x22-20020a1709028216b0290112042155c8so854019pln.14
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 03:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1p0hq197aHAGaW5BKYoNfB/tuVzJPiICYoStJg8y1wo=;
        b=jrVZEaCWIQF2MHszRJK0z4fKuV+OgV6c6OElvCKIDXI8AY0A0KYlZL3ar8nDfAcRb9
         9TkmlFY+O3lHP+BL/JFmOUSuKCqX/Dl/XyoDdLH7pL0zOU/ZNFkgh4lHgJl04h1qgjER
         yV3q3evq0K6YspjZd4hGNTODEQAcIzKIo5jQ0iPpUsk0SyFqhsxwxVDfQZBRNh0bN8w/
         w6ZEysnCEWn+Ce41uz0Lh2b7JfXeKMMaW0RkOzoTHGAQ7JwogfrSvdg7g8auOfKGYMS1
         MENbESNhUf01ZLK+Na81re5EZF/vAl/hOkzONUZS56WtGkp5FHgKAGMThJEROtvBQZVt
         vXlA==
X-Gm-Message-State: AOAM5327Z60ehb43l6OeiY4432abZWZKwYeMuWxcOiuje5rcFVxRnW30
        /UjMBmkHJosESdPrhwLOg57ZbN5qk2K5gNf9HKNwXoVagBBY7S5QxXR91U81PCTGfImbR+jrD8I
        HKBiXmTWw8m9vDRuFUfsbJiEOgje3Jhz0rFJjRWtfoteF
X-Received: by 2002:a17:902:263:b029:110:e758:2748 with SMTP id 90-20020a1709020263b0290110e7582748mr4206726plc.53.1623321886692;
        Thu, 10 Jun 2021 03:44:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLHLkhyk5AxWiCypkqSRARAogHCfU+JEX5CfaUjOdgp86pMp9ES8nKQwCUhoq2oh7Kjtphhh8T1oHQ2u8O4lk=
X-Received: by 2002:a17:902:263:b029:110:e758:2748 with SMTP id
 90-20020a1709020263b0290110e7582748mr4206710plc.53.1623321886291; Thu, 10 Jun
 2021 03:44:46 -0700 (PDT)
MIME-Version: 1.0
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Thu, 10 Jun 2021 18:44:35 +0800
Message-ID: <CAMy_GT_BnuUBjNhNpSP4ZRXCs5vcXcfTM3qxfE=4CkC39_jTpw@mail.gmail.com>
Subject: [kvm-unit-test] Unable to build kvm-unit-test on little-endian
 PowerPC (lswx/lswi invalid when little-endian)
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

We have found an issue while trying to build this test on little-endian PowerPC:
gcc -std=gnu99 -ffreestanding -O2 -msoft-float -mabi=no-altivec
-mno-altivec -I /home/ubuntu/upstream/kvm-unit-tests/lib -I
/home/ubuntu/upstream/kvm-unit-tests/lib/libfdt -I lib -Wa,-mregnames
-g -MMD -MF powerpc/.emulator.d -fno-strict-aliasing -fno-common -Wall
-Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers
-Werror  -fomit-frame-pointer  -fno-stack-protector
-Wno-frame-address   -fno-pic  -no-pie  -Wclobbered
-Wunused-but-set-parameter  -Wmissing-parameter-type
-Wold-style-declaration -Woverride-init -Wmissing-prototypes
-Wstrict-prototypes -mlittle-endian   -c -o powerpc/emulator.o
powerpc/emulator.c
/tmp/ccO2j7oR.s: Assembler messages:
/tmp/ccO2j7oR.s:335: Error: `lswx' invalid when little-endian
/tmp/ccO2j7oR.s:381: Error: `lswx' invalid when little-endian
/tmp/ccO2j7oR.s:403: Error: `lswx' invalid when little-endian
/tmp/ccO2j7oR.s:432: Error: `lswx' invalid when little-endian
/tmp/ccO2j7oR.s:643: Error: `lswi' invalid when little-endian
/tmp/ccO2j7oR.s:669: Error: `lswi' invalid when little-endian
/tmp/ccO2j7oR.s:690: Error: `lswi' invalid when little-endian
make: *** [<builtin>: powerpc/emulator.o] Error 1

A quick search on the Internet [1] indicates this has something to do
with a new version of binutils:
commit 86c0f617ac5f3a5f4aab76c7f90255254ca27576
Author: Alan Modra <amo...@gmail.com>
Date:   Mon Aug 10 15:06:43 2020 +0930

    Error on lmw, lswi and related PowerPC insns when LE
            * config/tc-ppc.c (md_assemble): Error for lmw, stmw, lswi, lswx,
            stswi, or stswx in little-endian mode.
            * testsuite/gas/ppc/476.d,
            * testsuite/gas/ppc/476.s: Delete lmw, stmw, lswi, lswx, stswi,
stswx.
            * testsuite/gas/ppc/a2.d,
            * testsuite/gas/ppc/a2.s: Move lmw, stmw, lswi, lswx, stswi,
stswx..
            * testsuite/gas/ppc/be.d,
            * testsuite/gas/ppc/be.s: ..to here, new big-endian only test.
            * testsuite/gas/ppc/le_error.d,
            * testsuite/gas/ppc/le_error.l: New little-endian test.
            * testsuite/gas/ppc/ppc.exp: Run new tests.

Since this test is not expected to work with little-endian, maybe we
can modify the endianess check in powerpc/emulator.c to skip this test
code snippet?

Thanks
PHLin

[1] https://www.mail-archive.com/kde-bugs-dist@kde.org/msg489085.html
BugLink: https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1931534
