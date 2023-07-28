Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B69A767124
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbjG1PyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbjG1PyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 11:54:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDE44A2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:53:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c6db61f7f64so2157703276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690559634; x=1691164434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSKHeZCMgvA3kWIhrH+n4mSoJzgBzU5J6H2rFYp+lic=;
        b=36hr/ZVZer9RvAya4ZWnFnQbK8YQhtITqVZBkBjBo440v2c0X6eN0dTqrfwuSz7rnr
         k6WaexoqA62nX8FAG4nFQN42YtpTPoI2wh+3jJ8o7wPm1hCgTfuNVbS6EPbcqVQMYEN8
         yX6GAsSlGhmh3OfRqIjW8R05WSUu0K/X4fXpahOmLUZoi6YQFqEw5dv+/YSaOupBw3r1
         1QOJlnLq34i4AF+BnbyIEyZktriEUaH2gPVQf9yg//1ZrZLXvLnuD9WAlIPQNWkv2YPw
         izFsP5t0laJ87+k+PtVShNOsqU9+ABHsrNM8WXC1tgWj4cUC0mfYLX4gBDtMPyqVsRaM
         2pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690559634; x=1691164434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pSKHeZCMgvA3kWIhrH+n4mSoJzgBzU5J6H2rFYp+lic=;
        b=AqiK9umiHK8ch7WrQ7T/fFmrshm8C7FYQPb4xiGUa0hbdQ4esYpqT38GI/E8CVonft
         5fp4WCT4uqXovMaoZoYlYkG4siW3hmVl5V/TCdoBcXUMj2EBv3JU/5B0jHxbzkbLavN1
         CgWWR59CbW7T5HvJxTG0sMUDtB+U8yBlhyHnLafdioc4tBhus3f4E6pD2nryDSlrNoVv
         xVah/Q/yjvGS/ftp4BQ/cQTQnx2Py5aFI+Pl68BlnNKHm4kozf7Qhend4pdK+b5two0J
         0ZdsfhV/+CglR4ZNbhshdNRJQK6x0dXHHgq/uZHBYpnrH5GvyDRpSaD8Ei6xOvboTTXV
         8b/Q==
X-Gm-Message-State: ABy/qLZzFurC9IRKdxk6t/g9Jqt71XkzNBtKjF52YZ3TAaMh08w+kjWg
        /2bx+afGf97XRtRnUB/G6FyxBkXxCgY=
X-Google-Smtp-Source: APBJJlHbJprqMW+zMuvG32ayD8bofMBAAKNaDzLOF7DuAIN4jyWdo3wXWE6hvbwHUsAc0SpOW5cSp73k0WI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db82:0:b0:d0f:15a4:5a53 with SMTP id
 g124-20020a25db82000000b00d0f15a45a53mr10767ybf.2.1690559633993; Fri, 28 Jul
 2023 08:53:53 -0700 (PDT)
Date:   Fri, 28 Jul 2023 08:53:52 -0700
In-Reply-To: <20230728-21d0e3ecb0d8916fd9d9bceb@orel>
Mime-Version: 1.0
References: <cover.1690364259.git.haibo1.xu@intel.com> <7e9d2d5518375083f10c92a3d1acd98914f69fd8.1690364259.git.haibo1.xu@intel.com>
 <20230728-21d0e3ecb0d8916fd9d9bceb@orel>
Message-ID: <ZMPR56RVgzI6s6Ik@google.com>
Subject: Re: [PATCH 2/4] KVM: riscv: selftests: Add exception handling support
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Haibo Xu <haibo1.xu@intel.com>, xiaobo55x@gmail.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm-riscv@lists.infradead.org
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

On Fri, Jul 28, 2023, Andrew Jones wrote:
> On Thu, Jul 27, 2023 at 03:20:06PM +0800, Haibo Xu wrote:
> > +void vm_init_trap_vector_tables(struct kvm_vm *vm);
> > +void vcpu_init_trap_vector_tables(struct kvm_vcpu *vcpu);
> 
> I think we should use a common name for these prototypes that the other
> architectures agree to and then put them in a common header. My vote for
> the naming is,

Just allocate the tables in kvm_arch_vm_post_create().  I've been meaning to
convert x86 and ARM, but keep getting distracted/waylaid by other things.

https://lore.kernel.org/all/Y8hCBOndYMD9zsDL@google.com

>   void vm_init_vector_tables(struct kvm_vm *vm);
>   void vcpu_init_vector_tables(struct kvm_vcpu *vcpu);
> 
> > +
> > +typedef void(*handler_fn)(struct ex_regs *);
> > +void vm_install_exception_handler(struct kvm_vm *vm, int ec, handler_fn handler);
> 
> I'd also put this typedef

And rename it to (*exception_handler_fn).

> and prototype in a common header (with s/ec/vector/ to what you have here)

Hmm, yeah, I think it makes sense to let vm_install_exception_handler() be used
from common code.  the vector to be installed is inherently arch specific, but
it would be easy enough for a test to use #ifdeffery to define the correct vector.
