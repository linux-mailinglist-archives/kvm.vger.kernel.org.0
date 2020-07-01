Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2851D2106B8
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgGAIvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:51:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbgGAIvJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 04:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593593467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VNQywQ4WULmvG5XJASmUxhfJNh3Bpzu0ny98FqLsuk=;
        b=Pttcv8M9iIlP3WHtqOqWnEthgUxBYp8iN/GALQitgufKr8b/QpJFTM5fY56EP+Y8hpiLcR
        B4NLEoitD3UoWiFGr0xvNxjm6VNLSCN78bnWmLXZUb0pboWd0TyeOH6cpulJWwMrt83xUK
        Hw6YvrM3WrskK+VeqTQbBRkOk3h4Z/w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-fSEUZtFUOlSECFk7wlrOwQ-1; Wed, 01 Jul 2020 04:51:06 -0400
X-MC-Unique: fSEUZtFUOlSECFk7wlrOwQ-1
Received: by mail-ej1-f70.google.com with SMTP id b14so14208391ejv.14
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 01:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7VNQywQ4WULmvG5XJASmUxhfJNh3Bpzu0ny98FqLsuk=;
        b=Dr3WG0W8UOx3VRzTTJeJlW6vCDUb82AjqNiCtDU45rb7VuJiS38ZVxfZuzlFEPKvgP
         ffzZyUCxzZyUl/cBrjCmzzLRvTJa4+vQkN7UOU/zkFFdT4BDlToxGz6K0isOaEtm2Mt8
         W0iF6vhQw/5wIvDERREQBBJWtmmqu/m/wW8J6q2/038NaaFzWXFayCM3+W4vx+tkko+e
         7wEcxb/Qfh5mGL4S5719soI9Qzk5yOx6VbDC7ZXF1iYXqqhcYMgSNyhLPEZs+F5pOhB9
         LwW9QjNhRQ+8kaogX82g8NGZZKjjoqEZBt703V8xXj2JevlgjAHhnlWzsZDyBRxrZIlT
         ABPw==
X-Gm-Message-State: AOAM5315BE1ROf5OWYdtR7mHGsYf1bSymmtRznelVnhNguG5dMgQ1y0C
        bmksZOc9aDn3Qzc6/bl7SXOLyck/T4AcQQ4sjEs4oUM+kxjPKKyoVLpfDboDkTfyyv8U+dJfb0B
        YJpeI/zQ8IM1s
X-Received: by 2002:a17:906:35d2:: with SMTP id p18mr22924999ejb.393.1593593464949;
        Wed, 01 Jul 2020 01:51:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSG1SxV9LNm00jpW3vWYbuZ97Hrer23zo2O7oCAGyecirVUpQT5PffbZ/+cfuq6y+H8w4EUQ==
X-Received: by 2002:a17:906:35d2:: with SMTP id p18mr22924979ejb.393.1593593464700;
        Wed, 01 Jul 2020 01:51:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1? ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id cq7sm5469069edb.66.2020.07.01.01.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 01:51:04 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] scripts: Fix the check whether testname is
 in the only_tests list
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
References: <20200701083753.31366-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11b56d2f-e481-8951-69ea-8400f1cb7939@redhat.com>
Date:   Wed, 1 Jul 2020 10:51:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200701083753.31366-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/20 10:37, Thomas Huth wrote:
> When you currently run
> 
>  ./run_tests.sh ioapic-split
> 
> the kvm-unit-tests run scripts do not only execute the "ioapic-split"
> test, but also the "ioapic" test, which is quite surprising. This
> happens because we use "grep -w" for checking whether a test should
> be run or not - and "grep -w" does not consider the "-" character as
> part of a word.
> 
> To fix the issue, convert the dash into an underscore character before
> running "grep -w".
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  scripts/runtime.bash | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 8bfe31c..03fd20a 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -84,7 +84,8 @@ function run()
>          return
>      fi
>  
> -    if [ -n "$only_tests" ] && ! grep -qw "$testname" <<<$only_tests; then
> +    if [ -n "$only_tests" ] && ! sed s/-/_/ <<<$only_tests \
> +                               | grep -qw $(sed s/-/_/ <<< "$testname") ; then
>          return
>      fi
>  
> 

Simpler: grep -q " $testname " <<< " $only_tests "

Also, please do the same for groups in the two "if" statements right below.

Paolo

