Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5267747D360
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 15:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbhLVOF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 09:05:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240918AbhLVOFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Dec 2021 09:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640181924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqupQy9BWVxvY1RJypzQBL1pDBMn6sDvZoPupIJTRwo=;
        b=Jos/QNti+v9kHGwaepqAEp1DFRjjILv9sbDu7+dhXfM+RNNF635gIvWkyFPBis6W08Qlz5
        MZH+tXrSdQXOWPfd6LxjvN0ml26MueFIFZ+iMnatazIhlpHGCs8dkulqLOE+V1NJw0zufR
        6FKMuos7RxdWHm5QgChg5r6t4cwBueU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-0i0VPz6iOzanHtlTXw36Sg-1; Wed, 22 Dec 2021 09:05:23 -0500
X-MC-Unique: 0i0VPz6iOzanHtlTXw36Sg-1
Received: by mail-ed1-f69.google.com with SMTP id i5-20020a05640242c500b003f84839a8c3so1939342edc.6
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 06:05:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OqupQy9BWVxvY1RJypzQBL1pDBMn6sDvZoPupIJTRwo=;
        b=S0PrP3My9AmKWwwKXazcvB/fCwvteCBVaoIWTWCPEGYj9pY6edZXZLRf36RPd7psQj
         kK0numebCnqw1qtdmogJxSH14DHr4uLx2eFtyjSnxcu94SKbnu8N4wlnoY0RfnPANgVl
         K3jknaHhOKMW3fjzFwx51onmcnKL9U4iYLAdtYxCw747UsYh/VSMpz/nUUrAVI4UGyZd
         SZLhoHQcDy+YdDPQBMLYv1/wso15PxbHDOJIBm01YYHgyCDnN6PJY5nR9ssuQXIW0urX
         /O0iXQ9iFTpUGae1eA1CsVju2qJ/mGWZ/6BIO1o16lhoxABepK2mxzZsR6Hf6SR+iuUk
         z6Ng==
X-Gm-Message-State: AOAM531eK5cufSqBejFoGEY6EWXxNFTYf+RCDmr1wpVqKfeC3Fmxbr0K
        vQKHfyUK6bmJqIQrN0XHW/NQSGnByuMm1pRMq461LKoDWJGUianL/MJMGhIg0Z+y0itvoyzEyZE
        mKAlTkREqqcTl
X-Received: by 2002:a17:906:538f:: with SMTP id g15mr2704177ejo.354.1640181921897;
        Wed, 22 Dec 2021 06:05:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfesu97ShxW/0pR0HhI4lKZd7MIrBKBCIJXeOSTh+xCx7ko/0pSPcXopXXLwH82TEzzfQskQ==
X-Received: by 2002:a17:906:538f:: with SMTP id g15mr2704158ejo.354.1640181921601;
        Wed, 22 Dec 2021 06:05:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::4fa? ([2001:b07:6468:f312::4fa])
        by smtp.googlemail.com with ESMTPSA id m16sm948750edd.61.2021.12.22.06.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 06:05:21 -0800 (PST)
Message-ID: <4cb1af94-42d4-20d9-ab7d-301f2890fa2c@redhat.com>
Date:   Wed, 22 Dec 2021 15:05:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/3] AMX KVM selftest
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com
References: <20211222214731.2912361-1-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211222214731.2912361-1-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 22:47, Yang Zhong wrote:
> Hi Paolo,
> 
> Please help review this patchset, which is still based on Jing's AMX v2.
> https://lore.kernel.org/all/20211217153003.1719189-1-jing2.liu@intel.com/
> 
> Since Jing's v3 was justly sent out, I will rebase this patchest on it and send my
> separate v3.
> 
> About this selftest requirement, please check below link:
> https://lore.kernel.org/all/85401305-2c71-e57f-a01e-4850060d300a@redhat.com/
> 
> By the way, this amx_test.c file referenced some Chang's older test code:
> https://lore.kernel.org/lkml/20210221185637.19281-21-chang.seok.bae@intel.com/
> 
> Thanks!

Hi, this looks good to me.

Paolo

