Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8F15FBB96
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJKTxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiJKTxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:53:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52E7C1E9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:53:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x6so14206462pll.11
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DhlMOfPBdi/CsWsdnaMLzdq//FOZZc6tM8Yhst23qAw=;
        b=C74IZkU1+jAVMUbnoGaRvOY7sEMO90MLdqDnWdkCWMz+9uJUmGC54r5aogn7gustEJ
         NUT9LGUBlKvqGxhkCb2fhBcHJ+RopOoW+WGwCwqBO58ANWo474enoaJs+mCaCc1PvWEO
         3mr/8neCIz0RuDiDApHrM53UWqUAP0Xtp0aTZzw5ZpxrNo7SH/qiYb8hjohj0p9poY0Q
         2wRm5LUWsZtelulLw/VpEuPzX6a7lK1Lq6gyPkMeZSlTTfJdjULHqVoeB6bqZle6sdyg
         1GAXwgG45SfOwGsPo9N9CL4KtmqKt/Ar/3b5MNW/IMnHlGxrVQ81fxjLw4oD5tdkzj6J
         52AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DhlMOfPBdi/CsWsdnaMLzdq//FOZZc6tM8Yhst23qAw=;
        b=pR/1SJlY5id36uiaqbNkBP8L4zmJjZsqt5UXVZ54//L5p3lPxKnqlIXqYHIZ6JnHII
         0XLZDur4znocFrX0cH/ffsK4b7N31Zp/SnHhZzEE/LJgrAFQeZBMFbBBueymTVFHuCRK
         aHFI4lM9MBxWDDAEC5joFdOztzG/4dmnQwKRm+bkfkVvfM4ykZLufzMPFlsrOdPnuDTv
         ZOwS2hQj7bsItreYsT+vgr4QHnDYcb1W71L/5WU2XhBz8OP5ujx5X6ZyTqFVVfMuhXOE
         lbr5H8wudaGdEOzDL3pFkyfc0PTAiSRDVflkzVI1HX1Z3XUUjYPz7jXK68Yqh3m8xHbN
         wN4w==
X-Gm-Message-State: ACrzQf1bzdAxBGOXLSuF0R7tz2t6it0w+zqcNMZPy5kRnNzmBWt8imYn
        K49hd+wcUX0wV5xAopIK+ABULA==
X-Google-Smtp-Source: AMsMyM5mDG37X/LUkK2IJv0l3Ao0MyE1gBDWewqQmfyvUQqBeSdGUycE1fnfGPaslQRj09zOXZ1H8w==
X-Received: by 2002:a17:90b:1b08:b0:20d:7bbf:4701 with SMTP id nu8-20020a17090b1b0800b0020d7bbf4701mr881615pjb.87.1665518019533;
        Tue, 11 Oct 2022 12:53:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x6-20020a628606000000b005629b6a8b53sm9744924pfd.15.2022.10.11.12.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:53:39 -0700 (PDT)
Date:   Tue, 11 Oct 2022 19:53:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v5 03/30] KVM: x86: Move check_processor_compatibility
 from init ops to runtime ops
Message-ID: <Y0XJvx7aISd+fZDq@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <82455a41cd39decdd1eb8765c37278aa78a3a72e.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82455a41cd39decdd1eb8765c37278aa78a3a72e.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
> from check_processor_compatibility() and its callees.
> 
> use a static_call() to invoke .check_processor_compatibility.
> 
> Opportunistically rename {svm,vmx}_check_processor_compat to conform
> to the naming convention of fields of kvm_x86_ops.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-2-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  2 +-
>  arch/x86/kvm/svm/svm.c             |  4 ++--
>  arch/x86/kvm/vmx/vmx.c             | 14 +++++++-------
>  arch/x86/kvm/x86.c                 |  3 +--
>  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 51f777071584..3bc45932e2d1 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP(check_processor_compatibility)

Nit I missed in all previous versions: please add this new entry above "hardware_enable"
so as to keep the order similar to the order in struct kvm_x86_ops.  E.g.

KVM_X86_OP(check_processor_compatibility)
KVM_X86_OP(hardware_enable)
...
