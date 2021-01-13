Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C912F509B
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbhAMRDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:03:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726471AbhAMRDz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 12:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610557348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Smmarn7+kTg9NtlEve0dM2aP73SfAqDNXY/hj+WRkWA=;
        b=GYBAiLPIGUbPCp/YP5fX+CxAd0DtjNLrKhiC/tCcm6AbkBHEQtUVzBQp3CVt6FZVpltPY/
        BXMJ3TNelaVqVfpXsk20xVZPqp9nDU0X5Gb3DGLQu9PBdy7K6bTOLk9jFKpNkOtPCL2nRV
        3K7mODi4D7k3JPx8lncQGMrchCE1lN8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-oKA6KP0aOQi9rPHQzAnqvQ-1; Wed, 13 Jan 2021 12:02:21 -0500
X-MC-Unique: oKA6KP0aOQi9rPHQzAnqvQ-1
Received: by mail-ed1-f72.google.com with SMTP id dc6so1157146edb.14
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Smmarn7+kTg9NtlEve0dM2aP73SfAqDNXY/hj+WRkWA=;
        b=PJ49rgkzEf7ice/fR1yGojZSDotGPlHvkSa9fqZXzkyZE/ootjGXUpmviXrJUmaPn2
         m1VOaaXdE5Guj3nTj10VA4YQnJuJZq6809gekrz/Z4D5YSC7VpiV9W1EoCZSh+1HdIPQ
         qrN9cxjAP0RHwDmbWI1jbDd5ry+zSKLLhyzHiYrmCHRcEwcbmv1iGh6z1tuQqTM5JYz4
         P0O9kStm0uQSFJinVzxVmc+mLxX+YMc3Y3TsqzrHK+3tTtMbhVDG3dW10v9A60/joUYs
         v/cZdWQH7+5p6yZdrIawMwLzps2rchvg1sx7DFazHm6fdhJmnUxIBoa+DUnPO18107MO
         5JdA==
X-Gm-Message-State: AOAM5314wQ5wTXLYeUZ/HiO+Vprqks6BpZnEH9RcJICz4hBWuAho3+Wn
        rF7iqxsCyn7iSnT5x+ndN5ZfOFn9px2kk8woHX/TGw5m5UXpBkzbQfGrcnJSmZAy9HEiF9vtXF5
        hSGkfMIKAyrAi
X-Received: by 2002:aa7:d494:: with SMTP id b20mr2644618edr.330.1610557340532;
        Wed, 13 Jan 2021 09:02:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMmCNisH+jW7xEd0xjiUGZvxfRGUjlt2CBUCz2Mpmj09y/ImnZTo/4jA+WbsCGj10sXePc3A==
X-Received: by 2002:aa7:d494:: with SMTP id b20mr2644591edr.330.1610557340231;
        Wed, 13 Jan 2021 09:02:20 -0800 (PST)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id e11sm935298ejz.94.2021.01.13.09.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 09:02:19 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Jason Baron <jbaron@akamai.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
 <6026c2a4-57bf-e045-b62d-30b2490ee331@akamai.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6d36a405-03d4-b3f6-2aa3-2bd1bc79a622@redhat.com>
Date:   Wed, 13 Jan 2021 18:02:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <6026c2a4-57bf-e045-b62d-30b2490ee331@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/21 17:16, Jason Baron wrote:
>>> +#define DEFINE_KVM_OPS_STATIC_CALL(func)    \
>>> +    DEFINE_STATIC_CALL_NULL(kvm_x86_##func,    \
>>> +                *(((struct kvm_x86_ops *)0)->func))
>>> +#define DEFINE_KVM_OPS_STATIC_CALLS() \
>>> +    FOREACH_KVM_X86_OPS(DEFINE_KVM_OPS_STATIC_CALL)
>> Something wrong here?
> Hmmm...not sure what you are getting at here.

I just misread define vs. declare.

> Or we could just use the KVM_X86_OP_NULL() macro for anything
> that doesn't have a 'svm' or 'vmx' prefix as I think you were
> suggesting?
>
> Using the KVM_X86_OP_NULL() for
> all definitions that don't use 'svm' and 'vmx', would mean
> manually defining all 20 in vmx and svm

Yes, that's the simplest thing to do.  Then we clean them up as we 
rename the functions.  If you want, go ahead and rename the five easy 
ones yourself.

Paolo

> .update_exception_bitmap = update_exception_bitmap,
> .enable_nmi_window = enable_nmi_window,
> .enable_irq_window = enable_irq_window,
> .update_cr8_intercept = update_cr8_intercept,
> .enable_smi_window = enable_smi_window,

