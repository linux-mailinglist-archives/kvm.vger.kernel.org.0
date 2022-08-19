Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFA59A4E8
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349868AbiHSR4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 13:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352295AbiHSRzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 13:55:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA56754A4;
        Fri, 19 Aug 2022 10:37:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gb36so10051413ejc.10;
        Fri, 19 Aug 2022 10:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc;
        bh=XMhdxcayB7NvmBY1v3/q80/CfpweTA7+ilDxiqMN9/E=;
        b=BvV0lSHZe5gbu00tO9mrrGfNwZojebEXelBO7GXkcjZXOsMLqDadmtUKTyIhETABLa
         t59lbqaSYmfbQ4lmBhx3hiHSGkuQ4JlBNoEwxofMXhAoMr5Kcad137QapAoWY5NFh3fh
         Y1O6BiS3xXe59S531bEeKL6kNKd+fZk4VNQJIJmIZ+1YDjHwSmoQhW501secDGxpN907
         QbdWP6t634cYXlYPDCoUj1tmR0DrXBq8Dl4gX2jZ6uz7A5+HiwannZRBu5mLqg9G1UW6
         Re70d88rysUQFODy6hSr6/zD5YvT/CXuLr1qH2QtSumQGXvVa1wAbvnVuj0m2opCJDMF
         NfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc;
        bh=XMhdxcayB7NvmBY1v3/q80/CfpweTA7+ilDxiqMN9/E=;
        b=LvR87bhgZ9H5G8bBYdaeMhkubv++dRycjk3UH6dTMkwReuQVS868w5Qxs/Wd1Vs8HL
         V3M1uYb1ict3u96GSBLiZbJR/RaiD9OBGa6pmmrPU7CvdLUOi8aBoXwwyzi+GoKkQT/9
         hLecV99IBBl6tgNUTJhHIJTlQcFn9fE1e69/K4TsUMBS0hSaBhux3mW6c31wIWLjFP0O
         +EgNh0eRzHMqAhhBUhRZvheXFSmvcJ6XTy8Uth4izeGEuSHyfaGlZJ4rd+FENwyf+l34
         acX0e+c7nyJF1Tn9wnqlbnvi12j7nJdQ5DS1Wyxb+TNbg017V2eer9FTm69avWDXlIgv
         gr/A==
X-Gm-Message-State: ACgBeo0QfyuSG25vosOLALbkfAkLSHSpQZ/3zj9kXouUk1SKJsTwbUuA
        nfl6UDLlsxa4ANpk9/4HDhE=
X-Google-Smtp-Source: AA6agR7h/IQJ5GacyKlcm1YG1B4x2HSBa5tDFoJT4ecn4SSoEK+VDOXxxv01YQG2gnhlRef2dfCX7Q==
X-Received: by 2002:a17:907:1c8f:b0:6e8:f898:63bb with SMTP id nb15-20020a1709071c8f00b006e8f89863bbmr5639177ejc.721.1660930654898;
        Fri, 19 Aug 2022 10:37:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id b15-20020a1709063f8f00b007336c3f05bdsm2646738ejj.178.2022.08.19.10.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 10:37:34 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bab3cc28-4473-d446-bb6d-bca6939adb63@redhat.com>
Date:   Fri, 19 Aug 2022 19:37:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20220803224957.1285926-1-seanjc@google.com>
 <20220803224957.1285926-3-seanjc@google.com>
 <CALzav=e_H0LU+2-KcG_bPahVhJM8YGnH24J6aJ9HG9Eqj-waew@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=e_H0LU+2-KcG_bPahVhJM8YGnH24J6aJ9HG9Eqj-waew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/22 18:21, David Matlack wrote:
> On Wed, Aug 3, 2022 at 3:50 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
>> masks change; simply clearing enable_mmio_caching when a configuration
>> isn't compatible with caching fails to handle the scenario where the
>> masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
>> location, and toggle compatibility from false=>true.
>>
>> Snapshot the original module param so that re-evaluating MMIO caching
>> preserves userspace's desire to allow caching.  Use a snapshot approach
>> so that enable_mmio_caching still reflects KVM's actual behavior.
> 
> Is updating module parameters to reflect the actual behavior (vs.
> userspace desire) something we should do for all module parameters?
> 
> I am doing an unrelated refactor to the tdp_mmu module parameter and
> noticed it is not updated e.g. if userspace loads kvm_intel with
> ept=N.

If it is cheap/easy then yeah, updating the parameters is the right 
thing to do.  Generally, however, this is only done for 
kvm_intel/kvm_amd modules that depend on hardware features, because they 
are more important for debugging user issues.  (Or at least they were 
until vmx features were added to /proc/cpuinfo).

Paolo
