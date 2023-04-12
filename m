Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F86DF926
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 16:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjDLO5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 10:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDLO5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 10:57:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651BC6E8F
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:57:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54ee397553eso122298147b3.19
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681311423; x=1683903423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UxuSmrxcS5kvb5ro9G9wLKGBPlYViuLgcSx+dZgTw44=;
        b=vbh+sD6bSGK2jMfoJ/XyWWBWb258PuGE9SbBVYhyrammk8fHt+mzkhJr4NPIIobVOp
         DnMtl3q99fCA0Jx4JRr2cqcOrRqOzO7K1mTcU45QX6JNnJbJUEIqzwAJA1153kODFif+
         uGKr5cmUHodF9Z0qhJ4C0OF0XzISTXEyvOWGuVzj5rwgLzWLKh7wrcdsNTPYVuTnxZtr
         dytsavvmD9UgtURE+8gFZiqP94OpeoOw32aOen7lUcLcM1t7ZbK1sCM9ldTSOdyfm8BZ
         XQmOWQmi4fk3Gf95quFDdBaMlThOVLKt/3u5m5+4G31t60uahVsktM+ClGYuBHepi4BW
         85qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681311423; x=1683903423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxuSmrxcS5kvb5ro9G9wLKGBPlYViuLgcSx+dZgTw44=;
        b=p0wlAoZ1DjXuSYnvrHGWssSr4YZysrw6VNAH9yDrgfE9bA+8o6UXde9lOyi2HjM6lg
         wPFoPpeHdyAUjC+L3WrDPBFTBzi6UGYJIZLjkprukXI/1xufmtiBuaxak/MHAKfOa555
         15kWo/YOEiW57VqUq3gtaULmSm3im22IL/btPfugguUF9MMdyhNSCGFWAXGvQCq4DFX+
         1xLQ3HYOWMAbWha8SV4+mLjxGMrbO1l1dXilQavhaEV9+o/C6F7TTdfdL32fxFxWz8jy
         mszni8+Vp8+QVSZFnD4TiA0jjOwKLMEDMOXNHuHzqoL7S50ROV02QovsydHcuGWTMQVh
         4lEg==
X-Gm-Message-State: AAQBX9cqmopuWJH464cXZDXlF1pE1quVlFYdE/1vJWpfbDdPongdLzds
        k0klUbT/8PlLfKaFU78KNXuJ9adBXh8=
X-Google-Smtp-Source: AKy350a4ZuucXx2qirsNP0iItyLkiWlkZZ6EeKErOwzoigS1mEf9dDAD6gNZTKrWlhKqxdLhM/IjVG0ojf0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae46:0:b0:54e:edf3:b48f with SMTP id
 g6-20020a81ae46000000b0054eedf3b48fmr2040578ywk.5.1681311423706; Wed, 12 Apr
 2023 07:57:03 -0700 (PDT)
Date:   Wed, 12 Apr 2023 07:57:02 -0700
In-Reply-To: <1c9bebd63b25f2789b4064748c30c4590bbc2c7d.camel@intel.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com> <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
 <ZC4qF90l77m3X1Ir@google.com> <1c9bebd63b25f2789b4064748c30c4590bbc2c7d.camel@intel.com>
Message-ID: <ZDbGvic9qmplVRT8@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023, Kai Huang wrote:
> On Wed, 2023-04-05 at 19:10 -0700, Sean Christopherson wrote:
> > On Wed, Apr 05, 2023, Huang, Kai wrote:
> > > On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > > > *** WARNING *** ABI breakage.
> > > > 
> > > > Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> > > > for SGX enclaves.  Past me didn't understand the roles and responsibilities
> > > > between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> > > > being helpful by having KVM adjust the entries.
> > > 
> > > Actually I am not clear about this topic.
> > > 
> > > So the rule is KVM should never adjust CPUID entries passed from userspace?
> > 
> > Yes, except for true runtime entries where a CPUID leaf is dynamic based on other
> > CPU state, e.g. CR4 bits, MISC_ENABLES in the MONITOR/MWAIT case, etc.
> > 
> > > What if the userspace passed the incorrect CPUID entries?  Should KVM sanitize
> > > those CPUID entries to ensure there's no insane configuration?  My concern is if
> > > we allow guest to be created with insane CPUID configurations, the guest can be
> > > confused and behaviour unexpectedly.
> > 
> > It is userspace's responsibility to provide a sane, correct setup.  The one
> > exception is that KVM rejects KVM_SET_CPUID{2} if userspace attempts to define an
> > unsupported virtual address width, the argument being that a malicious userspace
> > could attack KVM by coercing KVM into stuff a non-canonical address into e.g. a
> > VMCS field.
> 
> Sorry could you elaborate an example of such attack? :)

Hrm, I was going to say that userspace could shove a noncanonical address in
MSR_FS/GS_BASE and trigger an unexpected VM-Fail (VMX) or ??? behavior on VMLOAD
(I don't think SVM consistency checks FS/GS.base).  But is_noncanonical_address()
queries CR4.LA57, not the address width from CPUID.0x80000008, which makes sense
enumearing 57 bits of virtual address space on a CPU without LA57 would also allow
shoving a bad value into hardware.

So even that example is bogus, i.e. commit dd598091de4a ("KVM: x86: Warn if guest
virtual address space is not 48-bits") really shouldn't have gone in.

> > The reason for KVM punting to userspace is that it's all but impossible to define
> > what is/isn't sane.  A really good example would be an alternative we (Google)
> > considered for the "smaller MAXPHYADDR" fiasco, the underlying problem being that
> > migrating a vCPU with MAXPHYADDR=46 to a system with MAXPHYADDR=52 will incorrectly
> > miss reserved bit #PFs.
> > 
> > Rather than teach KVM to try and deal with smaller MAXPHYADDRs, an idea we considered
> > was to instead enumerate guest.MAXPHYADDR=52 on platforms with host.MAXPHYADDR=46 in
> > anticipation of eventual migration.  So long as userspace doesn't actually enumerate
> > memslots in the illegal address space, KVM would be able to treat such accesses as
> > emulated MMIO, and would only need to intercept #PF(RSVD).
> > 
> > Circling back to "what's sane", enumerating guest.MAXPHYADDR > host.MAXPHYADDR
> > definitely qualifies as insane since it really can't work correctly, but in our
> > opinion it was far superior to running with allow_smaller_maxphyaddr=true.
> 
> I guess everyone wants performance.

Performance was a secondary concern, functional correctness was the main issue.
We were concerned that KVM would end up terminating healthy/sane guests due to
KVM's emulator being incomplete, i.e. if KVM failed to emulate an instruction in
the EPT violation handler when GPA > guest.MAXPHYADDR.  That, and SVM sets the
Accessed bit in the guest PTE before the NPT exit, i.e. KVM can't emulate a
smaller guest.MAXPHYADDR without creating an architectural violation from the
guest's perspective (a PTE with reserved bits should never set A/D bits).
