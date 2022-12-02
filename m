Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313676402EE
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiLBJJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiLBJJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:09:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D359B7B3
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:08:59 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y4so4105828plb.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uKuDlheAQlnav8x6wCebRhCDj6K0PqB5VyLpGNot6uQ=;
        b=eFwIUrE3URGqzTcbT11JFGw5DbAFWjIjzCgyRMl0GxK7ZXbtVyfPH0OAB3TkwmySWk
         P0BSDycSCFzmhA/x4pSDiB43sdeXm6W2om7k1lPF398sOj5HuuzvtmZLI37LzY7WMFHa
         kTrQWMX1D3uDeVgjyOolV4R5aCpMR0HTr+xrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKuDlheAQlnav8x6wCebRhCDj6K0PqB5VyLpGNot6uQ=;
        b=Apq3kdlwhc/5C0tqOZQqXe0obfNevjH43FyI1jmnn7SyOvf9IYTEKVkcWZPQlOd+NB
         gCyIQ2HjFxumRQSlGoAPcC74upZrYpRqVZW+Yvr1w+2T1AbtEexffkOClS+aWpiChkLJ
         N8hOFYCm2XQe4lshCYIFSHwON3QiWY69hSTKvVb03lzXozJ8sOGDYqcQPWX6DMIh7piQ
         VpoCnqSNZRwaTZyxkR22UXXXBMlC4jfDBHRACi00jnbMv768ZRnJNCUzCbdLEWqIA/6l
         SrhYGKmgZO2gvxp6to4qxutLJrNjqegpyso2Y5Fg1XrSpPPCuHBwX/6nPS2TbMVQAh9l
         gcpQ==
X-Gm-Message-State: ANoB5pkYuiaptxcAmcrvCOvK6/4HN16yFwqpYsHyA1mln4NDqvJa7SsQ
        5FMvV1x4c78lPgNLoRu5vnwzABxdSOP7VLExB6hb
X-Google-Smtp-Source: AA0mqf5lRB9PRRAJMtQEDr+mr8TWCBn4M2WVdZNdbbxOIDDfHUKFDXZnwg7nqSUeKoYfsoVMfdSLiL6t+V+z6jscN0A=
X-Received: by 2002:a17:902:f095:b0:189:b352:a236 with SMTP id
 p21-20020a170902f09500b00189b352a236mr7016505pla.75.1669972139006; Fri, 02
 Dec 2022 01:08:59 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-9-atishp@rivosinc.com>
 <20221101153112.hpst2bohsdvqours@kamzik> <CAOnJCU++M5jd6toy1J8T+FPGJWSUaw8s9X7sxZY25naPoZeJJw@mail.gmail.com>
 <20221123142254.2mc3j27kgw37jblv@kamzik>
In-Reply-To: <20221123142254.2mc3j27kgw37jblv@kamzik>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 2 Dec 2022 01:08:47 -0800
Message-ID: <CAOnJCULCHZXLG18BNw=Fn8UaNb8hSMuvLAsA+j_4mX+_B27MYg@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 6:22 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Tue, Nov 22, 2022 at 04:45:16PM -0800, Atish Patra wrote:
> ...
> > This brings up another generic error returning problem in KVM SBI
> > land. Usually, SBI error code numbers do not
> > align with Linux error codes to accommodate other operating systems.
> > However, most of the SBI error codes
> > have 1-1 relationship with the Linux error code.
> > Thus, kvm internal code returns a Linux specific error code and
> > vcpu_sbi will map those to SBI error code using
> > kvm_linux_err_map_sbi.
> >
> > However, this will not work for SBI_ERR_ALREADY_STARTED/STOPPED as
> > there are no corresponding
> > Linux specific error codes. We can directly return the SBI error codes
> > from vcpu_pmu.c and modify the
> > kvm_linux_err_map_sbi to pass through those. In that case, we can't
> > map any linux error code that
> > collides with SBI error code. Any other ideas to handle this case ?
> >
>
> It seems like we should drop kvm_linux_err_map_sbi() and add another
> parameter to kvm_vcpu_sbi_extension.handler for the SBI error. Another

That will just move the problem from the generic SBI layer to
extension specific layer.
The root problem remains the same as we can't expect the individual
extension to return
a valid linux specific error code.

Maybe we can relax that requirement. Thus, any extension that has
additional SBI error codes
may opt to return SBI error codes directly. For example, PMU extension
implementation will
directly SBI specific error codes from arch/riscv/kvm/vcpu_pmu.c. In
future, there will be other
extensions (e.g TEE) will have many more error codes that can leverage
this as well.

Does that sound reasonable ?

> option is to continue mapping SBI errors to Linux errors, e.g.
> SBI_ERR_ALREADY_STARTED == EBUSY, but that may not be too easy in
> all cases and the errors become ambiguous, as we can't tell if the
> Linux implementation generated the error or if the SBI call did.
>

We can't distinguish between SBI_ERR_ALREADY_STARTED/STOPPED in that case.

> Thanks,
> drew



-- 
Regards,
Atish
