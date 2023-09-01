Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9963778F977
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 10:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbjIAIDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 04:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjIAIDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 04:03:46 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C2C10D7
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 01:03:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a640c23a62f3a-99df431d4bfso199827766b.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 01:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693555422; x=1694160222; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0PJF2sdOqWMTdhnOy+ah6h0lRpj4+pB07jQ8lCelNXs=;
        b=EEzVjQ5pDzbfnOA8AgoBNam9i9FNWjRed/3Z5oVZR+FYe0fzje+qJGSprCler35Oa5
         zkbNeG2ZbsAUcjwoYqk8f974em0ILaFoqk8TT2/avkCisdY+fKD0yM+AS19HV7i6+ouz
         sCdWnLwYUMvhusYd29ZMczAxCAzh7KApDstCSHeOWPQvWjAcgn8ARyacvLGJh22UrUS8
         T9C+ZadgRzg8C/YGyYxeAI0bdS9QlgoNcWJfE1WjPIhAkczh2IloYGmWEY5sL0zAVCuy
         IkEqSLJJnHNLJQccCF/K8Jjqage3hDjCzZzVGCAVQ2QEq0looiDuszG9FoPq6tiFaVIK
         9Jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693555422; x=1694160222;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0PJF2sdOqWMTdhnOy+ah6h0lRpj4+pB07jQ8lCelNXs=;
        b=WjCnn6M59wzpjo9jUhXkqaj+WOjzC2h7ugHuYfZdeenN44ipInySPFgoSQqKRe4Uj+
         pkjutFz/jIdNPjUe0Mggu7cekqxZfeqPT7A5yJZrFgJSUIyu6v9GNpzhaNEvFknVDov4
         AZlUoSfMzWM00OQwiBjK/yLHVtOotiYIzU2vmmPRO+Ls3/O2BSvl48Hg0k+ovDxxYNOc
         M6EOBuSlL/ge+3nv5R196ljhd0fwiTiEgjWSYGNTwWMYwQakVt+m+GGIHipltuRUEilR
         oRW+YP2xnx2GiUkoiLUhU6PK8MmgxE6xTum2KbX6Cc5e01jYe4BsNrKn8CSjLQxvIV0E
         f8pQ==
X-Gm-Message-State: AOJu0YzqvVgPFyU8syN0fIw8aSgb2du4RAew0CPU+Py7LIgAqSb637ZL
        X5MfoMVIUNGdvyg5lNWwY1uQ4w==
X-Google-Smtp-Source: AGHT+IGymkOKommHWfDqJ3IlTz+5W9APgk0soidXVbcbnmRwhMH15DRV2R3BelGzHFNdLEB4Ag12Pw==
X-Received: by 2002:a17:906:1cf:b0:9a5:a068:5548 with SMTP id 15-20020a17090601cf00b009a5a0685548mr1082864ejj.75.1693555421945;
        Fri, 01 Sep 2023 01:03:41 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id t1-20020a170906268100b00993150e5325sm1685356ejc.60.2023.09.01.01.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 01:03:41 -0700 (PDT)
Date:   Fri, 1 Sep 2023 10:03:40 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.6
Message-ID: <20230901-a316e896c1355315c18dbe41@orel>
References: <CAAhSdy2XiFD1QC+v_UZ5G0TAhmT8uH48=UQdu6=bL=EPWy+2Kg@mail.gmail.com>
 <CABgObfbHSkoavDYqKhhotn0cOFr+x2QRYD4NN9v_55tK4nxQoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbHSkoavDYqKhhotn0cOFr+x2QRYD4NN9v_55tK4nxQoQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 07:28:41PM +0200, Paolo Bonzini wrote:
> On Wed, Aug 23, 2023 at 7:25 PM Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.6:
> > 1) Zba, Zbs, Zicntr, Zicsr, Zifencei, and Zihpm support for Guest/VM
> > 2) Added ONE_REG interface for SATP mode
> > 3) Added ONE_REG interface to enable/disable multiple ISA extensions
> > 4) Improved error codes returned by ONE_REG interfaces
> > 5) Added KVM_GET_REG_LIST ioctl() implementation for KVM RISC-V
> > 6) Added get-reg-list selftest for KVM RISC-V
> >
> > Please pull.
> >
> > Regards,
> > Anup
> >
> > The following changes since commit 52a93d39b17dc7eb98b6aa3edb93943248e03b2f:
> >
> >   Linux 6.5-rc5 (2023-08-06 15:07:51 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.6-1
> >
> > for you to fetch changes up to 477069398ed6e0498ee243e799cb6c68baf6ccb8:
> >
> >   KVM: riscv: selftests: Add get-reg-list test (2023-08-09 12:15:27 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.6
> >
> > - Zba, Zbs, Zicntr, Zicsr, Zifencei, and Zihpm support for Guest/VM
> > - Added ONE_REG interface for SATP mode
> > - Added ONE_REG interface to enable/disable multiple ISA extensions
> > - Improved error codes returned by ONE_REG interfaces
> > - Added KVM_GET_REG_LIST ioctl() implementation for KVM RISC-V
> > - Added get-reg-list selftest for KVM RISC-V
> >
> > ----------------------------------------------------------------
> > Andrew Jones (9):
> >       RISC-V: KVM: Improve vector save/restore errors
> >       RISC-V: KVM: Improve vector save/restore functions
> >       KVM: arm64: selftests: Replace str_with_index with strdup_printf
> >       KVM: arm64: selftests: Drop SVE cap check in print_reg
> >       KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
> >       KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
> >       KVM: arm64: selftests: Delete core_reg_fixup
> >       KVM: arm64: selftests: Split get-reg-list test code
> >       KVM: arm64: selftests: Finish generalizing get-reg-list
> 
> Pulled, thanks, but I'll give a closer look to these patches after
> kicking the long-running tests. It would have been nicer to get an
> Acked-by from either me or Marc or Oliver, but no huge deal.

FWIW, we got a "seems fine" from Marc [1].

https://lore.kernel.org/all/87y1ilpz3m.wl-maz@kernel.org/

Thanks,
drew
