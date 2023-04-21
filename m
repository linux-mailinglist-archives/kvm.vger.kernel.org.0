Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998D6EB23B
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 21:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjDUTYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 15:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbjDUTYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 15:24:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4192126A3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 12:24:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a68f2345c5so22213545ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 12:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682105092; x=1684697092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvkLA+a8YoW/wuOsjaIxJzuPVSb1YjjMK/JpWWUYlMo=;
        b=Z1mYNDZ6AkudtVnrT3n5V/eEIts8OddUDSW9KLn74LxIddwBxxMBvHvXimDOcCpD64
         X6WHStiU+II2uxk73igF03YyRe+mqwSuW6H9Qtdv7u/DWvtDubpnzfk1YriCRr9za8v5
         XC2S0BuPZrz2o6+CZXODj0TbYeG2KwCM2cVe6oSpp9pVUDXxGg9olTtkau7Q+5+NsYc4
         cPFBjLGEPHFWzzeOrmDbwFXicua/PB03j/rs7FblIcXdCvm1JDi0Tcgqxr22anUmw5R3
         tGRsDEZo6/EsKO19A+OOzPNIS7W+AHqe2QZk6VRckV7ELyCwNp6MWsNbX2FhgYUyMfrE
         CxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682105092; x=1684697092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvkLA+a8YoW/wuOsjaIxJzuPVSb1YjjMK/JpWWUYlMo=;
        b=BHBRyFazfl8IitdjEW42/DTfb8Hal1k42U7Scglhx1nl+QlvnP6Mcinf5DJQqyIafW
         wPoajxIizfW5OLpkOKf4T23pKY6LkpYkkkvlENiq14XiCtSqnAVcN+yK3yMcciihb2U3
         gspxGAJsiHiQRft23W4mr2zMTbF9TAeebbL1uUQR9XGCwxWFUS7vyw/6vUxAhErhqqU7
         OIrtk3LJeYXcSRrcp0FPsNdWtRVf7IOapEHZBy3Ppz5fHbOGio/2Cp9smCMv7gYa4DjF
         vQUHAUn3uySx9y94tNMZcBuT0lQeGmmYPMsztyW9dFCbRMtnScBH+LP1Hl5b41PBlo/2
         2ijw==
X-Gm-Message-State: AAQBX9dH+WhyAGR+k6881usI+wzsFJgGzSno1T+611T/9w/TG0MHMjho
        kUfMTlfGrNXP4/AkQT8X0qrlOLH6xjqA4KQNVPB/Ag==
X-Google-Smtp-Source: AKy350bWDl0o884sMlNpmr/NR+NvkEPHrIR9Z4zX48mWh2RO0zn4bHfGQxbBytUzrO9XtFhCP8cwpF/T0JLyArYTY9E=
X-Received: by 2002:a17:903:22c8:b0:1a6:c12d:9036 with SMTP id
 y8-20020a17090322c800b001a6c12d9036mr7907063plg.33.1682105092516; Fri, 21 Apr
 2023 12:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-46-atishp@rivosinc.com>
 <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com>
In-Reply-To: <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Sat, 22 Apr 2023 00:54:41 +0530
Message-ID: <CAHBxVyFhDapAeMQ8quBqWZ10jWSHw1CdE227ciyKQpULHYzffA@mail.gmail.com>
Subject: Re: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap hooks
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 3:46=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 4/19/23 15:17, Atish Patra wrote:
> > The guests running in CoVE must notify the host about its mmio regions
> > so that host can enable mmio emulation.
>
> This one doesn't make a lot of sense to me.
>
> The guest and host must agree about the guest's physical layout up
> front.  In general, the host gets to dictate that layout.  It tells the
> guest, up front, what is present in the guest physical address space.
>

That is passed through DT/ACPI (which will be measured) to the guest.

> This callback appears to say to the host:
>
>         Hey, I (the guest) am treating this guest physical area as MMIO.
>
> But the host and guest have to agree _somewhere_ what the MMIO is used
> for, not just that it is being used as MMIO.
>

Yes. The TSM (TEE Security Manager) which is equivalent to TDX also
needs to be aware
of the MMIO regions so that it can forward the faults accordingly.
Most of the MMIO is emulated in the host (userspace or kernel
emulation if present).
The host is outside the trust boundary of the guest. Thus, guest needs
to make sure the host
only emulates the designated MMIO region. Otherwise, it opens an
attack surface from a malicious host.

All other confidential computing solutions also depend on guest
initiated MMIO as well. AFAIK, the TDX & SEV
relies on #VE like exceptions to invoke that while this patch is
similar to what pkvm does.
This approach lets the enlightened guest control which MMIO regions it
wants the host to emulate.
It can be a subset of the region's host provided the layout. The guest
device filtering solution is based on
this idea as well [1].

[1] https://lore.kernel.org/all/20210930010511.3387967-1-sathyanarayanan.ku=
ppuswamy@linux.intel.com/


>
