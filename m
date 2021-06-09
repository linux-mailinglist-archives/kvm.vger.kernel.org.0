Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA63A1724
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhFIO0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:26:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237993AbhFIO0B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gV3l2HBP+EPnPQllTsCVp8vP7IeEYt10tdtvtLJxm2Q=;
        b=KHlM5qUzZCveEpNoHtLhWkMS1m0JSV8gqK9bebG0t0JZkKzP1tRKbnGvtEIrDA4iSpSBSH
        ASXSHIigZ1w/rvUT0Yr0aD3K27CztD0R462mRSsys5puQ6w9TqB/RZyIUtAQsPbatyQV3L
        8UUlYdSz0Y+niHxXc8u4JcX8vVFzdP4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-W3dTknMgM5aDNrChCpdLhA-1; Wed, 09 Jun 2021 10:24:02 -0400
X-MC-Unique: W3dTknMgM5aDNrChCpdLhA-1
Received: by mail-wr1-f72.google.com with SMTP id k11-20020adfe3cb0000b0290115c29d165cso10834779wrm.14
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gV3l2HBP+EPnPQllTsCVp8vP7IeEYt10tdtvtLJxm2Q=;
        b=t8qP8ioO71sz38k8s9KP0sib7gEv2cWOyyUrNXU7oxKezK2KLACCK0Z7KaZnO5BPIb
         zjZmNiRiDFxbGJu0UiqDCCYAsQtQCGlqgOZCi59Z21Hcc66+AGBalamRLx9i6qYXKbHi
         6ncNZ7UKFqbZ2Sv0ltoA5N4dYFQ3xGMmvIehw4L0Z8jdeKXAUTsHhyk4LjUC223fwBx9
         vw+TOl5Z4UUH5KmCUGXQ2PziqMLYMniG+eD80xAvnvPPIZMSNnCIE75Um8SkgNM2JK0z
         lb/0tYoGO1t6xTQWd+YeOnnFkYybQ2Lv/tgoDz2tEIJ0IVzW7ifp3Ka5p7lmgwdPQKRA
         RpjQ==
X-Gm-Message-State: AOAM5338rBVJE589CDbeglna5gltCNKMVTn3v+d+NJS7CYY6qiG/FTt/
        bbRmHpxb/9ddJ8qxSAF+aRsdLq5quYxPtOmxNXN15QrWryrHSxnplC6MTw5TDIkrZAkj4v4Ao6N
        0Ip6ZZ4CICwKctBLxVhJ/xqEZd9sjhKadXpgDNQBqEa8pPOXw5MT2OyRiWm9GGeW2
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr84736wrt.218.1623248641235;
        Wed, 09 Jun 2021 07:24:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxX3v1nQNIRbJJ3WdbWhSSctCYj+allKkyATQGpPcWSnY0qyg6gzVlIeP+3b5coAl5XrXDCqA==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr84708wrt.218.1623248640997;
        Wed, 09 Jun 2021 07:24:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g186sm15529637wme.6.2021.06.09.07.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:24:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix misspelled KVM parameter in error
 message
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org
References: <20210609140217.1514-1-sidcha@amazon.de>
 <20210609140217.1514-3-sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcf60221-0318-9355-30a2-f641751611f4@redhat.com>
Date:   Wed, 9 Jun 2021 16:23:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609140217.1514-3-sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 16:02, Siddharth Chandrasekaran wrote:
> KVM module parameter force_emulation_prefix is misspelled with a
> "forced"; fix it.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>   x86/emulator.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 6100b6d..97f28ba 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -1124,7 +1124,7 @@ int main(void)
>   		test_mov_dr(mem);
>   	} else {
>   		report_skip("skipping register-only tests, "
> -			    "use kvm.forced_emulation_prefix=1 to enable");
> +			    "use kvm.force_emulation_prefix=1 to enable");
>   	}
>   
>   	test_push16(mem);
> 

Queued this one, thanks!

Paolo

