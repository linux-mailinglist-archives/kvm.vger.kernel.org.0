Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B929570EFC
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiGLAiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiGLAiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:38:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362303C8D6;
        Mon, 11 Jul 2022 17:38:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so9887252pjl.5;
        Mon, 11 Jul 2022 17:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JJppeYPpiQk2YSUaODqq/NfKy0bniqk6PDQKnI1rd/Q=;
        b=kNP3aJdY63KR3teCaO/Qp0ZDg7K4C13ThusDQFDAUMKqADeS0omOzTTcIKOMGGshO7
         AZWMrdXJcVx87XlfjsjoDmqMa0K1b7H3t2TtBwLuJ20vOA8ylMqWgm3JaNdaVoGCKUMv
         tgo37HsPUcPNaHaLksZ23BQdq1O9OUrkL2vBTVlNMZ+4Tm6iB7uU5oJZ+2NDpjpFXfwA
         VnMuBTC7vANC1dHGOiW6ufV0Hg3NNL6GSCa57Bee5Slvh6Jfgh1hz236aAC3FgtcJ5gs
         w4cbmgTHsi4hP6JaULz4u+o65NRgEnwYaDBr6KEtzji4qVe9tjAqDlPKTWMYtgPf/pT7
         qlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJppeYPpiQk2YSUaODqq/NfKy0bniqk6PDQKnI1rd/Q=;
        b=bXd3PUlUczpajE/tVXtGowCoQxd+qgK5VCBQeV2C39jeKCMXWF4zklgW+iiQ87ARh3
         eRKAS4WSNump/bhWXPJdAMlU7mXa3CVazItBT5JksQKwPJriSuWK1T2VFvh4Y8dDyQmx
         KScLuT+7yGImCka50x9NERNVk9Ju5PEISMZM1RLj6A7h6Xb0GJBIE+DyefQguOeXu4Op
         r01cPvo4yYN624g8ONAiV7xAhuAFCzZ2Y5DAeqbcWV7peZcvaFC7DysIuKYM00rjbsVc
         btD4izLJK98KKFDImpEGlLrXo7V5Tc7KsV2l799xDFYeQZFs0BuiJjUKajG5dgL5ZN5K
         FyaQ==
X-Gm-Message-State: AJIora+spHxwI++rK6T8DD03y/gmdI0w3pkCywmFdwLW7UoxglAzoEfk
        eYMq1oS65oYRkp5+PiHXK5uFUCTj11Y=
X-Google-Smtp-Source: AGRyM1vLB9AE7oHESlQrn34FEHTgjASGUrN/PcmbPkMX59LmIS8kK+h2WKtuuqcTDy5lRkoq4sWD+A==
X-Received: by 2002:a17:90b:3e89:b0:1f0:4233:b20e with SMTP id rj9-20020a17090b3e8900b001f04233b20emr1190973pjb.0.1657586293471;
        Mon, 11 Jul 2022 17:38:13 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id l3-20020a170902f68300b0016c5306917fsm1535279plg.53.2022.07.11.17.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 17:38:12 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:38:11 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 008/102] KVM: x86: Refactor KVM VMX module init/exit
 functions
Message-ID: <20220712003811.GB1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
 <46acf87f3980a6f709e191cfc10ff4be78e23553.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46acf87f3980a6f709e191cfc10ff4be78e23553.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 03:53:31PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Currently, KVM VMX module initialization/exit functions are a single
> > function each.  Refactor KVM VMX module initialization functions into KVM
> > common part and VMX part so that TDX specific part can be added cleanly.
> > Opportunistically refactor module exit function as well.
> > 
> > The current module initialization flow is, 1.) calculate the sizes of VMX
> > kvm structure and VMX vcpu structure, 2.) hyper-v specific initialization
> > 3.) report those sizes to the KVM common layer and KVM common
> > initialization, and 4.) VMX specific system-wide initialization.
> > 
> > Refactor the KVM VMX module initialization function into functions with a
> > wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> > among VMX and TDX.  We have a wrapper function, "vt_init() {vmx kvm/vcpu
> > size calculation; hv_vp_assist_page_init(); kvm_init(); vmx_init(); }" in
> > main.c, and hv_vp_assist_page_init() and vmx_init() in vmx.c.
> > hv_vp_assist_page_init() initializes hyper-v specific assist pages,
> > kvm_init() does system-wide initialization of the KVM common layer, and
> > vmx_init() does system-wide VMX initialization.
> > 
> > The KVM architecture common layer allocates struct kvm with reported size
> > for architecture-specific code.  The KVM VMX module defines its structure
> > as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> > struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> > TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to report the
> > sizes of them to the KVM common layer.
> > 
> > The current module exit function is also a single function, a combination
> > of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> > logic and KVM common logic.  This is just refactoring to keep the VMX
> > specific logic in vmx.c from main.c.
> 
> This patch, coupled with the patch:
> 
> 	KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
> 
> Basically provides an infrastructure to support both VMX and TDX.  Why we cannot
> merge them into one patch?  What's the benefit of splitting them?
> 
> At least, why the two patches cannot be put together closely?

It is trivial for the change of "KVM: VMX: Move out vmx_x86_ops to 'main.c' to
wrap VMX and TDX" to introduce no functional change.  But it's not trivial
for this patch to introduce no functional change.

So I moved this patch right after the main.c patch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
