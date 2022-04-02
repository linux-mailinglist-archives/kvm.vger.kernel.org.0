Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984724EFD97
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbiDBBIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDBBIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:08:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CA9220B2F
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:06:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so3969701pjk.4
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5o4M1jt8/ZpdgJUd2875rzc8tpkN1WNPorh2WI+3lZ8=;
        b=dc5UAyygErJO8iyx0dcQihKdzdVGEyuh+t/WdSeO66Qdkb0Ne9fhFHd6oKfXEHRbmW
         JStauTPUD8uupns8twdhv8/MWhA3BlGF7QwGbmkwh+JQMI/xVZoYP47OoVZZ5RZxJzNO
         OZGC0HWPJvuxC7tIE5rKKkTY/ejxW2P+N09s5s5TtJDUJ0dv1V2PwfTBTE+dVjucALdD
         cOXy9LxeAj9LI54O9wSVn98F3eiL3Uw34eNa8TUHyZND/J0Do+maqdPR5Fu1xJ7gRcTw
         gkVJskeS+TYnPy3kGiBHxxEALiodFO6BaUiWDvkALZHxGm7eWlgdyAvYOBSd09vV0kpx
         IsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5o4M1jt8/ZpdgJUd2875rzc8tpkN1WNPorh2WI+3lZ8=;
        b=N5eUhHxhpPateITZ7UzQ5m4KEqsPzdmpEJfAiw9HNGWEdfed3TKiYP6nzJCUgjQWhl
         HHxHdRAEvfdRZ4CVj5oT0HsErsOnhCGGme7hx83mHerRj6P4DyHFDkgBXlbleTTSGRhX
         gXzQijbhgv69L6TkJ+4cQCljz6lwim3Qtm4Mu+5KOsWJ92diaB8GatazigBZKuOJHl4s
         EWdwMkj3iBslLXKgzGpLqvMbefX59UVpgATVuU40b8VM8YsVsTeXNmG7hHCCX9992jSn
         ZzqkiZUH/+JlRRcy/7nQVmA8grnJtX8y6F2ZTpLSeulX9Yl6UF5/5XsHB/ZA4CPzLZ9l
         AJaw==
X-Gm-Message-State: AOAM5323HGdrm5PRJBcLCxklBH9nsJRkfzXJZMBkPyZhWV26DtrOMCrf
        dqqGz0UBizFXeTS82A5T4FAqKg==
X-Google-Smtp-Source: ABdhPJzmiwkZKL8SxSPErXY6pjhLYJDKuQFxkiRneInmGR/TOIDE0tVjGRjgIJ1HGU4g1fOWOK4DZw==
X-Received: by 2002:a17:902:b7cb:b0:154:57eb:c754 with SMTP id v11-20020a170902b7cb00b0015457ebc754mr12518946plz.2.1648861593168;
        Fri, 01 Apr 2022 18:06:33 -0700 (PDT)
Received: from [192.168.86.237] (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
        by smtp.gmail.com with ESMTPSA id p19-20020a17090b011300b001ca44029199sm1718097pjz.16.2022.04.01.18.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 18:06:32 -0700 (PDT)
Message-ID: <796a4d51-f697-1e99-c8ac-20ab26cc635a@google.com>
Date:   Fri, 1 Apr 2022 18:06:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write
 lock
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20220401194652.950240-1-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
In-Reply-To: <20220401194652.950240-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 12:46 PM, Oliver Upton wrote:
> It is possible to take a stage-2 permission fault on a page larger than
> PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
> eagerly maps at the largest possible block size. When dirty logging is
> enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
> mappings and instead clears the write bit on the pte.
> 
> Since dirty logging is always performed at PAGE_SIZE granularity, KVM
> lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
> fault handler. This operation must be done under the write lock. Since
> commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
> relaxation during dirty logging"), the stage-2 fault handler
> conditionally takes the read lock on permission faults with dirty
> logging enabled. To that end, it is possible to split a 2M block mapping
> while only holding the read lock.
> 
> The problem is demonstrated by running kvm_page_table_test with 2M
> anonymous HugeTLB, which splats like so:
> 
>    WARNING: CPU: 5 PID: 15276 at arch/arm64/kvm/hyp/pgtable.c:153 stage2_map_walk_leaf+0x124/0x158
> 
>    [...]
> 
>    Call trace:
>    stage2_map_walk_leaf+0x124/0x158
>    stage2_map_walker+0x5c/0xf0
>    __kvm_pgtable_walk+0x100/0x1d4
>    __kvm_pgtable_walk+0x140/0x1d4
>    __kvm_pgtable_walk+0x140/0x1d4
>    kvm_pgtable_walk+0xa0/0xf8
>    kvm_pgtable_stage2_map+0x15c/0x198
>    user_mem_abort+0x56c/0x838
>    kvm_handle_guest_abort+0x1fc/0x2a4
>    handle_exit+0xa4/0x120
>    kvm_arch_vcpu_ioctl_run+0x200/0x448
>    kvm_vcpu_ioctl+0x588/0x664
>    __arm64_sys_ioctl+0x9c/0xd4
>    invoke_syscall+0x4c/0x144
>    el0_svc_common+0xc4/0x190
>    do_el0_svc+0x30/0x8c
>    el0_svc+0x28/0xcc
>    el0t_64_sync_handler+0x84/0xe4
>    el0t_64_sync+0x1a4/0x1a8
> 
> Fix the issue by only acquiring the read lock if the guest faulted on a
> PAGE_SIZE granule w/ dirty logging enabled. Add a WARN to catch locking
> bugs in future changes.
> 
> Fixes: f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation during dirty logging")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
