Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE29D6C918
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 08:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfGRGJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 02:09:46 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45836 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfGRGJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 02:09:46 -0400
Received: by mail-oi1-f195.google.com with SMTP id m206so20564072oib.12;
        Wed, 17 Jul 2019 23:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ouBAKzVQ2WnfW41jjUNSqg5dQI8v8T4WQ5DV145fghA=;
        b=KYALgA1zFr7+r2vv2kmMdJwu9oy2XZhF9xHQjP98tFxHQQ7HXzCHMG5m5ixgSd8LDc
         fddBGeSxpAMW+hidhCOKC+GtN6O588kGXCS+iBwPmEoNAGY5erVhW8ZT21IxljAAVOw3
         tMn7b+6PuzoH6XC9WD7n236tfPgtBJg9qaUlvuKPxJLLnpGFEvThx1bHbE89PUbYEp8X
         d3aiBkt7saW0T4DEB/iNPYBXUdtabWxWpePCAR/4EJkNiV9qXxYtc7axwnYJUJMAn0MQ
         byg4LilWV6cj5lCZ2LQ4m5pflznGzLywe+GIfk2A7N+1M5qeekVmbV4mTvQIECWrs4Ls
         Rd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ouBAKzVQ2WnfW41jjUNSqg5dQI8v8T4WQ5DV145fghA=;
        b=ES/p0SNMEHhdIF8mqcifihJUsR8uY5GMAsyTKnejuvsHotnw5xgZxqqeyvzuT5KUoc
         018+eGRJDO4AWmMIAIAVK6K/rH7MQfm73KcLGsHJye5LA3crh0jEHAr/WZ59+XinMrbs
         VUe2BUgZpJPIPK1dNrsAiudQZ+s4hlawPaFZndIe/5hyjko6VZ29QMZbOUuwJ57zHz6o
         yCJEKaV3ZjUx7updFnQOUOkRrg6E3snJHIh2Ww5KjyB0wdkOBt9nBhCj23Z3MKUgHXlC
         v2raRsYz7yNeupeRrqLFSTyGZYDleSU76yT0s1IgUuWAQ05V8tF70jBpev6YB7paRMtN
         R9mQ==
X-Gm-Message-State: APjAAAWDb3kHs+R13sWZvvk6jREDAhGRAvFllC9C/UsAjgTl9LrV0Wt3
        8TpPZ6+5JJMv0NM3mZm9/UTZ+w/aEYpbX/D2BbaRPKvS
X-Google-Smtp-Source: APXvYqwWqXZX2mRFaLJVkAtMNUeKBnbzZCyEkuKXbjVpO1sE7LhI8bZMHh6S8diabmTFcV/v2sZseKp/Jj3uH28NE+o=
X-Received: by 2002:a05:6808:3:: with SMTP id u3mr20158410oic.141.1563430185092;
 Wed, 17 Jul 2019 23:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 18 Jul 2019 14:09:36 +0800
Message-ID: <CANRm+Cxhtp=taa6b0oP2fRcM5fqbUJRMan4AyQ--Y-SXX+Frog@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc arm guy's latest email
On Fri, 12 Jul 2019 at 15:15, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during vcpu w=
akeup
> and interrupt delivery), except the lock holder, we want to also boost vC=
PUs
> that are delivering interrupts. Actually most smp_call_function_many call=
s are
> synchronous ipi calls, the ipi target vCPUs are also good yield candidate=
s.
> This patch sets preempted flag during wakeup and interrupt delivery time.
>
> Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
> ebizzy -M
>
>             vanilla     boosting    improved
> 1VM          23000       21232        -9%
> 2VM           2800        8000       180%
> 3VM           1800        3100        72%
>
> Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs,
> one running ebizzy -M, the other running 'stress --cpu 2':
>
> w/ boosting + w/o pv sched yield(vanilla)
>
>             vanilla     boosting   improved
>               1570         4000       55%
>
> w/ boosting + w/ pv sched yield(vanilla)
>
>             vanilla     boosting   improved
>               1844         5157       79%
>
> w/o boosting, perf top in VM:
>
>  72.33%  [kernel]       [k] smp_call_function_many
>   4.22%  [kernel]       [k] call_function_i
>   3.71%  [kernel]       [k] async_page_fault
>
> w/ boosting, perf top in VM:
>
>  38.43%  [kernel]       [k] smp_call_function_many
>   6.31%  [kernel]       [k] async_page_fault
>   6.13%  libc-2.23.so   [.] __memcpy_avx_unaligned
>   4.88%  [kernel]       [k] call_function_interrupt
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b4ab59d..2c46705 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>         int me;
>         int cpu =3D vcpu->cpu;
>
> -       if (kvm_vcpu_wake_up(vcpu))
> +       if (kvm_vcpu_wake_up(vcpu)) {
> +               vcpu->preempted =3D true;
>                 return;
> +       }
>
>         me =3D get_cpu();
>         if (cpu !=3D me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> --
> 2.7.4
>
