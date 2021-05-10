Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BDC379544
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhEJRVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEJRVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:21:46 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773DCC061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:20:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h127so14068025pfe.9
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZzL3ZHXZ7m2ggKi2Qah/SWBr76vIJ2DZqHjIyxevM6E=;
        b=ptbHWGVWYMYw+vOAxw2ekEbD2cWZiy6v31kAz1QWZl5MThlB4lsqtxV38hZtgU5qy9
         faLHaZleak+CwZZAaxmUc3qpIGwjXET4FeGaZPcqL/xc1cURsiHhExsWYZFGlyJRNyMy
         yLb9AmvznDnJC4A4qXrYlft5h5R4iiSC9GF2DOjpzmqjhTs9tSfbjJVZXrO0khFpkpkC
         MJnT6J9tjrsgxHEZWHdqmSFPzjITicCQdCPxcU3YrkTL4d40yNBnetD0vvnGaX6zCs1Z
         /d/CVYRwGtEFTnwyy3F8iMTnCxB2dmo8N8r/wuVz9/aiS4hUTke7fUwme+o1n+OYLgm4
         xGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZzL3ZHXZ7m2ggKi2Qah/SWBr76vIJ2DZqHjIyxevM6E=;
        b=HfX+slLJYatJvWcQJrIpqUNqQaGcJp6ihAmlrtcb0bSXV0JPo/p1JBepvAY8yGQ684
         mY0yD3fhZbaAyk51YW24xB3J8jrOtttvbOOBdjJAUNhGWsyuIN1M86EoMcma+dyB59Ur
         a2Cw43RDjRib93N++cp+VQHhr84jv9+BlWfZ3gZTY/YKhjjj7MgGelfTKHI36bEqK7C/
         XtpyUPlJOJDveHtttK1Ge3Nloytxmt0drKX0kyz3L9JrsC7CJifVDkMwY4k+WxdK2ybO
         17KJtdOd8HYF2EPGZBtud7qPyB07wof4iYiZYrCcPSHnHWFQ0aCchE8lrYDCwerYZvKA
         zBcA==
X-Gm-Message-State: AOAM530YTy2UYk8SAAOBw7QT2mEkJJtdigM1VJRHMlcNCKCkNSXF5h+3
        2tRjdGy9Bnw+TFtnU0KTQ7y19w==
X-Google-Smtp-Source: ABdhPJy1oLZCmLFbyCJlujed6wf2ASI6OmQRBCGkLiXEVmlurrplL4vagdlhloy77Y0efCZI9InDag==
X-Received: by 2002:a62:8895:0:b029:283:f725:6a7 with SMTP id l143-20020a6288950000b0290283f72506a7mr26093548pfd.79.1620667240813;
        Mon, 10 May 2021 10:20:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r16sm8840371pgk.16.2021.05.10.10.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 10:20:40 -0700 (PDT)
Date:   Mon, 10 May 2021 17:20:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is supported
Message-ID: <YJlrZJrVhUKCbnba@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-3-seanjc@google.com>
 <bc90b793ac351f9426710d354bf0c3621f36e763.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc90b793ac351f9426710d354bf0c3621f36e763.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Maxim Levitsky wrote:
> On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > Do not advertise emulation support for RDPID if RDTSCP is unsupported.
> > RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
> > both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
> > unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
> > inject a #UD.
> > 
> > Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
> > but this is a KVM bug and will eventually be fixed.
> > 
> > Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index f765bf7a529c..c96f79c9fff2 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> >  	case 7:
> >  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> >  		entry->eax = 0;
> > -		entry->ecx = F(RDPID);
> > +		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> > +			entry->ecx = F(RDPID);
> >  		++array->nent;
> >  	default:
> >  		break;
> 
> Just to make sure that I understand this correctly:
> 
> This is what I know:
> 
> Both RDTSCP and RDPID are instructions that read IA32_TSC_AUX
> (and RDTSCP also reads the TSC).
> 
> Both instructions have their own CPUID bits (X86_FEATURE_RDPID, X86_FEATURE_RDTSCP)
> If either of these CPUID bits are present, IA32_TSC_AUX should be supported.

Yep.

> RDPID is a newer feature, thus I can at least for the sanity sake assume that
> usually a CPU will either have neither of the features, have only RDTSCP,
> and IA32_AUX, or have both RDSCP and RDPID.

Yep.

> If not supported in hardware KVM only emulates RDPID as I see.

Yep.

> Why btw? Performance wise guest that only wants the IA32_AUX in userspace,
> is better to use RDTSCP and pay the penalty of saving/restoring of the
> unwanted registers, than use RDPID with a vmexit.

FWIW, Linux doesn't even fall back to RDTSCP.  If RDPID isn't supported, Linux
throws the info into the limit of a dummy segment in the GDT and uses LSL to get
at the data.  Turns out that RDTSCP is too slow for its intended use case :-)

> My own guess for an answer to this question is that RDPID emulation is there
> to aid migration from a host that does support RDPID to a host that doesn't.

That's my assumption as well.  Paolo's commit is a bit light on why emulation
was added in the first place, but emulating to allow migrating to old hardware
is the only motivation I can come up with.

commit fb6d4d340e0532032c808a9933eaaa7b8de435ab
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Jul 12 11:04:26 2016 +0200

    KVM: x86: emulate RDPID

    This is encoded as F3 0F C7 /7 with a register argument.  The register
    argument is the second array in the group9 GroupDual, while F3 is the
    fourth element of a Prefix.

> Having said all that, assuming that we don't want to emulate the RDTSCP too,
> when it is not supported, then this patch does make sense.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
