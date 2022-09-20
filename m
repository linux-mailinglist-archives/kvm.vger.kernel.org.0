Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A5A5BEFD6
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiITWMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 18:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiITWM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 18:12:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF3578230
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 15:12:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so2360815pjb.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 15:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=w71R3v9e1TW1/hjijYCzi0m5qWgThm+svmUEdVemzxU=;
        b=kCieer+t5VYBbHJPW8Y5P+qcDqbWaVCk+rzD3BbauqVhYOVkfjZUpDLNpquYTko5uq
         5Nd2E+cgxrEDd6zR4iZASbuxZ7TlZDrkaJAuZGRAWLc0kDnLXlhiBLtFWTWmZ1VoJpen
         s2bFYejIsKSeto3BVf8KYNuq34D81YNjIKEA+c7Pfqj60KBLMaOB16tbgAUS4Rfkf1Cw
         nItRu8NBP08BFfE95UVDAWvLv+K1XNF6E8mVlkxEdKH9Ond4EJmYAWtJtucpBEBzJZoG
         zKa4skrJ672hUBeNunLUxZvvip9GilqOfXKu3wUGBAgnIcYF1A4n3VwTj+UJ5orQYXoQ
         hIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=w71R3v9e1TW1/hjijYCzi0m5qWgThm+svmUEdVemzxU=;
        b=y2Kgltp+1h8YzFPqZIv4h2pyyzC3Jr5xkWaPywguHnAaY/tJfBWY0ohnyDGkWIiRcF
         0QHYjVtziasXzaRbbWUv1yfiyinBykE3P026WSEBYmLwr/EQh//04hdXf6n8CQZLWlpA
         SoXIKK0b/1QjP6VupyV0kv0ULRNdmuHDu7S7ndfRrOSNs0GZjb/4rQYW65NskU0hObmX
         DwMsqLFpRZjtWG1FFOKP2/CDRsPBfip6CAWC+9EqHeLMVXEASZ2g3XYT3oMeg5ZyRZ7h
         QwdQiU8zjW4crPeDxB4y14s+w8DSZG4wf6mSbKZH7O6M/UnBi/63n6+cYoo94pinRI71
         /G8g==
X-Gm-Message-State: ACrzQf2uk36pS5EP0sUGkCsw83VfWUhjs6L+5gR81sKkxna7AU3bVtYB
        VsMMsjEWLWSGhUNN5u0yHzoOJG4dVM3lcw==
X-Google-Smtp-Source: AMsMyM4sQy3TyqFwSK9Mscuurx+xz8IIxQWEE+ktbuy+7w8mMP9bdMzg6rETKgbLrYdvHsdMt0dOcA==
X-Received: by 2002:a17:902:efd2:b0:176:b888:2481 with SMTP id ja18-20020a170902efd200b00176b8882481mr1651637plb.144.1663711946914;
        Tue, 20 Sep 2022 15:12:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e23-20020aa79817000000b00540b35628a4sm416731pfl.123.2022.09.20.15.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 15:12:26 -0700 (PDT)
Date:   Tue, 20 Sep 2022 22:12:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Add missing trace points in emulator path
Message-ID: <Yyo6xqWO1G9wIn7Y@google.com>
References: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
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

On Fri, Sep 02, 2022, Hou Wenlong wrote:
> Some existed trace points are missing in emulator path, e.g.,
> RDMSR/WRMSR emulation and CR read/write emulation. However,
> if add those trace points in emulator common interfaces in
> arch/x86/kvm/x86.c, other instruction emulation may use those
> interfaces too and cause too much trace records. But add those
> trace points in em_* functions in arch/x86/kvm/emulate.c seems
> to be ugly. Luckily, RDMSR/WRMSR emulation uses a sepreate
> interface, so add trace points for RDMSR/WRMSR in emulator
> path is acceptable like normal path.
> 
> Changed from v1:
> - As Sean suggested, use X86EMUL_PROPAGATE_FAULT instead of
>   X86EMUL_UNHANDLEABLE for error path.
> - As Sean suggested, move "r < 0" handling into the set helper,
>   and add "r < 0" check in the get helper.
> 
> v1: https://lore.kernel.org/kvm/cover.1658913543.git.houwenlong.hwl@antgroup.com
> 
> Hou Wenlong (2):
>   KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
>   KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".
