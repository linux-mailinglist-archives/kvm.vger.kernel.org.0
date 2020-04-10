Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159161A47F0
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDJPnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:43:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgDJPnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 11:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586533389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F8q97ViWZ16ox9j0mRxmF3fIwTwaIbQN2mVISFGHGsE=;
        b=Qbryb22byl0e9wVVNeyCfaXixTaIa/Dqhb1GnS9tI7yJJhbrd/m6T0pASXv0ZDCtxAnD78
        Xxa9yCAxuLMNlZ0ukyhJoBepL/DEpYULwKTyd5z2ZiNunzmljGIy4ZeD2oqFmKgQ8k48Ek
        ZRh79JDL5dqn9J797PfG/SfMo/98q2E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-AZpjzacIM1KRU9RoPJrkpg-1; Fri, 10 Apr 2020 11:43:03 -0400
X-MC-Unique: AZpjzacIM1KRU9RoPJrkpg-1
Received: by mail-wr1-f72.google.com with SMTP id j16so718902wrw.20
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 08:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F8q97ViWZ16ox9j0mRxmF3fIwTwaIbQN2mVISFGHGsE=;
        b=IfEfN6W28sYzOYsKy5VzDy1Ta2p7K+2dhYhcqn0DQPUhrpUeMt+fVBsNVOS+ccemeM
         Ya1rbF/xZBwo3m720qERHPO0yTdbSvxNar9sUYvNJLHg3B5q0yxm0UlOOlbbBjwmivT5
         Au3hJTCb7SGplTUSivn5oWdv/GyRqXs8rJJ0qizYvjLIGcGi7dn0PubxbsIUIw1GVjM+
         x73xbC7EoMjL62+bCxWNVYyPZc7v2n0+6P3Exlk96LjawmagvoE4D5crO6UZWUMnfMFo
         c4XO8E28TiUd5akQy5DsDuLTbzF/lmJucuv2hh9q/CpmiNeccPCLC7orsIOVk6kgUsTQ
         Gb2A==
X-Gm-Message-State: AGi0PuYHtiOZHfP6JqroCqwimj1jasIliIRUX2riz29j6uCLg9y3iezH
        +vBVZaQAI33ksxcOyJyFSnkh5kWlv9C5aN7qEHjFcdZ/R97RcJJYO08fXw6AUzL1kSGvXaalwka
        qmYGQtupZiWY0
X-Received: by 2002:adf:e90e:: with SMTP id f14mr5262875wrm.106.1586533382375;
        Fri, 10 Apr 2020 08:43:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHWorgLRiw+eqBBOF/2dWTfaPrnkL8JdihaAMiEo428qkm5jMLXVPYGwNNnnaG7ZsDQi3L5g==
X-Received: by 2002:adf:e90e:: with SMTP id f14mr5262851wrm.106.1586533382025;
        Fri, 10 Apr 2020 08:43:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b7:b34c:3ace:efb6? ([2001:b07:6468:f312:f4b7:b34c:3ace:efb6])
        by smtp.gmail.com with ESMTPSA id t67sm3329979wmt.48.2020.04.10.08.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 08:43:01 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2 1/2] svm: Add test cases around NMI
 injection
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20200409152848.17762-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4fa0232-08c1-84bb-a94c-9329d3594e3b@redhat.com>
Date:   Fri, 10 Apr 2020 17:43:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409152848.17762-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 17:28, Cathy Avery wrote:
> This test checks for NMI delivery to L2 and
> intercepted NMI (VMEXIT_NMI) delivery to L1.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
> v2: Remove redundant NMI_VECTOR
> ---
>  x86/svm_tests.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 16b9dfd..b6c0106 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1340,6 +1340,85 @@ static bool interrupt_check(struct svm_test *test)
>      return get_test_stage(test) == 5;
>  }
>  
> +static volatile bool nmi_fired;
> +
> +static void nmi_handler(isr_regs_t *regs)
> +{
> +    nmi_fired = true;
> +    apic_write(APIC_EOI, 0);
> +}
> +
> +static void nmi_prepare(struct svm_test *test)
> +{
> +    default_prepare(test);
> +    nmi_fired = false;
> +    handle_irq(NMI_VECTOR, nmi_handler);
> +    set_test_stage(test, 0);
> +}
> +
> +static void nmi_test(struct svm_test *test)
> +{
> +    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
> +
> +    report(nmi_fired, "direct NMI while running guest");
> +
> +    if (!nmi_fired)
> +        set_test_stage(test, -1);
> +
> +    vmmcall();
> +
> +    nmi_fired = false;
> +
> +    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
> +
> +    if (!nmi_fired) {
> +        report(nmi_fired, "intercepted pending NMI not dispatched");
> +        set_test_stage(test, -1);
> +    }
> +
> +}
> +
> +static bool nmi_finished(struct svm_test *test)
> +{
> +    switch (get_test_stage(test)) {
> +    case 0:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        vmcb->save.rip += 3;
> +
> +        vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +        break;
> +
> +    case 1:
> +        if (vmcb->control.exit_code != SVM_EXIT_NMI) {
> +            report(false, "VMEXIT not due to NMI intercept. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +
> +        report(true, "NMI intercept while running guest");
> +        break;
> +
> +    case 2:
> +        break;
> +
> +    default:
> +        return true;
> +    }
> +
> +    inc_test_stage(test);
> +
> +    return get_test_stage(test) == 3;
> +}
> +
> +static bool nmi_check(struct svm_test *test)
> +{
> +    return get_test_stage(test) == 3;
> +}
> +
>  #define TEST(name) { #name, .v2 = name }
>  
>  /*
> @@ -1446,6 +1525,9 @@ struct svm_test svm_tests[] = {
>      { "interrupt", default_supported, interrupt_prepare,
>        default_prepare_gif_clear, interrupt_test,
>        interrupt_finished, interrupt_check },
> +    { "nmi", default_supported, nmi_prepare,
> +      default_prepare_gif_clear, nmi_test,
> +      nmi_finished, nmi_check },
>      TEST(svm_guest_state_test),
>      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
> 

Queued (both), thanks.

Paolo

