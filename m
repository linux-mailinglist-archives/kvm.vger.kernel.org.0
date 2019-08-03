Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6400380490
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfHCGDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:03:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50638 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfHCGDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:03:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so69906589wml.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1Bg7pHVRZHFAIlglq7EJltjZN0ovjw/td6NGQCcl24=;
        b=sLar0wpKOYOFxChLFpffFVBePBJWLsadbMEYb+QxLRP88gWUqk9qaYdozlvUQSGxjA
         wYIuGwkO+YHhyFW2qsdzEgw2XKRvdukdCUpx54QP5RJpcfIVksEO67+1oIHQ5JcYWPkI
         aiICTb9ljipF7L+qYdti6wPmksAWAU9BvdP4KXdAM241Hl+KtOU9/psm7BDRwGfLchHA
         Ybdd7wqurk+q8rqudIfixUCv0/TwBR82stAUl/+tmX6H5usXmO2e+1QTb/+EPUrn4fiR
         7RKtuVGLexXtn5HMGM2tghnUJeVqSZuL3ywaxIu0UkpDN1rzyBVFmaKdRfm+DJPwrZTQ
         aYhQ==
X-Gm-Message-State: APjAAAWybAO8dKz8cnmpxAJBxSule/cqdDIvv4EL1Zttf5BMBd6udC7/
        zZwURUJXx2SmVgWO8r5TCK4mZw==
X-Google-Smtp-Source: APXvYqz5a01CMllxqdzGgPoACQ+37QCcaKarUxj3ZZwq005RfxFUYDLJnKSjixfp55XQ79bozzthUQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr7819593wme.177.1564812202139;
        Fri, 02 Aug 2019 23:03:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id c30sm146927959wrb.15.2019.08.02.23.03.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:03:21 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Force GCC version to 8.2 for compiling the
 ARM tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Drew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu
References: <20190730121056.5463-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e9db8130-0215-9aba-5687-c23b1128d8e5@redhat.com>
Date:   Sat, 3 Aug 2019 08:03:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730121056.5463-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 14:10, Thomas Huth wrote:
> The kvm-unit-tests are currently completely failing with GCC 9.1.
> So let's use GCC 8.2 again for compiling the ARM tests to fix
> the CI pipelines on gitlab.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index a9dc16a..fbf3328 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -17,7 +17,7 @@ build-aarch64:
>  
>  build-arm:
>   script:
> - - dnf install -y qemu-system-arm gcc-arm-linux-gnu
> + - dnf install -y qemu-system-arm gcc-arm-linux-gnu-8.2.1-1.fc30.2
>   - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> 

Queued, thanks.

Paolo
