Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD83FF0ED
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbhIBQQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhIBQQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:16:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80232C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:15:24 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t1so2494378pgv.3
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9hsKCsvAc+NpyKxD6LkPgUN99rsUl4Mu6Z/Upfc+vYg=;
        b=fSm9PxGOLu5qMyu+VGbGIhHJD+A0Uyzyb7tbkPtzhXuBdHHqrcbyTZr3pJiv55xTtA
         xghzr1DngMbiT0AKuqFPivm9uA36tidlTAt1orchxQOYSbLQIzOij0VT3cJ1N6NoGiAc
         Dnzk2wgptNKid5HkHDoM3hn775CKM8+3h1VsixoMlRPTCwGjZRXRFwwZjedCtht+khYZ
         /38fGrDFrjxmFrceoL0HkLzx9JKVidIHkcVF+vB/07E7OnYhWXk2lhJp+rFE1LDv3Bw1
         sJ/wfC5CURAsO3YS8XnbHTEI2hGFGDMzzwzL6bNkRWgPlBIHj7qzcA26bu7WDoel5YUb
         RFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9hsKCsvAc+NpyKxD6LkPgUN99rsUl4Mu6Z/Upfc+vYg=;
        b=iFA03cbw7E9fvq8m1iszLGWboqemU9xB+swA44npo9mlYYX1evO5OkQLw7g1fWxf6x
         SgUzhziEz9SjBy/zuU50vxIEUv+Ws7QWqMBeshRfWID54WF6hb9brj8h6ipE7G7oXjGH
         SxyPOF1R1/j9N776nQHzNwSVaPEIuY9GlyYW+AF5l5RX6uvvl2j4pLYbBfV3/l9rwqkL
         OLX7ET8i+mqADi3rpSt9xGopbDSh+qdUPeul/1ECQ1zSpDsjKodMCrLipaWKtpuvaOHw
         MLpyGeyZX/yMlKg1WXNmQtuidRbLx5YY++REe1v6XBCR8iGt7E0QZ4wMUR51IXhEV3tT
         RLsw==
X-Gm-Message-State: AOAM5309sHjpOLrUam2m8qlPvo9u+Xt9zKfrMLiwY1qPVbgFiimVsm6e
        EzahMg1R2bNU2/QGWhFC293gRA==
X-Google-Smtp-Source: ABdhPJyuWPgLWVgkJrTn8l+ao7PrF4vWzU62syPlrpdLHUAeVgPTArfKsqKMDXGEeS7YXLai10fklQ==
X-Received: by 2002:a63:9d4c:: with SMTP id i73mr1479588pgd.216.1630599323729;
        Thu, 02 Sep 2021 09:15:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l127sm2920354pfl.99.2021.09.02.09.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:15:22 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:15:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YTD4l7L0CKMCQwd5@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021, Xiaoyao Li wrote:
> On 8/2/2021 11:46 PM, Sean Christopherson wrote:
> > > > > @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
> > > > >    	return 0;
> > > > >    }
> > > > > +static int handle_notify(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> > > > > +
> > > > > +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
> > > > 
> > > > What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.
> > > 
> > > It means whether the VM context is corrupted and not valid in the VMCS.
> > 
> > Well that's a bit terrifying.  Under what conditions can the VM context become
> > corrupted?  E.g. if the context can be corrupted by an inopportune NOTIFY exit,
> > then KVM needs to be ultra conservative as a false positive could be fatal to a
> > guest.
> > 
> 
> Short answer is no case will set the VM_CONTEXT_INVALID bit.

But something must set it, otherwise it wouldn't exist.  The condition(s) under
which it can be set matters because it affects how KVM should respond.  E.g. if
the guest can trigger VM_CONTEXT_INVALID at will, then we should probably treat
it as a shutdown and reset the VMCS.  But if VM_CONTEXT_INVALID can occur if and
only if there's a hardware/ucode issue, then we can do:

	if (KVM_BUG_ON(exit_qual & NOTIFY_VM_CONTEXT_INVALID, vcpu->kvm))
		return -EIO;

Either way, to enable this by default we need some form of documentation that
describes what conditions lead to VM_CONTEXT_INVALID.

> VM_CONTEXT_INVALID is so fatal and IMHO it won't be set for any inopportune
> NOTIFY exit.
