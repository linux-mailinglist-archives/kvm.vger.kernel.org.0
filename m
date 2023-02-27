Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7282E6A4D8B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjB0VsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjB0VsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:48:15 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5D322798;
        Mon, 27 Feb 2023 13:48:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q23so4455342pgt.7;
        Mon, 27 Feb 2023 13:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ErGexxN3zJKfa8w4LZol695vYh8JJqDay56LGf9Oqdo=;
        b=SDBg+t0SigbljRdSAsK27YboxtVT2Z8HGLY8Okh3Ki8Q5DPYqFklAOR1YTDbTZvcoT
         tlYKBEP5i+YkcpsBLkakOZrfoRTtTwxUDamXa2lqm85fLidsAGqhOip1zx6NHEq08TGR
         0fzvxlLZF04hr+uXcRIoIEEZYM8ENkUEh58EN44tVxrQ0/P1Rd72ZhmUR/hDpprQEmEW
         LJz/SreDu77LW4frUW1JJrkJkcJLjZHkQcZGI/gTficO81o9hLiT4waYB3rX4AOz8u9v
         9CtnpW1uq/fg97HYezs0Sznrt9b6SVidV7JEFm0vliJxksb8+1Y+198xmiXabPkbg1Ms
         GsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErGexxN3zJKfa8w4LZol695vYh8JJqDay56LGf9Oqdo=;
        b=L0xK8LfYw8cRBc4JjfrHzdAN+1LbJ+s7mWM1mI5/s5F703M3IfLVBCdleilfqNSN7a
         /ZKPQLnBO3r+r2dkzwAeolTQn5sZEYc1qDn2Sefz7wVs7pTMR7LoYYLtNTLclAYtpmlp
         aCO76qF+GVKoqrObtkGHoradHcoa5+9Gsly89Rpf8d+gVwCpcVZ4ljDzGXfO2lzIA9LM
         AMAnUx1R2GaK1G8USI++I8MY//f0qRbMoo6Pxwv826R3zV0PHwY8A/eSi8cu357AlWnE
         7NkpICfqH77yv82w81Iz4lhZKUs3Op/GWy0b+pt7uca4n1UvO0D8lbgSrZ2KUjj/bZBw
         uwIA==
X-Gm-Message-State: AO0yUKUL0EbZcq1YehbMfzl3ORxOVMI93KrBJT53m1Kf69oZWkmyj3Ho
        JWHFn4VuixSQ1DcTMpPlQF42pXqDTy8=
X-Google-Smtp-Source: AK7set/NtzCU1wlNr6Wi3FkCZ2h1FX+qS/srLMiB1wsXTGe5maB/JENjwZVz9VCppeLgLq4OASH7ow==
X-Received: by 2002:aa7:9805:0:b0:5aa:4df7:7eef with SMTP id e5-20020aa79805000000b005aa4df77eefmr440902pfl.6.1677534492023;
        Mon, 27 Feb 2023 13:48:12 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id q26-20020a63751a000000b00502e6c22c42sm4342866pgc.59.2023.02.27.13.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:48:11 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:48:09 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 021/113] KVM: TDX: Refuse to unplug the last cpu on
 the package
Message-ID: <20230227214809.GJ4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <ecf02459d319789aca1b9399ed8fda47c03812df.1673539699.git.isaku.yamahata@intel.com>
 <d95328039ba69346c30555def1991bddc385ddd4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d95328039ba69346c30555def1991bddc385ddd4.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 10:23:16AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > In order to reclaim TDX HKID, (i.e. when deleting guest TD), needs to call
> > TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have used TDX HKID, refuse
> > to offline the last online cpu. Add arch callback for cpu offline.
> 
> I think it is worth to talk about suspend staff, i.e. why we only refuse to
> offline the last cpu when there's active TD, but not choose to offline the last
> cpu when TDX is enabled in KVM.  People may not be able to understand
> immediately the reason behind this design.

Updated the comment.

> Btw, I certainly don't want to speak for Sean, but it seems this was suggested
> by Sean?  If so, add a 'Suggested-by' tag?

Added suggested-by.

> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > 
> 
> [snip]
> 
> > +
> > +int tdx_offline_cpu(void)
> > +{
> > +	int curr_cpu = smp_processor_id();
> > +	cpumask_var_t packages;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	if (!atomic_read(&nr_configured_hkid))
> > +		return 0;
> 
> As mentioned above, I think it also worth to add some comment here.  When people
> are trying to understand some code, I think mostly they are just going to look
> at the code itself, but won't use 'git blame' to dig out the entire changelog to
> understand some code.

Makes sense. Added a comment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
