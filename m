Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8F93A171C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhFIOZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237368AbhFIOZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jjZF3gCf4qvAes2x1coFKY5Z3ioj6l3K4a2iOJudRcA=;
        b=K8JXWAC9y6xNSqPnoHV1hm056LS+IdcUwFr9WALdS/TgBl/GoES+ofbXz6D2EfP2HIij0X
        nBVo5KY19d/riBWYYsmpvfG7Z8IypMra95VTRds8u8hhVj9uA2AXkVr7hcg23JUPJSIMSI
        Xot/vc5tdnkBN+zBZ8QU1MS3ny0R3Nc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-3n5un0gkMbKqLEiB--eBSg-1; Wed, 09 Jun 2021 10:23:40 -0400
X-MC-Unique: 3n5un0gkMbKqLEiB--eBSg-1
Received: by mail-wm1-f72.google.com with SMTP id h206-20020a1cb7d70000b0290198e478dfeaso876505wmf.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjZF3gCf4qvAes2x1coFKY5Z3ioj6l3K4a2iOJudRcA=;
        b=sj0cZoR/otrgGzl91xROiHstyaVovzXa5uym+cRA9svUpQZb0B+BW/Jp7vkQJcsxvP
         +xLF7Uk3PL9yqxVhofSMwirHyUnJSI99WJwqZ9Ndp9HJE5AhW7omEllNmr0uUghWR4bo
         dEn+hLdJAC286afxDw96hs5icgE+pwEKt6zycwZQSxW6yvibwXKSsQ8VN1sbYFfDXD8U
         fcHBATVkPjfZRTg4v5u8dJyPS79kKOOQsykV4P4tfEj5/rAz4nuQDFCfh1KPlW82JOBl
         QukrhYmC8Gh+K/nNI73RmYCRFyG6Jq7mfUt2r4AiMbKnqAMSmU5H4oW1qq1lBUKWyJoP
         hnVQ==
X-Gm-Message-State: AOAM530ESId6HDczPGwv1klQEIdlDJPaZDqkitfuBx8kIJvC+hCcmy4a
        9uKmcboDFWjo45YzEIy1qOvPpqW3pBleWlK41oZ7+XJLCggjhnJB4gUJWC09TlnXA5VFdZXTtu3
        oo64wVOXKRih5JBI8AngvK2wXY4hVtDQzIIs4pK2EWohJkEehaMJuqkclU6/6N63y
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr68751wry.342.1623248618762;
        Wed, 09 Jun 2021 07:23:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKVDODYpGPSF4I0Joj7Aziu8oSwAjqxFwTUyZheDKV4Mo/PQJ8eZhOqVsAEPzm5iFWLwOBXQ==
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr68730wry.342.1623248618590;
        Wed, 09 Jun 2021 07:23:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r6sm97888wrt.21.2021.06.09.07.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:23:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] gitignore: Add tags file to .gitignore
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org
References: <20210609140217.1514-1-sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <28e911ae-b5c5-58f1-7ded-0836ca4889ef@redhat.com>
Date:   Wed, 9 Jun 2021 16:23:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609140217.1514-1-sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 16:02, Siddharth Chandrasekaran wrote:
> Add ctags tags file to .gitignore so they don't get checked-in
> accidentally.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>   .gitignore | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 784cb2d..8534fb7 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,3 +1,4 @@
> +tags
>   .gdbinit
>   *.a
>   *.d
> 

If you're using them, you might consider adding the Makefile rules to 
create the files.  Alternatively, you can add "tags" to your global 
~/.git/info/exclude.

Having the file but not the rules feels like the worst of both worlds...

