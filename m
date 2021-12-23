Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CE347E944
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbhLWWVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:21:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234511AbhLWWVR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 17:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640298076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BLhdrTtFS4d9QLyy94dou9kcH8oqzaYd+9Lj+mRultU=;
        b=fKEB7jrc2kdiRZrpG4Y144p5YrfRlRZQHbXXUH7xBbHNXI1GbYbKA4OiesZ+6cBS1D+p0C
        m3Rq5eWP4/MlIbGjvz3FOpmW6qJZ8Dd4tNAwRw32wWIeq8YEnOtDox/5Q83H5M6jckTPZ7
        HWmvcNLDcBATsfgp4ErLYxivVu9kHAw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-dRoCmjBRN7-MiVZFr7DSSQ-1; Thu, 23 Dec 2021 17:21:15 -0500
X-MC-Unique: dRoCmjBRN7-MiVZFr7DSSQ-1
Received: by mail-wm1-f70.google.com with SMTP id j207-20020a1c23d8000000b00345b181302eso5359480wmj.1
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BLhdrTtFS4d9QLyy94dou9kcH8oqzaYd+9Lj+mRultU=;
        b=SEj5SJsnwVJsraJmVK08NEPF9fgHPVL7FgfI7dqP1tGs955szTvUgyxFb5r5APIwba
         qRPrCfY1XDhMiKA2PSOdgcKlgfHyyuvqPFKGGkoUduXTQHhSBm0WUN3uTDjNCt/XtEoC
         VeqTX/JylQP8cssFAZM80Nivwygua4Z+v5TLWGSyHZQpkDiL0qNs+MjptzUECHZ8wn10
         JNmPZB5UT3815ZJk7wa4/AYvPkD0bSBFFrw+iTku/r6YpC3m74eUG0qGCRCDlufqtfyp
         iJi83tAUZLxCoDj4FWqQSnWIi4ivbC3FENkqguZXG6Tt9zjXpsVylfZu1HlZiE0F09xW
         kCmw==
X-Gm-Message-State: AOAM530ulMHnq+vEYIH7yrZee8iSj8GPZR+lXvqepcKubHq/m91Nbwid
        FG/ywIb7KD3qDivftPd5wn/ij36rhdUaX+PWNIMw3hHP+KV1O94Qm+bX4SXDdFAuwTLeFZRZupm
        JJ1hoVeGEdBGy
X-Received: by 2002:a5d:6212:: with SMTP id y18mr2860193wru.608.1640298074410;
        Thu, 23 Dec 2021 14:21:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZnBZxJd1LMkcfiib+jy/HVwoipxEEhkSDvT4eFD8hSTjuOrqcUiRayxchWKrlhCNT6Qkbqg==
X-Received: by 2002:a5d:6212:: with SMTP id y18mr2860185wru.608.1640298074229;
        Thu, 23 Dec 2021 14:21:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m10sm6139515wms.25.2021.12.23.14.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 14:21:13 -0800 (PST)
Message-ID: <b4154e56-4502-68f4-ed9a-0de8ee833280@redhat.com>
Date:   Thu, 23 Dec 2021 23:21:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YcTpJ369cRBN4W93@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/23/21 22:24, Sean Christopherson wrote:
>>> Any word on when these will make it out to kvm.git? Did you find
>>> something else I need to fix?
>> I got a WARN when testing the queue branch, now I'm bisecting.
> Was it perhaps this WARN?

No, it was PEBKAC.  I was trying to be clever and only rebuilding the 
module instead of the whole kernel, but kvm_handle_signal_exit is 
inlined in kernel/entry/kvm.c and thus relies on the offsets that were 
changed by removing pre_pcpu and blocked_vcpu_list.

So now the hashes in kvm/queue is still not officially stable, but the 
pull request for the merge window should be exactly that branch + the 
AMX stuff.  The SEV selftests can still make it in 5.17 but probably 
more towards the end of the merge window.

Paolo

