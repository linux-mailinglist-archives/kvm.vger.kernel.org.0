Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3E6E9C51
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 21:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjDTTOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 15:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjDTTOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 15:14:04 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240752711
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 12:14:01 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b60365f53so1815492b3a.0
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 12:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682018040; x=1684610040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiGazBo7fqmmG21SdxdzgEwUnvE1CYshJ5DRTxFcvcU=;
        b=VPpNbcz8lUmn6XqbAF8ZKpyYp3zV26MHR66QP3yKRqpcmVdPoHTXLEyF6Tm6HEp4sd
         I6BqSMDCI5vFX0NE5D1q7CokCl4/RoKvxQk1G13HaFvjs53+GMT1wsINZIEansmPZtBE
         1k8Rd9FGcvKrprRZvlKXZGn5l88bbi1KjmY6066siYhLq8wcQ8X6Jf6SnA5UoPM85uEo
         7diQrnMp6doro6jk8uOyyRDOWi4bDJDokTvU+c4NBYe1TsSjguNSflNmfNIhkY1Df2B0
         kI05B/Wzga0pxbf0UynU69HDnh053SHp7yyj+UPOsBKA2vPkT5VaxUle0IyaTxscv/pO
         Av8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682018040; x=1684610040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiGazBo7fqmmG21SdxdzgEwUnvE1CYshJ5DRTxFcvcU=;
        b=Ylu/DDItrlabl1Qi5y8MZKY3UbB78OBxBb7dtcZrGh66JZsVkZvNy+ramWZMkSmeDE
         OFjxs8A6bYjfn6utYpUz1LUcM1dwE+K1UdNmx82joInPkNCjRK+fakaDtBZ7w1SltR3o
         6Fjr3zxhxwyqMhqPBSk6S3JxzT5njFjQoSUBN2I1mvLKhKx9MnBQuM4TnBIFWYVMp6ep
         cF25qq0IwYgqLWPE1+sbuXii9yhlJ0R7Q6eW0p8hi3TTV2r6UJozU3pIXpzocr6VAx7o
         sRc00LvM6he75yArIeJgS13PfP3oDhOS9qEgDHh4mvtNhTbr92kiXh/8HaQvJqCICE2j
         EPzw==
X-Gm-Message-State: AAQBX9etgLVfHKKOsxa0FLAqmDT1DF3M5NXhvbw9vTZMVinzMCtApESY
        XtPgL+0EIJyq8o0f5fBIzMvno7oy0otpRySQyiLIo8DBrmu5RFlTkom/3WxV
X-Google-Smtp-Source: AKy350aRQ0rM7CLx1DwjTywqrVN0WjdwG2lvnHksOXDIHfuaqZi7DwTJ1XnW9z+QtTwIqGEYzeTP15HNnlsEvUBFY24=
X-Received: by 2002:a17:90a:744c:b0:23f:962e:826b with SMTP id
 o12-20020a17090a744c00b0023f962e826bmr2608127pjk.15.1682018040457; Thu, 20
 Apr 2023 12:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <ZEFopfs5Ij/AIkee@google.com>
In-Reply-To: <ZEFopfs5Ij/AIkee@google.com>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Fri, 21 Apr 2023 00:43:49 +0530
Message-ID: <CAHBxVyE+SkQ-jpbupmJU4fpuiXY_GufnANDBUuO5bMHDsudeYg@mail.gmail.com>
Subject: Re: [RFC 00/48] RISC-V CoVE support
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 10:00=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 19, 2023, Atish Patra wrote:
> > 2. Lazy gstage page allocation vs upfront allocation with page pool.
> > Currently, all gstage mappings happen at runtime during the fault. This=
 is expensive
> > as we need to convert that page to confidential memory as well. A page =
pool framework
> > may be a better choice which can hold all the confidential pages which =
can be
> > pre-allocated upfront. A generic page pool infrastructure may benefit o=
ther CC solutions ?
>
> I'm sorry, what?  Do y'all really not pay any attention to what is happen=
ing
> outside of the RISC-V world?
>
> We, where "we" is KVM x86 and ARM, with folks contributing from 5+ compan=
ines,
> have been working on this problem for going on three *years*.  And that's=
 just
> from the first public posting[1], there have been discussions about how t=
o approach
> this for even longer.  There have been multiple related presentations at =
KVM Forum,
> something like 4 or 5 just at KVM Forum 2022 alone.
>

Yes. We are following the restrictedmem effort and was reviewing the
v10 this week.
I did mention about that in the 1st item in the TODO list. We are
planning to use the restrictedmen
feature once it is closer to upstream (which seems to be the case
looking at v10).
Another reason is that this initial series is based on kvmtool only.
We are working on qemu-kvm
right now but have some RISC-V specific dependencies(interrupt
controller stuff) which are not there yet.
As the restrictedmem patches are already available in qemu-kvm too,
our plan was to support CoVE
in qemu-kvm first and work on restrictedmem after that.

This item was just based on this RFC implementation which uses a lazy
gstage page allocation.
The idea was to check if there is any interest at all in this
approach. I should have mentioned about
restrictedmem plan in this section as well. Sorry for the confusion.

Thanks for your suggestion. It seems we should just directly move to
restrictedmem asap.

> Patch 1 says "This patch is based on pkvm patches", so clearly you are at=
 least
> aware that there is other work going on in this space.
>

Yes. We have been following pkvm, tdx & CCA patches. The MMIO section
has more details
on TDX/pkvm related aspects.

> At a very quick glance, this series is suffers from all of the same flaws=
 that SNP,
> TDX, and pKVM have encountered.  E.g. assuming guest memory is backed by =
struct page
> memory, relying on pinning to solve all problems (hint, it doesn't), and =
so on and
> so forth.
>
> And to make things worse, this series is riddled with bugs.  E.g. patch 1=
9 alone
> manages to squeeze in multiple fatal bugs in five new lines of code: dead=
lock due
> to not releasing mmap_lock on failure, failure to correcty handle MOVE, f=
ailure to

That's an oversight. Apologies for that. Thanks for pointing it out.

> handle DELETE at all, failure to honor (or reject) READONLY, and probably=
 several
> others.
>
It should be rejected for READONLY as our APIs don't have any
permission flags yet.
I think we should add that to enable CoVE APIs to support as well ?

Same goes for DELETE ops as we don't have an API to delete any
confidential memory region
yet. I was not very sure about the use case for MOVE though (migration
possibly ?)

kvm_riscv_cove_vm_add_memreg should have been invoked only for CREATE
& reject others for now.
I will revise the patch accordingly and leave a TODO comment for the
future about API updates.

> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 4b0f09e..63889d9 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -499,6 +499,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>
>         mmap_read_lock(current->mm);
>
> +       if (is_cove_vm(kvm)) {
> +               ret =3D kvm_riscv_cove_vm_add_memreg(kvm, base_gpa, size)=
;
> +               if (ret)
> +                       return ret;
> +       }
>         /*
>          * A memory region could potentially cover multiple VMAs, and
>          * any holes between them, so iterate over all of them to find
>
> I get that this is an RFC, but for a series of this size, operating in an=
 area that
> is under heavy development by multiple other architectures, to have a dif=
fstat that
> shows _zero_ changes to common KVM is simply unacceptable.
>

Thanks for the valuable feedback. This is pretty much pre-RFC as the
spec is very much
in draft state. We want to share with the larger linux community to
gather feedback sooner
than later so that we can incorporate that feedback into the spec if any.

> Please, go look at restrictedmem[2] and work on building CoVE support on =
top of
> that.  If the current proposal doesn't fit CoVE's needs, then we need to =
know _before_
> all of that code gets merged.
>

Absolutely. That has always been the plan.

> [1] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutem=
ov@linux.intel.com
> [2] https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng%40linu=
x.intel.com
>
> > arch/riscv/Kbuild                       |    2 +
> > arch/riscv/Kconfig                      |   27 +
> > arch/riscv/cove/Makefile                |    2 +
> > arch/riscv/cove/core.c                  |   40 +
> > arch/riscv/cove/cove_guest_sbi.c        |  109 +++
> > arch/riscv/include/asm/cove.h           |   27 +
> > arch/riscv/include/asm/covg_sbi.h       |   38 +
> > arch/riscv/include/asm/csr.h            |    2 +
> > arch/riscv/include/asm/kvm_cove.h       |  206 +++++
> > arch/riscv/include/asm/kvm_cove_sbi.h   |  101 +++
> > arch/riscv/include/asm/kvm_host.h       |   10 +-
> > arch/riscv/include/asm/kvm_vcpu_sbi.h   |    3 +
> > arch/riscv/include/asm/mem_encrypt.h    |   26 +
> > arch/riscv/include/asm/sbi.h            |  107 +++
> > arch/riscv/include/uapi/asm/kvm.h       |   17 +
> > arch/riscv/kernel/irq.c                 |   12 +
> > arch/riscv/kernel/setup.c               |    2 +
> > arch/riscv/kvm/Makefile                 |    1 +
> > arch/riscv/kvm/aia.c                    |  101 ++-
> > arch/riscv/kvm/aia_device.c             |   41 +-
> > arch/riscv/kvm/aia_imsic.c              |  127 ++-
> > arch/riscv/kvm/cove.c                   | 1005 +++++++++++++++++++++++
> > arch/riscv/kvm/cove_sbi.c               |  490 +++++++++++
> > arch/riscv/kvm/main.c                   |   30 +-
> > arch/riscv/kvm/mmu.c                    |   45 +-
> > arch/riscv/kvm/tlb.c                    |   11 +-
> > arch/riscv/kvm/vcpu.c                   |   69 +-
> > arch/riscv/kvm/vcpu_exit.c              |   34 +-
> > arch/riscv/kvm/vcpu_insn.c              |  115 ++-
> > arch/riscv/kvm/vcpu_sbi.c               |   16 +
> > arch/riscv/kvm/vcpu_sbi_covg.c          |  232 ++++++
> > arch/riscv/kvm/vcpu_timer.c             |   26 +-
> > arch/riscv/kvm/vm.c                     |   34 +-
> > arch/riscv/kvm/vmid.c                   |   17 +-
> > arch/riscv/mm/Makefile                  |    3 +
> > arch/riscv/mm/init.c                    |   17 +-
> > arch/riscv/mm/ioremap.c                 |   45 +
> > arch/riscv/mm/mem_encrypt.c             |   61 ++
> > drivers/tty/hvc/hvc_riscv_sbi.c         |    5 +
> > drivers/tty/serial/earlycon-riscv-sbi.c |   51 +-
> > include/uapi/linux/kvm.h                |    8 +
> > mm/vmalloc.c                            |   16 +
> > 42 files changed, 3222 insertions(+), 109 deletions(-)
> > create mode 100644 arch/riscv/cove/Makefile
> > create mode 100644 arch/riscv/cove/core.c
> > create mode 100644 arch/riscv/cove/cove_guest_sbi.c
> > create mode 100644 arch/riscv/include/asm/cove.h
> > create mode 100644 arch/riscv/include/asm/covg_sbi.h
> > create mode 100644 arch/riscv/include/asm/kvm_cove.h
> > create mode 100644 arch/riscv/include/asm/kvm_cove_sbi.h
> > create mode 100644 arch/riscv/include/asm/mem_encrypt.h
> > create mode 100644 arch/riscv/kvm/cove.c
> > create mode 100644 arch/riscv/kvm/cove_sbi.c
> > create mode 100644 arch/riscv/kvm/vcpu_sbi_covg.c
> > create mode 100644 arch/riscv/mm/ioremap.c
> > create mode 100644 arch/riscv/mm/mem_encrypt.c
> >
> > --
> > 2.25.1
> >
