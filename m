Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E902584E89
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiG2KK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiG2KKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 06:10:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CEA18E3B;
        Fri, 29 Jul 2022 03:10:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y15so4167927plp.10;
        Fri, 29 Jul 2022 03:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JLafTdZQTIJ/ZMJeobMerLJx0fL+MSQkWHLfTftgshw=;
        b=o6XqJw9hP7MTR0AQfrp6ZHmQmzzVlWgOJAK3T5HgtDEtwIewC7n6e+IvizjILqvdCR
         TBUUYHqWiFBlLVqbgx4Itar+AihpcSbvd0WWuGp04L9bMbRw9/mxid8zUs4HBvohKFhQ
         K9uk5IUmxN9i3VXXOcw990FwXBqg47t3sTiY0/ry5W9aHhfcoN9MJR65EDjdhGfytYAJ
         VOsNmtJIP0ZMPeuVJE2bPllB/B3MBMlpt0bRjeg4v6yp6GSo+5q5bP5eIjtC+hcCgrsl
         3LFpWMGgDgHsYm15+DhTcEyI8ONfPr+SPUnvkRyH2bsGl0+A266wIiDMXVF9K/E+hUpt
         /9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JLafTdZQTIJ/ZMJeobMerLJx0fL+MSQkWHLfTftgshw=;
        b=n+cskNu7IOgfMzcbV3NumEkSheNBqV1DKgfDOBvALi1b+iDc35eYtu8bHyiVOYLuwy
         J72SxXmpCXicwoDXtVPWs55gSZSffsGJZBbNbUE0nqFhuqfnwWSLulct20m2SitxF5EY
         /Vp9Cq6inA+p4IBg3zDRRXuGVCHUojgsbulzuaZuiqFysY4AK6y+3jXh73a2kHuGrSAV
         eaHlB8b97RRxosHWrHelo3Tl3t0F5p01q2+m/H0wl2wYtO/Joczx7cGxQR1JhZuV8uaE
         620Zy+50s4pBJrvs0rRs5W6QCyCrD+NPLcN/X/yw7aBcFESiDGdXSuFudSWvck6kuenT
         xLkQ==
X-Gm-Message-State: ACgBeo1eOZfJzmu0cnXfC9togqq2OQ5jdNVjUEthuWuoA5AjULI2G8HG
        BnImszJcxbPwfzsgSoqIktQ=
X-Google-Smtp-Source: AA6agR7/nDUlBch2dSEnYa7yEYJCHAd5tYPLQUz5u9LOpnraaR+54di/vBPRWzIBd9AChfzY1Gy66Q==
X-Received: by 2002:a17:902:d504:b0:16d:69f9:e607 with SMTP id b4-20020a170902d50400b0016d69f9e607mr3059327plg.131.1659089418670;
        Fri, 29 Jul 2022 03:10:18 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z7-20020aa79487000000b005289c9a46aesm2464490pfk.80.2022.07.29.03.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 03:10:18 -0700 (PDT)
Message-ID: <2d932ad7-899b-ed26-d77c-f149fb2afc36@gmail.com>
Date:   Fri, 29 Jul 2022 18:10:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-4-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220727233424.2968356-4-seanjc@google.com>
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

On 28/7/2022 7:34 am, Sean Christopherson wrote:
> guest_cpuid_has() is expensive due to the linear search of guest CPUID
> entries, intel_pmu_lbr_is_enabled() is checked on every VM-Enter,_and_
> simply enumerating the same "Model" as the host causes KVM to set the
> number of LBR records to a non-zero value.

Before reconsidering vcpu->arch.perf_capabilities to reach a conclusion,
how about this minor inline change help reduce my sins ?

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecbbae42976..06a21d66be13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7039,7 +7039,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
  	pt_guest_enter(vmx);

  	atomic_switch_perf_msrs(vmx);
-	if (intel_pmu_lbr_is_enabled(vcpu))
+	if (vmx->lbr_desc.records.nr &&
+	    (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT))
  		vmx_passthrough_lbr_msrs(vcpu);

  	if (enable_preemption_timer)
