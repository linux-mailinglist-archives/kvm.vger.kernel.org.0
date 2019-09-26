Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A669DBF0D4
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfIZLIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 07:08:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfIZLIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 07:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569496094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Vn5rtw7bFwtVsF25YPndZQSh4Su2suTuy5dFm4//+c=;
        b=U+UeesFPEaEzFA/pL9jLukijZHUHUwDnYwikBk3LqvRSMocsxcrczE6fzLCJkWlRXgt7fL
        WDKExxtJbJqgXMX99phUr75j1F9lRlfrkGjztSxTIJ9ZZPUo8vmOQlX7Yb4czy2qWNwAop
        /5OUq8rXn06lsYzdTnhwmVHMyepjie8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-IkYGIpACOVeTmDaNgCViTA-1; Thu, 26 Sep 2019 07:08:11 -0400
Received: by mail-wr1-f72.google.com with SMTP id l6so797285wrn.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 04:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2Kxm+ElnCWf5BcR8w3pGD9Nj6zwgfc6BpRAlws3Lcc=;
        b=HUzfhDCMf7YhCj+BJdMFNFOO92okjPS8MotVJ54n31bC7w4rgPeWnF/aXpv7N2P5nc
         YHRU4ptY6CQXO6da9y7HgHFmib40a6xSwzqdZ4qA9lkrdsaJhEWccbcKKUyICoKZCCTa
         a/9YvW4klpkSRJSSVTeoUdR16g/fBf7D621zkpqoUDLfcpHdOvg39Hln0XXXDQSyqzrk
         uFdWBvhv+2BIoCPjAi9U8YpnHN+Xp+akaw/hjgfvgFXd6Kup1N7rzr/xj8b1+6xOyB7M
         xGzqCSleK67pNW2p1Kn5cTLBg4QQVJuHj/LpX2d3zQ8oUOVr97I2U5zPyVytGmOTXMeP
         s4pQ==
X-Gm-Message-State: APjAAAWZ1c8URmHr1nC3mHBxekmNqo3tED3PWKqbWwnkvQeJwbYXVkCf
        lCkp+ABbxAV125RqVv3o8H92RQN8w8Klf7fAP7UD1xe/edYBaREwlGR/rZkbspBx1CEBSRAyek3
        bjs4kpjV9ji+l
X-Received: by 2002:a5d:620d:: with SMTP id y13mr2356579wru.86.1569496089699;
        Thu, 26 Sep 2019 04:08:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4i+DgU+ieuWUVVaqBkX69/VAu/LcDHi4ynTrxFaKpGTrXXm+6SZCWb4CC0HDIKRscSumS7w==
X-Received: by 2002:a5d:620d:: with SMTP id y13mr2356562wru.86.1569496089453;
        Thu, 26 Sep 2019 04:08:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h9sm2246080wrv.30.2019.09.26.04.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 04:08:08 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Enumerate support for CLZERO instruction
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20190924205108.241657-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4716e9e-c43d-8b70-f387-cf3dd27a8781@redhat.com>
Date:   Thu, 26 Sep 2019 13:08:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924205108.241657-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: IkYGIpACOVeTmDaNgCViTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 22:51, Jim Mattson wrote:
> CLZERO is available to the guest if it is supported on the
> host. Therefore, enumerate support for the instruction in
> KVM_GET_SUPPORTED_CPUID whenever it is supported on the host.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index dd5985eb61b4..787f1475bf77 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -479,8 +479,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_en=
try2 *entry, u32 function,
> =20
>  =09/* cpuid 0x80000008.ebx */
>  =09const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
> -=09=09F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSB=
D) |
> -=09=09F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> +=09=09F(CLZERO) | F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) |
> +=09=09F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F(AMD_SSBD) |
> +=09=09F(VIRT_SSBD) | F(AMD_SSB_NO);
> =20
>  =09/* cpuid 0xC0000001.edx */
>  =09const u32 kvm_cpuid_C000_0001_edx_x86_features =3D
>=20

Queued, thanks.

Paolo

