Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E743DA91E
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhG2QbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:31:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232013AbhG2Qa7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 12:30:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627576255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=orFog0sxfUadBkEgJaJjuoSWySLaowDikIZVY8CyGTw=;
        b=dspfyz4NrIhmn4vwZf13U/req2N7klc2w6NjrjlDFvhgPo4Xcrt1Ual6Hitn6G5VrUvpNI
        Yx1ZgpH6kxn8J8UMlg6SeOjVjfbuT50yKUrk/QnjNnR1uDmxL6qZjPCpVoqcKoA/U353UG
        ew3vBd4Z5kWA1JZRi7u4cnfPRrhSEwg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-x_vU8EerNf6HnXLN9j6hdQ-1; Thu, 29 Jul 2021 12:30:53 -0400
X-MC-Unique: x_vU8EerNf6HnXLN9j6hdQ-1
Received: by mail-wm1-f71.google.com with SMTP id k13-20020a05600c1c8db029025018ac4f7dso2179968wms.2
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=orFog0sxfUadBkEgJaJjuoSWySLaowDikIZVY8CyGTw=;
        b=raPviO7RyiAcvjcPHInfUW11tDiiLxGS35Fn6HLTlnQqwyhE9ih+k7mQsHX1KlyiXO
         mJy5slhKZQ0WEkEO2YRk5LIuH57eSAMFbe9QAfi/DN/nz9dhZXAiGfMSpM+hC2j+KZSh
         b+T8cvzyw/VOaRcfc5O2lVosPs/s38RBYEtIbeq6IhtgxrnbUtuf7F8wsixjwV++da8G
         QA4ykmlCNR6/Etdeb/MmVkerHH1LFyW7wzo/XSIRR4Nc6OT6fbpe9mTvabjt5vnGvekA
         xFh1CHhE1dQjtRHTck1z1EqRSTrPnCkZwS5SC8S43ZkKTjNQg9even68Mb3YFW2V26oz
         /DwQ==
X-Gm-Message-State: AOAM530Lr8rr61v5+xCSXIsw3NfQ00ZLLpXmgZ5wgukyMdFau2nDXyrk
        kbxyGWVpI+gH0AXFe+3OH5YEkwQGlasi94YLRxsNgEYkceXoCiEOOdt6ywZgGQjuZa81M3VGKUk
        +rbFf7A35GuQL
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr5512873wmh.56.1627576252722;
        Thu, 29 Jul 2021 09:30:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8op0aYdpNBUVNZ07xifizo4nlPJ/0UHrFszSxe4dMu5xaM7/9rONhD05PbI9DYilr5YLi6g==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr5512856wmh.56.1627576252496;
        Thu, 29 Jul 2021 09:30:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g138sm4927501wmg.32.2021.07.29.09.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 09:30:51 -0700 (PDT)
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210726165843.1441132-1-pbonzini@redhat.com>
 <87zgu76ary.fsf@vitty.brq.redhat.com>
 <1d82501c-05fd-deff-9652-790cde052644@linux.microsoft.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is
 initialized
Message-ID: <38eb919c-2da1-648e-10a4-a76205fd5e96@redhat.com>
Date:   Thu, 29 Jul 2021 18:30:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1d82501c-05fd-deff-9652-790cde052644@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 22:18, Vineeth Pillai wrote:
> 
> On 7/27/2021 11:23 AM, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>
>>> Right now, svm_hv_vmcb_dirty_nested_enlightenments has an incorrect
>>> dereference of vmcb->control.reserved_sw before the vmcb is checked
>>> for being non-NULL.  The compiler is usually sinking the dereference
>>> after the check; instead of doing this ourselves in the source,
>>> ensure that svm_hv_vmcb_dirty_nested_enlightenments is only called
>>> with a non-NULL VMCB.
>>>
>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> Cc: Vineeth Pillai <viremana@linux.microsoft.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> [Untested for now due to issues with my AMD machine. - Paolo]
> Finally got hold of an AMD machine and tested nested virt: windows on 
> linux on
> windows with the patches applied. Did basic boot and minimal verification.
> 
> Tested-by: Vineeth Pillai <viremana@linux.microsoft.com>

Thanks!  In the meanwhile I had fixed my machine too. :)

Paolo

