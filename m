Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D419E3517DE
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhDARm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234724AbhDARj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/BBKBlx1OfSHWLkYgonnSO4l/9MHzCO752YaBajZ8Q=;
        b=e/y5Vt107g4vnqRGvS5uGHAH0rQ8rCJDmLbeeOtclNDj9oiB1YSZCCEXMEXPAgYuL59iGL
        9Ec1EKJ8pRj+umymYx8e+vyu2MzfaT+Nmj0iqmfFOPWaRoQpeyeCuHWt4uQPIeuZar87oy
        6Th8uc9+QOGB9RiGQA3g+L1P0qSXxFk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-dV_aIS8xMn2OfWkwwHle1g-1; Thu, 01 Apr 2021 13:33:15 -0400
X-MC-Unique: dV_aIS8xMn2OfWkwwHle1g-1
Received: by mail-ed1-f72.google.com with SMTP id t27so3194866edi.2
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 10:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d/BBKBlx1OfSHWLkYgonnSO4l/9MHzCO752YaBajZ8Q=;
        b=spLjSL/GbEc4wQwV/pErJ1t4Uf1djd/i7wnFUbgAML5Fs+lEbuosy9EtwHqQDYDi4O
         pNIXNd7cP4mkhpTANn/Tby2dfG9qnd1OVI8tGrVh38l615TZ3npax2+UeoKLsgQlL0oZ
         s5qKkb+VZlzI5ylnBBbpa5zSdMVtWPDaUDyxy46snv8ORmJxUftWS5O/yEi3JUGvUYxc
         xNsBA59YymxbAoe+ROwHILC75SeVfHTkYaBIW8VsrjZoEjnjvDynh4EJ5ksma1ZcG+nD
         I0MQzCPX4i6XLR8mpoUBYf5XuZbYdNO8L9Xk698q4aRRwRp2C6noaemY+Q8i26bzy/OA
         PcjQ==
X-Gm-Message-State: AOAM533UU6qJbLOrNWbtHvcZ6xaMACABNVlKtrIyIMY6X/6Pe1B7IPjl
        Llm3yptx8d5HI/6Afzy//0MeMgNW3RIm/S7CcMC4YawpNW7iIKPU7q0ITklYBbqCfF1JIi7PrVi
        Sn2YypDbAzuto
X-Received: by 2002:aa7:c5cf:: with SMTP id h15mr11231694eds.190.1617298394506;
        Thu, 01 Apr 2021 10:33:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZfN64zCsvdLd6I8M1pmmbc99mo22JNIWQgtMGhG11m0FRnXFOPVa57b9jEod6y04/Mur8fw==
X-Received: by 2002:aa7:c5cf:: with SMTP id h15mr11231685eds.190.1617298394363;
        Thu, 01 Apr 2021 10:33:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q26sm3097846eja.45.2021.04.01.10.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 10:33:13 -0700 (PDT)
Subject: Re: [PATCH 4/6] KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-5-mlevitsk@redhat.com>
 <b1a36c94-6dd5-88ef-a503-f6d91eb2d267@redhat.com>
 <0b3a93e3d1ba6a89da327b93be2ecf47f22010d4.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <514c1f1f-5c7d-7b27-b893-87d9b85db523@redhat.com>
Date:   Thu, 1 Apr 2021 19:33:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0b3a93e3d1ba6a89da327b93be2ecf47f22010d4.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 19:10, Maxim Levitsky wrote:
> I haven't yet studied in depth the locking that is used in the kvm,
> so I put this to be on the safe side.
> 
> I looked at it a bit and it looks like the pdptr reading code takes
> this lock because it accesses the memslots, which is not done here,
> and therefore the lock is indeed not needed here.
> 
> I need to study in depth how locking is done in kvm to be 100% sure
> about this.

Yes, SRCU protects reading the memslots (and therefore accessing guest 
memory).

>> 195, not 196.
> 
> I am also planning to add KVM_CAP_SET_GUEST_DEBUG2 for which I
> used 195.

Sounds good then.

Paolo

