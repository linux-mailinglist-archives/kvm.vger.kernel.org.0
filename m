Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216453646ED
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhDSPRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 11:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbhDSPRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 11:17:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14756C061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 08:16:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so20587519pjh.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 08:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vbmx1/41jC8YgU5iYwhJ4h7BEVgLwcoyeVabbKhD8m8=;
        b=pzGd/yTcYcZmnxk3pwk3iyingnb595aJwWCHkV4XhSfkNolZX+m+uJPMbfxiSuqCqM
         g/E1hFiTaLK8TLFW7av16sW6uSDxJrMRFgXFAoiq1QwkwHsBgDKrhZNaDg20dRo6uaG9
         Jg2nbNgeHl5mcmR2b/yEEddSRV9BLOGArtUSyrwiyq3GRuH8SiA1bGGMGNDbuzCz6QXn
         LGRa9OTtlPyA/ZeFBYTQ9veVEKGX0STl47b7FgtRo03jDWMihtlsjojCEB0fmUuFvyNI
         dqtOX2NI9aa5L0+OlRlnfCHeMu29qJaE2ErleHWFykzE10PAVUlJkBDAcV4meAHdvFLh
         gA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vbmx1/41jC8YgU5iYwhJ4h7BEVgLwcoyeVabbKhD8m8=;
        b=G/7YXHptuJcsitN8nYLUNDUX4f657LCSYslkg4TyKbHvghVD3Q2VmH9TA9//DKWsxV
         GmLYniYSDi8HFAsYyneqK3frUqK3YlAsI961yHRQPHk8Wnzs5PErVZTmE6zT4Ln7nME9
         7AweAymrZtD3seg2ffqsCTIxKwnheSzq/EB+bK/yOFH0pGXZKMmRxjaic35bl4v8859K
         /ZNdnIkF1fEXZdzsvLE2p+T4QsQTduqiIretlb39pUZ1GDnHyKwxIWj7K6+me+4DqUej
         eNkyYvzsrJNKAUbyt42TeVu9gFNOkqxCRr5TMqsdR1Hu2J6sVtKMcI2kdSGZZVLe1WIc
         Vyug==
X-Gm-Message-State: AOAM531cqCjwjdtgvQ2ntcjekHKgglrdYQIhcxirZj32kefbrA5J6Stc
        VcB0v2PqsK64juJqFXEJ8neXgQ==
X-Google-Smtp-Source: ABdhPJxdS1y+qwekLPWuRqliFP8PKQh8SUCaMcSUQkSfWWnas0M7+FlE/LbZ/zigohEi3ykTlwiMEg==
X-Received: by 2002:a17:902:b40e:b029:e6:837f:711 with SMTP id x14-20020a170902b40eb02900e6837f0711mr23648247plr.2.1618845403507;
        Mon, 19 Apr 2021 08:16:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y24sm12058331pjp.26.2021.04.19.08.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:16:42 -0700 (PDT)
Date:   Mon, 19 Apr 2021 15:16:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
Message-ID: <YH2e1lIckOBY2OGa@google.com>
References: <cover.1618196135.git.kai.huang@intel.com>
 <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
 <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
 <3d376fef419077376eecb017ab494ba7ffc393a7.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d376fef419077376eecb017ab494ba7ffc393a7.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Kai Huang wrote:
> On Sat, 2021-04-17 at 16:11 +0200, Paolo Bonzini wrote:
> > On 12/04/21 06:21, Kai Huang wrote:
> > > @@ -4377,6 +4380,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> > >   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
> > >   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
> > >   
> > > 
> > > +	if (cpu_has_vmx_encls_vmexit() && nested) {
> > > +		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> > > +			vmx->nested.msrs.secondary_ctls_high |=
> > > +				SECONDARY_EXEC_ENCLS_EXITING;
> > > +		else
> > > +			vmx->nested.msrs.secondary_ctls_high &=
> > > +				~SECONDARY_EXEC_ENCLS_EXITING;
> > > +	}
> > > +
> > 
> > This is incorrect, I've removed it.  The MSRs can only be written by 
> > userspace.

vmx_compute_secondary_exec_control() violates that left, right, and center, it's
just buried down in vmx_adjust_secondary_exec_control().  This is an open coded
version of that helper, sans the actual update to exec_control since ENCLS needs
to be conditionally intercepted even when it's exposed to the guest.

> > If SGX is disabled in the guest CPUID, nested_vmx_exit_handled_encls can 
> > just do:
> > 
> > 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
> > 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
> > 		return false;
> > 
> > and the useless ENCLS exiting bitmap in vmcs12 will be ignored.
> > 
> > Paolo
> > 
> 
> Thanks for queuing this series!
> 
> Looks good to me. However if I read code correctly, in this way a side effect would be
> vmx->nested.msrs.secondary_ctls_high will always have SECONDARY_EXEC_ENCLS_EXITING bit
> set, even SGX is not exposed to guest, which means a guest can set this even SGX is not
> present, but I think it is OK since ENCLS exiting bitmap in vmcs12 will be ignored anyway
> in nested_vmx_exit_handled_encls() as you mentioned above.
> 
> Anyway, I have tested this code and it works at my side (by creating L2 with SGX support
> and running SGX workloads inside it).
> 
> Sean, please also comment if you have any.
> 
> 
