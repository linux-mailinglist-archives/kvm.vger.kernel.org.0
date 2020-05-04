Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30621C4001
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgEDQf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:35:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgEDQf6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zGQgxhZuStGNIik/5wRjRbyRSeqnbfltE4LxfFjoEOA=;
        b=TDTWH4Qd8u9MuyWnvLjt09JfkfV+Tpg7p7vum23YSYshx9gNY0R/93bR1cXfMSnp82GzYR
        Cf3sr5NFryTmrhIk26UeGNk4zXHoZWcWW8hVS9sTtyVWTBOqE0WNNwDIy4SNDleN4ZtANp
        gNXvcLRkUpD/SeGMug88sIbENBgd/sI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-UwNfzzReOXS9TJF-Jw8ung-1; Mon, 04 May 2020 12:35:55 -0400
X-MC-Unique: UwNfzzReOXS9TJF-Jw8ung-1
Received: by mail-wm1-f72.google.com with SMTP id u11so67233wmc.7
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zGQgxhZuStGNIik/5wRjRbyRSeqnbfltE4LxfFjoEOA=;
        b=ShMgl9OdmMLe/sjoZDI4Soz9YTPQhQzu+x7JsXVbOow3hE7gJONZvv9UwOo2qF6nt0
         NSqUHpJd4qYQBKPIjaAZQ4Onc/OLbES3d5sIXckkHdrY8HVheVpylV16AtOUIY3EdJdk
         2HdY75Ezk8PwVNF/9IM68iRhlcfqkGzSSR7jnwtFdbA/CToeuPWgtvEgavfb03W7LiA/
         rtXOOUO9J9XC1hZL8NsjMQouXMNYx8LfoUWJnaZR/fqrxL5fju9rTZ8CYn5L6QJsfezz
         nl2ct8L6NTvOxGM89I1U5Zcl9EuTxlU5vG9d2mU5RZzcPzwbTJx6qyb539g/wD4Qvw2p
         n5aA==
X-Gm-Message-State: AGi0PuYCKO2JwcxX5kiLceNkIplBnvffdGwFoekK8IZO0sh2VIt9+j1x
        /o93cIjg6LKglBBWJRBVsbyYEOpP8otkxdwobeuYebEf2TlS+DGu1yHGw0nrOV6Qex9Mf2JNvtl
        /Z/h6Z5n1DMfM
X-Received: by 2002:a5d:5082:: with SMTP id a2mr160602wrt.224.1588610154552;
        Mon, 04 May 2020 09:35:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypIp2UyN429DvfosgwsSLLhqzlALwieFhFzafW/enJ4dikF9voaJRJ8nPBD2lIZrSuvupZ/lFQ==
X-Received: by 2002:a5d:5082:: with SMTP id a2mr160582wrt.224.1588610154317;
        Mon, 04 May 2020 09:35:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id j10sm15302138wmi.18.2020.05.04.09.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:35:53 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] svm: Fix nmi hlt test to fail test
 correctly
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200428184100.5426-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <811b4acf-1356-1b82-edf3-29e73d2ed9d3@redhat.com>
Date:   Mon, 4 May 2020 18:35:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200428184100.5426-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 20:41, Cathy Avery wrote:
> The last test does not return vmmcall on fail resulting
> in passing the entire test.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/svm_tests.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 2b84e4d..65008ba 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1480,6 +1480,7 @@ static void nmi_hlt_test(struct svm_test *test)
>      if (!nmi_fired) {
>          report(nmi_fired, "intercepted pending NMI not dispatched");
>          set_test_stage(test, -1);
> +        vmmcall();
>      }
>  
>      set_test_stage(test, 3);
> 

Queued, thanks.

Paolo

