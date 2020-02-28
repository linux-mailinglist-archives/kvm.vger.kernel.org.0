Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A79174063
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 20:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgB1TkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 14:40:15 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43013 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgB1TkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 14:40:15 -0500
Received: by mail-io1-f65.google.com with SMTP id n21so4699738ioo.10
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 11:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPtMn1DRr9XvortjUITPDZ3CEbiHBiNte82vuONVh9o=;
        b=cDHRNBL+DGb0SwIW5hKVvIEk/rKsc3Qa/m3QWhsM9EfjGpCSpswe5FAwggWnLXfZYb
         apyEZ3/qVKdvxvBhnmagMWIYVhXzcl1nl1nqZ8CFf7YTYK6Zx8FleZUfdr92c3zK5EPI
         OJagCvhXGdyESUjn9v2uxCOF1V6F1L3LVYtrF+wloSm7v8gDaE/zdTMlmq/R0ApRomv7
         XCQTY+nvdtYYTS/lHF9gmLmRI0u+iN9GemgTOFqCdHU40ei3Rai2YrFq6akSwrSVCpBz
         MIp4XD3vKHPW/LWJBJt4qWaWvtcKGA8eLqpzcSmH8aU6XKWmawTEIRAWmGB4aB7dndOa
         pljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPtMn1DRr9XvortjUITPDZ3CEbiHBiNte82vuONVh9o=;
        b=mhD95NveNoz7BUOWwkgVnBfkdEuiRWqUdFHV+SsTrdbxwkzPTJaYOIWNMtPF+59JBg
         /gnMe14VH708qX599nBp/gcFNb2WcLc/CZWu1Iq4LSwhhsXxFinoG4nJh4qfKwMPLk9u
         /a4dFOdYIy0VO6+6hQBv0F+h5B+v4yHalKiFzmP7zOVjBRKoWV2n9YbuMVR5lubp2qBB
         H2HvGR91puFlnkmWJ7HlvOoI7auEkbvRxyZ042Wx/PNbLB/ipCgGym4IUHvhSmO5pk6r
         TZrJrjagVKSt56/KR1cZuuUfsVOkhVBRPjDb9D8GPv/ijr0KPq26x86xgoGquvike91C
         HmCw==
X-Gm-Message-State: APjAAAXKyJYIZ0AtRQEt+Bak2pshR5QXzTZVF9c24wVA2ygbYbn0YLGx
        965ZJmvocb5ph70GhdOAQI2M4O0m8fB8oFdXUINI+w==
X-Google-Smtp-Source: APXvYqyEoF4X3ARGk0tM2iH0JFYNphuD8sW56MfDi2pW2PQ5LxAd41Kqp9Dn0hjBJx4XkWsF+imcnXVzJbf29oDpyCk=
X-Received: by 2002:a02:cd3b:: with SMTP id h27mr4685466jaq.18.1582918814624;
 Fri, 28 Feb 2020 11:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20200228085905.22495-1-oupton@google.com> <20200228085905.22495-2-oupton@google.com>
In-Reply-To: <20200228085905.22495-2-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Feb 2020 11:40:03 -0800
Message-ID: <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 12:59 AM Oliver Upton <oupton@google.com> wrote:
>
> Switch the default value of the 'avic' module parameter to 1.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b82a500bccb7..70d2df13eb02 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -358,7 +358,7 @@ static int nested = true;
>  module_param(nested, int, S_IRUGO);
>
>  /* enable / disable AVIC */
> -static int avic;
> +static int avic = 1;
>  #ifdef CONFIG_X86_LOCAL_APIC
>  module_param(avic, int, S_IRUGO);
>  #endif
> --
> 2.25.1.481.gfbce0eb801-goog

How extensively has this been tested? Why hasn't someone from AMD
suggested this change?
