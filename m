Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E4424FCE
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhJGJPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:15:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231661AbhJGJPP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633598001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6xWksNQxoEXfwg6tFpy/wzo4JRJNCvclfH22DUGY4E=;
        b=KkwylZvsvdLs9aWRSqQ+sjTtykc13hgDBdVMRqojCEJJcxx+zRHa4Q3Ro6eOcxBNLUiAPU
        4KhXjrl4ibNFsAVuw0CuupgDZexUkLKxeS6tjLzuMqgd5MhngHm0yDNcwwAekgLX5kHZTL
        PMjLOFYs3kw9HYkgxvvWefND/dxJXcs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-xPq36TxAPOCb_oQooq_XxQ-1; Thu, 07 Oct 2021 05:13:19 -0400
X-MC-Unique: xPq36TxAPOCb_oQooq_XxQ-1
Received: by mail-wr1-f71.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso4151552wrg.16
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 02:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p6xWksNQxoEXfwg6tFpy/wzo4JRJNCvclfH22DUGY4E=;
        b=mEnMy627PEVXZTRVQCnSBj40DsOtjw1NLDiU0qHea/6L8jwO/Mloyc9qZak04OIg2r
         vifqhaGsGemo+blMt6EIrG1X1AHH6a/BsWuS57gNrQVJfHv+L4W/JhCp1F4gqyJP5bIF
         m4/pUCjuKKWOdjKf2ugiMALXLpcWgMrSHo7CKCDFyvk0rqtu9hhPe9NabfhJNe6ZiGcw
         +FgYjpjlTt3YCz/oyZCnRV0bLQSm+kKGlBpR8X4aZH9/NdtEEF/a3+bcqZP5/ZElWIYu
         SPQAhwPlWNYhGqVd9n5W0y5kb5uPHEjkYhr30caELfr8r0bNr53+496a6Ny8pqyBw3Qr
         xbig==
X-Gm-Message-State: AOAM532TccN1Zu9jpMY6WSia3AqS2XZonV7GIYV/AeC/7LDaKK0Crt/x
        gwKUdIGNGsDNd/mQC9WmEgzQaJnXCrDy7kfwX80qjrWiA3TQDrPIdZHEL5AH9pPoOYRH51Zjr4Z
        nAuB1CEDPckuR
X-Received: by 2002:a05:6000:1681:: with SMTP id y1mr3785916wrd.340.1633597998116;
        Thu, 07 Oct 2021 02:13:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPzCotQqXgoiOprZwOPA4N5NmPi1N04Ol14kHOuwFWyEINDsoKzDLuPf0JZUMGzKHSwWR/jw==
X-Received: by 2002:a05:6000:1681:: with SMTP id y1mr3785892wrd.340.1633597997949;
        Thu, 07 Oct 2021 02:13:17 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id r18sm17528012wrs.47.2021.10.07.02.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 02:13:17 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 8/9] s390x: snippets: Set stackptr and
 stacktop in cstart.S
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-9-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <39c39816-146e-6715-fe22-0f56bd943d6f@redhat.com>
Date:   Thu, 7 Oct 2021 11:13:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211007085027.13050-9-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/2021 10.50, Janosch Frank wrote:
> We have a stack, so why not define it and be a step closer to include
> the lib into the snippets.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/snippets/c/cstart.S | 2 +-
>   s390x/snippets/c/flat.lds | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index a1754808..031a6b83 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -17,7 +17,7 @@ start:
>   	xgr \i,\i
>   	.endr
>   	/* 0x3000 is the stack page for now */
> -	lghi	%r15, 0x4000 - 160
> +	lghi	%r15, stackptr

I already wanted to ask you to replace the magic value 0x4000 here ... great 
to see that you already did it :-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

