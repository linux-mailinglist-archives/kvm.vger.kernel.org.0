Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EFB358875
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhDHPbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:31:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232058AbhDHPa6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 11:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617895846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7y+qV1QX6itWVJvsPTpvv4qB/DYjHt3u6N1WcKj9Bg=;
        b=AnHcYgyUtY14fA2GB1gwqlIU7tYn6HdMToRE4LGGNZ5cKD+NxC5zG2TF3VlwQ+B/uqrJXP
        RX/gVzQN6QO+fdwiV97c4ZR/4SgrVc0TdWK1tzW0GcXLv7qEnqySL178WNz8XxXCKLS8Gu
        KMh1lW2NYHZEHta+9xeR0k5qFpszTGw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-9mB0oXGPNfyoCwc3vB_K-A-1; Thu, 08 Apr 2021 11:30:44 -0400
X-MC-Unique: 9mB0oXGPNfyoCwc3vB_K-A-1
Received: by mail-ej1-f69.google.com with SMTP id di5so1034959ejc.1
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 08:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f7y+qV1QX6itWVJvsPTpvv4qB/DYjHt3u6N1WcKj9Bg=;
        b=EeLCZ+csJynZDYP9Eq+86gMwILLF05gQ6063QwkbZySF/7/AC/Y4jZwY4GiFCqD2sy
         t5Cswti78NHFwG36MOfSSO+yWGErLnBKtzP3lrNqXubQboQCzcNwwd36WtP+OV7PNpkF
         gofT2HYXiLGvlDkgBfUJy+/udGRZNXbmHjHmt/BMcxcSlSCxJy7kD7sWOMi1dSqDgC1p
         0aC1i6oE66A6u+KAhnOBzLHEefzgv9KWOI6Mb0JqULvf+Y89OMiT6ZLbLFgfu6PJfg2F
         iPJTw6A1jFIgxTxBE9EyvScWXXDx/LDpysuIpStymQ39Tt2Jj1O5T4sUm+qaBqpuhF0m
         1juA==
X-Gm-Message-State: AOAM530erqljfgFuSQY6rqEEU1bAHTDee8qnYKj3AQpZRmVEpa/S3IHv
        LzpwtP85dzdEckcPqcdzIPaqnq+oxhZi76hMCoanCyfnrGUVQFsa/z0NWlQvCBC2ozO6ayPC870
        nTScjlXvI+qawnqW5n0WlTykGip9IIv0iXJK4laRIRPOM4tmoIKQj+USUaECN3Gvc
X-Received: by 2002:a17:906:f2c4:: with SMTP id gz4mr11221250ejb.369.1617895837606;
        Thu, 08 Apr 2021 08:30:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0Y3dI6nxcGhLpQ0Wo61Aeoqztdw5kKwf3X3+bdymlXu5DaOTJRHYyc2lp0yIFxYtWUBsSww==
X-Received: by 2002:a17:906:f2c4:: with SMTP id gz4mr11220328ejb.369.1617895829796;
        Thu, 08 Apr 2021 08:30:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h23sm6317924ejd.103.2021.04.08.08.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:30:28 -0700 (PDT)
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
To:     Wei Liu <wei.liu@kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        graf@amazon.com, eyakovl@amazon.de, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
Date:   Thu, 8 Apr 2021 17:30:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 17:28, Wei Liu wrote:
>> Although the Hyper-v TLFS mentions that a guest cannot use this feature
>> unless the hypervisor advertises support for it, some hypercalls which
>> we plan on upstreaming in future uses them anyway.
>
> No, please don't do this. Check the feature bit(s) before you issue
> hypercalls which rely on the extended interface.

Perhaps Siddharth should clarify this, but I read it as Hyper-V being 
buggy and using XMM arguments unconditionally.

Paolo

