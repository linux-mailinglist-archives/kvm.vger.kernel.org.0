Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5BE680C17
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 12:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjA3Li0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 06:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbjA3LiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:38:25 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F542A9B1
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 03:38:22 -0800 (PST)
Received: from [78.40.148.178] (helo=webmail.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pMSUH-002RNM-2F; Mon, 30 Jan 2023 11:38:13 +0000
MIME-Version: 1.0
Date:   Mon, 30 Jan 2023 11:38:13 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     Alistair Francis <Alistair.Francis@wdc.com>
Cc:     philipp.tomsich@vrull.eu, frank.chang@sifive.com,
        dickon.hood@codethink.co.uk, qemu-riscv@nongnu.org,
        palmer@dabbelt.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        bin.meng@windriver.com
Subject: Re: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
In-Reply-To: <606a3bcc7c7428d2504d2c60055e76255454c558.camel@wdc.com>
References: <20230119143528.1290950-1-lawrence.hunter@codethink.co.uk>
 <380600FF-17AC-4134-85C7-CBDF6E34F0E2@getmailspring.com>
 <ad8d999b4e972aa0ea4a276b3d4d8dc355c2d435.camel@wdc.com>
 <CAAeLtUC5p=k4XiXoZxEA6qnLHpmjnuKT+6WUaskbt=uYB1XjrA@mail.gmail.com>
 <606a3bcc7c7428d2504d2c60055e76255454c558.camel@wdc.com>
Message-ID: <c3e76130725358ade9e87681f3c0233f@codethink.co.uk>
X-Sender: lawrence.hunter@codethink.co.uk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-01-29 22:23, Alistair Francis wrote:
> On Sun, 2023-01-29 at 23:12 +0100, Philipp Tomsich wrote:
>> 
>> 
>> On Sun, 29 Jan 2023 at 23:08, Alistair Francis
>> <Alistair.Francis@wdc.com> wrote:
>> > On Thu, 2023-01-26 at 09:21 +0000, Lawrence Hunter wrote:
>> > > Follow up for add RISC-V vector cryptography extensions
>> > > standardisation
>> > > RFC: we've not received any comments and would like to move this
>> > > series
>> > > towards getting merged. Does anyone have time to review it, and
>> > > should
>> > > we look at resubmitting for merging soon?
>> >
>> > Hello,
>> >
>> > This series never made it to the QEMU list. It looks like it was
>> > never
>> > sent to the general qemu-devel mailing list.
>> >
>> 
>> 
>> This has so far been more than a little painful for our review, as we
>> can't just pull the patches down from patchwork to use our regular
>> test-and-review flow.
>> Should we wait until the resubmission for our review?

We have pushed a branch 'rfc-zvk-19-01-23' with our commits based on a
fairly recent master. Hopefully this will ease the review process.

https://github.com/CodethinkLabs/qemu-ct.git

> 
> Up to you. It won't be merged unless it has been sent to the general
> mailing list, so you can either get a head start or just wait.
> 
>> 
>> Note that the current series is not in-sync with the latest
>> specification.
> 
> It's only an RFC, so for now that's ok as it won't be merged anyway.
> 
> Alistair
> 
>> We'll try to point out the specific deviations (we have a tree that
>> we've been keeping in sync with the changes to the spec since mid-
>> December) in our reviews.
>> 
>> Cheers,
>> Philipp.
>>  
>> > When submitting patches can you please follow the steps here:
>> > https://www.qemu.org/docs/master/devel/submitting-a-patch.html#submitting-your-patches
>> >
>> > It's important that all patches are sent to the qemu-devel mailing
>> > list
>> > (that's actually much more important then the RISC-V mailing list).
>> >
>> > Alistair
>> >
>> > >
>> > > ---------- Forwarded Message ---------
>> > >
>> > > From: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
>> > > Subject: [RFC PATCH 00/39] Add RISC-V cryptography extensions
>> > > standardisation
>> > > Date: Jan 19 2023, at 2:34 pm
>> > > To: qemu-riscv@nongnu.org
>> > > Cc: dickon.hood@codethink.co.uk, frank.chang@sifive.com, Lawrence
>> > > Hunter <lawrence.hunter@codethink.co.uk>
>> > >
>> > >
>> > > > This RFC introduces an implementation for the six instruction
>> > > > sets
>> > > > of the draft RISC-V cryptography extensions standardisation
>> > > > specification. Once the specification has been ratified we will
>> > > > submit
>> > > > these changes as a pull request email to this mailing list.
>> > > > Would
>> > > > this
>> > > > be prefered by instruction group or unified as in this RFC?
>> > > >
>> > > > This patch set implements the instruction sets as per the
>> > > > 20221202
>> > > > version of the specification (1).
>> > > >
>> > > > Work performed by Dickon, Lawrence, Nazar, Kiran, and William
>> > > > from
>> > > > Codethink
>> > > > sponsored by SiFive, and Max Chou from SiFive.
>> > > >
>> > > > 1. https://github.com/riscv/riscv-crypto/releases
>> > > >
>> > > > Dickon Hood (1):
>> > > >  target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
>> > > >    translation and execution support
>> > > >
>> > > > Kiran Ostrolenk (4):
>> > > >  target/riscv: Add vsha2ms.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: add zvksh cpu property
>> > > >  target/riscv: Add vsm3c.vi decoding, translation and execution
>> > > > support
>> > > >  target/riscv: expose zvksh cpu property
>> > > >
>> > > > Lawrence Hunter (16):
>> > > >  target/riscv: Add vclmul.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vclmul.vx decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vclmulh.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vclmulh.vx decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesef.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesef.vs decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesdf.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesdf.vs decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesdm.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesdm.vs decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesz.vs decoding, translation and execution
>> > > > support
>> > > >  target/riscv: Add vsha2c[hl].vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vsm3me.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: add zvkg cpu property
>> > > >  target/riscv: Add vghmac.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: expose zvkg cpu property
>> > > >
>> > > > Max Chou (5):
>> > > >  crypto: Move SM4_SBOXWORD from target/riscv
>> > > >  crypto: Add SM4 constant parameter CK.
>> > > >  target/riscv: Add zvksed cfg property
>> > > >  target/riscv: Add Zvksed support
>> > > >  target/riscv: Expose Zvksed property
>> > > >
>> > > > Nazar Kazakov (10):
>> > > >  target/riscv: add zvkb cpu property
>> > > >  target/riscv: Add vrev8.v decoding, translation and execution
>> > > > support
>> > > >  target/riscv: Add vandn.[vv,vx,vi] decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: expose zvkb cpu property
>> > > >  target/riscv: add zvkns cpu property
>> > > >  target/riscv: Add vaeskf1.vi decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaeskf2.vi decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: expose zvkns cpu property
>> > > >  target/riscv: add zvknh cpu properties
>> > > >  target/riscv: expose zvknh cpu properties
>> > > >
>> > > > William Salmon (3):
>> > > >  target/riscv: Add vbrev8.v decoding, translation and execution
>> > > > support
>> > > >  target/riscv: Add vaesem.vv decoding, translation and
>> > > > execution
>> > > >    support
>> > > >  target/riscv: Add vaesem.vs decoding, translation and
>> > > > execution
>> > > >    support
>> > > >
>> > > > crypto/sm4.c                                 |   10 +
>> > > > include/crypto/sm4.h                         |    8 +
>> > > > include/qemu/bitops.h                        |   32 +
>> > > > target/arm/crypto_helper.c                   |   10 +-
>> > > > target/riscv/cpu.c                           |   15 +
>> > > > target/riscv/cpu.h                           |    7 +
>> > > > target/riscv/crypto_helper.c                 |    1 +
>> > > > target/riscv/helper.h                        |   69 ++
>> > > > target/riscv/insn32.decode                   |   48 +
>> > > > target/riscv/insn_trans/trans_rvzvkb.c.inc   |  164 +++
>> > > > target/riscv/insn_trans/trans_rvzvkg.c.inc   |    8 +
>> > > > target/riscv/insn_trans/trans_rvzvknh.c.inc  |   47 +
>> > > > target/riscv/insn_trans/trans_rvzvkns.c.inc  |  121 +++
>> > > > target/riscv/insn_trans/trans_rvzvksed.c.inc |   38 +
>> > > > target/riscv/insn_trans/trans_rvzvksh.c.inc  |   20 +
>> > > > target/riscv/meson.build                     |    4 +-
>> > > > target/riscv/translate.c                     |    6 +
>> > > > target/riscv/vcrypto_helper.c                | 1013
>> > > > ++++++++++++++++++
>> > > > target/riscv/vector_helper.c                 |  242 +----
>> > > > target/riscv/vector_internals.c              |   63 ++
>> > > > target/riscv/vector_internals.h              |  226 ++++
>> > > > 21 files changed, 1902 insertions(+), 250 deletions(-)
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkns.c.inc
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
>> > > > create mode 100644 target/riscv/vcrypto_helper.c
>> > > > create mode 100644 target/riscv/vector_internals.c
>> > > > create mode 100644 target/riscv/vector_internals.h
>> > > >
>> > > > --
>> > > > 2.39.1
>> > > >
>> > > >
>> > > >
>> >
