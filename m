Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B95491E57
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345701AbiARDzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356918AbiARDyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 22:54:54 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87738C06175D
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 19:54:31 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id q13-20020a9d4b0d000000b0059b1209d708so2013649otf.10
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 19:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbBaRhq0Zl172wZjFD6mMT0O+mfQ7/gwQxGz/7ZESEw=;
        b=gRfcuuT1j/h0h++snV+0azr2NTp2dXTmL/7iBpO88Sm9O8kzlmj213Oz3xFMwGh8PL
         +lUlIH16CN9kdS5ljfI426WUpceaPGrlugHtY8ejXwV5Y17NLWNsF1bjmhyVnHjgWP4K
         LvfSGQY7v3sI5DyyODGziT+78AG6cRPSqJVaozM9XHX9s33i0sAHcV49DNlTWriwk4U6
         t0r/aBF+EKkAHYjJXD9hsBjTlrmdaqv9RjCWMsnphnN5WvneCfC7Q4eUDZH4E7DaxrYF
         GtPwTooeTtxnEnZbKz7YImers6XYk8x4bxGauiPqfGGCSwwbEFCA4ssK2R8zuHe+GD44
         egGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbBaRhq0Zl172wZjFD6mMT0O+mfQ7/gwQxGz/7ZESEw=;
        b=FLgbvHLK4yqD6kBqOyOyn9oSicytk1yVJv3haY7Ri+DW84wnyQXUHhMIDjqTEf2WU5
         Avf9y6xi95EPS035tzdaH1VW65JAWOvNPQO+STBh3dX9KJfHiDZspwMOmu3FgedoAm3w
         0j00gwhsaFK+GQj9/ZGiiSkG/rZxTPx544T61g/FPnBdI+ruB141AInfnHxctDjiEYdc
         ZDPiwPVaBVHdYeW8Cl4uB4LoZJyo+ZAdrrG0X/NABHSw4cZNQew/n1jKkmuK1faCZ55Z
         pmRBHudr2GEzVlGG0yHk1jRTU+HQnMV1CLxLXoY1IThXpBDilwnUe49QTLI2OFbM2Nno
         tqEg==
X-Gm-Message-State: AOAM531LT9N2kPK/czXf21WsrIBA+WxqEmyRXcp4OVkSEbQdiibzB24E
        B/ST7ex1ntlUDhctDwTVRdv+jifYsEtqfBFCrL93gg==
X-Google-Smtp-Source: ABdhPJztuFTJAskYbZKN3kZ8V6YI+W//Vkcww6VhLq+9TDPFxFaCO6o11iAv//nmCDJoMmBtj2sDkespnMW5lZ+Mky4=
X-Received: by 2002:a9d:d12:: with SMTP id 18mr16395258oti.75.1642478070388;
 Mon, 17 Jan 2022 19:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20211217124934.32893-1-wei.w.wang@intel.com>
In-Reply-To: <20211217124934.32893-1-wei.w.wang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 17 Jan 2022 19:54:19 -0800
Message-ID: <CALMp9eR18D6omo6kVTUXQ2enPpUBE=5oQWvQ5uiYu_0h6npE8A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 6:05 AM Wei Wang <wei.w.wang@intel.com> wrote:
>
> The fixed counter 3 is used for the Topdown metrics, which hasn't been
> enabled for KVM guests. Userspace accessing to it will fail as it's not
> included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
> which have this counter.
>
> To reproduce it on ICX+ machines, ./state_test reports:
> ==== Test Assertion Failure ====
> lib/x86_64/processor.c:1078: r == nmsrs
> pid=4564 tid=4564 - Argument list too long
> 1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
> 2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
> 3  0x00007fbe21ed5f92: ?? ??:0
> 4  0x000000000040264d: _start at ??:?
>  Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)
>
> With this patch, it works well.
>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Reviewed-and-tested-by: Jim Mattson <jmattson@google.com>

I believe this fixes commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
number of vPMU fixed counters to 3") from v5.9. Should this be cc'ed
to stable?
