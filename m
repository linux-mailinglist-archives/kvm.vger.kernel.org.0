Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F157B7CDA
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 12:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242107AbjJDKJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 06:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242121AbjJDKJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 06:09:03 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED65FDC;
        Wed,  4 Oct 2023 03:08:58 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-9ad8bf9bfabso362456066b.3;
        Wed, 04 Oct 2023 03:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696414137; x=1697018937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QhjphZjPQubNUMGliWIijAtmmqyU7MZs7rGN2jMrbGo=;
        b=qQj8HJ70nvTp1NF0Lo4VPcuYJjfhTWMbzzYlmnNFilkXrjQvf1lEWKo77L4Oloyc5F
         ACmrtPx7ImYr2ANJMvpxJdYH2dkFhxB2xefg0CgHb0mzILh4TTJV53QiqiypkHk9PtqG
         AiHEJj42x/Q6XFIBlgeegHjU1iUjqV3XNzoEztULCdHFWj5iFzd7veOBbhSiLzf7M0Cq
         t3Zuu+IH3JwPvA5slZeZpWUxBbLtnYIxo7dB4fIb3NnEBVti3VXx1PZAZVploZOZl2WH
         AsNhdZHgndV+WhX+8KDIAQv+XdYbjcmFWCljl/uaSmPxWr8oNlhQ4xk3Xu3U6wAJ8xjN
         ApZA==
X-Gm-Message-State: AOJu0YwGpnNFfRfbrxJCiF5EHZZVa6+XpixKv4GZcCYDebsM+B702ZKB
        g7VuwWH6RgszRsh7w4jsOYE=
X-Google-Smtp-Source: AGHT+IHZ8RqXxikCuvn30AHVy3FvECZfZbdOBi/tpHCARpYUK7L9+TwTOGSlAS5+WsKPD82tRm2JXg==
X-Received: by 2002:a17:906:3ca1:b0:9a1:891b:6eed with SMTP id b1-20020a1709063ca100b009a1891b6eedmr1398348ejh.76.1696414137075;
        Wed, 04 Oct 2023 03:08:57 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-023.fbsv.net. [2a03:2880:31ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id g12-20020a170906594c00b00997e99a662bsm2534599ejr.20.2023.10.04.03.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 03:08:56 -0700 (PDT)
Date:   Wed, 4 Oct 2023 03:08:54 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, rcu@vger.kernel.org, rbc@meta.com
Subject: Re: kvm/x86: perf: Softlockup issue
Message-ID: <ZR05tlRqF9c09/l6@gmail.com>
References: <ZRwcpki67uhpAUKi@gmail.com>
 <CALMp9eSozxk-nuwWF3Xvg7fqC5doHKc5-6Nh40EnmzVRX+EQ4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSozxk-nuwWF3Xvg7fqC5doHKc5-6Nh40EnmzVRX+EQ4Q@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jim,

On Tue, Oct 03, 2023 at 07:36:48AM -0700, Jim Mattson wrote:
> On Tue, Oct 3, 2023 at 6:52 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > I've been pursuing a bug in a virtual machine (KVM) that I would like to share
> > in here. The VM gets stuck when running perf in a VM and getting soft lockups.
> >
> > The bug happens upstream (Linux 6.6-rc4 - 8a749fd1a8720d461). The same kernel
> > is being used in the host and in the guest.
> 
> Have you tried https://lore.kernel.org/kvm/169567819674.170423.4384853980629356216.b4-ty@google.com/?

Thanks for the heads-up. These two patches indeed fix the problem.
Thanks for getting the problem fixed.

Tested-by: Breno Leitao <leitao@debian.org>

Breno
