Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4C6D88FA
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjDEUp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjDEUp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:45:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44620273F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:45:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54574d6204aso367840557b3.15
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680727541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqWp3muviIDsLuEo0I+CjY33qaMzCnuNiH2jilw/FyQ=;
        b=bc/T9w3S7CK/4dOnFZo7pu05rfJHm9ttZb6aRb+mNJgmKqP3VDE8tVoyFgzAweKIqH
         MAxJvMfSYd38r9NkS3nz/B2PIKExl/i/y5mHZMtZPxplbA9tmaRHk4XaWGFAWpGdqbxt
         8YkbzprRP3BOocRmk6SXmEowAvQ594xRWhzDwUvMDPkiNWYrvaOXTFU6LgoSzbVlajj8
         4YnaVIuGip1QfJw1P55VnwgpFco5nvon5AZxt0DnLuNsaoJ/1zNp9gk10U3KIY/T/nP4
         ZB0QJPq9bum12rfIEhbM1pVcE3VaNa0hXCmANxOZovJWRLWaeGT5t3VZOyGQ+yEzvJHX
         +0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqWp3muviIDsLuEo0I+CjY33qaMzCnuNiH2jilw/FyQ=;
        b=crvnOynFGrTEmy0JO4nO9eNm+qGb9dON4QQOuNalFBBOPtNNmVA0yaF9Ibg41cvM8j
         c0fO2nFq/wp/XSiv+HBo9umRbL0A1Ysr6wFSl+FISV50tP9k7UzS2zVPuGagSZcT7f4C
         ovK62qDbKB8uSUcJs4sO460/OsTfBcV0f/pbMQwWep8cNuD+iGZlCMAmMitx9fRZSkp+
         7b+Mhzsk6LaiPGBTuiTd+o3fWh+7V/QQN4oC7XXWHz1lqWs8e6r8WfjeisX6xXm25yTj
         +jOxRf90Yu2VGhw0zPEXzXbeP1dPc0miQcH3/kBIxdNw2x8/63MvxsKXY45k6RAbjMGU
         8pcQ==
X-Gm-Message-State: AAQBX9fljQ/dL71Z7JlAK41Yj4fItYFJRbHCGXMDgBohY/y8uaQ7SbbX
        aVNraV+Ilr+cjPtdiqICAOM2qtbIolE=
X-Google-Smtp-Source: AKy350ac4+xwZhDrezXJonuNe20SvP6FeYm6LfdTvPSke3XT1okmA5YFL6u9FwUMSFsb9g70NEdu7DE4Kk4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:768b:0:b0:b6d:80ab:8bb6 with SMTP id
 r133-20020a25768b000000b00b6d80ab8bb6mr471857ybc.1.1680727541518; Wed, 05 Apr
 2023 13:45:41 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:45:40 -0700
In-Reply-To: <20220810061924.1418-1-santosh.shukla@amd.com>
Mime-Version: 1.0
References: <20220810061924.1418-1-santosh.shukla@amd.com>
Message-ID: <ZC3d9EPMCoknCoU8@google.com>
Subject: Re: [kvm-unit-tests PATCHv2] x86: nSVM: Add support for VNMI test
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Santosh Shukla wrote:
> Add a VNMI test case to test Virtual NMI in a nested environment,
> The test covers the Virtual NMI (VNMI) delivery.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---

Quite a few comments, but I'll post a v3 with everything cleaned up.  More below.

> diff --git a/x86/svm.h b/x86/svm.h
> index 766ff7e36449..91a0dee2c864 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -131,6 +131,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define V_INTR_MASKING_SHIFT 24
>  #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
>  
> +#define V_NMI_PENDING_SHIFT 11
> +#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
> +#define V_NMI_MASK_SHIFT 12
> +#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
> +#define V_NMI_ENABLE_SHIFT 26
> +#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)

Same complaints as I had for the kernel side, e.g. VM_NMI_MASK vs. V_NMI_BLOCKING_MASK.

> +
>  #define SVM_INTERRUPT_SHADOW_MASK 1
>  
>  #define SVM_IOIO_STR_SHIFT 2
> @@ -419,6 +426,7 @@ void default_prepare(struct svm_test *test);
>  void default_prepare_gif_clear(struct svm_test *test);
>  bool default_finished(struct svm_test *test);
>  bool npt_supported(void);
> +bool vnmi_supported(void);
>  int get_test_stage(struct svm_test *test);
>  void set_test_stage(struct svm_test *test, int s);
>  void inc_test_stage(struct svm_test *test);
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index e2ec9541fd29..f83a2b56ce52 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1445,6 +1445,93 @@ static bool nmi_hlt_check(struct svm_test *test)
>  	return get_test_stage(test) == 3;
>  }
>  
> +static volatile bool vnmi_fired;

There's no need to use a separate flag, just reuse nmi_fired.  And then this
test can also reuse nmi_prepare().

> +static void vnmi_handler(isr_regs_t *regs)
> +{
> +    vnmi_fired = true;

Use tabs, not spaces.

> +}
> +
> +static void vnmi_prepare(struct svm_test *test)
> +{
> +    default_prepare(test);
> +    vnmi_fired = false;
> +    vmcb->control.int_ctl = V_NMI_ENABLE;
> +    vmcb->control.int_vector = NMI_VECTOR;
> +    handle_irq(NMI_VECTOR, vnmi_handler);
> +    set_test_stage(test, 0);
> +}
> +
> +static void vnmi_test(struct svm_test *test)
> +{
> +    if (vnmi_fired) {
> +        report(!vnmi_fired, "vNMI dispatched even before injection");
> +        set_test_stage(test, -1);

Ugh, so much copy+paste in the test.  I'll add a patch to provide a macro to dedup
the report_fail() + set_test_stage() + vmmcall(), the last of which is unnecessarily
dependent on non-failing code in many cases.

> +static bool vnmi_finished(struct svm_test *test)
> +{
> +    switch (get_test_stage(test)) {
> +    case 0:
> +        if (vmcb->control.exit_code != SVM_EXIT_ERR) {

Took me a bit of staring to understand why an error is expected.  The setup path
really needs a comment explaining that it deliberately creates a bad configuration,
and it should explicitly clear INTERCEPT_NMI.

> +            report_fail("VMEXIT not due to error. Exit reason 0x%x",
> +                        vmcb->control.exit_code);
> +            return true;
> +        }
> +        report(!vnmi_fired, "vNMI enabled but NMI_INTERCEPT unset!");
> +        vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +        vmcb->save.rip += 3;
> +        break;
> +
> +    case 1:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report_fail("VMEXIT not due to error. Exit reason 0x%x",

VMMCALL expected, not ERR.
