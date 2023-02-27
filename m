Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803886A4DAF
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjB0WED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0WEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:04:02 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF3725971;
        Mon, 27 Feb 2023 14:04:01 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y11so4200335plg.1;
        Mon, 27 Feb 2023 14:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9Vy9YJMeTGktqaspKST4Ezg7ndZTW3Q++vqGgwh1RD0=;
        b=I1zZhyEbP8qvizC5YcfEhNqcyWvjJjcVBXB9UWIFTFPct4RRPqLSlnJrWq94oxP0lK
         qrQYfjqQ2e+MkPlXHntfC9o7L3bQIRcvp7O6BAqcltqUJ2uLA27qv5Nd/c9Ai+1xZ8z/
         5HndUYqrqZuPtkCu2VQ6q3XWEy2Xaa4Epio3CuoNUrxoGwzQi89hvg317Fy6zezbdwEr
         p2wUwTR7eonWBZqNP3cwUauuzBLHB/fgFwxkVnM8YfoD2QwJQ3pZUGcyUdCeKv/tvhTC
         +Rf3ZAj+BRUJ1ttuNCLG9xPZJXPSWgPcRetoeGMRkek+T4pHNet8FxTvuzTRbuld0nQh
         6CnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Vy9YJMeTGktqaspKST4Ezg7ndZTW3Q++vqGgwh1RD0=;
        b=k/nHsGFR2ClHCCTr6gHMW/52QjYzf05GYqSPZXrkbi386bb1M3Gn76Ib5sdzIsYBES
         oPsCW/ct/xUteyzMmeFNYXqEqI6oWHG86VD02KlOYSwPjZK0nflf4lW5Ri1M3jjTDBjG
         KA4zyqernPl/mUW3d6SlmeTbyP+zzevIHv2KsyBBYvW7mbdbdiSMUpGSRrBI93vFrurZ
         SwWQDFqhanHXmaLMkJHnGv1TE7Dzeq/awyHVb9pNnY1HPfr2qEK2B7ypqA3LdIa7X8dc
         sx9wrgb/X2wZo7E60us5QYsRvh2aGn0K3MjJiy5rE8WHYEbjxTcFdNZZBOcMzZCtPjTI
         AftA==
X-Gm-Message-State: AO0yUKWLrgCK3xgh8+WqX4MjQZjR70h00vNVE2ljhIyDBaHEsH7tJFaT
        l41S4ylSe9V/+zvWYzEIWa4=
X-Google-Smtp-Source: AK7set+on4n9zpMFpmcdKTDU+LtbO/ENFrbQfkqaCPp+jRJfgwyO6NwYX1osk6gkqpETRe6Q8r4pLw==
X-Received: by 2002:a17:902:e844:b0:19a:b033:2bac with SMTP id t4-20020a170902e84400b0019ab0332bacmr319318plg.46.1677535440842;
        Mon, 27 Feb 2023 14:04:00 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b0019cb6222691sm5074415plb.133.2023.02.27.14.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 14:04:00 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:03:58 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 055/113] KVM: x86/VMX: introduce vmx tlb_remote_flush
 and tlb_remote_flush_with_range
Message-ID: <20230227220358.GQ4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <d69b281c23131254ae6fdea67e384ef931dbba8e.1673539699.git.isaku.yamahata@intel.com>
 <d98561f16056d919626a46f0d078b774e2d56445.camel@intel.com>
 <Y8bSpdplnlRus3lx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8bSpdplnlRus3lx@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 04:53:57PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Jan 17, 2023, Huang, Kai wrote:
> > On Thu, 2023-01-12 at 08:32 -0800, isaku.yamahata@intel.com wrote:
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -244,7 +244,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
> > >  {
> > >  	int ret = -ENOTSUPP;
> > >  
> > > -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> > > +	if (range && kvm_available_flush_tlb_with_range())
> > >  		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> > 
> > Again, IMHO this code change doesn't make code any clearer.  With the new code,
> > I need to go into the kvm_available_flush_tlb_with_range() to see what's going
> > on, but with the old code I don't.
> 
> Agreed.  Though I think this patch as a whole can be replaced with a more
> straightforward solution.
> 
> hv_remote_flush_tlb() is used when KVM is running as a Hyper-V guest, whereas
> TDX requires running KVM on bare metal.  KVM should simply disallow TDX when a
> hypervisor is detected, then there's no need for vmx_tlb_remote_flush_with_range().

Ok, I dropped this patch and add the check into hardware_setup().  If hyper-v
is enabled, disable tdx.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
