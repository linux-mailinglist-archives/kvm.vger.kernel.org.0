Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7C14845FA
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 17:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiADQdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 11:33:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229984AbiADQdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 11:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641313981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzZrHzekcrvRX006y/Gm8rTUUV9sSFe7cbZaHfBSLqg=;
        b=hVyVuwtUhR4QNtEueLFk+b8In4kdphwrqaTSDGsQNel79qDrspx6yc5gNKMhg++6Yre345
        VT13L6wKKvIADweMBzE+KN2CsVLetgrcfY/UTzPvYXo1OoRF4G7ijleQ6RHZfwApU/e0Dg
        5vxoa/qWSFXxzBv31ahdqsp2nSgkQzE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-pine5CoJON2i0yoYhBdGug-1; Tue, 04 Jan 2022 11:33:00 -0500
X-MC-Unique: pine5CoJON2i0yoYhBdGug-1
Received: by mail-wr1-f71.google.com with SMTP id j19-20020adfa553000000b001a375e473d8so3422133wrb.4
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 08:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tzZrHzekcrvRX006y/Gm8rTUUV9sSFe7cbZaHfBSLqg=;
        b=iGX9crvX+eSVRdXZyDTohws4YHZNuv9t/oK8zO4L4Ma+IuruqR9uQxzV+Tlau07sSU
         xBYVl5ajlBNYT0Wn9zBywBZiiqwXUTLA3MBxfGfGHnGLp/tTG8Zgl5kEmxjMsaEV0R65
         yZ9vSztL0gM4ILVVu+/nFo0ZvJkmxiSxvVshZB5dQhS9Qkwdyw49fo5ZmFQ0asRiTvxN
         ohnC9xdlNIbqjWYV433B2i8xeHF/YMHeq+m4Yh6lPygf5oPhIQlf6Nt7/VoXhr1uySYO
         cXUU743W4Py0wTMeB38eXMmANNDoVGyGJ3bQOgQNX9MsUz5hF8rhAfShXrWQNPnUgNL8
         Vi1w==
X-Gm-Message-State: AOAM531LXnQYyTrdueaRHaGaacrzvFK6pK3pDrE3xT7QtKcXstL4DKet
        B94qywCp8PxBgCLv/Z3p78rgYhYSZbm33zhZAoRMbqHfuOIq74dqPpSbWl97nMROd7FnNVYDP1e
        FWGYuapv6vEDzXP4pQ29Edt56jw6oP/MsmHUq++51y9aP4DrXRt4HT/6paoyakWiL
X-Received: by 2002:adf:d0cb:: with SMTP id z11mr43499826wrh.470.1641313979126;
        Tue, 04 Jan 2022 08:32:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydR36rOEJz/kKdK6YEmU1gonpIfUL0n4Y/d/fq7dJDFrjtLzcP+ca6deofwJ0vw6WX7z6lWA==
X-Received: by 2002:adf:d0cb:: with SMTP id z11mr43499811wrh.470.1641313978883;
        Tue, 04 Jan 2022 08:32:58 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n1sm41002268wri.46.2022.01.04.08.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 08:32:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kaya, Metin" <metikaya@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in
 checking SynIC timer support
In-Reply-To: <1641300662336.87966@amazon.com>
References: <1641300662336.87966@amazon.com>
Date:   Tue, 04 Jan 2022 17:32:57 +0100
Message-ID: <87wnjfpikm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kaya, Metin" <metikaya@amazon.com> writes:

> This commit fixes 69d4bf751641520f5b2d8e3f160c63c8966fcd8b. stimer_suppor=
ted() should use HV_X64_MSR_SYNTIMER_AVAILABLE instead of HV_X64_MSR_SYNIC_=
AVAILABLE.=E2=80=8B
> From 3e31f7d2b7bfc92ff710e3061b32301f96862b8b Mon Sep 17 00:00:00 2001
> From: Metin Kaya <metikaya@amazon.com>
> Date: Wed, 22 Dec 2021 18:22:28 +0000
> Subject: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in chec=
king
>  SynIC timer support
>
> This commit fixes 69d4bf751641520f5b2d8e3f160c63c8966fcd8b.
> stimer_supported() should use HV_X64_MSR_SYNTIMER_AVAILABLE instead of
> HV_X64_MSR_SYNIC_AVAILABLE.
>

Fixes: 69d4bf7 ("x86: Hyper-V SynIC timers test")
> Signed-off-by: Metin Kaya <metikaya@amazon.com>
> ---
>  x86/hyperv.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/hyperv.h b/x86/hyperv.h
> index e135221..f2bb7b4 100644
> --- a/x86/hyperv.h
> +++ b/x86/hyperv.h
> @@ -190,7 +190,7 @@ static inline bool synic_supported(void)
>=20=20
>  static inline bool stimer_supported(void)
>  {
> -    return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNIC_AVAILABLE;
> +    return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNTIMER_AVAILABL=
E;
>  }

Unrelated to the change but I'd suggest renaming stimer_supported() to
hv_stimer_supported() and synic_supported() to hv_synic_supported().

>=20=20
>  static inline bool hv_time_ref_counter_supported(void)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

