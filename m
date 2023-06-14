Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DDB7304E3
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjFNQ3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 12:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjFNQ3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 12:29:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4D2126;
        Wed, 14 Jun 2023 09:29:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b3d44e3d1cso27758205ad.0;
        Wed, 14 Jun 2023 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686760150; x=1689352150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYowlirmzVIaJjVl16L1Tp/LJMaIiS2KG5AvJneLQwg=;
        b=SWJgfL3FSDyVYjLG5C+Fjwv/9AuktNh8hR+Opy5aTJ2VBx19Dx14eIac3gyMIRvXiA
         JqbhOOPdyhXXo4RiCsdyb4WqTNemV9TYbpQX3pQ3UppRRx5zAhrfJYZpyM/377EWS9YF
         Lesb0kfYzuhJ4/X0RYAwV2PEUbz4IwgY2IX4wTWZAaLGmKMaob/KlAcx3M6vXmnKqY2U
         AMunAiCAYgCX+eh/UYI1rflNYhBD9NvqWSvz4mfe1wb9z7ur2dhE6uZIEZpp1k2U+HTG
         EogOnMCsSZGCfnwdXZ7i0kdh8tMxRKdbg7H4jEqI5FY72b+hLNyEzLpBkH8lXdCVrs8H
         2aSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686760150; x=1689352150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYowlirmzVIaJjVl16L1Tp/LJMaIiS2KG5AvJneLQwg=;
        b=SbK6PBG1+I0URklIEEMRdSqf357G6/GqoiIB/QWfxEV/eHxrTECoRt7FMiT83vIGG2
         JuLYvWylZb21hR8iQJQovpjtPU/MLGMA2zEJXxrE+VyifbyYE6bCp13VUGmk85u0X5t6
         FxIGUZ2forGKVDC195Rb9Ib2oFHN+w7qlDxllxipy68GByUOLlrAPAV/xCyjsGTC8x6d
         CRrgV0o4gh2UeGLOl6+fQm115MG6moOsCM8AEc/FPnxdMeduNfQyH1GYl/jxVsbCNfND
         XafPsY4u4zfitERSTjm6gUxGj+6NQhVRVr5R54Ale38md0dylZiaqEa5v18krfgDrKR1
         q9NQ==
X-Gm-Message-State: AC+VfDydG6lE5avkuxkuBecJhkVW2L0Rw2teLrxeX0LJfnX0iQ/JRCo9
        0FrKlaHVpH3BhMyyhN95x+Y=
X-Google-Smtp-Source: ACHHUZ5UMZIajldYpDot2kKchRNzTJ8a5aZWtQeixvRPHbDlPsku9M1G64WDOf8ev6ReuuFGU/U9oQ==
X-Received: by 2002:a17:902:da8a:b0:1af:feff:5a70 with SMTP id j10-20020a170902da8a00b001affeff5a70mr15710192plx.11.1686760150456;
        Wed, 14 Jun 2023 09:29:10 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902b70a00b001afd6647a77sm12466432pls.155.2023.06.14.09.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 09:29:09 -0700 (PDT)
Date:   Wed, 14 Jun 2023 09:29:08 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20230614162908.GS2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230607181537.GG2244082@ls.amr.corp.intel.com>
 <DS0PR11MB63733FFA02B4A5C04561A1BFDC50A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230608201054.GK2244082@ls.amr.corp.intel.com>
 <DS0PR11MB6373FA1820DDC8804BAF6BD6DC5AA@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373FA1820DDC8804BAF6BD6DC5AA@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 11:45:49AM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Friday, June 9, 2023 4:11 AM, Isaku Yamahata wrote:
> > How about this comment?
> > 
> > 	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> 
> Where is the TDX_SEAMCALL_UD error code documented in the spec?
> I failed to find it.

This is not a part of the spec, but a convention of __seamcall().
Please refer to
https://lore.kernel.org/all/ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com/


> > In the case of reboot or kexec,
> > 		 * kvm shutdown notifier, kvm_shutdown(), makes VMX off
> > (VMXOFF)
> > 		 * while TDs can be still running to invoke SEAMCALL.  It
> > 		 * results in superfluous errors or warnings.
> > 		 * If rebooting, return 0 to suppress superfluous messages.
> > 		 * If not rebooting, panic by kvm_spurious_fault().
> > 		 */
> > 		kvm_spurious_fault();
> 
> I would put it this way:
> SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
> This can happen when host gets rebooted or live updated. In this case,
> the instruction execution is actually ignored as KVM is shut down, so
> the error code is suppressed. Other than this, the error is unexpected
> and the execution can't continue as the TDX features reply on VMX to
> be on.

Thanks for it. I made minor fix to it.

	if (unlikely(ret == TDX_SEAMCALL_UD)) {
		/*
		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
		 * This can happen when the host gets rebooted or live
		 * updated. In this case, the instruction execution is ignored
		 * as KVM is shut down, so the error code is suppressed. Other
		 * than this, the error is unexpected and the execution can't
		 * continue as the TDX features reply on VMX to be on.
		 */
		kvm_spurious_fault();
		return 0;
	}

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
