Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10764E67A
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 04:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiLPDue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 22:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLPDuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 22:50:32 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649E48760;
        Thu, 15 Dec 2022 19:50:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so4790370pjp.1;
        Thu, 15 Dec 2022 19:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CdHnVY8nb6Yk9Xaeu1Dmkn7tDhOJ1cSSlgeTmWNpY4g=;
        b=UV5iZlPC8KUf7JHbTh4dsoHgiF93ceVHZjaIHpuDK6wC8L8vdqPWZfiiFbdGCShCIM
         gLSBTrwENZ2C+CMkQzo4nAmWHbMWU3PQg1qDtQKFZYmsD1CNiQItSCE1QMa4SP0pAhUT
         lU1XSamINyoWjjAUJMy1OUIlWrNkZfWbVmzqkElLJIc62er6F+ijQ949mzxLSYN64iR6
         P0xd/aVh/nN2+IWx5Km+mAhm18wL9S+sQQQ1ubIWrNaYeFvbRCQp6wEydKhbaN4OoESc
         dCgShe3Zc8jKViBb1PP99dfTzsTYbwSjfYCLNyQ9zntx8eEhjlSp6cVyzzASaYi38dyB
         gUMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdHnVY8nb6Yk9Xaeu1Dmkn7tDhOJ1cSSlgeTmWNpY4g=;
        b=oRfCbbC6gWDDPB9WXanO1jTXxlIsCrc9XQSmEMTzFd1UaI21IfD0drdOT3CuNTU5ke
         tpqUjSzs+xWjIccO7dqsPNZTrQYaYEuY8LsugKILK6evw7a2M60iXnouOEkmBoSeLg4K
         vcSBbNYh3NNwZdAswrPvMsSjfidbfRRfyYB1idiGG5PfUXpVm2DJP4gJjm9f+zq12xdt
         uXr33uRtKHP4bdGI6xRTZdyNm5rWutth5pbsBY5GOshlR53e8Pg8x+rUYeliVxaRBROy
         8t+WEzP8U0LC1Z61AEAVrSWXDwyrXz1A0FYOTlX4rpa0JW2/rabampoWe1oWzF6j/Pna
         DHTg==
X-Gm-Message-State: ANoB5pnXCCZlPgmWxP+YybQzYqZ6deJZ7BOZthzrL/ivRREipjhbqeUR
        Hj597WJst833BAAwU0wrdRM=
X-Google-Smtp-Source: AA0mqf75vcvr//vorQm4K80NqFRfToUE0p+UT6OLwgogK+RVdjBI+RkI3mEG67+dbJw9USxqPcQNyw==
X-Received: by 2002:a17:90a:4681:b0:220:bc30:a19e with SMTP id z1-20020a17090a468100b00220bc30a19emr25005848pjf.32.1671162631104;
        Thu, 15 Dec 2022 19:50:31 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id mm8-20020a17090b358800b00218d894fac3sm3965254pjb.3.2022.12.15.19.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 19:50:30 -0800 (PST)
Date:   Thu, 15 Dec 2022 19:50:29 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 104/108] KVM: TDX: Silently ignore INIT/SIPI
Message-ID: <20221216035029.GD527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <a888bb4d30de2e57b0eb5e61189349c86cab1a70.1667110240.git.isaku.yamahata@intel.com>
 <ea9cbd65-be61-036c-715f-ac4604d0cb73@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ea9cbd65-be61-036c-715f-ac4604d0cb73@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 11:17:44PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 4acba8d8cb27..d776d5d169d0 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -286,6 +286,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
> >   	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
> >   }
> > +static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return;
> > +
> > +	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
> > +}
> > +
> > +static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu)) {
> > +		/* TDX doesn't support INIT.  Ignore INIT event */
> > +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +		return;
> > +	}
> > +
> > +	kvm_vcpu_deliver_init(vcpu);
> > +}
> > +
> 
> Is it better to add WARN_ON_ONCE in the above two functions for TD case?

No because KVM_SET_VCPU_EVENTS ioctl can trigger those callback.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
