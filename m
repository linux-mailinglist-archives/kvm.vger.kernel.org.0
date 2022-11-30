Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9163B63D7C7
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiK3OJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiK3OIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:08:00 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02CE7CAB1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:07:29 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o30so13270098wms.2
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c0kltdn3tSDAhioYUsyEvH/SbMhgxahUyA1un7racDs=;
        b=XCechuH2E6y1KDnKrP9q2UhAC1kFT7ys0a/GAIuK6HEdRQib9PiYcLpjidqUflGrNo
         D62jaXEjdkJcaFc3gaJwAzPC0cFwxlXPH/MvrNek8nDXUdY2qVgzdajQEf7dMQdBq32Q
         nJHRfk19wnAlqqFN6jAnr7GgvDBLB6GpFrYzjRgLosfH1HcpaBJglDcLiIgUczJdeHER
         uiMz3b1n5t2/U102XE4elO0ddOnjtl+px1cBi7XBk878FWjGXTOuDmhD5wdADSPeoMeB
         fzM74cXwK57AqEAasyueRA9TJax162Y7zTzJcbiJSroIe1SxLc4j7GziS9Xtw7CJK+AB
         vsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0kltdn3tSDAhioYUsyEvH/SbMhgxahUyA1un7racDs=;
        b=p8Ly1czkh3Azo19aixJHXYsg4fS1N98E+FjQiSegZh+FOu+s2xDEJD+bE3//Mjb+Ph
         ZqFPwtep1wrftwT6dlt5BoG1qasg+EYXiCSrExy/vuDz3BnJZPxJF9gP4AW1Ni58OqdR
         daLaUtmY8+L4BO1z5YLKfgYqqVMPIinIpbSwOyw1+EjkEgomYJCedMzhg+BPdn9uHFp3
         A31mUhpG+1pLbsA4p3qVnX/nzriqrlc60Sx0nSCO92ip70+TmTMgU7Vy8r5TdFZJ+b9h
         e+1mlaKuhrggtdnOugWsN4B0Ake98wEalj4VeOu+NxG7ebRll0ekPa5kvPzY43dir5kr
         1O+Q==
X-Gm-Message-State: ANoB5pk2uFHqsvZUj8LW00zfb2FCmO0k+RRUDQH/++T7IAOd1BUJXepa
        JwvxvD6i5u+k1E0NS1WzF/s=
X-Google-Smtp-Source: AA0mqf5Mkj+Oty6BMZD/mgLmALapKOo0G2EdGlDibjdXkMVcugwIOEYXT/HN5eaDKP5G2bXLAA1caA==
X-Received: by 2002:a05:600c:3592:b0:3d0:7040:c84b with SMTP id p18-20020a05600c359200b003d07040c84bmr3039955wmq.137.1669817248309;
        Wed, 30 Nov 2022 06:07:28 -0800 (PST)
Received: from [192.168.23.148] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id d8-20020a05600c34c800b003cf4eac8e80sm2555769wmq.23.2022.11.30.06.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 06:07:28 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <38738c96-3bde-7866-505a-1acff26c2764@xen.org>
Date:   Wed, 30 Nov 2022 14:07:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 2/2] KVM: x86/xen: Allow XEN_RUNSTATE_UPDATE flag
 behaviour to be configured
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
References: <20221127122210.248427-1-dwmw2@infradead.org>
 <20221127122210.248427-3-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20221127122210.248427-3-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2022 12:22, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Closer inspection of the Xen code shows that we aren't supposed to be
> using the XEN_RUNSTATE_UPDATE flag unconditionally. It should be
> explicitly enabled by guests through the HYPERVISOR_vm_assist hypercall.
> If we randomly set the top bit of ->state_entry_time for a guest that
> hasn't asked for it and doesn't expect it, that could make the runtimes
> fail to add up and confuse the guest. Without the flag it's perfectly
> safe for a vCPU to read its own vcpu_runstate_info; just not for one
> vCPU to read *another's*.
> 
> I briefly pondered adding a word for the whole set of VMASST_TYPE_*
> flags but the only one we care about for HVM guests is this, so it
> seemed a bit pointless.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Paul Durrant <paul@xen.org>

