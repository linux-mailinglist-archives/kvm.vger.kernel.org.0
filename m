Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41D4CB6F4
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 07:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiCCGaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 01:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiCCGaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 01:30:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26EC167FB0
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 22:29:32 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w3so5233001edu.8
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 22:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nv2jBESqYpfKB+23Wkh2MF8fptyzS2i2FuhOWbufpkM=;
        b=Ovd2aF1q0I1V6n/vY+V2NouJEgjg0VzfxAGwTtnzJ0Vo8HNOxlvD7qUpgji46MEjxD
         gqeJnIGB8ocpupGyRzvow8TDZf9xwnpg9H/SwK+vOWrgq47M9n97rOzFBRjBsrJ3a/pt
         uD5EVN1NlMey9xVGf7/V0wuWBaH2ZYI7I54Xoww0JrbLLvxQpJWn+pu7Q6WvMG5I+hj0
         sbXisQq7Wb3+Am+M4BuD71jaGzSz9AgV+OCAjIm6tuUhU7sLMVCtKtn+elC6XJpAjlVR
         1mLrca+nrFkI9cNx4j3MWarDdN3H82T14RtLnKy0pnamU+01I1JfRAV3rWYwffymeyGT
         /Yrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nv2jBESqYpfKB+23Wkh2MF8fptyzS2i2FuhOWbufpkM=;
        b=iTrvQ0tq09t/soxVm4YCw3O98yFofdGcPJkUUjxzgtJCVJHb1/s4hnTA3vRKNhkehm
         +E7Fyr5vrPrSqn0MNr4LlyosmMXbu5s0luuh4aaJ6B5IIHAkHgzgB1ShWTHq1g7Yf6iN
         Y4QYUkBjngCwvKb+4gkk0o4sChfp+2P0bbdDBzeTaHym2/bcQozBaat3vm23QX0LCpZ5
         StceM5cGydXFG4SdXEpV93uIPSePev4zQwgOzQTO87ATdpwK3Jn88F62+EIfD1znF00d
         W1qzkQyKMMt4ODGIQlw5WVxWRZj6zvCFwSU7ONAVlXYOLyH/gqjRaNwpYZ0hKmIDBiCg
         cJSw==
X-Gm-Message-State: AOAM5304REmxIy2dgIYN9jdZJ8puFrMa96eYCz12qsGMO3LmiKPWLaP4
        6YKKGIe2GYI0VQGzhjAkQhE=
X-Google-Smtp-Source: ABdhPJw+WI+nQ9hTUQz1PdBbmuyAehS3rtx8IWDOVurU7C+R/HLDVHBIQEAyh9jqrZsmm/QM+CRksQ==
X-Received: by 2002:a05:6402:2801:b0:410:a592:a5d0 with SMTP id h1-20020a056402280100b00410a592a5d0mr32455736ede.253.1646288971415;
        Wed, 02 Mar 2022 22:29:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id fs6-20020a170907600600b006da8ec6e4a6sm335959ejc.26.2022.03.02.22.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 22:29:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
Date:   Thu, 3 Mar 2022 07:29:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com> <YiAdU+pA/RNeyjRi@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiAdU+pA/RNeyjRi@google.com>
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

On 3/3/22 02:43, Sean Christopherson wrote:
>> Maybe I can redirect you to a test case to highlight a possible
>> regression in KVM, as seen by userspace;-)
> Regressions aside, VMCS controls are not tied to CPUID, KVM should not be mucking
> with unrelated things.  The original hack was to fix a userspace bug and should
> never have been mreged.

Note that it dates back to:

     commit 5f76f6f5ff96587af5acd5930f7d9fea81e0d1a8
     Author: Liran Alon <liran.alon@oracle.com>
     Date:   Fri Sep 14 03:25:52 2018 +0300

     KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled
     
     Before this commit, KVM exposes MPX VMX controls to L1 guest only based
     on if KVM and host processor supports MPX virtualization.
     However, these controls should be exposed to guest only in case guest
     vCPU supports MPX.

It's not to fix a userspace bug, it's to support userspace that doesn't
know about using KVM_SET_MSR for VMX features---which is okay since unlike
KVM_SET_CPUID2 it's not a mandatory call.

Paolo
