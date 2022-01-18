Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3A492296
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345605AbiARJVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:21:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345636AbiARJVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642497694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V0up1jTBKdJRELCW3kgB+6Gb4eRzyxkdBmk1g6b9cN0=;
        b=RmDX/0z39KwQXp82h+Jd5HkmfXa5HfEXYzALg9EfShbUVJQ9CIY2pLYT5EZoINpaoHsFxH
        kFX4hK271G0SR84M4YX1843khPHprHqWLgMlpMa6FS9+g6Z1vShBigTV5rW1D3DQRiBl1o
        WqzXBHPGqxCM4WtwPDXgv/74YiaX+tI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-3N1ZJQBtP6qk-qulCQzLvw-1; Tue, 18 Jan 2022 04:21:32 -0500
X-MC-Unique: 3N1ZJQBtP6qk-qulCQzLvw-1
Received: by mail-wm1-f71.google.com with SMTP id p7-20020a05600c1d8700b0034a0c77dad6so1620349wms.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 01:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V0up1jTBKdJRELCW3kgB+6Gb4eRzyxkdBmk1g6b9cN0=;
        b=KHowlRDm2Gv7mBLYpKy1BKCuyuQNKu+yQ2UKgN012jf0QVe5RmsdWrsrok6fAR5vA3
         NMcrvIIufz63ZKP4clh17KmxpwXYK8z1dMNuiZLKvxI37uttzQKGyJTQHTNMZdN9a+z/
         6AED+TKeOhpibmTW6FqeOSSapbKjHRkG2n/3mNJAqwycdKQBKMhIuR+Aa1BLMCdn78bD
         qsJMnRvWrFAvV4Wr5Tp+4fqASULSz2A/qVTLpQtPUsVVF/7JNkBIkMHyw3e9vTy4wwQ7
         hOnhRTm5qidLeZIbaC8b3bDc6XoMWWmxuXmGzLHJ2vwEy2bV8sh8x402jzpTcNGpyhkQ
         IDJQ==
X-Gm-Message-State: AOAM533u/LtMlSTRncPsBkbTMTGfHIjG43Xb9uYI3tLcPmPgP4uzhUFq
        Su+6NBG1fNA+6TwTUe2JiofTEsHXBQXNN//aUx5OuS0gvZydSL3vnI7QIT+bSGuCH0/BPxXvJr3
        bjE7VenMoV42a
X-Received: by 2002:adf:f14d:: with SMTP id y13mr22460412wro.4.1642497691020;
        Tue, 18 Jan 2022 01:21:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQZpKJtdKUtknQlsuVUdAZ6wJLHmkM7UkdnWQguNwuAKRrv3aVJPWLp8uRn42swBXemfm2AA==
X-Received: by 2002:adf:f14d:: with SMTP id y13mr22460397wro.4.1642497690840;
        Tue, 18 Jan 2022 01:21:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t8sm1800816wmq.43.2022.01.18.01.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:21:30 -0800 (PST)
Message-ID: <d6e6d814-bcbb-b4a0-04cb-8f90dcbf68e4@redhat.com>
Date:   Tue, 18 Jan 2022 10:21:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit
 tests for nSVM
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org
References: <20211229062201.26269-1-manali.shukla@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/29/21 07:21, Manali Shukla wrote:
> This series adds 3 KVM Unit tests for nested SVM
> 1) Check #NM is handled in L2 when L2 #NM handler is registered
>     "fnop" instruction is called in L2 to generate the exception
> 
> 2) Check #BP is handled in L2 when L2 #BP handler is registered
>     "int3" instruction is called in L2 to generate the exception
> 
> 3) Check #OF is handled in L2 when L2 #OF handler is registered
>     "into" instruction with instrumented code is used in L2 to
>     generate the exception
> 
> Manali Shukla (3):
>    x86: nSVM: Check #NM exception handling in L2
>    x86: nSVM: Check #BP exception handling in L2
>    x86: nSVM: Check #OF exception handling in L2
> 
>   x86/svm_tests.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 114 insertions(+)
> 

Queued, thanks.

Paolo

