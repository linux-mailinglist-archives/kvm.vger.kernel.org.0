Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5653EF7724
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKOz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:55:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29316 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbfKKOz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 09:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573484127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=10eqtXWuVOk/SFcUQHUwhmnRCi7Z/jWR3Bf4PWIs544=;
        b=ejzdVn6183uUU8IexcK8OjKh4eaeDZCNtlEYHooRf1/udaYwOvmEyUZPhjcXrfy4rNQeXt
        +Ap2+6Oig3GgXDaI5O2ymxjuDrCc9oEaNLyOZc0KhAmS9ivGuF8r+aZPoM0Gg6w4drJpwd
        Co3FpH0g37q2OJ0ItAEn5khjyG7iDkM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-h2bG63K9M96JoeRutBPouA-1; Mon, 11 Nov 2019 09:55:22 -0500
Received: by mail-wm1-f72.google.com with SMTP id b10so6996806wmh.6
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:55:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L+RPoJU0SRZeztIGuIxHP4ILQcmCn8rcmjau5H+T5fU=;
        b=QD9LULwHN+JREZlsT4r3A1g2zui7m6cjGferwWV6Ey6xSWpqjLQUbkdiXN+SRI0q5X
         u4aCwOjiAgve+Gayh4AjEQUjmZv/Zf36rsVd4a1phANn3c2ZZoCkd7qDvbKOUTes2OEF
         aSK4BHZ4aJoMZJ0VAOsuTUEIHs5oYrhkCH4T9ljM/+xZFPiJWdfM4EShcPhJy3y6csVu
         h+Ba5OzQr/cjg1EXxKphT2eW+KrA1dNj9mEwV5yNeZIp0o97a3GzMpXojuOOAB5FhfS3
         wdZm1dbWdTFlRheyaGsg3XgPLjYCzZRY/b+updG2fCgcnaz4BAjHW4t8EZeUFd8l6T5a
         OhSA==
X-Gm-Message-State: APjAAAWFcX9NFuk4IWy2Xbip7tvALvlrBOSuK+sxlONxkGPsDzkkAHnx
        iecTE/96ZrpT51YSMJkGNl0CVXjfu0op3RTUsegwcP+wbCxOmiNcVYasVhJgRTDd3CSClq2duWV
        ObZjCuJTT/q6t
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr3629209wmo.51.1573484121108;
        Mon, 11 Nov 2019 06:55:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqygEcPiKWLFQC4cHYw8wZ57ZVZIMkXMOQVAUC4L07ysw5xUL3cy43xb0YJFdz5Qucylgifv5A==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr3629194wmo.51.1573484120818;
        Mon, 11 Nov 2019 06:55:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id v128sm27196680wmb.14.2019.11.11.06.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:55:20 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Fix comment to specify PID.ON instead of PIR.ON
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111122525.93098-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ec7f2160-0557-2d65-1981-b726455f9360@redhat.com>
Date:   Mon, 11 Nov 2019 15:55:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111122525.93098-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: h2bG63K9M96JoeRutBPouA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:25, Liran Alon wrote:
> The Outstanding Notification (ON) bit is part of the Posted Interrupt
> Descriptor (PID) as opposed to the Posted Interrupts Register (PIR).
> The latter is a bitmap for pending vectors.
>=20
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5d21a4ab28cf..f53b0c74f7c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6137,7 +6137,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcp=
u)
>  =09if (pi_test_on(&vmx->pi_desc)) {
>  =09=09pi_clear_on(&vmx->pi_desc);
>  =09=09/*
> -=09=09 * IOMMU can write to PIR.ON, so the barrier matters even on UP.
> +=09=09 * IOMMU can write to PID.ON, so the barrier matters even on UP.
>  =09=09 * But on x86 this is just a compiler barrier anyway.
>  =09=09 */
>  =09=09smp_mb__after_atomic();
>=20

Queued, thanks.

Paolo

