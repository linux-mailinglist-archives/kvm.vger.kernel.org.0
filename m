Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A221E42F80A
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbhJOQZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241225AbhJOQZv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 12:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634315024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0dUjwksIDHaSNxgE7CPJrIi+Tw+7V2d+HBzHTp7KGdE=;
        b=h8+1yD/xsr41dZ4or3X7sFAVKEg5dz+V2B1DZv/RhFnL4ebyetKyC7RoQWbweGf1h5wvNr
        WVALWZSoDGJSnFFoX/x5Wi7E4Q3+3t7a2wGBTav+COO7xbhWqa2HMCXb//qNbmtHwpmQNn
        I84LNUiEyqcfkwhhKzPzgTOxWF1KmRc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-i27buBw-MZyO0n5IZ2q87w-1; Fri, 15 Oct 2021 12:23:43 -0400
X-MC-Unique: i27buBw-MZyO0n5IZ2q87w-1
Received: by mail-ed1-f69.google.com with SMTP id cy14-20020a0564021c8e00b003db8c9a6e30so8722500edb.1
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0dUjwksIDHaSNxgE7CPJrIi+Tw+7V2d+HBzHTp7KGdE=;
        b=RdSwpxdVT2/BeAcrTAKxXj3fGmXBfmuF1FwKblk9iwPeLroTlqAL/mUMwlYTxI+zhL
         F7cuRx09zRl4sAwGzq97Ln1+48pGESTNyqnkQQ+orBWbEdgibH+XAe3OH/SZBJgVOkdI
         uFiGVeFtG8BAiF/97+cCWBtJ/2EWMUpXJidWFx10cwtWH+zL+GxH4JVVCvL9LmyTQu5Q
         tKDhxfuAAxSvooL6OawrYxxS7XyOmkVG/7snvaQLpMqEiVO2m9v/nIEqCziSNag3J7Kz
         WvMFRuOmTLs7YTK3lUKD5HoTVkBi4+4jDRF7lEqFNeMbd+gxoipXsoK+Lf4epA0rktRz
         oOqA==
X-Gm-Message-State: AOAM530nN2k39Cboz39udLiVhZAN/hYIgUoxK6OkCUuWWB8x9OohoNcN
        nH0h6I2xia5RjQKBjv/i7DNEB/J817UERY2nTwQYiRnYJVPsOWWGGVzsKna9rEmSoyYIqoXN10t
        Rgd3fBaCA/7f2
X-Received: by 2002:a17:906:3990:: with SMTP id h16mr7584873eje.47.1634315021904;
        Fri, 15 Oct 2021 09:23:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsQGA+8BsCmr7SQSB0VxlYyCNedYLjMfVkD5Via97XqRMdShpt4MdstGB3XKIGMWZfy2B2uw==
X-Received: by 2002:a17:906:3990:: with SMTP id h16mr7584844eje.47.1634315021664;
        Fri, 15 Oct 2021 09:23:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d14sm4480865ejd.92.2021.10.15.09.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:23:41 -0700 (PDT)
Message-ID: <5faa7e49-9eb6-a075-982a-aa7947a5a3d6@redhat.com>
Date:   Fri, 15 Oct 2021 18:23:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211009010135.4031460-1-seanjc@google.com>
 <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
 <YWRJwZF1toUuyBdC@google.com> <YWRtHmAUaKcbWEzH@google.com>
 <ebf038b7b242dd19aba1e4adb6f4ef2701c53748.camel@redhat.com>
 <YWmpKTk/7MOCzm15@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YWmpKTk/7MOCzm15@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 18:15, Sean Christopherson wrote:
>>
>>                                          - now vCPU1 finally starts running the page fault code.
>>
>>                                          - vCPU1 AVIC is still enabled
>>                                            (because vCPU1 never handled KVM_REQ_APICV_UPDATE),
>>                                            so the page fault code will populate the SPTE.
> But vCPU1 won't install the SPTE if it loses the race to acquire mmu_lock, because
> kvm_zap_gfn_range() bumps the notifier sequence and so vCPU1 will retry the fault.
> If vCPU1 wins the race, i.e. sees the same sequence number, then the zap is
> guaranteed to find the newly-installed SPTE.
> 
> And IMO, retrying is the desired behavior.  Installing a SPTE based on the global
> state works, but it's all kinds of weird to knowingly take an action the directly
> contradicts the current vCPU state.

I think both of you are correct. :)

Installing a SPTE based on global state is weird because this is a vCPU 
action; installing it based on vCPU state is weird because it is 
knowingly out of date.  I tend to be more on Maxim's side, but that may 
be simply because I have reviewed the code earlier and the various 
interleavings are still somewhere in my brain.

It certainly deserves a comment though.  The behavior wrt the sequence 
number is particularly important if you use the vCPU state, but it's 
worth pointing out even with the current code; this exchange shows that 
it can be confusing.

Paolo

