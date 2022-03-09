Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464254D2D25
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 11:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiCIKeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 05:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCIKeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 05:34:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8871986D6;
        Wed,  9 Mar 2022 02:33:24 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u10so2263251wra.9;
        Wed, 09 Mar 2022 02:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2TIhBGZZT2Sdj20iP1ZMGyRasB0aL4dQ4VGA6wpujWU=;
        b=SLnnOOaUySE/vVlhHO0c/KRIc7THdFeNsIMeGM1c/hHtnb+0WLrJkcfu7tpE9dg8RT
         TtuGO8SRKPGYUU9vbfnQNuNL6SdXpc6Lr9vtP/P+WVo+vs6/pOZFhbnly7oP1TGgzBII
         z9DQeCX0jk0v+3BRYzfZRxw64ZMHeLyV3fbKx0B9JGv6FKYROzJS1BDjoCtgujYxLmSs
         K1Hw+RxoZcK1T1stvKHE7eBoHwp1UIzTAIdF8pTV4XvqWhBf5T5/o0hYiNl0VWIvWRR1
         xFFYBw7xlvmpV29GmhOapd5BVSGez/1Bj9H8JgDOI4k0KpOqcJgBmBxwqZ2rGMBKv0Yw
         6GZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2TIhBGZZT2Sdj20iP1ZMGyRasB0aL4dQ4VGA6wpujWU=;
        b=3/hTsAXU9ZTxFtKJDaaJQ1suLfldqKT6PXvG3lwR4f1qt96yrrLjrNdbnoU2YTkbeI
         ySTIO2co9BQVSU2pC5jssGH3yeg93xT3lU3fKpTzlMvlVInTqjOw619GFAj/SgvQ1pwO
         BgQ9bndjTuKLHi1Jd0iFumfACapJ7LiL5T9IDzYP+eVN2Q1MykwPuAUAP9xTtM61bjNq
         Ml0Di0NZw07P8y/vg5ZpCT4k6ITk9NAcGRFdpO128WEAFOBAlt2pIY2J3JJo+OtcbjnG
         ArakxNG2/RvKolMoXJqjZv+efJoWN5s9OE35dfORfjDrCh6c+FjBquG1CJvvLul+HKiB
         vFSg==
X-Gm-Message-State: AOAM531x8UQc0gDtCXVQT7k9R0eF8GlDRlhT34FdNKOaNANRbBY9e8Uj
        gLDyEnVbSUKHN9GqSVj2q92bnCpLS7o=
X-Google-Smtp-Source: ABdhPJx3I4CgjUpRaHWG6b5XR5TDvqoHm2ZOnASwxM/9LBEK2jnkDeM8X5SIRtt0bHfv7whyKHx9ww==
X-Received: by 2002:a05:6000:1449:b0:1fc:a870:4b85 with SMTP id v9-20020a056000144900b001fca8704b85mr8097325wrx.639.1646822003335;
        Wed, 09 Mar 2022 02:33:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o19-20020a05600c511300b00389c3a281d7sm6250982wms.0.2022.03.09.02.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 02:33:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2f983feb-0afa-ce3d-5065-bd27d3a6a948@redhat.com>
Date:   Wed, 9 Mar 2022 11:33:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 19/25] KVM: x86/mmu: simplify and/or inline computation
 of shadow MMU roles
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-20-pbonzini@redhat.com> <Yiev/V/KPd1IrLta@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yiev/V/KPd1IrLta@google.com>
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

On 3/8/22 20:35, Sean Christopherson wrote:
>> +	root_role = cpu_mode.base;
>> +	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
> Heh, we have different definitions of "simpler".   Can we split the difference
> and do?
> 
> 	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
> 	if (!____is_efer_lma(regs))
> 		root_role.level = PT32E_ROOT_LEVEL;
> 

It's not that easy until the very end (when cpu_mode is set in 
kvm_mmu_init_walker), but I'll make sure to switch to is_efer_lma once 
it is possible.

Paolo
