Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA54291DE
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhJKOeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242322AbhJKOdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 10:33:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA28C0613DF
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 07:27:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s11so10964066pgr.11
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tbf5GCA+ODjS2j5L/SUM7NgsKD1MXeVm9DtdN1uNmRY=;
        b=ABPfom5jLrBcTPsIgrbeLq6+c13HG0lLLusqKXB3RBQOIRKYfQKPCzP25DiqiI/xpP
         xUPc3kK9u4aXk6OhdLaunZgyUVpcPzMvKVjy4MKZtOxY+g3odGWYAT6EesqQWzmmg+ri
         u0DLvrwoPYazyoN7e7o9ADhge0gL3RyAdvtW94MfBvE8XZxD1sC3ucvXH3tW3/Bu+I+B
         Z4Wxi2SZZSSdaPhCxIPaEOk/2JROOjDizzjjUMRM+20tZ8iT08I5xq9+R8Wa0UudIvye
         YEXbe+t2ff1NZnbhvtz5o1RM+2kg7G/1/rhUcK7fD2tnnH61OHTVzBgM06aJtrHapzbG
         XrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tbf5GCA+ODjS2j5L/SUM7NgsKD1MXeVm9DtdN1uNmRY=;
        b=FSIpT6XMhrDwP/uN4agjSty6JcV8IqDXjDRJ88OCabLlxLWstwN2SOCklnTXMokWKI
         h6acT06mvwcjLw/vqAda0yxq1Eje2kZYjmzXcB8i2LawiLjd8KVt7lq7FrXX2EPLwGEJ
         KtwuWQQBZjevIxdWYNIjo/idetHHRMmLU9q28fO9aWvxhEt1GQvHfetJV6jaHG9Ni+0t
         Cty3TESsi0Br+IHRpvuPb+ikw6cBMxSKVgoq8DLUp2yYTylx/IrZ8oMJtmVUCn6rLP/f
         SRIzRor7jqg0Z5k0HHfqF2FbM+SGikDYxa6GlA9zLGpznwsP/3E+42Jpwgm5Fiwtr5H0
         Y+Mw==
X-Gm-Message-State: AOAM5330e+IM1tDSBdy5FjYkmASWsQ1JK8dGQRjsh3p9tKmzyqBH/QoI
        QgRnevcOw0yCkYqM7JVIdVzGUg==
X-Google-Smtp-Source: ABdhPJyRKhv3Thu3gd3ZdCh6lmbkSOvEdSSuG9PXLL3cEdrNtkoUgEQeUXODrrBqlEV9ULdqDGBTmw==
X-Received: by 2002:a63:c:: with SMTP id 12mr18621798pga.477.1633962437528;
        Mon, 11 Oct 2021 07:27:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18sm9055024pfj.46.2021.10.11.07.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 07:27:16 -0700 (PDT)
Date:   Mon, 11 Oct 2021 14:27:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
Message-ID: <YWRJwZF1toUuyBdC@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
 <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 10, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> > Belated "code review" for Maxim's recent series to rework the AVIC inhibit
> > code.  Using the global APICv status in the page fault path is wrong as
> > the correct status is always the vCPU's, since that status is accurate
> > with respect to the time of the page fault.  In a similar vein, the code
> > to change the inhibit can be cleaned up since KVM can't rely on ordering
> > between the update and the request for anything except consumers of the
> > request.
> > 
> > Sean Christopherson (2):
> >   KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
> >     memslot
> >   KVM: x86: Simplify APICv update request logic
> > 
> >  arch/x86/kvm/mmu/mmu.c |  2 +-
> >  arch/x86/kvm/x86.c     | 16 +++++++---------
> >  2 files changed, 8 insertions(+), 10 deletions(-)
> > 
> 
> Are you sure about it? Let me explain how the algorithm works:
> 
> - kvm_request_apicv_update:
> 
> 	- take kvm->arch.apicv_update_lock
> 
> 	- if inhibition state doesn't really change (kvm->arch.apicv_inhibit_reasons still zero or non zero)
> 		- update kvm->arch.apicv_inhibit_reasons
> 		- release the lock
> 
> 	- raise KVM_REQ_APICV_UPDATE
> 		* since kvm->arch.apicv_update_lock is taken, all vCPUs will be
> 		kicked out of guest mode and will be either doing someing in
> 		the KVM (like page fault) or stuck on trying to process that
> 		request the important thing is that no vCPU will be able to get
> 		back to the guest mode.
> 
> 	- update the kvm->arch.apicv_inhibit_reasons
> 		* since we hold vm->arch.apicv_update_lock vcpus can't see the new value

This assertion is incorrect, kvm_apicv_activated() is not guarded by the lock.

> 	- update the SPTE that covers the APIC's mmio window:

This won't affect in-flight page faults.


   vCPU0                               vCPU1
   =====                               =====
   Disabled APICv
   #NPT                                Acquire apicv_update_lock
                                       Re-enable APICv
   kvm_apicv_activated() == false
   incorrectly handle as regular MMIO
                                       zap APIC pages
   MMIO cache has bad entry
