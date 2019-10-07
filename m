Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EBBCDE86
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 11:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJGJ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 05:56:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727347AbfJGJ4j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Oct 2019 05:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570442197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGCddKS718FipsNyp6Li0RaGymGo1SIlI0BWkQKGgdk=;
        b=RAaekNza/Y5pwbfBEtFlBIE6wUSbmGfqZ+8U1yuT9cKk0tGN3Sh3IoiV7Bx6QlYyFThOVx
        tl29aW5VSsN14+85DO7gjSdTBUfVAWhrkR2/LKAA+5Ch6SHKCTnvCausqPI43e/+zocKOn
        GkhF/JsP5kBy05hPl4z1nWL8/1PXkAk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-OzOJIsdyMsihvVyZ5KZGsA-1; Mon, 07 Oct 2019 05:56:35 -0400
Received: by mail-wr1-f72.google.com with SMTP id j7so5487510wrx.14
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 02:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=urt/KbjJhYcqSFQ63RnNBAJj2B/Our2AbfxPZ2gH52U=;
        b=at6ACvRriEltBCqk/wnc/gkwEGy7IYrD9gjm116vdLVFaUy1mB80Sa0eXpXYN1VEF4
         TLzo7KMMRpe3KQot3byN0oIEbZ8Q/JUdmgXF++tgYoc3HbEKTrNYY3UcMOMoxKnyBu3E
         CKRtGTXM7Sj9amjls7szbBvwk0EUhw6F/i3EOGUsdA3CP6oGKaSpgupegg3YjDaKY9Br
         I1RSgEw037wsdnIFPnO8SGcbw2vH+gVl5AIgSwKC+Q2lDbIVPitRyjRtWBKmuO5PVgF1
         IoKd1/nqB72C7CmTGlzpLWiuuvhVM4q3B/kDtNRSN+9s+Lzsp5oMviMrUu+LjrgbezZj
         285g==
X-Gm-Message-State: APjAAAXIr0BmFjfu0uapuWuqheONa4HVyy6W/oNTOGFyKt0ZkTe5ChMT
        tVaK7EUaqUA1ZVfldDAk9YlKOdln+TaRRtCMwEOpBT3qvPGeS9wTLMJfcpqgm74HGZciccnX+fi
        6WqVf1eT9SeUA
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr16747232wrr.11.1570442194415;
        Mon, 07 Oct 2019 02:56:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/QTDsxrozaHomcYJqEjutSznmkT5BmfHMBnH0Ov6V8bBAITHDVDRdMgzoANgHUE4PNehwPw==
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr16747218wrr.11.1570442194188;
        Mon, 07 Oct 2019 02:56:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id l11sm16433892wmh.34.2019.10.07.02.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 02:56:33 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20191004202247.179660-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c562a64d-baf3-42f6-3a97-0dc0a5918127@redhat.com>
Date:   Mon, 7 Oct 2019 11:56:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004202247.179660-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: OzOJIsdyMsihvVyZ5KZGsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/19 22:22, Jim Mattson wrote:
> When the RDPID instruction is supported on the host, enumerate it in
> KVM_GET_SUPPORTED_CPUID.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9c5029cf6f3f..f68c0c753c38 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -363,7 +363,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_e=
ntry2 *entry, int index)
> =20
>  =09/* cpuid 7.0.ecx*/
>  =09const u32 kvm_cpuid_7_0_ecx_x86_features =3D
> -=09=09F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
> +=09=09F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>  =09=09F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  =09=09F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>  =09=09F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
>=20

Queued, thanks.

Paolo

