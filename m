Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD40051E003
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441934AbiEFUS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 16:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383046AbiEFUSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 16:18:25 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C239633BA
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:14:41 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2f7d19cac0bso92909197b3.13
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 13:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxH1d9ojLvDDSEEaZCYmfTD8+J/7hhyInfxqdb2JGbA=;
        b=F2IWZz96qIwTLlWpVeGU9Ek0wswV9Tf3eH7PiCLPb5sPzPVPfJo+piZzUhIo2ySt6C
         vXePkPm4u0FP28P3YjphzDg2XD2+1Yfmu8XHAeCddKoSwHe+uDyEWZ445XuI9rDYJ9Ey
         08YPwQFdR40gxcIyjmYHjwLszpfsOyqqliXo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxH1d9ojLvDDSEEaZCYmfTD8+J/7hhyInfxqdb2JGbA=;
        b=XTH62KAUq9sODrJXX+15EY0+Jsa1bzL69edUqgdcdibmB1IziaCn7uumVyPOZkvwRL
         VsjwXhfrXf1wQJy9vUEgn1GzjHXVGaF/1ZOPyJjszhoHrmwqtY3//Wg/jsK4jPB4bQ+z
         P/g9gry7ZPM11unhsn4I1G1gpUfmXoJlBO0S1KmUyd6VXGO/iQpOmnrpdbLt4IHlFg8+
         BD3nH95WLqTgIda7rlA7OfMZq8T3OafL4GRq3o7+twHWvQi6o8Fc0e76i8lZQQ9uMqf6
         T9KOHzBmJEu29OqFiGu9a0p6su7qqAM7yBI8rQhC4GCrHg/pXLf2MeZ6cR7oupn+kDvb
         IVsw==
X-Gm-Message-State: AOAM5315OCp8mijIVQB3O1gVwLOLpPVSIdwWd0mSaM3liJwvcEWbWAWO
        okbdQkOO/5GQ4Wq6/07b/HcRYI3R3/MK3ITtlSGn
X-Google-Smtp-Source: ABdhPJy4UFsfbbzRv1rDToj2HySigmRbKtDpavcWWYxvB+2uOZzlbytZ5U7kHkWSnEMTnBBs03rbCaJqNAhOm/s+rFw=
X-Received: by 2002:a81:a1c9:0:b0:2f7:f0b7:59f5 with SMTP id
 y192-20020a81a1c9000000b002f7f0b759f5mr4223463ywg.478.1651868080404; Fri, 06
 May 2022 13:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220304101023.764631-1-atishp@rivosinc.com> <20220506125450.GB22892@willie-the-truck>
 <CAAhSdy3Okh8oFZWQYziNNXaxkmF1MsfVYz-nHr=0g4fsYBSbRg@mail.gmail.com>
In-Reply-To: <CAAhSdy3Okh8oFZWQYziNNXaxkmF1MsfVYz-nHr=0g4fsYBSbRg@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 6 May 2022 13:14:28 -0700
Message-ID: <CAOnJCUK_mMcV7WKGitD9O4bzcWb5AaWyNZ3PVA3FEYt_M_OAhw@mail.gmail.com>
Subject: Re: [RFC PATCH kvmtool 0/3] Add Sstc extension support
To:     Anup Patel <anup@brainfault.org>
Cc:     Will Deacon <will@kernel.org>, Atish Patra <atishp@rivosinc.com>,
        julien.thierry.kdev@gmail.com, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 6, 2022 at 7:43 AM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, May 6, 2022 at 6:24 PM Will Deacon <will@kernel.org> wrote:
> >
> > On Fri, Mar 04, 2022 at 02:10:20AM -0800, Atish Patra wrote:
> > > This series adds Sstc extension which was ratified recently.
> > >
> > > The first two patches adds the ISA extension framework which allows
> > > to define and update the DT for any multi-letter ISA extensions.
> > >
> > > The last patch just enables Sstc extension specifically if the hardware
> > > supports it.
> > >
> > > The series can also be found at
> > > https://github.com/atishp04/kvmtool/tree/sstc_v1
> > >
> > > The kvm & Qemu patches can be found at
> > >
> > > KVM: https://github.com/atishp04/linux/tree/sstc_v2
> > > OpenSBI: https://github.com/atishp04/opensbi/tree/sstc_v1
> > > Qemu: https://github.com/atishp04/qemu/tree/sstc_v1
> > >
> > > [1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
> > >
> > > Atish Patra (3):
> > > riscv: Update the uapi header as per Linux kernel
> > > riscv: Append ISA extensions to the device tree
> > > riscv: Add Sstc extension support
> >
> > These look fine to me. What's the status of the kernel-side changes?
>
> The kernel-side of changes will be merged for 5.19 or 5.20.
>

I will revise the kernel series soon and rebase the kvmtool changes on
the latest.

> I will ping you once kernel-side changes are merged.
>
> Thanks,
> Anup
>
> >
> > Will



-- 
Regards,
Atish
