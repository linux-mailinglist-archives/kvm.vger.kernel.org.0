Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222CB54D501
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348338AbiFOXMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345630AbiFOXMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:12:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DBD6160
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:12:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o6so11669059plg.2
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D3ky3t/3DQXGDC31n3Wsb1ZjnBTMKkyu2mEIlrYE2tA=;
        b=e8ulTm729ZPaEA6ttDElfBTxboVk5dGBvVq8YKXpo7B0VwJP/ijnz5HjnQHPYIpYnc
         amvItIZQfJhWsmLjwKBZc7ADkS4KGar2zkC0UJoILH9mnHcURJgtwejKBhblGwAON1Rt
         Rirqbz75mzJoojqbwW3XOLmx0IJ/AA2Ihm7+Xkfe5SVbnj/PoJmOTBtLdto1xo/a+GSL
         GFaPcEAY5EagRSf2WpxpjdVN1dUVafys9vSslDCZKSSax7LE4YVcDdBmrIgsy9nV5ky1
         AFfLbV/xZ1tDuMpX1XqbLrzrQYmF31u+LDYjpi74TAcgaQz7t8Lm9uKIgbGFgNDIcVAy
         rIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3ky3t/3DQXGDC31n3Wsb1ZjnBTMKkyu2mEIlrYE2tA=;
        b=IeyyZY1fOBzAqpb1oMC3sgMsc2HGls+6AJQcZOcIpzziBWdajsvXttDrPRRjQn3Lgx
         xBIFbtRGTexw47UleHHEaCgCul4yrBHes2dtDDNS9hrW4ITL/PLiRaJIk50FSOnNwSIZ
         TuiqL+lL3O38QWe+5nNJrQ38Gys2xOaUeT+uvwWQgFubJwRkaOKTf+UVU2PoFUWFEbBp
         YuzSBdZR0+1ATSjATYHd0MPsmQlwRKV4Im1M5lb2SZ2LdETsF03v7cDqqwLzJJZjdmvN
         z8pZU/B/GyTk2n9ZZtQ2hgUAlaGFNtGqo8Fq6ht7TJxjdLl58wRaMc33GfSBCj1/pF1u
         HYPw==
X-Gm-Message-State: AJIora9nctI4nUsSJ0gAsV2f39+wbUzoxvfwDfk6nQPxWnDihGVn29D6
        Pm45KYWZ550vPErh2HYayYCBGQ==
X-Google-Smtp-Source: AGRyM1sl47BhPXuWAkqJOGRULRiqdaACgeXme4YMtEu+ey33Vl8Xnapld2oJ2KRSk1XVG3oSQL/DGg==
X-Received: by 2002:a17:90b:4a4c:b0:1e4:dcfc:e688 with SMTP id lb12-20020a17090b4a4c00b001e4dcfce688mr12711019pjb.38.1655334749192;
        Wed, 15 Jun 2022 16:12:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s17-20020a17090a5d1100b001e0d4169365sm2397157pji.17.2022.06.15.16.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:12:28 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:12:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 10/11] x86: efi, smp: Transition APs
 from 32-bit to 64-bit mode
Message-ID: <YqpnWe2NwIlAiG37@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-11-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-11-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Varad Gautam wrote:
> diff --git a/x86/start32.S b/x86/start32.S
> index 9e00474..2089be7 100644
> --- a/x86/start32.S
> +++ b/x86/start32.S
> @@ -27,7 +27,16 @@ MSR_GS_BASE = 0xc0000101
>  .endm
>  
>  prepare_64:
> -	lgdt gdt_descr
> +#ifdef CONFIG_EFI
> +	call prepare_64_1
> +prepare_64_1:

Use "1:" for the label, and 1f / 1b, that way it's obvious it's a relatively transient
thing.

> +	pop %edx
> +	add $gdt_descr - prepare_64_1, %edx
> +#else
> +	mov $gdt_descr, %edx
> +#endif

Rather than have #ifdefs everyway, add a macro to hide the differences, e.g.
load_absolute_addr.
