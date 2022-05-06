Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7151151E13C
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 23:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376497AbiEFVjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444570AbiEFVjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:39:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F1290;
        Fri,  6 May 2022 14:35:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so7937216pjf.0;
        Fri, 06 May 2022 14:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i4ODuIClhs3mPszvinEDNPwzFTB2SCM7aKWWSn8J0uI=;
        b=ZobUQTJx+NEoOz7HvidPGdMS7pGKQYEvaMWHSkM0LrrT6xvFzsqRlO8aabdUfk5mzA
         WAA2gQ7JSMyXLNUMRob2kQl5ERwLxOJ2TkuCeceApSb8CPToTX5+rYaOc+1tcw5gg1Br
         7SVE3oSloMmZlo6LHAFw4xmpUoIo3tI/ITUkxK5fr1rV84MGytDKKoGyceW6oPKJpYzu
         /roz5hcWkLX7E2Wm1fgGGypKwUltKCTWHToCeXoq5qEMdzN1UN5eWqvyC1KKII/boOsN
         9XxfX8biWIIfNEmkVv2/GQ0CM3ODhwDpG3bBlExPQabUZdRprNM2RcKRAcEsCwuNKBdJ
         vnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i4ODuIClhs3mPszvinEDNPwzFTB2SCM7aKWWSn8J0uI=;
        b=1CokWBJ4/UWZYRM7o7AbkoYHJqqb3kOQ/yhizM3BYvJuYi2Z/yt8XvkAkgEJovZZa/
         MRtpVCzn9MWwc61abQ5nScsX64bvrkg2H1KQESu60/e451xYexv45+/365rMYraKrJ8j
         rcknpiEEm01PddEpH+6fq4tUUxmN8fdUT6v9vCgTkhuTEohO+MVveUE6Np98g5XNz8MG
         shCRg91GTqls8r5lHcY/GuZFPPUrlPAXziedYxzleDECdrrwYUqlW0jkyEUcsMYK6aAi
         eIaVwlBw9XVIf3gwdReQwNBz6Aphh78cdNVy0HMYJZ6DNkpfqopFcu4lbG+IHMXV6LvM
         1F9w==
X-Gm-Message-State: AOAM533yzY4HsDvfPFULcwUmW34XgfU1ryVfetLJbcElxKWcrUGqmg3O
        KkAWXQLbnzF5r5qMfvh8ODliwRjWlec=
X-Google-Smtp-Source: ABdhPJxfE2Zwmmn+Pr9mn2jUdfULvWEfYj/0IErCyVgFBWuR1SqIzLe8Zj3cUVEiQ+lBKOLIVVylRQ==
X-Received: by 2002:a17:90a:9ea:b0:1dc:1c48:eda with SMTP id 97-20020a17090a09ea00b001dc1c480edamr14473942pjo.38.1651872919617;
        Fri, 06 May 2022 14:35:19 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id n3-20020a056a0007c300b0050e0dadb28dsm3846324pfu.205.2022.05.06.14.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 14:35:19 -0700 (PDT)
Date:   Fri, 6 May 2022 14:35:18 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 017/104] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20220506213518.GB2145958@private.email.ne.jp>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <b4cfd2e1b4daf91899a95ab3e2a4e2ea1d25773c.1651774250.git.isaku.yamahata@intel.com>
 <16632b27-7a0d-887b-c86e-9e1673840f55@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16632b27-7a0d-887b-c86e-9e1673840f55@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 04:56:52PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> > index 8df7a16f7685..b4fc8182e1cf 100644
> > --- a/arch/x86/virt/vmx/tdx/seamcall.S
> > +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> > @@ -50,3 +50,4 @@ SYM_FUNC_START(__seamcall)
> >   	FRAME_END
> >   	ret
> >   SYM_FUNC_END(__seamcall)
> > +EXPORT_SYMBOL_GPL(__seamcall)
> 
> It cannot compile, we need
> 
> #include <asm/export.h>

Thanks, will fix it.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
