Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF46B3A22
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCJJRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjCJJQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:16:49 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDE410A2BD
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:12:46 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYnX-00GpVx-TB; Fri, 10 Mar 2023 09:12:23 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 00/45] Add RISC-V vector cryptographic instruction set support
Date:   Fri, 10 Mar 2023 09:11:30 +0000
Message-Id: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides an implementation for Zvkb, Zvkned, Zvknh, Zvksh, Zvkg, and Zvksed of the draft RISC-V vector cryptography extensions as per the 20230303 version of the specification(1) (1fcbb30). Please note that the Zvkt data-independent execution latency extension has not been implemented, and we would recommend not using these patches in an environment where timing attacks are an issue.

Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.

For convenience we have created a git repo with our patches on top of a recent master. https://github.com/CodethinkLabs/qemu-ct

1. https://github.com/riscv/riscv-crypto/releases


Dickon Hood (2):
  qemu/bitops.h: Limit rotate amounts
  target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
    translation and execution support

Kiran Ostrolenk (8):
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Add vsha2ms.vv decoding, translation and execution
    support
  target/riscv: Add zvksh cpu property
  target/riscv: Add vsm3c.vi decoding, translation and execution support
  target/riscv: Expose zvksh cpu property

Lawrence Hunter (17):
  target/riscv: Add vclmul.vv decoding, translation and execution
    support
  target/riscv: Add vclmul.vx decoding, translation and execution
    support
  target/riscv: Add vclmulh.vv decoding, translation and execution
    support
  target/riscv: Add vclmulh.vx decoding, translation and execution
    support
  target/riscv: Add vaesef.vv decoding, translation and execution
    support
  target/riscv: Add vaesef.vs decoding, translation and execution
    support
  target/riscv: Add vaesdf.vv decoding, translation and execution
    support
  target/riscv: Add vaesdf.vs decoding, translation and execution
    support
  target/riscv: Add vaesdm.vv decoding, translation and execution
    support
  target/riscv: Add vaesdm.vs decoding, translation and execution
    support
  target/riscv: Add vaesz.vs decoding, translation and execution support
  target/riscv: Add vsha2c[hl].vv decoding, translation and execution
    support
  target/riscv: Add vsm3me.vv decoding, translation and execution
    support
  target/riscv: Add zvkg cpu property
  target/riscv: Add vgmul.vv decoding, translation and execution support
  target/riscv: Add vghsh.vv decoding, translation and execution support
  target/riscv: Expose zvkg cpu property

Max Chou (5):
  crypto: Create sm4_subword
  crypto: Add SM4 constant parameter CK
  target/riscv: Add zvksed cfg property
  target/riscv: Add Zvksed support
  target/riscv: Expose Zvksed property

Nazar Kazakov (10):
  target/riscv: Add zvkb cpu property
  target/riscv: Add vrev8.v decoding, translation and execution support
  target/riscv: Add vandn.[vv,vx] decoding, translation and execution
    support
  target/riscv: Expose zvkb cpu property
  target/riscv: Add zvkned cpu property
  target/riscv: Add vaeskf1.vi decoding, translation and execution
    support
  target/riscv: Add vaeskf2.vi decoding, translation and execution
    support
  target/riscv: Expose zvkned cpu property
  target/riscv: Add zvknh cpu properties
  target/riscv: Expose zvknh cpu properties

William Salmon (3):
  target/riscv: Add vbrev8.v decoding, translation and execution support
  target/riscv: Add vaesem.vv decoding, translation and execution
    support
  target/riscv: Add vaesem.vs decoding, translation and execution
    support

 accel/tcg/tcg-runtime-gvec.c                 |   11 +
 accel/tcg/tcg-runtime.h                      |    1 +
 crypto/sm4.c                                 |   10 +
 include/crypto/sm4.h                         |    9 +
 include/qemu/bitops.h                        |   24 +-
 target/arm/tcg/crypto_helper.c               |   10 +-
 target/riscv/cpu.c                           |   36 +
 target/riscv/cpu.h                           |    7 +
 target/riscv/helper.h                        |   71 ++
 target/riscv/insn32.decode                   |   49 +
 target/riscv/insn_trans/trans_rvv.c.inc      |   93 +-
 target/riscv/insn_trans/trans_rvzvkb.c.inc   |  220 ++++
 target/riscv/insn_trans/trans_rvzvkg.c.inc   |   40 +
 target/riscv/insn_trans/trans_rvzvkned.c.inc |  170 +++
 target/riscv/insn_trans/trans_rvzvknh.c.inc  |   84 ++
 target/riscv/insn_trans/trans_rvzvksed.c.inc |   57 +
 target/riscv/insn_trans/trans_rvzvksh.c.inc  |   43 +
 target/riscv/meson.build                     |    4 +-
 target/riscv/op_helper.c                     |    5 +
 target/riscv/translate.c                     |    6 +
 target/riscv/vcrypto_helper.c                | 1001 ++++++++++++++++++
 target/riscv/vector_helper.c                 |  240 +----
 target/riscv/vector_internals.c              |   81 ++
 target/riscv/vector_internals.h              |  222 ++++
 24 files changed, 2192 insertions(+), 302 deletions(-)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvkned.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
 create mode 100644 target/riscv/vcrypto_helper.c
 create mode 100644 target/riscv/vector_internals.c
 create mode 100644 target/riscv/vector_internals.h

-- 
2.39.2

