Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54765A1D4D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244506AbiHYXnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244574AbiHYXm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:42:56 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C10B8A62
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:42:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 12so19204906pga.1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc;
        bh=wiEsNvz5ZJJ1GrD/uuku1yQ6cApUWHJmUxRfgwiaX+Y=;
        b=i1J1uRnC8rskyL9RmZ21dnnwmWJhw+hHrY/KBDKpL27AP14d3bPb8RFs+rK0TH1g92
         5jwjQmLP821ACk0zKzFz5mlucx3x9MBDrZ9+Yi8SzR6r+kbN3AzodpFoZT0Wm4CXFfd5
         ea3mRvVUf4dgAoDDu9DnghlOAsVsDMySxyedQZ18gdYZD0qL3vd5UT9MJ6TmorkZ3gJ0
         VY+k1X/269JhAdYE86PXZi2+yJAm6GFE22hjB7eqGwOczwz4E6vbUSqwyYS7rrHrn6Qm
         D2GlE7jkMVRtPng1muRhM4AP8BUtsPaQc3K1pztIHhPAscOG7378ml3G9FUSSshFsbif
         cI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc;
        bh=wiEsNvz5ZJJ1GrD/uuku1yQ6cApUWHJmUxRfgwiaX+Y=;
        b=j1NAArxcmY44Nw1uMj4DiyJ84dzhu5XaF7os/1AOoNCbHcUKqGSQkmGDlfAd8pMs18
         2ptZyigoYkt8/pvYVu28w3opfZzJkGrDzfQHI3AMRryPZyC2pSISvaGSmtLBXkhtOHnV
         bseMnjtuoWeGq2h1iwnnpq/wszchsjTLYBRHJsV8oHYcSD6Ftmgjh+IL0g+ovOpWqNuf
         wSbpBTvkDrJxwAOvwgrVjkJbkoZZykDr2RFzxXkMHY7mV4529fhpskoLWNYWbj4P/ieQ
         idt3TSI3z1PvPtDcLvApQ0yjqGqU6GtRvWbg/19r2w0hA4wbEjwwdVjlEZDJLmuQAXl7
         Komw==
X-Gm-Message-State: ACgBeo3KqdS8T4LKBJqsKQUSv2CGGXX2qnqlCKbEm+z+oXEo5DtkIw+S
        H73o3f3fwA0L69KvKOZOS8pU2A==
X-Google-Smtp-Source: AA6agR6PGWwsGBhmDj/mFX/3PJvX0zBuN/lav09rmNgS9vGADrGEKqTtG0egaYFX5YNXBjBnSU7Wsg==
X-Received: by 2002:a63:eb02:0:b0:429:ee06:825f with SMTP id t2-20020a63eb02000000b00429ee06825fmr1138993pgh.606.1661470974202;
        Thu, 25 Aug 2022 16:42:54 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902aa9100b00172d0c7edf4sm130808plr.106.2022.08.25.16.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:42:53 -0700 (PDT)
Date:   Thu, 25 Aug 2022 16:42:53 -0700 (PDT)
X-Google-Original-Date: Thu, 25 Aug 2022 16:42:52 PDT (-0700)
Subject:     Re: [PATCH 0/4] misc warning cleanup in arch/risc-v
In-Reply-To: <CAK9=C2UGJgu0eXHARkvftf+xbqnTaK2k9Jbz_4WVS8PQpgtaWg@mail.gmail.com>
CC:     mail@conchuod.ie, anup@brainfault.org, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, conor.dooley@microchip.com,
        guoren@kernel.org, vincent.chen@sifive.com,
        xianting.tian@linux.alibaba.com, heiko@sntech.de,
        wangkefeng.wang@huawei.com, tongtiangen@huawei.com,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     apatel@ventanamicro.com
Message-ID: <mhng-45ccfcad-b9d9-4914-8e07-c7a3581ea52b@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Aug 2022 09:14:32 PDT (-0700), apatel@ventanamicro.com wrote:
> On Fri, Aug 19, 2022 at 4:32 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Sun, 14 Aug 2022 07:12:34 PDT (-0700), mail@conchuod.ie wrote:
>> > From: Conor Dooley <conor.dooley@microchip.com>
>> >
>> > Hey all,
>> > Couple fixes here for most of what's left of the {sparse,} warnings in
>> > arch/riscv that are still in need of patches. Ben has sent patches
>> > for the VDSO issue already (although they seem to need rework).
>> >
>> > VDSO aside, With this patchset applied, we are left with:
>> > - cpuinfo_ops missing prototype: this likely needs to go into an
>> >   asm-generic header & I'll send a separate patch for that.
>> > - Complaints about an error in mm/init.c:
>> >   "error inarch/riscv/mm/init.c:819:2: error: "setup_vm() is <trunc>
>> >   I think this can be ignored.
>> > - 600+ -Woverride-init warnings for syscall table setup where
>> >   overriding seems to be the whole point of the macro.
>> > - Warnings about imported kvm core code.
>> > - Flexible array member warnings that look like common KVM code
>> >   patterns
>> > - An unexpected unlock in kvm_riscv_check_vcpu_requests that was added
>> >   intentionally:
>> >   https://lore.kernel.org/all/20220710151105.687193-1-apatel@ventanamicro.com/
>> >   Is it worth looking into whether that's a false positive or not?
>> >
>> > Thanks,
>> > Conor.
>> >
>> > Conor Dooley (4):
>> >   riscv: kvm: vcpu_timer: fix unused variable warnings
>> >   riscv: kvm: move extern sbi_ext declarations to a header
>> >   riscv: signal: fix missing prototype warning
>> >   riscv: traps: add missing prototype
>> >
>> >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
>> >  arch/riscv/include/asm/signal.h       | 12 ++++++++++++
>> >  arch/riscv/include/asm/thread_info.h  |  2 ++
>> >  arch/riscv/kernel/signal.c            |  1 +
>> >  arch/riscv/kernel/traps.c             |  3 ++-
>> >  arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
>> >  arch/riscv/kvm/vcpu_timer.c           |  4 ----
>> >  7 files changed, 30 insertions(+), 16 deletions(-)
>> >  create mode 100644 arch/riscv/include/asm/signal.h
>>
>> These generally look good to me.  Anup handles the KVM bits so I'll let
>> him chime in there, but
>>
>> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>>
>> on all of them.
>>
>> Happy to do some sort of shared tag thing, but it looks like these are
>> all independent enough that it'd be easier to just split them up.  I've
>> put the non-KVM bits over at palmer/riscv-variable_fixes_without_kvm, if
>> you guys are all OK splitting this up then I'll go take those onto
>> riscv/fixes.  I'll wait a bit for folks to get a chance to look, so it
>> won't be for tomorrow morning.
>
> Thanks Palmer. I have queued the KVM fixes (first two patches).

Sounds good.  The others are in riscv/fixes.

>
> Regards,
> Anup
>
>>
>> Thanks!
>>
>> --
>> kvm-riscv mailing list
>> kvm-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/kvm-riscv
