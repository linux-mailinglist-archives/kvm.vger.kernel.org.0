Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE89F77D6C9
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbjHOXtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbjHOXtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:49:07 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A020219A1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:49:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26820567a96so6571972a91.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692143344; x=1692748144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ai3SS/R3qJXPIgXXmyKDtDH3gZg1gO3SDAYDOg5WW9Q=;
        b=qL0o/zzwWbC+nPTZcDOKZinDjbU5zFiimKkDX1J5X961L9H6U0W9qsGFkp6HIfEXjh
         boKELSrXzi56kK13RUTkLM8R6kPjyTgoFud59l2YOkvd4SKC9xpIKzUqY3mcqcISaaFu
         9AUO6+K55RP/8w1n3YTDC9i7kHk7137dscur348iJb709fXf7oAMil9noYzJr61P7Wc5
         CMeZbMdkwexKWEHpMjXkTi9/MQDmPdQoRec18zKxIsGXk4uHA1+3pPwzi/9UOiiA3H4W
         njinpZeZk+ONauAhhKwdjiKoe6ir9IhBe0T4cy2FHLK0mP6APDDtUrVA1cgOx7+3loTM
         rtzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692143344; x=1692748144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ai3SS/R3qJXPIgXXmyKDtDH3gZg1gO3SDAYDOg5WW9Q=;
        b=Myv9whENjTF+9XssBWlT5dEvaVDv9EE0gEK+WA9ZFibQT/aQOfq48izP4nJxkBJd1+
         6j75dkWF6llDAnextKZdzMJvVKY/7Ej3s+i1f86XtuTUeqOy1/dA+Ggx5cKthboSaFkA
         BqrRPu3ArtFsupFxY3fM1j7tSYdndLp3pG8ifVzHxBgUCHzZRVAZx6+iClfY3ISQRWnZ
         I2oqoo6PnMXePucBE2VdXQQTUHEHsrUimZBN9EJ4buEwu0FEMrN3UDAHBg1o34B1QYjJ
         XmKmILJCf58sERH5aY1E4Yac2XJcO1OdV5BH+VV9mqZnPv3PV6rmq19SAY5WXw8clhaI
         Y+ow==
X-Gm-Message-State: AOJu0YxEDY5q2kCL8EmsZx65z4p/LbasA9E5XgxcDbG/6uezX8IPAZrg
        zU5XuvUtNArmPoXEZGs2wnea7iJiQ9M=
X-Google-Smtp-Source: AGHT+IH7vc1KeKVIj6yt/VRvxDgt4h6tFx+r9b//eCMmm6tCscUVU057Cs6O3TY+qLcO3236WaD9nWwtAvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:894:b0:269:5af:d3fe with SMTP id
 bj20-20020a17090b089400b0026905afd3femr15444pjb.2.1692143344063; Tue, 15 Aug
 2023 16:49:04 -0700 (PDT)
Date:   Tue, 15 Aug 2023 16:49:02 -0700
In-Reply-To: <6adf6bdd-4ba5-991e-9547-deec36819898@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <6adf6bdd-4ba5-991e-9547-deec36819898@linux.intel.com>
Message-ID: <ZNwO7qInJ/zX0FLI@google.com>
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
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

On Tue, Aug 15, 2023, Binbin Wu wrote:
> Gentle ping.

I expect to get to this tomorrow.  Sorry for the delay.
