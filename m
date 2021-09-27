Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B429419D55
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhI0Rsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:48:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236962AbhI0Rsn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 13:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632764824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ryDhvxI0D4+x5a2eZW+6+xV/dil48ItaFsqys1pNbt0=;
        b=BHLpRzIVwA9C2kBlD3uuy8Kc0Ze2J0JQKcQVR+bxbwendBR2QaSa159Jt0K5F68jfzeBO4
        Je5/qHugwHrDQcjTQp1OEqnz4zCBrnF7+7rbpAVG/PDrung9NCgN9XMWWsBvYP6UOuaefa
        BiTXPK3YN8W0ejCYgswCwWZkVlvGYt4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592--Dl9r7qOO9-HNudzUlabhw-1; Mon, 27 Sep 2021 13:47:03 -0400
X-MC-Unique: -Dl9r7qOO9-HNudzUlabhw-1
Received: by mail-wr1-f72.google.com with SMTP id e12-20020a056000178c00b001606927de88so1247825wrg.10
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 10:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ryDhvxI0D4+x5a2eZW+6+xV/dil48ItaFsqys1pNbt0=;
        b=MvacnnkHWDWjkN0Xl9Sa+bovQ4nmldn5bXM+xUCe6jHxwTJvtXIIVcm0WanEsnlVNI
         lwheMEpSpWNXBxQPK2Q0GHId0rfAW0qfUNN+BuBn+I+cxfahBkCwQAwD3P4+SmYm/9k6
         2Idw41sBX/tFQ0kPZxyAFHYSHtKcmA5NFDONlnN0i+kqwf4mJQ4RXEkJfOdVti0IvnYI
         cWerF9viecFQM9KRTGjahlB3qMEedEYYWzu45oeWKr2PBcjz7sSkw+M9MWAR4exeUBaR
         JqcJ4/mDbdn4WuL1/VIkhAc6sgB1sM16ItnvCzQe4uu5RTIiqwlkqwZm+QX8qDr7aatE
         YReA==
X-Gm-Message-State: AOAM531sOh4fgZ8EV4b9gVrpPfsAcjH2U+0qv7Je0ydPKiedbb9XujMY
        lfp2t8p2M57Bj6lX+hVgd+2b3Ire3UHvmZBHTGy91PDakSkwO8NrpBZrHiqBsE9WEMgkNbf70IS
        HBpWl2fZW4YUu
X-Received: by 2002:adf:e783:: with SMTP id n3mr1332533wrm.37.1632764821987;
        Mon, 27 Sep 2021 10:47:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG+02rrPNofwdceC460HuS7nCJCrPJYQ1riXHwCvcpyjKPJT0xMmfSiF/IGwq7Y/JE3c3Yyw==
X-Received: by 2002:adf:e783:: with SMTP id n3mr1332519wrm.37.1632764821806;
        Mon, 27 Sep 2021 10:47:01 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id c30sm17398156wrb.74.2021.09.27.10.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 10:47:01 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: Makefile: Remove snippet
 flatlib linking
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-8-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <329948a8-b4ea-1c4a-5392-3fd6aa8540f6@redhat.com>
Date:   Mon, 27 Sep 2021 19:47:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922071811.1913-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2021 09.18, Janosch Frank wrote:
> We can't link the flatlib as we do not export everything that it needs
> and we don't (want to) call the init functions.
> 
> In the future we might implement a tiny lib that uses select lib

s/select/selected/ ?

> object files and re-implements functions like assert() and
> test_facility() to be able to use some parts of the lib.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 5d1a33a0..d09c0a17 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -92,7 +92,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>   	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>   
>   $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib)

Don't we need memcpy() and friends in some cases? ... well, likely not, 
otherwise linking would fail... So:

Reviewed-by: Thomas Huth <thuth@redhat.com>

