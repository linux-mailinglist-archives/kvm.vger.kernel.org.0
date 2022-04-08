Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B36C4F8C7D
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiDHCUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 22:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiDHCUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 22:20:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A7C1D0DF;
        Thu,  7 Apr 2022 19:18:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d15so6661553pll.10;
        Thu, 07 Apr 2022 19:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o0cQuvUKTZm4ZjWyQIb1ASci1RthUlv38d72RXq3EFs=;
        b=VYo+0a4JBbD6ZVEM9PWWuJTnW/bdtE3xmbjNjlFVKYNwpXx9/6DqADslQeLfxfxgof
         J5IfV3lCCLGR4zSy6VSIgciDw12pWUB0jxFaEpDGvzUo5sBM2TPC1iAKKgcbj0Pj99qg
         53e2NPtcgfSTx26VNWz/LIO72CAjEr8iz1BSr9OzQ8RXYAPM4SsuR1I3HqAQq/r3/5Cw
         N07iG71TA1fAWEjKErBdSDFlrB7ez45wH9n+DXw4KNOvETb2YxjjcZmdWTG8VXqnQcvC
         GIJRNnCzG7/Vei9a8/fVZpQ1vruOc40JKKgvx6NglmnZMduKwy0knmbCq+Ex6kleB3YS
         neMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o0cQuvUKTZm4ZjWyQIb1ASci1RthUlv38d72RXq3EFs=;
        b=AnywEjErEPpVTPdMO5qqM2xk9WHlkGab/6KSgyzDHWvRSmSHlXVBboRi/G88F6f+KR
         R9nkZwShdtAQiCNL4+dFXftyTrsu8mmdOvtjYXxlOEybGDH+0DIoqZy16sg4XZ49j/er
         U/+sQijnk+CxpXCbn3B23Z5qn1BMnOyc3ZpVr23PtgWk6j3pzTfQxzx4ONmpXoGBA8dS
         EG77ZunKFwjbYMsaln9P8d5l8F4LATcE3SqSfpXXqNB9mJgiLb+8lYiuFIGUafNnPOne
         Ioo06VlP72rCAO/gsBr3Re5BFMPrNQMXNDPdbQPlzc5K0lI6T8bodZuI9iAtzdjS/i5Q
         8gBg==
X-Gm-Message-State: AOAM530nwc2fZAdddiMfpHCKTT14P8Z/IpLp8xgNZkWTgcLRpTjVgr/w
        yXVlM0WNXw83RZXtOESEz5A=
X-Google-Smtp-Source: ABdhPJy4GuSncifOMTLsISn67FovQIdb3IQix/UKOsY+EncibFUtYyDaLLfmBmohtDY3EFGEQXxF5Q==
X-Received: by 2002:a17:902:a9c5:b0:156:32bf:b526 with SMTP id b5-20020a170902a9c500b0015632bfb526mr17219876plr.46.1649384285892;
        Thu, 07 Apr 2022 19:18:05 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm25260744pfh.177.2022.04.07.19.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 19:18:05 -0700 (PDT)
Date:   Thu, 7 Apr 2022 19:18:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20220408021803.GE2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 05:55:01PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 70f9be4ea575..6e26dde0dce6 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
> >  /* Trust Domain eXtension sub-ioctl() commands. */
> >  enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> > +	KVM_TDX_INIT_VM,
> >  
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > @@ -561,4 +562,15 @@ struct kvm_tdx_capabilities {
> >  	struct kvm_tdx_cpuid_config cpuid_configs[0];
> >  };
> >  
> > +struct kvm_tdx_init_vm {
> > +	__u32 max_vcpus;
> > +	__u32 tsc_khz;
> > +	__u64 attributes;
> > +	__u64 cpuid;
> 
> Is it better to append all CPUIDs directly into this structure, perhaps at end
> of this structure, to make it more consistent with TD_PARAMS?
> 
> Also, I think somewhere in commit message or comments we should explain why
> CPUIDs are passed here (why existing KVM_SET_CUPID2 is not sufficient).

Ok, let's change the data structure to match more with TD_PARAMS.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 20b45bb0b032..236faaca68a0 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -387,6 +387,203 @@ static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> >  	return 0;
> >  }
> >  
> > +static struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(struct kvm_tdx *kvm_tdx,
> > +						u32 function, u32 index)
> > +{
> > +	struct kvm_cpuid_entry2 *e;
> > +	int i;
> > +
> > +	for (i = 0; i < kvm_tdx->cpuid_nent; i++) {
> > +		e = &kvm_tdx->cpuid_entries[i];
> > +
> > +		if (e->function == function && (e->index == index ||
> > +		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> > +			return e;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > +			struct kvm_tdx_init_vm *init_vm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct tdx_cpuid_config *config;
> > +	struct kvm_cpuid_entry2 *entry;
> > +	struct tdx_cpuid_value *value;
> > +	u64 guest_supported_xcr0;
> > +	u64 guest_supported_xss;
> > +	u32 guest_tsc_khz;
> > +	int max_pa;
> > +	int i;
> > +
> > +	/* init_vm->reserved must be zero */
> > +	if (find_first_bit((unsigned long *)init_vm->reserved,
> > +			   sizeof(init_vm->reserved) * 8) !=
> > +	    sizeof(init_vm->reserved) * 8)
> > +		return -EINVAL;
> > +
> > +	td_params->max_vcpus = init_vm->max_vcpus;
> > +
> > +	td_params->attributes = init_vm->attributes;
> > +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > +		pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
> > +			"host perf registers properly.\n");
> > +		return -EOPNOTSUPP;
> > +	}
> 
> PERFMON can be supported but it's not support in this series, so perhaps add a
> comment to explain it's a TODO?

Yes, good idea. Will do.


> > +	max_pa = 36;
> > +	entry = tdx_find_cpuid_entry(kvm_tdx, 0x80000008, 0);
> > +	if (entry)
> > +		max_pa = entry->eax & 0xff;
> > +
> > +	td_params->eptp_controls = VMX_EPTP_MT_WB;
> > +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> > +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> > +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> > +	} else {
> > +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> > +	}
> 
> Not quite sure, but could we support >48 GPA with 4-level EPT?

No.
"5-level paging and 5-level EPT"
section 4.1 4-level EPT
"4-level EPT is limited to translating 48-bit guest-physical addresses."
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
