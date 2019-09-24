Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E941BC999
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391359AbfIXN64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:58:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389545AbfIXN6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569333534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVAD+emWzvOIQBYJThy1GnIBuI4lY3K+JH0UY/hlEjM=;
        b=JkDBryUu6ZxcLXPcxlbPHtFjUn8ejsDo9g+6dJngEp8sLEk6vG/ztR5vBfBWGW5NTTV9bD
        sF5NhGYTJzJUjzKUBNdTS+wg7b5GK2d78DCKt324a5YcE6mZ4kvubK2dxYC9BBF7GEKyA2
        X5cYAwB9tcUoaowICr/6GydDHHcm1No=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-CFHnFf6MO3yxAG8hi3_X5Q-1; Tue, 24 Sep 2019 09:58:51 -0400
Received: by mail-wr1-f71.google.com with SMTP id a4so606649wrg.8
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nP5v7RaNsdBj7HiE43gMQzy6PMHfSmYGo+DgY+XLGHE=;
        b=Mhck0IoU0rgM9yQmJfCLLXrnnW7Cu7nPQYbY2D0Mk1dceQzuVgjc9PmGKgCA+6zdGD
         R0JJSf4YnJZqVun/pFZBGE+KxDaOHXCbRK9lwtcSaYrL1YIbpjY8TyQv4J84BeAsPrYC
         QH1hDMH3FPbV4+m9gAW9fMvw+fDETnWobu4U0BieZdTUdqcLkydgGvUSVE+4uDRN84aS
         rraaaEYcQKILS+CMRztJmQhhwnvDaIp1ZuY299J2AG8Ln7Is1ZrzMyNRcgxHkWIq4G8a
         Qhkq2sHSgVufOEWWcZn2fshsdUgtKpCVjw6N8VPNt9LFnSTXy67CxZ8TynQEQNSeS5lL
         IXag==
X-Gm-Message-State: APjAAAXPFx2BokVklxRzG0orP41kw1ysuuouT2seSYEYyIT6h1vV52CD
        kKezXFnh3fHCkK4v6aiYBQnx3QnxssuCsOY/bkNRVqNyGNcgqaYhz8A4dZRUpDFt/mJJpf+nWW4
        whaRP7dMI6b4X
X-Received: by 2002:a05:600c:2208:: with SMTP id z8mr133818wml.113.1569333530137;
        Tue, 24 Sep 2019 06:58:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxKaMgrtR32Plz5hy16tjMK6zrPKIUrDoFQ4NbzNLe4nOcMVpujZ+bVSFE1rLWo2n3U+1WF5w==
X-Received: by 2002:a05:600c:2208:: with SMTP id z8mr133797wml.113.1569333529896;
        Tue, 24 Sep 2019 06:58:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id a6sm150440wme.11.2019.09.24.06.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:58:49 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add "significant index" flag to a few CPUID
 leaves
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>,
        Steve Rutherford <srutherford@google.com>
References: <20190912165503.190905-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea8eeb02-1d81-3a4f-ab61-3e1072488549@redhat.com>
Date:   Tue, 24 Sep 2019 15:58:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912165503.190905-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: CFHnFf6MO3yxAG8hi3_X5Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/09/19 18:55, Jim Mattson wrote:
> According to the Intel SDM, volume 2, "CPUID," the index is
> significant (or partially significant) for CPUID leaves 0FH, 10H, 12H,
> 17H, 18H, and 1FH.
>=20
> Add the corresponding flag to these CPUID leaves in do_host_cpuid().
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation supp=
ort")
> ---
>  arch/x86/kvm/cpuid.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948e..e7d25f4364664 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -304,7 +304,13 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 *e=
ntry, u32 function,
>  =09case 7:
>  =09case 0xb:
>  =09case 0xd:
> +=09case 0xf:
> +=09case 0x10:
> +=09case 0x12:
>  =09case 0x14:
> +=09case 0x17:
> +=09case 0x18:
> +=09case 0x1f:
>  =09case 0x8000001d:
>  =09=09entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>  =09=09break;
>=20

Queued, thanks.

Paolo

