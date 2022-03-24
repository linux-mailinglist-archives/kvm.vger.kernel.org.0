Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3204E6902
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 20:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352823AbiCXTHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345568AbiCXTHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 15:07:20 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2562AB82CD
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 12:05:48 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i12so3815990ilu.5
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 12:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bdKvMIDVNTrtFUnPvvj21CUc6VO1Vry7PVFr01V12K4=;
        b=YxwDWeqAK4gEdUMwxR5cmTX3l+obG1pZtVe73KNjmU2QScaJpB62pRLUEVGyN0+cb5
         fehdDTHoD6EnYa9P1JByCugQiXebfbIKqL4ZhXNHgVcJhK037XQZbbKrUrlqHEnlFkPz
         2daQN2mX87mVgnHLnAx881MEJ8639CmLEHk5NJg/s9ZG56hCy5XwfBhJqWDCCHT1rXXW
         7zHd7Fcdn2X9eKl+NJkqsJgNHfMsNQjGL0uzQRMcr5JcYT6rQESbC0uU8D9AUz67UBIb
         1rmwlnl083VHOLDfyj35719Q0O5aAajWKo+YK6IqO6/a6b9+jogp4AiLR2pMOOyO9cQh
         zMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bdKvMIDVNTrtFUnPvvj21CUc6VO1Vry7PVFr01V12K4=;
        b=mJ86zQj+ZGPvzqu+wf6GHZPcW6+7DvSltkc47TqHHGZEwC6JnGGtGxYAGhmQDzrMu/
         b2irHaVV2yK/qy4Q3tG3YYSn5cg2tROEgatRNd6SDe2yWrc91PLWXWgQpG+0HvgHcudV
         oZYKdM+wzlgot728IRwnxywEhPLYF4UsePsxxCfHcHq2BOUbNkdXDY8bfDCG2FcwA58b
         FO5WNw5s3vfIp1g7de4BCwuD8DiwICh2WvmaJD2W7KG3otgDWYbKhOhYtMZLG3nw5etp
         TMz4Z/CzGifyHmZQWzADT8HHVzI3bNhOFAaUYgTj5o5kfVlUIojW+kEUPVFqGJitSM2t
         j5Ew==
X-Gm-Message-State: AOAM531eSMyjwsHMldYc2R3+o69kIn08moW/tAIfR7680V8kfEE2JBxs
        JySx3YMqHEyM2GWeIBk0NI0Y46ULuQs3sg==
X-Google-Smtp-Source: ABdhPJzZU/NAVkGcEtkI+SpQQ2GV89NQggRqI7nLcju0OPbNarCvpy3YzT+Rk76hEO+WaP382hdWvw==
X-Received: by 2002:a05:6e02:20c7:b0:2c8:4ae0:ce78 with SMTP id 7-20020a056e0220c700b002c84ae0ce78mr3559039ilq.284.1648148747241;
        Thu, 24 Mar 2022 12:05:47 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6bf705000000b00649a2634725sm1849499iog.17.2022.03.24.12.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:05:46 -0700 (PDT)
Date:   Thu, 24 Mar 2022 19:05:43 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <YjzBB6GzNGrJdRC2@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 06:57:18PM +0100, Paolo Bonzini wrote:
> On 3/24/22 18:44, Sean Christopherson wrote:
> > On Wed, Mar 16, 2022, Oliver Upton wrote:
> > > KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
> > > both of these instructions really should #UD when executed on the wrong
> > > vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
> > > guest's instruction with the appropriate instruction for the vendor.
> > > Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
> > > use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
> > > do not patch in the appropriate instruction using alternatives, likely
> > > motivating KVM's intervention.
> > > 
> > > Add a quirk allowing userspace to opt out of hypercall patching.
> > 
> > A quirk may not be appropriate, per Paolo, the whole cross-vendor thing is
> > intentional.
> > 
> > https://lore.kernel.org/all/20211210222903.3417968-1-seanjc@google.com
> 
> It's intentional, but the days of the patching part are over.
> 
> KVM should just call emulate_hypercall if called with the wrong opcode
> (which in turn can be quirked away).  That however would be more complex to
> implement because the hypercall path wants to e.g. inject a #UD with
> kvm_queue_exception().
> 
> All this makes me want to just apply Oliver's patch.
> 
> > > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
> > > +		ctxt->exception.error_code_valid = false;
> > > +		ctxt->exception.vector = UD_VECTOR;
> > > +		ctxt->have_exception = true;
> > > +		return X86EMUL_PROPAGATE_FAULT;
> > 
> > This should return X86EMUL_UNHANDLEABLE instead of manually injecting a #UD.  That
> > will also end up generating a #UD in most cases, but will play nice with
> > KVM_CAP_EXIT_ON_EMULATION_FAILURE.

Sean and I were looking at this together right now, and it turns out
that returning X86EMUL_UNHANDLEABLE at this point will unconditionally
bounce out to userspace.

x86_decode_emulated_instruction() would need to be the spot we bail to
guard these exits with the CAP.

> Hmm, not sure about that.  This is not an emulation failure in the sense
> that we don't know what to do.  We know that for this x86 vendor the right
> thing to do is to growl at the guest.
> 
> KVM_CAP_EXIT_ON_EMULATION_FAILURE would not have a way to ask KVM to invoke
> the hypercall, anyway, so it's not really possible for userspace to do the
> emulation.

Userspace could theoretically patch the hypercall itself and retry execution.
But IMO, userspace should just leave the quirk enabled and accept the default
KVM behavior if it still wants hypercall patching.

--
Thanks,
Oliver
