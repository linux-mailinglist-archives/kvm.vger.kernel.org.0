Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4D62E5A7
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiKQUOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiKQUOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:14:34 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4CD2F664;
        Thu, 17 Nov 2022 12:14:33 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v17so2675104plo.1;
        Thu, 17 Nov 2022 12:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXtykp6uOflNtBDft8OJSus5n3qX3RKU76Dq7puWTXY=;
        b=FRUUiYDjn0143+2Cq1TPOq1Tvh2+hQURnhBMONeZVESBoToYxs6xmGoNI411MhkLYn
         YH2tI7k578AAN41YVsNA+wAlp/Kzy2U6M6WKqhGgcgnX3pwB7bBqpWZ+vAhFlCQdUHcn
         23Fk3TMOx46JRy867WW5AOnt6LIT4QEU2kkvKpNXb00tZgY486GjB/B8oQWqCcjaQ/yW
         8HgVqJ+23Dbg5ztLn9DCJEEHZOUWHl91xfhkK5JMMYC/u1pdbxr4G1PoHfPyh1ZugDhG
         G8qrEj7+wlRFG7hrv3RYUEWQYHa3fuyAh68kd/Fso53x248EE9JKV2Z8y40DIXGx/Ad5
         UacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXtykp6uOflNtBDft8OJSus5n3qX3RKU76Dq7puWTXY=;
        b=aOQxvAzqlseB01uzVluEyG4xm2c5p9F6lH+um45/N6qjoZwKJsjz9nwP1G5d5pLYJc
         6gS+hy9kZtCEPpx9/75Jv481/bAbnCRzNKmZaGOhvwym64C3xL+Ah0AwBeMQ546HuCId
         KMePwKF4mW8G2nyewVgEQWdgzrc87a/78V6X0+i68jvvwfsgq52sr6HnUhIh2XJ9TfZp
         bx9R6VgP9p3S4fpQVTWFyLWQTqKjvcIgSRAOwOVsjAp06VGKITuWhYxnRaVBy9EkuqPw
         247k94rVrQsPmxaSOaWxmBBdxF16O6H6czcneX8yloifciQLsT2n/B5bFYgVdKLMP3a8
         lHTQ==
X-Gm-Message-State: ANoB5pmtuYOcPi+IWjmw25t/aMO7GVO8U1JVFCSiGyHyLYXZtpP+aXGq
        UVJOiutgfo0gzFOvqi2iiMg=
X-Google-Smtp-Source: AA0mqf7XWf8DGiPQNWUMcxtMySn/nxpNcRAkil6JmV4ATJ5XrBk5FL89HpOVYtzy2H+V6vy1m75+bA==
X-Received: by 2002:a17:902:bf06:b0:17e:802b:fd6e with SMTP id bi6-20020a170902bf0600b0017e802bfd6emr4364903plb.116.1668716073317;
        Thu, 17 Nov 2022 12:14:33 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id u13-20020a170903124d00b00186ad73e2d5sm1791202plh.208.2022.11.17.12.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:14:33 -0800 (PST)
Date:   Thu, 17 Nov 2022 12:14:32 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 072/108] KVM: TDX: restore user ret MSRs
Message-ID: <20221117201432.GB2751024@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <3260994f3d9a036795c81bf06842558afabeeef7.1667110240.git.isaku.yamahata@intel.com>
 <de9b844f-c70b-bce7-9723-25f61e4f696f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <de9b844f-c70b-bce7-9723-25f61e4f696f@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 03:49:32PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Several user ret MSRs are clobbered on TD exit.  Restore those values on
> > TD exit and before returning to ring 3.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 43 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3ec465cbaeef..f35ccf2b502d 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -456,6 +456,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   	vcpu->kvm->vm_bugged = true;
> >   }
> > +struct tdx_uret_msr {
> > +	u32 msr;
> > +	unsigned int slot;
> > +	u64 defval;
> > +};
> > +
> > +static struct tdx_uret_msr tdx_uret_msrs[] = {
> > +	{.msr = MSR_SYSCALL_MASK,},
> > +	{.msr = MSR_STAR,},
> > +	{.msr = MSR_LSTAR,},
> > +	{.msr = MSR_TSC_AUX,},
> > +};
> > +
> > +static void tdx_user_return_update_cache(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> > +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> > +					     tdx_uret_msrs[i].defval);
> > +}
> > +
> >   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> >   {
> >   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > @@ -495,6 +517,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> >   	tdx_vcpu_enter_exit(vcpu, tdx);
> > +	tdx_user_return_update_cache();
> >   	tdx_restore_host_xsave_state(vcpu);
> >   	tdx->host_state_need_restore = true;
> > @@ -1558,6 +1581,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> >   		return -ENODEV;
> >   	}
> > +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> > +		/*
> > +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> > +		 * before returning to user space.
> > +		 *
> > +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> > +		 * because the registration is done at vcpu runtime by
> > +		 * kvm_set_user_return_msr().
> > +		 * Here is setting up cpu feature before running vcpu,
> > +		 * registered is alreays
> 
> typo, already or always?

already. Thanks.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
