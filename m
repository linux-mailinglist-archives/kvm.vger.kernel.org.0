Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F354379DB
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhJVP1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233412AbhJVP1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:27:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKn/MMnrjzSTMvrkCX2L7r2/M5K0U88gx7mskxYYYD8=;
        b=PPxKsEu/pBMspA3dFpP/TF0u33zvmJHP7KyzDsBNjK+0O+7YsK52gwS1UJxTuyL/EX1S0t
        ejj+9885F42Baxm9d0grs1cPd6nRM6F44HxFNfIW44KXwdoDk9Qcjo9p2AzYnRMzFyIbQY
        AeFNY5Nt5grpxSYeOSKBWfDjfJkeDt4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-Tg54rfouNtSUaN-wrWSZwA-1; Fri, 22 Oct 2021 11:24:55 -0400
X-MC-Unique: Tg54rfouNtSUaN-wrWSZwA-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so4010412edl.17
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WKn/MMnrjzSTMvrkCX2L7r2/M5K0U88gx7mskxYYYD8=;
        b=VIUOlsaM5WNRL3vKdcI0TrPB8VHowod+BxqpdCUFXrOfUtKJHz0jazWxcXpsi7iL+h
         Mp4F1/K5crdjqpJxK/RgbwZOEut0acRVdZIeWNdw0QPP8dzsi6euLi1rU9QktHfOivkm
         LrHeIU1+ryOts8o31j+gE3DtDB4CTxO4d/91rK1A0KYlsgZe36HLH6th3YZmOKNg1UuC
         PBWeJr4dsoD2OkJwiiBJb2AcO/zV6aDWk3XkIiCU7JFk8vGYllT/b6qNE6nbFscmSTxw
         Vm+/ULAxvz4PXzlWnOj1iqtB+3eozO4ddagjVAQeny66k/HLEEVOpXNDc5RGuvfUjqFy
         PLJQ==
X-Gm-Message-State: AOAM532rDw/Im0pbPpHU4aS+0DZZjJMwx+2PCzzT7SSWR8Yz9B+QSpe7
        60OKWy3FrpUnh+QweekA3sLE3Gj/PN1zppNmK9tp/PHtvpfgWPg07wq2JdCniA6CSjF9RUXs1FT
        mkbOzXPWEQDab
X-Received: by 2002:a17:906:ca18:: with SMTP id jt24mr227111ejb.325.1634916294057;
        Fri, 22 Oct 2021 08:24:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1gMsV0VbjksXEJRF9KOJy6vrhOLALRqiJ74io2ME1xy22uV1bJNsaAASMo+PgzQ54ZbscQg==
X-Received: by 2002:a17:906:ca18:: with SMTP id jt24mr227080ejb.325.1634916293883;
        Fri, 22 Oct 2021 08:24:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l23sm3922047ejn.15.2021.10.22.08.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 08:24:53 -0700 (PDT)
Message-ID: <44630562-a855-f3e2-a427-9f3da3abdd70@redhat.com>
Date:   Fri, 22 Oct 2021 17:24:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v6 1/4] KVM: x86: Clarify the kvm_run.emulation_failure
 structure layout
Content-Language: en-US
To:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
 <20210920103737.2696756-2-david.edmondson@oracle.com>
 <YWYeJ9TtfRwBk/5D@google.com> <cunfst5ff37.fsf@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cunfst5ff37.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 11:29, David Edmondson wrote:
> On Tuesday, 2021-10-12 at 23:45:43 GMT, Sean Christopherson wrote:
> 
>> On Mon, Sep 20, 2021, David Edmondson wrote:
>>> Until more flags for kvm_run.emulation_failure flags are defined, it
>>> is undetermined whether new payload elements corresponding to those
>>> flags will be additive or alternative. As a hint to userspace that an
>>> alternative is possible, wrap the current payload elements in a union.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>>> ---
>>
>> To complete the set... :-)
>>
>> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> Thanks!
> 

Queued, thanks!

Paolo

