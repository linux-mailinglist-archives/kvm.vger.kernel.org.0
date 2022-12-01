Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF9B63E770
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLACEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiLACEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:04:06 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E12862E4
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 18:04:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d18so252577pls.4
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 18:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/Llka/k+bGclHQxEjVBhY77pI0SOprA36HniKfBLjI=;
        b=YEPtzfCOhSVKrLqTfWmQLVFnY9kGXYlvHnp3v56fyMenhVnmfWX90iqCGUqIlSMslO
         iGLvWkrJh8BXxQbiGxdEz3HAQOHUBAl7fTPUv3QFHMjzWOvp0H0xuvlY/NsA/6vHHmLy
         W0Q12DPU17ZyzyE9iJxjqmMgGylb/bVyYYQLgERinrMqXmy2KRRmgIRg6ZCjH8GgoQPG
         dMAVkJxIO/3C3J7ZxOlSUfH/tshBzN7/5gR+y1anSnH109fxq9Z2OLIYmbhaf8MLZzy2
         mPDS6Bvea1DkyE0Bmc7Vm2407PswKgCD9GG1bfcuaIc9gWWzVNDsYMv+iaNuc5uZ12OS
         bhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/Llka/k+bGclHQxEjVBhY77pI0SOprA36HniKfBLjI=;
        b=2LWJF5XshXa4TLhxdq09Yj0dCcJ33aGWa1A1EA2UlGOccW2BEU7AYnMmMYvLGzWugU
         Kr8LScvnIW04j/Wmxb9XIa+vBdsrlorzhInC97BqSvxott3zj5Q5dO7eBg1T8egjCkf+
         4nlfQYEZUYyOD6rY0oVI+odsT3zJ7U5yb4smN9xir8JTSXahBAuKfNN57yWcRMz5yKKO
         9W+dxdYvy5KQIJ1WtisE5AhTZFvE3QncMuDUoBRPtyPAzrQBiZq/7k4LMOFKaSQCacM3
         U8QWPA6RW9yib7EJB8Z4aa1TzI96d8RwsqgGosuJ5ttfLvVLY6ayV898G5thhp0eHGJU
         QcQA==
X-Gm-Message-State: ANoB5plgxNE7y6MZQ+iwnRNx+PDRjmNwzbUMcwv31w0yGSvJPo5ox0r2
        Bl/T8r+0D0zMc4b4M5ODMZtFtYrRmlELxA==
X-Google-Smtp-Source: AA0mqf4Tpq7+9XvtKkJwI+Y4Rzwj/zvCq1SFCe3MQgae7SAOAJmpcCK3a3tQyg7KSnHboweLsSZIWw==
X-Received: by 2002:a17:902:bd04:b0:189:38a1:30fe with SMTP id p4-20020a170902bd0400b0018938a130femr42019045pls.47.1669860244929;
        Wed, 30 Nov 2022 18:04:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b00186b55e3cd6sm2187791plf.133.2022.11.30.18.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 18:04:04 -0800 (PST)
Date:   Thu, 1 Dec 2022 02:04:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] KVM: x86: Remove unnecessary export of
 kvm_inject_page_fault()
Message-ID: <Y4gLke+jtw07/Rrb@google.com>
References: <20221114095606.39785-1-likexu@tencent.com>
 <20221114095606.39785-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114095606.39785-6-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Don't export x86's kvm_inject_page_fault(), the helper isn't used by
> KVM x86's vendor modules. Add declaration to header file out of
> existing callers' need.

...

> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..69811b4f3eac 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -307,6 +307,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> +void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);

arch/x86/include/asm/kvm_host.h already has a definition, no need for one here.
The definition could obviously be moved, but I'd prefer not to bother at this time
as I want to move _all_ of kvm_host.h out of the "public" include directories (WIP).
