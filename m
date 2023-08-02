Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D291976D696
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbjHBSLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 14:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbjHBSK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 14:10:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F032103
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 11:10:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbf8cb6143so1134735ad.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 11:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690999853; x=1691604653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hNOi1ejB1pS9dlnPvTd4BYpS5FGTlhXd3925hg/0fm0=;
        b=1OE6veZg59gsoeCLHSoB+UkPlLRLs1s07mLxso/osH78WHkdAyjyM4PFg5Fl4ie4bF
         8Qo+8PDNUg50lP5ODwwCYp4j7hvQjDe7PTVUeYd+qQ8VWZ0FPNt4U58Lca5UL+4tPn+h
         P2AQIfN8/ciTQ7eTvI9WfNCJ2Yw8sJqnjprqmUrBmOebKgbeUxbvIcy83OAqQuxMlUHz
         Ka/cmhhuQX+2eepM+r+ZZwEm9yWdteKzIfjvrX0OC7HWPhtD3ANjTNIcySs2o1S1qbtD
         6F64Y2wQS7ACru2HtGrPU40xivGqU91vFZx/cKdsS27iWoCyFLSe/lPv3rzAL4XHHGha
         Kwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690999853; x=1691604653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hNOi1ejB1pS9dlnPvTd4BYpS5FGTlhXd3925hg/0fm0=;
        b=YZV+5teDK5C/iKqSFLX7FacSBN3OVuVL+JsU00Ua5epXDyXEXrigr/BkNXEqB2heJJ
         ymWARbdAu+AZP4Ge0MUQE9R2zopb7QPOB85P9ucdm9r6VnUS07xHhYgbRUtG+a6OedFk
         ugTimzgN0fMG7io1afFSbp7/A+xy3u++As5PWxDNylYPR6KWmn3hGR+No+eUnugABRfT
         atZVS2PLQELYQrIsE9X7JOZfDw87AAY5Hm8NdSFPmkTk2J3XjJPAJ6qjaNoXKFzEHj/z
         wKSZEZ+i0Q7tTAPZmUNNe2MxP5nJscaDI/+KJxPyUxoV6LOMRfyA7cLwkOyyXjHm/VCu
         0Fdw==
X-Gm-Message-State: ABy/qLbxn5CHc26uQ79qn8KlpenTlc5EpzV3pAd6MI7un9BKjCi+CCgg
        /pFAI/ePh0x7K0+aIKdOE0ELuaEijlU=
X-Google-Smtp-Source: APBJJlF95ARaqLNa81cSoeQ/yVAVuvkJNFxH1E7bSipo61hU/hVILuvCTY7msX2mF/eehqZ1FtZW+rjYsqE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b7:edcd:8dcf with SMTP id
 u1-20020a170902e5c100b001b7edcd8dcfmr98453plf.4.1690999853513; Wed, 02 Aug
 2023 11:10:53 -0700 (PDT)
Date:   Wed, 2 Aug 2023 11:10:51 -0700
In-Reply-To: <20230801020206.1957986-5-zhaotianrui@loongson.cn>
Mime-Version: 1.0
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn> <20230801020206.1957986-5-zhaotianrui@loongson.cn>
Message-ID: <ZMqcKzrSsw9WGeTC@google.com>
Subject: Re: [PATCH v1 4/4] selftests: kvm: Add LoongArch tests into makefile
From:   Sean Christopherson <seanjc@google.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Tianrui Zhao wrote:
> Add LoongArch tests into selftests/kvm makefile.

Please elaborate on how the lists of tests was chosen.  E.g. explaing why
LoongArch isn't supporting kvm_binary_stats_test, rseq_test, etc.

> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  tools/testing/selftests/kvm/Makefile | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c692cc86e7da..36a808c0dd4c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -55,6 +55,10 @@ LIBKVM_s390x += lib/s390x/ucall.c
>  LIBKVM_riscv += lib/riscv/processor.c
>  LIBKVM_riscv += lib/riscv/ucall.c
>  
> +LIBKVM_loongarch += lib/loongarch/processor.c
> +LIBKVM_loongarch += lib/loongarch/ucall.c
> +LIBKVM_loongarch += lib/loongarch/exception.S
> +
>  # Non-compiled test targets
>  TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
>  
> @@ -181,6 +185,13 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
>  TEST_GEN_PROGS_riscv += set_memory_region_test
>  TEST_GEN_PROGS_riscv += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_loongarch += kvm_create_max_vcpus
> +TEST_GEN_PROGS_loongarch += demand_paging_test
> +TEST_GEN_PROGS_loongarch += kvm_page_table_test
> +TEST_GEN_PROGS_loongarch += set_memory_region_test
> +TEST_GEN_PROGS_loongarch += memslot_modification_stress_test
> +TEST_GEN_PROGS_loongarch += memslot_perf_test
> +
>  TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
>  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
>  TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
> -- 
> 2.39.1
> 
