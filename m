Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C6148425D
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 14:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiADN1V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Jan 2022 08:27:21 -0500
Received: from gloria.sntech.de ([185.11.138.130]:38836 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbiADN1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 08:27:21 -0500
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1n4jqN-0004e6-TR; Tue, 04 Jan 2022 14:27:15 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Atish Patra <atishp@rivosinc.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v5 1/5] RISC-V: KVM: Mark the existing SBI implementation as v01
Date:   Tue, 04 Jan 2022 14:27:14 +0100
Message-ID: <8323751.1mJVJdxAKN@diego>
In-Reply-To: <6615284.qex3tTltCR@diego>
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-2-atishp@rivosinc.com> <6615284.qex3tTltCR@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Dienstag, 4. Januar 2022, 14:19:41 CET schrieb Heiko Stübner:
> Hi Atish,
> 
> Am Donnerstag, 18. November 2021, 09:39:08 CET schrieb Atish Patra:
> > From: Atish Patra <atish.patra@wdc.com>
> > 
> > The existing SBI specification impelementation follows v0.1
> > specification. The latest specification allows more
> > scalability and performance improvements.
> > 
> > Rename the existing implementation as v01 and provide a way to allow
> > future extensions.
> > 
> > Reviewed-by: Anup Patel <anup.patel@wdc.com>
> > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> 
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index eb3c045edf11..32376906ff20 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -1,5 +1,5 @@
> >  // SPDX-License-Identifier: GPL-2.0
> > -/**
> > +/*
> >   * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> >   *
> >   * Authors:
> 
> This got already fixed by [0]
> commit 0e2e64192100 ("riscv: kvm: fix non-kernel-doc comment block")
> so this patch doesn't apply cleanly anymore.

hmm, just found Anup's "I've queued this..." message after
writing my reply, so scratch the above ;-) .

@Anup: I've looked at git.kernel.org but didn't find a tree
there, can you tell me where this did go to?

Thanks
Heiko


