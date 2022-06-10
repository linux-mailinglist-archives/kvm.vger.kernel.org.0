Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD61545AEA
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 06:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiFJEQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 00:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiFJEQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 00:16:24 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679C760C6
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 21:16:18 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w16so24417443oie.5
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 21:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hkGa/PDuyzntrwdlXUO76bHwmviUPpWbtzdxGwAtZFA=;
        b=MONVFrjDmw5TNZl+N7xic7WrT6pFbIwGQHtmMCmUKvaL2wMtwOJh4slUmYhpLWRtwC
         Gr5ABDbGtCt0q8wKhZPIib/aLxg33emm67OOJtg3PhnmnrHKuR6i5eBUOwB6lQPi4/Qe
         EtjoOy7Ukdvp5VWh//qc8bhfMzIdSfk1k3jo7F66kfU+WKjRI+WSSB4v4sLziOV6mT7k
         rBcasiLw6d9KP4KsvlyxrxCvOFfwizuDU96P+BMQkuMPVDBkZ5hFOLTPy6mFsPHBOHOQ
         vfqsHnUzEeq4f/4ahIfacF4fgYz9qqAPOCJWUFJJWaFmSujFINw7Z329DruWh6/j7J1c
         OjIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hkGa/PDuyzntrwdlXUO76bHwmviUPpWbtzdxGwAtZFA=;
        b=gSPGVPQwTCSgqhGZ4esWdxv0Y5q6NHiArCGHlsf8OdBwb1y9BNzxmxporNjMUXmX9z
         cC9By53gCpT8jRd56FtHpB5e9Vzuag9cP/irn0mI39qMvv2XS0QczV9+Uwih0Sqt83o0
         sJ7cLE3wdcqJN7LMyDOlnF/yDUrhILzeHXb+vW9JuAkdTaSJb0WVoCh0VIH76XR+UeQg
         cYuD3lZY4z++MO9e2Y1ruzeSzxI4rJecZ7G0ciCf/wEYugC5jp3V6tKZF6VdvUUQoWdX
         6QezzhuDG/o16x6gcUdvWa3U/OPxNJsfuslekKfKCQra0/5KEK1GkdMDk9QBeIzFQedR
         Rhfw==
X-Gm-Message-State: AOAM530MDGfg7dlbeIgsQljJ6bcubyxBwpIz1YO0t6pcMcD1S+DXBFpe
        8ZbXf2JjR0B1QegOqy+23hWP7Hwr7AeWSX0Mwq3j3D51FKA1tg==
X-Google-Smtp-Source: ABdhPJzt3NnZQ0tVOpU7+w0Qr11+2eGZl5EtENbkKzpWP2q0OxZ2Sg28ZvJaz6FfQ/Ny5S2moCNGmbq4TPrbBLNSNBQ=
X-Received: by 2002:a05:6808:1189:b0:32b:7fb5:f443 with SMTP id
 j9-20020a056808118900b0032b7fb5f443mr3643613oil.269.1654834577419; Thu, 09
 Jun 2022 21:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com> <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com> <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
 <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com>
In-Reply-To: <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jun 2022 21:16:06 -0700
Message-ID: <CALMp9eQL1YmS+Ysn7ZPQjcha6HoqALNVTBqTLO7iTFpZMgyUAg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Yang, Weijiang" <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 9, 2022 at 7:49 PM Like Xu <like.xu.linux@gmail.com> wrote:

> RDPMC Intel Operation:
>
> MSCB = Most Significant Counter Bit (* Model-specific *)
> IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported
> counter))
>         THEN
>                 EAX := counter[31:0];
>                 EDX := ZeroExtend(counter[MSCB:32]);
>         ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
>                 #GP(0);
> FI;
>
> Therefore, we will not have a #GP if !enable_pmu for legacy or future user space
> programs.

I beg to differ. Continue on a bit further...

#GP If an invalid performance counter index is specified.

If !enable_pmu, no performance counters are supported by kvm. Hence,
all performance counter indices are invalid.

The only CPUs for which one might argue that userspace could
reasonably assume that some PMCs are valid, in spite of
CPUID.0AH:EAX[7:0]=0, are the three legacy families I mentioned
previously.
