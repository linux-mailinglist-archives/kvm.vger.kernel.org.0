Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55529E3F2
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 08:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgJ2HYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 03:24:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgJ2HYI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 03:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603956247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNtlQgloUeeFpFm/UYnd2QqHmCntydKiC9S5aRwY9pM=;
        b=C9kL2ZXn6g9CuajaolZscrS57gR8yi8ZKmdC84JVfYEGwzYljmkDdYvtX/4pVBunuE9jm/
        1BpFuRipmJVb7rg8kR3oWrHudzqWgUDc6kkweDh7en1iWYMTaTomyT6W+muuImHv8/T9QT
        ME+XTY/AWhPdhD0kextch8BQgsqCpCE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Zg4azvf9MpWTPzjAiO35zw-1; Thu, 29 Oct 2020 03:08:51 -0400
X-MC-Unique: Zg4azvf9MpWTPzjAiO35zw-1
Received: by mail-wm1-f70.google.com with SMTP id c204so751020wmd.5
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 00:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNtlQgloUeeFpFm/UYnd2QqHmCntydKiC9S5aRwY9pM=;
        b=Ag/d3Jj8ZyM+wHNmk7xpw6PQX+IW6JDKdiEKDB5tgtFRUwbZMbrYqH0iiAWQNI97zY
         Acud8DsHXKyI5Eyk7PFQai/zyRnuXUZOwogb6r7uSXeVGHgmpZRYVRgiksvqwTCSevG4
         Efw+CphyqHEQq6q3U6PoG/vmJOzYiWV0aCoQp5Oo90kmVkQ5d85iQRKkhlHNLywIQyPg
         xUzZkiKU1+wdFNQYHOenikDP+jkMEHf0AGtuPrUFltRpSq1VPSByBiBH03tcOwviCjwU
         TtwYJqxIL4VF7BaIIT6e4v9m9JzuCSqj6/ufjm/q/qpbLxG5OI5/86m6fNF6MeLoq6jN
         jxTA==
X-Gm-Message-State: AOAM530yPpGQQ+ruCLvPJ0BtZTPEF86oWXg4wGP149Fwahna0bWVfiQs
        skgQmRFkERxrlPEaZWx58J1YMQ0cOD1bJeSwhxPGB5fNczxFF6y6G/3UlMnZpoXjiXIn2jo6IJg
        Kr0od6qQLXJrs
X-Received: by 2002:adf:ffc7:: with SMTP id x7mr568877wrs.168.1603955329819;
        Thu, 29 Oct 2020 00:08:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzr5QxiaeE97A/Ch6ysaWmySxBZDFTK07rkynbJmQuuifl6JLmIofOedm/gYiPVF5PhrM6sgQ==
X-Received: by 2002:adf:ffc7:: with SMTP id x7mr568856wrs.168.1603955329628;
        Thu, 29 Oct 2020 00:08:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r18sm3462688wrj.50.2020.10.29.00.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:08:49 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Add macro for hugepage GFN mask
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
 <80038ae1-d603-dc22-1997-1ad7da0a936d@redhat.com>
 <20201028152948.GA7584@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3d68b2b-2af6-04ce-c5f6-47786d9a15bb@redhat.com>
Date:   Thu, 29 Oct 2020 08:08:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201028152948.GA7584@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/20 16:29, Sean Christopherson wrote:
> The naming and usage also aligns with the kernel, which defines PAGE, PMD and
> PUD masks, and has near identical usage patterns.
> 
>   #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
>   #define PAGE_MASK               (~(PAGE_SIZE-1))
> 
>   #define PMD_PAGE_SIZE           (_AC(1, UL) << PMD_SHIFT)
>   #define PMD_PAGE_MASK           (~(PMD_PAGE_SIZE-1))
> 
>   #define PUD_PAGE_SIZE           (_AC(1, UL) << PUD_SHIFT)
>   #define PUD_PAGE_MASK           (~(PUD_PAGE_SIZE-1))

Well, PAGE_MASK is also one of my pet peeves for Linux.  At least I am
consistent. :)

>> and of course if you're debugging it you have to
>> look closer and check if it's really "x & -y" or "x & ~y", but at least
>> in normal cursory code reading that's how it works for me.
> 
> IMO, "x & -y" has a higher barrier to entry, especially when the kernel's page
> masks uses "x & ~(y - 1))".  But, my opinion is definitely colored by my
> inability to read two's-complement on the fly.

Fair enough.  What about having instead

#define KVM_HPAGE_GFN_BASE(gfn, level)  \
   (x & ~(KVM_PAGES_PER_HPAGE(gfn) - 1))
#define KVM_HPAGE_GFN_INDEX(gfn, level)  \
   (x & (KVM_PAGES_PER_HPAGE(gfn) - 1))

?

Paolo

