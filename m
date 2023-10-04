Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A407B8343
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 17:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243011AbjJDPNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 11:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjJDPNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 11:13:18 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4375ABD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 08:13:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5803b6fadceso1778885a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696432395; x=1697037195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPvrdimJk+6ET5yzeMFp8sbCNMwce3CbuZMRLA/5qXQ=;
        b=XSe1IiUZzNCmIxTBKM2fm1IVrnQ+3kKtW/gX+92BIoiExRjeHBhwzq2ny+k2FpOsDu
         2CiekpyXK5DfWjgu0QG2L8PdAQ7XZXEyI9nwO/bDAwFpAtuOLYqDxVW4ry7VQVb0VG7k
         MBuPNQ0MwCsVAjvph+x59Mv5l33EWZtXKmrdLG4zdFacnky/vA1MZONMkp0+ZEY/U8jw
         zjTDmLxG7e8lhdQOiG6o8VZjOlL+af8RRX3DIRESUiQjhUZAwKJd432s3Hi4QwZujxmX
         bUY8GSnESyh4R7Px7jkGEWkkFcU61gEk8WMQffBjem9E44Dt7oRyvah0fhIKYSvq5KmF
         Bo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696432395; x=1697037195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPvrdimJk+6ET5yzeMFp8sbCNMwce3CbuZMRLA/5qXQ=;
        b=glwbu+awiqW7zACBPtrRxP3FpjAeIM3WdKV6gF9RZOoeTFY1CSLCui127JstM/IFy3
         6X5lHrevm+1bwEzArbMWVNKeCFAe01VQ0NC4TiTdZdaOIaFa9TvEJA8oC+h/XlOh6Kjm
         kNHSnJ2wpj8mKey38mI7XW+TARv6dz/vMomKSXAhTrgE9ttQZrNviT378qUllKHWZZfZ
         Ebj/twR1Li6i4iqfldu+GX4BRyIf6WOt/tbkCSqSwdy5kcrNy4jsT90Un2qxY9bMMrBH
         IxxTSeKGwP/WudtF8wuzWrABFEdhCvKAPAx8MQehyP7GtqZ5o8o7r/rrsOSW1V3v9jZx
         qygw==
X-Gm-Message-State: AOJu0Yw8ZdgcmLn1YwbIqVd7ccova3QCPp7SN4p1I80Akrzxx6LxW9Di
        /odVNBSjp9fWCmaAj4yZ0Mk8AtwzUY8=
X-Google-Smtp-Source: AGHT+IEKa17mmr2ebFxTfA1V0ZPXedWSM8wuYgAPoTve4i5P/ko83KyT+5QmGNULOttyAQXT8DIABAa9e8w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d583:b0:262:ffa8:f49d with SMTP id
 v3-20020a17090ad58300b00262ffa8f49dmr42120pju.9.1696432394658; Wed, 04 Oct
 2023 08:13:14 -0700 (PDT)
Date:   Wed, 4 Oct 2023 08:13:12 -0700
In-Reply-To: <20231004133827.107-2-julian.stecklina@cyberus-technology.de>
Mime-Version: 1.0
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de> <20231004133827.107-2-julian.stecklina@cyberus-technology.de>
Message-ID: <ZR2BCHmqofCcAuBM@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: rename push to emulate_push for consistency
From:   Sean Christopherson <seanjc@google.com>
To:     Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, Julian Stecklina wrote:
> push and emulate_pop are counterparts. Rename push to emulate_push and
> harmonize its function signature with emulate_pop. This should remove
> a bit of cognitive load when reading this code.
> 
> Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
> ---
>  arch/x86/kvm/emulate.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index fc4a365a309f..33f3327ddfa7 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1819,22 +1819,23 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
>  	return X86EMUL_CONTINUE;
>  }
>  
> -static int push(struct x86_emulate_ctxt *ctxt, void *data, int bytes)
> +static int emulate_push(struct x86_emulate_ctxt *ctxt, const unsigned long *data,
> +			u8 op_bytes)

I like the rename and making @data const, but please leave @bytes as an int.

Regarding @bytes versus @len, my vote is to do s/len/bytes for emulate_pop() and
emulate_popf().
