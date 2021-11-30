Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ADB462F9D
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 10:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbhK3JcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 04:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbhK3JcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 04:32:07 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DCEC061574;
        Tue, 30 Nov 2021 01:28:48 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so83599335eds.10;
        Tue, 30 Nov 2021 01:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AZ8mITnC21HfY1uu3H4ULc30qrtA5ZbGZsBh6LmlSAM=;
        b=bn76a7KAwfJq9ZpwE24VoRqoyidQ7M1s4KCZvqajwDcuakABMogt0Rqit/4oCOy9+i
         CPv/HVvtSVVfuMkv4OwEpJK6tczEWZ81FqndgNygQPrnP9YATIPEvtQkakWPRvEP9Prz
         MwOYHSnWdGOCchCt3VB30Tew5oTT1onVFYeEkmg2UseV0LX9CRnyZvtzAZdZbCpcIypl
         FEgf3IlYICCFmEkoPut4wb759djybRqEHLwNuQZDHfXkDjYrODWXLSXH7LsaIQpEH7of
         QbPPPSNBnFN1U1bAoc78IseT2/qp9GPo5txdSFOR8oaO76/NVQy25BSZBMACqvi3q8r5
         bTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AZ8mITnC21HfY1uu3H4ULc30qrtA5ZbGZsBh6LmlSAM=;
        b=YyTlJU+uogeGkrDnbLTyoNNqSILLcXS2X/I6x2UXi90609Pgg56Wcn+/u3r1vqP58a
         HmQgsnab5shdQ8XY62IUeM0FnXGZU2DRjQCOfv0/jwGNtT/yuMx8OfS0f1oPuLua3hj3
         06MZ2vyXbw5m6RhrIy8QP1TiybUCsi0vDW5hdnfiusNn92N7BrGww90cMgosN2Pa8bxw
         0pKBBpgVEChVfOguQsFCaDqL39wR6dbbvOEC6xLs1bjb8MwwCu0e0rzcOXECdT5q7BTh
         qbCVkbR9tShACv1y6XeqLwC022ZlQD8nD/7YFwYrgokPbuZhYBXUjYniGUcfEeQvh8Sv
         2BLg==
X-Gm-Message-State: AOAM530/UJR0Y6bWnmQW61pHv1IkiSKJEaNU+SfXSf6He/cj7UAtoex6
        UhFrYdzTDgFXBDxQabkYi68=
X-Google-Smtp-Source: ABdhPJw6IFqqtcn1aWf+yrqj/qtCTJ0crnrUikbTQUItsYszXJiP1QxYsXcZyO+9cDWIWEQ841DYuQ==
X-Received: by 2002:a17:907:60cf:: with SMTP id hv15mr20912631ejc.561.1638264525636;
        Tue, 30 Nov 2021 01:28:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id w22sm11891922edd.49.2021.11.30.01.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 01:28:45 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
Date:   Tue, 30 Nov 2021 10:28:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Q. about KVM and CPU hotplug
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 09:27, Tian, Kevin wrote:
> 		r = kvm_arch_hardware_enable();
> 
> 		if (r) {
> 			cpumask_clear_cpu(cpu, cpus_hardware_enabled);
> 			atomic_inc(&hardware_enable_failed);
> 			pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
> 		}
> 	}
> 
> Upon error hardware_enable_failed is incremented. However this variable
> is checked only in hardware_enable_all() called when the 1st VM is called.
> 
> This implies that KVM may be left in a state where it doesn't know a CPU
> not ready to host VMX operations.
> 
> Then I'm curious what will happen if a vCPU is scheduled to this CPU. Does
> KVM indirectly catch it (e.g. vmenter fail) and return a deterministic error
> to Qemu at some point or may it lead to undefined behavior? And is there
> any method to prevent vCPU thread from being scheduled to the CPU?

It should fail the first vmptrld instruction.  It will result in a few 
WARN_ONCE and pr_warn_ratelimited (see vmx_insn_failed).  For VMX this 
should be a pretty bad firmware bug, and it has never been reported. 
KVM did find some undocumented errata but not this one!

I don't think there's any fix other than pinning userspace.  The WARNs 
can be eliminated by calling KVM_BUG_ON in the sched_in notifier, plus 
checking if the VM is bugged before entering the guest or doing a 
VMREAD/VMWRITE (usually the check is done only in a ioctl).  But some 
refactoring is probably needed to make the code more robust in general.

Paolo

> By design the current generation of TDX doesn't support CPU hotplug. 
> Only boot-time CPUs can be initialized for TDX (and must be done en 
> masse in one breath). Attempting to do seamcalls on a hotplugged CPU
> simply fails, thus it potentially affects any trusted domain in case its
> vCPUs are scheduled to the plugged CPU. 
