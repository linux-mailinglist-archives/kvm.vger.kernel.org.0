Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A961CC186
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEIM6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 08:58:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgEIM6k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 08:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589029117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMVWh1mEzqEp+H77U0A+zFW74/ES0KTqoqYD9zfDHVk=;
        b=SBJ7/Yjvw+WfbzUO9nI73ThDYrgRMySMbvpMU4CzBDncTpIPAUpXPFaBKO/p0LrlC4nICd
        AcOlpeEGbUgmqv6ji5rgh5JwKQZK2WMxu/aQkXYW7VjcdmegotZLUeBQT/TR9K5dF6XUXq
        UBTUiOKBZfkoYqUcmFk2A1Co8IA7iFY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-HhDxal-dPiKjcaTFXcq-2g-1; Sat, 09 May 2020 08:58:34 -0400
X-MC-Unique: HhDxal-dPiKjcaTFXcq-2g-1
Received: by mail-wr1-f69.google.com with SMTP id g30so400211wrb.4
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 05:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMVWh1mEzqEp+H77U0A+zFW74/ES0KTqoqYD9zfDHVk=;
        b=q2GRm3QsaSCFdOr0hd+IaIBjZXkz7eCKUuHExg17PPN7chWK5vhrycCHQZlNGk4Am9
         Km4a6HDMp2E5d9yXMf2Z93AcvSBpVL2twEMwaNYdmgkh+2vt/OK2FfjmQr1nkwt5L2xx
         XlmJnCXN7tN8DXEPRkzduAj5a18k1fDkvWNMKb8cD/GH32Zl97+S0F89kxRCotFdySev
         pq23PAenhYzE8RyVaT7GcMCIRZvW4DHOPiB/YH+AQHhxW3PvJDQdXrTPoQhkORe5aoyw
         I8Y4jCVlj+JeUSyUM+JexLuwVUDwu9sY1VBv3vYWi6AVLyYHAlXIwEpFKMmBHebo+INk
         8OzA==
X-Gm-Message-State: AGi0PuZYt1K/GJqjHBz/CcAtLj1++WDxLrJShEff9OQ7GIY2wUlhH1JE
        EEMfGT2tvqN2l9dPQg8LBVlua6ZCdfDDcw+0m8DyrDgLiFrDvNiP6o6VILmn5o7uVI4/6fvYeT4
        p6i3gZd8Ar72l
X-Received: by 2002:a1c:bbc4:: with SMTP id l187mr1466334wmf.183.1589029113622;
        Sat, 09 May 2020 05:58:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypKq4Rk8OD2T4G72wvoaVVvKImJJwsZJ+gbZPfWKklL8AEJZ1rTGr/sDTr1PsG7tp0d8p/dZEg==
X-Received: by 2002:a1c:bbc4:: with SMTP id l187mr1466307wmf.183.1589029113323;
        Sat, 09 May 2020 05:58:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id x12sm8175828wrp.55.2020.05.09.05.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 05:58:32 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] svm: Test V_IRQ injection
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200509111622.2184-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4097f4fe-f941-a8ef-8d93-3164f0b0441d@redhat.com>
Date:   Sat, 9 May 2020 14:58:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200509111622.2184-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/20 13:16, Cathy Avery wrote:
> Test V_IRQ injection from L1 to L2 with V_TPR less
> than or greater than V_INTR_PRIO. Also test VINTR
> intercept with differing V_TPR and V_INTR_PRIO.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/svm_tests.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 150 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 65008ba..aa6f3c2 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1595,6 +1595,153 @@ static bool exc_inject_check(struct svm_test *test)
>      return count_exc == 1 && get_test_stage(test) == 3;
>  }
>  
> +static volatile bool virq_fired;
> +
> +static void virq_isr(isr_regs_t *regs)
> +{
> +    virq_fired = true;
> +}
> +
> +static void virq_inject_prepare(struct svm_test *test)
> +{
> +    handle_irq(0xf1, virq_isr);
> +    default_prepare(test);
> +    vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +                            (0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
> +    vmcb->control.int_vector = 0xf1;
> +    virq_fired = false;
> +    set_test_stage(test, 0);
> +}
> +
> +static void virq_inject_test(struct svm_test *test)
> +{
> +    if (virq_fired) {
> +        report(false, "virtual interrupt fired before L2 sti");
> +        set_test_stage(test, -1);
> +        vmmcall();
> +    }
> +
> +    irq_enable();
> +    asm volatile ("nop");
> +    irq_disable();
> +
> +    if (!virq_fired) {
> +        report(false, "virtual interrupt not fired after L2 sti");
> +        set_test_stage(test, -1);
> +    }
> +
> +    vmmcall();
> +
> +    if (virq_fired) {
> +        report(false, "virtual interrupt fired before L2 sti after VINTR intercept");
> +        set_test_stage(test, -1);
> +        vmmcall();
> +    }
> +
> +    irq_enable();
> +    asm volatile ("nop");
> +    irq_disable();
> +
> +    if (!virq_fired) {
> +        report(false, "virtual interrupt not fired after return from VINTR intercept");
> +        set_test_stage(test, -1);
> +    }
> +
> +    vmmcall();
> +
> +    irq_enable();
> +    asm volatile ("nop");
> +    irq_disable();
> +
> +    if (virq_fired) {
> +        report(false, "virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
> +        set_test_stage(test, -1);
> +    }
> +
> +    vmmcall();
> +    vmmcall();
> +}
> +
> +static bool virq_inject_finished(struct svm_test *test)
> +{
> +    vmcb->save.rip += 3;
> +
> +    switch (get_test_stage(test)) {
> +    case 0:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        if (vmcb->control.int_ctl & V_IRQ_MASK) {
> +            report(false, "V_IRQ not cleared on VMEXIT after firing");
> +            return true;
> +        }
> +        virq_fired = false;
> +        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +                            (0x0f << V_INTR_PRIO_SHIFT);
> +        break;
> +
> +    case 1:
> +        if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
> +            report(false, "VMEXIT not due to vintr. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        if (virq_fired) {
> +            report(false, "V_IRQ fired before SVM_EXIT_VINTR");
> +            return true;
> +        }
> +        vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
> +        break;
> +
> +    case 2:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        virq_fired = false;
> +        // Set irq to lower priority
> +        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +                            (0x08 << V_INTR_PRIO_SHIFT);
> +        // Raise guest TPR
> +        vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
> +        break;
> +
> +    case 3:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +        break;
> +
> +    case 4:
> +        // INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        break;
> +
> +    default:
> +        return true;
> +    }
> +
> +    inc_test_stage(test);
> +
> +    return get_test_stage(test) == 5;
> +}
> +
> +static bool virq_inject_check(struct svm_test *test)
> +{
> +    return get_test_stage(test) == 5;
> +}
> +
>  #define TEST(name) { #name, .v2 = name }
>  
>  /*
> @@ -1750,6 +1897,9 @@ struct svm_test svm_tests[] = {
>      { "nmi_hlt", smp_supported, nmi_prepare,
>        default_prepare_gif_clear, nmi_hlt_test,
>        nmi_hlt_finished, nmi_hlt_check },
> +    { "virq_inject", default_supported, virq_inject_prepare,
> +      default_prepare_gif_clear, virq_inject_test,
> +      virq_inject_finished, virq_inject_check },
>      TEST(svm_guest_state_test),
>      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
> 

Queued, thanks.

Paolo

