Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1B86C9E65
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjC0ImZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbjC0IlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:41:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07DF93F6
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 01:37:53 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r11so32607040edd.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 01:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679906272;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JCsf64qoJ0zuxLLz8+aL8JaRFiRBBUNP3y6Axhcy5HI=;
        b=Mq7OBkZqtWIKDv//IYblZJ0qSp1ocjZ1TDqUTcG8SOT/CnR+mZEQsVGV0aWWQ9h41c
         vEOVv8OfCmeIiHsqwmPBc1dyAPPXnSOwBslY2SG5nOn+ufnf94iao3iYEYatCKeaTU+5
         8PeyeqRDH/Sui7WyMUWw1jauHpWKM1aWdfXn0hgj1F6Ujw64bVY/X5aUCyH38Jm+o6kj
         v4BM2Wy2kLcOxJwq+cxg8oGGmh4hvZ+UEEb5g4TTjT+k6JDwLrFh+au+SsgWDCZG5RmU
         9e9RHQxm5zcSsDhTHt+efBDb3sCOiCYzNxHZW45mQpjzCeupQTdgrkCTQgWbbiYhPjp7
         2p6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679906272;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCsf64qoJ0zuxLLz8+aL8JaRFiRBBUNP3y6Axhcy5HI=;
        b=vOocCa6Ro/OHqMhHK+1xnyF+gNs0T/u8xgFCEOr6k1tMfyGG7xz02qvWqyMwhVrWJX
         fKvQLnuMOdSk7hAXvoBSv9huQXo8gCCi3Cdu/dB/TGKk5MVNSBFnMSMyTI86G1kcJdhU
         Y9+T0zVoFMzo/wcR75ttFtCMRfAnU9b6a5ZMLwr8HkLDGG0QWYIZhR7xhOYCvq+j45OJ
         AssDVwjxDppCrbE8FDxDCMtCKrfndYRCUEvwNchi3OzsoxD+AaRhxvnqN6V8h2phK5Lm
         qQnB4QZvNPW/JXHlMaSFTd6yCtlPD1IXOgrEUjQAEHmAojolEWY7xjEnYdmu2SAIq35N
         G1Fg==
X-Gm-Message-State: AAQBX9cxPo5+/9/hPwsvC9Ocfiuu60KSQgQ0kBRfZ/+mPH4MlutpMK+V
        hEynEkwZKFMOzv9ZKxaQNtjlHg==
X-Google-Smtp-Source: AKy350YcGrrwE+BXjHaGz0Jv07lrsbz2x6mzdgVJ1EVsG6EakTxsa6QMSJNNfJYSv9/7vktI2d/xRg==
X-Received: by 2002:aa7:db96:0:b0:4fd:2ad2:13c4 with SMTP id u22-20020aa7db96000000b004fd2ad213c4mr11648851edt.21.1679906272487;
        Mon, 27 Mar 2023 01:37:52 -0700 (PDT)
Received: from ?IPV6:2003:f6:af49:5500:8c4f:f203:6182:1e2b? (p200300f6af4955008c4ff20361821e2b.dip0.t-ipconnect.de. [2003:f6:af49:5500:8c4f:f203:6182:1e2b])
        by smtp.gmail.com with ESMTPSA id r3-20020a50d683000000b004c0239e41d8sm14390419edi.81.2023.03.27.01.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 01:37:52 -0700 (PDT)
Message-ID: <814c8975-17ad-f1bb-3b26-2175d79a1153@grsecurity.net>
Date:   Mon, 27 Mar 2023 10:37:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
To:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
 <9261e319-084b-b6fe-550e-31b3683776c4@intel.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <9261e319-084b-b6fe-550e-31b3683776c4@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.03.23 10:33, Xiaoyao Li wrote:
> On 3/22/2023 9:37 AM, Mathias Krause wrote:
>> Guests like grsecurity that make heavy use of CR0.WP to implement kernel
>> level W^X will suffer from the implied VMEXITs.
>>
>> With EPT there is no need to intercept a guest change of CR0.WP, so
>> simply make it a guest owned bit if we can do so.
> 
> I'm interested in the performance gain. Do you have data like Patch 2?

It's mentioned in the cover letter[1], quoted below:

[1]
https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

: I used 'ssdd 10 50000' from rt-tests[5] as a micro-benchmark, running on a
: grsecurity L1 VM. Below table shows the results (runtime in seconds, lower
: is better):
:
:                               legacy     TDP    shadow
:     kvm-x86/next@d8708b        8.43s    9.45s    70.3s
:     + patches 1-3              5.39s    5.63s    70.2s
:     + patches 4-6              3.51s    3.47s    67.8s


Thanks,
Mathias
