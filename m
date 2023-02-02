Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3456884DC
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 17:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjBBQyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 11:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjBBQyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 11:54:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFB265EF4
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 08:54:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o13so2481910pjg.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 08:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kJ0f+4Iwz0HTx72kqcZhrtmrN9bqGK8Yuq0L/qHX1RY=;
        b=GLI9HOIIiGV2fz7Lz2VE0L33ilmcX5dUj/q2VCLqWJNf7qOOrTlbzJ/4YWvYplyE6P
         v+ln41+zoFGdFbTKo6OQjPVe2SGLwLpanKAp4asNAJ44vuVKts7tXEjOI+fYpbO//onz
         uksE9/6Co2grJR0k5p6gKF9/O6TS0nBbqf81sYuS2dIq7517aU4AAQbp+Lb1Gu3LmknT
         ljnp5A9VdumEESA3wLC0QuahI/FPLQHE/b7w0Unk65zS6UpKgImxGAkws67XDfvC8x1i
         C5lIqVTJJyH4mTyo8XU2C/yH+bEx1cZAbaxgDmoWfnOODNFCraOvofnGNnF/PUd20FWW
         k8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJ0f+4Iwz0HTx72kqcZhrtmrN9bqGK8Yuq0L/qHX1RY=;
        b=unhtyFtP6UIS9yYbZXzmOGc+4gLsB7T83JHRULquinhZoBt8aln1mrPHAcSYMtKkoi
         TMCNuXDOJmBrPtxiTMCqcfqfTEMQgDAer98+e6LbufzGl0q+tPYUgYHyyjQe8NncnAT7
         /J+Y7L1Xzqj6CFOFobkSlRtCbSH6Jo7xGktKJRUdEWtmU6tv7P/NDhUFRkjV4JtjlvlZ
         G4vu0SbWs8GhAqIH5mrjjMvYSV70rfGuzOppTWxkzgRj0YhzBDUrBY6nde+jTMQsPuQG
         uQgz2D2As2QbeymOIZdKnv1ZG39tE6lrlBN/3YWZDa24VUn3yJFtYF8V4LPb8ZHdKXtH
         tIPA==
X-Gm-Message-State: AO0yUKWm4GZo/msNEEmY4qwn/ZbQtis+RTmE68u1jAE/5jcqKMkdZQvf
        vMZv+q7q2AX7hDBJm2BlXrtZUA==
X-Google-Smtp-Source: AK7set+M0Z80ydD51nFkK20U+pZI6GsENTemYMjeMn4MHSx4d6nk7oBuRjJJBaqXGuxuTCwycUMpPA==
X-Received: by 2002:a17:902:e84c:b0:198:9f0c:a8f with SMTP id t12-20020a170902e84c00b001989f0c0a8fmr9541662plg.21.1675356859642;
        Thu, 02 Feb 2023 08:54:19 -0800 (PST)
Received: from [192.168.50.194] (rrcs-173-197-98-118.west.biz.rr.com. [173.197.98.118])
        by smtp.gmail.com with ESMTPSA id jd13-20020a170903260d00b0019893d572bfsm6101413plb.211.2023.02.02.08.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 08:54:19 -0800 (PST)
Message-ID: <3df923b9-ff6b-c378-2416-1a215709db72@linaro.org>
Date:   Thu, 2 Feb 2023 06:54:14 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 04/39] target/riscv: Add vclmulh.vv decoding, translation
 and execution support
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-5-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230202124230.295997-5-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/23 02:41, Lawrence Hunter wrote:
> +static void do_vclmulh_vv(void *vd, void *vs1, void *vs2, int i)
> +{
> +    __uint128_t result = 0;

In passing, you may not use __uint128_t directly, as it is not supported on all hosts. 
Philipp has given you good advice on adjusting the computation.


r~
