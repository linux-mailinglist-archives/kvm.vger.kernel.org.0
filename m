Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD95FEA25
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 10:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJNIIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 04:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJNII3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 04:08:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89551B94F8;
        Fri, 14 Oct 2022 01:08:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so7200277pjq.3;
        Fri, 14 Oct 2022 01:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xK6fW6kMOZrKxJ/R2Pth+02xZVi1100jXJMyRN3sdFA=;
        b=q6uPo73rme15pNGc4xGwAR+kgjRuWGN1DysiYNhK5scYe0eQ1AaB1LFKezo2y3VsNI
         N3Uq+5vLyisVGzH7aAinoakWeh1XBNcte9TyTL5VhQLWzMhbWGhTVJMAflCb36TYS/Qf
         erLBavfYxP277WshVx7nuXOrits6jJZr/GnKuT28ljKLj4TChdfEdhnDuDm6QqcoajEI
         TDcb/ZUtkgVrSdHVN5wcGMfYk/HdOs0ihdJbR84wrOrAbKOpr5U+8M8oosRKFECbUB7c
         pC+mjCFDM+ixqu7pSb5KYAJxAS8F+Dlq7kLKHWLCm73YCQH4IcctuMnChmQcr7DrURUP
         VffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK6fW6kMOZrKxJ/R2Pth+02xZVi1100jXJMyRN3sdFA=;
        b=r7d0tbr/0q6SuTYsEuTExVwpeUmtOsUfZ/eMESCCtaovKHPie4ZKC92/jWexVBtZDH
         /CIEpeKrYa62Da6Y0HaEPeJXCO3/3Wll1TiiPGn4qfqyOv15NU79QUrWcV382LB1n7KC
         sjNnoJT5KYbW3lVUBZwHHqEWjJW9zcIJ0DDCXgZlGNzjIcqr3hHX+Onr+vp9SSPSLoXB
         UpZgiRh2pvPvJBX1wGZ8Te3TAkRFg7BPygjuuO9ki14Q1q7eS2hKOh+P7xZU9KHhPeyP
         Qyc6JeKszffF6P05qxYqrITvK2/LUnfk73miqjTs36HXS7vnLXf+mCK7a2ZFG8A03TI1
         Qnwg==
X-Gm-Message-State: ACrzQf0SGy50sCvOdvTDq7TJVdxtezb1LYLnKjbqbA77B0zOaaeZ8Cgf
        0P7nu9KMQWBDvqXM4HhrTD0=
X-Google-Smtp-Source: AMsMyM589E3hvhE2jFPeWoKcf+kXiB3ru4Ti4mpBLpL3oeyDinCSIpcVWKaAm1rZM6s7nvBxdqWMBg==
X-Received: by 2002:a17:902:d70a:b0:178:5d52:9e41 with SMTP id w10-20020a170902d70a00b001785d529e41mr3903681ply.0.1665734908345;
        Fri, 14 Oct 2022 01:08:28 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 138-20020a621490000000b00563b31c9e0csm1017486pfu.34.2022.10.14.01.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 01:08:27 -0700 (PDT)
Message-ID: <341cffc3-d0b9-2ef7-3c6e-c48ea179699b@gmail.com>
Date:   Fri, 14 Oct 2022 16:08:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v3 5/7] KVM: x86/pmu: Defer counter emulated overflow via
 pmc->prev_counter
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220831085328.45489-1-likexu@tencent.com>
 <20220831085328.45489-6-likexu@tencent.com> <Yyz2x5bSR/7ZTV0R@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yyz2x5bSR/7ZTV0R@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/9/2022 7:59 am, Sean Christopherson wrote:
> The bigger issue is that calling __kvm_perf_overflow() here can get false negatives.
> If reprogramming fails due to contention, the reprogram_pmi bit will be left set
> and so this check in __kvm_perf_overflow() will suppress the PMI.

I understand your motivation, and before we reprocess on "left set reprogram_pmi 
bit",
we may need reproducible cases to cover "reprogramming fails".
