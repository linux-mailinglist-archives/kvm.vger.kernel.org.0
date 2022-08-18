Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B435990CC
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 01:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243034AbiHRXB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 19:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242629AbiHRXBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 19:01:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710D1CAC50
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:01:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u22so2693087plq.12
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc;
        bh=6F0tHF/oZtPKzXhD+jVdw1jFO81d1wFdaL8SH2xhFCM=;
        b=Jg7kDDyoFvyFkN8yuaa10Cba2/J5uDCEOww8js0kJq1QX6PElsft4GDFqrrnjqxVRE
         h3ADoHa/Ed8N/XNTF4NZpPFQ+qcwh3IMjfeqJ7PQIqhC4fHeVRMWxel+pyRldIgOJ7Yj
         zpJ+R2QZbkqpdzMKpqe5+BMOblTp2eeYDS53ffc/UnvhTS1L5jAhAxJfwXXVoxpD7w6w
         ZlZn1AF70HSUDoWWDAgPYZj3D56JBjTFqkid5KeHFMqNfHJ8YXkPiqaVlwe+YMWgkC1Q
         GfygesNOSmrtUO8VCPBsO6WGLvWjZo1jGnfDSWj5aM/jLL3DlHCbeJ+MfxLNKMTGVPdH
         qOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc;
        bh=6F0tHF/oZtPKzXhD+jVdw1jFO81d1wFdaL8SH2xhFCM=;
        b=hDjbi189KhAe7G8OqBMXSTgJFw3jkvWTBAF3VYpvePdW+ai5CgK/+PQYXDnJXu63td
         T778qGfUVYa0L07uie/31VU0av6ImceUp6EZDK5zxkesrl+hPYtYZbDL8cbSh2u/ekug
         14sRraS+31fOr1rOwuURsY1lIQLOfxp2DhA9/hmhYlBDwQo9NRR2NexE+pk0aKPujAqE
         9T6Yvc9D1w6180ZGBqO69Y6xMp+6fK7r8oU1NVS2WrrftLC3VTPNDPTaZ2FiaGqgMHqq
         Q4FAyAGZjd4E94swHcY0yZBD0mVtpfKFwNJFmdS0WyFq9799VfCa9zcpthHNsw1a2rpv
         4GXg==
X-Gm-Message-State: ACgBeo0I1SPw5Tg9I1tN61AQ1xxcgmtbiV+ijqGrW+jwNjLIIKjz6pJ+
        ndHMKKcZyDjzZaOesA5puBKu0A==
X-Google-Smtp-Source: AA6agR7yRAXYc2k60DD4yr8Vnn8n7IcSqqHcY55G5LMynuepnj72MKFv/FbeFlyJNG46nWrGIgDgPA==
X-Received: by 2002:a17:902:e80d:b0:16e:f7bf:34a7 with SMTP id u13-20020a170902e80d00b0016ef7bf34a7mr4519987plg.112.1660863712125;
        Thu, 18 Aug 2022 16:01:52 -0700 (PDT)
Received: from localhost ([50.221.140.186])
        by smtp.gmail.com with ESMTPSA id pw15-20020a17090b278f00b001efa332d365sm1987115pjb.33.2022.08.18.16.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 16:01:51 -0700 (PDT)
Date:   Thu, 18 Aug 2022 16:01:51 -0700 (PDT)
X-Google-Original-Date: Thu, 18 Aug 2022 16:01:45 PDT (-0700)
Subject:     Re: [PATCH 0/4] misc warning cleanup in arch/risc-v
In-Reply-To: <20220814141237.493457-1-mail@conchuod.ie>
CC:     anup@brainfault.org, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, conor.dooley@microchip.com,
        guoren@kernel.org, vincent.chen@sifive.com,
        xianting.tian@linux.alibaba.com, heiko@sntech.de,
        wangkefeng.wang@huawei.com, tongtiangen@huawei.com,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     mail@conchuod.ie
Message-ID: <mhng-49e49c17-7241-45f8-bea3-17188bd1d0fa@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 14 Aug 2022 07:12:34 PDT (-0700), mail@conchuod.ie wrote:
> From: Conor Dooley <conor.dooley@microchip.com>
>
> Hey all,
> Couple fixes here for most of what's left of the {sparse,} warnings in
> arch/riscv that are still in need of patches. Ben has sent patches
> for the VDSO issue already (although they seem to need rework).
>
> VDSO aside, With this patchset applied, we are left with:
> - cpuinfo_ops missing prototype: this likely needs to go into an
>   asm-generic header & I'll send a separate patch for that.
> - Complaints about an error in mm/init.c:
>   "error inarch/riscv/mm/init.c:819:2: error: "setup_vm() is <trunc>
>   I think this can be ignored.
> - 600+ -Woverride-init warnings for syscall table setup where
>   overriding seems to be the whole point of the macro.
> - Warnings about imported kvm core code.
> - Flexible array member warnings that look like common KVM code
>   patterns
> - An unexpected unlock in kvm_riscv_check_vcpu_requests that was added
>   intentionally:
>   https://lore.kernel.org/all/20220710151105.687193-1-apatel@ventanamicro.com/
>   Is it worth looking into whether that's a false positive or not?
>
> Thanks,
> Conor.
>
> Conor Dooley (4):
>   riscv: kvm: vcpu_timer: fix unused variable warnings
>   riscv: kvm: move extern sbi_ext declarations to a header
>   riscv: signal: fix missing prototype warning
>   riscv: traps: add missing prototype
>
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
>  arch/riscv/include/asm/signal.h       | 12 ++++++++++++
>  arch/riscv/include/asm/thread_info.h  |  2 ++
>  arch/riscv/kernel/signal.c            |  1 +
>  arch/riscv/kernel/traps.c             |  3 ++-
>  arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
>  arch/riscv/kvm/vcpu_timer.c           |  4 ----
>  7 files changed, 30 insertions(+), 16 deletions(-)
>  create mode 100644 arch/riscv/include/asm/signal.h

These generally look good to me.  Anup handles the KVM bits so I'll let 
him chime in there, but

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

on all of them.

Happy to do some sort of shared tag thing, but it looks like these are 
all independent enough that it'd be easier to just split them up.  I've 
put the non-KVM bits over at palmer/riscv-variable_fixes_without_kvm, if 
you guys are all OK splitting this up then I'll go take those onto 
riscv/fixes.  I'll wait a bit for folks to get a chance to look, so it 
won't be for tomorrow morning.

Thanks!
