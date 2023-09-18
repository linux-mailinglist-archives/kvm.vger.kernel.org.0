Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10EC7A4BE4
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbjIRPXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbjIRPXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:23:32 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C0134;
        Mon, 18 Sep 2023 08:18:31 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-401ec23be82so49654455e9.0;
        Mon, 18 Sep 2023 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695050309; x=1695655109; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w54mgLsXZyF9Sm0smxclmce0mhDWz8ur28XiwaO9K0k=;
        b=bIl8TWunvgTXQoJvFqAlgKAINfWznxSCGcfjYHtswN3+3UDSw2oMDVE/+h4aj7eVge
         abeZQv7xM4BRXidVUizOWWe1EZxHQN9hp7SwAvHWdWTzK+0DyM0tke4Ra9jpxHf13MBI
         bg5DXmIEpwPXfRF4VKwIWj8Act7ymBsG52dCA92oTe8FHc9Bdp2Jnq48PtXVliBYi8D8
         BaIZIV0y8J3lQB+X3LzVU9J/mT+IBztiXKlKLDslMeCOo0MU7yS0S/ZSJ8lihX/ZRDld
         etIjbZ5A6fe+DohDS+nTaqurEdYHFEoLvS/2fS3DTMLDvaZR/UWLYHzGOnCsyMgMIBut
         fpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050309; x=1695655109;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w54mgLsXZyF9Sm0smxclmce0mhDWz8ur28XiwaO9K0k=;
        b=KR/KXhvOoEwFJQkhBeYP1AIG9GPglWW2UGCNwNqLSv7SuBeY83ObKhOjttWBm2W9DP
         /VxHaRM6Pqc2hqPTWVa1qiuqdQMQwBrn6czTvQS5dneOoWlNokQeARtKb6sUJLYbUgRb
         HmsnRfggx93mUuHObS7JMrYJ/UU268aTZy2gDfKtzoKILx6hZpntWL5yk9yBTzue5ZgV
         1Z6sVUMlfVGu5/jQpLLvpdu2iiGvqMJ3Avd4Q5Yf+g+8ocsAN5mfL1oi9MGqj0ELVXLc
         W4UKiB5ZlGHriESEoIyldFBXRrErABPlwlvztf0HLTO22othrrIbFnFrB66UHoTV5WtB
         yYlQ==
X-Gm-Message-State: AOJu0Yzi3T04VNa0pg/iOeEh4K/zNwIryIDcV0BR3ZtXM6qrca+oaGMW
        mqqG3ep5FOSvVIsBoR5tQCYIZM5OZP6iXHWZ
X-Google-Smtp-Source: AGHT+IEeybKZqRsHJfjXdSZZ4nUev8Gj95QgSsAtbd8Cd2rs1soTdJJGYN81BScGjqPkhrDPOWUOEw==
X-Received: by 2002:adf:a3c4:0:b0:31f:f664:d87 with SMTP id m4-20020adfa3c4000000b0031ff6640d87mr7135072wrb.20.1695043461087;
        Mon, 18 Sep 2023 06:24:21 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id f13-20020a5d568d000000b0031fd849e797sm12502050wrv.105.2023.09.18.06.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:24:20 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e5cba995-7525-de56-fb0a-97697fe41cc7@xen.org>
Date:   Mon, 18 Sep 2023 14:24:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 10/12] KVM: selftests / xen: map shared_info using HVA
 rather than GFN
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-11-paul@xen.org>
 <9b172014d6ce533fd45b4c79f9cd0dc30b0029d2.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <9b172014d6ce533fd45b4c79f9cd0dc30b0029d2.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 14:19, David Woodhouse wrote:
> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>>
>> -                               ret = pthread_create(&thread, NULL, &juggle_shinfo_state, (void *)vm);
>> +                               if (has_shinfo_hva)
>> +                                       ret = pthread_create(&thread, NULL,
>> +                                                            &juggle_shinfo_state_hva, (void *)vm);
>> +                               else
>> +                                       ret = pthread_create(&thread, NULL,
>> +                                                            &juggle_shinfo_state_gfn, (void *)vm);
>>                                  TEST_ASSERT(ret == 0, "pthread_create() failed: %s", strerror(ret));
>>   
> 
> 
> This means you don't exercise the GFN-based path (which all current VMM
> implementations use) on newer kernels. Could you have a single
> juggle_shinfo_state() function as before, but make it repeatedly set
> and clear the shinfo using *both* HVA and GFN (if the former is
> available, of course).

The guidance is to use HVA if the feature is available; a VMM should not 
really be mixing and matching. That said, setting it either way should 
be equivalent.

> 
> While you're at it, it looks like the thread leaves the shinfo
> *deactivated*, which might come as a surprise to anyone who adds tests
> at the end near the existing TEST_DONE. Can we make it leave the shinfo
> *active* instead?

Ok.

   Paul
