Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4288728937
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbjFHULA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 16:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjFHUK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 16:10:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD07C1707;
        Thu,  8 Jun 2023 13:10:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-652a6cf1918so850933b3a.1;
        Thu, 08 Jun 2023 13:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686255057; x=1688847057;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KaorFROknjCn9/iVhBQO9PAsd8HYdHVJN5C9ENR6YJY=;
        b=d4haJP3T5+svy6N/pjKXZzN+9c59xnjk5MNne8EWxsJ/F2y/AlcU5khc1lDxZACmPo
         5b8jd+FRn5zkglJwxsdgxLh08r6HR8hekliatKKBP8cwWWBwT7Y2GsvRTFHdmxSTvyan
         45ayfpDci0sng7uLskyryB5GJ5Ytg6MS75CEdCSUg8NaULBGuL+PgGUvq0VVNwS7BuBQ
         lTRYptfzi6HfFxncQMUNbNdTqSSXD05bJ1nffB0u5ZhkkzMrZVeVNPa6hX7WwVKirAXv
         Q6kbsiDNw0pNPHn42Ft0AhI+I8uAl6p8WcbiheTYwuFVplwK+8BluGY1DknYeKbuYk5K
         fApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686255057; x=1688847057;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KaorFROknjCn9/iVhBQO9PAsd8HYdHVJN5C9ENR6YJY=;
        b=WUixBEfXKWI6hBlhqPPb7Jt7vmxS1J6KwnWb+8Gona0XbluFosMDB5plLEVUBGStAv
         QEjyud+Z5ewz9ruPKzhKMl0tbv3EzYgCuOCL+pCGjeLBP7upKGDbEhcY2khCyzUW5fq1
         nr6QFURP0VxNjLF/LyujfS1Ylb423cgIjlGeF6JEa8EfBMJ/Isll2hWnJlFWXSwNn2nw
         n1E2NyqoLwtmL9fEDxVECouwq4OB00yKZntw9Etv1pX/LDG/asYQM9Wc9/TmdQOiRQEr
         azIxDqfdVnww3Yq8R9XtUXzZZelZT3xyDlAf1WD7qyo8A3jx/c7rC/tHbukQiIAFyDCr
         XARQ==
X-Gm-Message-State: AC+VfDzChoXDk6eBA7uBfGFLSAiQlmXWfRKVMrTomM3tMgGLNe0I87fi
        rg+faQ0j+822p90VO2kiOVM=
X-Google-Smtp-Source: ACHHUZ4E7lX8FjskeXiifJrLjxkPRXnFFeAdkZpZwNyMNxtNO+OutUboGDoPhJ4L4suVZIB4vx0Y7A==
X-Received: by 2002:a05:6a00:812:b0:658:2818:edd4 with SMTP id m18-20020a056a00081200b006582818edd4mr8062710pfk.13.1686255056839;
        Thu, 08 Jun 2023 13:10:56 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id u5-20020a62ed05000000b006580e98326esm389759pfh.42.2023.06.08.13.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:10:56 -0700 (PDT)
Date:   Thu, 8 Jun 2023 13:10:54 -0700
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
Message-ID: <20230608201054.GK2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230607181537.GG2244082@ls.amr.corp.intel.com>
 <DS0PR11MB63733FFA02B4A5C04561A1BFDC50A@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB63733FFA02B4A5C04561A1BFDC50A@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 01:43:27AM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Thursday, June 8, 2023 2:16 AM, Isaku Yamahata wrote:
> > On Mon, Jun 05, 2023 at 03:20:19PM +0000, "Wang, Wei W"
> > <wei.w.wang@intel.com> wrote:
> > > > +static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> > > > +			       struct tdx_module_output *out) {
> > > > +	u64 ret;
> > > > +
> > > > +	ret = __seamcall(op, rcx, rdx, r8, r9, out);
> > > > +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> > > > +		/*
> > > > +		 * TDX requires VMXON or #UD.  In the case of reboot or
> > > > kexec,
> > > > +		 * VMX is made off (VMXOFF) by kvm reboot notifier,
> > > > +		 * kvm_reboot(), while TDs are still running.  The callers
> > > > check
> > > > +		 * the returned error and complain.  Suppress it by returning 0.
> > > > +		 */
> > >
> > > Curious how do the callers check the returned error when " Suppress it
> > > by returning 0" here.
> > 
> > It doesn't make sense for the caller to check the error and warn when
> > kvm_rebooting = true.
> > Let's make it "return kvm_rebooting ? 0 : ret;" instread of "return 0;".
> > Does it make sense?
> 
> Seems no need. The comments look confusing, and not aligned to what
> the code achieves. From what I read:
> - if kvm_rebooting=true there: return 0 to caller and no error or warning happens
> - if kvm_rebooting=false there: crash the system via kvm_spurious_fault.
> In this non-rebooting case, I think the callers don’t get a chance to read the 
> returned value and complain.

How about this comment?

	if (unlikely(ret == TDX_SEAMCALL_UD)) {
		/*
		 * TDX requires VMXON or #UD.  In the case of reboot or kexec,
		 * kvm shutdown notifier, kvm_shutdown(), makes VMX off (VMXOFF)
		 * while TDs can be still running to invoke SEAMCALL.  It
		 * results in superfluous errors or warnings.
		 * If rebooting, return 0 to suppress superfluous messages.
		 * If not rebooting, panic by kvm_spurious_fault().
		 */
		kvm_spurious_fault();
		return 0;
	}

> Another thing is, have you double-checked that invocation of seamcalls
> indeed returns TDX_SEAMCALL_UD when VMX=off?

I observed it several times during testing tdx module initialization. Here is
the example I dug out from my debug logs.

  tdx: SEAMCALL failed: CPU 162 is not in VMX operation.
  tdx: TDX module initialization failed (-22)
  kvm_intel: Failed to initialize TDX module.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
