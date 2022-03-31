Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4E24EE3B3
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbiCaWCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiCaWCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:02:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0B51107EC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:00:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id j13so800741plj.8
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xdDHp8DZv62+tC1QpF06xU//55Uv53QsP+VwWvx7yKA=;
        b=EIWeMACFP4jLGYR2cBqX0EnEcdQE/UAi5wgZaLvKnjpAg/Buj6Lo83ST7MK6tOkMYw
         kRH74cPPb3v1iG73l1LNJJA0CGbfykkoyj4j7nqrk+hsmYuLq3tTsW4ByFj7IRk7vPHB
         DJ5ZxUkYx7xQ8yJ9S/3YkhYeutJi+8qh6U77T3WrtdbxhnFuDqULsk3BHrSCarE6dsAq
         EeV1B3qVaS3NRcq5KQO5GlxNLakQbAHUR/NziCSq9TzoTuhfxS5kAHrcHH4v2EHDAosp
         KlJWuYEqRDSNAZ3GimiSa70ZD3rv5XS7YEeZWO9pLkSQi54edf2uCsc88gi76sB/5Cwe
         +uNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xdDHp8DZv62+tC1QpF06xU//55Uv53QsP+VwWvx7yKA=;
        b=bl+gswViGltAz4G4pb8iVP4qOyrqRxtilUrm5ePNYidmE4tT81BQOvYcrzPaL1+ZTF
         ldjhU+A3dzqHjfrxqV2GEnRh73Kg6Fs35dhuR5ZQw08OHlcjUoZKwpd9ojhhnap7mFDx
         IBTKNy0jS9oGjijE6ACmAmNJtw1D4pZ2d/5FwZZYmZbKFpydjuVStFfmT8m9EoBOXc6h
         UmODH98UJppmMzC3F7RulxdfZ4CEZ7kvdwrhSG6e3s9DGBZioRVMQTromS+i+11iKNXy
         azGUqQxvq0TuolcXM9ejtc4hXPTSoJUSkJm1NlQ4Xcj2yUmrzP57fO+3u8Wrvg2tjOPq
         nHrQ==
X-Gm-Message-State: AOAM533hHD4DJCJAZMcp0zyP+u7Nf2m02iQV1iXN3PIvySLs+rMjoJ+C
        +ECO0klm2x+vNwMcOPnH2BasOQ==
X-Google-Smtp-Source: ABdhPJz1IGynAVRKqq2sYcpKslDVnp2bEwrTzO0FDG5XYcRu+u38Lvvd1DQheCE7tkhG9mNJ54bvKw==
X-Received: by 2002:a17:90a:728f:b0:1c9:dbf2:591b with SMTP id e15-20020a17090a728f00b001c9dbf2591bmr8277572pjg.172.1648764044464;
        Thu, 31 Mar 2022 15:00:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z7-20020a056a00240700b004e1cde37bc1sm453873pfh.84.2022.03.31.15.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:00:43 -0700 (PDT)
Date:   Thu, 31 Mar 2022 22:00:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RESEND 2/5] KVM: X86: Add guest interrupt disable state
 support
Message-ID: <YkYkiLRo+p2T/HQx@google.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
 <1648216709-44755-3-git-send-email-wanpengli@tencent.com>
 <YkOembt1lvTEJrx0@google.com>
 <CANRm+Cy66YAyRp0JJuoyp3k-D9HSZbYF3hYO3Vjxz5w1Rz-P3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cy66YAyRp0JJuoyp3k-D9HSZbYF3hYO3Vjxz5w1Rz-P3g@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022, Wanpeng Li wrote:
> On Wed, 30 Mar 2022 at 08:04, Sean Christopherson <seanjc@google.com> wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 50f011a7445a..8e05cbfa9827 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -861,6 +861,7 @@ struct kvm_vcpu_arch {
> > >               bool preempt_count_enabled;
> > >               struct gfn_to_hva_cache preempt_count_cache;
> > >       } pv_pc;
> > > +     bool irq_disabled;
> >
> > This is going to at best be confusing, and at worst lead to bugs  The flag is
> > valid if and only if the vCPU is not loaded.  I don't have a clever answer, but
> > this needs to have some form of guard to (a) clarify when it's valid and (b) actively
> > prevent misuse.
> 
> How about renaming it to last_guest_irq_disabled and comments as /*
> Guest irq disabled state, valid iff the vCPU is not loaded */

What about usurping vcpu->run->if_flag?  Userspace could manipulate the data, but
that should be fine since the data is already guest-controlled.
