Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7688588C49
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiHCMjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiHCMje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:39:34 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E834C24BDF
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 05:39:32 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id bb16so19720015oib.11
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 05:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=BTGHx16QK/ZyJ8XnHN8yrExP4SwB3/TppkdkcnSErPE=;
        b=LiUJ4PmA2ryKFx3WQcnn+uFoV1eGk+kN0FU/QzH27A0g9liPwG7ZHTG5BMwAo6pS4j
         dCf4143b61C2sCjTJvZiyVD/FQLUWJhXTSV2DfXMYHoPW/oN4qRdsovFI802muVoX3ZB
         MnGzbSicSpBz440sT+VJAlax5n3Sqlsqu+uGTkW541gxBfQk7dCVl8q0cXLGRRs7v/Tv
         pMh8+4LQdyVGj3wfIITmBCbPM5jf/rphiRDo4iyn9xiMrBaykytpPoCe1S7UIcpTCEz7
         SWPDbxmE4rJYlh67Tz9Qnl+ypyOGHpqpsdgapNZE5aAAphhu4CPrviwvghv3rxpSzS7Q
         W8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=BTGHx16QK/ZyJ8XnHN8yrExP4SwB3/TppkdkcnSErPE=;
        b=jRKPMAklLtObnYY7GgezE4DunbCGMf4Ofi/PICESgWM1+OO99SW7nK5EYaDYkV1gN3
         +1LaI6y24lpd29tzrLvBSFlVfzyj7wGZY+GpEIfdPFruqQkx4R3zCMo8A829/pGO/vo4
         b81qk6PHDoIwFD8DQHQZsPerNJ12ebnKcR3OcS3y4hYOmxNb7uKb79yRBaJrW79+nSf5
         1W4+3ovMM4lQR5UDZHfyLymyKyXLxiKAtDVLlSJJ2nN6pEnn7/CAgUGHXQSRLY08HIqB
         5xNXpRgslGFZqbqf7Edgo9lf3NPTj3KDepjUnNe4iZrmaofQrqVCNXkpLUPAJ77VXqaF
         UGXg==
X-Gm-Message-State: ACgBeo3JXqnNhXz/IzUf/EaBHMut1JrgO15ICByToWIgh347V66LySmU
        BtdQmpmy8WE5jneo2E3x3gocIAfGsy9R3KeUo2Npc3Eu3Wc=
X-Google-Smtp-Source: AA6agR4QXZGX1HJ1V2f+EyMVrovnb2zAtZVKUqpXUeCUmsn/DBTomdpkzjpCGVLeMGrCLXNKoxKP2BS+ZWgHHubu5Mk=
X-Received: by 2002:a05:6808:f12:b0:33e:c452:9ce9 with SMTP id
 m18-20020a0568080f1200b0033ec4529ce9mr1548015oiw.181.1659530371813; Wed, 03
 Aug 2022 05:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220722230157.2429624-1-jmattson@google.com>
In-Reply-To: <20220722230157.2429624-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 3 Aug 2022 05:39:19 -0700
Message-ID: <CALMp9eSkB8KN4sm==VOZWaa1jJfzoiPWen4OGE0fTdAHSdGxzQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: kvmclock: Fix a non-prototype
 function declaration
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jul 22, 2022 at 4:02 PM Jim Mattson <jmattson@google.com> wrote:
>
> Avoid a -Wstrict-prototypes clang warning.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  x86/kvmclock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/kvmclock.c b/x86/kvmclock.c
> index f190048c9bde..f9f21032fea9 100644
> --- a/x86/kvmclock.c
> +++ b/x86/kvmclock.c
> @@ -222,7 +222,7 @@ static cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>         return ret;
>  }
>
> -cycle_t kvm_clock_read()
> +cycle_t kvm_clock_read(void)
>  {
>          struct pvclock_vcpu_time_info *src;
>          cycle_t ret;
> --
> 2.37.1.359.gd136c6c3e2-goog

Ping.
