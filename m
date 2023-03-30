Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455616CF89D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjC3BP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC3BP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:15:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E0D19A;
        Wed, 29 Mar 2023 18:15:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z19so16671676plo.2;
        Wed, 29 Mar 2023 18:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680138956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TihRUSuIbcyCr0lFNEjhUbfKbaamQ0uPf3hyuIDE6gQ=;
        b=RTCry2uEnJf3RnYi048V1AACEOoeINBihN3daGEThrK7Bq+36P6NP1q9dkpULWbie8
         uQ+5BgrxGjr7TFybutkeCUNROz8jAAU2iJAYvbAeJat1n3Y84fIlGB5JO8bQN2fILctV
         weQomRf25JCSNirmMlrZaZXWqMY+Ndlv4D7ywqjsk4uGOFl2jRWEjPrDLVe+qEUwtVb7
         gHIGhoXDOIjAZBJu0GAc9dXoeWWsZa95TZ3WNZxAeeqOtwj4ggXyBUQA91tbJh7MSABN
         4Q8h5m17gFc6yi4pAJjEumavn5466GH9ZVOjZe9MX8KInbActnX91Mc0xDbj3tPgLqIk
         M2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680138956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TihRUSuIbcyCr0lFNEjhUbfKbaamQ0uPf3hyuIDE6gQ=;
        b=a97sSIxFPhaBR4gUofMdtd0njRI9NNvGYc0hJree1Mpwtx+Gn12tm6SVTz4HqnK9tG
         ytGf9e8vmBfWpLBxsvW0Yr7+/9DfE8x4QqcJK4yyiZSJfxa4mRhw7iXP46vj06maKiyx
         iCFxFyMCSn+UA87kITzduEAPzEsvgxaptBQPZZgpjx5Pmak7yb0a/DrGmuSLDyNa/vqQ
         Sxqw9ZAZmeWqSa3N0Ly1AbfJM1Ei376djTL7uYXs5DWzUT/QIbctv7AdU5tsFMPuUC5S
         RWZO6KYYfpewE/wKWYsn/KbeVr4XHP/7VDljvPHUf+6P+XyQTdC92+Q4S3R56CNPWhO6
         pd/w==
X-Gm-Message-State: AAQBX9dCnhsDQhgfBQ0gMOub4YCto9HApE82OPBoKPCaDpiRm6evN33j
        89OAhqtfIauuR2USCUM/IAc=
X-Google-Smtp-Source: AKy350bTyshcbmCc+pIoeONIBpErKFE3Gxut0UYm4dqDCX6T8TbmlSk/RhFbqlgU82sSChm+gMnTgQ==
X-Received: by 2002:a17:903:7c3:b0:19c:b4e3:c65b with SMTP id ko3-20020a17090307c300b0019cb4e3c65bmr16884174plb.8.1680138956389;
        Wed, 29 Mar 2023 18:15:56 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001a1a9a5e53fsm6979478plr.136.2023.03.29.18.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 18:15:55 -0700 (PDT)
Date:   Wed, 29 Mar 2023 18:15:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230330011554.GD1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cbfaedb652dad85f4020a2dcd74ac4abb5c14ac5.1678643052.git.isaku.yamahata@intel.com>
 <b3198a621a39d4c277ddf540e7a492953dc3637d.camel@intel.com>
 <20230325011200.GB214881@ls.amr.corp.intel.com>
 <a10d63840b02c4bbe1c027e5f230e4799f87ddda.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a10d63840b02c4bbe1c027e5f230e4799f87ddda.camel@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 09:54:40AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff -u b/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > --- b/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -347,6 +347,25 @@
> >  	return 0;
> >  }
> >  
> > +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	/* TDX private GPA is always WB. */
> > +	if (!(gfn & kvm_gfn_shared_mask(vcpu->kvm))) {
> 
> Are you still passing a "raw" GFN?  Could you explain why you choose this way?
> 
> > +		/* MMIO is only for shared GPA. */
> > +		WARN_ON_ONCE(is_mmio);
> > +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> 
> I guess it's better to include VMX_EPT_IPAT_BIT bit.

On second thought, there is no need to check it.  We can simply drop this check.

u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
{
	if (is_mmio)
		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;

	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

	/* TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback. */
	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
}

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
