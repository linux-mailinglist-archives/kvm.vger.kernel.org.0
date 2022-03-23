Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E2C4E542D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 15:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244747AbiCWOZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 10:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244678AbiCWOZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 10:25:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CCEDEDF;
        Wed, 23 Mar 2022 07:24:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r22so3138975ejs.11;
        Wed, 23 Mar 2022 07:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xxM/CCiZqmy9dWayhpcsnysAin++6OStfr44+GkTcw0=;
        b=LdcFoB1uCbYp/KQmdXmuKc4HRQNzV99UWZs93wZEeI4BwrG7d+a2NKtTwJLVNU5x0z
         rtb2kfUl9rmjBqMvdGi7b95HGL7kwZPmqpkwDwd0UJ5rQCk5i5+bjId909aT7jsyZrtl
         sW6W+shCkt7wEOSsfGi+IDHxf4dYwUk1rNfA0JJyEkYcXg/wrpzy234LWQJjgGSjwSAV
         e8tBwUx6MnYyTVo7xIz/43wsgZdc+FJNM/EmCYHVQ62KGVfTspitO1ykd3VI2Yl4Ka1Y
         w/dVSOQWk7EPJ2rjCmaErI9advMUOH7eT3giTfotfcBcy6IwtlXe+T2pIVzP5fc4+hzq
         7o3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xxM/CCiZqmy9dWayhpcsnysAin++6OStfr44+GkTcw0=;
        b=l+N10lrLDSNttkUV5uaWdBLIiSpvjGybwEsNsdxZepxNVpP04viaHJ2go8Zw/Z6nyt
         56fLSm4nPMOKNIybSmXBAQyRUMhmaX5nXXpGLGjaQTYqdPtOwrK0DZAgos5ZN8kUyGGT
         AvnuEVNbULuXvsdouPqkrKKeKOGFKs7/PlumrpMPVQU4eqlGxiWPtgW6WsOHFhKj7uNw
         vzo33b+psQFqwJuwnAEyczCGRs0k2iGb7VaYrgep/TWqC1jYEyke1pp21z7jDjdBI/4q
         4+BxKI19sYoGyFtZGzPLKsG4ehY6xIBP4vdB4k9zgZrSb/lPjJiRvkq4xozmiRjJCqkY
         EN6A==
X-Gm-Message-State: AOAM533R/wbnNjKjb0ht8nfEUr3KYUxlIkVFLO1Rue8iwn6tnAeanvbJ
        TC9fai3gYY8jeQ32DEInSOI=
X-Google-Smtp-Source: ABdhPJykBB6DNurIzRR5b4gOQQyE2jIBjMtPp159C7bzAKeSXaAF6aLqtptppOrRQKTnhQoxuzBqog==
X-Received: by 2002:a17:906:3a55:b0:6ce:c2ee:3e10 with SMTP id a21-20020a1709063a5500b006cec2ee3e10mr214494ejf.210.1648045460145;
        Wed, 23 Mar 2022 07:24:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id jg22-20020a170907971600b006df9ff416ccsm7839ejc.137.2022.03.23.07.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 07:24:19 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <01c86f82-0c61-94c1-602c-f62d176c9ad7@gnu.org>
Date:   Wed, 23 Mar 2022 15:24:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: ping Re: [PATCH v4 0/2] x86: Fix ARCH_REQ_XCOMP_PERM and update
 the test
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, dave.hansen@linux.intel.com
Cc:     yang.zhong@intel.com, ravi.v.shankar@intel.com, mingo@redhat.com,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@alien8.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
References: <20220129173647.27981-1-chang.seok.bae@intel.com>
 <a0bded7d-5bc0-12b9-2aca-c1c92d958293@gnu.org> <87a6dgam7b.ffs@tglx>
 <877d8kakwg.ffs@tglx>
From:   Paolo Bonzini <bonzini@gnu.org>
In-Reply-To: <877d8kakwg.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/22 13:55, Thomas Gleixner wrote:
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1625,6 +1625,8 @@ static int __xstate_request_perm(u64 per
>   
>   	/* Calculate the resulting kernel state size */
>   	mask = permitted | requested;
> +	/* Take supervisor states into account */
> +	mask |= xfeatures_mask_supervisor();
>   	ksize = xstate_calculate_size(mask, compacted);
>   

This should be only added in for the !guest case.

Paolo
