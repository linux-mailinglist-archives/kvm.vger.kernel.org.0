Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846C159A3B1
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354505AbiHSQzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 12:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354323AbiHSQyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 12:54:13 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F38D183BF
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:15:39 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id x10so4960906ljq.4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tvaOIKhIqDrlMVEW0M57lH2FbWGy6GB7UifbcgzXwMA=;
        b=BWPL5Gwxnd6uvirT5L872kNYJ1/RVqqzVTOuvVl0byaKKDwxiC85rh1yDoAgy+gao5
         3fM/PAfiyWkXCZVyxHqUcfFbmhYPy/yalvQXBwkN6niIQt9NlbZRxmLDaknpSV7WxZes
         6W3rLratY55z6g5aDDOzcW0j5qKK9dzHqN2oGuJv3bQksoxpeK3oULTkk5e+yXmagh9X
         nMs1GVU8IZy7n3jOC3CR2Y3daqHQw0MDKcxNM3x0oSYiUpgXF/Ky55KZBTxEtmW/oDqN
         bjQez5aoT2e/EmPFMBB4vkRrqfUUAc9ie3ITUwuIxLOQ5IYE2RFzLLj4WHvjdfBiYrXQ
         UFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tvaOIKhIqDrlMVEW0M57lH2FbWGy6GB7UifbcgzXwMA=;
        b=PFLmkTerLOryAaNxs+KsAhMRB6kdxvb2XyLyb1TweSaH/zYAR5rq7vAHPS4GmDp/l/
         6d5rIeZT5iBGBREO0ME65e7o13da7L82vEQRc9Eb4223F2ugG/YaOrMiOodtqjR3Ytof
         LDg9PW4XNmga4YY3RlBqE0lity+fsCUSSdP1q8qOzfKm+4y/IP3DO2qdea9RDpDsRyax
         3OOUQkp9K9o0WCgzH+WiZJ5VOjYgl1bwJGmxsK1FI6+T8BXVeTcJR0CpJjVDCdMQZQRo
         PwU9dD3h9lgsZbB5gpaqTW8i14iu2qau5u1lUzpWE8i9NppsNChSLMu3hVYsoVjlXP+q
         uz4g==
X-Gm-Message-State: ACgBeo1heyaMRdoI+px0Qe76e0VIUQCOMsbSRSSt/6xoOH5bcTOiZbP+
        29/hLwOd5jD8fzmGtAZcKeaXc2mXzhdH3n4YuR4HAA==
X-Google-Smtp-Source: AA6agR7ylA+ldzRezYJ/9dHzw0N0PaVrNlEsvgrtMNftGoI69PPeTWIjFPy22UT8Csh8mEMNSX9bxxcZo6h9BeNxHCU=
X-Received: by 2002:a05:651c:b20:b0:25f:e9c7:ac9e with SMTP id
 b32-20020a05651c0b2000b0025fe9c7ac9emr2229509ljr.266.1660925685170; Fri, 19
 Aug 2022 09:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220814141237.493457-1-mail@conchuod.ie> <mhng-49e49c17-7241-45f8-bea3-17188bd1d0fa@palmer-ri-x1c9>
In-Reply-To: <mhng-49e49c17-7241-45f8-bea3-17188bd1d0fa@palmer-ri-x1c9>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 19 Aug 2022 21:44:32 +0530
Message-ID: <CAK9=C2UGJgu0eXHARkvftf+xbqnTaK2k9Jbz_4WVS8PQpgtaWg@mail.gmail.com>
Subject: Re: [PATCH 0/4] misc warning cleanup in arch/risc-v
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     mail@conchuod.ie, anup@brainfault.org, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, conor.dooley@microchip.com,
        guoren@kernel.org, vincent.chen@sifive.com,
        xianting.tian@linux.alibaba.com, heiko@sntech.de,
        wangkefeng.wang@huawei.com, tongtiangen@huawei.com,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Fri, Aug 19, 2022 at 4:32 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Sun, 14 Aug 2022 07:12:34 PDT (-0700), mail@conchuod.ie wrote:
> > From: Conor Dooley <conor.dooley@microchip.com>
> >
> > Hey all,
> > Couple fixes here for most of what's left of the {sparse,} warnings in
> > arch/riscv that are still in need of patches. Ben has sent patches
> > for the VDSO issue already (although they seem to need rework).
> >
> > VDSO aside, With this patchset applied, we are left with:
> > - cpuinfo_ops missing prototype: this likely needs to go into an
> >   asm-generic header & I'll send a separate patch for that.
> > - Complaints about an error in mm/init.c:
> >   "error inarch/riscv/mm/init.c:819:2: error: "setup_vm() is <trunc>
> >   I think this can be ignored.
> > - 600+ -Woverride-init warnings for syscall table setup where
> >   overriding seems to be the whole point of the macro.
> > - Warnings about imported kvm core code.
> > - Flexible array member warnings that look like common KVM code
> >   patterns
> > - An unexpected unlock in kvm_riscv_check_vcpu_requests that was added
> >   intentionally:
> >   https://lore.kernel.org/all/20220710151105.687193-1-apatel@ventanamicro.com/
> >   Is it worth looking into whether that's a false positive or not?
> >
> > Thanks,
> > Conor.
> >
> > Conor Dooley (4):
> >   riscv: kvm: vcpu_timer: fix unused variable warnings
> >   riscv: kvm: move extern sbi_ext declarations to a header
> >   riscv: signal: fix missing prototype warning
> >   riscv: traps: add missing prototype
> >
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
> >  arch/riscv/include/asm/signal.h       | 12 ++++++++++++
> >  arch/riscv/include/asm/thread_info.h  |  2 ++
> >  arch/riscv/kernel/signal.c            |  1 +
> >  arch/riscv/kernel/traps.c             |  3 ++-
> >  arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
> >  arch/riscv/kvm/vcpu_timer.c           |  4 ----
> >  7 files changed, 30 insertions(+), 16 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/signal.h
>
> These generally look good to me.  Anup handles the KVM bits so I'll let
> him chime in there, but
>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>
> on all of them.
>
> Happy to do some sort of shared tag thing, but it looks like these are
> all independent enough that it'd be easier to just split them up.  I've
> put the non-KVM bits over at palmer/riscv-variable_fixes_without_kvm, if
> you guys are all OK splitting this up then I'll go take those onto
> riscv/fixes.  I'll wait a bit for folks to get a chance to look, so it
> won't be for tomorrow morning.

Thanks Palmer. I have queued the KVM fixes (first two patches).

Regards,
Anup

>
> Thanks!
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
