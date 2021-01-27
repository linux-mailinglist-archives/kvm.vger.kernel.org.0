Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA9305982
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 12:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhA0LWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 06:22:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235902AbhA0KhV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 05:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611743755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvvpdQmaoclN7F+XWBVjYRaUXCYn0Re2cC+2fW1RDDc=;
        b=W5j5qDxp9dBmMlwIixsbGARm3UIz1Nupk/FHQ5U7w4XmvRSbaNtcm0XOFih7vULX4U9yN3
        MgT14eRhmqS2QliD1wVMja8z7gt6zShRO4PEeV9mtqyvD9HluxVhbJQ1B8JM8aFS4WGXLL
        uJKp9PMgo7VaMJBEV3T6QD02aFsSYLA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-c47X0VK9MdChVwHx2_3LaA-1; Wed, 27 Jan 2021 05:35:53 -0500
X-MC-Unique: c47X0VK9MdChVwHx2_3LaA-1
Received: by mail-ed1-f72.google.com with SMTP id f12so1110405edq.15
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 02:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GvvpdQmaoclN7F+XWBVjYRaUXCYn0Re2cC+2fW1RDDc=;
        b=QRy3dYE5Kwr60pfF+mrYHvw57QRnCZU0B6NdmAgywIntVmt/AdUajtdKmsWF53PUyM
         HMmDhzcyDuJYTtpycL71Skqc1jENgim0Gq1VBEj9eTcW+LeR1PmkvTC1jgxmd55i5rhF
         H/4Z8ajz5Q2yGnZ5pu3HFJ/6+ZoycI+81JWcSn948/3dlJDHQoxZkTbflPJa+tEt0tDg
         qya84MdkOH/SCFxlHHfuP23Ocx3VmAYW3jSFdux9Nws6dS7DcOfSucbdEZ0KSaULuA5y
         5u6uIBsBexHnKwNDqjjLMazXFLhdz3ErV9v+TfBhnxZginBSIwwd/4rS0MFFsUVygTkD
         kTuQ==
X-Gm-Message-State: AOAM531DAP0ymOK0Ja0uF4bWSBewL0nBUNeTE2qV8vbI8YqnPbg4YUyX
        L1nWCX1TjiytowoMPXLvRShyKTg6rWr/UMlivQSIwsV3wkoqET42b5xj3Cc7Mlz/2PJfoEMnGSp
        2yfGVykzZaVWL
X-Received: by 2002:a17:906:3a13:: with SMTP id z19mr6631470eje.317.1611743752534;
        Wed, 27 Jan 2021 02:35:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxS1LrXNx8IVq/PgQG53ZnNilYUBzQFa0IO7CuM218q0UU+ykV2WmllqhqyX7yM4HPt/WfXQQ==
X-Received: by 2002:a17:906:3a13:: with SMTP id z19mr6631454eje.317.1611743752316;
        Wed, 27 Jan 2021 02:35:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s2sm1019933edx.77.2021.01.27.02.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 02:35:51 -0800 (PST)
Subject: Re: Thoughts on sharing KVM tracepoints [was:Re: [PATCH 2/2] KVM:
 nVMX: trace nested vm entry]
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
 <20210121171043.946761-3-mlevitsk@redhat.com> <YAn/t7TWP0xmVEHs@google.com>
 <f1c90d8a44795bbdef549a5fcf375bcf1d52af93.camel@redhat.com>
 <YA8xpfPtonJdxU2D@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61a387ca-ef02-2ba0-e48e-f25f7e62e6cf@redhat.com>
Date:   Wed, 27 Jan 2021 11:35:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YA8xpfPtonJdxU2D@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/21 22:01, Sean Christopherson wrote:
> I 100% think that VMX and SVM should share the bulk of the
> code.  Improvements to VMX almost always apply in some way to SVM, and vice
> versa.

I agree.

> IMO, after debugging a few times, associating
> error_code with the event being injected is second nature.  Prepending
> intr_info_ would just add extra characters and slow down mental processing.
> 
>> of course both it and intr_info are VMX specific).
> 
> Not really, SVM has the exact same fields with slightly different names.
> 

I slightly prefer the SVM names, using eventinj and eventinjerr in the 
trace points wouldn't be bad.

Having too many tracepoints are a problem.  Having a lot of info in a 
single tracepoint is not a problem, though.

Paolo

