Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DEE7270FC
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjFGV4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjFGV4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:56:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521E4269A
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:56:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8c3186735so11322050276.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174976; x=1688766976;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q70DbX23LQKAa10Wwol/OMAx4WJbhJj/87v7cVDjDPk=;
        b=d+Tiqc9IiKGT2Da8oD6vSXM4b2WaQPMr/z1QkLYSLlPZ/uyDuGsGaOxCS9wXcf3DBX
         5LLdJf8Vx7y6FEjw0bfPPekgvbMYcqMSzw/bXfmFDFc0N41arYQgeXGvDUODuY6RQa+J
         O+TcgMuRW5eF9EZSPmGPpkPhcyvT5nmzfiMQplC4tPr11jsGAE6M3YDAr+hbw5r9kVTn
         YG4UKnz+WSBmELQpTYus46DV5hyxn0Y5w5ldSYBQj/ZjwoitDI+9wE9xGVKiJlDse7fa
         SrJajB4PAyIe/FEmhqOq8Wcz4GDzSffHSlTFeYNLQlXbFxSjH2o3BPBF5orzOH+/CAhw
         WVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174976; x=1688766976;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q70DbX23LQKAa10Wwol/OMAx4WJbhJj/87v7cVDjDPk=;
        b=XXDbmyOxRqkIQ5n8uBaDcT+i46src5ghkY0ilkKPdkQ+bfckeUxA8lYD8cAgPwii1m
         9tmfaoHmN1+c6S4B4vgwp0W+e+/FXlBHC/pR+UEaDja7QtLVQo4dgRQYdGFXhxR7CnuM
         /1SlXwPvdkLF0zfJIkzGat32M8VYcWo23Dteq5TOq6QQ6j6kQzI9ljM86z0BBhqfbxtw
         O8kisDFcy8g2f6PJloyGmm9Hykfd7QE13ip77W2IW4FuDl/Ox8ojaLP7IPLnofY0cvgs
         sev6HpUm//n9+TR2Rzn7JPerR/OMpX4VUEyrI+erV/3wuMhdr8T8TL0WAZcvNBZQVLC3
         0blQ==
X-Gm-Message-State: AC+VfDxknszLMIMQpqafCERRtAMLzlEw34gXgzaqoRdcW5cMlUtn4NmF
        12U0Bbxtv+WRNqMyy6cdyDmcjvRr0MA=
X-Google-Smtp-Source: ACHHUZ7AboJ4lIvZemjpD5/WAWnDJGV4RRmilep6KW1uRwpG2Aey6pUK46qJp9dWOo7cXy068jNjRuGmapM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1882:b0:bab:a1e6:c87d with SMTP id
 cj2-20020a056902188200b00baba1e6c87dmr2644932ybb.4.1686174976792; Wed, 07 Jun
 2023 14:56:16 -0700 (PDT)
Date:   Wed, 7 Jun 2023 14:56:15 -0700
In-Reply-To: <20230607212111.1579831-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607212111.1579831-1-seanjc@google.com>
Message-ID: <ZID8/5McZlNRJrPZ@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Truncate reserved bits for
 emulated test of full width writes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Sean Christopherson wrote:
> Mask off reserved bits when stuffing PMCs with full-width writes in the
> forced emulation subtest, otherwise the test may fail due to attempting
> to set reserved bits.
> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Gah, Like already posted a fix, I just misread his patch at first glance.

https://lore.kernel.org/all/20221226075412.61167-3-likexu@tencent.com
