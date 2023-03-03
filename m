Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AF6A8E3B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 01:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCCAns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 19:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCAnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 19:43:46 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC6912BE6;
        Thu,  2 Mar 2023 16:43:45 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y11so1115198plg.1;
        Thu, 02 Mar 2023 16:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677804225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3tN2TJD6h5Tdg/xMggzqyAbykrMyjvz4T9+nHOb9PzY=;
        b=IhKNMoT2evP1Z83EI+3N0wlMMT8Y4oWNBiqIo3CdVAlSbx1F0Tmta/tZDph2CJVDlM
         I2RFlYJ3Z1x7P7efqfzgWMRFctg44Vw5FR2MPrIlHpMG2rNeZkXOOB3STTazzxBRbE/k
         aC6vUF0YR+ubItS3K0ovNeeU66O/clT8eAjBpjeeqCQuAFS7NWc1c3Eugv9Aq0N5rMDd
         AC+iW2yPunVOr70K8BFFQ3flh9kiWu6ItsJgIEFPuFV84A7k1KeFoyP8zHg4KFzO10/C
         Qn4ASALrmXNGW71XEAS3dN1a/m8lr6tOMd2IVx+2LFmk2qW1Eg/5BZ+kPUeZkGAWt2h0
         rn0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677804225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3tN2TJD6h5Tdg/xMggzqyAbykrMyjvz4T9+nHOb9PzY=;
        b=vw4rzYpH88g+xnoxnHHc1MKqg28JrUPdqMscXUTI2i6fLMSwCCfDlUFR9KJ5Q9TF04
         NcXzqyCvuonYhAYetjix1eHFUg084VgfniPham8u4TmYHRZkzdg6w1Gbn+4lZfyYQt3w
         ntDEW/UFvKmiLmx8a6QLVC6qmdUkvbOcWZpEBOuhK0kpNfogKGptYhQOhEHOzjm1pKEf
         XwAoMiZgsy7m4AD4aQ/5nyjNulbAEQlIUSwFGHaSSQ6qJtJvMVjHeCecC3cVEKiUM2yw
         7YwDYZgA5DyDtBys4wWdHn+IJQ50lJBfYuMWyrbMauKJDknGkbuOLVtHVyHHyb1VPXua
         kw5w==
X-Gm-Message-State: AO0yUKVuH6Zwf30RwZELgdToaOtWgTTBznGKs/jATU6IOWC7E8tz2xZ3
        gxfT9kdmvufTBEo3zq3mZdZ6W+gZ01I=
X-Google-Smtp-Source: AK7set8Y33AwWEq1Mye/AsYcC4+xRBNsnMCr2mw4GlaGQhfZ8xn1rJs7SKabiw+qbNkIVHUCdN4K4A==
X-Received: by 2002:a17:90b:314d:b0:237:6178:33b1 with SMTP id ip13-20020a17090b314d00b00237617833b1mr13738245pjb.19.1677804224519;
        Thu, 02 Mar 2023 16:43:44 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id lx3-20020a17090b4b0300b00233bc4edb77sm2201582pjb.25.2023.03.02.16.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 16:43:43 -0800 (PST)
Date:   Thu, 2 Mar 2023 16:43:41 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230303004341.GC2069594@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
 <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
 <20230228110632.GV4175971@ls.amr.corp.intel.com>
 <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
 <20230228201858.GY4175971@ls.amr.corp.intel.com>
 <a455c53dc1cdf81790f2996056cdd13cff482d9b.camel@intel.com>
 <20230301003512.GA3852341@ls.amr.corp.intel.com>
 <033e4e9c870046027e51f5811aa6c2ac64389987.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <033e4e9c870046027e51f5811aa6c2ac64389987.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 12:49:06AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2023-02-28 at 16:35 -0800, Isaku Yamahata wrote:
> > On Tue, Feb 28, 2023 at 09:49:10PM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On Tue, 2023-02-28 at 12:18 -0800, Isaku Yamahata wrote:
> > > > On Tue, Feb 28, 2023 at 11:52:59AM +0000,
> > > > "Huang, Kai" <kai.huang@intel.com> wrote:
> > > > 
> > > > > On Tue, 2023-02-28 at 03:06 -0800, Isaku Yamahata wrote:
> > > > > > > > +	if (!e)
> > > > > > > > +		return -ENOMEM;
> > > > > > > > +	*e  = (struct kvm_cpuid_entry2) {
> > > > > > > > +		.function = 1,	/* Features for X2APIC */
> > > > > > > > +		.index = 0,
> > > > > > > > +		.eax = 0,
> > > > > > > > +		.ebx = 0,
> > > > > > > > +		.ecx = 1ULL << 21,	/* X2APIC */
> > > > > > > > +		.edx = 0,
> > > > > > > > +	};
> > > > > > > > +	vcpu->arch.cpuid_entries = e;
> > > > > > > > +	vcpu->arch.cpuid_nent = 1;
> > > > > > > 
> > > > > > > As mentioned above, why doing it here? Won't be this be overwritten later in
> > > > > > > KVM_SET_CPUID2?
> > > > > > 
> > > > > > Yes, user space VMM can overwrite cpuid[0x1] and APIC base MSR.  But it
> > > > > > doesn't
> > > > > > matter because it's a bug of user space VMM. user space VMM has to keep the
> > > > > > consistency of cpuid and MSRs.
> > > > > > Because TDX module virtualizes cpuid[0x1].x2apic to fixed 1, KVM value doesn't
> > > > > > matter after vcpu creation.
> > > > > > Because KVM virtualizes APIC base as read only to guest, cpuid[0x1].x2apic
> > > > > > doesn't matter after vcpu creation as long as user space VMM keeps KVM APIC
> > > > > > BASE
> > > > > > value.
> > > > > > 
> > > > > 
> > > > > Contrary, can we depend on userspace VMM to set x2APIC in CPUID, but not do this
> > > > > in KVM?  If userspace doesn't do it, we treat it as userspace's bug.
> > > > > 
> > > > > Plus, userspace anyway needs to set x2APIC in CPUID regardless whether you have
> > > > > done above here, correct?
> > > > > 
> > > > > I don't see the point of doing above in KVM because you are neither enforcing
> > > > > anything in KVM, nor you are reducing effort of userspace.
> > > > 
> > > > Good idea. I can drop cpuid part from tdx_vcpu_create() and apic base part from
> > > > tdx_vcpu_reset(). It needs to modify tdx_has_emulated_msr() to allow user space
> > > > VMM to update APIC BASE MSR.
> > > 
> > > My personal preference would be:
> > > 
> > > 1) In KVM_SET_CPUID2, we do sanity check of CPUIDs provided by userspace, and
> > > return error if not met (i.e X2APIC isn't advertised).  We already have cases
> > > that KVM_SET_CPUID2 can fail, so extending to do TDX-specific check seems
> > > reasonable to me too.
> > 
> > This is moot. The current check does only check maxphys address bit size and
> > specified xfeatures are supported by host.  It's bare minimum for kvm to work.
> > It doesn't try to check consistency.
> > 
> > 
> > > 2) For APIC_BASE, you can just initialize the MSR in tdx_vcpu_reset() and ignore
> > > any update (+pr_warn()?) to MSR_IA32_APIC_BASE.
> > 
> > The x86 common code for KVM_CREATE_VCPU, kvm_arch_vcpu_create(), calls vcpu_create,
> > creates lapic, and calls vcpu_reset(). 
> > 
> > Setting ACPI BASE MSR with X2APIC enabled, checks if cpuid x2apic bit is set.
> > Please notice guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) in kvm_set_apic_base().
> > To work around it, one way is set cpuid artificially in create method as this
> > patch does.  Other way would be to introduce another version of
> > kvm_set_apic_base() that doesn't check cpuid dedicated for this purpose.
> > The third option is to make it user space responsibility to set initial reset
> > value of APIC BASE MSR.
> > 
> > Which option do you prefer?
> > 
> 
> I just recall you have already set all CPUIDs via tdx_td_init().  I would do
> below:
> 
> 1) keep all CPUIDs in tdx_td_init(), and make vcpu->cpuid point to that.
> 2) Ignore KVM_SET_CPUID2 for TDX guest (+ pr_warn(), etc).
> 3) Set TDX-fixed CPU registers/msrs, etc in reset_vcpu().

Finally I come up with the following flow.

- KVM_CREATE_VCPU
  - tdx_vcpu_create()
    no cpuid, no msr operation
- KVM_SET_CPUID2
  user space has to set cpuid...x2apic=1
- KVM_TDX_INIT_VCPU
  tdx_vcpu_ioctl() sets APIC_BASE MSR to x2apic enabled.
  Here if user space VMM doesn't set cpuid properly, it results in error.

ACPI_BASE MSR is read only for both user space VMM and guest TD.
cpuid:
After KVM_TDX_INIT_VCPU, user space VMM can update it by KVM_SET_CPUID2.
KVM doesn't care.  Guest TD see cpuid.x2apic value virtualized by TDX module
while KVM internally doesn't use the value because APIC_BASE won't change.


Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
