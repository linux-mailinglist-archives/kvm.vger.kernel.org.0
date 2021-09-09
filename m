Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1B405D16
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhIITAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 15:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbhIITAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 15:00:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5391C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:59:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d18so1686021pll.11
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ivHQCNTMj8d081EaJs/OWp0rY18lxe7zmhcLzE6AV3M=;
        b=YnjGjn+AKEmZ920Dc2yEn3vadOv8hGcIrIfrx+Lo4uwM1Pk4c793DAW101NoeUSTn/
         bXl13y7V493cBm7h6LnfqQKWturRswUuWOmhxkK55I7p1EPKL33/ZvKQAQFueqCUqPHA
         /6BoyCl++OiJb3DXF+UgfzFU2RyYxyddNk+PQ2SdRqDCgwC0uFE8BxiSNevMselh/ml2
         +knI0+9D8zKLV5Hnq5izjaiHkCU5anlpAM35eEkW4QLHmDrlCznQ3wsm9eJbkXBudqKs
         8YoMSJ20ZMc+eosSj85XHm/D2OqyTyBKVQrloLYlXSc7ZjdthMi7wlGNFfXJDmvsC63N
         WFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ivHQCNTMj8d081EaJs/OWp0rY18lxe7zmhcLzE6AV3M=;
        b=HBIuzmgNxhdHrjdWecohEV/E+VVA+nR/JmOi4pbp3Ms2nEpGXJFVuAIapCz5WKg2Zy
         FSo2qQsT68NL3AtT7VPfBH5ncR/4SM+pPlH99XeSib7o+mR8a0Zq1CdVTxb3yTqhheM6
         LhagKI/JxIiufTivWODx0GqwunZ3BwWadsGsDIgNi28tIwm9l6oIm5GtjzkR/fLGrg3D
         W82pfm9h0BYgbSW+iDNTlrL7wdE/jGfgy+0ujGkWU/VJkr4NBiZsJS9x6KpmkwU0SJdy
         ZM9+8kePD9zRGEHWKpr6axjonUyOPPgGMe9mYNVRKNNVZIpNTXbRHIRvOtbSrCezYuu5
         CoGg==
X-Gm-Message-State: AOAM5335Umt5aQKy/meS1Qdi26eS7MqLLvQNUfkZ88rpmRUEO3rm1vvt
        Sc+F8p+RrgEPR1px4rlOkTqY+A==
X-Google-Smtp-Source: ABdhPJzbuG9m75RBkmn+9LvIUiv0Yxgry2fXtBpxvZf91/vhVbV1zXHbF1aZnXw49a+ez/Aw4NJQ2A==
X-Received: by 2002:a17:90a:f002:: with SMTP id bt2mr5227853pjb.207.1631213949990;
        Thu, 09 Sep 2021 11:59:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u7sm3063969pjn.45.2021.09.09.11.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 11:59:09 -0700 (PDT)
Date:   Thu, 9 Sep 2021 18:59:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YTpZeVZb5tsscAmv@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <YTD4l7L0CKMCQwd5@google.com>
 <YTD9kIIzAz34Ieeu@google.com>
 <118cd1b9-1b50-3173-05b8-4293412ca78c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118cd1b9-1b50-3173-05b8-4293412ca78c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021, Xiaoyao Li wrote:
> On 9/3/2021 12:36 AM, Sean Christopherson wrote:
> > On Thu, Sep 02, 2021, Sean Christopherson wrote:
> > > On Tue, Aug 03, 2021, Xiaoyao Li wrote:
> > > > On 8/2/2021 11:46 PM, Sean Christopherson wrote:
> > > > > > > > @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
> > > > > > > >     	return 0;
> > > > > > > >     }
> > > > > > > > +static int handle_notify(struct kvm_vcpu *vcpu)
> > > > > > > > +{
> > > > > > > > +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> > > > > > > > +
> > > > > > > > +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
> > > > > > > 
> > > > > > > What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.
> > > > > > 
> > > > > > It means whether the VM context is corrupted and not valid in the VMCS.
> > > > > 
> > > > > Well that's a bit terrifying.  Under what conditions can the VM context become
> > > > > corrupted?  E.g. if the context can be corrupted by an inopportune NOTIFY exit,
> > > > > then KVM needs to be ultra conservative as a false positive could be fatal to a
> > > > > guest.
> > > > > 
> > > > 
> > > > Short answer is no case will set the VM_CONTEXT_INVALID bit.
> > > 
> > > But something must set it, otherwise it wouldn't exist.
> 
> For existing Intel silicon, no case will set it. Maybe in the future new
> case will set it.
> 
> > The condition(s) under
> > > which it can be set matters because it affects how KVM should respond.  E.g. if
> > > the guest can trigger VM_CONTEXT_INVALID at will, then we should probably treat
> > > it as a shutdown and reset the VMCS.
> > 
> > Oh, and "shutdown" would be relative to the VMCS, i.e. if L2 triggers a NOTIFY
> > exit with VM_CONTEXT_INVALID then KVM shouldn't kill the entire VM.  The least
> > awful option would probably be to synthesize a shutdown VM-Exit to L1.  That
> > won't communicate to L1 that vmcs12 state is stale/bogus, but I don't see any way
> > to handle that via an existing VM-Exit reason :-/
> > 
> > > But if VM_CONTEXT_INVALID can occur if and only if there's a hardware/ucode
> > > issue, then we can do:
> > > 
> > > 	if (KVM_BUG_ON(exit_qual & NOTIFY_VM_CONTEXT_INVALID, vcpu->kvm))
> > > 		return -EIO;
> > > 
> > > Either way, to enable this by default we need some form of documentation that
> > > describes what conditions lead to VM_CONTEXT_INVALID.
> 
> I still don't know why the conditions lead to it matters. I think the
> consensus is that once VM_CONTEXT_INVALID happens, the vcpu can no longer
> run.

Yes, and no longer being able to run the vCPU is precisely the problem.  The
condition(s) matters because if there's a possibility, however small, that enabling
NOTIFY_WINDOW can kill a well-behaved guest then it absolutely cannot be enabled by
default.

> Either KVM_BUG_ON() or a specific EXIT to userspace should be OK?

Not if the VM_CONTEXT_INVALID happens while L2 is running.  If software can trigger
VM_CONTEXT_INVALID at will, then killing the VM would open up the door to a
malicious L2 killing L1 (which would be rather ironic since this is an anti-DoS
feature).  IIUC, VM_CONTEXT_INVALID only means the current VMCS is garbage, thus
an occurence while L2 is active means that vmcs02 is junk, but L1's state in vmcs01,
vmcs12, etc... is still valid.

