Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A29581868
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiGZRcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239069AbiGZRcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:32:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40E1C938
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:32:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p6-20020a17090a680600b001f2267a1c84so16239213pjj.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xQn8OIn+j3L6VrBDRl1G52g1Si4+uiQp9x97KiACjVk=;
        b=EA9KpAWVkxRYu/HKcFe0HYF6+bHioLVn56UoKyQ2j6udqXVnhSh94Yvkt0CMqI2cN9
         EjnjGf7eo+BkYsK4Rk5ikSRqMU4p9qDpPpdjcN6AfxxcSmcO8Wlq2s+SutmyQPt94yeC
         3WX7mtPFXkcePH98y2ZaQLF4vPY9NUK/C64B+vWyuqNkzOvOa8ZYgqHbOPhAeHzEeITl
         c+t4JvWIxLdIYWtHIGYIVzikP/s8uZx206Sio8VGeoTOaPDlWBuVgOwP6BaDlA7qBSAB
         ft8NagjBRfvERTy34bqEMCgEiD91JZg0guMVhkaljKcvE5KV2G8hYAFLDEXsnw0FM4Tr
         JyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xQn8OIn+j3L6VrBDRl1G52g1Si4+uiQp9x97KiACjVk=;
        b=JNlUu7CNToQFvT73pm5SSn1J8dvYiDdLBz91kfC76d6aU0KIzMFhBtQbUfDHZAeWb2
         UErKjB3igtZr2is9rxWBIDQP9QLgWuDHMzyArA17S38Hm7+QGtvzW187IKZiuRfkCYbA
         SA4QYwY3f7ZVIFNQHqo62kl7pyTMqX8qXadTVTeK6bXyK6qJEMAubl/NB+wYjbH/ZAHp
         ttcGfEKM8A9ZpF+15dAD2gVJLI1C8GvosDW/0eBmtbNombbTYL25kQrDqgSATq/b7+ao
         7e7sdEkCqNVJpsKPafkv3ERwlmZyDlaIroCIl7lJHlKGOF9gTpIGj6YQr2yW5mU/JbFP
         tkXg==
X-Gm-Message-State: AJIora+tH//aFjDbBy92zuL57THMIrYiP/rYkNPYX3/wkYQda1IfjAxF
        YMKnCPHroQT6giRzVtdY7rY6SOw8OTUTFw==
X-Google-Smtp-Source: AGRyM1uLH3IBP7ABz9PDmypLQTHIygJTzmAfNEuJRckiY72lIdZgu/jS2RoPz1l2jiHCgic8v0WzlA==
X-Received: by 2002:a17:902:a516:b0:16c:ef6f:fec7 with SMTP id s22-20020a170902a51600b0016cef6ffec7mr17607550plq.140.1658856739525;
        Tue, 26 Jul 2022 10:32:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b0016c4fb6e0b2sm12048525plg.55.2022.07.26.10.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:32:18 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:32:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86: add and use *_BIT constants for CR0,
 CR4, EFLAGS
Message-ID: <YuAlHgkpBZS0QJ5e@google.com>
References: <20220726151232.92584-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726151232.92584-1-pbonzini@redhat.com>
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

On Tue, Jul 26, 2022, Paolo Bonzini wrote:
> The "BIT" macro cannot be used in top-level assembly statements
> (it can be used in functions through the "i" constraint).  To
> avoid having to hard-code EFLAGS.AC being bit 18, define the
> constants for CR0, CR4 and EFLAGS bits in terms of new macros
> for just the bit number.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

...

> diff --git a/x86/smap.c b/x86/smap.c
> index 0994c29..3f63ee1 100644
> --- a/x86/smap.c
> +++ b/x86/smap.c
> @@ -39,7 +39,7 @@ asm ("pf_tss:\n"
>  #endif
>  	"add $"S", %"R "sp\n"
>  #ifdef __x86_64__
> -	"orl $" xstr(X86_EFLAGS_AC) ", 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry

I don't understand, this compiles cleanly on both gcc and clang, and generates the
correct code.  What am I missing?

> +	"orl $(1<<" xstr(X86_EFLAGS_AC_BIT) "), 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
>  #endif
>          "iret"W" \n\t"
>          "jmp pf_tss\n\t");
> -- 
> 2.36.1
> 
