Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB4972D66E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 02:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbjFMAci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 20:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFMAch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 20:32:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3827BD
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 17:32:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-517bad1b8c5so3668460a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 17:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686616356; x=1689208356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yX9rg1GE7JedoZnbev4zp2kZXMJNrCiYsIp+6jpgdgg=;
        b=kceIBlY0oL3T0WHh/fOdPyP0AVuEynmhYUiu21nfXnHugE5JDyaRFRXjc92Lo+4H+M
         253Oa/XPqO+l5+C0gAuTWbVLEA+5uC35KvDmam2tBDAVkR0FR7trO2jvL8IG7HoWzA9U
         jBrHr4Zyi5orQsbec6Rt9Q9gEBADNpLcOMweGx3VRTmT+ERWUD6tRYQTM7ZmH8yjPAHa
         vVwymwBhOHN0eLvJ/Oq90XkXqIIsV1aU3DEEZC46J1C8a1u/S6d3Z4KckibW3zlmReBD
         Ha8wlR7zp+38FFsH4rraQkbXT3mq1BvxknzmlpgFJQ6L55/G+WYAykliD6dkzK6VwqnA
         nPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616356; x=1689208356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yX9rg1GE7JedoZnbev4zp2kZXMJNrCiYsIp+6jpgdgg=;
        b=lC7MOl1/xfcXNdJq0j+aJkDroahsOXy0PR/15E6AEquhjSqWjLtq/iDS82raIgxz8t
         NjkGIZznbnl0lfoQCqCe1SdGSUoyK+PNrxffphIlOMYEH3lAgrv+vMzHB1JBZ5QgoZ4l
         5qRWhUS0OXnWxaDgI9lycpiOyDVN6hvLiG68VFCsWUGfCkU2UMvQa+g7YYlh1Rymst2B
         OGOn7CKuuDkEW+yx5gvcpza4p84mXaOv6NL98DDhr6ize3Y6HGiz5fUw5Sfd9+Ro9rBt
         wT2q3kUI3c44DsS7pNu+TCXwOH11t2sZgc9/DM8QaPwR55+lgyaqsQDYikdqA+uYbirr
         bSNA==
X-Gm-Message-State: AC+VfDw9ykx9GO4BG/ZtrP7Eh5MEfiEwoE5kj5K3AoMno9iGizmywocK
        bucruOtoC2i/Ri5cLmiz61IbsQfw6vE=
X-Google-Smtp-Source: ACHHUZ5omSUh4SDnoNkGbDixcT4S7zvCDkocq0DneY9QtyYsitcwWrcBZgk1TYRYRrLG69AgOvgG3LfM1vY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:de48:0:b0:53f:2d21:5a16 with SMTP id
 y8-20020a63de48000000b0053f2d215a16mr1484539pgi.10.1686616356135; Mon, 12 Jun
 2023 17:32:36 -0700 (PDT)
Date:   Mon, 12 Jun 2023 17:32:34 -0700
In-Reply-To: <20230413184219.36404-7-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230413184219.36404-1-minipli@grsecurity.net> <20230413184219.36404-7-minipli@grsecurity.net>
Message-ID: <ZIe5IpqsWhy8Xyt5@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 06/16] x86/run_in_user: Change type of
 code label
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, Mathias Krause wrote:
> Use an array type to refer to the code label 'ret_to_kernel'.

Why?  Taking the address of a label when setting what is effectively the target
of a branch seems more intuitive than pointing at an array (that's not an array).

> No functional change.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  lib/x86/usermode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index e22fb8f0132b..b976123ca753 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -35,12 +35,12 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  		uint64_t arg1, uint64_t arg2, uint64_t arg3,
>  		uint64_t arg4, bool *raised_vector)
>  {
> -	extern char ret_to_kernel;
> +	extern char ret_to_kernel[];
>  	uint64_t rax = 0;
>  	static unsigned char user_stack[USERMODE_STACK_SIZE];
>  
>  	*raised_vector = 0;
> -	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
> +	set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
>  	handle_exception(fault_vector,
>  			restore_exec_to_jmpbuf_exception_handler);
>  
> -- 
> 2.39.2
> 
