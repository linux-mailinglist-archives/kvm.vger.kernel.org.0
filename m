Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026D03FF18B
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346345AbhIBQhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244016AbhIBQhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:37:35 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAEC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:36:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e7so2562973pgk.2
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WoqzlkSq/fGvPkW8YSM9+7jUzqSLn8LthZIO2IYZaaI=;
        b=EEt3jt+S/Vci4zOc2xXUi/q+4p+B26VNW1UEEVqkibBi6mK2FwOUk1MdFlVSEMLOrJ
         d/Y1GQP1SHYBP3qaD29j6I/xwZ4Qk6GCSKQojlmJgH3IxGgE3RmB94Mq3pKkaiDkshak
         M3wC0yRrjXekqCh34ATBmVCBiyibb4kkXb9l9mojlO6gZxz2/gW/J9VLrdiR8JNp22Mi
         mlBrnft4AALtSAiy7BVK00Yxgom9yCxS/J/MXfpPmtlBmp5RC42QjjAEjsYWmM5Hapea
         V070XUV1Hs3cEmbIeKHAHZY/z5MQcknVUpkcFz6y4FchLBtfjAGHkgRGrCo+n6SdxsTn
         Y3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WoqzlkSq/fGvPkW8YSM9+7jUzqSLn8LthZIO2IYZaaI=;
        b=UHBvedBe4UZzl3IVQd2hay/ZY0OrJgooOybzPCGPVibuI711ipGJI9yYyQsvTLVwcH
         HiL1MVGTRDurDPaf1ViUVcBQ3xfIWsJk2KiwXNjwtppvtge8PHqV6lL4iSeTXueYUStE
         4LLwIkONDWZo4Oum0NiMgKDqhyrMSCIpHN+QHU1Ek4cb6f+9E9jcPBg8XPBlZnVpp7Be
         DZ+tdOL+Mp8mI70vs/zsWgiMbUjOmEgExBAY2h6EczPCd5W6kdNshsst15Co/JGJuKiO
         clNS1XdE/PUbQIZ69DB7rBuWMPz2oPPpi6nX0VKhJyM82jScS7keBfrKuZ4vOzOM5Sez
         WvSQ==
X-Gm-Message-State: AOAM531hUeulQvx3CuAlyOHwQqdCGJ6/WSDshO7ks/aPxdetHXCn0z4q
        tUhC9AxkO3VNyzJUY4Mlr29SPQ==
X-Google-Smtp-Source: ABdhPJxxFMkDLmuTdTkfD6jluqnpwjbDQr6laF4lzbyjb+BdXXTCdkepFXCmGefjgCwNI6xghcnuqA==
X-Received: by 2002:a63:dc03:: with SMTP id s3mr4136239pgg.88.1630600596415;
        Thu, 02 Sep 2021 09:36:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p9sm3646853pgn.36.2021.09.02.09.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:36:35 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:36:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YTD9kIIzAz34Ieeu@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <YTD4l7L0CKMCQwd5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTD4l7L0CKMCQwd5@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Sean Christopherson wrote:
> On Tue, Aug 03, 2021, Xiaoyao Li wrote:
> > On 8/2/2021 11:46 PM, Sean Christopherson wrote:
> > > > > > @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
> > > > > >    	return 0;
> > > > > >    }
> > > > > > +static int handle_notify(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> > > > > > +
> > > > > > +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
> > > > > 
> > > > > What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.
> > > > 
> > > > It means whether the VM context is corrupted and not valid in the VMCS.
> > > 
> > > Well that's a bit terrifying.  Under what conditions can the VM context become
> > > corrupted?  E.g. if the context can be corrupted by an inopportune NOTIFY exit,
> > > then KVM needs to be ultra conservative as a false positive could be fatal to a
> > > guest.
> > > 
> > 
> > Short answer is no case will set the VM_CONTEXT_INVALID bit.
> 
> But something must set it, otherwise it wouldn't exist.  The condition(s) under
> which it can be set matters because it affects how KVM should respond.  E.g. if
> the guest can trigger VM_CONTEXT_INVALID at will, then we should probably treat
> it as a shutdown and reset the VMCS.

Oh, and "shutdown" would be relative to the VMCS, i.e. if L2 triggers a NOTIFY
exit with VM_CONTEXT_INVALID then KVM shouldn't kill the entire VM.  The least
awful option would probably be to synthesize a shutdown VM-Exit to L1.  That
won't communicate to L1 that vmcs12 state is stale/bogus, but I don't see any way
to handle that via an existing VM-Exit reason :-/

> But if VM_CONTEXT_INVALID can occur if and only if there's a hardware/ucode
> issue, then we can do:
> 
> 	if (KVM_BUG_ON(exit_qual & NOTIFY_VM_CONTEXT_INVALID, vcpu->kvm))
> 		return -EIO;
> 
> Either way, to enable this by default we need some form of documentation that
> describes what conditions lead to VM_CONTEXT_INVALID.
