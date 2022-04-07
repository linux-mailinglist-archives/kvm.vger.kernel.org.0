Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF39B4F8106
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbiDGNzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbiDGNzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:55:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6401118665;
        Thu,  7 Apr 2022 06:53:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d10so6553859edj.0;
        Thu, 07 Apr 2022 06:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RtLEHMXofVwSigiZFruK1cViTW610dtmPpogWRx2vYw=;
        b=Q9vW21lD4OBM6tWcGgFjv4mr1Jlw8Y1HftqW6nKVE/kn8NU5nrtIRuKRZ0kvV5JTDa
         JUIetz7mC/8jEWgICzJHIl4QnlxBdT+jVEqvtH0UAYgP4jy2vakI7MqoldoILxFAhipM
         rBZCcxUXu0rIT6myNSOl1RMcCC9Sc6j5VPisJVSEDH54xkT8EXDyOWHL0yscGmpYhjbV
         KfOwAyduR8/tR1m3PPOg05GbXbxQKDc7iZVqSKQmTrUGeAWAeOkQMCB/kbuuPXp3IlVh
         UDk3ntcbwvFhkEBMRU57NgsggAtGvAOggUEGqHq8zLqJETfBvEzHsuOa0jkHeVwd4u/+
         PkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RtLEHMXofVwSigiZFruK1cViTW610dtmPpogWRx2vYw=;
        b=tuvUA6ZWUePU3votAoHpJvbhglY5ne0s7/bSOEqSkhVulzSvHfVi26i9f3rjhyqsRz
         nut1Wq1KD/RRSjwaQ5MImTn0h7yxLeEgFwjzJwGVh17LsgKhXISpCkfqGKGpQqws6gPj
         +KedLLNkr/v3Oso7ddua2aNA8RnlobjG1G2BwENkwt14pKEOf7cZlRxARd/sducpWg0o
         8M3zDAQBlBb5SbQsXjKxY9aQ7cpW8zsk/OpaMm6LkeAAtKKeWa4MICtFUvKChXvtZBHv
         i8oF5sVx8uCB/u6HF7Sb76dqTRtRD+kxkx6HWCMlreTsSFkmo4u83pPdSDKIe3UL7+34
         JwBw==
X-Gm-Message-State: AOAM531OlRS3xTzWQ324nteU4VA9PoP4XPiViAfVE/78ey1usTja1Jwg
        t+F2f01y9d2d9maKhg7HvK8=
X-Google-Smtp-Source: ABdhPJzfQSBegI2RHjRgjDsZUux0MM3e853t44jeZ9G6UHrN1tVMWA0IqES/TdKb+emQmclu7SoEyQ==
X-Received: by 2002:a05:6402:2688:b0:419:5dde:4700 with SMTP id w8-20020a056402268800b004195dde4700mr14644996edd.124.1649339581190;
        Thu, 07 Apr 2022 06:53:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c1-20020a50cf01000000b0041cb7e02a5csm7389585edk.87.2022.04.07.06.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:53:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <37a736d0-1f25-79be-4c3f-c8e8a5a62528@redhat.com>
Date:   Thu, 7 Apr 2022 15:52:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 045/104] KVM: x86/tdp_mmu: make REMOVED_SPTE
 include shadow_initial value
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
 <3f93de19-0685-3045-22db-7e05492bb5a4@redhat.com>
 <Yk4j0cCR5fnQKw1F@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yk4j0cCR5fnQKw1F@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 01:35, Sean Christopherson wrote:
>> Please rename the existing REMOVED_SPTE to REMOVED_SPTE_MASK, and call this
>> simply REMOVED_SPTE.  This also makes the patch smaller.
> Can we name it either __REMOVE_SPTE or REMOVED_SPTE_VAL?  It's most definitely
> not a mask, it's a full value, e.g. spte |= REMOVED_SPTE_MASK is completely wrong.

REMOVED_SPTE_VAL is fine.

Paolo
