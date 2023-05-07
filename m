Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149E26F9750
	for <lists+kvm@lfdr.de>; Sun,  7 May 2023 09:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjEGHc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 03:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjEGHc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 03:32:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F34B5FC3;
        Sun,  7 May 2023 00:32:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-643846c006fso3703240b3a.0;
        Sun, 07 May 2023 00:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683444747; x=1686036747;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=89+W8zJ6Mq/UfKqjwBOgpTmp6CEnn7ssQftyoTFkWt4=;
        b=ASxW3xn0fQmeqWl6ffccWL4RYTxX6LOpaLsz9F3eoc/PClKFBiCucLs2dwgwbyBczk
         +LZnp8MCZifVSssWNFRTkF/HufpsQpvpcJFuBYq4aF9qJFF7Yn7kN2Ez+ZOAh6nPbVKw
         gMQdz7cCQKkomr5Qut7sjwAhN/FzjZIb24ZN37NJmNedQgfTYGz74BzhcFla3PG8ca7n
         x//d9tzxCOQY/rgmkkhMRgJ2wL9U4JFpzYeeoDkSV3VPS/oBmsjuXLgIypB0J0dTfQbl
         irXjgDi7AF3JGzXs7rsgkEfSwLXW/SlizYRlVSbJIB5jTJwpkH3xbAbFqVZnKFw+AYsK
         +5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683444747; x=1686036747;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89+W8zJ6Mq/UfKqjwBOgpTmp6CEnn7ssQftyoTFkWt4=;
        b=JRjHcaRyZErrSXn/cw+dT8lf/MX2JSTxg4SBREI84DwAh5paiRHYm7D/Bmh28uH3t2
         9TxWGmmqRq7zd3cVWKPC4b2VmsxjGXnoZdYKWMsWK8hHiYSGvbzjZhEjaalcrBn9yrXF
         rQHT/z7X4pKaoxYoLz17FL1w6v1Tnz/pw5eHpDaUqqTRbOQXE8uHEqgtn4nTSWQ+b1ML
         RL/T9ZzFPSVYqDM5tnkHE5D+cuHfQ7ipDJFQK2jpbBl9yifxPFIMEx4XekIT1ope6Emo
         A8rimdvesD5eXdhz3dK0A+S0zuUMRc3+bRLDMEsu7u/0P34Hjoqw5UJV1Md1WolFKQ7e
         foGQ==
X-Gm-Message-State: AC+VfDwhHl+KH+V/W3VP9JuiUekvxlsnY2/fZTzOvbvLYW0dhay9TI0H
        WDeFwNDYc451659JeXO/F6DeYCT/k9+kMQ==
X-Google-Smtp-Source: ACHHUZ6eX+f7lR5nz9mBA4hqWBMLqujyZQTuaBAbqySDtXkVuoF5Gmfwe8iYybciNGPoSMPw8CvPYA==
X-Received: by 2002:a05:6a20:2445:b0:f6:28de:89e8 with SMTP id t5-20020a056a20244500b000f628de89e8mr9275496pzc.0.1683444746877;
        Sun, 07 May 2023 00:32:26 -0700 (PDT)
Received: from [172.27.232.43] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id n13-20020aa78a4d000000b0062de9ef6915sm4023989pfa.216.2023.05.07.00.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 00:32:26 -0700 (PDT)
Message-ID: <e70af22a-f09f-aadb-8353-35b29d2def61@gmail.com>
Date:   Sun, 7 May 2023 15:32:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP with TDP enabled
Content-Language: en-US
To:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-3-minipli@grsecurity.net>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20230322013731.102955-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2023 9:37 AM, Mathias Krause wrote:
> There is no need to unload the MMU roots with TDP enabled when only
> CR0.WP has changed -- the paging structures are still valid, only the
> permission bitmap needs to be updated.
> 
> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
> implement kernel W^X.
> 
> The optimization brings a huge performance gain for this case as the
> following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
> grsecurity L1 VM shows (runtime in seconds, lower is better):
> 
>                         legacy     TDP    shadow
> kvm-x86/next@d8708b     8.43s    9.45s    70.3s
>               +patch     5.39s    5.63s    70.2s
> 
> For legacy MMU this is ~36% faster, for TTP MMU even ~40% faster. 

TTP --> TDP

>   void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>   {
> +	/*
> +	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
> +	 * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata needs
> +	 * to be updated, e.g. so that emulating guest translations does the
> +	 * right thing, but there's no need to unload the root as CR0.WP
> +	 * doesn't affect SPTEs.
> +	 */
> +	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {

Curiously, this patch only affects tdp_enabled, why does legacy MMU also 
see comparable performance gains?
