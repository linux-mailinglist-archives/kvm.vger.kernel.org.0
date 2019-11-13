Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EA1FABDC
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 09:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKMIUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 03:20:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43302 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbfKMIUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 03:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573633244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=whJvieYSPZF3C0Ev7gvfZK1XEQG2EzzzHM80XB6g75A=;
        b=Bw70PeBZgNnnFEiAg4WDTsvZhpIoN4+p2i0WVtiArVYx2v8nBe2iMB4068sdE+jP/U8VKb
        56Wp8lNYsn+mwjR9fgqSkia92wCgMOcy0KH2KUi3/66AJqh3PokHhvn8+y42qM2p2kxWWz
        XKxY1JnOcpiv8vDBmQM6DsVoG7qeO0M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-v9mm87aGMoyokkCTiljjZw-1; Wed, 13 Nov 2019 03:20:43 -0500
Received: by mail-wm1-f71.google.com with SMTP id f14so807277wmc.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 00:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gRJtnCq+CKt1kPsmHkXPWnEtQz9JufgD24IWcr8duAg=;
        b=NkGPpPSicaWtHRqm0pll3B+GRylDTZ/lC2eujJuvSvAgJslqPlN9J8ZT2p/3G3l8Ko
         KsFObxPbPxgEXhBYm6KOp764URchnfogKUgKZy8OSrocOccalH+TBXwcTYmJ3glVFzSg
         P2XKLDbsKox/MUMf9KHGvmU0c6RgJbTSz5abAQPubVhQZk340Qqcx5aPAN3CJ0hDvsRG
         Jcjf1KidPZHjWJFWlr/+3VPLNFh2dJ+fBxgYK58w99pZG0tVv+rvlaeg3h4WV+r5P1+e
         oSSAwnVQCmp6j3t0HR7fUSPhmBh6taYpOF3r0LnyXVQNNMghfn+b4ksSoGgnR5pJEzUV
         M+nQ==
X-Gm-Message-State: APjAAAU5asP8b/FBlADwYCxa9hVkswl2uWiWxoCZzlVyZHvUAcO9muNf
        UBzK4DOvi6m71q+W092gFBdMUlB4k6xSVpIYvcEVwlXf7U4SsOEWqjog9yryC2qDjun/ghg+pFQ
        qnxin45So/y8A
X-Received: by 2002:a5d:4986:: with SMTP id r6mr1507902wrq.307.1573633241982;
        Wed, 13 Nov 2019 00:20:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvuhfthJLiZbIf7ASFW0EJey9TeYZbP3dIAq7chny/myshfoEZhQsu6Zyv9TB2AwA4sR/anA==
X-Received: by 2002:a5d:4986:: with SMTP id r6mr1507868wrq.307.1573633241635;
        Wed, 13 Nov 2019 00:20:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id 19sm2670309wrc.47.2019.11.13.00.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 00:20:41 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Reset the three MSR list number variables to 0
 in kvm_init_msr_list()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>
References: <20191113011521.32255-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <02a71740-a98d-622e-ee3e-705fe707c772@redhat.com>
Date:   Wed, 13 Nov 2019 09:20:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113011521.32255-1-xiaoyao.li@intel.com>
Content-Language: en-US
X-MC-Unique: v9mm87aGMoyokkCTiljjZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 02:15, Xiaoyao Li wrote:
> When applying commit 7a5ee6edb42e ("KVM: X86: Fix initialization of MSR
> lists"), it forgot to reset the three MSR lists number varialbes to 0
> while removing the useless conditionals.
>=20
> Fixes: 7a5ee6edb42e (KVM: X86: Fix initialization of MSR lists)
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8c8a5e20ea06..9368b0e6bf21 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5102,6 +5102,10 @@ static void kvm_init_msr_list(void)
> =20
>  =09perf_get_x86_pmu_capability(&x86_pmu);
> =20
> +=09num_msrs_to_save =3D 0;
> +=09num_emulated_msrs =3D 0;
> +=09num_msr_based_features =3D 0;
> +
>  =09for (i =3D 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
>  =09=09if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
>  =09=09=09continue;
>=20

Ouch.  Sorry.

Paolo

