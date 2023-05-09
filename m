Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED406FCD15
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbjEIR64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 13:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjEIR6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 13:58:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ABF40F4
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 10:58:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaf2ede38fso60457615ad.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 10:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683655130; x=1686247130;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlJsm86rT3SLxx+ZGGQ6/9XUqT8vn3qcLSBujAHvDQ0=;
        b=ge5QAE+vHW6/rthSAGBTramJL/OLMOEhOQnhkHzfuddyaQoTFa5elRBLKMrZrtNF7s
         a9Ra9ow9c8YNhriMVriuo9+kFNKHi93gtDfYsVYvC22KJ4fOlIC7iFISc69GaNxBWCRL
         VAVSpyOmRQ6yDIvAeuhZWHIZpfGwupLja9Gr+UwV+ZJTzziefN9m1dzQOW0p1VdCClLB
         0uVjfITEg4AwPUY+LxUbIky1aF1gz3N3RAraF1+JQ+QIvLd2iMwDdQ7cwPLohOlgsFSt
         VH5cYTeSl9+fWtNtLkMdOH/1wtja7t8bs20sCA3/uBvkkChbcEnRbavwOz654xSDDv6V
         +Rng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683655130; x=1686247130;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlJsm86rT3SLxx+ZGGQ6/9XUqT8vn3qcLSBujAHvDQ0=;
        b=Yz9+YY5xSdlCWUbKTgCoHWyvleIJIxaqChL9yYpweFluC09lZo0ZH6thvbxlG0gkRy
         OMGMy9MAJAehuvz2SAtJAQ12iqErtccwE2jCArkpGWdla1bPZ58iGkVifSma6udbe1Vj
         c3TGycX3g+MhXxXlIDbKd92kFChoPQa776eY4MYGck31cF8gr9ciZ1z+N6ON9wCVTJat
         ZNS9QIVBCVJ9nimK8StTwxJWX546fGmN9/cedgAOavmhXRbYKRiu3QF87i9F0AZnEfyN
         Os58ldskLN3x98Wj4yhAD25W9ES64N9M2SXAIsdiygcpDmwbqV408ZIPLVyNtBf8qeDc
         7/8A==
X-Gm-Message-State: AC+VfDz69G/ZKWI1YcYdNEFSTYewcibHkEOElJVIjw/3AZCD4Afyd6XC
        qJ3UOelhCy7BFBTnIwEGKOGmwA==
X-Google-Smtp-Source: ACHHUZ5P1nlX10L+l60QDQSm73QeWCEprrfYGDnaXTPF/DVkKuwBOGe7eRAB+60LjZTEm6Qd9OQAjA==
X-Received: by 2002:a17:903:32cb:b0:1ac:94a9:941a with SMTP id i11-20020a17090332cb00b001ac94a9941amr4415200plr.30.1683655130332;
        Tue, 09 May 2023 10:58:50 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id io20-20020a17090312d400b0019fea4d61c9sm1896204plb.198.2023.05.09.10.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 10:58:49 -0700 (PDT)
Date:   Tue, 09 May 2023 10:58:49 -0700 (PDT)
X-Google-Original-Date: Tue, 09 May 2023 10:58:29 PDT (-0700)
Subject:     Re: [PATCH -next v19 20/24] riscv: Add prctl controls for userspace vector management
In-Reply-To: <2629220.BddDVKsqQX@diego>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, andy.chiu@sifive.com,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, vincent.chen@sifive.com, guoren@kernel.org,
        wangkefeng.wang@huawei.com, sunilvl@ventanamicro.com,
        Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        josh@joshtriplett.org, shr@devkernel.io, joey.gouly@arm.com,
        jordyzomer@google.com, ebiederm@xmission.com, omosnace@redhat.com,
        david@redhat.com, Jason@zx2c4.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     heiko@sntech.de
Message-ID: <mhng-399d1e16-1a51-466f-8e71-c17e9b360d07@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 04:14:26 PDT (-0700), heiko@sntech.de wrote:
> Hi,
>
> need to poke this more, but one issue popped up at first compile.
>
> Am Dienstag, 9. Mai 2023, 12:30:29 CEST schrieb Andy Chiu:
>> This patch add two riscv-specific prctls, to allow usespace control the
>> use of vector unit:
>>
>>  * PR_RISCV_V_SET_CONTROL: control the permission to use Vector at next,
>>    or all following execve for a thread. Turning off a thread's Vector
>>    live is not possible since libraries may have registered ifunc that
>>    may execute Vector instructions.
>>  * PR_RISCV_V_GET_CONTROL: get the same permission setting for the
>>    current thread, and the setting for following execve(s).
>>
>> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
>> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
>
>
>> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
>> index 960a343799c6..16ccb35625a9 100644
>> --- a/arch/riscv/kernel/vector.c
>> +++ b/arch/riscv/kernel/vector.c
>> @@ -9,6 +9,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/sched.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/prctl.h>
>>
>>  #include <asm/thread_info.h>
>>  #include <asm/processor.h>
>> @@ -19,6 +20,8 @@
>>  #include <asm/ptrace.h>
>>  #include <asm/bug.h>
>>
>> +static bool riscv_v_implicit_uacc = !IS_ENABLED(CONFIG_RISCV_V_DISABLE);
>> +
>>  unsigned long riscv_v_vsize __read_mostly;
>>  EXPORT_SYMBOL_GPL(riscv_v_vsize);
>>
>> @@ -91,11 +94,51 @@ static int riscv_v_thread_zalloc(void)
>>  	return 0;
>>  }
>>
>> +#define VSTATE_CTRL_GET_CUR(x) ((x) & PR_RISCV_V_VSTATE_CTRL_CUR_MASK)
>> +#define VSTATE_CTRL_GET_NEXT(x) (((x) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK) >> 2)
>> +#define VSTATE_CTRL_MAKE_NEXT(x) (((x) << 2) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK)
>> +#define VSTATE_CTRL_GET_INHERIT(x) (!!((x) & PR_RISCV_V_VSTATE_CTRL_INHERIT))
>> +static inline int riscv_v_get_cur_ctrl(struct task_struct *tsk)
>> +{
>> +	return VSTATE_CTRL_GET_CUR(tsk->thread.vstate_ctrl);
>> +}
>> +
>> +static inline int riscv_v_get_next_ctrl(struct task_struct *tsk)
>> +{
>> +	return VSTATE_CTRL_GET_NEXT(tsk->thread.vstate_ctrl);
>> +}
>> +
>> +static inline bool riscv_v_test_ctrl_inherit(struct task_struct *tsk)
>> +{
>> +	return VSTATE_CTRL_GET_INHERIT(tsk->thread.vstate_ctrl);
>> +}
>> +
>> +static inline void riscv_v_set_ctrl(struct task_struct *tsk, int cur, int nxt,
>> +				    bool inherit)
>> +{
>> +	unsigned long ctrl;
>> +
>> +	ctrl = cur & PR_RISCV_V_VSTATE_CTRL_CUR_MASK;
>> +	ctrl |= VSTATE_CTRL_MAKE_NEXT(nxt);
>> +	if (inherit)
>> +		ctrl |= PR_RISCV_V_VSTATE_CTRL_INHERIT;
>> +	tsk->thread.vstate_ctrl = ctrl;
>> +}
>> +
>> +bool riscv_v_user_allowed(void)
>> +{
>> +	return riscv_v_get_cur_ctrl(current) == PR_RISCV_V_VSTATE_CTRL_ON;
>> +}
>
> EXPORT_SYMBOL(riscv_v_user_allowed);
>
> kvm is allowed to be built as module, so you could end up with:
>
> ERROR: modpost: "riscv_v_user_allowed" [arch/riscv/kvm/kvm.ko] undefined!
> make[2]: *** [../scripts/Makefile.modpost:136: Module.symvers] Fehler 1
> make[1]: *** [/home/devel/hstuebner/00_git-repos/linux-riscv/Makefile:1978: modpost] Fehler 2
> make[1]: Verzeichnis „/home/devel/hstuebner/00_git-repos/linux-riscv/_build-riscv64“ wird verlassen
> make: *** [Makefile:226: __sub-make] Fehler 2

and presumably that means that "make allmodconfig" hasn't been run, 
which might shake out some more issues.

>
>
> Heiko
