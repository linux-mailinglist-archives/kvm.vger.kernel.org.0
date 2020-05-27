Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7931E471E
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389568AbgE0PRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 11:17:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389447AbgE0PRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 11:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590592630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jxeEDhzgrLh/X883Y6dHJor3hgYqo4NWCe2gqfOAWXs=;
        b=GSbA3bj3ud4HVU0ry0IYyBcjst9+CIRpyY5t4iTcJgp8e5l2u/6xmOUjeQ6zqj84WEx1s9
        0mwiTWz0bvmnKaoYZP1v6M8UFWQOfhFAHbAh7/W5ERnD5BJM4bIwg+vrzZiSiqFIp39ohC
        pX2T9Hb1wDt+i7WO62gseDnpS+AE+Vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77--3CiTK6XMtSG5BRCYO9Ubw-1; Wed, 27 May 2020 11:17:08 -0400
X-MC-Unique: -3CiTK6XMtSG5BRCYO9Ubw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A137107ACF6;
        Wed, 27 May 2020 15:17:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C0805D9E5;
        Wed, 27 May 2020 15:17:01 +0000 (UTC)
Message-ID: <69386188ba90a8852525f1c984d5df57c21ee2e7.camel@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
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
Date:   Wed, 27 May 2020 18:17:00 +0300
In-Reply-To: <20200527012140.GD31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
         <20200523161455.3940-3-mlevitsk@redhat.com>
         <20200527012140.GD31696@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 18:21 -0700, Sean Christopherson wrote:
> On Sat, May 23, 2020 at 07:14:55PM +0300, Maxim Levitsky wrote:
> > This msr is only available when the host supports WAITPKG feature.
> > 
> > This breaks a nested guest, if the L1 hypervisor is set to ignore
> > unknown msrs, because the only other safety check that the
> > kernel does is that it attempts to read the msr and
> > rejects it if it gets an exception.
> > 
> > Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
> 
> Same comments on the line wraps and Fixes tag.
I rewrote the commit message and I hope that the new version
is better. I fixed the 'fixes' message as well.

> 
> For the code:
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Thank you!

Best regards,
	Maxim Levitsky


> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b226fb8abe41b..4752293312947 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5316,6 +5316,10 @@ static void kvm_init_msr_list(void)
> >  			    min(INTEL_PMC_MAX_GENERIC,
> > x86_pmu.num_counters_gp))
> >  				continue;
> >  			break;
> > +		case MSR_IA32_UMWAIT_CONTROL:
> > +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> > +				continue;
> > +			break;
> >  		default:
> >  			break;
> >  		}
> > -- 
> > 2.26.2
> > 

