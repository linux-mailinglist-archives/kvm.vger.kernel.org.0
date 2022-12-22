Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD6765484D
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 23:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiLVWTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 17:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLVWTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 17:19:45 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3168828712
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 14:19:44 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id h8so1583529qkk.8
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 14:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UfSW37xyH08SHLM9n3NcxeaT1opzh4yR4lRe7mABNso=;
        b=cUVNX9ZqoXmKkgfp2gBAHZlt09fofwavxmdbZiz0Pyj1vO7lVklOULeg7WyLbz7ylA
         m8SDJzPw9UJ19VUUDwN+8+EdtmiYFGGYtS945P7D2Jsoa8dpJIZ+ckV+fPnrXt24ZU60
         3AgF4y0qEy4c3J6OzTJEkDEjoYDNfhE/xGgFj+OVd4kKt7sylvpf+QqgwWEHkPwzS7tR
         6O80tSUQvv5AP2qy7YjDjne4P4peYPhGoEz1tusxo7vV1HppjQh+stxHSRH4jwJKeobV
         lqffWea2hel9b2IKmu2ppG9b0doupx9a/YvorJuxgJ+GQnHlBQGlX6XOIaTSnEvGBzxU
         nI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfSW37xyH08SHLM9n3NcxeaT1opzh4yR4lRe7mABNso=;
        b=ZRXJvl4da+IIGoqSLgRUI84HrOA4IzOS9AzFTrZVxT0oJTAr5TwPB6OeZp/InD6Smg
         kxCYIaPkPtCeLRKceiS3Dbpur+er+wmC8QEL2n+KDkYpO7AYEpFt65ji8DGo925uscwb
         pQwLTdk4kecMT+YT9V+F+YGqeTxI1Pc31kr3NgEAfr3tFOMQzkzcWSkJXvJUFBUxCMvW
         7TivTTr5ObOxzHYAhXs+2Po6JHKremKZs0X5z9bA/QkahX1xZxu6dEASKpOsR0vlvgf8
         m5KjA+CrmNHDaqmzM6z8JvWiMuWBo82xb2s66vMziIapRiLlJsuS04ATlmhejVcw33d/
         zEzQ==
X-Gm-Message-State: AFqh2kpE06945TYxZGCqCXQzfwnNGGd7aGHOyUHWbdZTfVlt/1mkPmIh
        NQJgN18rV4ENMWBMRNctishkbAQz0Nj/AOg1FjqNvQ==
X-Google-Smtp-Source: AMrXdXuTZx+MXLMJByTfCJ3fWVZHrHlG32ocHcBiVOA9wx9LeZTLtM6itQXQCtMyT5FFlyorvQqGrQrgCC3366wuIdM=
X-Received: by 2002:a05:620a:13e9:b0:6ff:b886:54d3 with SMTP id
 h9-20020a05620a13e900b006ffb88654d3mr315913qkl.383.1671747582993; Thu, 22 Dec
 2022 14:19:42 -0800 (PST)
MIME-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com> <20221018205845.770121-6-pgonda@google.com>
In-Reply-To: <20221018205845.770121-6-pgonda@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Thu, 22 Dec 2022 14:19:31 -0800
Message-ID: <CAGtprH8wfYk05+yfzngHJ99ESwjhDf-sRaLO3AT2x1VyFQ6pvw@mail.gmail.com>
Subject: Re: [PATCH V5 5/7] KVM: selftests: add library for
 creating/interacting with SEV guests
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Oct 18, 2022 at 1:59 PM Peter Gonda <pgonda@google.com> wrote:
>
> ...
> +
> +static void configure_sev_pte_masks(struct kvm_vm *vm)
> +{
> +       uint32_t eax, ebx, ecx, edx, enc_bit;
> +
> +       cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> +       enc_bit = ebx & CPUID_EBX_CBIT_MASK;
> +
> +       vm->arch.c_bit = 1 << enc_bit;

This should be 1ULL << enc_bit as the overall result overflows 32 bits.

> +       vm->arch.pte_me_mask = vm->arch.c_bit | vm->arch.s_bit;

Maybe the role of pte_me_mask needs to be discussed in more detail. If
pte_me_mask is to be used only for maintaining/manipulating encryption
of page table memory then maybe it should be just set as
vm->arch.c_bit or better yet replaced with vm->arch.c_bit.

gpa_protected_mask also needs to be set here so that vm_untag_gpa
works as expected.

> +       vm->protected = true;
> +}
> +
> ...
> +}

> --
> 2.38.0.413.g74048e4d9e-goog
>
