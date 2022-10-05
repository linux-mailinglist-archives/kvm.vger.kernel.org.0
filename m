Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28675F5D2B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJEXSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJEXSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:18:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1127E857F4
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:18:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n7so165511plp.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JNwoGL1n07m0yO1AnZ6fH4M5ZUN13BRxbClxXHPjGyU=;
        b=qBzzSGtdv5pnVVb7CxXRK4Q5pJhImK/V0tkGXZtO6uMO4yAwXw4NBMswSalXTlabGU
         pqM148e2O8lj9FwM7LBEkApswweJsxtLGlVEkcxqtKiojBg8x1wCMaHIAMogbwcNidap
         WBo7ONJ59ysFWKZy0V86n8cF1/S+DSL8rBO85gcGEQ9Uq10AQM515yYyi2EWMDLq97QH
         RJc8y9VWGhq5m3lkePWEhjo7ENpLVxxoaEcqfuwIzVB+Ds9+iSU2SrKvZiCAQEnkH7xc
         Qvik40yuiNUJbDpeie9nx+RXaeAK5cz8oJCLcqXb0/rflBPTM+k8p75nYzzaaGBxx+gn
         EJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNwoGL1n07m0yO1AnZ6fH4M5ZUN13BRxbClxXHPjGyU=;
        b=zGKCbubiF/vBu+08sVEQ684bTJHDUIFqHqCNz6gzlJeErkrw5yz58bVpJhwhXwcw4O
         fDxyGGMI1ynFi4KOB7MImkpun2ooQfY6edxl7sWb9WO9urX9cf8ZjLuX1hfby3PvU33m
         UyD9zPUvhCfbQl5laquNsV0EISAIlzmDCbaw1jYRCxK12xdtaNQihSaDOnraAd5HkYLo
         KIxFh8HB21yNqjfLn3v/rczdzl2dPqxoDQKFqezaxjwq6qXwI7fbPMqgqBu/xoIcneJ0
         trwosUlr8crY1LiRY4vWin7SB8KtrS1liIWAWtTUeg8c0VCWWz62kLHiVL5vx6ZghWyy
         DZ7Q==
X-Gm-Message-State: ACrzQf2QuuYzoRTw3OKehbQXMTHG5UKNHbvolmtcIwj/pvtrXdiZ09xD
        mxYscRiEAc6A2b/PAuj9WtJ7gA==
X-Google-Smtp-Source: AMsMyM5HZGwAs5is0JJWLyBZG04HMJ5LDwjZ197HbyqPNCRKyl3JRP0d8+qyTudM/nX9C8sj9Ezy+A==
X-Received: by 2002:a17:902:f64f:b0:179:edcc:2bf4 with SMTP id m15-20020a170902f64f00b00179edcc2bf4mr1943290plg.70.1665011889486;
        Wed, 05 Oct 2022 16:18:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b00178b77b7e71sm11092489plg.188.2022.10.05.16.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 16:18:08 -0700 (PDT)
Date:   Wed, 5 Oct 2022 23:18:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: remove obsolete kvm_mmu_gva_to_gpa_fetch()
Message-ID: <Yz4QrT+RHzXy2eaz@google.com>
References: <20220913090537.25195-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913090537.25195-1-linmiaohe@huawei.com>
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

On Tue, Sep 13, 2022, Miaohe Lin wrote:
> There's no caller. Remove it.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
