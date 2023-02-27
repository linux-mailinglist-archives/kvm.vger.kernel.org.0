Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB386A4D8E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjB0Vux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjB0Vuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:50:52 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963A425949;
        Mon, 27 Feb 2023 13:50:51 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so7062494pjg.4;
        Mon, 27 Feb 2023 13:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=meEVIRiCgVJpcli9FyE5YVGKtU2twkGrW5a1EbqqYn0=;
        b=e2sdZDOj0QUOWbQlDHQ5KEZIl1IkE3CF2hipxrH+jVJaBxiTkFVj/Pa0HpSXwoBWKT
         z9UY2UE37bcEa6gv469IjHEUowZP3vkKcVME4VQ9HPpwrlJ/mR1G5Qxg3J5/BvFI6iuv
         7fCQ/FP0PQO85x0+I/8nleR0Ajz4u9GRWvbgiYS0pYxH4sxZqrDfV8y7K64UB0DQbVQg
         qAkzbJEOARbnH6fipluQwnwf3jzb9D9t3w1ZX4yZs3zpIMAnQdvgOaXmapuxYQkL/cDd
         pCtVCpB09rTf+CfOtjZ1nmlO6EstkDtpXpKE31foAn93QTtj1rtutv05+8ODOCqxp8iq
         FFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meEVIRiCgVJpcli9FyE5YVGKtU2twkGrW5a1EbqqYn0=;
        b=voOokk+tjOw2K64J1PhjN7TYWBqFTILn9l0djUAUCG+i8BBF1gY/xdr1ouOMrNyPM3
         esGVJ/lIiIcdDJv+4/mlD2wWf7V/T3wfkeB0u5B5AH13YPMTQU5q1aaNwZblhtLK4r8n
         58+TU++Z6+DV/Ki/SH0tgFK1bdMTNUiGciAaV6+0nyjcMdoH3ax5Jg/OBALJYuqFkG6K
         rnuWCwZ80pVkILeax00uF9HscIPrtv473VgvzigwAO97E1+fj0W/BjojFqQHOg8xEvKt
         ZDD/8UTgbJ5giHB4xm1fR932J8YUgdSwYxzurjwBcQj7kB3UxFVqY0pVA7F+wR9VJIF7
         5pKw==
X-Gm-Message-State: AO0yUKUl3bCLgxf5JMvGv2lB3fpo9SDsrcojbyECYn4Z3+19OwPUm9Fo
        FI/5fQKEwrTgFzTNhAN4B/8=
X-Google-Smtp-Source: AK7set9cG8hBQgtwX8yF+5rT14a4x2ccHq0B0HWz6kdK5gw5gln6lxxx1IpGzN9zsS2cAAt3AjGQVQ==
X-Received: by 2002:a17:90b:1c8d:b0:233:eba7:10c0 with SMTP id oo13-20020a17090b1c8d00b00233eba710c0mr747597pjb.1.1677534650994;
        Mon, 27 Feb 2023 13:50:50 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a9dc200b0023493354f37sm6737691pjv.26.2023.02.27.13.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:50:50 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:50:48 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kai.huang@intel.com
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20230227215048.GK4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
 <20230125112434.0000512a@gmail.com>
 <Y9Fj/vgPEzfU1eof@google.com>
 <20230127233513.0000367c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230127233513.0000367c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:36:52PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Wed, 25 Jan 2023 17:22:08 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Wed, Jan 25, 2023, Zhi Wang wrote:
> > > On Thu, 12 Jan 2023 08:31:38 -0800
> > > isaku.yamahata@intel.com wrote:
> > > 
> > > This refactor patch is quite hacky.
> > > 
> > > Why not change the purpose of vcpu->arch.mmu_shadow_page.gfp_zero and let the
> > > callers respect that the initial value of spte can be configurable? It will be
> > > generic and not TDX-specific, then kvm_init_shadow_page() is not required,
> > > mmu_topup_shadow_page_cache() can be left un-touched as the refactor can cover
> > > other architectures.
> > > 
> > > 1) Let it store the expected nonpresent value and rename it to nonpresent_spte.
> > 
> > 
> > I agree that handling this in the common code would be cleaner, but repurposing
> > gfp_zero gets kludgy because it would require a magic value to say "don't initialize
> > the data", e.g. x86's mmu_shadowed_info_cache isn't pre-filled.
> > 
> > And supporting a custom 64-bit init value for kmem_cache-backed caches would require
> > restricting such caches to be a multiple of 8 bytes in size.
> > 
> > How about this?  Lightly tested.
> > 
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Wed, 25 Jan 2023 16:55:01 +0000
> > Subject: [PATCH] KVM: Allow page-sized MMU caches to be initialized with
> >  custom 64-bit values
> >
> 
> It looks good enough so far although it only supports 64bit init value. But
> it can be extended in the future. 
> 
> Just want to make sure people are thinking the same:
> 
> 1) Keep the changes of SHADOW_NONPRESENT_VALUE and REMOVED_SPTE in TDX patch.
> init_value stays as a generic feature in the kvm mmu cache layer. It is *not*
> going to replace SHADOW_NONPRESENT_VALUE.
> 
> 2) TDX kvm_x86_vcpu_create sets the SHADOW_NONPRESENT value into init_value.
> 
> 3) mmu cache topping up function initializes the page according to init_value
> with Sean's patch. 

The patch worked for me. Included into v12 patch series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
