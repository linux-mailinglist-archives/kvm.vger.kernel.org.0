Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395FACA119
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 17:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfJCPXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 11:23:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727302AbfJCPXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 11:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570116190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACYcsO5LsuCnnuz+aym6467+xvrSkMd0esdIlAnFhJA=;
        b=RyJOT/x2zVPDpeE+W8ShdxBezrLjnweQjsIpLSO5uxjuimkccWke7S6EOAzt15F0udd+gB
        UmllhRcZFEF9v+j/TVfvJ5PfGphuC/66HjK9V6pvCmYUw+I8c1AmEeqb9hCW1AWcDCLRLr
        p0Xare+A7Uj1CoZdY+w+Ou/+VcdwLvo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-GB6cxvxLP32IYltfseJb6A-1; Thu, 03 Oct 2019 11:23:04 -0400
Received: by mail-wr1-f71.google.com with SMTP id z17so1269657wru.13
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 08:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QgeiVRP5tMXZ1aGWjGfno8dOcRW0i0euoLLtYTrHYXg=;
        b=F9cRJ35tSSZ6vXm8rOi9fjI5Jp0ZhzTkYHr7gz5eobG35mCLo2p23AUK/3JFpdWMPx
         9AKKxTDH0ocQjQpzl/jpDHu4jjZAeKqOdsoAeROmYUVAK2XHIdVL3f3PvvE+MHuP17/V
         DmllnlNwIMviCGASsqUTL/synoyLW5dsrpyHUoYROdzbhT+XF9wgNaMVE4szDhMdYscN
         SXorvl/AXcvgS3cjFTE2waoweQLVYRnNZg5GeQRf96IqsR5Tkrx/O1ZXgfrSK3yS9NTo
         M6m8diWAE2SHSTTm2NfFMWpx4k+cCM433Z87+nFmNNxbTiYBYBweZ3lnb+PaMBCMOwHE
         0fBg==
X-Gm-Message-State: APjAAAVDW5qkM+eRvGIvxFKkWVnd3qIPqG3421RlntJpa1abv6zdmW1X
        o5lod6P6Zc4tn5o0tSScKD+Yu9xcvNWZRXvoj2ssCtK7M+nBoJktwBEgXAtvFiYDAIrgiU2NW22
        /n3sZO5YiYh5H
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr7606102wml.52.1570116183643;
        Thu, 03 Oct 2019 08:23:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsmftxYDdLZIgTJtXmiSPDna8Xyn/lEwG7UsHtL9DbCpfQd9VxButfSW9NUGlbs3alDdg53g==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr7606077wml.52.1570116183312;
        Thu, 03 Oct 2019 08:23:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id p85sm3795488wme.23.2019.10.03.08.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:23:02 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: MSR_IA32_VMX_MISC[30] is not MBZ
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com
References: <20191002181114.3448-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <951c1057-54b8-c944-ea65-68293fd5e397@redhat.com>
Date:   Thu, 3 Oct 2019 17:23:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002181114.3448-1-namit@vmware.com>
Content-Language: en-US
X-MC-Unique: GB6cxvxLP32IYltfseJb6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 20:11, Nadav Amit wrote:
> MSR_IA32_VMX_MISC[30] tells whehter "VM entry allows injection of a
> software interrupt, software exception, or privileged software exception
> with an instruction length of 0".
>=20
> In other words, it is not MBZ (must be zero), so do not check that it is
> cleared.
>=20
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/vmx.c b/x86/vmx.c
> index d518102..647ab49 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1486,7 +1486,7 @@ static void test_vmx_caps(void)
>  =09report("MSR_IA32_VMX_MISC",
>  =09       (!(ctrl_cpu_rev[1].clr & CPU_URG) || val & (1ul << 5)) &&
>  =09       ((val >> 16) & 0x1ff) <=3D 256 &&
> -=09       (val & 0xc0007e00) =3D=3D 0);
> +=09       (val & 0x80007e00) =3D=3D 0);
> =20
>  =09for (n =3D 0; n < ARRAY_SIZE(vmx_ctl_msr); n++) {
>  =09=09ctrl.val =3D rdmsr(vmx_ctl_msr[n].index);
>=20

Queued, thanks.

Paolo

