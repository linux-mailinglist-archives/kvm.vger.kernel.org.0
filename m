Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB775ADD0C
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 03:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiIFBqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 21:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiIFBqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 21:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9326F65550;
        Mon,  5 Sep 2022 18:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02739B815CE;
        Tue,  6 Sep 2022 01:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924C2C43143;
        Tue,  6 Sep 2022 01:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662428778;
        bh=xs4xCHPpRTSPH1q5xqbVYT0d5Xh7RHhnV/wtT03qh9o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bm0qjyC2t9TwGwEG24yn5DgveTfSTLhfHEAIhHPyWVHs5IujJtgloa9bLyT8PGsAp
         Y2deaM+vuMaSfJUUuZN2olk2QgX7fzARBfTeAxI3+k3ofdvt7yKL8sZS/72uEVa6UP
         mfnVNtMossvMA9z5Eu11si7P1+lWKTHWiTu0WeS8i8QmUdgevP4vCX8I0t93Bz0ZaQ
         UpBBSDjZ2IlRa9BKft/sfJEafi2pHU7RrmdimbnyrGWpORCOweKwcgoyu5acYCGJGX
         otwfmTxF0tCSpmlp3q1lKLTZXTHcA+HvF+A0689X4Lq0bQ81E3KJocAjy1lsZhk6D+
         8iW7KwNrfFFgw==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1278624b7c4so6732248fac.5;
        Mon, 05 Sep 2022 18:46:18 -0700 (PDT)
X-Gm-Message-State: ACgBeo00HcmmJHRcBWJ+kfVoiuZgsgsjUi2rb76fW3V91z6brpOk8l3r
        AwxUJCOH2pYtMMSVozAGlb44DNxgMpWqDuXciKA=
X-Google-Smtp-Source: AA6agR7rQMCHzliXpvc366478Lt3HDQkS0AJxe6688qZr6jFNV0WLHEbuu6BgOf1F0gYkq5AKEjr6QkCE3JufBBZ0vk=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr10373144oab.112.1662428777684; Mon, 05
 Sep 2022 18:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220831175920.2806-1-jszhang@kernel.org> <20220831175920.2806-5-jszhang@kernel.org>
 <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
 <YxWYh5C5swlyobi2@linutronix.de> <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
 <YxW3cZEhEideZon2@linutronix.de>
In-Reply-To: <YxW3cZEhEideZon2@linutronix.de>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 6 Sep 2022 09:46:05 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSuLNxUD=Kdn+3o6Jj_bv+X4pntvUHCsXXD5AgcVjj0pQ@mail.gmail.com>
Message-ID: <CAJF2gTSuLNxUD=Kdn+3o6Jj_bv+X4pntvUHCsXXD5AgcVjj0pQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] riscv: add lazy preempt support
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 5, 2022 at 4:46 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-09-05 16:33:54 [+0800], Guo Ren wrote:
> > > There is "generic" code in the PREEMPT_RT patch doing that. The count=
er
> > > is incremented/ decremented via preempt_lazy_enable()/disable() and o=
ne
> > > of the user is migrate_disable()/enable().
> > > Basically if a task is task_is_realtime() then NEED_RESCHED is set fo=
r
> > > the wakeup. For the remaining states (SCHED_OTHER, =E2=80=A6) NEED_RE=
SCHED_LAZY
> > > is set for the wakeup. This can be delayed if the task is in a "preem=
pt
> > > disable lazy" section (similar to a preempt_disable() section) but a
> > > task_is_realtime() can still be scheduled if needed.
> > Okay, It should be [PATCH RT]. RISC-V would also move to GENERIC_ENTRY
> > [1], so above assembly code would be replaced by generic one, right?
>
> correct.
Maybe TIF_XXX_RESCHED also could be merged into GENERIC_ENTRY, just
like what you've done in syscall.

struct thread_info {
          unsigned long           flags;
          unsigned long           syscall_work;   /* SYSCALL_WORK_ flags */
+        unsigned long           resched_work;   /* RESCHED flags */

Or merge them into one:
struct thread_info {
          unsigned long           flags;
-         unsigned long           syscall_work;   /* SYSCALL_WORK_ flags */
+         unsigned long           ge_flags; /* GENERIC_ENTRY flags */

>
> Sebastian



--=20
Best Regards
 Guo Ren
