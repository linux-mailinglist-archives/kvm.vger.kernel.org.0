Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D004E57F8
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbiCWR5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241540AbiCWR5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:57:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB4B71EF3;
        Wed, 23 Mar 2022 10:55:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id g3so2255668plo.6;
        Wed, 23 Mar 2022 10:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=74ozZKKGaEgDQrA8Jk64U3Yx/VDukiycGxbgIMenxpg=;
        b=gxsU3owAUgHQJcex7SYVEn6Sp+EdVzSF8FF0m+3KxflOGMYfM5nNZVtH/rJdMyExFz
         ApHIKSTnMfaSkuSDEx72uewBFZ+oBLAwMh+5g0B0hrEaf4pCe+HzLqVZ48sGiiye0Qzz
         6x6ZptEDvCsu+HYiJ4FlBvG7uu+PHjGL6YYkjsHrjC3H8WaG2gL88VWJ+xTQXDQVqJYL
         q28zSGpTw1CL5Jg+ufkVMlKf/Arg6OX0xqUIC5V/qcvKalfJ/Bl9OPpHLPxGHaYBYXsh
         K72Aj9rw3Uo8ptpTfSu78+QOum2iRX7277m6G8g5q1IOc0VTiwPGRrvyrj9gtyvKUNk5
         9dmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=74ozZKKGaEgDQrA8Jk64U3Yx/VDukiycGxbgIMenxpg=;
        b=YtOdKYLyQ00/CEFZ6HXiB3A1Hj9VTvw/2zO7Fn11A9L3oFPqefbsi0EXXabtQHiI4R
         AxMZvHJSkqqAJA6EoIAFYrKWeI9fSLsfdDr8lIxx43GrgYNSS/LEL314SeyfHEoCbEO1
         fqv5ZWmUqDRTpSl6+n51xJDQLyX5zE/4RKXppEoNvJGPJCK8/bO5Meb8cXHwUJWWLPDk
         6uWUA8MhNj7otwZXCjAE103RAyaICpqSbkcZeIgv6OFmcg62BD5bXPy7IivbKocW30cD
         O64tfhzSu9y2hUEt8YEkdjrZIglSjctQgh9JbJvdCfO9W8Cs+eUcaOfKWcK5RZyil4fV
         osdw==
X-Gm-Message-State: AOAM533DdoRoIjMCdCwuH9k2qM9HY9LTLYkUE9YdtwRzGJzYK5oneYfU
        xMd24zpUpQMTmnRyJP6rHSw=
X-Google-Smtp-Source: ABdhPJznVZBA3Vg/agNsTCbhWL6GBJNHoM5nrUCS9hUyApEH9twQm4QLr/H1uugjsQKWz0rVM0+WZw==
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id q13-20020a17090a430d00b001bcf3408096mr977461pjg.93.1648058153981;
        Wed, 23 Mar 2022 10:55:53 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id w12-20020a056a0014cc00b004f790cdbf9dsm521606pfu.183.2022.03.23.10.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:55:53 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:55:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 064/104] KVM: TDX: Implement TDX vcpu enter/exit
 path
Message-ID: <20220323175552.GG1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <cedda3dbe8597356374ef64de26ecef0d8cd7a62.1646422845.git.isaku.yamahata@intel.com>
 <CAAYXXYy3QLWyq9QrEnrsOLB3r44QTgKaOW4=HhOozDuw1073Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYy3QLWyq9QrEnrsOLB3r44QTgKaOW4=HhOozDuw1073Gg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 10:28:42AM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Fri, Mar 4, 2022 at 11:50 AM <isaku.yamahata@intel.com> wrote:
> > @@ -509,6 +512,37 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >         vcpu->kvm->vm_bugged = true;
> >  }
> >
> > +u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
> > +
> > +static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > +                                       struct vcpu_tdx *tdx)
> > +{
> > +       guest_enter_irqoff();
> > +       tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
> > +       guest_exit_irqoff();
> > +}
> > +
> > +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > +{
> > +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +
> > +       if (unlikely(vcpu->kvm->vm_bugged)) {
> > +               tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> > +               return EXIT_FASTPATH_NONE;
> > +       }
> > +
> > +       trace_kvm_entry(vcpu);
> > +
> > +       tdx_vcpu_enter_exit(vcpu, tdx);
> > +
> > +       vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> > +       trace_kvm_exit(vcpu, KVM_ISA_VMX);
> > +
> > +       if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
> > +               return EXIT_FASTPATH_NONE;
> 
> Looks like the above if statement has no effect. Just checking if this
> is intentional.

I'm not sure if I get your point.  tdx->exit_reason is updated by the above
tdx_cpu_enter_exit().  So it makes sense to check .error or .non_recoverable.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
