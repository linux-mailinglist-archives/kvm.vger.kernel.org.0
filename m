Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F32C107E09
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWK2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:28:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbfKWK2y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Nov 2019 05:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574504933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=4tanX7i7KcH5r5sp86+hzp4NVa2zdCctCVhumJRLPOU=;
        b=NGWtZ+q0s/cgizBas69EIPd/kXyU/wNO92qSi3/naLcGZfgYkpRL0B4gjyxFNZEo/F2x3F
        QYIOCqTP7QP0nrxbkCa9tIpY5LZcf1mD72NyavTH6CBzWlwbNR38DnyFgRJV0UN/050Wom
        Blj2ZDYClGQbDOvcq69+BTvrPZOGhI0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-mH5YNLQyO0y90vKzSjqbZw-1; Sat, 23 Nov 2019 05:28:49 -0500
Received: by mail-wm1-f72.google.com with SMTP id h191so4600400wme.5
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQ6hGferHGL1L9ZhEoN6QHHY4p/q+t8P9KyFKfImRlM=;
        b=PMMT6Id8lAHiMJ4iAPOrqQlh6a7gikPRHt36QgqsBaSDuBT+vxkU/pSqKpakA1Pc+Y
         AmdxYHX9Z5GaKHP3OsgINhRrgu8F7PsRMV1Y6skDgbEOl0VartjXKYssVzGtQCBqDu7q
         9n1Bq5K56dwb6qmZKruoxxxCCkfIVwkBxfJ5YYSx0x66t7sIV9mHmSc4v9dPfp7Zx9ui
         Iw3XiIaZ1HPZmijuKZAeMuJ2Y3BCTke6IWqFBRMUOyNUv1VrOLvk7U6cIfKLa3ntXyx6
         pgMc1QQLU8G08qcJyZHsO6qGX+M2c1m/lfB3UKFc28X4lPje7t1gtymVPvHXsPhRkVCk
         A4OQ==
X-Gm-Message-State: APjAAAVNWF1coycSwHoejRFsj6bp4SJEGo7n1fesBDvPHzmnfn1c4ied
        ZtThNNG8k3cIrc0ZIiQx12ytXgID0rk4SryWLx5xMauoR9OrWLvVTrmOTpeQWMYlIHKt5KG/2wH
        fnxJSorZRxhy/
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr19268144wml.158.1574504928500;
        Sat, 23 Nov 2019 02:28:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4xCz0dXTtexlA9Uc6i/YILe7MVHjojQkEJS0nbbNGxD8iTzmKHbIesOw080i43k7qZDM+8A==
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr19268125wml.158.1574504928227;
        Sat, 23 Nov 2019 02:28:48 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id y6sm1695912wrn.21.2019.11.23.02.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:28:47 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Remove a spurious export of a static function
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191122201549.18321-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <48aa2a88-560f-fa16-746f-d7398dafa086@redhat.com>
Date:   Sat, 23 Nov 2019 11:28:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191122201549.18321-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: mH5YNLQyO0y90vKzSjqbZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/11/19 21:15, Sean Christopherson wrote:
> A recent change inadvertantly exported a static function, which results
> in modpost throwing a warning.  Fix it.
>=20
> Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_C=
APABILITIES")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a256e09f321a..3e9ab2d1ea77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1329,7 +1329,6 @@ static u64 kvm_get_arch_capabilities(void)
> =20
>  =09return data;
>  }
> -EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
> =20
>  static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>=20

Queued, thanks.

Paolo

