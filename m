Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799BC4259BE
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 19:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242977AbhJGRtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 13:49:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241738AbhJGRtl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 13:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633628866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMIgq/shF4zYaj1gUby36uqdLSqQ0DPEM64q06xf0oM=;
        b=VLyYn/prYDV98BIXWh3m31tZa0WcmpVkIxx0AGuUVC/mR/Y2/2JLSb7hoHjd/Ju0KtcknE
        7YdrzGpNA74Fg7VSaYO92+jhiqhfXdpD0zPZsmbnEteKufHhSGpXbhGIlqQuWMif4qjb+h
        8E1b8hw/9LjrILhoVR18ELRbZ5OoLoU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-nimx9f4QNICrbVBxgc1Lgg-1; Thu, 07 Oct 2021 13:47:45 -0400
X-MC-Unique: nimx9f4QNICrbVBxgc1Lgg-1
Received: by mail-wr1-f72.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso5298103wrg.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 10:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zMIgq/shF4zYaj1gUby36uqdLSqQ0DPEM64q06xf0oM=;
        b=xBb3OfsgORNSIxdcMuhGIIp9vsXBjGFnoVmja87QUHAbany/sHa7LZHtf3fgqarZNz
         LmojqOX+tgBzGZeAIvGf1ChF3wKBHOCr39KHP4qo1JRcMsdaIPyy6no8JZg33Pe/MzKr
         hl4tzuXSQr4cGQeZhWU6z8NhBYhex0Mmv3PNDJstnR3nupyzlroKiWDX/IclSeKJJtRK
         278Jo0zInM1GVLDlnvpRQxFwGMq67V0N301nOp4wWpoUlDM+Iq0RyJL7Cj7J6AczsOAV
         iTeyJTWqT+L51WRMouULNBwgEbxOzCqTuXeJQgfhCP5OUqQT9B6Yq5pTMfNekltaN0xu
         loLg==
X-Gm-Message-State: AOAM531EA3kp3HOf7lVBOssgXxcwQolrhKVLcaRp0zVnsJKZTVK7UP8C
        a7fqtu5nvHInhkiC5CkqFdZGB9po9R3mE0dj+CnzgkZIfweizqjn451d8cnQZTbIavGFbgkU8vE
        VdkNoAAQsC/1R
X-Received: by 2002:adf:97d0:: with SMTP id t16mr6921555wrb.124.1633628864696;
        Thu, 07 Oct 2021 10:47:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVQLk62OBdz/FxDWWdF4DHH5+h/b3zennVSvs4B8TXw3JIJsMFZYSDdaYmn9xuR8+I3uSEKA==
X-Received: by 2002:adf:97d0:: with SMTP id t16mr6921533wrb.124.1633628864451;
        Thu, 07 Oct 2021 10:47:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h18sm84173wmq.23.2021.10.07.10.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 10:47:43 -0700 (PDT)
Message-ID: <81bfc7de-2b9e-f210-0073-b31535d7b302@redhat.com>
Date:   Thu, 7 Oct 2021 19:47:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 4/9] KVM: x86: reset pdptrs_from_userspace
 when exiting smm
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-4-sashal@kernel.org>
 <e5b8a6d4-6d5c-ada9-bb36-7ed3c8b7d637@redhat.com>
 <CA+G9fYt6J2UTgC8Ths11xHefj6qYOqS0JMfSMoHYwvMy3NzxWQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CA+G9fYt6J2UTgC8Ths11xHefj6qYOqS0JMfSMoHYwvMy3NzxWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/21 17:23, Naresh Kamboju wrote:
> Is this expected to be in stable-rc 5.10 and below ?
> Because it is breaking the builds on queue/5.10, queue/5.4 and older branches.
> 
> arch/x86/kvm/x86.c: In function 'kvm_smm_changed':
> arch/x86/kvm/x86.c:6612:27: error: 'struct kvm_vcpu_arch' has no
> member named 'pdptrs_from_userspace'
>   6612 |                 vcpu->arch.pdptrs_from_userspace = false;
>        |                           ^
> make[3]: *** [scripts/Makefile.build:262: arch/x86/kvm/x86.o] Error 1

No, it was added in 5.14.

Paolo

