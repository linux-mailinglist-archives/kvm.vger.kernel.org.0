Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57825BF1A8
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiIUADB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUAC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:02:59 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953495FF48
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:02:58 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id f20-20020a9d7b54000000b006574e21f1b6so2861079oto.5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=8law8D5pcm6I8ecnHk2V8T33DhrE54Khl2jFwyTG1+Y=;
        b=DoU1CkIavINkLQHOAuDkCtgufNCV7SKnx9KvLGtRb18JeX+9n1WSjZdFDa9Q57wciT
         xmTxa2tvdQuSQk93N/zuzntn8kUao4CCpuS2pXk7qFK3Hz8z1lsXohaC6xHVDOku822j
         QDNsNbrLV5HXakO/SHBeCf6vzsGzgWjPRcGrKwXUPryLRBzS//jx75ZXQGENzzdNb1bN
         DYLNHeyt94b7yXjVcrnSubDRFGneFnCxXWuGfM+iAUsq6/belo5q9gwtcKqc/Ykqsjae
         aOw+LmOO9h0AvPnYUCYkjrn4FR44QjyF8j6IW5h3TQULh6cO5nLguv8eWd0PdpXimI9U
         /HWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8law8D5pcm6I8ecnHk2V8T33DhrE54Khl2jFwyTG1+Y=;
        b=VNdlUECXvCqIZhk0MFDCBzBmmYGp+BlIQp7E5ALvlMIeIQ2qkFBFb41uzLOyDJXAn3
         2w8++AW5IRt/ivsfrjoG9ms5ZDpH8WYPQAYiRyAaiLga+mPaQC+XchhQqojRU2Z7Ei4w
         tX/TUs5Vy2gbtvZRs6nUZnudhWOiURP8nhFegx1FJFprHhaM7sLUVMPhc25WUqeS5a6B
         ZE6boV5CwUTeKqMGgXdC1aPghy09QSH7fOglILlyptAhtTJwuLM95CAJQFBeKx4drfVV
         8iTT9o077UFXwUswJsXJLL6kcFsumAr+X2HIwhNMzfm2ja5D1pKrgsH+V+kPVL8m842q
         QrYA==
X-Gm-Message-State: ACrzQf2iPZDA0L40BkLLMraKdU0U+bp2tp43sevmoh9uYvKS5Cwr1myd
        yZsJPVAahQVb9CmBf8RifGktg6QLcngd25tQweN7yg==
X-Google-Smtp-Source: AMsMyM5T7Al2dm+R48Lk6EPwEL+yNQHSxRv9CXA93YKAt4RR7XKd4ZxdIyBzPusZ6ZdBI4aj2QS9/HEk87iA6KKG3iQ=
X-Received: by 2002:a05:6830:2705:b0:659:ebb0:ecad with SMTP id
 j5-20020a056830270500b00659ebb0ecadmr8739273otu.75.1663718577755; Tue, 20 Sep
 2022 17:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220919093453.71737-1-likexu@tencent.com> <20220919093453.71737-4-likexu@tencent.com>
In-Reply-To: <20220919093453.71737-4-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Sep 2022 17:02:46 -0700
Message-ID: <CALMp9eTXRmuBvNNMhPvcwZE3+kFzR8qJYNspB2jjBoaw_EjS2A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg
 leaf 0x80000022
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Sep 19, 2022 at 2:35 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Sandipan Das <sandipan.das@amd.com>
>
> From: Sandipan Das <sandipan.das@amd.com>
>
> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
> new performance monitoring features for AMD processors.
>
> Bit 0 of EAX indicates support for Performance Monitoring
> Version 2 (PerfMonV2) features. If found to be set during
> PMU initialization, the EBX bits of the same CPUID function
> can be used to determine the number of available PMCs for
> different PMU types.
>
> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
> that guests can make use of the PerfMonV2 features.
>
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
