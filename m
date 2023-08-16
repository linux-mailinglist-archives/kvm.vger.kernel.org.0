Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D077D911
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbjHPDbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbjHPDaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:30:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171B926BB;
        Tue, 15 Aug 2023 20:29:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1bddac1b7bfso19517045ad.0;
        Tue, 15 Aug 2023 20:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692156550; x=1692761350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEj0mBQfdRbRzSN3O+Uxwh388GZNZtY3hJehezBw8Tk=;
        b=SUzyW+CK6xwBBdd141aQTNgs5M0ctYOmHsTvc0rxmpBGYEjUQECTAhLJ3HjH16xHTv
         XQzOjTGT6YbkcakFSg7ns92IoN3ZsjWW666LMcZ7gnWF6isMv3xV8VWzVwPVVKcBW6Jw
         ujnCwOGwe71LqzwY/tuCeZ0o4qtKmdhYzBQMGahYfQTOVlkGhTNSBV/eXLQOrsxDbMpR
         j9UAG06LAEc5Dk1LqXqya1a9vedo1e8UnMONVcPV9KLtr5vwuc+nrEgvpGwRYjU3dMmf
         6+swqjp+vlqklLDY8/+fYgo2NDNi+aOMm/QHc97nqmyl7/pnZARUvaVWugvF7Lw4UHxc
         Wptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692156550; x=1692761350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lEj0mBQfdRbRzSN3O+Uxwh388GZNZtY3hJehezBw8Tk=;
        b=RUtjIPUBeiL2gOGmfpz7FyFyg11OpzrD0snJUUgDCAlpZZDTM5HJfnat4/e458WjnM
         MYz6bR7/sTw027xz9BxoSaTJsTT9ZhHM/dom3/Dy0Hz7aCOvqjvT+YY4lnJAr/9fjjOe
         Y07JnGbKKD5FTmqc+S5PyZj4m2ZsScnVsihsDAr5knzllZmqQq10zrDlmiBYCUUAGPst
         sjIwplHmhcPv7zbNRLKPSPpRjKaZcJcggmCON1uG02DCI+na1rvlneUOVwlT4rXplCwi
         OD/SZMEPxbSYOorAcdZKs99IJZnf/yumLP4ZErFv/o4utV1GnUS3fwrXD6hqXJe31cdv
         4uUw==
X-Gm-Message-State: AOJu0YxQeGc/HWUI5GE+1NIoXWpjvdYVTCoTecC7hzPYDmrQv4C4/O1W
        yk5JXz2OJtHvxsqMW7ZGBmE=
X-Google-Smtp-Source: AGHT+IGvmST2diMC63PU988FBHP7pMvA1OsAloTkdMPgjoTMMurYdMU6kLVUyUqi8Q5XWH7le4R0lw==
X-Received: by 2002:a17:902:e74c:b0:1bc:56c3:ebb6 with SMTP id p12-20020a170902e74c00b001bc56c3ebb6mr1120655plf.8.1692156549878;
        Tue, 15 Aug 2023 20:29:09 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902b58b00b001b83e624eecsm11889924pls.81.2023.08.15.20.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:29:08 -0700 (PDT)
Message-ID: <6979eae9-53c3-5dad-7d3e-d256d5252271@gmail.com>
Date:   Wed, 16 Aug 2023 11:29:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v3] KVM: x86/pmu: Add documentation for fixed ctr on PMU
 filter
To:     Sean Christopherson <seanjc@google.com>,
        Jinrong Liang <cloudliang@tencent.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230531075052.43239-1-cloudliang@tencent.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <20230531075052.43239-1-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Gentle ping.

在 2023/5/31 15:50, Jinrong Liang 写道:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Update the documentation for the KVM_SET_PMU_EVENT_FILTER ioctl
> to include a detailed description of how fixed performance events
> are handled in the pmu filter. The action and fixed_counter_bitmap
> members of the pmu filter to determine whether fixed performance
> events can be programmed by the guest. This information is helpful
> for correctly configuring the fixed_counter_bitmap and action fields
> to filter fixed performance events.
> 
> Suggested-by: Like Xu <likexu@tencent.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304150850.rx4UDDsB-lkp@intel.com
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
> 
> v3:
> - Rebased to 5c291b93e5d6(tag: kvm-x86-next-2023.04.26)
> - Revise documentation to enhance user understanding. (Sean)
> - Post this patch separately from the selftests changes. (Sean)
> 
> v2:
> - Wrap the code from the documentation in a block of code; (Bagas Sanjaya)
> 
> v1:
> https://lore.kernel.org/kvm/20230414110056.19665-5-cloudliang@tencent.com
> 
>   Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a69e91088d76..9f680eb89b2b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5122,6 +5122,24 @@ Valid values for 'action'::
>     #define KVM_PMU_EVENT_ALLOW 0
>     #define KVM_PMU_EVENT_DENY 1
>   
> +Via this API, KVM userspace can also control the behavior of the VM's fixed
> +counters (if any) by configuring the "action" and "fixed_counter_bitmap" fields.
> +
> +Specifically, KVM follows the following pseudo-code when determining whether to
> +allow the guest FixCtr[i] to count its pre-defined fixed event::
> +
> +  FixCtr[i]_is_allowed = (action == ALLOW) && (bitmap & BIT(i)) ||
> +    (action == DENY) && !(bitmap & BIT(i));
> +  FixCtr[i]_is_denied = !FixCtr[i]_is_allowed;
> +
> +KVM always consumes fixed_counter_bitmap, it's userspace's responsibility to
> +ensure fixed_counter_bitmap is set correctly, e.g. if userspace wants to define
> +a filter that only affects general purpose counters.
> +
> +Note, the "events" field also applies to fixed counters' hardcoded event_select
> +and unit_mask values.  "fixed_counter_bitmap" has higher priority than "events"
> +if there is a contradiction between the two.
> +
>   4.121 KVM_PPC_SVM_OFF
>   ---------------------
> 
> 
> base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5

