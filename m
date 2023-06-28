Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF8741903
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjF1TqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 15:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjF1TqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 15:46:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312C1BE8
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 12:46:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53450fa3a18so48266a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 12:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687981580; x=1690573580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7mcp5/4P8AP0xkXt/thddGLST36j3uQroOasjJw2kQ=;
        b=3X3J2Y9E1VfBP9Ua7QLQHnf5tWOiCY196KrTDDRGoQT5j5w75S+ef9lJaxQf1I+Dr6
         2ng0STjRGjZzYm7EtW7P3AqdvF4BpiTunzeqVHiCrNu8SLnudKTIoKMLwKyJ+dHLPtZx
         Uy1kq7ORYYrbeGQK/jo2+9FBGCEtb3qnJypIwWIFe5dx+s8TQoFaJ9YZI1UhCqWeNfUG
         wJ7PZQbwTrRcOtewooOJgYCoEZ9a9ay3tNFjuIrVPzJTK7o6U4C4oXVv4avxQuEpejEU
         +mrUIUhzaO+zX+OZ8TzVl3OK/CB6e1shtdVkwtZV8PtCKhlGXpsxLKpVzlQEyBGrOjtP
         Cd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687981580; x=1690573580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7mcp5/4P8AP0xkXt/thddGLST36j3uQroOasjJw2kQ=;
        b=B+vB3Dzv3RHnKwztdgE1hyqEztX0aC485GYu1scpXwrICOWVCtv1qf+mbNXP7GMHXp
         JAwhqPriS9Gco1icFHcrrxITwOrL/MUi+U0xViOLR1eVSX/7skbALIwrvzcd93V7ISp6
         QSuj+C+A5ogiv8Lu3J9C00mmMxsWs2LEH9VwgBDheBmI81brTiw28vvDl6z/HSDnOnvv
         vMPJ9rtSUZDgZM+HL7tykORmAedvXRkcjHK6e8/hTod3FgWhLS9lsRGKhh2xZH+6SIJU
         krtQirS3wjLr3wOBYaS4y/bDgdHClAqZ0I6ZBgpkXyud76se7NwCQ4jU2sg3otqAu14n
         SZ9Q==
X-Gm-Message-State: AC+VfDxC6x2jnXOtNQ3NCn/CF5r9ESZcbj08UAuzuB/27fXHodQMSCt4
        tas2rF94Dg8amWphf3W/b7vXY20xnQU=
X-Google-Smtp-Source: ACHHUZ63GagN7SvQAnsZIi3Pep1VIp9fjbRzI2L7PvnlNPi9oisw5tsVURUi8r1TgGB2Av+65c6uN1xbQbk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f50e:0:b0:54f:d3ef:539a with SMTP id
 w14-20020a63f50e000000b0054fd3ef539amr3666158pgh.4.1687981580106; Wed, 28 Jun
 2023 12:46:20 -0700 (PDT)
Date:   Wed, 28 Jun 2023 12:46:18 -0700
In-Reply-To: <20230530134248.23998-2-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com> <20230530134248.23998-2-cloudliang@tencent.com>
Message-ID: <ZJyOCpueM0viGDfX@google.com>
Subject: Re: [PATCH v2 1/8] KVM: selftests: KVM: selftests: Add macros for
 fixed counters in processor.h
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Heh, duplicate "KVM: selftests:" in the shortlog.

On Tue, May 30, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add macro in processor.h, providing a efficient way to obtain

Try not to describe what the patch literally does in terms of code, the purpose
of the shortlog+changelog is to complement the diff, e.g. it's super obvious from
the diff that this patch adds macros in processor.h.

> the number of fixed counters and fixed counters bit mask. The

Wrap closer to 75 chars, 60 is too aggressive.

> addition of these macro will simplify the handling of fixed
> performance counters, while keeping the code maintainable and
> clean.

Instead of making assertions, justify the patch by stating the effects on code.
Statements like "will simplify the handling" and "keeping the code maintainable
and clean" are subjective.  In cases like these, it's extremely unlikely anyone
will disagree, but getting into the habit of providing concrete justification
even for simple cases makes it easier to write changelogs for more complex changes.

E.g.

  Add x86 properties for the number of PMU fixed counters and the bitmask
  that allows for "discontiguous" fixed counters so that tests don't have
  to manually retrieve the correct CPUID leaf+register, and so that the
  resulting code is self-documenting.

> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index aa434c8f19c5..94751bddf1d9 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -240,6 +240,8 @@ struct kvm_x86_cpu_property {
>  #define X86_PROPERTY_PMU_VERSION		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 0, 7)
>  #define X86_PROPERTY_PMU_NR_GP_COUNTERS		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
>  #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
> +#define X86_PROPERTY_PMU_FIXED_CTRS_BITMASK	KVM_X86_CPU_PROPERTY(0xa, 0, ECX, 0, 31)

Please spell out COUNTERS so that all the properties are consistent.

> +#define X86_PROPERTY_PMU_NR_FIXED_COUNTERS	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 0, 4)
>  
>  #define X86_PROPERTY_SUPPORTED_XCR0_LO		KVM_X86_CPU_PROPERTY(0xd,  0, EAX,  0, 31)
>  #define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0	KVM_X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
> -- 
> 2.31.1
> 
