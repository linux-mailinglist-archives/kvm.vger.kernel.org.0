Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF5740C1F2
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhIOIpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 04:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231747AbhIOIpk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 04:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631695461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADrqp1/QUIGA/T7aV/2lJTe0h/xjpqwDvAEv0yJIxIE=;
        b=Wue1J18LTE3Hie5Wu9ZummcLQPD9zm6wShMTEFSgnbye3s5is1tjs69eaJO2JlBa+liI7Z
        s8kvirKSqKtINW75cjyLC0zWt0OsRyhJ2imd/0S8REg9vnF9+RYVmldnUzzV8b+2bjwJ7x
        vEOTN2iugv3Fqw2uhmPiez+UeE2aG1w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-umwbts8aMz2s5_lHxtNAsQ-1; Wed, 15 Sep 2021 04:44:20 -0400
X-MC-Unique: umwbts8aMz2s5_lHxtNAsQ-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a056402270a00b003c8adc4d40cso1179955edd.15
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 01:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ADrqp1/QUIGA/T7aV/2lJTe0h/xjpqwDvAEv0yJIxIE=;
        b=ZKk/hlFj91R/UDycp6F+wGtUW2Qr3QhJiTDpmH9n0kgN3oaoSBCWAYXYf1J2oBiUgK
         beNy1XDqXp8p1gloiGfD3ogBrjxV8PIRfLQVmK84YoH6F1nZMJYfJXOq6o7lSxifBLHE
         d0hDMS/ZFwzORbZg4/KUnANVEIbYNULuN2WsNI7Xbe5JsaAO6kEpRRSwVuM3I9A7g/2i
         Smt/4SxbzrNSsctNJAaWnxy4dyb9djTQ+j/NilN4qL0DvYMYQhBAXn66+arhsXsZXpCG
         DckWNBVCCPb72WlZkLK3+au7HnBv7phck1ZB47poA4n8mXcuQAxkd2+BJvwq5GcfNDbF
         A0xQ==
X-Gm-Message-State: AOAM530VeNrP5uyUfuXhW6SjVdrNDFrN3brzf/t8ArBbEci7ciQKQjVS
        jO6iAdQgDF3IzNax4WSlwCQu/IXD+wTTPAee63C8prCav+kuiieA26nqVa9SO5rB4sHm7qcd4tm
        gQ41HPWK28Xb3
X-Received: by 2002:a17:906:720e:: with SMTP id m14mr23382026ejk.500.1631695458863;
        Wed, 15 Sep 2021 01:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYJf8R+muJrg6i1DgERLQ+Qjby5sOQnwwLs5CQhAF0+bn8gEhcl2FLgZ/RVYOHNg30uMCZAA==
X-Received: by 2002:a17:906:720e:: with SMTP id m14mr23382008ejk.500.1631695458655;
        Wed, 15 Sep 2021 01:44:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mq25sm5416905ejc.71.2021.09.15.01.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 01:44:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for
 SEV-ES
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
References: <20210914171551.3223715-1-pgonda@google.com>
 <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com>
 <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
 <YUDuv1aTauPz9aqo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
Date:   Wed, 15 Sep 2021 10:44:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUDuv1aTauPz9aqo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 20:49, Sean Christopherson wrote:
> On Tue, Sep 14, 2021, Peter Gonda wrote:
>> I do not think so. You cannot call KVM_SEV_LAUNCH_UPDATE_VMSA on the mirror
>> because svm_mem_enc_op() blocks calls from the mirror. So either you have to
>> update vmsa from the mirror or have the original VM read through its mirror's
>> vCPUs when calling KVM_SEV_LAUNCH_UPDATE_VMSA. Not sure which way is better
>> but I don't see a way to do this without updating KVM.
> 
> Ah, right, I forgot all of the SEV ioctls are blocked on the mirror.  Put something
> to that effect into the changelog to squash any argument about whether or not this
> is the correct KVM behavior.

Indeed, at least KVM_SEV_LAUNCH_UPDATE_VMSA would have to be allowed in 
the mirror VM.  Do you think anything else would be necessary?

Paolo

