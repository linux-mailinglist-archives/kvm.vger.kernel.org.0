Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D5A64DFF1
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLORrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 12:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiLORrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 12:47:08 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A371B252BB
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:47:07 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m19so14387218wms.5
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=sNLNZlLE6oimTLTCnYhJy/T49F8cJl61AWb/ObcFz38=;
        b=GukGMHxGFO4O4rV9FtHECMfVu6evqvEMgrj6gDaxS3WRJDIHALLdYF88oITeFZ5TPS
         oLDcyEjr9BYu+elCxOSHrKoN6uO3DNyahMawUUJukIK5xBaklWu8Kd48UprmmnSc9P0d
         8ACQBBWAlnXxB4iqLNDAWDo+m2o+WS2eYV47Vf+DQEhMqbWQq3cukSHnbCPl7uautt6W
         ckm3IDwJq7e+iKPSJTeF8+aMtY1qapBU65h8V/t36yGcTMjnoe+9m5hcb3OzUjtifKtU
         tlPBIK06000XCCSnucr9qWcs1nyZrfp/vxN5EAKBqYLqq4G1RMFwIxF4nbRSxZEE3J2o
         wUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNLNZlLE6oimTLTCnYhJy/T49F8cJl61AWb/ObcFz38=;
        b=76wQQV4MQsxwG0OFwR9srLdA3/hgCg5eTVyb1/CS+tqngNMOs7tDNe9V/gIkxB9k6c
         2KYB7K7GKRbAmTAnL4GJFduHksdWZ/Vd/hc7LRZE5Xzyt2ZQx93E8iWj9azIhSbnnf4u
         vBqePwZGebAWk2LP+mpPZRbGEXgViSoihw5/jlwSX3yiHFVFYnyEyebTLn136eiuRuz9
         Bd4bV5IcbAbf3ysyIdfoEzfm545IfDH0euhMmlEH9d8MmMgSn4aZQypUoz6YoIJv5ByH
         K+eAsrW7W2ROqdy9DP0SNAoxO1fdhD/ko/RP2wuuX66bgnFj3jXv0zThukuzXXU5I0dW
         dlOg==
X-Gm-Message-State: ANoB5pkKTQfmDKmLCKuDh9GHVopTeGXKG8arKDz735c1TPIkklXFxhZU
        LM1zH3yqeLQ4of+5gAhraqs=
X-Google-Smtp-Source: AA0mqf7IeHn5AwfVHmCooG3859lPSwzRToSxLtGRPZlFFh0THW/wC4vIbBYCuWKS4A1+pF4UuWh+pw==
X-Received: by 2002:a05:600c:6015:b0:3cf:ea76:1823 with SMTP id az21-20020a05600c601500b003cfea761823mr22917190wmb.41.1671126426075;
        Thu, 15 Dec 2022 09:47:06 -0800 (PST)
Received: from [192.168.4.253] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b003b4cba4ef71sm8196049wmq.41.2022.12.15.09.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 09:47:05 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ed102505-5154-8730-7661-40c430faa437@xen.org>
Date:   Thu, 15 Dec 2022 17:46:59 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86/xen: Use kvm_read_guest_virt() instead of
 open-coding it badly
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <d52040a8d46e68efd86273be66808fe4a8c70e1d.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <d52040a8d46e68efd86273be66808fe4a8c70e1d.camel@infradead.org>
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

On 14/12/2022 13:38, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In particular, we shouldn't assume that being contiguous in guest virtual
> address space means being contiguous in guest *physical* address space.
> 
> In dropping the manual calls to kvm_mmu_gva_to_gpa_system(), also drop
> the srcu_read_lock() that was around them. All call sites are reached
> from kvm_xen_hypercall() which is called from the handle_exit function
> with the read lock already held.
> 
> Fixes: 2fd6df2f2 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
>         536395260 ("KVM: x86/xen: handle PV timers oneshot mode")
>         1a65105a5 ("KVM: x86/xen: handle PV spinlocks slowpath")
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Spotted the same issue in the QEMU patches while working through them:
> https://git.infradead.org/users/dwmw2/qemu.git/shortlog/refs/heads/xenfv
> Then realised it was like that in the kernel too.
> 
>   arch/x86/kvm/xen.c | 56 +++++++++++++++-------------------------------
>   1 file changed, 18 insertions(+), 38 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

