Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8950947BDCC
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhLUJ6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhLUJ6X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 04:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640080702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWineNtXqbTJ5Et1Uv2T/Fd4TrSY33+kUANsK8qrVRk=;
        b=KQmXJNnWL6fuNsQrMXOj8CBt2NJM2UlclYwrbtL0WZJ3iHttmHxUcqLgPCoh+JCLdbFfsr
        jYAlokVCcIplt2Asw/PV1cHzm8Gxuxq4iuZztzAbDYXw/k4w4oau5UsXMTTp9E5CvdpK7e
        3TXl5Ok/vAVybm+ag5ubk0TZx68vZlI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-RnvHXf46NxqvCHBONGk6SQ-1; Tue, 21 Dec 2021 04:58:21 -0500
X-MC-Unique: RnvHXf46NxqvCHBONGk6SQ-1
Received: by mail-ed1-f70.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so5848886edc.18
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 01:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sWineNtXqbTJ5Et1Uv2T/Fd4TrSY33+kUANsK8qrVRk=;
        b=Qd1qPva83q5Wtx0eGn3FCBcBo5SVnaChEFU1xreDmFosyySEQCA5aRwdOLJ2Zc+Pph
         nScDhcNVPwIckGp6TgDs+Ze1hLg2hCqj3umT4j/7Ph6Mb7IwMoD4LFgGDI0LiN90LO9c
         mEJVVMEubr3CTJh0n3h0Q9T5UbcnLiJ1Drm37E/h+VhC50Oc+IESprwAgAcdS1mCgKj9
         t0flFp4r50Rvxb8f4v/SqcXCYa3iir79MkS77nLSoHBGHE6cowAPRjQNDFxUAwfQn3HJ
         EYnfIDrtNm+uq1xVUDzYYR43TNuMH5uN81tLOpo85GUpRzdzeRJMpusGFncJVs3RhKdI
         772w==
X-Gm-Message-State: AOAM531PWrDwQp85NKu67iZLLEo7PPL3y+vCoOIutdO4j+ddich7F3ln
        RbHuU92zGcKdngTRBflTDl6n/M+l3oVf1wn335hs9+vtg3iqfFBVT37odewFa7oDl+7DkwHjsFe
        29B/mPj4gCYlx
X-Received: by 2002:a17:907:1703:: with SMTP id le3mr1948179ejc.344.1640080700077;
        Tue, 21 Dec 2021 01:58:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4f4Fi/3ajjfBqudjvoNO4LlCY2Zi0M/IbSQaY5n0ZYQtqx6OOihln9DSBs6B59SLHKiWUkA==
X-Received: by 2002:a17:907:1703:: with SMTP id le3mr1948160ejc.344.1640080699808;
        Tue, 21 Dec 2021 01:58:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hc14sm3615121ejc.42.2021.12.21.01.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 01:58:19 -0800 (PST)
Message-ID: <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
Date:   Tue, 21 Dec 2021 10:58:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211221092130.444225-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 10:21, Thomas Huth wrote:
> Instead of failing the tests, we should rather skip them if ncat is
> not available.
> While we're at it, also mention ncat in the README.md file as a
> requirement for the migration tests.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
> Signed-off-by: Thomas Huth <thuth@redhat.com>

I would rather remove the migration tests.  There's really no reason for 
them, the KVM selftests in the Linux tree are much better: they can find 
migration bugs deterministically and they are really really easy to 
debug.  The only disadvantage is that they are harder to write.

Paolo

> ---
>   README.md             | 4 ++++
>   scripts/arch-run.bash | 2 +-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 6e6a9d0..a82da56 100644
> --- a/README.md
> +++ b/README.md
> @@ -54,6 +54,10 @@ ACCEL=name environment variable:
>   
>       ACCEL=kvm ./x86-run ./x86/msr.flat
>   
> +For running tests that involve migration from one QEMU instance to another
> +you also need to have the "ncat" binary (from the nmap.org project) installed,
> +otherwise the related tests will be skipped.
> +
>   # Tests configuration file
>   
>   The test case may need specific runtime configurations, for
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 43da998..cd92ed9 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -108,7 +108,7 @@ run_migration ()
>   {
>   	if ! command -v ncat >/dev/null 2>&1; then
>   		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> -		return 2
> +		return 77
>   	fi
>   
>   	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
> 

