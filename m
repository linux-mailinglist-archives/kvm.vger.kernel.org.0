Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224E7687DB4
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjBBMot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjBBMom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:42 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99768E068
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:21 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvD-004Q6t-8c; Thu, 02 Feb 2023 12:42:36 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 00/39] Add RISC-V vector cryptography extensions
Date:   Thu,  2 Feb 2023 12:41:51 +0000
Message-Id: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series introduces an implementation for the six instruction sets
of the draft RISC-V vector cryptography extensions specification.

This patch set implements the instruction sets as per the 20221202
version of the specification (1). We plan to update to the latest spec
once stabilised.

Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink
sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.

For convenience we have created a git repo with our patches on top of a
recent master. https://github.com/CodethinkLabs/qemu-ct

1. https://github.com/riscv/riscv-crypto/releases

Dickon Hood (1):
  target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
    translation and execution support

Kiran Ostrolenk (4):
  target/riscv: Add vsha2ms.vv decoding, translation and execution
    support
  target/riscv: add zvksh cpu property
  target/riscv: Add vsm3c.vi decoding, translation and execution support
  target/riscv: expose zvksh cpu property

Lawrence Hunter (16):
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
  target/riscv: add zvkg cpu property
  target/riscv: Add vghmac.vv decoding, translation and execution
    support
  target/riscv: expose zvkg cpu property

Max Chou (5):
  crypto: Move SM4_SBOXWORD from target/riscv
  crypto: Add SM4 constant parameter CK.
  target/riscv: Add zvksed cfg property
  target/riscv: Add Zvksed support
  target/riscv: Expose Zvksed property

Nazar Kazakov (10):
  target/riscv: add zvkb cpu property
  target/riscv: Add vrev8.v decoding, translation and execution support
  target/riscv: Add vandn.[vv,vx,vi] decoding, translation and execution
    support
  target/riscv: expose zvkb cpu property
  target/riscv: add zvkns cpu property
  target/riscv: Add vaeskf1.vi decoding, translation and execution
    support
  target/riscv: Add vaeskf2.vi decoding, translation and execution
    support
  target/riscv: expose zvkns cpu property
  target/riscv: add zvknh cpu properties
  target/riscv: expose zvknh cpu properties

William Salmon (3):
  target/riscv: Add vbrev8.v decoding, translation and execution support
  target/riscv: Add vaesem.vv decoding, translation and execution
    support
  target/riscv: Add vaesem.vs decoding, translation and execution
    support

 crypto/sm4.c                                 |   10 +
 include/crypto/sm4.h                         |    8 +
 include/qemu/bitops.h                        |   32 +
 target/arm/crypto_helper.c                   |   10 +-
 target/riscv/cpu.c                           |   33 +
 target/riscv/cpu.h                           |    7 +
 target/riscv/crypto_helper.c                 |    1 +
 target/riscv/helper.h                        |   69 ++
 target/riscv/insn32.decode                   |   48 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc   |  162 +++
 target/riscv/insn_trans/trans_rvzvkg.c.inc   |    9 +
 target/riscv/insn_trans/trans_rvzvknh.c.inc  |   47 +
 target/riscv/insn_trans/trans_rvzvkns.c.inc  |  119 ++
 target/riscv/insn_trans/trans_rvzvksed.c.inc |   35 +
 target/riscv/insn_trans/trans_rvzvksh.c.inc  |   20 +
 target/riscv/meson.build                     |    4 +-
 target/riscv/translate.c                     |    6 +
 target/riscv/vcrypto_helper.c                | 1013 ++++++++++++++++++
 target/riscv/vector_helper.c                 |  242 +----
 target/riscv/vector_internals.c              |   63 ++
 target/riscv/vector_internals.h              |  226 ++++
 21 files changed, 1914 insertions(+), 250 deletions(-)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvkns.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
 create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
 create mode 100644 target/riscv/vcrypto_helper.c
 create mode 100644 target/riscv/vector_internals.c
 create mode 100644 target/riscv/vector_internals.h

-- 
2.39.1

