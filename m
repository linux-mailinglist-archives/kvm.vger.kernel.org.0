Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F467C7BE
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 10:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbjAZJtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 04:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjAZJtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 04:49:31 -0500
X-Greylist: delayed 1688 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 01:49:29 PST
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0BB10414
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 01:49:29 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pKyRN-000Kay-RL; Thu, 26 Jan 2023 09:21:06 +0000
Date:   Thu, 26 Jan 2023 09:21:05 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     "=?utf-8?Q?qemu-riscv=40nongnu.org?=" <qemu-riscv@nongnu.org>
Cc:     "=?utf-8?Q?dickon.hood=40codethink.co.uk?=" 
        <dickon.hood@codethink.co.uk>,
        "=?utf-8?Q?frank.chang=40sifive.com?=" <frank.chang@sifive.com>,
        "=?utf-8?Q?palmer=40dabbelt.com?=" <palmer@dabbelt.com>,
        "=?utf-8?Q?alistair.francis=40wdc.com?=" <alistair.francis@wdc.com>,
        "=?utf-8?Q?bin.meng=40windriver.com?=" <bin.meng@windriver.com>,
        "=?utf-8?Q?pbonzini=40redhat.com?=" <pbonzini@redhat.com>,
        "=?utf-8?Q?philipp.tomsich=40vrull.eu?=" <philipp.tomsich@vrull.eu>,
        "=?utf-8?Q?kvm=40vger.kernel.org?=" <kvm@vger.kernel.org>
Message-ID: <380600FF-17AC-4134-85C7-CBDF6E34F0E2@getmailspring.com>
References: <20230119143528.1290950-1-lawrence.hunter@codethink.co.uk>
Subject: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
X-Mailer: Mailspring
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follow up for add RISC-V vector cryptography extensions standardisation
RFC: we've not received any comments and would like to move this series
towards getting merged. Does anyone have time to review it, and should
we look at resubmitting for merging soon?

---------- Forwarded Message ---------

From: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [RFC PATCH 00/39] Add RISC-V cryptography extensions standardisation
Date: Jan 19 2023, at 2:34 pm
To: qemu-riscv@nongnu.org
Cc: dickon.hood@codethink.co.uk, frank.chang@sifive.com, Lawrence Hunter <lawrence.hunter@codethink.co.uk>


> This RFC introduces an implementation for the six instruction sets
> of the draft RISC-V cryptography extensions standardisation
> specification. Once the specification has been ratified we will submit
> these changes as a pull request email to this mailing list. Would this
> be prefered by instruction group or unified as in this RFC?
> 
> This patch set implements the instruction sets as per the 20221202
> version of the specification (1).
> 
> Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink
> sponsored by SiFive, and Max Chou from SiFive.
> 
> 1. https://github.com/riscv/riscv-crypto/releases
> 
> Dickon Hood (1):
>  target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
>    translation and execution support
> 
> Kiran Ostrolenk (4):
>  target/riscv: Add vsha2ms.vv decoding, translation and execution
>    support
>  target/riscv: add zvksh cpu property
>  target/riscv: Add vsm3c.vi decoding, translation and execution support
>  target/riscv: expose zvksh cpu property
> 
> Lawrence Hunter (16):
>  target/riscv: Add vclmul.vv decoding, translation and execution
>    support
>  target/riscv: Add vclmul.vx decoding, translation and execution
>    support
>  target/riscv: Add vclmulh.vv decoding, translation and execution
>    support
>  target/riscv: Add vclmulh.vx decoding, translation and execution
>    support
>  target/riscv: Add vaesef.vv decoding, translation and execution
>    support
>  target/riscv: Add vaesef.vs decoding, translation and execution
>    support
>  target/riscv: Add vaesdf.vv decoding, translation and execution
>    support
>  target/riscv: Add vaesdf.vs decoding, translation and execution
>    support
>  target/riscv: Add vaesdm.vv decoding, translation and execution
>    support
>  target/riscv: Add vaesdm.vs decoding, translation and execution
>    support
>  target/riscv: Add vaesz.vs decoding, translation and execution support
>  target/riscv: Add vsha2c[hl].vv decoding, translation and execution
>    support
>  target/riscv: Add vsm3me.vv decoding, translation and execution
>    support
>  target/riscv: add zvkg cpu property
>  target/riscv: Add vghmac.vv decoding, translation and execution
>    support
>  target/riscv: expose zvkg cpu property
> 
> Max Chou (5):
>  crypto: Move SM4_SBOXWORD from target/riscv
>  crypto: Add SM4 constant parameter CK.
>  target/riscv: Add zvksed cfg property
>  target/riscv: Add Zvksed support
>  target/riscv: Expose Zvksed property
> 
> Nazar Kazakov (10):
>  target/riscv: add zvkb cpu property
>  target/riscv: Add vrev8.v decoding, translation and execution support
>  target/riscv: Add vandn.[vv,vx,vi] decoding, translation and execution
>    support
>  target/riscv: expose zvkb cpu property
>  target/riscv: add zvkns cpu property
>  target/riscv: Add vaeskf1.vi decoding, translation and execution
>    support
>  target/riscv: Add vaeskf2.vi decoding, translation and execution
>    support
>  target/riscv: expose zvkns cpu property
>  target/riscv: add zvknh cpu properties
>  target/riscv: expose zvknh cpu properties
> 
> William Salmon (3):
>  target/riscv: Add vbrev8.v decoding, translation and execution support
>  target/riscv: Add vaesem.vv decoding, translation and execution
>    support
>  target/riscv: Add vaesem.vs decoding, translation and execution
>    support
> 
> crypto/sm4.c                                 |   10 +
> include/crypto/sm4.h                         |    8 +
> include/qemu/bitops.h                        |   32 +
> target/arm/crypto_helper.c                   |   10 +-
> target/riscv/cpu.c                           |   15 +
> target/riscv/cpu.h                           |    7 +
> target/riscv/crypto_helper.c                 |    1 +
> target/riscv/helper.h                        |   69 ++
> target/riscv/insn32.decode                   |   48 +
> target/riscv/insn_trans/trans_rvzvkb.c.inc   |  164 +++
> target/riscv/insn_trans/trans_rvzvkg.c.inc   |    8 +
> target/riscv/insn_trans/trans_rvzvknh.c.inc  |   47 +
> target/riscv/insn_trans/trans_rvzvkns.c.inc  |  121 +++
> target/riscv/insn_trans/trans_rvzvksed.c.inc |   38 +
> target/riscv/insn_trans/trans_rvzvksh.c.inc  |   20 +
> target/riscv/meson.build                     |    4 +-
> target/riscv/translate.c                     |    6 +
> target/riscv/vcrypto_helper.c                | 1013 ++++++++++++++++++
> target/riscv/vector_helper.c                 |  242 +----
> target/riscv/vector_internals.c              |   63 ++
> target/riscv/vector_internals.h              |  226 ++++
> 21 files changed, 1902 insertions(+), 250 deletions(-)
> create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
> create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
> create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
> create mode 100644 target/riscv/insn_trans/trans_rvzvkns.c.inc
> create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
> create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
> create mode 100644 target/riscv/vcrypto_helper.c
> create mode 100644 target/riscv/vector_internals.c
> create mode 100644 target/riscv/vector_internals.h
> 
> -- 
> 2.39.1
> 
> 
> 
