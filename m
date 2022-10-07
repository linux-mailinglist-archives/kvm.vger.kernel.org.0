Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DDF5F7E21
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJGTid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJGTiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:38:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B260910B788
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:38:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n7so5454072plp.1
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 12:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3rrcXpuZKRM+KusxikaUH8D4u3EuQEaFpgWMrgs+cjc=;
        b=HDD9/5jA8tDMlJhLAIdy30TF+iTMHSUbr/TR1j6RQXFrRbmYCKpbMdd+pjqNgxiS1E
         gPYrCqdLW+wADluCZ+5p5qXqixX/JOR88d16oahiNLWuv/8GkDLeg0XNzWpcYnT42++H
         AXkDK/3JkKtjntneEuzE4+aSTe/TOuRs9377L3hdGrmGaTpJuqB1Uns3zm//XphsSv46
         3AVcEFF4sufBMecyEYrodtY1X0g9Ok7hkINjfyc5KXjUoKjS+s4ikYH10yc9Gnl/b9yz
         GBLcMNjxfSQAN8Xysl7YYu0t/3QXYDRWMqlS+MLnrEMtD3PwIA5lv8yGUwXeqyLZiIDR
         QO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rrcXpuZKRM+KusxikaUH8D4u3EuQEaFpgWMrgs+cjc=;
        b=1MRmUygV75QsurrkkRUVrRz9PiaFyIC7Fs8QS3IO3/BP5zRLfgmzVHuIGug5AzGEqJ
         81Um84328kKkgiqZ9vF24lTA2qjx+3SwXAVx0QBQ6+dm44IiIGDAGCEQsrBeSUDiyHqC
         DQiR46zQAuKPpzHkK3WRwXFOMWLiL2ym5IZQViHtltx49gpKz0utLWOpybrNNXz043c1
         m+CLeU3lSCIxtoi2/Bn3PooV3FuC2meNPLf+9l46+0WKnRQ+7XqWxFdcv6u5eJJ+rRSr
         //UoXRrEGjq/CtUNbZgN0jLsrrjH5ng85iRqV2o5ZRsyJ2UjEB/zPAheJzXE2dlvJRig
         NNVw==
X-Gm-Message-State: ACrzQf1D+slXkY5VXMYf7cQ++AAUimUdqs27T4hf4NL77hJtnH0gyMaw
        aIUQuYiFBL4sfEYyL8Yw5yH9yg==
X-Google-Smtp-Source: AMsMyM75cyiDVTH3kQfgXNUDRS9hdpc7CkqxGMy547GhYQsQAaMw+aObwLFCGhqc0sEBfjBMrcDAhw==
X-Received: by 2002:a17:902:aa46:b0:178:9ee5:c7f1 with SMTP id c6-20020a170902aa4600b001789ee5c7f1mr6730566plr.69.1665171489623;
        Fri, 07 Oct 2022 12:38:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b0018099c987e6sm348648plg.285.2022.10.07.12.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:38:09 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:38:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Message-ID: <Y0CAHch5UR2Lp0tU@google.com>
References: <20220919091008.60695-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919091008.60695-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs adds
> a new architectural IA32_OVERCLOCKING_STATUS msr (0x195), plus the
> presence of IA32_CORE_CAPABILITIES (0xCF), the theoretical effective
> maximum value of the Intel GP PMCs is 14 (0xCF - 0xC1) instead of 18.
> 
> But the conclusion of this speculation "14" is very fragile and can
> easily be overturned once Intel declares another meaningful arch msr

s/msr/MSR for consistency

> in the above reserved range, and even worse, just conjecture, Intel
> probably put PMCs 8-15 in a completely different range of MSR indices.
> 
> A conservative proposal would be to stop at the maximum number of Intel
> GP PMCs supported today. Also subsequent changes would limit both AMD
> and Intel on the number of GP counter supported by KVM.
> 
> There are some boxes like Intel P4 (non Architectural PMU) may indeed
> have 18 counters , but those counters are in a completely different msr

unnecessary whitespace before the comma.  And s/msr/MSR again.

> address range and is not supported by KVM.
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Fixes: cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")

Does this need Cc: stable@vger.kernel.org?  Or is this benign enough that we don't
care?

No need for a v4, the above nits can be handled when applying.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---

In the future, please provide a cover letter even for trivial series, it helps
(me at least) mentally organize patches.

Thanks!
