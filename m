Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB2410282D
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 16:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfKSPeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 10:34:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42099 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728045AbfKSPeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 10:34:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574177670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=C/voEchAETWB+tWHQ2FVr7DfDDh8sc5TP8Nb/c9lrUI=;
        b=CJhPKxupGO7q91qn4zwlysbeJcoHGdwkRklu7fj5V/YzplF2uL9bGcpR8poa6XPpA6zTtJ
        +1DCwDeVOg23GRNzuUN8XM9GiP3bz67Lgr0tHcwdx5oJV51Ew0Gf3H14T1bCyHb8VM3jnM
        /hXBW84xhZ5vHOCLSArlGzxoLko3Ffg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-vZY4nbm8M-OKwbDFhhmY3g-1; Tue, 19 Nov 2019 10:34:27 -0500
Received: by mail-wm1-f71.google.com with SMTP id f21so2445086wmh.5
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 07:34:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ozPqxYYVyB+z1rGADe+0BjnuTxvm4S/rP0PZtTuQLck=;
        b=NxpNWjdeVTxJtWxV/fEYfte08IQNQqeEy/99LDfQEnDyJyvI0AnIhS5UVeBxY2PUpW
         Nd4U19qUjH9pp8ArQvCXF5UmRDwT7L1BirsPDlMmrIJ9YdI5+15QABJ8PPfP1zcj6FNn
         NphBaMXfjEt2OFge3kbbQVs0/wEzsucEdH5QZ6vAvBmfQ/ul1YmHLt1k1Wkt97lEXi20
         RpepppkSCrIvWOLND2tb6QIGNc+SbzyFDPU6LURxOORPyTq8p70rZ2rDEWyljFTATF04
         GZsh0T9F/29u4yiSJZYsrQSeMMn7NhfCK9XUj9q4JKRQYfbU7guLkcgr03awfTviMuDl
         1omg==
X-Gm-Message-State: APjAAAUcMBQgqr/syiyly2M9vuKsOWRwjiEd24KdaWz5TuhtrBgOeSRE
        RRkgQX80WrKniGZNUw+fG9x1I6yirppLAmGthCjsihfAVVEdn9dnilqoF2mLhPUK1t3vxQ+ZJOh
        /JUuiIytPRfnw
X-Received: by 2002:a1c:6405:: with SMTP id y5mr6795079wmb.175.1574177666666;
        Tue, 19 Nov 2019 07:34:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3rP51U9kcFzJB55l6B8ucOflaG0/TB3FFM3XpOoJGxJC98Rem3IDJTnq6fqyzEbsOyr0XGQ==
X-Received: by 2002:a1c:6405:: with SMTP id y5mr6795041wmb.175.1574177666378;
        Tue, 19 Nov 2019 07:34:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id x11sm28022389wro.84.2019.11.19.07.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 07:34:25 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Unexport kvm_vcpu_reload_apic_access_page()
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mark Kanda <mark.kanda@oracle.com>
References: <20191118172702.42200-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <823c1956-42b9-5524-ef8f-224fd45301d9@redhat.com>
Date:   Tue, 19 Nov 2019 16:34:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118172702.42200-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: vZY4nbm8M-OKwbDFhhmY3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/19 18:27, Liran Alon wrote:
> The function is only used in kvm.ko module.
>=20
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb992f5d299f..7e7a0921d92a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7916,7 +7916,6 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vc=
pu *vcpu)
>  =09 */
>  =09put_page(page);
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
> =20
>  void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>  {
>=20

Queued, thanks.

Paolo

