Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7C56FFBCD
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 23:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbjEKVVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbjEKVVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 17:21:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D8E2D74
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:21:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba6388fb324so5283631276.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683840093; x=1686432093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7AN2BvNktbQe4IJ/Ma5+Qdt3xfDpzDtC26faivHBV6c=;
        b=BKcFJ7hu1xebAJLYJhRcfxFDecbJkkJ5+lLHAKOMq8VWY3x2Hpn6bu5Fi6TcxN3ZLN
         P9q0N6HpZRymyBuMsuacMLGxXe+w7Peq5PMvfaPVEmlIpugJyyphz/8O9Ol8Ik3JRRwm
         QMn0lX5kiq/IZoWRVeI1dbBzkq5E+WDR2HCYzWd+MlKAfv8gtlyse/A4vn3Z1wgSb8Fk
         xxx9dg3JTte6bUu7QFgRmULuqUI4NJf3r2KOzQ3xZunLpqtsHVTEo2kKi2x829ThOsXN
         Lt7G2QeGRMf4T7jwEyevn6/qhDK+FsPbxLecBr0cRPx6KNIE3YI99NxW1vBmp2cFDlO3
         tYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683840093; x=1686432093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7AN2BvNktbQe4IJ/Ma5+Qdt3xfDpzDtC26faivHBV6c=;
        b=PKIzQTtGX5NoxTzGNHaD/WxMVu9+Q9ePVX0TWcVvBNUL5/iVOGVLaCMdlyJuBlzvyZ
         RToBH5Zvt0AoKJroKI2bUxGoohF7VYCl6JARvk584+DthZCAXhgMwMEb3yzsyasHAh3X
         JlCAQ9+XmCsSwTXNxGuuYY/GmMelvESbzXs5M+cgufcM497dXQ3bMBI3Upu7L1uhBZwS
         sI1oO2gOcWsxoosnsQpydiRcG5UwAvWdY8l3l4vkYNjlc/oVVEq8MxuCzj7+I6WBlykg
         o2dpqM3U8Q35c5NMr2DA5MBLsBK37MYLlb8RWcIADYGAuu+uTDtkzpZO8ucURunr87dz
         WqWA==
X-Gm-Message-State: AC+VfDxFZJ1dBizDi/82gYQPbk9OobHxmQYBNDUkBung2dctJorIWe2d
        OwimCjFbs2umhQtQKOGYfbHdvjQKdaI=
X-Google-Smtp-Source: ACHHUZ65Y9M6woJPmWD/+zgzxFToKLRUixqjQ0jcylLtFfR9DxtIY/wi/Uwmq4BLmxpz8Ac9dFTNxtOtqgU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:309:0:b0:ba6:a54d:1cae with SMTP id
 j9-20020a5b0309000000b00ba6a54d1caemr1694487ybp.0.1683840093708; Thu, 11 May
 2023 14:21:33 -0700 (PDT)
Date:   Thu, 11 May 2023 14:21:32 -0700
In-Reply-To: <20230508154943.30113-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230508154943.30113-1-minipli@grsecurity.net>
Message-ID: <ZF1cXOfcxiRfVJ5p@google.com>
Subject: Re: [PATCH 5.4 0/3] KVM CR0.WP series backport
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023, Mathias Krause wrote:
> This is a partial backport of the CR0.WP KVM series[1] to Linux v5.4. It
> limits itself to avoid TDP MMU unloading as making CR0.WP a guest owned
> bit turned out to be too much of an effort and the partial backport
> already being quite effective.
> 
> I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
> a grsecurity L1 VM. Below table shows the results (runtime in seconds,
> lower is better):
> 
>                           TDP    shadow
>     Linux v5.4.240       8.87s    56.8s
>     + patches            5.84s    55.4s
> 
> 
> This kernel version had no module parameter to control the TDP MMU
> setting, it's always enabled when EPT / NPT is. Therefore its meaning is
> likely what became "legacy" in newer kernels.
> 
> Please consider applying.

NAK, same problem as 5.10 and 5.15.  Sorry :-(
