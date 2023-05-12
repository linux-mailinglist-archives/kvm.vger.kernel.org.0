Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14376700D1A
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 18:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbjELQgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 12:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjELQgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 12:36:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95184AD06
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 09:35:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51b7810ec2cso5479756a12.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 09:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683909343; x=1686501343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJVtsVgkJ9xPeAAGT/C87CXV1IF/qgXHBdnwAFzyB8I=;
        b=1VNxtdKQHKbcU7lqUQORqeDfbAmE33Jz9JeTk4gPQ3CVa5kpsaJ5Mxv3KG0KO1ro3u
         Ccl5UAMIEsghYui3h7vbtdCJ5jhhcGcKmHs4g0sXYlJiln3detNGXE0ei4phyk79HYAn
         bWdrdat13IaSNS4qnYv0WtA5jwzRudQvvRdHVyJYKhgTu+mlmaJ+KAxOsxHklg8VKEGR
         fNaBGNtbiOmR50W8rwor0ixLVLi9We7DMgFzhtwgk0/Iwu+kcvrhHkEC0EJSCnpyVZwy
         7VNR5RO2oNREIgvrTU82m/vsv5hVhj55J7RzM8caBxLBHwD8h63w2LxKqYa7c7RueDgB
         PMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683909343; x=1686501343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJVtsVgkJ9xPeAAGT/C87CXV1IF/qgXHBdnwAFzyB8I=;
        b=Qw9ohmnHeFWse/i0nLUtdO+FayqGuskv9/CsGdvuNO3LBhDtCb9tzTD5hT7X/iNVf9
         pygzk1gUNeONyKIQKum23wx41sGzQVwxVzrNPfFv9UF2UhoZa/y+8GGvzK1yNxqiNPoc
         ntG5l2G7wMaiu09lnTQp9i2keWYzoRJjOVmWRCQVNqOrZZ1AC48FicZENqhpUoUgXDFr
         Q60X009IzyuNcxshKtg2EkwFiv08ldvsDiVfj1ky/0LcCNUXNvibXQpcpeW0wgExer4i
         5F0VeM1zdcwp48v648hB/FYujtC0d/Kld/GaDDjEK5xa1ilBIpp/HJGpqv6E6qte4C1c
         6A6A==
X-Gm-Message-State: AC+VfDxznrj1wS+Ve3DtEwftaqcJHY8ONVNND7TJTNUlDsTV/h5LOmfz
        jyRidz1g1WrMaHIcmfSRlbPXMc8qoBM=
X-Google-Smtp-Source: ACHHUZ4CBKc6IL7gAYfIPzaLSvqPSjfRZ59HmgdGmTz8eILgng02sq5+DVlkeY/SKMuvIZOE1knm71X5xdI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2d5:0:b0:52c:bf59:f4f2 with SMTP id
 204-20020a6302d5000000b0052cbf59f4f2mr6269326pgc.1.1683909343049; Fri, 12 May
 2023 09:35:43 -0700 (PDT)
Date:   Fri, 12 May 2023 09:35:40 -0700
In-Reply-To: <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com> <20230511233351.635053-6-seanjc@google.com>
 <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
Message-ID: <ZF5qnQQYa6OAI0Hy@google.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023, Kai Huang wrote:
> On Thu, 2023-05-11 at 16:33 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e7f78fe79b32..8b356c9d8a81 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3700,8 +3700,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  			return 1;
> >  		}
> >  		break;
> > -	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> > -	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
> > +	case MSR_IA32_CR_PAT:
> > +	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
> > +	case MSR_MTRRdefType:
> >  		return kvm_mtrr_set_msr(vcpu, msr, data);
> >  	case MSR_IA32_APICBASE:
> >  		return kvm_set_apic_base(vcpu, msr_info);
> > @@ -4108,9 +4109,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		msr_info->data = kvm_scale_tsc(rdtsc(), ratio) + offset;
> >  		break;
> >  	}
> > +	case MSR_IA32_CR_PAT:
> >  	case MSR_MTRRcap:
> 
> ... Should we put MSR_IA32_CR_PAT after MSR_MTRRcap so it can be symmetric to
> kvm_set_msr_common()?
> 
> Looks there's no reason to put it before MSR_MTRRcap.

No, it's above MTRRcap for two reasons:

 1. When PAT is moved out of mtrr.c, PAT doesn't get bunded with the other MTRRs
    and so would just need to be hoisted back up.  The end code looks like:

	case MSR_IA32_CR_PAT:
		msr_info->data = vcpu->arch.pat;
		break;
	case MSR_MTRRcap:
	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
	case MSR_MTRRdefType:
		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 
 2. There is no MSR_MTRRcap case statement in kvm_set_msr_common() because it's
    a read-only MSR, i.e. the two can't be symmetric :-)

> > -	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> > -	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
> > +	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
> > +	case MSR_MTRRdefType:
> >  		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
> >  	case 0xcd: /* fsb frequency */
> >  		msr_info->data = 3;
> > -- 
> > 2.40.1.606.ga4b1b128d6-goog
> > 
> 
