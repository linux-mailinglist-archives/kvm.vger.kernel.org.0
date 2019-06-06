Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB53740D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfFFM0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:26:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37406 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfFFM0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:26:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so2230364wmg.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lCZt6V+Z6/2zzGaZJTNPQxfv/WSUvfvsaL5Q5JEq4KI=;
        b=kBGkaDBKq4oyidMY/6osbQ+YcggVZgJXm2K1u2oyX8B+yxQJDFQ+JR45eCEYq95fJc
         rN+P1+FdXoM2J/NvvWEGnIVtYwKeOPJU+64YF4dxVziMKSRg4uw45527geG5eovvfuol
         d1+VwRv8A4w46+EElEWA+YXlCJSnPbisUhlOES7BPaPbXCGQl7Y5JFBPn25gcIC458xu
         TfimXRuLJBUZJw+OBCuG0CVliZJ6VUf8BAmxhjrixVlsi7HkpueppqBtk49YyeijOI3t
         dvBOCnsdhkCpqunE/BuIWQI5Who9OpMRlZeTQf+k48pDcl0lSvAvqKmNbj0/l1+X1Ca+
         phvA==
X-Gm-Message-State: APjAAAUjsdHFRdhP9jvgvfVKc90MXBluj04WKQmF/wPDGfX/05J42aVa
        qjiIKi6soFuYbftqv3p5xHy9WJcFHJM=
X-Google-Smtp-Source: APXvYqx885bBkiL+bydPJ5Y7QpjylH/mqjqHJj+amnpJP2yVUv8b9Mt/7cEYxRFcz6Ybvjea5ZWH0Q==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr27261398wme.177.1559823998566;
        Thu, 06 Jun 2019 05:26:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 65sm1942627wro.85.2019.06.06.05.26.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:26:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Remove xfail in entry check in
 enter_guest_with_bad_controls()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190520095516.15916-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bdc2e93d-ede8-4dab-981d-95e0a9a0558b@redhat.com>
Date:   Thu, 6 Jun 2019 14:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520095516.15916-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 11:55, Nadav Amit wrote:
> The test succeeds in failing entry. This is not an expected failure.
> 
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index f540e15..014bf50 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1833,8 +1833,7 @@ void enter_guest_with_bad_controls(void)
>  			"Called enter_guest() after guest returned.");
>  
>  	ok = vmx_enter_guest(&failure);
> -	report_xfail("vmlaunch fails, as expected",
> -		     true, ok);
> +	report("vmlaunch fails, as expected", !ok);
>  	report("failure occurred early", failure.early);
>  	report("FLAGS set correctly",
>  	       (failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF);
> 

Superseded by commit 74f7e9b ("vmx: introduce
enter_guest_with_invalid_guest_state", 2019-04-18); thanks anyway!

Paolo
