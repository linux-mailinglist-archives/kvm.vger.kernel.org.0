Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8D107E0A
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKWK32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:29:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39300 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbfKWK32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Nov 2019 05:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574504967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=patTDqP6P/12wqJT5SP1aPiZu7eQGy3OK8NDt1fjPUM=;
        b=UemCyrHGd0+7YK48yGEajTEuj0ZJfDssGfSaooK+8iRHWkOt8Tbg52i3+7PGvemrJom9rs
        oKGN2fEm60S2cPwMoOK/QccRRkSRjZI7Fyl/2dy3AaaCr60Hd6zf0Bv+Wuv4KD8Q1zFnwx
        KwsWCeWMI5cu7RiodHvxcfCDpZlc7yE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268--lELbBtGOS2p3YcWhHfH0Q-1; Sat, 23 Nov 2019 05:29:25 -0500
Received: by mail-wr1-f72.google.com with SMTP id c6so5239777wrm.18
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LxlNznsKDsiNmIvShf/cu1MAgP/XlucV6i+DkqhtvE=;
        b=QT+Z9Y67Gjn215J13lYcdufvAdp5edG8s05NMSWIU5dtDwwwXUO+aAZVk8gebyETr6
         fDQzPijrB0LIpIRMHgIPqpwhVSJOGLFeU++FJJdKF25hoxXqvLkV0RmP7m3zvjNKnJNv
         7BBb/0wiQFhhkiAFS/t47PG5piAHsxgI/Y+/Y2ZEJ4vRFMxSrcLLiEZkUfMSNuSMruHR
         WFtLwLbROjxAcSzjWhXK8Da6Cj5Qjyyu4ZZeTBsT/5pVR2TgAgo4Ls+rB+juKGN8Z/n5
         Dp7pXRvm6tDHZHHgweWqrr1knSUa3vM0wcNV1ITnBbw+ohsCK2xz1xg/PTA2g4epxzmm
         WDIA==
X-Gm-Message-State: APjAAAWIFY1XBHbL7YJ+IMcm8lECTLorLHC8KrP6cOdU617jND/FeEmM
        OHCG9pWFnEE4RneATXDRqXcPIi18ws27J4qU25BLs46gfmBNBjOQtqCFAF1ndre7c+OV76Ubgx/
        KgWhwU7DxH/dM
X-Received: by 2002:a1c:7c0e:: with SMTP id x14mr1651195wmc.62.1574504964526;
        Sat, 23 Nov 2019 02:29:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfzOylcMIN+W5QEdcSCnBQn5pl/XoRCsnIZBpf+F3bnbWowWL4VxnTaZnP0L+DqoJrMJleqA==
X-Received: by 2002:a1c:7c0e:: with SMTP id x14mr1651177wmc.62.1574504964231;
        Sat, 23 Nov 2019 02:29:24 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id w11sm1720910wra.83.2019.11.23.02.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:29:23 -0800 (PST)
Subject: Re: [PATCH] KVM: Fix jump label out_free_* in kvm_init()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1574477150-775-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <86ac7d2a-b611-067a-f9cb-bd5f09d0b3a9@redhat.com>
Date:   Sat, 23 Nov 2019 11:29:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1574477150-775-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: -lELbBtGOS2p3YcWhHfH0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/11/19 03:45, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> The jump label out_free_1 and out_free_2 deal with
> the same stuff, so git rid of one and rename the
> label out_free_0a to retain the label name order.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/kvm_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13e6b7094596..00268290dcbd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4354,12 +4354,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, un=
signed vcpu_align,
> =20
>  =09r =3D kvm_arch_hardware_setup();
>  =09if (r < 0)
> -=09=09goto out_free_0a;
> +=09=09goto out_free_1;
> =20
>  =09for_each_online_cpu(cpu) {
>  =09=09smp_call_function_single(cpu, check_processor_compat, &r, 1);
>  =09=09if (r < 0)
> -=09=09=09goto out_free_1;
> +=09=09=09goto out_free_2;
>  =09}
> =20
>  =09r =3D cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:start=
ing",
> @@ -4416,9 +4416,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsi=
gned vcpu_align,
>  =09unregister_reboot_notifier(&kvm_reboot_notifier);
>  =09cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  out_free_2:
> -out_free_1:
>  =09kvm_arch_hardware_unsetup();
> -out_free_0a:
> +out_free_1:
>  =09free_cpumask_var(cpus_hardware_enabled);
>  out_free_0:
>  =09kvm_irqfd_exit();
>=20

Queued, thanks.

Paolo

