Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729803E8092
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhHJRuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236330AbhHJRtD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 13:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628617720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4WETgCfRJxaNKN6Crj5K5of7vonn/3mT6kzvrsWM8k=;
        b=hT6bpKzV0VGQbPS4PSfL/wY26hbAbfSf6tqL3zO1h+F64efY6UcBfXC9b7JvvlMdTWxfCE
        q93w+mbFn5ADJJlDsvPKHI4kTNPN0p62kB0zanxmR6YmU1cEpuiqXIqqXhQDVzfWhG2IIS
        MiJFW69yVyxW/N3dJU/9LmX2HJ+7j0Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-d2CpikQ_OjmEWuGeDImjzg-1; Tue, 10 Aug 2021 13:48:39 -0400
X-MC-Unique: d2CpikQ_OjmEWuGeDImjzg-1
Received: by mail-ed1-f72.google.com with SMTP id l18-20020a0564021252b02903be7bdd65ccso475845edw.12
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T4WETgCfRJxaNKN6Crj5K5of7vonn/3mT6kzvrsWM8k=;
        b=HG7W6bzvEs6RsAVjrpxGY8YQTjrwmA8fDn+FTKj7lrMwYw8X/ZKiIh9u5RogyrdI7J
         r4+mCBsIvL+m5mc5BYopHwaEQ1m7K6/u9soYVaybCHjpMxHIsNOR1BPOuozBOpsZo8X9
         eWTlJ5hGe/VWdVMF5XKAzxCihGiJLF7x99rC9MLYUs5dkOpYxfF51pwYSlM7vb0fqjFM
         xMpMFxL++6wXFbtM+oEU3mNhubW/V+p7t4urK8qjFxjy4GEKOP7eJYKknCSm769rntns
         AioK90GjJ+92YO5YCv4UZSvi6TR9EbjTKYT3Mw3CMYyAR+iQTkEKcfUMCl9+G9DlAUEB
         7MRw==
X-Gm-Message-State: AOAM533KGZiyn94NG07ORnR+oYYJMlZTP5N0IEif6zfKlAVEsmCzbwQt
        +g1reth/JonUhbSeKgvSFebksSaSLY5ImnsFM85kjL5FrIowZGxTp2lHeULHQn7KJyn8aaogBAZ
        dKYnej3q74MnB
X-Received: by 2002:a17:907:a06c:: with SMTP id ia12mr5197880ejc.377.1628617718284;
        Tue, 10 Aug 2021 10:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrMd+rSdhrmZJMswekFFSLTYDnGlb5onUGeP39SAUo2P8TibmmHx3hYQBbVOaszMWerl6Ozg==
X-Received: by 2002:a17:907:a06c:: with SMTP id ia12mr5197861ejc.377.1628617718077;
        Tue, 10 Aug 2021 10:48:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id x12sm9805718edv.96.2021.08.10.10.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:48:37 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: x86: Clean up redundant pr_fmt(fmt) macro
 definition for svm
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210809093410.59304-1-likexu@tencent.com>
 <20210809093410.59304-6-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef84c98d-9b33-052b-0747-2d2d327b1dfb@redhat.com>
Date:   Tue, 10 Aug 2021 19:48:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809093410.59304-6-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 11:34, Like Xu wrote:
> +#undef pr_fmt
> +#define pr_fmt(fmt) "SVM: " fmt
> +
>   #include <linux/kvm_types.h>

Why do you need the #undef?

Paolo

