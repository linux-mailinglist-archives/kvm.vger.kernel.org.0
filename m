Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5936A645D
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjCAApn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAApm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:45:42 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29658CA0D;
        Tue, 28 Feb 2023 16:45:42 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i5so10629817pla.2;
        Tue, 28 Feb 2023 16:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677631541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=itotDAvkNSqM9L6NfCXeS0yg6PSQMLST22vQZzFDif8=;
        b=lw1dGrPyQAuOM7WYvldcWIdqS7WqRmyMI3mZJmRJnyTCCeLgT4VZWAgnOjWcFzkY22
         mcrG3JSXzJwiXZqPortCdWih8SInbzGtw4QsmqpdG82ryQiTMzMgxdYunmf47qmwsXaR
         F1vgqobY4YnM2Hx/r9rLsi/IQanmSobRAJvYhER4VR0a3XwSMSSDzBIXjeRW57pmW4g7
         l6+dsC7Ita8d60HGJTdexpxC62xmfD+1OSARc1CtuPWlfrQOGj9PHtQcpWTfmVzO6rr+
         F+3XZawkxmOYRbquMLZ+2QHe4yk03wjHLzX2RuH0OJTxvX92Tv8Mq59Y8UZ2CWdD1iuk
         bGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677631541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itotDAvkNSqM9L6NfCXeS0yg6PSQMLST22vQZzFDif8=;
        b=Ta9447D8lgSlbkj15wPQbMDiQ+W3DkzCaP2847TsBol6k5SfgB3yDKC4rV9foJUyio
         Kdl9/bZqbrKGTRrkJ17uQyNzPYpLr2A8YZJaRvBBZFZesg2MGfMtvYdUgIut7Mch6Te4
         mp+B6u1czUBbIIMKYNehdxGB3VQU3a0A/iRjqNG9VSyt21Iut8EOWmX2YFLwfF6qTg71
         VsQvesbMT6rFDJzPL7R9SjVDR0vRpxHFL2DAtkvNr77x0YsXGOiYJTwUkKkRyw0mFTyP
         PPvGo4o7KLC4vxk07lpqbs/YXd0m34nSfPXD0P9muLzctX44wLC9mPb5Mt24QxO2oGop
         Klgw==
X-Gm-Message-State: AO0yUKW9KCDtaK2tM7KOScJdpu9S24NtR84pVEv5HH6rvR1sT51TOlL4
        VTL68T9B3S/7HGo2iJSTrOk=
X-Google-Smtp-Source: AK7set9moT28arC5PM2dQIIGj9okq904KeUfssdOuX2R66iu3dw432nYWaYAoO2US+d89vSfS/pbjg==
X-Received: by 2002:a17:902:d504:b0:19e:2c25:d65e with SMTP id b4-20020a170902d50400b0019e2c25d65emr4920946plg.42.1677631541524;
        Tue, 28 Feb 2023 16:45:41 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id o19-20020a170902779300b0019cba9d77desm7052408pll.258.2023.02.28.16.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 16:45:40 -0800 (PST)
Date:   Tue, 28 Feb 2023 16:45:39 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v12 000/106] KVM TDX basic feature support
Message-ID: <20230301004539.GC3852341@ls.amr.corp.intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
 <7ec69b6b-540c-95d1-079d-8527fabd440b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ec69b6b-540c-95d1-079d-8527fabd440b@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 04:03:12PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 2/27/2023 4:21 PM, isaku.yamahata@intel.com wrote:
> > KVM TDX basic feature support
> > 
> > Hello.  This is v12 the patch series vof KVM TDX support.  This is based on
> > v6.2-rc7 + the following patch series.
> > 
> > Related patch series This patch is based on:
> > - fd-based approach for supporing KVM v10 and
> >    https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
> >    git@github.com:sean-jc/linux.git  x86/upm_base_support
> > - TDX host kernel support v9
> >    https://lore.kernel.org/lkml/e1c717b36033caf8de9d7a448e06eff88ed0c9ae.camel@intel.com/T/#m2562c7f18eabae171793ed7ea81b3544d7af09c4
> 
> 
>  9fdabaaf0346 KVM: TDX: Make TDX VM type supported
>  fa6b8135913c KVM: x86: Introduce vm_type to differentiate default VMs from
> confidential VMs
>  6dbc1fdfb61f KVM: TDX: Add placeholders for TDX VM/vcpu structure
>  64a9c956f265 KVM: TDX: Initialize the TDX module when loading the KVM intel
> kernel module
>  bacb6554fcf5 KVM: x86/vmx: Refactor KVM VMX module init/exit functions
>  b17eee6a7d53 KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
>  5a8b8d63a2e8 x86/mtrr: Mask out keyid bits from variable mtrr mask register
>  29017e2c04cc KVM: arm64: Mark kvm_arm_init() and its unique descendants as
> __init
> 
> 
> I find above 8 patches not included in this patch series after TDX host
> kernel support series. Some of them were included in v11 before, and I think
> they are important to make the patch series intact. What's the reason for
> not including them?

Thanks for pointing it out. My bad. I wrongly specified the start of patch
series.  Those should be included.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
