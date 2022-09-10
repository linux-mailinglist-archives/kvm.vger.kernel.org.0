Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546E95B43A9
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 03:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiIJBjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 21:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIJBjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 21:39:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCD5FD36;
        Fri,  9 Sep 2022 18:39:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x1so3341295plv.5;
        Fri, 09 Sep 2022 18:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=+HyY6MoZcN0FsKJ3qyqHucj5l+tGou55KVTzAQ3Bdi8=;
        b=oYfb1vg+Kct23PhbzI75hD7wq0paEq8bOjhP7a39L3EHazFeRyHJdcOXIAqxCEsMvA
         8PxFjgViFtOxjlQcHRC3NW7z3rO81TfLCVEbRJk/Kr55PCDZcjoPZkzC4OdpfkbXb7nj
         cQgkdRqQYPWte2dIA8jQUFYWrm/jHWOyrE4kJQexSc0WO2hlU8+11LwohMJNbWhY3Cur
         Vw6KdvjKfOwJPiUYfWJ5p+pOOdQc+zs23J0sodSQCKivoJ4+I0NSxBam9yHej9t/kbVh
         V6AYVCQrdoQUC15Tr58FdCocNJHPkNQf30U6Xxr0b9A1YVvdATGDJ7DaTrbvIVdZxQV6
         /1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+HyY6MoZcN0FsKJ3qyqHucj5l+tGou55KVTzAQ3Bdi8=;
        b=TOgJFjQ9iRZ4bMnsJQQ8IQNkjLnOCTVfAvyjIuzlAsf5YRpONMKdh4U9cuAQiOmvXu
         KFuPQvK9U1Wa5MKU1y1klMwmd2tPLhJw1dKzLLsOV2pbCdKb/m35HxjkBLMWHlwTjGe/
         aEA7BivTXFlpncTKwMh+Dkj2DGiqmvwHgSI9NVsIxxvC/KZ5pDxtNUolNo2/+vw4OY7t
         XU/oV4dE/6pZCA4Qw6iVxmK3FUVBRVMpX+peGO38ozD6GRhx6i0QQYCUUFwfA2aw/MIV
         xEi3eO3B085v6dljJh5pKqWPVtbpGNrGJnGlU4QfzVbaBxKUIFmIZR6q/19R8JiQBHF0
         h2Rg==
X-Gm-Message-State: ACgBeo2X/JiaxHCE83WV7xF0L75cfc18A2x5BCxpRFqgBYR3qVHx9hDZ
        HT4dgfHszxEG75P6+Rq2EkCd8VCjalNl3g==
X-Google-Smtp-Source: AA6agR6lRSG1wvLOOC+rgQ59lwfkWh29IBcT8P0r1RooVwxOiv+zbZOqCwoOHzL0TLU/D2WrTFA+2A==
X-Received: by 2002:a17:90a:1f49:b0:202:7a55:558f with SMTP id y9-20020a17090a1f4900b002027a55558fmr8501511pjy.108.1662773977401;
        Fri, 09 Sep 2022 18:39:37 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id n10-20020a65488a000000b0041a6638b357sm1149185pgs.72.2022.09.09.18.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:39:36 -0700 (PDT)
Date:   Fri, 9 Sep 2022 18:39:35 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        John Garry <john.garry@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Qi Liu <liuqi115@huawei.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 23/26] RFC: KVM: powerpc: Move processor compatibility
 check to hardware setup
Message-ID: <20220910013935.GA699006@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <b348201517333f52c570f359e0d94bc9d5afc4f2.1662679124.git.isaku.yamahata@intel.com>
 <ee18616b-e657-7c10-5224-d9b18dbb9ea7@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee18616b-e657-7c10-5224-d9b18dbb9ea7@csgroup.eu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 05:55:14AM +0000,
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> 
> 
> Le 09/09/2022 à 01:25, isaku.yamahata@intel.com a écrit :
> > [Vous ne recevez pas souvent de courriers de isaku.yamahata@intel.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Move processor compatibility check from kvm_arch_processor_compat() into
> > kvm_arch_hardware_setup().  The check does model name comparison with a
> > global variable, cur_cpu_spec.  There is no point to check it at run time
> > on all processors.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: Fabiano Rosas <farosas@linux.ibm.com>
> > ---
> >   arch/powerpc/kvm/powerpc.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> > index 7b56d6ccfdfb..7e3a6659f107 100644
> > --- a/arch/powerpc/kvm/powerpc.c
> > +++ b/arch/powerpc/kvm/powerpc.c
> > @@ -444,12 +444,21 @@ int kvm_arch_hardware_enable(void)
> > 
> >   int kvm_arch_hardware_setup(void *opaque)
> >   {
> > -       return 0;
> > +       /*
> > +        * kvmppc_core_check_processor_compat() checks the global variable.
> > +        * No point to check on all processors or at runtime.
> > +        * arch/powerpc/kvm/book3s.c: return 0
> > +        * arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
> > +        * arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
> > +        *                            strcmp(cur_cpu_spec->cpu_name, "e5500")
> > +        *                            strcmp(cur_cpu_spec->cpu_name, "e6500")
> > +        */
> 
> This explanation shouldn't be in the code. The content of other file may 
> change in the future, the files may be renamed or deleted, new files may 
> be added. And there is no added value with that comment.
> 
> That detailed explanation should go in the commit message.

Ok, will move the comment into the commit message.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
