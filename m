Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD1240BDE
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 19:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgHJRYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 13:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgHJRYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 13:24:13 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5845C061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 10:24:12 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id v6so7878459ota.13
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 10:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/oqGxSbdXPMBHiIFcyGFXFYT4+IRpQtxuVCBuG+/4ds=;
        b=aBTHePXUn2+yrfuYa2HhvnUnzxa7MREk/7t+ChAPoIMUEKeHauDVTGAjsbfzMjserz
         TGD1xcvc/Kijuh6oOip8kqSGKKCgCD+XLPJcvl/5H9LRvqYoFsiFMAVCsaTnQfKH2Ufr
         rgJ24EVqansBvFDpeDdV+r/yLnyLrl9OkXwq5kKSlbcPfdLKV475L4FhgTPr13bHdjd2
         usxarcQ7KufoAhpYzHo2pc1XwXSLUBQSnbURey8sZ979xGgBptJ4fPj2e6ZtilZUgwhe
         zEfBF+t2nWj0M0agwaIPKxq9IBm4MoM3zoe/9EMuU+WqkI0QDg/MNFddSeifoMIbIhTl
         p/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/oqGxSbdXPMBHiIFcyGFXFYT4+IRpQtxuVCBuG+/4ds=;
        b=P05AaZ0h4VwZmvT1C0ItlRXSd/j0yfF+JIexHv8IehtM5BaS+7RUBhK/SUp92/0xXh
         Y4ysqzrTYVpUzXDjE2VewJdCxWHTpn6ZXzZ7Lj7zepeY2JS8vblBfXC9A8O9ny7tVVnX
         CzqBqo/ZbJTLFhB/dP2Hs1uWlMDUrH7HYLt7vKtAsMMtqzXktI+GgvezzlFuZwm+PGR5
         hDwLU3hiasvyKia5pi4PqPDf7aD3NC7sdTxBGP+NdJ8CuKhJ18Rh3EbBAbUZD1VxFtuE
         ZLbq4iMC/JQI+AXlYgcrUBhiOzW5iEeR1Ygs3l/bVrwF9odiLSfAih5zTvM3b3HmSKtY
         IeOw==
X-Gm-Message-State: AOAM533AyJodYob50SF00gqyARuY4jfZO5ZJRoUbrsBG4G/OHUnVW287
        Jyft3FwzSv88Hieyt6m3MUyl67wHD2m3MHqkfn7TJA==
X-Google-Smtp-Source: ABdhPJyzYRKF1sxaqjUAhkVLrPI+BtGXc1f2RvIK4uUMhjE4gcxBTEaArrYXIelmZyI19tzp7hb4Wg47lbmG30H21pw=
X-Received: by 2002:a9d:65ca:: with SMTP id z10mr1698532oth.295.1597080251945;
 Mon, 10 Aug 2020 10:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-7-aaronlewis@google.com> <db97d3bc-801e-2adc-9351-0f536561c279@amazon.com>
In-Reply-To: <db97d3bc-801e-2adc-9351-0f536561c279@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Aug 2020 10:24:00 -0700
Message-ID: <CALMp9eScA9SBJfYcnnDUH9mujvBsYmhyD5nC8XhorrxmBBv03g@mail.gmail.com>
Subject: Re: [PATCH 6/6] selftests: kvm: Add test to exercise userspace MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 4:28 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.08.20 06:20, Aaron Lewis wrote:

> > +       __asm__ __volatile__("rdmsr_start: rdmsr; rdmsr_end:" :
> > +                       "=a"(a), "=d"(d) : "c"(msr) : "memory");
>
> I personally would find
>
> asm volatile("rdmsr_start:");
> r = rdmsr(msr);
> asm volatile("rdmsr_end:");
>
> more readable. Same for wrmsr.

I don't think the suggested approach is guaranteed to work, because "r
= rdmsr(msr)" isn't always going to be a single instruction. The
compiler may do some register shuffling before and/or after the rdmsr
instruction itself, and I believe Aaron wants the labels immediately
before and after the rdmsr instruction.
