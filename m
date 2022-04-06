Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E224F6D2A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbiDFVrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiDFVqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:46:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF61777FF
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 14:25:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c23so3151796plo.0
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 14:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qe2CacMgj+jCc3pkDCwiveVrvTle60PK44vq1a1DPtE=;
        b=hbx6VWIdwKn1q8u9jC1ubsNbZ1FTtRQuswF9J82MrJC9oJjcGtErGoA2P2s9ShLSSu
         myns8iAB/xAvzNQBQLDssPbzB31U2UZestC3uTR2yCBem8p1SD5TRbNhn8VGkQfvA2RP
         z7UPymeyD5k5i+GQkDCneBuBmuoD0mJl7PicqAJYTtN+1GTKGcu6mZa1jUIZG0jiqB4J
         egbml7LKTGoJc71XTERWJUV0D9exFUhD/+2yfAPX8xzppsc/ETrgAVTHVA1g2YQZX7iw
         t/xRZcPoiEY1yyd+FYpw2AYayouApqXJMS3aXf0JFZUReLW3y2GjQDui40TXSuL7sxf5
         OjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qe2CacMgj+jCc3pkDCwiveVrvTle60PK44vq1a1DPtE=;
        b=YgQpEKdOOsbte8Kz8SPSqIZIL3XFBYjndEWq3+ClZ8BLvn/oGeKy+1KDPhwK/RcH0X
         jGwuQhSr7VxEYgRKA2/lLSxRxiIB5F70XBkgJS9h64P5kSHy54CGuwj1aO5y07wN3qTz
         GOxyS2aPjzyG8bgDZKMJ6kn9d2gpwdtCeOdRL96L/66pgJRE0D1HDycWrhWBia6yWy80
         ibXgy/NxanxmfLpZuK6a5djYHlTRTnFa2z1ngrchkaJjR/K2tQDSKFTcXuXdwKRwgh6r
         /WzPoDEBj4TlDHUJyqG2wwSQ6fRl8KTkcdLwOFaq2l/GE6W9WzrSD/f6IGDGv3mqWib+
         pcxg==
X-Gm-Message-State: AOAM532Bjkww6peMEE0D7dGuOLUWg6Xz5GbCM3RYlsOPy8UPWBogCFNt
        P6aLqPK8a8QeGvo4onQU6QFHew==
X-Google-Smtp-Source: ABdhPJza4w1wj7L/VkQR6GwXoUdzlZkbCsZh/WCqJE0j22B1oLiIOVzbS8djmGA+8lJUYR/CNsNA2Q==
X-Received: by 2002:a17:90b:3005:b0:1cb:f2b:2d03 with SMTP id hg5-20020a17090b300500b001cb0f2b2d03mr613861pjb.20.1649280330860;
        Wed, 06 Apr 2022 14:25:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm6533111pju.44.2022.04.06.14.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:25:29 -0700 (PDT)
Date:   Wed, 6 Apr 2022 21:25:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Message-ID: <Yk4FRlBbt29Z6/e7@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
 <YkzRSHHDMaVBQrxd@google.com>
 <YkzUceG4rhw15U3i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzUceG4rhw15U3i@google.com>
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

On Tue, Apr 05, 2022, Sean Christopherson wrote:
> On Tue, Apr 05, 2022, Sean Christopherson wrote:
> > On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> > > @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> > >  		}
> > >  	}
> > >  
> > > +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> > > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > +
> > >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> > 
> > Looks correct, but this really needs a selftest, at least for the SET path since
> > the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> > e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> > exit.
> > 
> > Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
> > making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
> > window to intercept the request.
> 
> Drat, I bet that MCE path means the WARN in nested_vmx_vmexit() can be triggered
> by userspace.  If so, this patch makes it really, really easy to hit, e.g. queue the
> request while L2 is active, then do KVM_SET_NESTED_STATE to force an "exit" without
> bouncing through kvm_check_nested_events().
> 
>   WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> 
> I don't think SVM has a user-triggerable WARN, but the request should still be
> dropped on forced exit from L2, e.g. I believe this is the correct fix:
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 9a6dc2b38fcf..18c5e96b12a5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1128,6 +1128,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
>         if (is_guest_mode(vcpu)) {
>                 svm->nested.nested_run_pending = 0;
>                 svm->nested.vmcb12_gpa = INVALID_GPA;
> +               kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>  
>                 leave_guest_mode(vcpu);
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f18744f7ff82..0587ef647553 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6276,6 +6276,7 @@ void vmx_leave_nested(struct kvm_vcpu *vcpu)
>  {
>         if (is_guest_mode(vcpu)) {
>                 to_vmx(vcpu)->nested.nested_run_pending = 0;
> +               kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>                 nested_vmx_vmexit(vcpu, -1, 0, 0);
>         }
>         free_nested(vcpu);
> 

Wrong again.  Once your patch to save/restore via KVM_VCPUEVENT_TRIPLE_FAULT
lands, clearing KVM_REQ_TRIPLE_FAULT is wrong because that will result in KVM
dropping the request when forcing an exit from L2 in order to reload L2 state,
e.g. if userspace restores events before nested state.  So I think the only thing
that can be done is to delete the WARN :-(
