Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907D36405E8
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiLBLhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiLBLhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:37:13 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B936D49E7
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 03:37:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r26so6077536edc.10
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 03:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXJtcqlaLP6+CXKylmb2agaWv2f+EorxGkZEJux5MAQ=;
        b=m3A7Keo5juBqmOvK9e2K7vrkdIzRp8ZeONbcC9AaOtt7dD5zMiho+D+Rb+7BcWH7zK
         wCHZZvYKzIlLqX/qa/QyQuVyyGiM9ds4R/TMZlA89JRPFAiA0L4WU5oqKb8lsa8UWqIy
         UCB18q8yokXiy1dnruy7KFzjojODvo0UYzHCaJVXuapZx1aAYdUORCA/TzCLeaAbwl4/
         J3HGB/zpAWqfWY0w+zEAfZWlm3Nlg0TNvwnlN52XYBqes1bn2NRIb2TKBYmWNJHXxZe7
         Uvnag4VE+kqlcL24TVT0vBpPqAOZ9ilA3O72FU2enShTDSwugAtQdWMT7I+jgKltq1tg
         euIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXJtcqlaLP6+CXKylmb2agaWv2f+EorxGkZEJux5MAQ=;
        b=H+lDIiH++yPaRnMGifgLDWhJ5gNL50tDNTLDqww/bMjKoVRWL8lbzlhf9sAvBuTdmS
         dLmJUolVfbqHnkCiNkMlQbK8D7Bdsdtfw16wHI+NhWbhqRntxqJzJfbattLjkX27TI5o
         lcxNxsQGtxE1CwarPxmnK7MyUqP/HvQVZM17HaLM2sgf4yvuzUhUVPY9JS4RpcLANA11
         uLtq/5VEvvLT31avao8YmS2zqu7Dz8e6f+MzLAUN02ZMHZsHWbWwu3kUsCLUaQsyd5a7
         xTdjLVmUIkR1kaWQTUxkniKg7Qkqbfy8qxTclJH4SUHrKUC9TlWdQVn3kTVkmPkU4cov
         5nSQ==
X-Gm-Message-State: ANoB5pnrMiMJWm1oSfAcRjBXvqi/3zImZi51PaFaUCGWEy0xZQu2WPuM
        7f6i88uD5xywwHVm7jIfQ+slKQ==
X-Google-Smtp-Source: AA0mqf4vGDG5MvIu6ojxnSaD8jSD5VdO9onQvOnqVlrAB81uoG+eg7B8tFXlyEbBfddbRf+dGtA+Ng==
X-Received: by 2002:aa7:c44c:0:b0:46b:3549:f7ef with SMTP id n12-20020aa7c44c000000b0046b3549f7efmr20909889edr.225.1669981030864;
        Fri, 02 Dec 2022 03:37:10 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id bm14-20020a0564020b0e00b0046bf4935323sm427781edb.30.2022.12.02.03.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 03:37:10 -0800 (PST)
Date:   Fri, 2 Dec 2022 12:37:08 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
Message-ID: <20221202113708.5sxbpnayj75xg6jp@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-9-atishp@rivosinc.com>
 <20221101153112.hpst2bohsdvqours@kamzik>
 <CAOnJCU++M5jd6toy1J8T+FPGJWSUaw8s9X7sxZY25naPoZeJJw@mail.gmail.com>
 <20221123142254.2mc3j27kgw37jblv@kamzik>
 <CAOnJCULCHZXLG18BNw=Fn8UaNb8hSMuvLAsA+j_4mX+_B27MYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCULCHZXLG18BNw=Fn8UaNb8hSMuvLAsA+j_4mX+_B27MYg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022 at 01:08:47AM -0800, Atish Patra wrote:
> On Wed, Nov 23, 2022 at 6:22 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Tue, Nov 22, 2022 at 04:45:16PM -0800, Atish Patra wrote:
> > ...
> > > This brings up another generic error returning problem in KVM SBI
> > > land. Usually, SBI error code numbers do not
> > > align with Linux error codes to accommodate other operating systems.
> > > However, most of the SBI error codes
> > > have 1-1 relationship with the Linux error code.
> > > Thus, kvm internal code returns a Linux specific error code and
> > > vcpu_sbi will map those to SBI error code using
> > > kvm_linux_err_map_sbi.
> > >
> > > However, this will not work for SBI_ERR_ALREADY_STARTED/STOPPED as
> > > there are no corresponding
> > > Linux specific error codes. We can directly return the SBI error codes
> > > from vcpu_pmu.c and modify the
> > > kvm_linux_err_map_sbi to pass through those. In that case, we can't
> > > map any linux error code that
> > > collides with SBI error code. Any other ideas to handle this case ?
> > >
> >
> > It seems like we should drop kvm_linux_err_map_sbi() and add another
> > parameter to kvm_vcpu_sbi_extension.handler for the SBI error. Another
> 
> That will just move the problem from the generic SBI layer to
> extension specific layer.
> The root problem remains the same as we can't expect the individual
> extension to return
> a valid linux specific error code.

I'm saying we return both from the extension specific layer, particularly
because only the extension specific layer knows what it should return.
KVM's SBI handlers currently have a return value and *out_val. *out_val
maps directly to SBI's sbiret.value, but the return value does not map to
SBI's sbiret.error. But, all we have to do is add *error_val to the
parameters for the extension handler to get it. Then, cp->a0 should be set
to that, not the return value.

> 
> Maybe we can relax that requirement. Thus, any extension that has
> additional SBI error codes
> may opt to return SBI error codes directly. For example, PMU extension
> implementation will
> directly SBI specific error codes from arch/riscv/kvm/vcpu_pmu.c. In
> future, there will be other
> extensions (e.g TEE) will have many more error codes that can leverage
> this as well.
> 
> Does that sound reasonable ?

I think we need both the Linux return and sbiret.error. The return value
indicates a problem *with* the emulation, while the new parameter I'm
proposing (*error_val) is the return value *of* the emulation. Normally
the Linux return value will be zero (a successful Linux call) even when
emulating a failure (*error_val != SBI_SUCCESS). When the return value
is not zero, then there's something wrong in KVM and the return value
should be propagated to userspace. We could also set the exit_reason to
KVM_EXIT_INTERNAL_ERROR, but KVM_EXIT_UNKNOWN is probably fine too.

> 
> > option is to continue mapping SBI errors to Linux errors, e.g.
> > SBI_ERR_ALREADY_STARTED == EBUSY, but that may not be too easy in
> > all cases and the errors become ambiguous, as we can't tell if the
> > Linux implementation generated the error or if the SBI call did.
> >
> 
> We can't distinguish between SBI_ERR_ALREADY_STARTED/STOPPED in that case.

That's why I only suggested using EBUSY for STARTED. Mapping STOPPED
was left as an exercise for the reader :-)

Thanks,
drew
