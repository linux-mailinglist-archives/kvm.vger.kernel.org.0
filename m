Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9966B893B
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 05:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjCNECK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 00:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNECF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 00:02:05 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F031B28232;
        Mon, 13 Mar 2023 21:02:03 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v21so5135826ple.9;
        Mon, 13 Mar 2023 21:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678766523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oVD6BAOOPLAqyhbYCoPWl9mlGeRBJxy4YZGiA5VMu0s=;
        b=UuHsXXCGqUDal9ROiG5788qatEms89ywqRaP21Mno3Dlczdb26mQgihh5gQRPpuA5A
         gQYMBqDTw+kOXR19qfjixcD1/MhoA56h4LVkE+FxIhd7uPwHXI1LIxtfaXU2y+v1w7fi
         0nt5ZMkrUJi3oO1J7r79wxZTLjLp5lyq1z6ZRKomdua8KN7p31LRIoEqJXHz1Hew2T6o
         tTSwwP+Xk1A9PS/a8HUc3Y5kS7stph4i/BwVE/zkiv9ghS0yayqaQoKK+n/tEZ++ulv/
         fHdZdY3iDc4sbbrMNeAoG9TZLWMyAipEY8bMqcyGml28oP1qeGcl13HSvl6umnFnNroZ
         hmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678766523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVD6BAOOPLAqyhbYCoPWl9mlGeRBJxy4YZGiA5VMu0s=;
        b=pfWin71dyOVrVZh0CIz9vEsycEC5NdMxQQE47x4PdOUH1K7v4r3GoR42Q5s54t6K/k
         NHSYDzYkMyNxjEY8CVNNjbZA222XLPhG8rLFBHnyfGLgjIeqw6ReD8jkbyay1RsBb/OR
         2k35GGusUC1b2T9KWIGHoDRkaPmDetxcihNqSm5Y7aJDRB3fY4tnvvE+MCxncEBO5KVp
         ex52+caqxc3uM5J9lXDnk7zOh2fGrbEExiIFPyWXcIA+QdouX9EO1ccLoMv5UWgfeQW3
         GRpS0MAIHLYRertnd+MewFQmF8NqiMMphGfTMrqVTWUg7/zjeaQDXMTicD4qy0WxTlCG
         LS5A==
X-Gm-Message-State: AO0yUKUR+33TdftwRpcI1v/Tma/cQToMH4cgUPttqtE2MiZ3TPGKSFlK
        vKxzDH7p/FhrhV7W7CSRcHA=
X-Google-Smtp-Source: AK7set98HRAyUYgbpkw4XR5WLct/qxQsZSwfBVSnmBjz8v2jt/GCyZEM4qcmuUiAo4cILhCVvFsIFg==
X-Received: by 2002:a17:90a:fe08:b0:23d:41:3582 with SMTP id ck8-20020a17090afe0800b0023d00413582mr5584297pjb.8.1678766523083;
        Mon, 13 Mar 2023 21:02:03 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090a400f00b00233864f21a7sm561058pjc.51.2023.03.13.21.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 21:02:01 -0700 (PDT)
Date:   Mon, 13 Mar 2023 21:02:00 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230314040200.GD3922605@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230308222738.GA3419702@ls.amr.corp.intel.com>
 <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
 <20230313234916.GC3922605@ls.amr.corp.intel.com>
 <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 01:50:40AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2023-03-13 at 16:49 -0700, Isaku Yamahata wrote:
> > On Sun, Mar 12, 2023 at 11:08:44PM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On Wed, 2023-03-08 at 14:27 -0800, Isaku Yamahata wrote:
> > > > > +
> > > > > +static int try_init_module_global(void)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	/*
> > > > > +	 * The TDX module global initialization only needs to be done
> > > > > +	 * once on any cpu.
> > > > > +	 */
> > > > > +	spin_lock(&tdx_global_init_lock);
> > > > > +
> > > > > +	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
> > > > > +		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
> > > > > +			-EINVAL : 0;
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	/* All '0's are just unused parameters. */
> > > > > +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> > > > > +
> > > > > +	tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
> > > > > +	if (ret)
> > > > > +		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
> > > > 
> > > > If entropy is lacking (rdrand failure), TDH_SYS_INIT can return TDX_SYS_BUSY.
> > > > In such case, we should allow the caller to retry or make this function retry
> > > > instead of marking error stickily.
> > > 
> > > The spec says:
> > > 
> > > TDX_SYS_BUSY	The operation was invoked when another TDX module
> > > 		operation was in progress. The operation may be retried.
> > > 
> > > So I don't see how entropy is lacking is related to this error.  Perhaps you
> > > were mixing up with KEY.CONFIG?
> > 
> > TDH.SYS.INIT() initializes global canary value.  TDX module is compiled with
> > strong stack protector enabled by clang and canary value needs to be
> > initialized.  By default, the canary value is stored at
> > %fsbase:<STACK_CANARY_OFFSET 0x28>
> > 
> > Although this is a job for libc or language runtime, TDX modules has to do it
> > itself because it's stand alone.
> > 
> > From tdh_sys_init.c
> > _STATIC_INLINE_ api_error_type tdx_init_stack_canary(void)
> > {
> >     ia32_rflags_t rflags = {.raw = 0};
> >     uint64_t canary;
> >     if (!ia32_rdrand(&rflags, &canary))
> >     {
> >         return TDX_SYS_BUSY;
> >     }
> > ...
> >     last_page_ptr->stack_canary.canary = canary;
> > 
> > 
> 
> Then it is a hidden behaviour of the TDX module that is not reflected in the
> spec.  I am not sure whether we should handle because: 
> 
> 1) This is an extremely rare case.  Kernel would be basically under attack if
> such error happened.  In the current series we don't handle such case in
> KEY.CONFIG either but just leave a comment (see patch 13).
> 
> 2) Not sure whether this will be changed in the future.
> 
> So I think we should keep as is.

TDX 1.5 spec introduced TDX_RND_NO_ENTROPY status code.  For TDX 1.0, let's
postpone it to TDX 1.5 activity.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
