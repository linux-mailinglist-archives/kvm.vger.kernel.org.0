Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE712581CD0
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 02:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiG0Ao5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 20:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbiG0Aoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 20:44:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0618E3AE55;
        Tue, 26 Jul 2022 17:44:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so2039086pjh.0;
        Tue, 26 Jul 2022 17:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GN/As28NJTkt9K3MCXqEyETDJB3ZuY0ItHR0XOMDO20=;
        b=eOVxX9scVmYCLsfd/EiwtUY7Pkh1pNA1M71bz18pHn7CC0EUA9SWx6ahknb9fYP7sO
         9Z0a8WQrH+3Z6B17rqEwSJpF3u2OyazBRxsjy0MctCVTgJbiGNJ/+RFcQNoXStrNm3M9
         iVOBChBS+ERR/yJOIUkKSvj6tvSe7F5FofEWxriVwbJcb85Z7acXFi7941ek6c0oeXyz
         q+5WI7HFaYTjrMueA9eyYkTB6dpFkunDo3Y0tE+zIHw3OpvGj0w1fFpxI2+/lt/8bhnU
         +WWpaKwG2l23r9FxduEWyRmmCCkrx7vDtFpX4gxEDsQ8uJLE50MOl04Y6z+WP22iIEJS
         UmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GN/As28NJTkt9K3MCXqEyETDJB3ZuY0ItHR0XOMDO20=;
        b=Ed3iAc5zYogG76dYfqnC2kTa5qgu8Q6mXSOXMmXAL9cKHQPp15VSMp/ClJbSEUoQG9
         FWjW4AhyNoHReMXuhvriWD43FYKUnnLX3b80mgwF65PXYodjvpWRWcAOKq2pbZRG5UHB
         6kbM1xNbVw5NnMxhhr3lW70mzOTeEURJbi4Gen8NJ259+H1nMS1/Nks6cuJ058L3spgi
         mUj7SNxdt3+ZGFlBAvLxPMeSxURA5XScTwpO9iXRcLnWMycuKiyIGYPh7JHbGShXnmXf
         fQPJbnWW32lBtSa0ZRNrN43fnmrgql+upjV1s1dcctcilpdnnCnimWSAoVIuPwLwJQeB
         K/1w==
X-Gm-Message-State: AJIora8CKkAaKxoFlb43I4qB9I3IwmzlJKSwtNliR7K7l0l5wh7pCtBK
        rul9cFWfsx2SuD2cKSgHAV8=
X-Google-Smtp-Source: AGRyM1tXAM3DDr7ZMwMAG5o1Ob+aZOo9Fc+MNvZKUwnqpx9bYCmDWnK6oOGA67J9k7U2sLwgEYyrJQ==
X-Received: by 2002:a17:902:7612:b0:16d:2dbe:26f2 with SMTP id k18-20020a170902761200b0016d2dbe26f2mr19645136pll.94.1658882690413;
        Tue, 26 Jul 2022 17:44:50 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id b1-20020a621b01000000b005258df7615bsm12305050pfb.0.2022.07.26.17.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 17:44:49 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:44:48 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 008/102] KVM: x86: Refactor KVM VMX module init/exit
 functions
Message-ID: <20220727004448.GH1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
 <46acf87f3980a6f709e191cfc10ff4be78e23553.camel@intel.com>
 <20220712003811.GB1379820@ls.amr.corp.intel.com>
 <20f87d1f04f71bd2be63519ebf2a2447c07f7e7a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20f87d1f04f71bd2be63519ebf2a2447c07f7e7a.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 01:30:34PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-07-11 at 17:38 -0700, Isaku Yamahata wrote:
> > On Tue, Jun 28, 2022 at 03:53:31PM +1200,
> > Kai Huang <kai.huang@intel.com> wrote:
> > 
> > > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > Currently, KVM VMX module initialization/exit functions are a single
> > > > function each.  Refactor KVM VMX module initialization functions into KVM
> > > > common part and VMX part so that TDX specific part can be added cleanly.
> > > > Opportunistically refactor module exit function as well.
> > > > 
> > > > The current module initialization flow is, 1.) calculate the sizes of VMX
> > > > kvm structure and VMX vcpu structure, 2.) hyper-v specific initialization
> > > > 3.) report those sizes to the KVM common layer and KVM common
> > > > initialization, and 4.) VMX specific system-wide initialization.
> > > > 
> > > > Refactor the KVM VMX module initialization function into functions with a
> > > > wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> > > > among VMX and TDX.  We have a wrapper function, "vt_init() {vmx kvm/vcpu
> > > > size calculation; hv_vp_assist_page_init(); kvm_init(); vmx_init(); }" in
> > > > main.c, and hv_vp_assist_page_init() and vmx_init() in vmx.c.
> > > > hv_vp_assist_page_init() initializes hyper-v specific assist pages,
> > > > kvm_init() does system-wide initialization of the KVM common layer, and
> > > > vmx_init() does system-wide VMX initialization.
> > > > 
> > > > The KVM architecture common layer allocates struct kvm with reported size
> > > > for architecture-specific code.  The KVM VMX module defines its structure
> > > > as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> > > > struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> > > > TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to report the
> > > > sizes of them to the KVM common layer.
> > > > 
> > > > The current module exit function is also a single function, a combination
> > > > of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> > > > logic and KVM common logic.  This is just refactoring to keep the VMX
> > > > specific logic in vmx.c from main.c.
> > > 
> > > This patch, coupled with the patch:
> > > 
> > > 	KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
> > > 
> > > Basically provides an infrastructure to support both VMX and TDX.  Why we cannot
> > > merge them into one patch?  What's the benefit of splitting them?
> > > 
> > > At least, why the two patches cannot be put together closely?
> > 
> > It is trivial for the change of "KVM: VMX: Move out vmx_x86_ops to 'main.c' to
> > wrap VMX and TDX" to introduce no functional change.  But it's not trivial
> > for this patch to introduce no functional change.
> 
> This doesn't sound right.  If I understand correctly, this patch supposedly
> shouldn't bring any functional change, right?  Could you explain what functional
> change does this patch bring?

This patch doesn't bring functional change.  This patch changes orders of
some function calls.  It doesn't matter actually.  But I think it's non-trivial.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
