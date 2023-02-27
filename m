Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C386A4DA3
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjB0V6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjB0V6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:58:20 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA49F7281;
        Mon, 27 Feb 2023 13:58:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so177292pjn.1;
        Mon, 27 Feb 2023 13:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFgPcL8KVOlQG1KgcGofHxwMq+phFfsr6crnqyLQQyA=;
        b=g8Re+oMCNJ/TgBGdp4BiEDryk3mjGerCWemdRaEoiJOvYS/7tTMMjKaNmt925pHZGX
         zHQvPq3MC9TFeHhfHtCvemiVNG4K18uJTdW1SxiFkYhHf0uknjbAEzFDI8pRJML8muM+
         dWNCzX8NK4bhsHCyXHrZbYWrfXz/iXNYaQykMQi6hYmYe+b9ftph4/NEyfGTt3F4HLNH
         pljkPD+Oo7hh5G7hf9GDqTC093F8KG+l1BaLObNIdJOfeZmG31s2JCFhtssATRdq/ZCD
         mS1jYuixxjxdUiwgIGPIjtSxI6uq4H8XRKxamZwEqJt+okxkQ58UzgF055Nhe6WJmwk6
         TirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFgPcL8KVOlQG1KgcGofHxwMq+phFfsr6crnqyLQQyA=;
        b=f960oaidUS4Jy3u8+WmbAKH1Yekf/6TP/Qxcaj9Dp6JDlKTBhkv/wC1w0T/++f7l6o
         dc0re45z/Pd2A48t0veQfH8JqPZx/MCu6DkFeVyBS4q7TD0a0PVbwxV/0kzkCveQ7ycI
         s7krSsNbCf73LxrOdVpiXhku08eLK2YLaKXCwrtJVsP9Ps81doUMrd6fI8T6CCSkd/UF
         40mjfCWSIZRuaPO9OWjmR9GifkYap4/L9bcYpYzEL6bjqBGO7sCOHXVJlWhuQ1vv8rCA
         LgVW+26Z17mPSmTSpN7MNyUKo3bhT7qpUMYGvK+4lUbgz5i/R6dauEA0Z8Tql6BWppMy
         iduA==
X-Gm-Message-State: AO0yUKXKBWI6HWTO2TXnIgWFhHAZ93DRYJv0A0M+3Gh6bfpSBFW5ASBd
        IWCl37zP2kNhsOPNVRl6d4CnISZ/HlI=
X-Google-Smtp-Source: AK7set+5Omb4ClWPydT4jEk78/I+pwk3G4znG+tewbGh3pNAOo0tskbURqtW8DovI2zb92q2jXMcQA==
X-Received: by 2002:a17:902:c1d2:b0:19c:e484:b45 with SMTP id c18-20020a170902c1d200b0019ce4840b45mr417927plc.27.1677535093066;
        Mon, 27 Feb 2023 13:58:13 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id b21-20020a170902d31500b0019a8e559345sm5042507plc.167.2023.02.27.13.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:58:12 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:58:10 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 033/113] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <20230227215810.GN4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <e3a95546186bc010c11da4152b8980a86702b6a9.1673539699.git.isaku.yamahata@intel.com>
 <886ee34123be83bbe565c5d02e5b0d4c000ef5a6.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <886ee34123be83bbe565c5d02e5b0d4c000ef5a6.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 11:16:04AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 6111e3e9266d..dffacb7eb15a 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -19,6 +19,14 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
> >  {
> >  	struct workqueue_struct *wq;
> >  
> > +	/*
> > +	 * TDs require mmio_caching to clear suppress_ve bit of SPTE for GPA
> > +	 * of MMIO so that TD can convert #VE triggered by MMIO into
> > +	 * TDG.VP.VMCALL<MMIO>.
> > +	 */
> > +	if (kvm->arch.vm_type == KVM_X86_TDX_VM && !enable_mmio_caching)
> > +		return -EOPNOTSUPP;
> 
> SEV-ES does the check in hardware_setup:
> 
> void __init sev_hardware_setup(void)
> {
> 	...
> 	/*
>          * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
>          * instruction stream, i.e. can't emulate in response to a #NPF and
>          * instead relies on #NPF(RSVD) being reflected into the guest as #VC
>          * (the guest can then do a #VMGEXIT to request MMIO emulation).
>          */
>         if (!enable_mmio_caching)
>                 goto out;
> 
> 	...
> }
> 
> TDX should be done in the same way.
> 
> And IMO this chunk really doesn't belong to this patch -- I interpret this patch
> as a "infrastructure patch to track shadow MMIO value on per-VM basis" (which
> even should have no functional change IMHO), but this chunk is clearly doing
> more than that.

It's cleaner to do in hardware_setup().  So I moved the logic into
hardware_setup() and an independent patch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
