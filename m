Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D1A62E59E
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiKQUKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiKQUKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:10:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E97EBD4;
        Thu, 17 Nov 2022 12:10:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k5so2614872pjo.5;
        Thu, 17 Nov 2022 12:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I6j1W3Ji+fdVPC6gf2n+swdKOz5mGcn5yydkS5FTGpA=;
        b=etd/G7iaKExY97a+7RFVEc/mtw7VNG9n+VHfEyE9IJatKO7FWet1pvhGQJaWzV91h9
         ZuCE+uPGyhFP5wP335ZGwfkf4ddZtUeTbalZZo6y9gg+VBjhfBHAKuN3MMO2U/A49Cnj
         ZnTIeHk2e65GQUxPOa1XGBlbWhbiwvNM/Q9LwNQ8MQ8Ktk2YzzgyHV2FBLQpZ9g7VFyU
         xSJnmW7s68ycW8hiKd14WZ5l37Jiiun6VKthVwDyFBWavZFcH/92ropyZaRgqNiSK1If
         SZgPkEDMKrxZCVxKSaVrNlJnp5zrNhxbIQQWTa9q1czULbL2xtqEX2Umi/BhVi4MFSSw
         Spnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6j1W3Ji+fdVPC6gf2n+swdKOz5mGcn5yydkS5FTGpA=;
        b=32hcePc+9tdOo6fB/NSP/D98nBmpacAW7YkDBF0N1jMIS6j0vEddq5d5LsNpOi3Npm
         kfOnOOWVwKav+Wgqg7E5k1KOBhc6lg2NzD2cKAZ4PJnfnaecmX/rSBam1yN9YD/V/J1y
         WHtZkSKyNeomxMGKiW7gpuj1uza2rRKSyfMMNLjj86KCQ/A7CQ7koyJXIGP5LwPYqrep
         5BQf8KmyVz55ikQNN4Ae/CCOx9yL7M12/MYGwwQhXLMc7OsSOiwN16JXDc0DJPRkcYTC
         l+oMI1u7CJ4/ZtqqGRPZ+qfBZJtEfZKos7ZV76Zr5G+MvfK74hJN2cr+dMyNLPqbUmt1
         HI7g==
X-Gm-Message-State: ANoB5pm3mDOHyEHBSRovRxR+ar8lSdVtyatT+SS162x8epibjHGFgDOz
        t/LWYv+CPfjLUJMyoM7SaCQ=
X-Google-Smtp-Source: AA0mqf5O1RehkPJLM2QkkzuuSpXswc1sc9uOH8KL8Ye5kzPbbbn0vg6BxXBK3syXAQmhi7n/KLV/3w==
X-Received: by 2002:a17:902:f111:b0:186:ee56:4a1e with SMTP id e17-20020a170902f11100b00186ee564a1emr4208717plb.167.1668715806451;
        Thu, 17 Nov 2022 12:10:06 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id r14-20020a65498e000000b00476f2b11c07sm1450318pgs.5.2022.11.17.12.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:10:05 -0800 (PST)
Date:   Thu, 17 Nov 2022 12:10:04 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v10 071/108] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
Message-ID: <20221117201004.GA2751024@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <238ab2d9a9d2ea71ecacb25203b91abbaf6fbcb4.1667110240.git.isaku.yamahata@intel.com>
 <8584a9c7-0ec1-db36-bb32-d508a091ea09@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8584a9c7-0ec1-db36-bb32-d508a091ea09@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 03:36:27PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 65541bfebb37..4d4b71c4cdb1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -440,6 +440,15 @@ void kvm_user_return_msr_init_cpu(void)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_user_return_msr_init_cpu);
> > +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> > +{
> > +	if (!msrs->registered) {
> > +		msrs->urn.on_user_return = kvm_on_user_return;
> > +		user_return_notifier_register(&msrs->urn);
> > +		msrs->registered = true;
> > +	}
> > +}
> > +
> >   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> >   {
> >   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> > @@ -455,15 +464,22 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> >   		return 1;
> >   	msrs->values[slot].curr = value;
> > -	if (!msrs->registered) {
> > -		msrs->urn.on_user_return = kvm_on_user_return;
> > -		user_return_notifier_register(&msrs->urn);
> > -		msrs->registered = true;
> > -	}
> > +	kvm_user_return_register_notifier(msrs);
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
> > +/* Update the cache, "curr", and register the notifier */
> > +void kvm_user_return_update_cache(unsigned int slot, u64 value)
> > +{
> > +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> > +
> > +	WARN_ON_ONCE(!msrs->initialized);
> > +	msrs->values[slot].curr = value;
> 
> If the value is the same as the cached one, can it just skip notifier
> registration?

We know tha the the user of the function (in the next patch) passes the
different value, the initial reset value in the return of TDH.VP.ENTER.  So
such check isn't added.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
