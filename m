Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A048415AD92
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgBLQmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:42:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27427 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728576AbgBLQmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581525758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1adZyTOfR/v6s80ffHMqqXSo2pdemYsunr3oiNOk5/8=;
        b=FDpAX4a5P2/ROMvraq5jT5rGoOeWetBvUeUX8++aJLDobO12KDIRVGNbqeSRCj1Pp7727y
        CloV8gqjqppkVSrYIVJt363AL2p8XiYH3gtM+7N2oBMJutIhULjiZ0hnbVBfC6V0mwPMpG
        ZauQLyFS/pGxnaZBzsyo6FgAoSOboHw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-OwBvaYFoP8WwLzq8k2Q0NQ-1; Wed, 12 Feb 2020 11:42:36 -0500
X-MC-Unique: OwBvaYFoP8WwLzq8k2Q0NQ-1
Received: by mail-wm1-f70.google.com with SMTP id p26so942359wmg.5
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:42:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1adZyTOfR/v6s80ffHMqqXSo2pdemYsunr3oiNOk5/8=;
        b=ZAWTYLUi0dBTVnYUDPKCqqmp+a+TEe4tZcKs5ti9+MhNi8u26agdjAZWde8z28C/0h
         zVb+TM42CHhEGt4gYrdITTOfHGWZsrZ0ZZqhM2Ly84k8kz5sejtfA+GRTbDZ4K2v2Qlh
         jqEJBHc1bORBRvMUV0LGW3iDJpjyJXMzejrDhvNqYSflcW/B/kyQ/YqOdzGt6PvQZpQ9
         zxywsTKM5rjmP3k0TVmz8KMfq4pDbe+Nr5cJTCaLjtoJV0PlCSoh+ggWP1GkLOIod6mv
         yy8YTprqkLWQkb7uujplh4a+Nmuhl3UIhe8oLgNE9Sl7eIBDDmIADkhVjHJebcd/NWiS
         oGSA==
X-Gm-Message-State: APjAAAW7bECzdJfadZIIZJ68HhrAmQXRAqQ7/45rXsWEsdIyBPJOjGUN
        y8ZCLGAn1SF+6YVvgnbP5xzbSf1Hs2HaSfCCI0U/NA/8pMUJe2wkP9rcLTzp/7F3gSiyMV1rl/b
        O93tqgPhJ+N+c
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr15775968wrp.167.1581525755304;
        Wed, 12 Feb 2020 08:42:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxB0bsei9MGFy/+qFOztBrTBKZisUs5CRha1tPks1V/Cpgkk6GhQwqh67eqtc4RvdpsN+FipA==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr15775940wrp.167.1581525755032;
        Wed, 12 Feb 2020 08:42:35 -0800 (PST)
Received: from [192.168.178.40] ([151.30.86.140])
        by smtp.gmail.com with ESMTPSA id w11sm867177wrt.35.2020.02.12.08.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 08:42:34 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: x86/mmu: Rename kvm_mmu->get_cr3() to
 ->get_guest_cr3_or_eptp()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
 <20200207173747.6243-7-sean.j.christopherson@intel.com>
 <1424348b-7f09-513a-960b-6d15ac3a9ae4@redhat.com>
 <20200212162816.GB15617@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <de17199e-aff3-b664-73f5-9c88727d064e@redhat.com>
Date:   Wed, 12 Feb 2020 17:42:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200212162816.GB15617@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/20 17:28, Sean Christopherson wrote:
> On Wed, Feb 12, 2020 at 01:00:59PM +0100, Paolo Bonzini wrote:
>> On 07/02/20 18:37, Sean Christopherson wrote:
>>> Rename kvm_mmu->get_cr3() to call out that it is retrieving a guest
>>> value, as opposed to kvm_mmu->set_cr3(), which sets a host value, and to
>>> note that it will return L1's EPTP when nested EPT is in use.  Hopefully
>>> the new name will also make it more obvious that L1's nested_cr3 is
>>> returned in SVM's nested NPT case.
>>>
>>> No functional change intended.
>>
>> Should we call it "get_pgd", since that is how Linux calls the top-level
>> directory?  I always get confused by PUD/PMD, but as long as we only
>> keep one /p.d/ moniker it should be fine.
> 
> Heh, I have the exact same sentiment.  get_pgd() works for me.

Ok, I'll post a patch that uses get_guest_pgd() as soon as I open
kvm/next for 5.7 material.

Paolo

