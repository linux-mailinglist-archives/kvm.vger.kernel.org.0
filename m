Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D6E4A64E6
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 20:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbiBATWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 14:22:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232461AbiBATWI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 14:22:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643743327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNLZeMJ1hLmOR320BSUE5LLY5y8wE3ZrAi1Mv89JbUQ=;
        b=NvgvnSwUmE6cYMmGtc/7CUanv8tY63TCctez4FZmPoO3GhMs/eu85E3s31AgYxkcsJBhSg
        Gm9T2FxOoQEDd6TGOSVMXLJcXBNi1PkNjBs+B7F4SP9FbJncN11OGjavw8N003c7NgjTKp
        IVJ/0mDIrePDCLE3DkDtEGsxy0gY3S8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-1VG_tkd4OHuQ-oyD1wN6rg-1; Tue, 01 Feb 2022 14:22:06 -0500
X-MC-Unique: 1VG_tkd4OHuQ-oyD1wN6rg-1
Received: by mail-ed1-f72.google.com with SMTP id i22-20020a0564020f1600b00407b56326a2so9211330eda.18
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 11:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KNLZeMJ1hLmOR320BSUE5LLY5y8wE3ZrAi1Mv89JbUQ=;
        b=I0ks9PC9OW5y+mfmVBHoa7pcLJjIZeQKsrVaf69lGwQUW2qz65uyXkC7gDg5z/vo9c
         2f34txX3woLHZPT1Peb4PE1tIsYtu/6uyPCnGLjY2YVljFS6snDRqSd8SBQKkkk+LS7o
         vEwIJRughvdVbYP5CDBxSXbPJMXjmZPsHbcKgKq1oTCQC8tJClv4riLzzz7JsdQdlnNB
         JNtV2uNRYcaS/Mq6kqEYF4jos5VctjFoKLRSwcc0pePU7yzM81CaCa+D/vezjpWxebFX
         kcdKqF/SVflVUWwuIC6Ruj4dzLovObxxlYJO0aLmefj5b/ofPqq99ZHJTFNvlpR5Pg3A
         Ptuw==
X-Gm-Message-State: AOAM533HUYCvzbGSe70gh4JFYePZkJ0l4/abn3HTdpsEHkTkE+N8mQRd
        qG3P0+iDdskd3KxzhRfdtWDRDkQil114QkL76LW6HqLSHZTwPv3TIUHsy8voEi9Xb3cgh/odOV7
        xAMUWIiHsgD5J
X-Received: by 2002:aa7:c0d4:: with SMTP id j20mr26748227edp.319.1643743325128;
        Tue, 01 Feb 2022 11:22:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB0QkeShLAjTU/5/HP9pcNPzROHxknHP3s2Qa0pyu4FMnViL6Fm6YTtV2jmrf6VcpsVq4mqA==
X-Received: by 2002:aa7:c0d4:: with SMTP id j20mr26748210edp.319.1643743324942;
        Tue, 01 Feb 2022 11:22:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i6sm15057876eja.132.2022.02.01.11.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 11:22:04 -0800 (PST)
Message-ID: <ebd368c8-5c2a-dc5b-203f-f058f68b7825@redhat.com>
Date:   Tue, 1 Feb 2022 20:22:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap for
 Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <35f06589-d300-c356-dc17-2c021ac97281@redhat.com> <87sft2bqup.fsf@redhat.com>
 <66bcd1bf-0df4-8f02-9c0d-f71cecef71f4@redhat.com> <87o83qbehk.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87o83qbehk.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/22 19:58, Vitaly Kuznetsov wrote:
>> Hmm, it fails to compile with CONFIG_HYPERV disabled, and a trivial
>> #if also fails due to an unused goto label.  Does this look good to you?
>>
> Hm, it does but honestly I did not anticipate this dependency --
> CONFIG_HYPERV is needed for KVM-on-Hyper-V but this feature is for
> Hyper-V-on-KVM. Let me take a look tomorrow.
> 

It's because, without it, the relevant structs are not defined by 
svm_onhyperv.h.  Go ahead and send a new version if you prefer, I can 
unqueue it (really, just not push to kvm/queue).

Paolo

