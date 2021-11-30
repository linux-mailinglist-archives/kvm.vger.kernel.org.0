Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8D463A7E
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 16:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhK3Psa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 10:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhK3PsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 10:48:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5301C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 07:45:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so17594574pjb.4
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 07:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dwL/N/0r33z1J+yxcqYeak1UGCvqy061/ybnlClImC4=;
        b=DzHYJSEDFeQhlh2V1wl/Olwddpz1XECXeRCQscX33t7syLnYQJHPGUp/iAx7ycqIm6
         sIrqsYTpuINIArwuiRlVbw3OZN8LCWAjG0GtZ7P/qRSQWn/WRlaL/4fvTIhYDOjcV9vl
         ZdL25iOeSmi33Q0PcusvosQm5dwlvBf5oLwdiuHDleuNu9YCfdMZfMSORd0ATQhoAZi7
         rT70s5XsP8R7Fgi99iVJRZi9Or7Gt5+Ev5VA1FkD4ITYPZ1j8y0V7ERtQGNp1tbu3M5F
         lXFmzgGHlYI0hnrCrAkqsMKnZPn+jp+cfR6UKsU5z3nHoa9UjOvQyYObsgZ1ZOIpgWSF
         JjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dwL/N/0r33z1J+yxcqYeak1UGCvqy061/ybnlClImC4=;
        b=wQ1we6xxmfkmAX2AlRkfPVn3WGdSCYZLrIenvPeakrvLg3eMCluTyTenn+ERGLZhg2
         gfwumyYtoCgZHd96/mDfU+7XakvG+POPloQCJ8snlpZagb/tm951Czfo9qR5RbNw1w/T
         Gqo83QxaZqAZkmSeja+BVnAGFrMPPDvaubyNTgOSCSSklLJPz267aeaWZ8G0g9X4tBYz
         miKUHYnRB0bT19+6UKL1HYVPKx1sod7WyPm6D96HYka7+68Mx6Ck2yPGAv5ks7bXSyuc
         d3bMIpyOF9EhOU+8988uBKqdxRbIvCaqa1crIzQStZMPLCdGVdHLsU5nhcU459VV/VIX
         MrvA==
X-Gm-Message-State: AOAM531BSY47RiDiLG2oxaGWylwsFDSlQX+GcgkbZZLYNAPhjFZeNAX8
        uETCZ7TCJjsN1tN1uVJAGzEAZQ==
X-Google-Smtp-Source: ABdhPJylVbFuOqgAdsqa3Cmb2dwe8PNZRVgirN7DPSZqHTeweb0oWnD/Zt7w1UPJ7BtiBbIxh/3btA==
X-Received: by 2002:a17:902:c78a:b0:142:1b7a:930 with SMTP id w10-20020a170902c78a00b001421b7a0930mr213746pla.8.1638287104019;
        Tue, 30 Nov 2021 07:45:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q9sm14364894pfj.9.2021.11.30.07.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:45:03 -0800 (PST)
Date:   Tue, 30 Nov 2021 15:45:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
Message-ID: <YaZG/NopJ7YaVUjD@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-28-seanjc@google.com>
 <df9d430c-2065-804b-2343-d4bcdb7b2464@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9d430c-2065-804b-2343-d4bcdb7b2464@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Paolo Bonzini wrote:
> On 11/20/21 05:50, Sean Christopherson wrote:
> >   	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> > -		rcu_read_unlock();
> > -
> >   		if (flush)
> >   			kvm_flush_remote_tlbs(kvm);
> > +		rcu_read_unlock();
> > +
> 
> Couldn't this sleep in kvm_make_all_cpus_request, whilst in an RCU read-side
> critical section?

No.  And if kvm_make_all_cpus_request() can sleep, the TDP MMU is completely hosed
as tdp_mmu_zap_spte_atomic() and handle_removed_tdp_mmu_page() currently call
kvm_flush_remote_tlbs_with_range() while under RCU protection.

kvm_make_all_cpus_request_except() disables preemption via get_cpu(), and
smp_call_function() doubles down on disabling preemption as the inner helpers
require preemption to be disabled, so anything below them should complain if
there's a might_sleep().  hv_remote_flush_tlb_with_range() takes a spinlock, so
nothing in there should be sleeping either.
