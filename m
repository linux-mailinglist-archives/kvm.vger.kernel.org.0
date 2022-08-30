Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD35A6ADA
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiH3ReY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 13:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiH3Rd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 13:33:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9E9564F6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:30:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q9so11279069pgq.6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YQ8ZcpbXRjUN1AF+PorHGIrk4GnuSWoX8YJ2o7FF8qA=;
        b=e7cMo785PTbK7lQdEBG57/gp/Ipq1BCKVCh1ENIlKVPAr+BYXoS4rDG2wsGGbBey3p
         eNKJLDnb5eg3GNHnV/ST9qvvevVcnoXr1vIIeGVn8USdr0bPIJxl83j3yzK40VNlQnHl
         rzrf58riSAvaYykXGoY6MevmEyT2jHsUfCg2yAddhRE7t2qiuR10DKSK7KPVPC4hbd/w
         9IfFKWUvIbcCEizv+7h4CwiR/2SGHVZTDlyDneaMxhBTflzZhFoMfM163EpS+sneyDAC
         YMNsTJi2sDBUp2VkXt7/EoE1e6P7Gj6fAnc69RbT+XAtYdhiR2F28yNTTIESbHPLD5Z3
         HqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YQ8ZcpbXRjUN1AF+PorHGIrk4GnuSWoX8YJ2o7FF8qA=;
        b=ZgWIsmz6sufzKsEEbgJbXyfLWTugTO+ipp/z68Jq0euj6Mc/Y7A5G/Sb/fzBxY5GS8
         c1qkZX6MpkZjpqbU9UUsX1JCM3TZYGeT5AHWm7avc3efyo8g2nD5YPW8KtYN7WjeVB08
         REIvCoHDVYMViK1vgMxEgbMWy/iOY41yAcyDlwe8+ghI9U2gHkIyDQCo5pHZQCrK/fvw
         DIocgMZOovnLIRPHjt9ZbL/K7PhPeQCETJw15ga0kBFmrvJo6p3vPIBeOEB5WYbr1Z8r
         ZF+4ejLeyeq9xUTDJsywQTbH6Qcr/IraUnpEQHzzRmyVTdSK9jZnMvQqRAXr/xzxG6PX
         lTNg==
X-Gm-Message-State: ACgBeo2i1TWrSr/Ok4T1k7GLIqZZgBoT+TIYZj20Ei3Ns9gnCblVrQ5D
        NidVpRlCV1D2PceK41BIOzBR2w==
X-Google-Smtp-Source: AA6agR6ahQC3OgKadAHRpGKGebHE8Y2/JSHi4S1bjD4R//knQWK67U9OFqK0gXSTU9JortNXulmakQ==
X-Received: by 2002:a63:8143:0:b0:42b:9e2f:548e with SMTP id t64-20020a638143000000b0042b9e2f548emr13267763pgd.548.1661880544516;
        Tue, 30 Aug 2022 10:29:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g8-20020a17090a290800b001fb398e5e6esm8754499pjd.55.2022.08.30.10.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 10:29:04 -0700 (PDT)
Date:   Tue, 30 Aug 2022 17:29:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/8] x86/pmu: Corner cases fixes and
 optimization
Message-ID: <Yw5I3P4Vs5GGBtuJ@google.com>
References: <20220823093221.38075-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Like Xu wrote:
> Good well-designed tests can help us find more bugs, especially when
> the test steps differ from the Linux kernel behaviour in terms of the
> timing of access to virtualized hw resources.
> 
> In this patch series, there are three small optimization (006/007/008),
> one hardware surprise (001), and most of these fixes have stepped
> on my little toes.
> 
> Please feel free to run tests, add more or share comments.
> 
> Previous:
> https://lore.kernel.org/kvm/20220721103549.49543-1-likexu@tencent.com/
> https://lore.kernel.org/kvm/20220803130124.72340-1-likexu@tencent.com/
> 
> V2 -> V2 RESEND Changelog:
> - The "pebs_capable" fix has been merged into tip/perf/tree tree;
> - Move the other two AMD vPMU optimization here;

This is not a RESEND.  These things very much matter because I'm sitting here
trying to figure out whether I need to review this "v2", which is really v3, or
whether I can just review the real v2.

  Don't add "RESEND" when you are submitting a modified version of your
  patch or patch series - "RESEND" only applies to resubmission of a
  patch or patch series which have not been modified in any way from the
  previous submission.       
