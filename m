Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9636301F
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhDQNAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236471AbhDQNAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618664393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWecu6SQYs8uhFs35a7UYYtKfFOnP5nbm6nErBWz6m0=;
        b=bsXf8G676rFByveULvaD422uIvnvKvdFz1KZttocEMhgvsYtUejhqcNMWX3uuh6MPAfPlK
        tB0HZpVzd69pX7KmbmWn1cVGajnDu/T9Q3kW1wgOTpMb4RuU4/GGtRoeh870YMlNuuodua
        kZob3Qe14PGddILfE1KoaWzjNoAjJns=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-lvqEflrBOGuW6H-O6bOuwA-1; Sat, 17 Apr 2021 08:59:50 -0400
X-MC-Unique: lvqEflrBOGuW6H-O6bOuwA-1
Received: by mail-ed1-f69.google.com with SMTP id ay2-20020a0564022022b02903824b52f2d8so8627909edb.22
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DWecu6SQYs8uhFs35a7UYYtKfFOnP5nbm6nErBWz6m0=;
        b=cYHfnYlyT0dLCZLGinJIr38ArEVYk81yNOsQIUMkggrloLf9zHxBTl4N9ZCVB5JGOc
         DvZrQfI30iVHgjDthO8mFmDnRPas8J/HD15thOMJRAUzEAfsicSwN2NzeyTxIK6Kh7Xv
         vMnhcOJKz+h8JRmGI+OsC51NvXxw6VT6j6BidtiP4zu1yHBBuro3xRl1Tr5czWwg5twk
         iDgrpljDgBeKfKpUTkwrI41cf8+tC2Ex7lM6dXb5haooIVkluuw0C4lhPZvWRlKSoywZ
         gcbRwgO+myCh2wJLh8uJfm6q/BcC+AjDGC2t541jSTqRr1XfxFcRp5xK8UAB2Xyb2KQ3
         EQ8A==
X-Gm-Message-State: AOAM532R1teMbOnrmBb5ajl9VZeFByI+s4uFlOIFzINWvpJ6dv/KAMEd
        tb/Fv2ZJcBkZwnjCltJR4J7i6+zfAFUmMj6yZvFQEOQD15eLa3Rz43ddVUYI7rj0toNsNODZfB3
        PouvHh4BiFiF+
X-Received: by 2002:a05:6402:8:: with SMTP id d8mr15182655edu.368.1618664389797;
        Sat, 17 Apr 2021 05:59:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrZVptaxnk5HQjF08VjV788QyYwVXW9cClbLU20UdnwK7Oy+o3Do4arDm4F4eZhNef8G8c/w==
X-Received: by 2002:a05:6402:8:: with SMTP id d8mr15182646edu.368.1618664389665;
        Sat, 17 Apr 2021 05:59:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o17sm3517851edt.92.2021.04.17.05.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:59:49 -0700 (PDT)
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210413213641.23742-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] kvm/selftests: Fix race condition with dirty_log_test
Message-ID: <f5f5f2c8-6edd-129d-b570-47d8eaca94c0@redhat.com>
Date:   Sat, 17 Apr 2021 14:59:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210413213641.23742-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/21 23:36, Peter Xu wrote:
> This patch closes this race by allowing the main thread to give the vcpu thread
> chance to do a VMENTER to complete that write operation.  It's done by adding a
> vcpu loop counter (must be defined as volatile as main thread will do read
> loop), then the main thread can guarantee the vcpu got at least another VMENTER
> by making sure the guest_vcpu_loops increases by 2.
> 
> Dirty ring does not need this since dirty_ring_last_page would already help
> avoid this specific race condition.

Just a nit, the comment and commit message should mention KVM_RUN rather 
than vmentry; it's possible to be preempted many times in 
vcpu_enter_guest without making progress, but those wouldn't return to 
userspace and thus would not update guest_vcpu_loops.

Also, volatile is considered harmful even in userspace/test code[1]. 
Technically rather than volatile one should use an atomic load (even a 
relaxed one), but in practice it's okay to use volatile too *for this 
specific use* (READ_ONCE/WRITE_ONCE are volatile reads and writes as 
well).  If the selftests gained 32-bit support, one should not use 
volatile because neither reads or writes to uint64_t variables would be 
guaranteed to be atomic.

Queued, thanks.

Paolo

[1] Documentation/process/volatile-considered-harmful.rst

