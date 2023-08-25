Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426BB78843E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbjHYKDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbjHYKDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 06:03:03 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26C1BE
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 03:03:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fee769fcc3so6087445e9.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 03:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692957780; x=1693562580;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kY08QU+d4mWdQ0tk6M3OcaOkEWEvY8tiOOSEuKl6UuA=;
        b=r8JfUO7KWaz2yP5UCx83o6gOtW9lVOb1FHNx2t0xC/VO3MTNxJgtKSkVy50nN7RkEb
         6fKKLXHdbJYZiWqqEtiH6x3e5puC0NZtO6xlLMPP6ZO6gX4R/WC2pnJsTQoXbsDk1eyZ
         pFDbpQ/oWfYcuTUBzhMQHeSfxZPswhA3UlAlpucZcP2z/E5nfhPRFCoGyJ+gupw0KhAx
         76h7ni/8a5B9JsXUdXi/cBdVRmRNGQUwwW930PNemAn4f1h+N5BTiV8XiO4mIpsyVCAq
         5cy9GYgpoFdUWksqf8Us1d2GvKi8p5pw/2NjtthzWm8raq+YRecA34rblsv0jwwqGcxt
         xpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692957780; x=1693562580;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kY08QU+d4mWdQ0tk6M3OcaOkEWEvY8tiOOSEuKl6UuA=;
        b=Ukpj8N+vlnvpg5DG08Zul36AN8AUmavDADeBSW0y8j/OMk8Ku9uEKP5gu6K/Yv1LrI
         XIdDFWBky5OrAYXCrJo8D55/uDeW9cXNgMQvgHaWEXkEii7mPYKze3FLPLB03ggCr8+s
         90SyY6KuxeOLit31rObJ1PjRGBRKChRHC/RuGK8vXtPZu/2d9LpcQHOFEGCf004G30MY
         XJSywHNrtnmNaYZWYggGWgfDvunIgCTded08BLx7A9rtXwGCzcC/E4RYkcE/+idExNyU
         hiLx+r1QAgYCq1bLqCzbY3zMXfpjfmBdckKMxLPR/GDGTjG3QM0s1Fm3ViYjmZuay6ML
         7nNA==
X-Gm-Message-State: AOJu0YwMsPy0I9TBB7LXJFDwPzBIQox4K/q+ptAX/lABMsjp+SM0Nnzc
        HSqQxpgc+pjiaclrtFk5vXo=
X-Google-Smtp-Source: AGHT+IE761JfNoeL6m1CDjrqlbvr6Dma1fChCAD47U5lpiYaunz235f0Bn1JLnTp4s5ifUBA9EldNQ==
X-Received: by 2002:a5d:4d85:0:b0:315:998d:6d25 with SMTP id b5-20020a5d4d85000000b00315998d6d25mr12678580wru.1.1692957779441;
        Fri, 25 Aug 2023 03:02:59 -0700 (PDT)
Received: from [10.95.145.119] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id z12-20020adff1cc000000b00317f29ad113sm1772305wro.32.2023.08.25.03.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Aug 2023 03:02:58 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <fe5bfc42-c940-b14e-d866-56ffb22313ca@xen.org>
Date:   Fri, 25 Aug 2023 11:02:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Reply-To: paul@xen.org
Subject: Re: [PATCH] i386/xen: Ignore VCPU_SSHOTTMR_future flag in
 set_singleshot_timer()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>
References: <5b30b245ba7714eb1420da43da979f9e8cb7e02c.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <5b30b245ba7714eb1420da43da979f9e8cb7e02c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2023 12:58, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Upstream Xen now ignores this flag¹, since the only guest kernel ever to
> use it was buggy.
> 
> ¹ https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> We do take an argument to emulate a specific Xen version, and
> *theoretically* we could ignore the VCPU_SSHOTTMR_future flag only if
> we're emulating Xen 4.17 or newer? But I don't think it's worth doing
> that (and QEMU won't be the only instance of Xen emulation or even real
> older Xen versions patched to ignore the flag).
> 
>   target/i386/kvm/xen-emu.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

