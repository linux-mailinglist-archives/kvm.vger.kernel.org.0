Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410C61140F2
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLEMnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 07:43:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729096AbfLEMnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 07:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575549799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1WWgL8RuF7Fs6ltC0qLeONxSmgpXtqUlxEFsxvFm70=;
        b=h2L4BFikSImluv5NCO4YEZKZ/j4mlAJiQ0u6WWdISl7FwmVA3rMqBUTDp+Y955wsfhv52g
        H2s9x7mVvT9DLXe3esxEWjzFdnULQ/TNwMj0Q8pXvxS7bAozh8SQJLtSoxAjbua6YTW0YR
        QalTzyh/q/5WSZGcixRQ+yYMjlFG3Cg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-Pyk_hMW8NQC3jl6bMKqF7w-1; Thu, 05 Dec 2019 07:43:16 -0500
Received: by mail-wr1-f70.google.com with SMTP id o6so1481272wrp.8
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 04:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1WWgL8RuF7Fs6ltC0qLeONxSmgpXtqUlxEFsxvFm70=;
        b=Hb2k8FrmwNUYzekeusn0sW9+P5NFDDwMnO9p0tOhkrJVY9tqRHJi0Pa3EpYOSfP2sM
         UB7iG+qdV0w7H3u24bC9cKrOHQXhmXRr5x/pUS7p/A7I+1Wo9HXTIldUn4dFBrElAqZ8
         hLsSaCFJQgi9P8cdJKn8WOgtxOmaRKXkXubmacYCZSWaEPBa2ZWpWY6x3I7Xdcc1PSQr
         L2SPX7qf5acuG4NWRs8nzS4XUlO39DuKyyCR5wfle7qfjjjuFyYmmEmU3YfruO9qLDEP
         VG5S7ntoh2LfeCaueCGOxFj7qqVU/dIdTdF0VwlRxegLng7wqL+7qhVznWqAbUMvX33t
         O6SQ==
X-Gm-Message-State: APjAAAWA2qybkCmEulI6bECbJibY0Nvwmc4YOVVhBSsd6yv0WVNL+AZd
        xwd1pm81G+YlAgTJlMvLI+72pYAYeSJYxu0brVf05qWg21FGBMPZEXq1FzfDjdggcnYhGeaTt5S
        Lcg3Lw4alULzk
X-Received: by 2002:a7b:cf16:: with SMTP id l22mr5136175wmg.79.1575549795077;
        Thu, 05 Dec 2019 04:43:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxtlO4z7GX9u/dCNLdQj6viEVF9+IodBKkT+pZtFOZQY3Da/hnmj69WiiFuDi52LhUSCM+UcA==
X-Received: by 2002:a7b:cf16:: with SMTP id l22mr5136156wmg.79.1575549794833;
        Thu, 05 Dec 2019 04:43:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id d10sm11953556wrw.64.2019.12.05.04.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 04:43:14 -0800 (PST)
Subject: Re: [PATCH v5 0/6] KVM: X86: Cleanups on dest_mode and headers
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9359243b-eaaa-99aa-af75-371587e75eb5@redhat.com>
Date:   Thu, 5 Dec 2019 13:43:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
Content-Language: en-US
X-MC-Unique: Pyk_hMW8NQC3jl6bMKqF7w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I actually prefer 0 to APIC_DEST_NOSHORT, but who am I to complain if
someone else is actually cleaning things up.

Queued, thanks.

Paolo

On 04/12/19 20:07, Peter Xu wrote:
> v5:
> - rename param of ioapic_to_lapic_dest_mode to dest_mode_logical [Sean]
> - in patch 5, also do s/short_hand/shorthand/ for kvm_apic_match_dest [Vitaly]
> - one more r-b picked
> 
> v4:
> - address all comments from Vitaly, adding r-bs properly
> - added one more trivial patch:
>   "KVM: X86: Conert the last users of "shorthand = 0" to use macros"
> 
> v3:
> - address all the comments from both Vitaly and Sean
> - since at it, added patches:
>   "KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand"
>   "KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK"
> 
> Each patch explains itself.
> 
> Please have a look, thanks.
> 
> Peter Xu (6):
>   KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
>   KVM: X86: Move irrelevant declarations out of ioapic.h
>   KVM: X86: Use APIC_DEST_* macros properly in kvm_lapic_irq.dest_mode
>   KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
>   KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
>   KVM: X86: Conert the last users of "shorthand = 0" to use macros
> 
>  arch/x86/include/asm/kvm_host.h |  5 +++++
>  arch/x86/kvm/hyperv.c           |  1 +
>  arch/x86/kvm/ioapic.c           | 24 +++++++++++++++---------
>  arch/x86/kvm/ioapic.h           |  6 ------
>  arch/x86/kvm/irq.h              |  3 +++
>  arch/x86/kvm/irq_comm.c         | 12 +++++++-----
>  arch/x86/kvm/lapic.c            |  9 +++------
>  arch/x86/kvm/lapic.h            |  9 +++++----
>  arch/x86/kvm/svm.c              |  4 ++--
>  arch/x86/kvm/x86.c              |  4 ++--
>  10 files changed, 43 insertions(+), 34 deletions(-)
> 

