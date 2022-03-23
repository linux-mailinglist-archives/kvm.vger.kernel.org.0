Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9674E50FB
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 12:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiCWLFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 07:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiCWLFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 07:05:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175073A730;
        Wed, 23 Mar 2022 04:04:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w25so1362100edi.11;
        Wed, 23 Mar 2022 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mAU0R4k+SWVtMg5hvXCUujH3/DpDfLXmJsNsylW/QEE=;
        b=iDZ39g1Ujx2MpZyUtvVU4pf9H/B1deYiw23v6izuj6tI6dqQwCBL35zfNeRTfpCpjs
         gFZ8u5+NFDNyCAob7iwUFxbzoGffPSoCT0u0RGpvYX5QShrOkTj/MslWzKhBe2RH6G5h
         A/1oOcOZ+wk+RUtkNLiuxz21ugXGianW+ILc7yCmBQdZsG5Be28ThfbKj+6l4/KAh7Vc
         0oTE7omSZqGfWuEYoZjvpgA2PW7aBpY5jPPDJi77XyhMQwPCvaH9lBhPi8c/JJKJpmnL
         BK0v4f2yt6XfWxFxo07cRtWRPKBtoo6wpwPW+HU5Hr3jcqM6lanRBvRdMr8Q7x6u4e6Q
         c9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mAU0R4k+SWVtMg5hvXCUujH3/DpDfLXmJsNsylW/QEE=;
        b=aqYGw0JqmMRa1yiXA9wQo1o2RWJFjMWwURrsu1TA+artSNSloBHoHQLVRjYFEIqYax
         5JN/LbNGdQbCH4+Fia0Nu/mO10tAhy+P/nL4nKAWeXzdN6a1d7wpfhKHvt4zqCZu0Ohw
         PZTHNBVjIpJj+iPc3KEnuqfX4jB45i9hAw9PEBadO0uCwkC+b9vL9ZTQ2VFjd8Xgw+0f
         wpGFILDjtwZOm+0db2/25DtLEKxoX3ESFcQSCr5PCQcl7ZIWuv1NNXouvnl/GFcG26s3
         9hpL52KRymTaLLUZqQdmMT6SRhIFWrYGjpqrwnFRZ6d0G/IFtWtIUpFXih/PIwhpRmOx
         NQ2g==
X-Gm-Message-State: AOAM532py88sL3LFW1E76RMzNzFLXYaS8FqpJgSqENZIbBgfEa/DvvNS
        0JUoiJQFMVrL4EhltpTUH6iHModtM/E=
X-Google-Smtp-Source: ABdhPJxTnKJtt9+vkeVE2V70jsUdyUE8LxCSSd85UgYSD/7DdGjVD3tjvfTG6kl4X/O20fxiHRVmng==
X-Received: by 2002:a05:6402:34d6:b0:419:4dc2:91c5 with SMTP id w22-20020a05640234d600b004194dc291c5mr13399271edc.329.1648033462499;
        Wed, 23 Mar 2022 04:04:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id g10-20020a056402090a00b004196250baeasm2344510edz.95.2022.03.23.04.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 04:04:22 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a0bded7d-5bc0-12b9-2aca-c1c92d958293@gnu.org>
Date:   Wed, 23 Mar 2022 12:04:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: ping Re: [PATCH v4 0/2] x86: Fix ARCH_REQ_XCOMP_PERM and update the
 test
Content-Language: en-US
To:     tglx@linutronix.de, dave.hansen@linux.intel.com
Cc:     yang.zhong@intel.com, ravi.v.shankar@intel.com, mingo@redhat.com,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@alien8.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
References: <20220129173647.27981-1-chang.seok.bae@intel.com>
From:   Paolo Bonzini <bonzini@gnu.org>
In-Reply-To: <20220129173647.27981-1-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas, Dave,

can this series be included in 5.18 and CCed to stable?

The bug makes the __state_perm field completely wrong.  As a result, 
arch_prctl(ARCH_GET_XCOMP_PERM) only returns the features that were 
requested last, forgetting what was already in __state_perm (the 
"permitted" argument to __xstate_request_perm).

In KVM, it is a bit worse.  It affects 
arch_prctl(ARCH_GET_XCOMP_GUEST_PERM) in the same way and also 
ioctl(KVM_GET_SUPPORTED_CPUID), but the bug can also make KVM return the 
wrong xsave state size to userspace.  It's likely to go unnoticed by 
userspace until Intel adds non-dynamic states above a dynamic one, but 
potentially userspace could allocate a buffer that is too small.

Paolo

On 1/29/22 18:36, Chang S. Bae wrote:
> Changes from V3:
> * Rebased onto 5.17-rc1.
> 
> V3: https://lore.kernel.org/lkml/20211110003209.21666-1-chang.seok.bae@intel.com/
> 
> ---
> 
> The recent x86 dynamic state support incorporates the arch_prctl option to
> request permission before using a dynamic state.
> 
> It was designed to add the requested feature in the group leader's
> permission bitmask so that every thread can reference this master bitmask.
> The group leader is assumed to be unchanged here. The mainline is the case
> as a group leader is identified at fork() or exec() time only.
> 
> This master bitmask should include non-dynamic features always, as they
> are permitted by default. Users may check them via ARCH_GET_XCOMP_PERM.
> 
> But, in hindsight, the implementation does overwrite the bitmask with the
> requested bit only, instead of adding the bit to the existing one. This
> overwrite effectively revokes the permission that is granted already.
> 
> Fix the code and also update the selftest to disclose the issue if there
> is.
> 
> Chang S. Bae (1):
>    selftests/x86/amx: Update the ARCH_REQ_XCOMP_PERM test
> 
> Yang Zhong (1):
>    x86/arch_prctl: Fix the ARCH_REQ_XCOMP_PERM implementation
> 
>   arch/x86/kernel/fpu/xstate.c      |  2 +-
>   tools/testing/selftests/x86/amx.c | 16 ++++++++++++++--
>   2 files changed, 15 insertions(+), 3 deletions(-)
> 
> 
> base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07

