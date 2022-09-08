Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7095B29FF
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIHXPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIHXPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:15:07 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C172CC99
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:15:06 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-11eab59db71so48415670fac.11
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=x84tAzemIZD1nMC7iUsQKY4UVtWo/vfIUvZtcXbQwZI=;
        b=d2eDFZ5jZL+0zQOD2kyntF4UPUCwmmTg33IlQRUfzlOhmTfpZrtBlgD01+9Dn8o+Ut
         BmUpqnJ7xIzsL3uERZqKTla68Av96gvy3bc5xrucPdZVUr/gXRMWz8YA79xzKL0kb8+l
         0DB13SkzysD1UfJaO/TA2tHw0BtLgV9EBR6hADRafKyKoS3OEujOHUx8j0BtVYmU7V+U
         WTOca5RXzw45XLtIFej8+mRacT5odAeSy0o/Z6rKGXolehQenvGHIR2ddrU3cMXBi7tw
         IFDxN3Ge9p3BzkZ6T/Xvh+erEAAAamWApPGgJK52ztldLH7B92yl5wkqzoLlrUMKDqWy
         haTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=x84tAzemIZD1nMC7iUsQKY4UVtWo/vfIUvZtcXbQwZI=;
        b=EZCssFTT3162wNm/5RjLReN2iYziHgE0mthScseRwQfx0l0Vse6TNY1d85yFhVSHz/
         EW3iNdYrjkJs3FQSkQ4FSRF1EoZhuXfCYvf1s9bDJBnpm3AQk6MBjspOdbt30twVf76i
         4prDhfRR4a2Y21/INFqojPGYZXGIskftVYNrVf1spltkphW9o9VGNGU+1usmO0t3CM48
         fI0NLLS0w57VAWsgFvqs8V7Qh4Gn9o5S+w9BfymKIsFfa+fHyP6gVVdyg8D0iVa79dbq
         lVniifpPuEAnUxX84uQxu+yDV+YSD+pC9Yr6325x0vpn8LQYvNDw3gEukug+ZFnYgmSa
         AROQ==
X-Gm-Message-State: ACgBeo21SaQwdo+qEd30PrXNW7MTmc11rDwNi5yNbzsSAbbSnQ2lG7EY
        9j6yOBCBujSJOY3E16rHJXAoiKI8BQUDL4LifJgAdQ==
X-Google-Smtp-Source: AA6agR7CwKt1OV3kKEsMuvPZSIPAv9IzGPf7ihw3Dnrzsn+52gqwAYfYl0ZJ8OnpFIUdKljVaqq1xP9nSxZgHiYKjmg=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr2456127oiw.112.1662678905621; Thu, 08
 Sep 2022 16:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com> <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
 <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com> <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
 <c07eb8bf-67fc-c645-18f2-cd1623c7a093@amd.com> <c6559d3e-38ec-9a2c-7698-995eb9f265c6@gmail.com>
 <63e6c2da-653f-6f0d-8d56-f1c24122c76d@amd.com>
In-Reply-To: <63e6c2da-653f-6f0d-8d56-f1c24122c76d@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 8 Sep 2022 16:14:54 -0700
Message-ID: <CALMp9eQObuiJGV=YrAU9Fw+KoXfJtZMJ-KUs-qCOVd+R9zGBpw@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 7, 2022 at 11:00 PM Sandipan Das <sandipan.das@amd.com> wrote:
> This is the suggested method for detecting the number of counters:
>
>   If CPUID Fn8000_0022_EAX[PerfMonV2] is set, then use the new interface in
>   CPUID Fn8000_0022_EBX to determine the number of counters.
>
>   Else if CPUID Fn8000_0001_ECX[PerfCtrExtCore] is set, then six counters
>   are available.
>
>   Else, four legacy counters are available.
>
> There will be an APM update that will have this information in the
> "Detecting Hardware Support for Performance Counters" section.

Nonetheless, for compatibility with old software, Fn8000_0022_EBX can
never report less than four counters (or six, if
Fn8000_0001_ECX[PerfCtrExtCore] is set).
