Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CDA7A978F
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjIURZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjIURZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:25:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6A04066E
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:13:15 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-532c81b9adbso1428661a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695316390; x=1695921190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlXVGGihr/Um8VppFFFoZThvd/Obt/HhaeL0kASOwJ8=;
        b=I93UUYOeDxkHJSpq0cfKen7kBNfxVfF0pz5KbRLZOZt4VwuOMzkYlFPRCNKDxQPFWw
         hZZfySk0R/EZSLIiNUTMdByoMo68nfw1IRaOgKLi4/Ri0yTqujVpH0YN1SwyuG1tM2/k
         GFlht/Q+50Gp4GmFBAgnvOhPW9+KLxCeJgSa/Ks7SCSS0Gt4Pj7Cu6g1oAqTYGNZNanq
         iFBTD0Ns4ipkWX5rTL//U1n4awdnaapRFXVkJ51+ZlNIvJbpNy+g6B+zAmIyWFK+aBRH
         RCTpa5JrTKnFSWg/7Ca+9gRTLTia59fbKlhMF4FskiqOBZhl1X4aGBDY1qjdyDv2ZNfm
         fE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316390; x=1695921190;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXVGGihr/Um8VppFFFoZThvd/Obt/HhaeL0kASOwJ8=;
        b=PKShvvgiUyrKf1bTzkudXNAzMpjjRXs+68KfUTaDMADHBcfpMLv7TOomnxDIYqrBuM
         C4h42/TfgzjlLK+4D5uckJF0XF/qtQtJtAqPUow+8QXjaLBDB8oI3lXT4ukZAlL3qIuF
         Sl43ToaHxOVq8fvTaaFUcntTmBFi24HT/WyqY7vb8SLM2p6rZka42TA8nZ61v19RJHTC
         8VFB9XR/VK3BiuNFHTc37MKcwC7u03bLoNBsKDlnjRXwEORTIsU6pHTaLPapAIlUMOcY
         gjfvSmDdTLoTlYwPbfEokKxTeei9Hu4mFzpYUJyAiKgRtzbL2T799JI5k2bMM3u8Lz7r
         VQ5g==
X-Gm-Message-State: AOJu0Yw56rpqXTJ5PGSphQ5WfswjV/0UC2708hROhGrTMuoLCZMkySnV
        DEIFFEwU68eNyQ0M6ZMZ5tuDhPanM6mfHiot8FY=
X-Google-Smtp-Source: AGHT+IEVmLQq+UzBdZyDArNwFSahITnvkbWTPZjwKGfWuPXbnyC9+l1/YPqWIBds6xw1bDrv8ypH8g==
X-Received: by 2002:a05:6512:702:b0:503:183c:1223 with SMTP id b2-20020a056512070200b00503183c1223mr4473980lfs.7.1695300448633;
        Thu, 21 Sep 2023 05:47:28 -0700 (PDT)
Received: from [172.20.41.70] (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id c21-20020aa7df15000000b00532c5e2d375sm792923edy.1.2023.09.21.05.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:47:27 -0700 (PDT)
Message-ID: <c9b5e431-d2a2-de52-9235-36d4203a4d5d@linaro.org>
Date:   Thu, 21 Sep 2023 14:47:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 1/8] KVM: arm64: Add generic check for system-supported
 vCPU features
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
 <20230920195036.1169791-2-oliver.upton@linux.dev>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230920195036.1169791-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/23 21:50, Oliver Upton wrote:
> To date KVM has relied on kvm_reset_vcpu() failing when the vCPU feature
> flags are unsupported by the system. This is a bit messy since
> kvm_reset_vcpu() is called at runtime outside of the KVM_ARM_VCPU_INIT
> ioctl when it is expected to succeed. Further complicating the matter is
> that kvm_reset_vcpu() must tolerate be idemptotent to the config_lock,
> as it isn't consistently called with the lock held.
> 
> Prepare to move feature compatibility checks out of kvm_reset_vcpu() with
> a 'generic' check that compares the user-provided flags with a computed
> maximum feature set for the system.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/arm.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

