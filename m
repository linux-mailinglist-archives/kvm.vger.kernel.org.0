Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6577C4D1FE5
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348482AbiCHSSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiCHSSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:18:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AB647C
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:17:35 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso2945221pjb.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cI7zgl192Zgl3FFh3U4mmGv/6PXl3YZNSM+T7Oyiol8=;
        b=Pv+w0OPdgjrA6X05d91ctImuGJjqz6cgOVsS+StY2xCxBllaQ1oKJPpCgl07DTCfim
         Qj4WFtlGsAAVKez+oNnuYOqWXssbmZb2FpVgOw1Cqu91SrXN+imKKs74YVJDNYV9qrND
         xPHdeHZfDMLpcHtpdlcvXXoYhwFNAu/8H2Hol8X6YsOGHcbZj1qtYGjU9suZQGFkJFqV
         yAZXLDesfbeIc1afkcghHlcou2HFoasrcMAIxPrQrs2q1YY5JCGhKN0RHI/ZEjvZPJJd
         IZQ/63nh2SluOZKNn4E4qMWN91ioO6WYa/c3Vmr9avBgws1nNe4qAqHs4kmp8CAXQGgu
         z/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cI7zgl192Zgl3FFh3U4mmGv/6PXl3YZNSM+T7Oyiol8=;
        b=C0hd8f7xkQ57GK4oJyxikwNKYffcncpdursu3I/wh0u3fsY111rdmcH36CCrU/Yh+h
         xya57FQbaEUbWyniJN1U88bcbcQZyspaiC3TUvfkPVXy8Ys3g6fh9ltCF4jsjykeTLwn
         HzgnkI4IPSkgAQZLnOhM6OSt8COdiyI/OKFxS11BD/Jo27CEBGZshrnsq3wF3yuyogFI
         cmX784eWYwDP+526P3GYXczWLzRdEW5c6cBDKgyPQgm0C0eGvcWkZCc7+bwKaWm1WWBY
         nyBdG209fe46xbMl4Od96Zgapj18s+dr7xwDOfP8Pyg5V2toGRckvarJ408e9TLGOXRD
         +a4g==
X-Gm-Message-State: AOAM530p31l3c2ehTR3R7HeC6hpPmsr5PCx4R/Zw9eu/NP+qTWvmFONv
        PtZuvY/fnmBBN9Vohq9sVtgO4doifM4btQ==
X-Google-Smtp-Source: ABdhPJz+wgCSAnSzicl3Luf93x8udYKc3NWJOTwE6AbtuwPSPxPWWSntgtXDPstaNRnyUE+WgFBQpQ==
X-Received: by 2002:a17:903:3094:b0:151:f5a7:ad72 with SMTP id u20-20020a170903309400b00151f5a7ad72mr8136332plc.135.1646763454896;
        Tue, 08 Mar 2022 10:17:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k23-20020aa790d7000000b004f6c8b7c13bsm14825043pfk.132.2022.03.08.10.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 10:17:34 -0800 (PST)
Date:   Tue, 8 Mar 2022 18:17:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 11/25] KVM: x86/mmu: remove
 kvm_calc_shadow_root_page_role_common
Message-ID: <Yiedukl6MC8OAAog@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-12-pbonzini@redhat.com>
 <YieW+PZarPdsSnO7@google.com>
 <f9e7903a-72b6-5bd7-4795-6c568b98f09d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e7903a-72b6-5bd7-4795-6c568b98f09d@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Paolo Bonzini wrote:
> On 3/8/22 18:48, Sean Christopherson wrote:
> > On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> > > kvm_calc_shadow_root_page_role_common is the same as
> > > kvm_calc_cpu_mode except for the level, which is overwritten
> > > afterwards in kvm_calc_shadow_mmu_root_page_role
> > > and kvm_calc_shadow_npt_root_page_role.
> > > 
> > > role.base.direct is already set correctly for the CPU mode,
> > > and CR0.PG=1 is required for VMRUN so it will also be
> > > correct for nested NPT.
> > 
> > Bzzzt, this is wrong, the nested NPT MMU is indirect but will be computed as direct.
> 
> CR0.PG=1 means it's *not* direct:
> 
> > +	role.base.direct = !____is_cr0_pg(regs);

Ha!  I was just cleverly making the case for checking ____is_cr0_pg() instead of
"direct" for computing the dependent flags, I swear...

On a serious note, can we add a WARN_ON_ONCE(role.base.direct)?  Not so much that
the WARN will be helpful, but to document the subtle dependency?  If the relevant
code goes away in the end, ignore this requrest.
