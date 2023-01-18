Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2706728CA
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjART4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjART4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:56:01 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA20C59779
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:56:00 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g205so10013189pfb.6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YbDp48Q3hOOILfpZ0miUXgeu0J/2/eNOGKA2QWjFdrY=;
        b=BGM4BRxQCJT2FnyvgjsDQN3nIxysH7tavGrs+9D57hZNhRQKuDx+Ctx36iF4dlNiqN
         t9YMPn1ypfiqbU02AbvHA/eOFVSnMCpzvCm4wK7fEptST3UR7MZ6D2w0i4cFbbpDnapQ
         IGUBnnbQsVx+skyZTMGBzT6PMgFdq0sS5oAiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbDp48Q3hOOILfpZ0miUXgeu0J/2/eNOGKA2QWjFdrY=;
        b=EpAqn2rqQQPcm153t0XxkemlXKIUCSSK/FPlCAypOMaOuEeTnOnn+JZNxF8YsRAyGV
         DnXFLoURMz4PnGV7UQfY4HWXCXgjB74h0ph3tABfnWSvNhcHQLlA3tDFDKzVm6dcYyps
         xEzYA2Z91LyTsftlGndgMF64jEz9piSD1bDvugmg3uw0pLVm68NkzFZtZWu3mWdjbk2C
         DWVk6HW0CNexyBh2Jc6Fx3XFV6LeBErhFiN1ORqw8qw1wmL8lbzX2Ip2FOuNbn2EyjiI
         qZaMlCMfUAA8NCSY4PR66jKKAshKWRkYiZAHJrkeaaPxm2il8oqQBxAf6eynWxn5t84U
         3CEA==
X-Gm-Message-State: AFqh2kpaKg7VACABTarSM7J/KAGMDf0gLrMD+F+7xJF6618E8wV2TooY
        YYS19H++FihZ5Pxw2XunWaEmBQ==
X-Google-Smtp-Source: AMrXdXthGcvChMWQIWnae/fpCv6lXAcgU4mMzbDzrsC/VaLzjAzdIwXTMuYmmZQ6kBCLQlU538wSww==
X-Received: by 2002:a05:6a00:1496:b0:586:35dd:91c3 with SMTP id v22-20020a056a00149600b0058635dd91c3mr11464530pfu.29.1674071760426;
        Wed, 18 Jan 2023 11:56:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e128-20020a621e86000000b0058bc5f6426asm7538312pfe.169.2023.01.18.11.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 11:55:59 -0800 (PST)
Date:   Wed, 18 Jan 2023 11:55:59 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org
Subject: Re: Fw: [linux-next:master] BUILD REGRESSION
 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9
Message-ID: <202301181155.024C8C4@keescook>
References: <20230117132800.b18b01c3895c26e8d3d003aa@linux-foundation.org>
 <Y8hOJhFVn2sv0tsF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8hOJhFVn2sv0tsF@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 07:53:10PM +0000, Sean Christopherson wrote:
> +Kees, I'm guessing this came in through a hardening branch[*].  I assume using
> __DECLARE_FLEX_ARRAY isn't an option since this is a uapi header. :-/

Oh, er, no. That's valid in UAPI. I guess it's missing:

#include <stddef.h>

Let me send a patch. Sorry about that!

-- 
Kees Cook
