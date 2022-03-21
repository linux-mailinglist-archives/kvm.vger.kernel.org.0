Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED8B4E28AB
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348416AbiCUOAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348428AbiCUN5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:57:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554AC177089;
        Mon, 21 Mar 2022 06:55:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so14491048pjp.3;
        Mon, 21 Mar 2022 06:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=T/cg/D61Rx2qtItbaDKzBrsQqCJp0A7fN462BM8Zc9c=;
        b=qDwwwCcGB+gtqoVPosDcM3L5PDl5Tj6aM91f2HtUmNrsLQi0MJYwB/c95JDzSy9Wqr
         K7tW/UXvpFuqkbLt3d4gsE/BbIslSJmejTRMsEoLUoq/pVM3EYn7YE0ii6MO6fwtTpqE
         YC4G8pZPPLqcE58T/9WVqsvO+8dc9zCN56DU72m+//4UMR71e7KQmhiOglZbiQZov/ma
         AvF+w/uwXvskbEJJMXB+wioMFwQYNWYQkLgbs0IGvx7Hs/aPWueJ+Dg6gJqtQ10swCZ+
         6m4MDE1l6rra0ZJ8KLL+tovyAOpNY++bw0PBm1sBGQ+wfwb8QeQrU15zjsbkuCxn2ePI
         B11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=T/cg/D61Rx2qtItbaDKzBrsQqCJp0A7fN462BM8Zc9c=;
        b=m6PQZ9eVOn8LqC0DHO/b1iNbSd5qYJUmy7NsWwsiVPRFilowbp0RJASw6MFu5fmWxA
         TgfPYyyu0zFYzPS8RYblwQA6BvghtqJjmiaHuHld6Z4pWM5NbpsWMH+3SnxVev9gIyX6
         QJZ5cMzcq08MfRkBYJxUTTUnDxSOaXsFBqKyhyZAV5BAtJ5RlvDIAAZZD5gBvCRvjbFB
         8EFNKo/twetwdnyqSe67s+7hUSSOTB61cYeTFRhFXivcmvyqG18HNQ13LScA8jXfnd+U
         HWql0s+qGXvulVORppmc2YZBD/KEz9ZRi4JV7HBOCkUAuXSCrawAnwFBzhAGpmLAEro4
         E/pw==
X-Gm-Message-State: AOAM533MhMIi0YM5Y8UO0U5smJ+U3mv/iIzUoG9AIeU/tZlb5IsEURT1
        RU66Chs+mQNpN8/gHoVnLaGKKUkBkHh1RQ==
X-Google-Smtp-Source: ABdhPJzpiyFkuIGJLf0bWw2DeEYaFR161YuddweM83B+KxzuYJ51Ob3lFjhNH3vOF0fOLqsOsA3eRg==
X-Received: by 2002:a17:903:110d:b0:14e:ea6c:7086 with SMTP id n13-20020a170903110d00b0014eea6c7086mr13121381plh.0.1647870923727;
        Mon, 21 Mar 2022 06:55:23 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm20487487pfj.146.2022.03.21.06.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 06:55:23 -0700 (PDT)
Message-ID: <08cbba2c-6e15-d138-ecb8-a22ded3f8c8a@gmail.com>
Date:   Mon, 21 Mar 2022 21:55:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 0/4] KVM: x86: Use static calls to reduce kvm_pmu_ops
 overhead
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20220307115920.51099-1-likexu@tencent.com>
Organization: Tencent
In-Reply-To: <20220307115920.51099-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Knock knock, do we have any more comments on this patch set ?

On 7/3/2022 7:59 pm, Like Xu wrote:
> Hi,
> 
> This is a successor to the previous patch set [1] from Jason Baron, which
> converts kvm_pmu_ops to use static_call. A typical perf use case [2] for
> an Intel guest shows good performance gains (results are in patch 0004).
> 
> V2 -> V3 Changelog:
> - Refine commit messages for __initdata; (Sean)
> - Merge the logic of _defining_ and _update_; (Sean)
> - Drop EXPORT_SYMBOL_GPL(kvm_pmu_ops); (Sean)
> - Drop the _NULL() variant in the kvm-x86-*-ops.h; (Thanks to Paolo and Sean)
> - Drop to export kvm_pmu_is_valid_msr() for nVMX; (Thanks to Sean)
> - Based on the kvm/queue;
> 
> V1 -> V2 Changelog:
> - Export kvm_pmu_is_valid_msr() for nVMX [Sean]
> - Land memcpy() above kvm_ops_static_call_update() [Sean]
> - Move the pmu_ops to kvm_x86_init_ops and tagged as __initdata. [Sean]
> - Move the kvm_ops_static_call_update() to x86.c [Sean]
> - Drop kvm_pmu_ops_static_call_update() [Sean]
> - Fix WARNING that macros KVM_X86_OP should not use a trailing semicolon
> 
> Please note checkpatch.pl complains a lot about KVM_X86_*_OP macros:
> - WARNING: macros should not use a trailing semicolon
> - ERROR: Macros with multiple statements should be enclosed in a do - while loop
> which could be addressed as a one-time follow-up if needed.
> 
> Previous:
> https://lore.kernel.org/kvm/20211108111032.24457-1-likexu@tencent.com/
> 
> [1] https://lore.kernel.org/lkml/cover.1610680941.git.jbaron@akamai.com/
> [2] perf record -e branch-instructions -e branch-misses \
> -e cache-misses -e cache-references -e cpu-cycles \
> -e instructions ./workload
> 
> Thanks,
> 
> Like Xu (4):
>    KVM: x86: Move kvm_ops_static_call_update() to x86.c
>    KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
>    KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
>    KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
> 
>   arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 +++++++++++++++++
>   arch/x86/include/asm/kvm_host.h        | 17 +--------
>   arch/x86/kvm/pmu.c                     | 48 +++++++++++++++-----------
>   arch/x86/kvm/pmu.h                     |  9 ++++-
>   arch/x86/kvm/svm/pmu.c                 |  2 +-
>   arch/x86/kvm/svm/svm.c                 |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c           |  2 +-
>   arch/x86/kvm/vmx/vmx.c                 |  2 +-
>   arch/x86/kvm/x86.c                     | 23 ++++++++++++
>   9 files changed, 94 insertions(+), 42 deletions(-)
>   create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h
> 
