Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B8C2FA804
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436744AbhARRqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:46:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407224AbhARRke (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:40:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610991544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZseZIi8yX5S303NGIXXx/ulrgZxg6NH+kedVFwQTEs=;
        b=IYpojVc5EsTUUEoskKRNCExo57nxgy3RAx8E72nm/HGye90ehNqecr+MCjXLuJYclCLiqd
        u3e/Oynl7iXAp5GBiZbmMrj/LL2GrP2qD5sQS6EnS8EG+V+1zli0v3HnHOXBwlZcNaEDgv
        vstZmgOx/OJM2zXHvGYyYincDFyqVNI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-l3VgsOysO4aJruRREo4P_g-1; Mon, 18 Jan 2021 12:39:02 -0500
X-MC-Unique: l3VgsOysO4aJruRREo4P_g-1
Received: by mail-wm1-f70.google.com with SMTP id u1so1262586wml.2
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZseZIi8yX5S303NGIXXx/ulrgZxg6NH+kedVFwQTEs=;
        b=SkecKu2+YRaQIs4H6Xg/3v7cMVbJiR5cJ0GMxDt5IfI+mkeLWpmNpUSgif+JudkLQZ
         d675hS0+uTNkIhiaZmoTxkOz4NT5SXLQmvBYlsW1vQr1a7mullFacjAaosjHYZ2ieTDU
         Ju9Rsyk7/k7WcGsgK/mi0glMMtcDxQKZyh8LBuoQzuN+0Q1iAsKSKUppD9sAd0L4aApP
         WDEtCCDZONVGkwuL7bPFb5MZNj7WoTfpiqdJnhrShz6fKjyaZA3NjvYiiIwfpJVPA98/
         osv3dkJvVKYBLKdyteMQOElTZj4RVt4gLnd3eaw0tEeIQJsNeawRVvKhDb99p/+mBdKC
         efNA==
X-Gm-Message-State: AOAM532s+13j/Foy6XpUkub5Y5Wnj8u6PbjGczdgIlNmPqbTuYSit3HH
        i/A4ejMy6tGGOP5yS51KIj8Xnam9Q9z/tCv6eAxkQFs5Ht/g/uAXpe32ukAsXCYBo6YQNC7YMWo
        SnZkObLlkl65z
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr524714wrv.375.1610991540878;
        Mon, 18 Jan 2021 09:39:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzApCklNf3IsEiyOZJobGsxyao7L2kwG6STK5+IwNUs02K7KxFZ5oPtNL0EUhAYdjCSWDJH6A==
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr524708wrv.375.1610991540752;
        Mon, 18 Jan 2021 09:39:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b132sm29295wmh.21.2021.01.18.09.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:39:00 -0800 (PST)
Subject: Re: [PATCH] KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
To:     Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        android-kvm@google.com, kernel-team@android.com
References: <20210108165349.747359-1-qperret@google.com>
 <20210115165004.GA14556@willie-the-truck>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb2cc30f-5a9d-ce7c-61e9-ff62ad90e035@redhat.com>
Date:   Mon, 18 Jan 2021 18:38:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115165004.GA14556@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 17:50, Will Deacon wrote:
> On Fri, Jan 08, 2021 at 04:53:49PM +0000, Quentin Perret wrote:
>> The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
>> as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
>> ioctl.
>>
>> Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
>> Signed-off-by: Quentin Perret <qperret@google.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 70254eaa5229..68898b623d86 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -1328,7 +1328,7 @@ documentation when it pops into existence).
>>   
>>   :Capability: KVM_CAP_ENABLE_CAP_VM
>>   :Architectures: all
>> -:Type: vcpu ioctl
>> +:Type: vm ioctl
>>   :Parameters: struct kvm_enable_cap (in)
>>   :Returns: 0 on success; -1 on error
> 
> I tripped over this as well, so:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Will
> 

Queued, thanks.

Paolo

