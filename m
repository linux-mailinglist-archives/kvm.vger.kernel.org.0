Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1B4B5BA9
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiBNUzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 15:55:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiBNUz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 15:55:28 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A48347065
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:55:08 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j12so27701677ybh.8
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3nfX1IJHQYZhWJDBMx1g0fhpVosVv76wsK35vK44cWk=;
        b=kymr/zMwnTAhhLIkffcjMHbuNFCM4KeQbKTl8YEWJynrXqLy30/Mrcx38Ch3iSAEZG
         98l8OX0OmOSpdjySTZLvci7TvR0eQTBPC4+jaajdhKCoSgm77wLXn9mGjemGn7SBXnfm
         HRqkjcz71ugRnetsaLOXBCAQ0+L4pO7/ELmzK/8psQOxT8eR4tJC6aFoSQEupURA9SAF
         P2drbcStglf730w0MOFxxMdz8VypblmeBFcuQIlzJf/6kiAm0ll5N57GZTZAXT15pQ7U
         VSG4/7kdGwT+1osG1czhP7Bh5vs9BDgcC7OwHmXAvaHlkHZuCL7h0p+vsCxpa+68K4LA
         bnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3nfX1IJHQYZhWJDBMx1g0fhpVosVv76wsK35vK44cWk=;
        b=mzdmjBurYFyztwPfSwbEPiubKvxkagBHE7kPvP7ebReU9Za+B6LY2lZdQQn+Oiq1GP
         MWkpwbtKIT6Ml4dya7qHNaVNnOZgqydq4gvWWlAST5vlbYYLgUinwJkIBKDFuSBsTOJN
         obryqhBeaWhdlp4E8rS6aqPggA5k1ut65eMx7vTIhddtqReNT7Pr5H6s9pcHm25iqzzy
         tD1cGPd6LDezAQ9ug/JuLcvyoF8F/uQGCAKBh+sMBGyu+EGSZHmqxrKnNKhOxMb/xSBY
         GLcdL43U0f5QLCHoQYr51ie/Qw42KmPXKSCVBLZHhSNxykIlP9Q6S+ByJn/6BfnKoyPS
         QJyA==
X-Gm-Message-State: AOAM533T44DsBGE2ZKuMzIcII1mqDXvsVqyqd57J+5nlgpnFqfoqCzDP
        qMW2yDwgKKHlv7q0M3CPAmL8blqZDfN+hwYfcRMEs9sbjvpMdA==
X-Google-Smtp-Source: ABdhPJy5S+HerHm2aYNW+8484Um8C4DXPdJPX9ubfpV6hGg1xNAKGVHVE7HOTvsdT2gyRgaZ2Am840mSimrtTTC8vGY=
X-Received: by 2002:a25:251:: with SMTP id 78mr745432ybc.730.1644870024179;
 Mon, 14 Feb 2022 12:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20220207051202.577951-1-manali.shukla@amd.com> <20220207051202.577951-4-manali.shukla@amd.com>
In-Reply-To: <20220207051202.577951-4-manali.shukla@amd.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 14 Feb 2022 20:20:13 +0000
Message-ID: <CAAAPnDH6y6pFG+Mw_JCYYi9rome0d0+Q4UTLK3KoBzREvkJwqw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: nSVM: Add an exception test
 framework and tests
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static void svm_l2_nm_test(struct svm_test *svm)
> +{
> +    write_cr0(read_cr0() | X86_CR0_TS);
> +    asm volatile("fnop");
> +}
> +
> +static void svm_l2_of_test(struct svm_test *svm)
> +{
> +    struct far_pointer32 fp = {
> +        .offset = (uintptr_t)&&into,
> +        .selector = KERNEL_CS32,
> +    };
> +    uintptr_t rsp;
> +
> +    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
> +
> +    if (fp.offset != (uintptr_t)&&into) {
> +        printf("Codee address too high.\n");

Nit: Code

> +        return;
> +    }
> +
> +    if ((u32)rsp != rsp) {
> +        printf("Stack address too high.\n");
> +    }
> +
> +    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
> +    return;
> +into:
> +    asm volatile (".code32;"
> +            "movl $0x7fffffff, %eax;"
> +            "addl %eax, %eax;"
> +            "into;"
> +            "lret;"
> +            ".code64");
> +    __builtin_unreachable();
> +}
> +

> +static void svm_l2_ac_test(struct svm_test *test)
> +{
> +    bool hit_ac = false;
> +
> +    write_cr0(read_cr0() | X86_CR0_AM);
> +    write_rflags(read_rflags() | X86_EFLAGS_AC);
> +
> +    run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
> +
> +    report(hit_ac, "Usermode #AC handled in L2");
> +    vmmcall();
> +}
> +
> +static void svm_ac_init(void)
> +{
> +    set_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
> +}
> +
> +static void svm_ac_uninit(void)
> +{
> +    clear_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
> +}
> +
> +struct svm_exception_test {
> +    u8 vector;
> +    void (*guest_code)(struct svm_test*);
> +    void (*init_test)(void);
> +    void (*uninit_test)(void);
> +};
> +
> +struct svm_exception_test svm_exception_tests[] = {
> +    { GP_VECTOR, svm_l2_gp_test },
> +    { UD_VECTOR, svm_l2_ud_test },
> +    { DE_VECTOR, svm_l2_de_test },
> +    { BP_VECTOR, svm_l2_bp_test },
> +    { NM_VECTOR, svm_l2_nm_test },
> +    { OF_VECTOR, svm_l2_of_test },
> +    { DB_VECTOR, svm_l2_db_test },
> +    { AC_VECTOR, svm_l2_ac_test, svm_ac_init, svm_ac_uninit },
> +};

If you set and clear PT_USER_MASK in svm_l2_ac_test() before calling
into userspace you can remove init_test and uninit_test from the
framework all together.  That will simplify the code.

Further, it would be nice to then hoist this framework and the one in
vmx into a common x86 file, but looking at this that may be something
to think about in the future.  There would have to be wrappers when
interacting with the vmc{s,b} and macros at the very least.

> +
> +static u8 svm_exception_test_vector;
> +
> +static void svm_exception_handler(struct ex_regs *regs)
> +{
> +    report(regs->vector == svm_exception_test_vector,
> +            "Handling %s in L2's exception handler",
> +            exception_mnemonic(svm_exception_test_vector));
> +    vmmcall();
> +}
> +
