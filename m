Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43330870B
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 09:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhA2I1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 03:27:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232335AbhA2H7Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 02:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611907164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Byzj47V22ZrQMztSmUqNQcCJr1IEFCgRbNoQucSd/oo=;
        b=b0eMgNojtJrbaIWKN0TNGSvXw6vdsNn5un76JYN81brsxIP9MbGzxqj5jyofvr1oCeLTQ8
        Il5shrlNZD/ve+fmFp/6oMPhXd45748lZOEBfDrI3a/W7qufjxx5nwC/H10D5WjiVCKzCC
        zfvUBGMVgcxhTSev3PKtKC5xK2hpC/U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-PcsDw9XiPY26-Tuxjn3hnw-1; Fri, 29 Jan 2021 02:59:20 -0500
X-MC-Unique: PcsDw9XiPY26-Tuxjn3hnw-1
Received: by mail-ed1-f72.google.com with SMTP id o19so4545908edq.9
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 23:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Byzj47V22ZrQMztSmUqNQcCJr1IEFCgRbNoQucSd/oo=;
        b=tFpF3vNZ1yuIuIwmTc/1+3epaMPcqytOM3bfZqhELctNHcZ+rocx1oXcHN6sM4oW5P
         gAiSGx8ZfCtQnjyt/jXvsChWr/US/r8rohV78t3ylFHhOg/IpqvwHesO+a9fHaOXV7OG
         2iO9cOU5C6VDu1RZKEwoUo/EAYnQpjPF1cSPKW9MX5zoyAsvV6zluBrLUxfZuRu36G9g
         yl2hLHpBmAfLPFjHnoFeiIs8+oO+dYhGmQB6fLsl3sIOHRY/biojs6UC9sdSNd26NKsJ
         mVtKu9ub4qHAHJyNxk0l9jQDNQfMblf4evsgQmTNuvGAIyJgqUDnTke5lKPA+yZ4//DC
         F9pg==
X-Gm-Message-State: AOAM530oQtLWBPft7gLmYWmNwd5f7uIO2C8sKH7JFCdCgFmdutut9NIB
        tjlIMPa2Z2nAGn+C/3NHa94sQhVYGPfrMSJZKoXm1oF4041RP8lN+LPzcf8cRfzj5sEwlhi+NxP
        Gnqqqvr6IUUIK
X-Received: by 2002:a17:906:29d4:: with SMTP id y20mr3309916eje.294.1611907158989;
        Thu, 28 Jan 2021 23:59:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywpE3P6hDHWu+Bjipn2LzdsQzXwqew1cSC6UJAGouaOMMbbWb+RKGWpZ51kaucdbLkyAZRhw==
X-Received: by 2002:a17:906:29d4:: with SMTP id y20mr3309900eje.294.1611907158843;
        Thu, 28 Jan 2021 23:59:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm3291971ejd.110.2021.01.28.23.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 23:59:17 -0800 (PST)
Subject: Re: [PATCH v5 15/16] KVM: Add documentation for Xen hypercall and
 shared_info updates
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-16-dwmw2@infradead.org>
 <e79d508e-454f-f34e-018b-e6b63fe3d825@redhat.com>
 <dd496053b8d51a400b66622cd25c10f4540ac4d9.camel@infradead.org>
 <204b5082-2f8b-9936-675f-0ddc12a6ab43@redhat.com>
 <f9b2b4e613ea4e6dd1f253f5092254d121c93c07.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e7075e1f-672c-f94c-3a3f-b824a45de61d@redhat.com>
Date:   Fri, 29 Jan 2021 08:59:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f9b2b4e613ea4e6dd1f253f5092254d121c93c07.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 20:26, David Woodhouse wrote:
>>> Honestly, I don't even care about reading it out except for long_mode
>>> which the kernel *does* infer for itself when the MSR is used to fill
>>> in the hypercall page.
>>
>> What about VM migration?
> 
> The VMM needs to know all these things anyway. It's not like it can
> *forget* where each vCPU's vcpu_info is, then just ask the kernel when
> it's time to orchestrate a migration.

Yeah it may not be particularly useful but it's not hard to write the 
code and it's easier to document.

> I suppose *maybe* the upcall vector is an exception; the VMM *could*
> forget that if it really wanted to, then ask the kernel for it on
> migration. But we don't because that seems pointless.
>
> But then it *theoretically* could have a sparse bitmap of "this feature
> but not the next feature", even though that would probably never happen
> in practice without weird selective backports. But it's still an icky
> API. And frankly I could live without the 'get' for any of these except
> LONG_MODE which the kernel might actually flip for us. The rest could
> be write-only for all I care.

I don't think it's that icky, the alternative would be a KVM_GET_ONE_REG 
like architecture that just returns a u64 but the bitmap works too. 
It's not hard to write the code.

Paolo

