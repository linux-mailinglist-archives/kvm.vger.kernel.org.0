Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CBF494C16
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 11:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiATKus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 05:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376400AbiATKrT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 05:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642675638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qO1hZafvyKcBxQP78yk3hqC/9kFUIj2Avg9axdX+yPo=;
        b=OZHe9T7smZ+tJe7rucU2a3BClATfnnHYUg4Z8esgdgor+Xc32iGjWRXNcevcv8qRjhQ9du
        fNeHTcRLM7XTpu9KA8Bc7/gEpi6oDV3koxPfLoSEcguFzsnHBVg9vmoBSIDOehL9s+e9Cr
        Pir0x7P3zTb53xJ2t8SWtpOYWeuOR64=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-bJbUG9M3MF6WVAigzUU23Q-1; Thu, 20 Jan 2022 05:47:17 -0500
X-MC-Unique: bJbUG9M3MF6WVAigzUU23Q-1
Received: by mail-wm1-f70.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso6507859wmq.6
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 02:47:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qO1hZafvyKcBxQP78yk3hqC/9kFUIj2Avg9axdX+yPo=;
        b=ZesB0zzQi0W6MDAcCFgAFHHTZF/AHoNtn5+dEJ6QvGj+LapE1qMAwK/mvf34ybWgLN
         XAwpJEV3akeBgfQzK76ONzXgHYm9nHHpTzuCNDPBOAksqh193d/5tjs/NrqXwzR8IbWj
         iT3FdJQfCNbtT4FGa0gBsQ7dWi3wSQ5ghIBBk131Bk/dsT8c4muBtuHzLCHgWO//EXNf
         QFCmheGYLD+GdkkgDwqSue8QJsGhO6i4KsLUc3bvMDuUa9Y7CqSdXlvmTDunFE3MPXhO
         4cYKYzs6vJg5RCvmw2hSqF0E7ra1gRTFSmFTCbFz+SK1DgK35SzxX8NEeyr2BRwvHmar
         IsVw==
X-Gm-Message-State: AOAM5308USj3p7xikGSmOsXSPl+vr69wm+Ki4y6s45Oza2VC8gL2WlDK
        mVMUZgsVdSW4QQg+/h1rzEKLmGPJDCXbocvZ10p87qDfE08gxUdD75cucVugJIyduoj+Ga7TYmM
        pRkIg3fO0ecIE
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr5521820wrm.680.1642675635950;
        Thu, 20 Jan 2022 02:47:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcrwDfaLaSDQRGqrng7EFnJZ80JOK/Ll6EzS9W8XU5xUayOcQx0qNZa9uj2wnfeK8hisgMXg==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr5521797wrm.680.1642675635763;
        Thu, 20 Jan 2022 02:47:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f17sm1972724wml.31.2022.01.20.02.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 02:47:14 -0800 (PST)
Message-ID: <a87499ee-8cd5-2f57-9c1a-58779b5f7047@redhat.com>
Date:   Thu, 20 Jan 2022 11:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: linux-next: manual merge of the kvm-fixes tree with Linus' tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220120092527.71e3a85f@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220120092527.71e3a85f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 23:25, Stephen Rothwell wrote:
> It may be worth while rebasing this fix on top of Linus' current tree.

Yes, the next pull request will include a merge commit to avoid the 
conflict.

Paolo

