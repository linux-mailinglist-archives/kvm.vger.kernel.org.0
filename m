Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB2BC9AC
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436616AbfIXOC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:02:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfIXOC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569333775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bP2Vy3Y0XVxX9FTorht+y1dIL7GMkyc6j3T3AlgityY=;
        b=fF82BqIHuNNyErXR9WEfyIRUV9lRLoqr/p/RVlC5fwYFRddQaifIVYx2pg7bzVMRbfxOBP
        GzUUxsCCFdN7yQp+Gx3h0ywWyDnx8zUoLdnAqlS1+VLN5qNgTImtWWVTwaYNAJhibA7Lc+
        vh13AYRM4rfml+VUr4KZg7A16EOj7Jw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-QIxgwJAANqapfnUAvz1CGg-1; Tue, 24 Sep 2019 10:02:53 -0400
Received: by mail-wm1-f71.google.com with SMTP id l3so55107wmf.8
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xpZyfbYCQ7JofJK60h+7fGnO91mzXLEeT0JEXVzqH8M=;
        b=soU0PxHU8axYnOCOWggZ8mH87desMy+hXQL6LwzZGZS9KlsXeiTjx0Pn2+z+5KDlHi
         7HNPJA85dSWnm4dmopTykGDsPToKbvtHMZ9CFj9aiKoaTEMIaAzTGjUG8+07F/CWW0lM
         l33tfpL6y1ZNwMEZcZW5aKTnFgz/dskuD0Iv5z6Eomvw0D464kjs7AZK/j1oNBS+wIKI
         URsRxZbvYSUxdmm4sXuDDluUDal/uyy4htGPFXglLX1tirlq35xEqb1bFLTV+wcnyy3U
         SJDqBzKFc8YYvWLzO71cf80bJBnpw71Wa04byu8DTOhCO3R8H0atIqU/Hu+XvEZMyJ1j
         uAbA==
X-Gm-Message-State: APjAAAVWu06ncz1G3Q+qgqIigXrc9Hzyn5gC/e29BqG3VmFORCAcuT05
        2vCtFBpVdxvZIgtaTmlLT7qKh0WRNK+I4d90MAfbbjUvl6MF+kjzBXjlqQ28j+SPvfqQv/nkA2l
        5UlITpzJkQM7i
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr219599wmj.6.1569333772154;
        Tue, 24 Sep 2019 07:02:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyGJ2szZrZyDvWDC1O3UbOneRyOelgPrOCervrfQKd0laB0pn9Aq8xV/mNjupAWCVlfWdVDLQ==
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr219546wmj.6.1569333771708;
        Tue, 24 Sep 2019 07:02:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id l13sm112501wmj.25.2019.09.24.07.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:02:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: remove memory constraint from "mov"
 instruction
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
References: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <143a8238-02fb-b058-ef17-cfd90bbaf0cd@redhat.com>
Date:   Tue, 24 Sep 2019 16:02:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: QIxgwJAANqapfnUAvz1CGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/19 23:19, Bill Wendling wrote:
> The "mov" instruction to get the error code shouldn't move into a memory
> location. Don't allow the compiler to make this decision. Instead
> specify that only a register is appropriate here.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/x86/desc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 5f37cef..451f504 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -263,7 +263,7 @@ unsigned exception_error_code(void)
>  {
>      unsigned short error_code;
>=20
> -    asm("mov %%gs:6, %0" : "=3Drm"(error_code));
> +    asm("mov %%gs:6, %0" : "=3Dr"(error_code));
>      return error_code;
>  }
>=20

Queued, thanks.  (With fixed commit message).

Paolo

