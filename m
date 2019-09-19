Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5184DB7E66
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 17:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbfISPk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 11:40:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbfISPk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 11:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568907656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=jtOOTxtBSH0XScdrTXtYNsOa16spVRV1/m7O55QYuzg=;
        b=LTut5zdWab+uFf8fl/RKozzHFTM3FCe7L5/xbJNJZ+XWr/fT43nZniWGY0YvicJFDnDdfl
        4iqv22e7xh0C2nW6PLTaPNkrsZG2/z7s5iN1YLPUG5h3XLd3lqhtuqEcNFatGlTcShPcVr
        RAZ5Tvz9mY7uS3I20JwsRO8W//DdSiA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-IFjtD5VOPDm5gN35R8DYEA-1; Thu, 19 Sep 2019 11:40:54 -0400
Received: by mail-wm1-f69.google.com with SMTP id h6so2008825wmb.2
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 08:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bAINjjRSlbUTjobcIGuJ8vNAwyPobHG3I1/jgsCdgXw=;
        b=UgQ0TV/nB7zZQ7UG/cSXWLK4LHIb3hDuR2Nna4/ngB3NoitKAFzG6jmhLIzCwsZ34L
         zlIE1DdMRpuUWjtfdvgKg4DGf20nr0XVVwGejFmSXbqQnHBLvMj2C36jnK85q8/Eazj7
         k/fZ7xkY9psPSIhILf+XHliDzU8I1z6R1E+7iqRiopV8lQ6xsWZLy7DFLCcFt4YNr8qa
         owpI0SPVR9qySr+9V9ZGgX2wlfPcMN+dJP3aQcI7ja+KTPmDpvgP1ZkS5z6Yn37aERBn
         BZR4n4hn8ztB9oRU/+E5vNP6hmWBQ2gp6jI+FnpyTQz1f8kVO6+ulw4cYk+DaxgOx/wj
         gM3g==
X-Gm-Message-State: APjAAAW/hGu/1vW87rgzD4yRg3zMYA8VguGJbxQ/mCJU55vryzvzN1DI
        nZnu5hXpGnOIxs9wBVpQ31nRgLXpvXeMWdMytif9pxtiIWVsUDUvv5pCqJul2D8dolIcpQoKdTD
        pJIElKwVIJsaL
X-Received: by 2002:adf:e488:: with SMTP id i8mr7375476wrm.20.1568907653242;
        Thu, 19 Sep 2019 08:40:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwR9KVma4Xblc47G5SpP/XvO6PKkeiTk0NhW+haXvKEfP9pKSHtsHzJm0BanCJIZYw+ZParUA==
X-Received: by 2002:adf:e488:: with SMTP id i8mr7375450wrm.20.1568907652977;
        Thu, 19 Sep 2019 08:40:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id t6sm9820328wmf.8.2019.09.19.08.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 08:40:52 -0700 (PDT)
Subject: Re: [RFC patch 15/15] x86/kvm: Use GENERIC_EXIT_WORKPENDING
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <20190919150314.054351477@linutronix.de>
 <20190919150809.964620570@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ef1145d8-01af-57d2-1065-cf12db16e422@redhat.com>
Date:   Thu, 19 Sep 2019 17:40:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919150809.964620570@linutronix.de>
Content-Language: en-US
X-MC-Unique: IFjtD5VOPDm5gN35R8DYEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/19 17:03, Thomas Gleixner wrote:
> Use the generic infrastructure to check for and handle pending work befor=
e
> entering into guest mode.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Subject should be "x86/kvm: use exit_to_guestmode".

Paolo

> ---
>  arch/x86/kvm/x86.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>=20
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -52,6 +52,7 @@
>  #include <linux/irqbypass.h>
>  #include <linux/sched/stat.h>
>  #include <linux/sched/isolation.h>
> +#include <linux/entry-common.h>
>  #include <linux/mem_encrypt.h>
> =20
>  #include <trace/events/kvm.h>
> @@ -7984,8 +7985,8 @@ static int vcpu_enter_guest(struct kvm_v
>  =09if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
>  =09=09kvm_x86_ops->sync_pir_to_irr(vcpu);
> =20
> -=09if (vcpu->mode =3D=3D EXITING_GUEST_MODE || kvm_request_pending(vcpu)
> -=09    || need_resched() || signal_pending(current)) {
> +=09if (vcpu->mode =3D=3D EXITING_GUEST_MODE || kvm_request_pending(vcpu)=
 ||
> +=09    exit_to_guestmode_work_pending()) {
>  =09=09vcpu->mode =3D OUTSIDE_GUEST_MODE;
>  =09=09smp_wmb();
>  =09=09local_irq_enable();
> @@ -8178,17 +8179,9 @@ static int vcpu_run(struct kvm_vcpu *vcp
> =20
>  =09=09kvm_check_async_pf_completion(vcpu);
> =20
> -=09=09if (signal_pending(current)) {
> -=09=09=09r =3D -EINTR;
> -=09=09=09vcpu->run->exit_reason =3D KVM_EXIT_INTR;
> -=09=09=09++vcpu->stat.signal_exits;
> +=09=09r =3D exit_to_guestmode(kvm, vcpu);
> +=09=09if (r)
>  =09=09=09break;
> -=09=09}
> -=09=09if (need_resched()) {
> -=09=09=09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -=09=09=09cond_resched();
> -=09=09=09vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
> -=09=09}
>  =09}
> =20
>  =09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>=20
>=20

