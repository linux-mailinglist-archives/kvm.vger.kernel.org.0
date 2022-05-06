Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69251DAE5
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442352AbiEFOq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiEFOqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:46:55 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4290A6AA43
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 07:43:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso6948284wme.5
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WiDxQKnEUh/Ftg98Qas+O/Qiia3OxJs8FJZz2Bh+GLM=;
        b=QND3wVqZiv1XwMWWtENM7IVmfUB0q5Vu3nkxI7akG3jPT7bWFsHnn+RBkzCG+X5d5O
         EiBKR3TH1/DpZy/laiuRk/7pu0e1ugADGrDtEIIomtWDRep8aRe/TXCUgtIougBvZgJL
         y137WUxf/Oop9pE+D0QCIlz3nslqvsErxOAn5AzxFL29UVQ/FkhPvYbYq+rd/vxdircP
         omP2hdeayELilhbMXsXxNo7gvRaNeCkNcYVjkgx466+aYJrQOTHDlllQSGKKi1HWMAsT
         AUjEz5dxZSI3UPv0WXfyDkIxdw0s5HmIoQ+D6oE9xteVSvrVQsdDPign8gzOcBVUsM53
         HW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WiDxQKnEUh/Ftg98Qas+O/Qiia3OxJs8FJZz2Bh+GLM=;
        b=oOM2tso5czB3MXcr8Wouic1+eZh40l/4Heqzby2EzmFEFvaDo/hJOWNVYYnYmmYI9t
         KnqDZteKo1SI28p1AJ0C+Cmv5/GpWgJYXBriMD8gjZeGZOrL0e55vhGIk77cxMC/MAY9
         4a6SJvgLgEJRacEuoT/GKVkI0X+uAmAmmknXfjziHdRYRGmfW9EO8Uc4t9Vj1UrEea7P
         pqQeX13sdUSWIGdcswGofq5G74jYNhOFk/NZjjcv9g1vSEubj4vvCgbtRHR1qMMwhFS8
         jVcmEfnVoNSDwmSOevQZqKIZup3RGatCme10rSSDmXzacMmZkiyqxmNsvLNXg7I3XXNN
         n9Zw==
X-Gm-Message-State: AOAM533YZQYM6smbC2emIZvy8NX/QB4ekvVOHSfHcG3Mdk+d2MnU2hpq
        edMsvEoTul8ZEe9gnr+8bis9M+KOyaNByL7TkSlRrQ==
X-Google-Smtp-Source: ABdhPJz1hEYjvGYVylC+vM3SWmQNa7P5Eo5mqV9MS5aLosuwlv8LHE3FaNRFK82N5hrxdJAadOQuPP3Xg6GZgvxB9+A=
X-Received: by 2002:a05:600c:1d08:b0:394:54ee:c994 with SMTP id
 l8-20020a05600c1d0800b0039454eec994mr3615092wms.137.1651848188655; Fri, 06
 May 2022 07:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220304101023.764631-1-atishp@rivosinc.com> <20220506125450.GB22892@willie-the-truck>
In-Reply-To: <20220506125450.GB22892@willie-the-truck>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 6 May 2022 20:12:57 +0530
Message-ID: <CAAhSdy3Okh8oFZWQYziNNXaxkmF1MsfVYz-nHr=0g4fsYBSbRg@mail.gmail.com>
Subject: Re: [RFC PATCH kvmtool 0/3] Add Sstc extension support
To:     Will Deacon <will@kernel.org>
Cc:     Atish Patra <atishp@rivosinc.com>, julien.thierry.kdev@gmail.com,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 6, 2022 at 6:24 PM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Mar 04, 2022 at 02:10:20AM -0800, Atish Patra wrote:
> > This series adds Sstc extension which was ratified recently.
> >
> > The first two patches adds the ISA extension framework which allows
> > to define and update the DT for any multi-letter ISA extensions.
> >
> > The last patch just enables Sstc extension specifically if the hardware
> > supports it.
> >
> > The series can also be found at
> > https://github.com/atishp04/kvmtool/tree/sstc_v1
> >
> > The kvm & Qemu patches can be found at
> >
> > KVM: https://github.com/atishp04/linux/tree/sstc_v2
> > OpenSBI: https://github.com/atishp04/opensbi/tree/sstc_v1
> > Qemu: https://github.com/atishp04/qemu/tree/sstc_v1
> >
> > [1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
> >
> > Atish Patra (3):
> > riscv: Update the uapi header as per Linux kernel
> > riscv: Append ISA extensions to the device tree
> > riscv: Add Sstc extension support
>
> These look fine to me. What's the status of the kernel-side changes?

The kernel-side of changes will be merged for 5.19 or 5.20.

I will ping you once kernel-side changes are merged.

Thanks,
Anup

>
> Will
