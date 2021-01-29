Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834D2308D4D
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhA2TXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 14:23:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232849AbhA2TV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 14:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611948001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GdnpEoYNUkWjsRHDOqmWnvBPMBiezEDLGqN7vEPsTbA=;
        b=LmsKCJUHgtj6rEYN1JBEN5kT5Xzdph3xDdBkT9E378DY7kqjem/tuKl9xTaSyQrFpt0AC2
        +UiqO27RogwzmNUzfEv8s6Ems8j9OKRJHUVpmtiyPNZhmpoaeV9kzeOLb78KR5AXE+1ljT
        iF2ZhuyYxTaFFEOQAAXPnxiVEfPz6pE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-7hRRF_RhP3u7aa8XwG_Wng-1; Fri, 29 Jan 2021 14:19:59 -0500
X-MC-Unique: 7hRRF_RhP3u7aa8XwG_Wng-1
Received: by mail-wr1-f70.google.com with SMTP id r5so5761083wrx.18
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 11:19:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GdnpEoYNUkWjsRHDOqmWnvBPMBiezEDLGqN7vEPsTbA=;
        b=U4DKAGKpDGZ2oTwuY9dFfMT3EjonPuXcr7FdGHkQNiOMm+qqrHNTHtJCho0XrV4QIO
         AdZSQfLO/9/StYgoi/EgkBG8Jj6j1bO10y8KhUAmPgLMI/IJpbGgeQbFQrkq374+6r+J
         UAc/Nnx8Pchp8qt1NK7eOxbSQjVzEEfU28pHPJE6am1Nzar6M9LZQtDITyA5Vm3nmyPt
         tn1nUubZmhEbT23ZZ3rc5XGIdI9L8Cy8fpiiCFHuuW44WBKUWG7FLH9aa6HkyPDPrJth
         NexzUei0/R87lUq+8G8jMbUC1ObGFFw7FR2NZ9hlvOPAUJdlmxd0svlnN+u1ZacN1+B4
         +VAA==
X-Gm-Message-State: AOAM531Uc1bciAJmeCDtXKQBM/CE9JY2RdGLtngyyBEr4oIjkmzmqt7J
        0F34aY+CTEG0Eiq0u/NoGISfHpdhHljoZiAunxdYY4LQdRLhBQ8NCNlEHXM7PsE20u+uvzMHjIQ
        9fim5CyTr3bw/
X-Received: by 2002:a1c:c343:: with SMTP id t64mr4984033wmf.19.1611947998296;
        Fri, 29 Jan 2021 11:19:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXQ0jObZ/AHOpBtT+RBtG05//ROo2D62CpOx0dEesMjPDqYP5ghTScg+pN/sduAQy/9xBxqg==
X-Received: by 2002:a1c:c343:: with SMTP id t64mr4984018wmf.19.1611947998135;
        Fri, 29 Jan 2021 11:19:58 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id i59sm14758727wri.3.2021.01.29.11.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 11:19:57 -0800 (PST)
Subject: Re: [PATCH v5 16/16] KVM: x86/xen: Add event channel interrupt vector
 upcall
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-17-dwmw2@infradead.org>
 <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
 <529a1e82a0c83f82e0079359b0b8ba74ac670e89.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97fef86f-fef3-3ee8-9ae9-2144d19fc2a5@redhat.com>
Date:   Fri, 29 Jan 2021 20:19:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <529a1e82a0c83f82e0079359b0b8ba74ac670e89.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/21 18:33, David Woodhouse wrote:
> On Thu, 2021-01-28 at 13:43 +0100, Paolo Bonzini wrote:
>> Independent of the answer to the above, this is really the only place
>> where you're adding Xen code to a hot path.  Can you please use a
>> STATIC_KEY_FALSE kvm_has_xen_vcpu (and a static inline function) to
>> quickly return from kvm_xen_has_interrupt() if no vCPU has a shared info
>> set up?
> 
> Something like this, then?
> 
>  From 6504c78f76efd8c60630959111bd77c28d43fca7 Mon Sep 17 00:00:00 2001
> From: David Woodhouse <dwmw@amazon.co.uk>
> Date: Fri, 29 Jan 2021 17:30:40 +0000
> Subject: [PATCH] KVM: x86/xen: Add static branch to avoid overhead of checking
>   Xen upcall vector
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Yes, that was the idea.  Thanks!

Paolo

