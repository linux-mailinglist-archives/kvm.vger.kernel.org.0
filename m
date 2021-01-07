Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC102ED641
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbhAGSAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbhAGSAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 13:00:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB232C0612F6;
        Thu,  7 Jan 2021 10:00:02 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dk8so8674302edb.1;
        Thu, 07 Jan 2021 10:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MjU7hC1ZlO0b74jFg9ZywySOI1ZO5CsVl4MzCXVYPGc=;
        b=EF7jAUH7PG+AWd63ehZRfFnTZzTfZC6ou5iHsCaFFQvzbQo0JdzfCFGNlJYik9tevJ
         8WiggIiJ+W18sG9SpoZUpXLru5GQeYLZYfdyhoD4bjDxul75cc+Ace9kSvZuYuflAgIb
         RG9t6mzqBphTlXYx4wyuCo9WhyiU+zwAh2f9OTOxrkpeumJ7qLi2UnKd+EidtmRoqJdi
         Bs8tNB10lGI8U6L3xPho5HOI3u75Ll9aRvxzD08BFUlQbPEn+Ssu70LDEwzsicM7cEQs
         qMacDkEke/XGivPNgYEgPlmYZZgh53uYTVrIxvzBJe7hBC9/9pkR3pkdwMDN0AcLGqFo
         +6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:references:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjU7hC1ZlO0b74jFg9ZywySOI1ZO5CsVl4MzCXVYPGc=;
        b=OrsTpZhlMsJ3I+t8cSdq2N8HpstRmbcdncwfSv+mcbUaxr+U/au20YnoO9TDnVtyV/
         QHTnoxpq7cmTuXB0PDeObbX13W13cg6gDMff+OWrYl9KhlFCQRX6ERJ7LgncNhbB+Dsa
         fvYTIKr4diWJOo2IklNqcaY4ni3mFHKNIbOmbiwIdJ2YzVDvM8OeHdO6BtAANfu19EPh
         ruPujBOpOjkAXqD+05ZHwbmUqoUWZQRT0ApAZCcfufQNmPn/a0D1Z6KXxNke5IVCRSJP
         b6qJGbKW1sUYSZKpsui2jME2VAEk0h4CT5OAXkAohbZlgHGBZ/ZAYy7te0eALPHeQadG
         vM4A==
X-Gm-Message-State: AOAM532NhqbbmWdiFXndiWm2BHWc8zsJNM4pF/+KhfyPFGcbkR8/3m17
        GFR8TYTkoRaX1giX9UQs6xo=
X-Google-Smtp-Source: ABdhPJwaX379R6wTIVqh/ItvPrM/BvfiylTPwkuFTHPpTQDeNQLlLG6o65dTmhJFmdcC8OyfAacKow==
X-Received: by 2002:a50:fc13:: with SMTP id i19mr2594263edr.281.1610042401515;
        Thu, 07 Jan 2021 10:00:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id pk19sm2739022ejb.32.2021.01.07.10.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:00:00 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-2-mlevitsk@redhat.com> <X/c+FzXGfk/3LUC2@google.com>
 <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
 on nested vmexit
Message-ID: <28958ec1-5ca4-f4a7-e8d7-189e87235cff@redhat.com>
Date:   Thu, 7 Jan 2021 18:59:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 18:51, Paolo Bonzini wrote:
> On 07/01/21 18:00, Sean Christopherson wrote:
>> Ugh, I assume this is due to one of the "premature" 
>> nested_ops->check_events()
>> calls that are necessitated by the event mess?  I'm guessing 
>> kvm_vcpu_running()
>> is the culprit?
>>
>> If my assumption is correct, this bug affects nVMX as well.
> 
> Yes, though it may be latent.  For SVM it was until we started 
> allocating svm->nested on demand.
> 
>> Rather than clear the request blindly on any nested VM-Exit, what
>> about something like the following?
> 
> I think your patch is overkill, KVM_REQ_GET_NESTED_STATE_PAGES is only 
> set from KVM_SET_NESTED_STATE so it cannot happen while the VM runs.

... and when leaving SMM.  But in either case, there cannot be something 
else causing a nested vmexit before the request is set, because SMM does 
not support VMX operation.  So I still don't think that it justifies the 
extra code and indirection.

Paolo
