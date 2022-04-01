Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446034EE5CF
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 03:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbiDABxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 21:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiDABxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 21:53:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3A12571AF;
        Thu, 31 Mar 2022 18:51:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x2so1195129plm.7;
        Thu, 31 Mar 2022 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZYoSvb6p0GaeXDPQELvHBRkenVkA39eLEuirDVFeehA=;
        b=odp7QeR+amh5tY1+VtPwLjejVfDCLPZE6pLOu/7hf9AM3c5k06MY6KIt6N4BYuVyuw
         Eob6IjyMnyd06ar4Y0wR/XLNAk9jhW4juQnJjRa1P1jxqrfaqkL2eCCKILPKgSZ4/NxM
         2uyHIWcFHEpY/F1c8iIXv44HM3Y8j18LiIMnLALGOHY/gTew8+xneK6XsZTMFBBmptsb
         9JcS7P9HPDDP9//e1ZstGs62JBjJU8Vl4Hn9apViVkyHXvE1To/H9CpwtbHzIpqzwK5y
         r9zOQ2AuX7xTHTJFDlLEEn9wv7LRdJnHPZPdv8nSt1oDnXp6Fi86+X6JZTvQ7nWq6MxD
         04mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZYoSvb6p0GaeXDPQELvHBRkenVkA39eLEuirDVFeehA=;
        b=f9cYbIxTBxhJV9e6DL70VM8LYdOwCVKQP5Jz8m9ZntFW+CyXVx63M4VvFuI09XUDUm
         9IqKfSePL4Yi4+JBVQP5AfhSBt5EfKEia5gF2t+BuqB04Z4roBRS5ldyOo0IUh0C5B18
         yI9RYd5BXvSwqZtUdc1ZRxRz4y5G3CUSLxY64y9DY96BtseG47Kl9804GFZkhzGyzmFC
         H2S2Iziec4sRPNgi8NQ8f0JnOyzDRH8xanhV33K8Jcr9+ZzsGHDD1aDASq+TKrx/llK7
         /CeH4Hs5ze8dJcXZPG4rncL7DX7OzPLpLjdBIb+dgrn78s1rTzlVh3B+Z0Txmy7P6xE/
         PSeQ==
X-Gm-Message-State: AOAM533Er2Xc33gKv0Sf8eKqDpVw5KMz8yqH0JkDMgESLzASLmHHrHPc
        W0YkTMNdaiJFXbnqCj0WLjX1ggUZjSo=
X-Google-Smtp-Source: ABdhPJwSheKj8vhKz/bOcOxSoksiXtFZD09d8VgskzQfnfm2+Ay77WWjUocoUEjZhachDqMbzYjmSw==
X-Received: by 2002:a17:90b:17c3:b0:1c6:b0ff:abf with SMTP id me3-20020a17090b17c300b001c6b0ff0abfmr9091598pjb.24.1648777891876;
        Thu, 31 Mar 2022 18:51:31 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000cd000b004fadb6f0290sm816866pfv.11.2022.03.31.18.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 18:51:31 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:51:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 032/104] KVM: x86/mmu: introduce config for
 PRIVATE KVM MMU
Message-ID: <20220401015130.GE2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <770235e7fed04229b81c334e2477374374cea901.1646422845.git.isaku.yamahata@intel.com>
 <55fa888b31bae80bf72cbdbdf6f27401ea4ccc5c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <55fa888b31bae80bf72cbdbdf6f27401ea4ccc5c.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022 at 12:23:28AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To Keep the case of non TDX intact, introduce a new config option for
> > private KVM MMU support.  At the moment, this is synonym for
> > CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The new flag make it clear
> > that the config is only for x86 KVM MMU.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/Kconfig | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 2b1548da00eb..2db590845927 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -136,4 +136,8 @@ config KVM_MMU_AUDIT
> >  config KVM_EXTERNAL_WRITE_TRACKING
> >  	bool
> >  
> > +config KVM_MMU_PRIVATE
> > +	def_bool y
> > +	depends on INTEL_TDX_HOST && KVM_INTEL
> > +
> >  endif # VIRTUALIZATION
> 
> I am really not sure why need this.  Roughly looking at MMU related patches this
> new config option is hardly used.  You have many code changes related to
> handling private/shared but they are not under this config option.

I don't want to use CONFIG_INTEL_TDX_HOST in KVM MMU code.  I think the change
to KVM MMU should be a sort of independent from TDX.  But it seems failed based
on your feedback.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
