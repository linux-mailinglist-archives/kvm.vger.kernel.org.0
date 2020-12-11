Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38F82D7FBE
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 21:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393105AbgLKUAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 15:00:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392755AbgLKT7y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 14:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607716707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvoJYzjsHf//R5+quTbEyOoJLSIUrpsBgM9T0OQSHyQ=;
        b=QxnS7UOsAbNC9zDyPghwE9PrYBptbteKAyiRQS4MnjfeBUobYUQ1euzrgPyylZyfQmFqSc
        PwdNIpdFR+gCbT8xQMl8+68lIm8wnrD8aDGx1bSh7jUnHXM8UxHhbGIX3nM1GEjcyX5Ihi
        fd/FWuThAweFEjakFAgMw29PPRpz28k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-Bf6_vpXSP8mgVy6iExAYRg-1; Fri, 11 Dec 2020 14:58:21 -0500
X-MC-Unique: Bf6_vpXSP8mgVy6iExAYRg-1
Received: by mail-wr1-f70.google.com with SMTP id o17so3724017wra.8
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 11:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvoJYzjsHf//R5+quTbEyOoJLSIUrpsBgM9T0OQSHyQ=;
        b=PSNROLvh2RMk0AmSPzo8bWRJ/et4g54ERV1eI60RINrFhX+KGPyLV1CpOEDgvbBw6A
         M15IjRsRV+mFSyGAOmAi+S0htKN33neuVfkPTPtQCFTfibdoC4WY6ClnDfFUvEVSghCw
         empd0IxSHYYZ2f19KA7sOpCAzUrkHCDXjJYI1ol7aqkJoKDOPOUKaS9oXwUGHt57fFHG
         uFsdoFObEn0JgHY4KkFVjTKYSN9ddylvw4jJiF/b3AqS1ibns7wy/nfOpmyCbxcwcreX
         0rxcqwfz5OFR8N+8pFr+X8WX10cn+FHAoVwy5I2uEupKWDJv3HzRFoq6Zd/gzy9PMu0B
         XtfA==
X-Gm-Message-State: AOAM533VVV6hIUxoHR5pbp0Ag9GW07zut9DJ3QDMnJmDs9AGX7l56W8j
        OZfdXqY8+N51ZuImt8ezZaU0x4pAIuSvm/cirL5s8qh9KiVmDPmpfXy5vHWml5/RAU0gWCbezDR
        uIHPh1vFEo7T9
X-Received: by 2002:a7b:c406:: with SMTP id k6mr15252454wmi.90.1607716700292;
        Fri, 11 Dec 2020 11:58:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBUr6N4x/0B1aDksKTeOdroA2gakaNWxOvpoZDNoiFvINrLk8sCihVq0lnlmPXT8hbs2JZUw==
X-Received: by 2002:a7b:c406:: with SMTP id k6mr15252445wmi.90.1607716700112;
        Fri, 11 Dec 2020 11:58:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h9sm16028827wre.24.2020.12.11.11.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 11:58:19 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] Makefile: fix use of PWD in target "all"
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
References: <20201211194331.3830000-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <12c39be2-1b0a-5b9d-4d6a-adf732c93e39@redhat.com>
Date:   Fri, 11 Dec 2020 20:58:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201211194331.3830000-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/20 20:43, Ricardo Koller wrote:
> The "all" target creates the build-head file in the wrong location when
> using "make -C" or "sudo make". The reason is that the PWD environment
> variable gets the value of the current directory when calling "make -C"
> (before the -C changes directories), or is unset in the case of "sudo
> make".  Note that the PWD is not changed by the previous "cd $(SRCDIR)".
> 
> 	/a/b/c $ make -C ../kvm-unit-tests
> 	=====> creates /a/b/c/build-head
> 
> 	/a/b/kvm-unit-tests $ sudo make
> 	=====> creates /build-head
> 		(note the root)
> 
> The consequence of this is that the standalone script can't find the
> build-head file:
> 
> 	/a/b/c $ make -C kvm-unit-tests standalone
> 	cat: build-head: No such file or directory
> 	...
> 
> 	/a/b/kvm-unit-tests $ sudo make standalone
> 	cat: build-head: No such file or directory
> 	...
> 
> The fix is to not use PWD. "cd $SRCDIR && git rev-parse" is run in a
> subshell in order to not break out-of-tree builds, which expect
> build-head in the current directory (/a/b/c/build-head below).
> 
> Tested:
> 	out-of-tree build:
> 	/a/b/c $ ../kvm-unit-tests/configure && make standalone
> 	
> 	sudo make:
> 	/a/b/kvm-unit-tests $ ./configure && sudo make standalone
> 	
> 	make -C:
> 	/a/b/c $ (cd ../kvm-unit-tests && ./configure) && \
> 				make -C ../kvm-unit-tests standalone
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 0e21a49..e0828fe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -101,7 +101,7 @@ directories:
>   
>   -include */.*.d */*/.*.d
>   
> -all: directories $(shell cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD >$(PWD)/build-head 2>/dev/null)
> +all: directories $(shell (cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD) >build-head 2>/dev/null)
>   
>   standalone: all
>   	@scripts/mkstandalone.sh
> 

Queued, thanks.

Paolo

