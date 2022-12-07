Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D64645511
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 09:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLGIGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 03:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLGIGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 03:06:17 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25089286D7
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 00:06:16 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n3so12594012pfq.10
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 00:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XdquHQi7NeKqSxeiFjUW2fxeM63S3wYNudDJTs5ka/I=;
        b=YnPCekdO7ZQMvJqfjISrBXD80eTFgn3TeTnSB9m7M6/qkkywTQOiSOYVaI3LvG4rjR
         SQ7nP30BxTBvoGvsRkE96FqHrc6c+vOCy0hdIlqpsLK4XTiheIKvr8idt+8cA/wcRr+I
         A6LIcSPv/RjOSIzZdbdqP0lXy5HziiVzaFVTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XdquHQi7NeKqSxeiFjUW2fxeM63S3wYNudDJTs5ka/I=;
        b=CsDYd8I4PkFl11LaODcQfRecvlcU9Pd/Vmui7/6OPVSvx6vAvtK1DjwaHTN+WP2sdt
         6pnjbWXYgC3C8/H5kERZ6DD+cWrRo+2X6wMPKF5eJfYeF4RJ7QBIrzIiTO+GMsOHmElD
         D6/Ik85HQuTLODgr4mT77y2JhSawkj34fXioGbWDcXyfd8DGV01EkTxMIcvie3YRMVWv
         QnS96oArHQ/G7CqHQc+dee12tMX5aTg/kH9dCmR3Fq6RJRbAMI0+tqkWQ4iu6Q/ol91c
         zGQOILhxUFRcohtj3Z5ML/YZf3SRUO5S/E3z8z06zr18dAdngLGzE7FG7zBGCvHUIqTL
         encw==
X-Gm-Message-State: ANoB5plJ+Hp1aEURGUYx9X8Lmh4vgouU2BeKbdST7+aGmZPxTxeLbPs7
        2CF9/NyX/XynyZL6V0qzpUrCQnjE3I0I9OHIMCBA
X-Google-Smtp-Source: AA0mqf5Lro0H1geKEW2uRGz1U6KauRanORdt4Xposn2GDms+sPYKmCK12zz5gK2GHbeiYIDgRl5JzfsE9dMxd38ouvw=
X-Received: by 2002:a62:3841:0:b0:577:22cb:1f16 with SMTP id
 f62-20020a623841000000b0057722cb1f16mr9614270pfa.24.1670400375616; Wed, 07
 Dec 2022 00:06:15 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-9-atishp@rivosinc.com>
 <Y4oxNbQwOldICdnw@google.com>
In-Reply-To: <Y4oxNbQwOldICdnw@google.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 7 Dec 2022 00:06:04 -0800
Message-ID: <CAOnJCU+Eo7do0Rd+S4RBOMYpY+sG8ODqpkqA-Cii92bO-cG5+Q@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 2, 2022 at 9:09 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 18, 2022, Atish Patra wrote:
> > RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> > the virtualization enviornment as well. KVM implementation
> > relies on SBI PMU extension for most of the part while traps
> > & emulates the CSRs read for counter access.
>
> For the benefit of non-RISCV people, the changelog (and documentation?) should
> explain why RISC-V doesn't need to tap into kvm_register_perf_callbacks().

As per my understanding, kvm_register_perf_callbacks is only useful
during event sampling for guests. Please let me know if I missed
something.
This series doesn't support sampling and guest counter overflow
interrupt yet.  That's why kvm_register_perf_callbacks support is
missing.
I will add kvm_register_perf_callbacks in the next revision along with
interrupt support.

> Presumably there's something in the "RISC-V SBI PMU & Sscofpmf ISA extension" spec
> that allows hardware to differentiate between events that are for guest vs. host?

Not directly. The Sscofpmf extension does have privilege mode specific
filtering bits[1] i.e. VSINH and VUINH which will indicate if the
events are specific to guest.
But that is only true if the hypervisor has enabled those bits. As I
said above, RISC-V do need to tap into kvm_register_perf_callbacks as
well.

[1] https://drive.google.com/file/d/171j4jFjIkKdj5LWcExphq4xG_2sihbfd/edit

-- 
Regards,
Atish
