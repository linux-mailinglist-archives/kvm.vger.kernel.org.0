Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDEE68F81F
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 20:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjBHTcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 14:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjBHTch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 14:32:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF524DE09
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 11:32:35 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so3362295pjb.1
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 11:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tFggisxxgfD6kmx0GPY2F8T8DXDuc4ugX5G1DQKz790=;
        b=dz7JaG0hNVXvYzcvhXAbk1T+EUE1qZy3cCGWOlV+n4RmNFDC0SGgBPgTEb+3QA+kyr
         D7UXIdetzi35/Zia8LMKCIDFm/dSrtf7esOyLGpUYJkE/ZJruT/XYgsc+Ls1BGYa5LZQ
         lH4EaNVq9+gq7kaC79NdtmF2u/HiJ+BQj7+wJZCr9pkifz6qIbXyn/kTY053qfrkJXLv
         A7429ZZHAncVvLEOiTaiQKxf8zQZXVR3umew1Q+PyecSkMSVRBQzh3ZTNQaOU8oZxseG
         ekA+VqDvWZ9RuV/lOG1Ww05HbLVqzD0/pjD63w1tezFegn9WII6LXXeD0b6IyMoNPvHz
         AJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFggisxxgfD6kmx0GPY2F8T8DXDuc4ugX5G1DQKz790=;
        b=FKjMo9Pk16yldMvFoTNCEY/dEPHEf/RqcWdpLwWAiXf4gYGZ7TPUCOgFBaP3ro5mLv
         dJUFeoOKIv97no39y0GZzTMiUWA/oiU9YLv8aG55ZjCcJ5D/tkcD3HyqFt0t+bOkHYcb
         mBOLEnGTqkLjPN++WRg8Mhm8viJ7BIDuLQZGM4bKCkF+bwcaDpdG6sClJ5PxTCm7g0Cn
         S2PnzqHQ7GF+blpZMDfL1zkPZgIBmYV5hev/ABfHyvzYrAWR9eCuv8uctVsDnn2Wf08x
         /9Pq0qhw1AEEEeLMK8lRusoViOhyqEgmaU7bt6OkOFoIEnPmUxbc9LmZxjJQ9jxGkoO7
         Ti1A==
X-Gm-Message-State: AO0yUKWhpwbfVDpBUbQFtyE3kws18Ry94N8OA1pMvopv8k05giBedjka
        3S3K6vsvIgFUPG0wgCdC0zR3iA==
X-Google-Smtp-Source: AK7set/JJINVL2/ghiEyQaUpPNNo6MdeDHsXbSNO6blx6+AIXB6H0p9/e+fP2H0UoOkgZ90xMrE5fw==
X-Received: by 2002:a17:90b:4c8e:b0:230:d4a2:88d3 with SMTP id my14-20020a17090b4c8e00b00230d4a288d3mr9492912pjb.48.1675884754877;
        Wed, 08 Feb 2023 11:32:34 -0800 (PST)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id mv17-20020a17090b199100b00229094aabd0sm1930820pjb.35.2023.02.08.11.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 11:32:34 -0800 (PST)
Date:   Wed, 08 Feb 2023 11:32:34 -0800 (PST)
X-Google-Original-Date: Wed, 08 Feb 2023 11:31:56 PST (-0800)
Subject:     Re: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions standardisation
In-Reply-To: <c3e76130725358ade9e87681f3c0233f@codethink.co.uk>
CC:     Alistair Francis <Alistair.Francis@wdc.com>,
        philipp.tomsich@vrull.eu, frank.chang@sifive.com,
        dickon.hood@codethink.co.uk, qemu-riscv@nongnu.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, bin.meng@windriver.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     lawrence.hunter@codethink.co.uk
Message-ID: <mhng-b8712b20-02a0-477c-a0e8-69269b928dc0@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URI_NOVOWEL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Jan 2023 03:38:13 PST (-0800), lawrence.hunter@codethink.co.uk wrote:
>
>
> On 2023-01-29 22:23, Alistair Francis wrote:
>> On Sun, 2023-01-29 at 23:12 +0100, Philipp Tomsich wrote:
>>>
>>>
>>> On Sun, 29 Jan 2023 at 23:08, Alistair Francis
>>> <Alistair.Francis@wdc.com> wrote:
>>> > On Thu, 2023-01-26 at 09:21 +0000, Lawrence Hunter wrote:
>>> > > Follow up for add RISC-V vector cryptography extensions
>>> > > standardisation
>>> > > RFC: we've not received any comments and would like to move this
>>> > > series
>>> > > towards getting merged. Does anyone have time to review it, and
>>> > > should
>>> > > we look at resubmitting for merging soon?
>>> >
>>> > Hello,
>>> >
>>> > This series never made it to the QEMU list. It looks like it was
>>> > never
>>> > sent to the general qemu-devel mailing list.
>>> >
>>>
>>>
>>> This has so far been more than a little painful for our review, as we
>>> can't just pull the patches down from patchwork to use our regular
>>> test-and-review flow.
>>> Should we wait until the resubmission for our review?
>
> We have pushed a branch 'rfc-zvk-19-01-23' with our commits based on a
> fairly recent master. Hopefully this will ease the review process.
>
> https://github.com/CodethinkLabs/qemu-ct.git

That's frequently helpful too, but the standard practice in QEMU is to 
always CC qemu-devel, even if you're aiming at another list too (like 
qemu-riscv, for example).  It's different than Linux, and IIUC it's 
there to make some of the automation work.

>
>>
>> Up to you. It won't be merged unless it has been sent to the general
>> mailing list, so you can either get a head start or just wait.
>>
>>>
>>> Note that the current series is not in-sync with the latest
>>> specification.
>>
>> It's only an RFC, so for now that's ok as it won't be merged anyway.
>>
>> Alistair
>>
>>> We'll try to point out the specific deviations (we have a tree that
>>> we've been keeping in sync with the changes to the spec since mid-
>>> December) in our reviews.
>>>
>>> Cheers,
>>> Philipp.
>>>  
>>> > When submitting patches can you please follow the steps here:
>>> > https://www.qemu.org/docs/master/devel/submitting-a-patch.html#submitting-your-patches
>>> >
>>> > It's important that all patches are sent to the qemu-devel mailing
>>> > list
>>> > (that's actually much more important then the RISC-V mailing list).
>>> >
>>> > Alistair
>>> >
>>> > >
>>> > > ---------- Forwarded Message ---------
>>> > >
>>> > > From: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
>>> > > Subject: [RFC PATCH 00/39] Add RISC-V cryptography extensions
>>> > > standardisation
>>> > > Date: Jan 19 2023, at 2:34 pm
>>> > > To: qemu-riscv@nongnu.org
>>> > > Cc: dickon.hood@codethink.co.uk, frank.chang@sifive.com, Lawrence
>>> > > Hunter <lawrence.hunter@codethink.co.uk>
>>> > >
>>> > >
>>> > > > This RFC introduces an implementation for the six instruction
>>> > > > sets
>>> > > > of the draft RISC-V cryptography extensions standardisation
>>> > > > specification. Once the specification has been ratified we will
>>> > > > submit
>>> > > > these changes as a pull request email to this mailing list.
>>> > > > Would
>>> > > > this
>>> > > > be prefered by instruction group or unified as in this RFC?
>>> > > >
>>> > > > This patch set implements the instruction sets as per the
>>> > > > 20221202
>>> > > > version of the specification (1).
>>> > > >
>>> > > > Work performed by Dickon, Lawrence, Nazar, Kiran, and William
>>> > > > from
>>> > > > Codethink
>>> > > > sponsored by SiFive, and Max Chou from SiFive.
>>> > > >
>>> > > > 1. https://github.com/riscv/riscv-crypto/releases
>>> > > >
>>> > > > Dickon Hood (1):
>>> > > >  target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
>>> > > >    translation and execution support
>>> > > >
>>> > > > Kiran Ostrolenk (4):
>>> > > >  target/riscv: Add vsha2ms.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: add zvksh cpu property
>>> > > >  target/riscv: Add vsm3c.vi decoding, translation and execution
>>> > > > support
>>> > > >  target/riscv: expose zvksh cpu property
>>> > > >
>>> > > > Lawrence Hunter (16):
>>> > > >  target/riscv: Add vclmul.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vclmul.vx decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vclmulh.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vclmulh.vx decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesef.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesef.vs decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesdf.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesdf.vs decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesdm.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesdm.vs decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesz.vs decoding, translation and execution
>>> > > > support
>>> > > >  target/riscv: Add vsha2c[hl].vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vsm3me.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: add zvkg cpu property
>>> > > >  target/riscv: Add vghmac.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: expose zvkg cpu property
>>> > > >
>>> > > > Max Chou (5):
>>> > > >  crypto: Move SM4_SBOXWORD from target/riscv
>>> > > >  crypto: Add SM4 constant parameter CK.
>>> > > >  target/riscv: Add zvksed cfg property
>>> > > >  target/riscv: Add Zvksed support
>>> > > >  target/riscv: Expose Zvksed property
>>> > > >
>>> > > > Nazar Kazakov (10):
>>> > > >  target/riscv: add zvkb cpu property
>>> > > >  target/riscv: Add vrev8.v decoding, translation and execution
>>> > > > support
>>> > > >  target/riscv: Add vandn.[vv,vx,vi] decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: expose zvkb cpu property
>>> > > >  target/riscv: add zvkns cpu property
>>> > > >  target/riscv: Add vaeskf1.vi decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaeskf2.vi decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: expose zvkns cpu property
>>> > > >  target/riscv: add zvknh cpu properties
>>> > > >  target/riscv: expose zvknh cpu properties
>>> > > >
>>> > > > William Salmon (3):
>>> > > >  target/riscv: Add vbrev8.v decoding, translation and execution
>>> > > > support
>>> > > >  target/riscv: Add vaesem.vv decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >  target/riscv: Add vaesem.vs decoding, translation and
>>> > > > execution
>>> > > >    support
>>> > > >
>>> > > > crypto/sm4.c                                 |   10 +
>>> > > > include/crypto/sm4.h                         |    8 +
>>> > > > include/qemu/bitops.h                        |   32 +
>>> > > > target/arm/crypto_helper.c                   |   10 +-
>>> > > > target/riscv/cpu.c                           |   15 +
>>> > > > target/riscv/cpu.h                           |    7 +
>>> > > > target/riscv/crypto_helper.c                 |    1 +
>>> > > > target/riscv/helper.h                        |   69 ++
>>> > > > target/riscv/insn32.decode                   |   48 +
>>> > > > target/riscv/insn_trans/trans_rvzvkb.c.inc   |  164 +++
>>> > > > target/riscv/insn_trans/trans_rvzvkg.c.inc   |    8 +
>>> > > > target/riscv/insn_trans/trans_rvzvknh.c.inc  |   47 +
>>> > > > target/riscv/insn_trans/trans_rvzvkns.c.inc  |  121 +++
>>> > > > target/riscv/insn_trans/trans_rvzvksed.c.inc |   38 +
>>> > > > target/riscv/insn_trans/trans_rvzvksh.c.inc  |   20 +
>>> > > > target/riscv/meson.build                     |    4 +-
>>> > > > target/riscv/translate.c                     |    6 +
>>> > > > target/riscv/vcrypto_helper.c                | 1013
>>> > > > ++++++++++++++++++
>>> > > > target/riscv/vector_helper.c                 |  242 +----
>>> > > > target/riscv/vector_internals.c              |   63 ++
>>> > > > target/riscv/vector_internals.h              |  226 ++++
>>> > > > 21 files changed, 1902 insertions(+), 250 deletions(-)
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvkns.c.inc
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
>>> > > > create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
>>> > > > create mode 100644 target/riscv/vcrypto_helper.c
>>> > > > create mode 100644 target/riscv/vector_internals.c
>>> > > > create mode 100644 target/riscv/vector_internals.h
>>> > > >
>>> > > > --
>>> > > > 2.39.1
>>> > > >
>>> > > >
>>> > > >
>>> >
