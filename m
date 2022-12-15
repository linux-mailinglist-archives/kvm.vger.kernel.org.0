Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68164D8CF
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLOJnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 04:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLOJni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 04:43:38 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CFE2BE4
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 01:43:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so2132346pjj.4
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 01:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dNl+I3+2wsmWm9OlHEeo9xRCdSepAcotXH/QyvUQcc=;
        b=D7XcMHO8IJTYyFeXIyGguZVxZdii9MGTG8X2OCSvAnOS2b145GtUFEBQEWoIpgnVoZ
         mQv+16MszA+a05OoDMTT7s3mW9ZcUROlpK5leL9rM9Q8ijvPlNXuzFFvksfwkYa4q7L0
         tqZGK+4vzFzPlirirn8CcdXgQvWMI435m0bCwoXVa2eAq5hgbJDTFhjOi7jTXPkhA7SG
         f5bQE1ppCKApGZdWg4PmCB0tO75MRPkB9FJSQNcVlbTpc5punCXiehtUNAss1ONKnE4k
         uMlSggET5TkIzvgFC/sTAtGH82XejLYB4d3v9XwtOMN+QdeskgXkDpEwdgVJpCTMSWTC
         ZTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dNl+I3+2wsmWm9OlHEeo9xRCdSepAcotXH/QyvUQcc=;
        b=Sp3/EBDw6ZRLd1x9fckCMJ6zmIIBV4uD1wdRCctcDZx7sFGxZwltk256IR5iP3qD5A
         EBiGrOVh+zhVbiKO8Ti92nyXjzEonzocgw+vPfC5f953WyW1WZhM7i47dN4Es/TU+J6T
         dFWEqwctQZx+MsHAY0ckvxTlLc1GzLcGzJB4DMM2JcCgJSSEmLJwmZtuCExFm7Bj0x/t
         +GUuK0oBU3lEfMryOhmwP96wUljMR1RV3vYtLL0vvBnZJR1nk3maG2sJ9MIb/qCl9wIq
         9m4IzkaBs0FFFm/swCQmJx1Umnja7Mn7jfmoRbgDEbul8XyIUjGyoYW5Px+bWjMIZ/5O
         KU1Q==
X-Gm-Message-State: ANoB5pmCudxRQSPdxSsSHn3ryYzQ1SXtVyerAsE0xQRu45tqNY6nWCbU
        zuzDmaG/UWIpAKlDxLlZwEy+zAtoaE4jujfy
X-Google-Smtp-Source: AA0mqf6AN7XM485uFKUPD/FUJCLM5u8hdAC4XpnDK3ArG7RhG+ObY0ZSkF+o8mMi0IzetzoD2PabKg==
X-Received: by 2002:a17:903:22cd:b0:189:e16f:c268 with SMTP id y13-20020a17090322cd00b00189e16fc268mr38742294plg.20.1671097417145;
        Thu, 15 Dec 2022 01:43:37 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q10-20020a170902daca00b00190c6518e30sm3329383plx.243.2022.12.15.01.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 01:43:36 -0800 (PST)
Message-ID: <3f0a7487-476c-071c-ece9-49a401982e40@gmail.com>
Date:   Thu, 15 Dec 2022 17:43:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v6 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <20221021205105.1621014-5-aaronlewis@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221021205105.1621014-5-aaronlewis@google.com>
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

On 22/10/2022 4:51 am, Aaron Lewis wrote:
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_S390_ZPCI_OP 221
>   #define KVM_CAP_S390_CPU_TOPOLOGY 222
>   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 224

I presume that the linux/tools code in google's internal tree
can directly refer to the various definitions in the kernel headers.

Otherwise, how did the newly added selftest get even compiled ?
Similar errors include "union cpuid10_eax" from perf_event.h
