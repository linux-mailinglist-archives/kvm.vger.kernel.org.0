Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8071A45B8D3
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 12:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhKXLKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 06:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhKXLKW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 06:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637752031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMB2sNUsa/0UAP4HkeCP25BsocK+xXuD+P0zzpx3vjI=;
        b=AqLqQpJRJqvk/Y6uehYF8uDPd/xxM0sUG2BJnnssyJ3lzfyvlRZtVlPI5RmM9divAXSqsj
        0+qofRjDEsco8asio8HLh1yZs8/R6S1Rdf9CLUpwckwkI5PHQeAxaKKWFOKASkaTngWPz5
        0ErN/PTuPbPvEviv1Wjp9HHJFZFKKU8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-sPTicXEbO_O3M0eosTZcBg-1; Wed, 24 Nov 2021 06:07:10 -0500
X-MC-Unique: sPTicXEbO_O3M0eosTZcBg-1
Received: by mail-ed1-f71.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso1979902edj.13
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 03:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aMB2sNUsa/0UAP4HkeCP25BsocK+xXuD+P0zzpx3vjI=;
        b=qhMVTakxP4feFdZGCDZBUGOeIwfE2jEkDqqbJhv3igjTVg/lRSdIHgrQTYwjE1bLFA
         vj97SO+ucds1mUmI8ehKM98QcHiliFLzUm5nmSDPseZGLL07sqrwraKfyW162o9+Aksi
         RqCDHFAUjhiB+kOBXEADBqa01X6Fox9zwuQWpWCmvTqFdZ9wyXsIK+CPFfez4Z2K+ykM
         amAdxEL+gP7vXFp3JQY5NPZ6H6Arc/tsuIJAkWNh/HHtzAXJU1EYx/4MBMt057G7oZP4
         lWL1LfNJwb9jbXv4kwr1gmKye+ACKjb+2rXZLeOjXEsOISsStihLoRt78OZ2arLySc+M
         Bylw==
X-Gm-Message-State: AOAM532USz69iEp/5GMxVwUPuoOmlfmW2FSNf7L5xbIVmAxEazb6QoBv
        pii2THxDVTZQH+DFTkiUCNJDzLgUbpgyy8C4I4Sq5e51vyydwHNl+D8aVwcc7JH6jaUIKAKYA/y
        07Csfh0zYBTGq
X-Received: by 2002:a17:906:398:: with SMTP id b24mr18897424eja.49.1637752022455;
        Wed, 24 Nov 2021 03:07:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/3AI7n2ydPSF4DuJUj9I55cNiYIR3/zfiBhnY+uMe5uwnnmEx4YLSqiw9/N8tZAOXWIQ/gA==
X-Received: by 2002:a17:906:398:: with SMTP id b24mr18897369eja.49.1637752022167;
        Wed, 24 Nov 2021 03:07:02 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id gt18sm6730329ejc.88.2021.11.24.03.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 03:07:01 -0800 (PST)
Date:   Wed, 24 Nov 2021 12:06:59 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Message-ID: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118184650.661575-2-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 06:46:41PM +0000, Alex Bennée wrote:
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  README.md | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/README.md b/README.md
> index b498aaf..5db48e5 100644
> --- a/README.md
> +++ b/README.md
> @@ -182,3 +182,5 @@ the code files.  We also start with common code and finish with unit test
>  code. git-diff's orderFile feature allows us to specify the order in a
>  file.  The orderFile we use is `scripts/git.difforder`; adding the config
>  with `git config diff.orderFile scripts/git.difforder` enables it.
> +
> +Please run the kernel's ./scripts/checkpatch.pl on new patches

This is a bit of a problem for kvm-unit-tests code which still has a mix
of styles since it was originally written with a strange tab and space
mixed style. If somebody is patching one of those files we've usually
tried to maintain the original style rather than reformat the whole
thing (in hindsight maybe we should have just reformatted). We're also
more flexible with line length than Linux, although Linux now only warns
for anything over 80 as long as it's under 100, which is probably good
enough for us too. Anyway, let's see what Paolo and Thomas say. Personally
I wouldn't mind adding this line to the documentation, so I'll ack it.
Anyway, we can also ignore our own advise when it suits us :-)

Acked-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

