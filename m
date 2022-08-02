Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADAB587B57
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 13:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiHBLIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 07:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbiHBLIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 07:08:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09C41D36;
        Tue,  2 Aug 2022 04:08:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b4so3098732pji.4;
        Tue, 02 Aug 2022 04:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=s/ZC9n/wInmegiSyRz568Hw+Uv60cUOdQmulw7RvUXE=;
        b=JIzh/vuRbxmOjINUOjX0I1ZMchVdtFY+Fa0uO7+l6lAv28fe4USKnm/hgnX2VZWqI7
         z1TYiNbGnAaITD+c24m9NSOqV3Ed0pLHcIs0RRBOulmcWYXjlJACO3HR5uF8KHmVQhiy
         +pR51WuNzFHosggAOBTNN0NLdZpGMKhLvoFnNGz+QwjLcuqq0lnU8vdB2Pf0Qz/jTqqX
         YYIEnCzUy8MdgMYB+xxWWQF2a2HHNeXQ3wfUVubPZaKG6L65bkGzUrrqcUuPnRTI4OHb
         X4/ZRy2vwth7I1JLNg42qxUSJ6U18EfoOSSfleSJ+EiIsSvHirpwgALnDG6zWpO24jMH
         lN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=s/ZC9n/wInmegiSyRz568Hw+Uv60cUOdQmulw7RvUXE=;
        b=BKlBx4SLkjwjve9yw1jOboPI60p3Q9xhGlZM0zkeMGbd+FgZkCfxqFh9C7L1u4Ctny
         UlvCZc0o3e7hy51UjdieMAdscK7tX7xks9LWJyCfX4NO/gbdjJY5D1w3XQet0JCd/AkH
         +/xppOEHeUaPdA2JhS4Hc7z7vg2sQZY5fJGt76ZcDdI3XzbmcplBYOLJ53SL0NO4cAsg
         vXZRBI6fsXqGLjfCy9vx4vse9D0TX4m8n02bUdscErjYXcFinWgjga3kkvc0owufVJsa
         nqeFflm30Y03dSTJwZYVH6P9hJGfdx43wc93J/HU40pK8vnolxeFnEYKG5uGGzW583oM
         K8sw==
X-Gm-Message-State: ACgBeo3ytdFd8w3ov4m1w2bAztCaTwxj6uZA1p1SLDEYEiQUC6hauGqm
        WM3PnR6WQePW1CIFCJh7GkFdEampsSWaPQ==
X-Google-Smtp-Source: AA6agR72GvaKk+IB8mY7pL/6ueGuHpTsAKXwXOD+DgH0Z6ngVnf5gQAnNHZ7VU5VrZReUkLDgtbaRg==
X-Received: by 2002:a17:902:c40e:b0:16e:cdf5:fd95 with SMTP id k14-20020a170902c40e00b0016ecdf5fd95mr14536542plk.86.1659438483228;
        Tue, 02 Aug 2022 04:08:03 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902ea0900b0016d12adc282sm11733065plg.147.2022.08.02.04.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 04:08:02 -0700 (PDT)
Message-ID: <5e8f11ef-22ff-ee67-ed39-8e07d4ee9028@gmail.com>
Date:   Tue, 2 Aug 2022 19:07:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/7] KVM: x86/pmu: Fix some corner cases including
 Intel PEBS
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220721103549.49543-1-likexu@tencent.com>
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To catch up on the first -rc, ping beggarly and guiltily.

On 21/7/2022 6:35 pm, Like Xu wrote:
> Good well-designed tests can help us find more bugs, especially when
> the test steps differ from the Linux kernel behaviour in terms of the
> timing of access to virtualized hw resources.
> 
> A new guest PEBS kvm-unit-test constructs a number of typical and
> corner use cases to demonstrate how fragile the earlier PEBS
> enabling patch set is. I prefer to reveal these flaws and fix them
> myself before we receive complaints from projects that rely on it.
> 
> In this patch series, there is one small optimization (006), one hardware
> surprise (002), and most of these fixes have stepped on my little toes.
> 
> Please feel free to run tests, add more or share comments.
> 
> Previous:
> https://lore.kernel.org/kvm/20220713122507.29236-1-likexu@tencent.com/
> 
> V1 -> V2 Changelog:
> - For 3/7, use "hw_idx > -1" and add comment; (Sean)
> - For 4/7, refine commit message and add comment; (Sean)
> - For 6/7, inline reprogram_counter() and restrict pmc->current_config;
> 
> Like Xu (7):
>    perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
>    perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
>    KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
>    KVM: x86/pmu: Don't generate PEBS records for emulated instructions
>    KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
>    KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
>    KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
> 
>   arch/x86/events/intel/core.c    |  4 ++-
>   arch/x86/include/asm/kvm_host.h |  6 +++--
>   arch/x86/kvm/pmu.c              | 47 +++++++++++++++++++++------------
>   arch/x86/kvm/pmu.h              |  6 ++++-
>   arch/x86/kvm/svm/pmu.c          |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c    | 30 ++++++++++-----------
>   6 files changed, 58 insertions(+), 37 deletions(-)
> 
