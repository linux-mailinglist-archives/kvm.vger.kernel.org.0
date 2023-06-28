Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24E6740720
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjF1ATL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF1ATK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:19:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B426AF;
        Tue, 27 Jun 2023 17:19:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-262d9e75438so2838748a91.2;
        Tue, 27 Jun 2023 17:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911549; x=1690503549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LRW+WfLeR5s36t4pmpW2ZzxI34nEruKTcCkQKc8zt1Q=;
        b=lXZCyJeD4x/gEW6A/gLJ9H8o8uBtBEpQLgGWLAuapamP8apREigOJbO980T40piv3j
         WCpnhd4zm3WHUySGDTZmZQbs4XwQWoG3Ze6TXItSpBeAZ4nOMp9mMoj2r61WE9xiEhCY
         Yzp2DggX6Uk1j8W7foRtc7JTrQFxh7/EVv1sLjpAJJtEJz9Rm1ccVAqKvzXaaARLDrOW
         mXFLwWLKQ2EkuGYeyb5N0lmHoMxg6ZguIFT7m/PLtvfuKqbxOEhVYWEGul9CAGrqswyB
         whrDRsXYJUz8Yka8EPN9pSotmXOZpWThpPGlrrBbIy46M2JJ0L/9cgX5RWWe7+uchlb8
         GfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911549; x=1690503549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRW+WfLeR5s36t4pmpW2ZzxI34nEruKTcCkQKc8zt1Q=;
        b=eagH8ACtRWPPh++6I1K0k3csINr6vVWgLgMJY1Oda3qn4nFoUoTjJ5HQaPi6OLgxIE
         0XHnTppoQE0+arfyS2sNF2RMy1YHG2yrUxWsxXY7OIitL63cwrsD9xLAldHefR7eRZ7N
         EvyrubpD+fJRNHW4LhrSf3EWPRFYvzB6UZhmUszqAYyIX/bBx0mp9gEgUCtjJ17MR+PK
         Eh8yC3Az1a1zbnqVCkvbb0oC2XInqetXbNZaGC1tyH3fLuD2Fz36/GBwnTUBoW9Yr91L
         Pqta8O+vZCFo5d6UIQubfiH8FHgEyynYqnWher+Ma2BHwYRuA2JqgNIhrw10vwnxepe5
         T2RA==
X-Gm-Message-State: AC+VfDw1s0QHXRnLADF3DPSXEvCxcLTdDr6eic6CgOorZuNXLi6yaew0
        jUHYh6nFCa0oc0GcLsmaNU13seRV7QKXtA==
X-Google-Smtp-Source: ACHHUZ543SbHsjKdnX0Px9SlC2128aPramo/lQSbMVvPHEubWaQs0pY8hUL1Js96oetOeWXp3foqAQ==
X-Received: by 2002:a17:90a:346:b0:262:ad7b:235b with SMTP id 6-20020a17090a034600b00262ad7b235bmr12898198pjf.34.1687911548511;
        Tue, 27 Jun 2023 17:19:08 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id lx13-20020a17090b4b0d00b00262def4ad92sm5062690pjb.41.2023.06.27.17.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:19:07 -0700 (PDT)
Date:   Tue, 27 Jun 2023 17:19:06 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230628001906.GA3629671@ls.amr.corp.intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
 <20230627094856.6udzuhzhygc4nzit@box.shutemov.name>
 <102e45dd81589625ed064a742508597e0d118375.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <102e45dd81589625ed064a742508597e0d118375.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 10:28:20AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2023-06-27 at 12:48 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Tue, Jun 27, 2023 at 02:12:35AM +1200, Kai Huang wrote:
> > > +/*
> > > + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> > > + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> > > + * leaf function return code and the additional output respectively if
> > > + * not NULL.
> > > + */
> > > +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> > > +				    u64 *seamcall_ret,
> > > +				    struct tdx_module_output *out)
> > > +{
> > > +	u64 sret;
> > > +	int cpu;
> > > +
> > > +	/* Need a stable CPU id for printing error message */
> > > +	cpu = get_cpu();
> > > +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> > > +	put_cpu();
> > > +
> > > +	/* Save SEAMCALL return code if the caller wants it */
> > > +	if (seamcall_ret)
> > > +		*seamcall_ret = sret;
> > > +
> > > +	switch (sret) {
> > > +	case 0:
> > > +		/* SEAMCALL was successful */
> > > +		return 0;
> > > +	case TDX_SEAMCALL_VMFAILINVALID:
> > > +		pr_err_once("module is not loaded.\n");
> > > +		return -ENODEV;
> > > +	default:
> > > +		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
> > > +				cpu, fn, sret);
> > > +		if (out)
> > > +			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> > > +					out->rcx, out->rdx, out->r8,
> > > +					out->r9, out->r10, out->r11);
> > 
> > This look excessively noisy.
> > 
> > Don't we have SEAMCALL leafs that can fail in normal situation? Like
> > TDX_OPERAND_BUSY error code that indicate that operation likely will
> > succeed on retry.
> 
> For TDX module initialization TDX_OPERAND_BUSY cannot happen.  KVM may have
> legal cases that BUSY can happen, e.g., KVM's TDP MMU supports handling faults
> concurrently on different cpus, but that is still under discussion.  Also KVM
> tends to use __seamcall() directly:
> 
> https://lore.kernel.org/lkml/3c2c142e14a04a833b47f77faecaa91899b472cd.1678643052.git.isaku.yamahata@intel.com/
> 
> I guess KVM doesn't want to print message in all cases as you said, but for
> module initialization is fine.  Those error messages are useful in case
> something goes wrong, and printing them in seamcall() helps to reduce the code
> to print in all callers.

That's right.  KVM wants to do its own error handling and error messaging.  Its
requirement is different from TDX module initialization. I didn't see much
benefit to unify the function.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
