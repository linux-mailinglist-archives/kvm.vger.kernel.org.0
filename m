Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2142B76D81B
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjHBTnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjHBTnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:43:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2F8D9
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:43:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584375eacacso1028327b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691005382; x=1691610182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2jIBbfk5OGqUX5RykuZjaLHj/apE9Fp7JSgKmJF0SOk=;
        b=0gR+cicF9eXLopYKCD9n+VxgZRC8dooUvSxgvsgqyGNyD/aDYM7jyNFKeUBIceGZ49
         6VHAefTJlreqPKan1Eyyx659507M3wsrgBuK6akBCUuh5Mhccq6R7dwNFHHXeTvBhAnz
         QSBJdd2xWfIBTL68to9MxWitNj0Bq/cpGdAl8DlxnV014DNaHAQOQ+zY+Zy0So3VRaU9
         Qa1XtEt+lNU8TWDKPeBe8WsH6mSILVql4uGeI7W9/gyj35Bhjoz73G9CphHKKRLmOuMo
         kupHRd+sCuWxeHoPek0/P333r4+GcN8AYWiCLw2qyRTxYcBt0hZhbnPxS5nGUAT/VxMa
         LUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691005382; x=1691610182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2jIBbfk5OGqUX5RykuZjaLHj/apE9Fp7JSgKmJF0SOk=;
        b=KRBDic2LRzJbqZGrt0zOqi49O4lWhbLIUIIks6BNA9xulmGdytiVkGfXVC/Z/p8DMb
         tBivw6ncARcCqb81fMzlLDvUzhIFC8ExJPrJXhC8OS/rAk+v6Gnu5oi1Nyn9fufbNrjl
         cWECskK5h+a8iJziVHlNneVa8P9fBWyMvzaO9JdMEN3ZIszVkcOcMnweZIpDypsXbRDz
         Meo+F49iZX9kQCrLS+bjINMu8sEgXWri8g6gSryU8SS/P65vXNRQUHGqv9LujmhXqVYB
         hAxSzFUbxNdyQIoY6YLNXIgJRQ2SHvhOF6xYgdoGJrC2N8KJf/dEHX4e+2I9Be24XuPD
         Pqqg==
X-Gm-Message-State: ABy/qLaYAzKTLqzBgm8RRhU3vKTW222nNuSQ6KYZgBNc21hkWxgw6O3Z
        a6hdguEis/XDP+NAUc/kDkeVLNCPYfI=
X-Google-Smtp-Source: APBJJlGjUTmJdt8Fmwmqo8cYkACQfAnxR9iUebnDWqbmlmiAYO08NP0IpSGFj/SzyGdbxtOX6QIqcJCF6yo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb06:0:b0:56c:e0c5:de88 with SMTP id
 n6-20020a81eb06000000b0056ce0c5de88mr149949ywm.1.1691005382610; Wed, 02 Aug
 2023 12:43:02 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:43:00 -0700
In-Reply-To: <20230720115810.104890-1-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230720115810.104890-1-weijiang.yang@intel.com>
Message-ID: <ZMqxxH5mggWYDhEx@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is not "fixup", this is support for CET and for new CPU functionality.

On Thu, Jul 20, 2023, Yang Weijiang wrote:
> CET KVM enabling patch series introduces extra constraints
> on CR0.WP and CR4.CET bits, i.e., setting CR4.CET=1 faults if
> CR0.WP==0. Simply skip CR4.CET bit test to avoid setting it in
> flexible_cr4 and finally triggering a #GP when write the CR4
> with CET bit set while CR0.WP is cleared.
> 
> The enable series also introduces IA32_VMX_BASIC[56 bit] check before
> inject exception to VM, per SDM(Vol 3D, A-1):
> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
> exception with or without an error code, regardless of vector."

This clearly should be at least two separate patches, maybe event three.

  1. Exclude CR4.CET from the test_vmxon_bad_cr()
  2. Add the bit in the "basic" MSR that says the error code consistency check
     is skipped for protected mode and tweak test_invalid_event_injection()

2 could arguably be split, but IMO that's overkill.

> With the change, some test cases expected VM entry failure  will
> end up with successful results which causes reporting failures. Now
> checks the VM launch status conditionally against the bit support
> to get consistent results with the change enforced by KVM.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  x86/vmx.c       |  2 +-
>  x86/vmx.h       |  3 ++-
>  x86/vmx_tests.c | 21 +++++++++++++++++----
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 12e42b0..1c27850 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1430,7 +1430,7 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
>  		 */
>  		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
>  		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP ||
> -					bit == X86_CR4_SMEP)))
> +					bit == X86_CR4_SMEP || bit == X86_CR4_CET)))
>  			continue;
>  
>  		if (!(bit & required1) && !(bit & disallowed1)) {
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 604c78f..e53f600 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -167,7 +167,8 @@ union vmx_basic {
>  			type:4,
>  			insouts:1,
>  			ctrl:1,
> -			reserved2:8;
> +			errcode:1,

Way too terse.  Please something similar to whatever #define we use on the KVM
side.  Ignore the existing names, this is one of those "the existing code is
awful" scenarios.

Also, I wouldn't be opposed to a patch to rename the union to "vmx_basic_msr",
and the global variable to basic_msr.  At first glance, I thought "basic.errcode"
was somehow looking at whether or not the basic VM-Exit reason had an error code.

> +			reserved2:7;
>  	};
>  };
>  
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 7952ccb..b6d4982 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
>  			    ent_intr_info);
>  	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>  	vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -	test_vmx_invalid_controls();
> +	if (basic.errcode)
> +		test_vmx_valid_controls();
> +	else
> +		test_vmx_invalid_controls();

This is wrong, no?  The consistency check is only skipped for PM, the above CR0.PE
modification means the target is RM.

>  	report_prefix_pop();
>  
>  	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
