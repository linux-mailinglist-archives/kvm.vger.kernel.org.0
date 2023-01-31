Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15CD682BC2
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 12:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjAaLqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 06:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjAaLqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 06:46:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A313F4ED6;
        Tue, 31 Jan 2023 03:46:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so14219221pjl.0;
        Tue, 31 Jan 2023 03:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qYifaKQOdsCBowbWJxa8KCq6fsv+ZqlLk9cIq259ukc=;
        b=HEnN3c0JOCuCmIJWBkj1VFuWv3t9X8o4DXgtnbgslMmtdKL8Lom6PgWpC947IGh4Q0
         dBQ/Y7X8V8rTWAVtHXPbsXKUKgQzwRm9W7YHsC52mjCpVeocf4XCCF57fELlADh4CK90
         76liDEi2MkhHLcyNNpDYqT22PakJNHFVdnUiQeYkmjIQT5imR/ujHNcMLTsfQt9KtQix
         tbeHIsjO8SaBZ203d7d0kU4vt3D0iBAfqaHQD1xO9udnC5uYF/f9KkAzmUY8IQQofw3X
         bUrtRh21NLFr1cZ5pBHRHZE6NK66mwmMn48t0zDVCkEMxkuxdPjBXdpKIi+5AxCE+54z
         5+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qYifaKQOdsCBowbWJxa8KCq6fsv+ZqlLk9cIq259ukc=;
        b=EsSUDiK278Dselv6dUE9P4mUoR3Lvew+0ZlCiraygl6v0Uq6FufX4WicwjTsrtQyTv
         XXqDC64dZktwBSKSHykkJ6thTJufQrL2AQ44nG3C4cMGE5rN8ERvH92ahpGhEMsi97A6
         VREKZPTPLaDXTZBUJnZHaPw0kRS2pAE2Q1giCUBD6udxPdoBTDPmuqWYd5D2DTk8Q55v
         20bIPJYd9GsspvNRXZ09MeTNi2Q4CbEDTTmQm4x7VBD/cm7m0ax4X89xq8pGNYPXISu8
         5cVrZc4Z3fiBXeOCFueruhFvPbM7X01H3IZEb0kqzyu939PPp6OQYDi2SYvmTjkEKH2J
         azxg==
X-Gm-Message-State: AFqh2kq2NFu7F/dOBfLY21LYsgdDjK0KVS+uoRuV/LShBhL32A1lZT9/
        amHwRRSfPuObQkBd2VjQbUgus5CtsX9EdD3e
X-Google-Smtp-Source: AMrXdXs0Pd6dEis9OUHMH5J2mjSrTBwIqSPGsXo5Nc5ZZK1loen0+cG5mjgIeOiaC4bM6QLM1CvNUA==
X-Received: by 2002:a17:90b:3eca:b0:229:f4cd:1e03 with SMTP id rm10-20020a17090b3eca00b00229f4cd1e03mr44938754pjb.22.1675165610071;
        Tue, 31 Jan 2023 03:46:50 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z28-20020a63b91c000000b004785a63b44bsm8502606pge.43.2023.01.31.03.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 03:46:49 -0800 (PST)
Message-ID: <89c214e1-a7b4-a0e8-8fb9-c769dbf30ed4@gmail.com>
Date:   Tue, 31 Jan 2023 19:46:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 2/6] KVM: x86/pmu: Gate all "unimplemented MSR" prints on
 report_ignored_msrs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20230124234905.3774678-1-seanjc@google.com>
 <20230124234905.3774678-3-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230124234905.3774678-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/1/2023 7:49 am, Sean Christopherson wrote:
>   arch/x86/kvm/hyperv.c  | 10 ++++------
>   arch/x86/kvm/svm/svm.c |  5 ++---
>   arch/x86/kvm/vmx/vmx.c |  4 +---
>   arch/x86/kvm/x86.c     | 18 +++++-------------
>   arch/x86/kvm/x86.h     | 12 ++++++++++++
>   5 files changed, 24 insertions(+), 25 deletions(-)

Nit: those changes don't just involve PMU, better to
remove pmu suffix from the patch title for more eyes.
