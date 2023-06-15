Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D717311CD
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbjFOIL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 04:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjFOILZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 04:11:25 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D581AA
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 01:11:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9827109c6e9so198323866b.3
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 01:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1686816682; x=1689408682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jc3bGs7n8LGJfGG9OcFyn2jHuE4ZH06NRDgfF5l5LjU=;
        b=DeLazfIC3InLlnc+CbN7u3tKeBgHiyvNu9e/jNH3WftMrgPB8g8Nm8trECi2KONeGZ
         uf3lWDYbRqTYPo0TVAcyEuFtq7s9eO4TbZ8HkZ0Zo2uvlysLQyGKYZ4tw2gr7KzCTIpj
         SgMSEMZGFaHUpnALuimbilC8pr1x3qSHGxIzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686816682; x=1689408682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jc3bGs7n8LGJfGG9OcFyn2jHuE4ZH06NRDgfF5l5LjU=;
        b=Yi0VTdhkEhCE/UkJ7sUXAcXP0n1MZf1Udd8qEMy+5mUp3OwvgyHwivEYcFTPQKVdxK
         HrR9n4F2EjGSc3d89HeE9fmKdpSev3XUCFXSrccOeBMzO2jyQKL+Qo2TJDIWPCKabKvQ
         ClfZ5xFrn6vrerYfIMd9UfE4CLwblaMiuCvkEpI0V4ImyMybxOB7kWKg5llxvrDJXyOg
         a8KC4IqGJ8bzJ9zCZUCiB3LpTjUP3joiwIvl1EpRZQZVOlbsGx6chEeUlYF6Pa3gUcTZ
         4DzpysKvYwdCBtDKhmchmpWWMTopn82NGhgG1stc+DQviI6M/+HAvOmnEPUFiZQ19XVE
         8kjw==
X-Gm-Message-State: AC+VfDzWzAFPQbHhaObpazQrMBZy9n79h9XBEEdoZ/fDYok/5CSEN+8l
        xxK8UZnsmeNL7o7jI/Rz5pgr9VrkMLJ0iBxC2AM=
X-Google-Smtp-Source: ACHHUZ4bUFGFP77ZcF3kMaZOJhG6wTzBNRglO1RF+tVoIeHKdwBZFicWiHALQYaEk74qIyu3OSniSMlM/E6RZ+LZRhQ=
X-Received: by 2002:a17:906:d553:b0:970:c9f:2db6 with SMTP id
 cr19-20020a170906d55300b009700c9f2db6mr17756450ejc.63.1686816681651; Thu, 15
 Jun 2023 01:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230608075826.86217-1-npiggin@gmail.com> <CACPK8XdpAxjvP+bFNFJzQQzBYvEwsE69QkbNWRumZtUW2wOrrA@mail.gmail.com>
 <CTCW1ILCXTMA.24T7LU9PQBTDA@wheely>
In-Reply-To: <CTCW1ILCXTMA.24T7LU9PQBTDA@wheely>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 15 Jun 2023 08:11:09 +0000
Message-ID: <CACPK8XdOv4j5y6ADrxfvW_iDLLT0UT6Dwb_-J3mTA1Rq9s4xtQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Jun 2023 at 03:02, Nicholas Piggin <npiggin@gmail.com> wrote:
>
> On Wed Jun 14, 2023 at 11:09 AM AEST, Joel Stanley wrote:
> > On Thu, 8 Jun 2023 at 07:58, Nicholas Piggin <npiggin@gmail.com> wrote:
> > >
> > > Posting again, a couple of patches were merged and accounted for review
> > > comments from last time.
> >
> > I saw some failures in the spr tests running on a power9 powernv system:
> >
> > $ TESTNAME=sprs TIMEOUT=90s ACCEL= ./powerpc/run powerpc/sprs.elf -smp
> > 1 |grep FAIL
> > FAIL: WORT      ( 895):    0x00000000c0deba80 <==> 0x0000000000000000
>
> This is just TCG machine? I'm not sure why WORT fails, AFAIKS it's the
> same on POWER8 and doesn't do anything just a simple register. I think
> on real hardware WORT may not have any bits implemented on POWER9
> though.

Yeah, just the TCG machine. Now that you point it out all of the
failures I reported are for ACCEL=<blank>, so they are running in tcg
mode.

run_migration timeout -k 1s --foreground 90s
/usr/bin/qemu-system-ppc64 -nodefaults -machine pseries,accel=tcg
-bios powerpc/boot_rom.bin -display none -serial stdio -kernel
powerpc/sprs.elf -smp 1 -append -w # -initrd /tmp/tmp.61XhbvCGcb


>
> > $ MIGRATION=yes TESTNAME=sprs-migration TIMEOUT=90s ACCEL=
> > ./powerpc/run powerpc/sprs.elf -smp 1 -append '-w' | grep FAIL
> > FAIL: SRR0      (  26):    0xcafefacec0debabc <==> 0x0000000000402244
> > FAIL: SRR1      (  27):    0xc0000006409ebab6 <==> 0x8000000000001001
> > FAIL: CTRL      ( 136):            0x00000000 <==>         0x00008001
> > FAIL: WORT      ( 895):    0x00000000c0deba80 <==> 0x0000000000000000
> > FAIL: PIR       (1023):            0x00000010 <==>         0x00000049
> >
> > Linux 6.2.0-20-generic
> > QEMU emulator version 7.2.0 (Debian 1:7.2+dfsg-5ubuntu2)
> >
> > On a power8 powernv:
> >
> > MIGRATION=yes TESTNAME=sprs-migration TIMEOUT=90s ACCEL= ./powerpc/run
> > powerpc/sprs.elf -smp 1 -append '-w' |grep FAIL
> > FAIL: SRR0      (  26):    0xcafefacec0debabc <==> 0x0000000000402234
> > FAIL: SRR1      (  27):    0xc0000006409ebab6 <==> 0x8000000000001000
> > FAIL: CTRL      ( 136):            0x00000000 <==>         0x00008001
> > FAIL: PIR       (1023):            0x00000060 <==>         0x00000030
>
> Hmm, seems we take some interrupt over migration test that is not
> accounted for (could check the address in SRR0 to see where it is).
> Either need to prevent that interrupt or avoid failing on SRR0/1 on
> this test.
>
> Interesting about CTRL, I wonder if that not migrating correctly.
> PIR looks like a migration issue as well, it can't be changed so
> destination CPU has got a different PIR. I would be inclined to
> leave those as failing to remind us to look into them.
>
> I'll take a look at the others though.
>
> Thanks,
> Nick
