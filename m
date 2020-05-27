Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049271E471D
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389544AbgE0PRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 11:17:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389501AbgE0PQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 11:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590592618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VVDQvFJrgkWSz8/ikl8zaz7psPPU6nwXpgVWbhjxY/A=;
        b=QW+CYypiY6rpNEISyGoTqYN8+viS3sVz1WUgt5ED5jO3sDQgnpQWuysOG66T1rfgAeMGxY
        7h2/+er8SSmGGOAKG5PxPXnynmHj6sNyntD8cknsVhtbYQgligtM+r3rspV8PqVq8pm1pn
        k1bKJ7bxqgXWXKMKFgh10bc2zYRD0MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-R7kKTjP5PX6oBfqiP1ZHrQ-1; Wed, 27 May 2020 11:16:54 -0400
X-MC-Unique: R7kKTjP5PX6oBfqiP1ZHrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1F6D107ACCD;
        Wed, 27 May 2020 15:16:52 +0000 (UTC)
Received: from starship (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F26519D82;
        Wed, 27 May 2020 15:16:48 +0000 (UTC)
Message-ID: <6d6d38a6f62e0d6d093713703e9f0e183c7eda13.camel@redhat.com>
Subject: Re: [PATCH 1/2] kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM
 capabilities
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Wed, 27 May 2020 18:16:47 +0300
In-Reply-To: <20200527012039.GC31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
         <20200523161455.3940-2-mlevitsk@redhat.com>
         <20200527012039.GC31696@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 18:20 -0700, Sean Christopherson wrote:
> On Sat, May 23, 2020 at 07:14:54PM +0300, Maxim Levitsky wrote:
> > Even though we might not allow the guest to use
> > WAITPKG's new instructions, we should tell KVM
> > that the feature is supported by the host CPU.
> > 
> > Note that vmx_waitpkg_supported checks that WAITPKG
> > _can_ be set in secondary execution controls as specified
> > by VMX capability MSR, rather that we actually enable it for a
> > guest.
> 
> These line wraps are quite weird and inconsistent.
Known issue for me, I usually don't have line wrapping enabled,
and I wrap the lines a bit earlier that 72 character limit. 
I'll re-formatted the commit message to be on 72 line format and I will
try now to pay much more attention to that.

> 
> > Fixes: e69e72faa3a0 KVM: x86: Add support for user wait
> > instructions
> 
> Checkpatch doesn't complain,  but the preferred Fixes format is
> 
>   Fixes: e69e72faa3a07 ("KVM: x86: Add support for user wait
> instructions")


> 
> e.g.
> 
>   git show -s --pretty='tformat:%h ("%s")'

Got it, and added to git aliases :-)

> 
> For the code itself:
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Thank you!

> 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 55712dd86bafa..fca493d4517c5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7298,6 +7298,9 @@ static __init void vmx_set_cpu_caps(void)
> >  	/* CPUID 0x80000001 */
> >  	if (!cpu_has_vmx_rdtscp())
> >  		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
> > +
> > +	if (vmx_waitpkg_supported())
> > +		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> >  }
> >  
> >  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> > -- 
> > 2.26.2
> > 

