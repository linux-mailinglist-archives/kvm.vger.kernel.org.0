Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42171390664
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 18:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhEYQRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 12:17:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233302AbhEYQRi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 12:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621959363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWKQ2FRMeKpEI6HlpFxdCErCeQjuf2CVv/zTj1uud2U=;
        b=Z98UUDe35mDhtxT2YFgpuRrBQewpgCGUuzny+7IEDP+FPEvdv8ekp/h1r0E5cPn4O/Xs+i
        xzumUjPhXdmjdrmUwjwQyqo6x4QQ604Lag6dK+92qGCTHYOpK2h1YXsBbyI41RlrZRYdfp
        dDjmqetiIzhI5wuzjnPw9n9oJeD/c0A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-r1tf-S3mMz-oMYfgiDEwjg-1; Tue, 25 May 2021 12:15:59 -0400
X-MC-Unique: r1tf-S3mMz-oMYfgiDEwjg-1
Received: by mail-ed1-f70.google.com with SMTP id v18-20020a0564023492b029038d5ad7c8a8so12673713edc.11
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MWKQ2FRMeKpEI6HlpFxdCErCeQjuf2CVv/zTj1uud2U=;
        b=oZ7xwXQv4vVSRPeYpqxoST7oRb4zFN/84TlmrxL3JVSeEKWkJqw5RxRd3O4a5YO/op
         pyi/Ey4JeVYYKH76/pxPrrez2/nwhFRFHDl70wn3CruSvvy+VFPZarfiGzHw9TDLlXXH
         5pmPieiSVFb9ITxRSThra8M1IlJa4LTGthp14RglCtnKTZ/nR9EHCJeJPzzjWaYwGwup
         XCLH8577wFtZBUS0qk4QjXiOk2X3mqWWrKPquiHfFos+8yH3e8Pyar+dfSMzqy34llzz
         HhgHRtwlhr1EhfiVszy0V3/8pEO5GM7NlJzemujXd3B7CwxjjI7DmRcIkXh5b3BoJnE+
         d7DA==
X-Gm-Message-State: AOAM531UIy+h52eRJkpsY014pWBKu6Q5cyzvtlYJxueIRC+EvWo3PuiZ
        +WJbY8xEx3l6mecOi8GuBuD7kN5yJcGcN5gXcO/KgceNITTPUZxADLPI9As8Q7KJkPTrfQ9ii7O
        UQWkTF6TbV0nQ
X-Received: by 2002:a17:906:3644:: with SMTP id r4mr29254815ejb.140.1621959358262;
        Tue, 25 May 2021 09:15:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Pf5t+DkvwwiPx0XllA23W7L/9RiYDfji124wzQSvXBcL3fzCNNBoTyrr73mQ0LIqxj2Slw==
X-Received: by 2002:a17:906:3644:: with SMTP id r4mr29254792ejb.140.1621959358110;
        Tue, 25 May 2021 09:15:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gt37sm1929280ejc.68.2021.05.25.09.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 09:15:57 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-10-ilstam@amazon.com>
 <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
 <YKv0KA+wJNCbfc/M@google.com>
 <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
 <YK0emU2NjWZWBovh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Message-ID: <0220f903-2915-f072-b1da-0b58fc07f416@redhat.com>
Date:   Tue, 25 May 2021 18:15:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK0emU2NjWZWBovh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 17:58, Sean Christopherson wrote:
>> The right place for the hw multiplier
>> field to be updated is inside set_tsc_khz() in common code when the ratio
>> changes.

Sort of, the problem is that you have two VMCS's to update.  If properly 
fixed, the cache is useful to fix the issue with KVM_SET_TSC_KHZ needing 
to update both of them.  For that to work, you'd have to move the cache 
to struct loaded_vmcs.

So you can:

1) move the cached tsc_ratio to struct loaded_vmcs

2) add a function in common code (update_tsc_parameters or something 
like that) to update both the offset and the ratio depending on 
is_guest_mode()

3) call that function from nested vmentry/vmexit

And at that point the cache will do its job and figure out whether a 
vmwrite is needed, on both vmentry and vmexit.

I actually like the idea of storing the expected value in kvm_vcpu and 
the current value in loaded_vmcs.  We might use it for other things such 
as reload_vmcs01_apic_access_page perhaps.

Paolo

>> However, this requires adding another vendor callback etc. As all
>> this is further refactoring I believe it's better to leave this series as is -
>> ie only touching code that is directly related to nested TSC scaling and not
>> try to do everything as part of the same series.
> But it directly impacts your code, e.g. the nested enter/exit flows would need
> to dance around the decache silliness.  And I believe it even more directly
> impacts this series: kvm_set_tsc_khz() fails to handle the case where userspace
> invokes KVM_SET_TSC_KHZ while L2 is active.
> 

