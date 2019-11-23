Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D267107E06
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfKWK1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:27:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfKWK1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Nov 2019 05:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574504872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=9t1o66oL/ot/4dk1v/CJNw3cN/q+qsqLeuNYINE0nag=;
        b=ah6PSvniGYzL+bg+B8Gd0J29YZ0FhrR1DxGzcDI6WYNYXaqPaWbpm81NLwwXcUK/ue5j2N
        vy+gfXBQ3ESauXiMxrEmx/ov+7P8Z/4cwMqH59BOEPiZ+zEGR3AArwyBdh1skRmT0SpdcN
        0Bd1KxXDWeX+c2cSO+W/eBKpbWHKbbU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-Ry0LziQXNoCMvG1Oe3MwAw-1; Sat, 23 Nov 2019 05:27:51 -0500
Received: by mail-wr1-f69.google.com with SMTP id c16so5320066wro.1
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:27:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ByRr3qgQ4gKWGr8Xv3AIFp3yO9nQXCN68JrkXg6kUo=;
        b=Qu7MAMC6J/8raLAQKzHmVFc5lotMmgx+5CHcT3pnFCgbq+84OEw3pAPLfktzoSR8l2
         8pIiLrE1Me7zy+nepuighCpeWJfLm1dFH/eMiQ2bBVSNtZN3URHPdjqKScCCSwSLl2S/
         PTV2ULocZPw1QR9CT+eDldWloDsGRouIjbggrANOQd17gDYjPQEAOiC1JtEwyekBdQnS
         bICgaKHNpNPTxa5bCX4wxoYd6BZz//ai+UGliZTNyiHFxzKKnjS08aQC73WqgZ1Utc+V
         i8jqr1kjGkCAh9ZH5KSguuq7ckt3cs/UlBSm37I6ZEBovrBe3tIQdQqcUPevxfLhbC5B
         ywjA==
X-Gm-Message-State: APjAAAUnTZOeWOluklNwbJFhu6ddFC8JKvWaUzacARMLDL4h9SUuxeym
        Cc10lryMpkW+8IsahRF5uPR8WzN9x5ZyhaXE5YrSMQRCSaafa1gCQt4Dl96AIedbvj62Y/UXvt+
        l+s33CXDvxGvS
X-Received: by 2002:a7b:c844:: with SMTP id c4mr9349285wml.1.1574504869933;
        Sat, 23 Nov 2019 02:27:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqzw+TvAijcHIZ2Iu2E8aCaIyvA0xNgfbMDlyhpcPW9ydL9HvxoUI6lL9XifEg/nHhROArNEbA==
X-Received: by 2002:a7b:c844:: with SMTP id c4mr9349262wml.1.1574504869559;
        Sat, 23 Nov 2019 02:27:49 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id o21sm1362003wmc.17.2019.11.23.02.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:27:49 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Fix the check whether CMCI is
 supported
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com
References: <20191009112754.36805-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ead9b6cc-b97c-bf8b-e76b-4022e5a74854@redhat.com>
Date:   Sat, 23 Nov 2019 11:27:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009112754.36805-1-namit@vmware.com>
Content-Language: en-US
X-MC-Unique: Ry0LziQXNoCMvG1Oe3MwAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 13:27, Nadav Amit wrote:
> The logic of figuring out whether CMCI is supported is broken, causing
> the CMCI accessing tests to fail on Skylake bare-metal.
>=20
> Determine whether CMCI is supported according to the maximum entries in
> the LVT as encoded in the APIC version register.
>=20
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  lib/x86/apic.h  |  7 +++++++
>  x86/vmx_tests.c | 10 +---------
>  2 files changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index b5bf208..a7eff63 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -70,6 +70,11 @@ static inline u32 x2apic_msr(u32 reg)
>  =09return APIC_BASE_MSR + (reg >> 4);
>  }
> =20
> +static inline bool apic_lvt_entry_supported(int idx)
> +{
> +=09return GET_APIC_MAXLVT(apic_read(APIC_LVR)) >=3D idx;
> +}
> +
>  static inline bool x2apic_reg_reserved(u32 reg)
>  {
>  =09switch (reg) {
> @@ -83,6 +88,8 @@ static inline bool x2apic_reg_reserved(u32 reg)
>  =09case 0x3a0 ... 0x3d0:
>  =09case 0x3f0:
>  =09=09return true;
> +=09case APIC_CMCI:
> +=09=09return !apic_lvt_entry_supported(6);
>  =09default:
>  =09=09return false;
>  =09}
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f4b348b..0c710cd 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5863,11 +5863,6 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
>  =09return val & 0xf0;
>  }
> =20
> -static bool is_cmci_enabled(void)
> -{
> -=09return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
> -}
> -
>  static void virt_x2apic_mode_rd_expectation(
>  =09u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
>  =09bool apic_register_virtualization, bool virtual_interrupt_delivery,
> @@ -5877,9 +5872,6 @@ static void virt_x2apic_mode_rd_expectation(
>  =09=09!x2apic_reg_reserved(reg) &&
>  =09=09reg !=3D APIC_EOI;
> =20
> -=09if (reg =3D=3D APIC_CMCI && !is_cmci_enabled())
> -=09=09readable =3D false;
> -
>  =09expectation->rd_exit_reason =3D VMX_VMCALL;
>  =09expectation->virt_fn =3D virt_x2apic_mode_identity;
>  =09if (virt_x2apic_mode_on && apic_register_virtualization) {
> @@ -5943,7 +5935,7 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
>  =09=09*val =3D apic_read(reg);
>  =09=09break;
>  =09case APIC_CMCI:
> -=09=09if (!is_cmci_enabled())
> +=09=09if (!apic_lvt_entry_supported(6))
>  =09=09=09return false;
>  =09=09*val =3D apic_read(reg);
>  =09=09break;
>=20

Applied, thanks.

Paolo

