Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2357C720C50
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 01:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbjFBXXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 19:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbjFBXXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 19:23:51 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791C7194
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 16:23:50 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64f74f4578aso2687817b3a.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 16:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685748230; x=1688340230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jfm1Ndw+rAtPhqZQW2Gr/ZBbND6Bd8PdV58Tj1aqHCo=;
        b=6QU7O7Uu1huv9bywSUNd4ty0vriC1bsAx+6r9L6ZvXa5LrqmB5X3kx59qKG1dGUc7A
         pNr57gwEmqt4MJYYA0yMdIq397FGc3Y9WDSeI3YLpYxXeymgdNXi/FUFtfMQwMnjogEF
         zHVDUSf79AnnHlg34xqQt/AXhYgr4r6LxSZeoWcp65tdzkFOEKCnbu3auegPnXGjuQU/
         kAiHGDBv73VIEhVq60aSKVf5t3znrqMUhBlsVR8GpR+BZq/6izaxDcTDdzGAtLH5xQ9m
         V+iALMPLqZlZaYuTyuIL9ZT0MVsGdkqkSS/3+cDXhagbFDRGfpY10Kz+lbaGkPD96Z+3
         sySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685748230; x=1688340230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jfm1Ndw+rAtPhqZQW2Gr/ZBbND6Bd8PdV58Tj1aqHCo=;
        b=EYVn6YsDbxTCT74pSWYccmde1i6crhVZP+X98x2PpBkR/VlSH9/4rxF2PGd2dS8s+k
         yHEtbp7JKkBOWCMbVus4a0vaJnYNTYjaEqdV1LBPaVKiWXYsYhPPQl1b3jL0sWUILpbY
         qX8MiajUL7jCaz92ziq8Vh78F/jlAZWp9WynGvhEnlrw7ygM/QgyiiXK6UGiJs1fyF98
         5j4Cix68tDVzGTvMdW+gOra9aNGLyWdB/TVrFnu4jpc2d7mt43gCi5fr3jr4yLBfu6ey
         aHvpfRritD82eAvL1kEXROryleYpVuo8Yu8tGAdsdUBlsKAyH3m1lqs+T2EdsyRpV5xn
         eejQ==
X-Gm-Message-State: AC+VfDxWUhL4nCNltc9afLfaNz2V4uUeDtDDSHO+N8fVyL9wBe0IoD8q
        xsjZ4r2cBekCF8GMxr5/IaLo5f/AwR8=
X-Google-Smtp-Source: ACHHUZ6pOsTFDYks3M7BVKb4Pd5aijSHceLqD6OoGHZRpboTOywQm3R0P9qfvzc6Chmhw9DBtJ3XrlkUtC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cc4:b0:653:9883:40ec with SMTP id
 b4-20020a056a000cc400b00653988340ecmr691178pfv.5.1685748229956; Fri, 02 Jun
 2023 16:23:49 -0700 (PDT)
Date:   Fri, 2 Jun 2023 16:23:48 -0700
In-Reply-To: <20230530060423.32361-4-likexu@tencent.com>
Mime-Version: 1.0
References: <20230530060423.32361-1-likexu@tencent.com> <20230530060423.32361-4-likexu@tencent.com>
Message-ID: <ZHp6BDhcv/popAqm@google.com>
Subject: Re: [PATCH v6 03/10] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> AMD PerfMonV2 defines three registers similar to part of the Intel
> v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS and
> GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific part of
> the handling can be extracted to make it generic for X86 as a straight
> code movement.
> 
> Specifically, the kvm_pmu_set/get_msr() handlers of GLOBAL_STATUS,
> GLOBAL_CTRL, GLOBAL_OVF_CTRL defined for Intel are moved to generic
> pmu.c and the callback function .pmc_is_globally_enabled is removed,
> which is very helpful to introduce the AMD PerfMonV2 code later.

Yeah, except this patch doesn't actually move anything.  *Some* of the common bits
show up in pmu.c, but the same bits in pmu_intel.c get left behind. 

> The new eponymous pmc_is_globally_enabled() works well as legacy AMD
> vPMU version is indexed as 1. Note that the specific *_is_valid_msr will
> continue to be used to avoid cross-vendor MSR access.

This should be two patches.  Moving the GLOBAL_CTRL stuff is logically separate
from moving the pmc_is_enabled() code.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> @@ -213,6 +212,22 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>  	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
>  }
>  
> +/*
> + * Check if a PMC is enabled by comparing it against global_ctrl bits.
> + *
> + * If the current version of vPMU doesn't have global_ctrl MSR,
> + * all vPMCs are enabled (return TRUE).
> + */
> +static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +
> +	if (pmu->version < 2)

Nah, we're not open coding this check, not after putting in the effort to squash
the mess of open coding on Intel.  Moving intel_pmu_has_perf_global_ctrl() is
trivial, and also allows moving the existence checks into kvm_pmu_is_valid_msr().
