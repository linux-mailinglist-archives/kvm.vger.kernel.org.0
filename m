Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57683139EC
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 17:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhBHQop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 11:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233293AbhBHQoQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 11:44:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612802569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7MuC7Jwkl57x1+CxiVPfsXtfPznnSoGp/kfJp/TYRg=;
        b=WrBpnAZiuWhK4MT7HQYAhQpv0OHdH1DwPI0EZbVma/HcGYI3sjvnShlaU5rlksU8/6goXp
        D0/54xCmVZgKPVxCF0UPdlww90+go8OCfssbIVwk2Of4GLtDOhFuYZ02zhVt34zCr7zXlF
        ozmkzTauCldvx2/R9nk7eecPwIqJZeg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-4tPa5cdgO9qZA8i-UPWpKg-1; Mon, 08 Feb 2021 11:42:45 -0500
X-MC-Unique: 4tPa5cdgO9qZA8i-UPWpKg-1
Received: by mail-wm1-f71.google.com with SMTP id 5so6836880wmq.0
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 08:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O7MuC7Jwkl57x1+CxiVPfsXtfPznnSoGp/kfJp/TYRg=;
        b=NBNJBfvad3XW2/xguWfioSpcibOURgZf3l5Lc9+X8VaFCurJlD6kqqx1FlFVU9QUy2
         VR5WyNkSNSTI+hGfz8e/LxR6Gr85OBY08WuVZ0uvZB/NgLxnAH2eDCLWYCWlvH6ZbBqO
         sx6hxClHbuMUbUwzxUF1NlE1HyFib046+chN+5hGEHGCh1p+fbbY5gLJY54LbhyKBl0X
         hIb0y2PLGsaJR1Zs+NOocKp6AbOrJ+KsnRqr0y6o41hHQ2PRPh1kAfB7u0cCZJJeBBfe
         kAcGLz1xkSGx6ikgh2zxCW3WAzDyzhC01S0JyZkl0Geuc5S6FLEqN1GCFLP+WLOxqPFG
         q87g==
X-Gm-Message-State: AOAM53365sJjwSRSZiAugZpKBjal2L737O9vgjQgH4in1a3t8om76Wr7
        1z2+8EOTz+r6jo3YkIIztzxFhGH5s+lOZ9VphLaGBHELkD/RMJxYsfS2BJ14ZjYXkTnl/kgQcVU
        4JtqZAjc+HF5t
X-Received: by 2002:a1c:7718:: with SMTP id t24mr6652058wmi.155.1612802564097;
        Mon, 08 Feb 2021 08:42:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw592oqZpHMrIE8oOsGnSF0aGruWMgXdgjXteMUQyY/QX0DWqI37CKVc6/KU3DV8JUqrMsGsg==
X-Received: by 2002:a1c:7718:: with SMTP id t24mr6652033wmi.155.1612802563776;
        Mon, 08 Feb 2021 08:42:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s10sm5068778wrm.5.2021.02.08.08.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:42:42 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Add new s390x targets to
 run tests with TCG and KVM accel
To:     Marcelo Bandeira Condotta <mbandeir@redhat.com>, thuth@redhat.com,
        kvm@vger.kernel.org
Cc:     Marcelo Bandeira Condotta <mcondotta@redhat.com>
References: <20210208150227.178953-1-mbandeir@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad7f7f42-9be4-43b3-95c6-edff7c0b534c@redhat.com>
Date:   Mon, 8 Feb 2021 17:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208150227.178953-1-mbandeir@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 16:02, Marcelo Bandeira Condotta wrote:
> From: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> 
> A new s390x z15 VM provided by IBM Community Cloud will be used to run
> the s390x KVM Unit tests natively with both TCG and KVM accel options.
> 
> Signed-off-by: Marcelo Bandeira Condotta <mbandeir@redhat.com>
> ---
>   .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index d97e27e..bc7a115 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -155,3 +155,31 @@ cirrus-ci-macos-i386:
>   
>   cirrus-ci-macos-x86-64:
>    <<: *cirrus_build_job_definition
> +
> +test-s390x-tcg:
> +  stage: test
> +  before_script: []
> +  tags:
> +    - s390x-z15-vm
> +  script:
> +    - ./configure --arch=s390x
> +    - make -j2
> +    - ACCEL=tcg ./run_tests.sh
> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     stsi sclp-1g sclp-3g
> +     | tee results.txt
> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
> +
> +test-s390x-kvm:
> +  stage: test
> +  before_script: []
> +  tags:
> +    - s390x-z15-vm
> +  script:
> +    - ./configure --arch=s390x
> +    - make -j2
> +    - ACCEL=kvm ./run_tests.sh
> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     stsi sclp-1g sclp-3g
> +     | tee results.txt
> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
> 

There is still a problem, in that every contributor's CI runs will mark 
the s390 as job as pending.  I think you should use variables to enable 
these tests only on forks that want them.

While at it, I agree with Thomas on testing {clang,GCC} on KVM rather 
than GCC on {KVM,TCG}.

Thanks!

Paolo

