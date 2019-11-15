Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A609DFDC72
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfKOLnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:43:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25474 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727183AbfKOLnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:43:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573818194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rulHLF9RYccZR87NRAA/+AbRPCJmMl0IDMx4SVUWbYw=;
        b=NU859P1orlda88x6iYdovmxREoLpnUtcTxZyOGSecsH2wtiTIKUQl33iZdvrW7e69fvgfq
        IJMB2R48zYUWyDi+nlHLlzXs6jIIQJsz8URXW4q3c3/IRoXnZoeIZaZMM7D5AXp1Gz18jq
        8kPI+3vtgzV2vtlmloqmm6y93jIhUuY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-7CnyIN8LNiaNBCCRCgaV-w-1; Fri, 15 Nov 2019 06:43:10 -0500
Received: by mail-wm1-f72.google.com with SMTP id x16so6774870wmk.2
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 03:43:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nArJyzxWi85uH1IMfCIsflaa68h1BibF5Tbbypa0d+M=;
        b=DYo2vGWNBSvBFsUwMIaOYfN1+E2+5jbM1KsXKNaZnzGMOXazrwhJs2UlYrKCFnujnp
         AoIHMkjB5sbuoaChf3jDcTB7rhikb5gOj04B1eMUFV0Wnpf3STvVfZ/tiQpecKU5FleM
         mtuKBPeAtXI0nug2GiGOozUczrjmJ1jNJySssPEkiYDuwKuC0Kb/SP/exua/uxX8HGx8
         yYd+ZUi+B6QqwTdFaLdL9M37BhJAJQ7aAsjrvLEfuXQpZ+RQvVySys1Q4MRQ9BrAJR6k
         GGv3At0SOVT7wFCtsggTXIRcSAm2iVGPjixv02EqTOL7r4gY+xfYeynaY2I/l2LN+TrP
         +/fw==
X-Gm-Message-State: APjAAAVJVFEvtXIUorMZ0IBEcyMu2iUG0pHYMzeR9VfNeqIU0knTyZ4Y
        t5gsK79yzd8Lyp+kNA55yT6f1mcZAkyg1SlBhTJ891KSzrrAyZcdg4cghUqD+AaxynAgryYYXwm
        HVAo//OjyU17V
X-Received: by 2002:adf:9d87:: with SMTP id p7mr14320756wre.11.1573818189537;
        Fri, 15 Nov 2019 03:43:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhwUII/AsG27ut1OmQr9xP/Yw9ZLfky4zMuNbWiWtGh+nqxvBwz850OxHa0pB2sqHRWA7PWw==
X-Received: by 2002:adf:9d87:: with SMTP id p7mr14320731wre.11.1573818189252;
        Fri, 15 Nov 2019 03:43:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id j66sm8595719wma.19.2019.11.15.03.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 03:43:08 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86/unittests.cfg: Increase the timeout of
 the sieve test to 180s
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190923111210.9495-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cfc265da-c635-39a2-2c1b-b78f3689f12e@redhat.com>
Date:   Fri, 15 Nov 2019 12:43:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923111210.9495-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: 7CnyIN8LNiaNBCCRCgaV-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/19 13:12, Thomas Huth wrote:
> In the gitlab-CI (where we are running the tests with TCG), the sieve
> test sometimes takes more than 90s to finish, and thus fails due
> to the 90s timeout from scripts/runtime.bash. Increase the timeout
> for this test to make it always succeed.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  See for example this run here where it took more than 90s:
> =20
>   https://gitlab.com/huth/kvm-unit-tests/-/jobs/301407814
> =20
>  If you don't like the change in unittests.cfg, I can also tweak
>  the (global) timeout in .gitlab-ci.yml instead.
>=20
>  x86/unittests.cfg | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d..e951629 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -172,6 +172,7 @@ file =3D s3.flat
> =20
>  [sieve]
>  file =3D sieve.flat
> +timeout =3D 180
> =20
>  [syscall]
>  file =3D syscall.flat
>=20

Queued, thanks.

Paolo

