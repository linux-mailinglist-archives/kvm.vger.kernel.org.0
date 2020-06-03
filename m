Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654BA1ECE14
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgFCLOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:14:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgFCLOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 07:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591182859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=66+2fJmyMEeOm+RfdaX0dEV8FbowH6WPfR+JgsoWFaY=;
        b=TBNU0htzL4T+BmdndP5/nCKIe0+PWjr97ZMgRxt6V1D21MbVrRcG1l7LiCKVhX0O0WOJrv
        GyzU8OU5n6V4BeFbiY9sEpirA3Bkk3UjCNwwnQE2rbBaaIWBoBpXpxga7KLUH8ILOWULWz
        Ywtqn8vjmig3ub0t9obE2ml3aKTG0IY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-4zQUcTa-MeuG61Pk6SjOyQ-1; Wed, 03 Jun 2020 07:14:17 -0400
X-MC-Unique: 4zQUcTa-MeuG61Pk6SjOyQ-1
Received: by mail-ej1-f70.google.com with SMTP id pw1so631009ejb.8
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 04:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=66+2fJmyMEeOm+RfdaX0dEV8FbowH6WPfR+JgsoWFaY=;
        b=EQXdLP4gfCbsDiv4Cpx9mzDNFhemU2aEAT0cJg0uGHnrHIrpSbwvsnVRNMYeJM98m4
         tkDjeWIuWf/fOWXUAzZJQBSNF8peWOQK/08xGwo8kxQRkLeofzrO5Y3FYeHM0nYsAnRW
         BNegQ5pkgIY3dbIs6anKp6qbIuyaMWcNv1nDVsCoMAJXo3XzsJYtAhgYSsaWj0qbHjrP
         2GoXv1YRjIzEkzti9uqcx3rPZuhVqmgeTSIT9hHC6Kc2Wh9/OoJ+YLpi5jRh+0eoiA7S
         EVs76ckz3VDZP77ZjMT4fW8+Tn2PSsWLNVTEuDLt4qcaf7yfbz3tD6mU7BCypn1PFXhe
         cobg==
X-Gm-Message-State: AOAM530MbWRu1Ee/BH51mvRlGIgTj8M2aJrmHBnQNKWdhEn/RtNrLfCH
        x0lGUUxJ0C/eX2JpkXzxntYFym8dnCsPBfgJIS5wdE10rthVQIfZkk30CxlpFQ7j8mx5Eil4ose
        VvA1uh09NIPcS
X-Received: by 2002:a17:906:560b:: with SMTP id f11mr12470089ejq.11.1591182856237;
        Wed, 03 Jun 2020 04:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmmkDjbCjAIUFgF6xHVnWC41NZMGs2xGfwkhaV1dIKlp/faLOhnX0X4W/6u4Q/Xq0ZFu5mvQ==
X-Received: by 2002:a17:906:560b:: with SMTP id f11mr12470075ejq.11.1591182856011;
        Wed, 03 Jun 2020 04:14:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id us3sm962679ejb.31.2020.06.03.04.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 04:14:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Huang\, Kai" <kai.huang@intel.com>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "wad\@chromium.org" <wad@chromium.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        "luto\@kernel.org" <luto@kernel.org>,
        "aarcange\@redhat.com" <aarcange@redhat.com>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "dave.hansen\@linux.intel.com" <dave.hansen@linux.intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "kirill.shutemov\@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "jmattson\@google.com" <jmattson@google.com>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "rientjes\@google.com" <rientjes@google.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kirill\@shutemov.name" <kirill@shutemov.name>,
        "Christopherson\, Sean J" <sean.j.christopherson@intel.com>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
In-Reply-To: <0cd53be8abede7e82a68c32b1d8b0e4ca6f24a05.camel@intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-3-kirill.shutemov@linux.intel.com> <87d06s83is.fsf@vitty.brq.redhat.com> <20200525151525.qmfvzxbl7sq46cdq@box> <20200527050350.GK31696@linux.intel.com> <87eer56abe.fsf@vitty.brq.redhat.com> <0cd53be8abede7e82a68c32b1d8b0e4ca6f24a05.camel@intel.com>
Date:   Wed, 03 Jun 2020 13:14:13 +0200
Message-ID: <87r1uwflkq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Huang, Kai" <kai.huang@intel.com> writes:

> On Wed, 2020-05-27 at 10:39 +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > On Mon, May 25, 2020 at 06:15:25PM +0300, Kirill A. Shutemov wrote:
>> > > On Mon, May 25, 2020 at 04:58:51PM +0200, Vitaly Kuznetsov wrote:
>> > > > > @@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
>> > > > >  {
>> > > > >  	kvmclock_init();
>> > > > >  	x86_platform.apic_post_init = kvm_apic_init;
>> > > > > +
>> > > > > +	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
>> > > > > +		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
>> > > > > +			pr_err("Failed to enable KVM memory
>> > > > > protection\n");
>> > > > > +			return;
>> > > > > +		}
>> > > > > +
>> > > > > +		mem_protected = true;
>> > > > > +	}
>> > > > >  }
>> > > > 
>> > > > Personally, I'd prefer to do this via setting a bit in a KVM-specific
>> > > > MSR instead. The benefit is that the guest doesn't need to remember if
>> > > > it enabled the feature or not, it can always read the config msr. May
>> > > > come handy for e.g. kexec/kdump.
>> > > 
>> > > I think we would need to remember it anyway. Accessing MSR is somewhat
>> > > expensive. But, okay, I can rework it MSR if needed.
>> > 
>> > I think Vitaly is talking about the case where the kernel can't easily get
>> > at its cached state, e.g. after booting into a new kernel.  The kernel would
>> > still have an X86_FEATURE bit or whatever, providing a virtual MSR would be
>> > purely for rare slow paths.
>> > 
>> > That being said, a hypercall plus CPUID bit might be better, e.g. that'd
>> > allow the guest to query the state without risking a #GP.
>> 
>> We have rdmsr_safe() for that! :-) MSR (and hypercall to that matter)
>> should have an associated CPUID feature bit of course.
>> 
>> Yes, hypercall + CPUID would do but normally we treat CPUID data as
>> static and in this case we'll make it a dynamically flipping
>> bit. Especially if we introduce 'KVM_HC_DISABLE_MEM_PROTECTED' later.
>
> Not sure why is KVM_HC_DISABLE_MEM_PROTECTED needed?
>

I didn't put much thought in it but we may need it to support 'kexec'
case when no reboot is performed but we either need to pass  the data
about which regions are protected from old kernel to the new one or
'unprotect exerything'.

-- 
Vitaly

