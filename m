Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A63F5A259D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245495AbiHZKOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 06:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245102AbiHZKOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 06:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910CB72A6
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661508873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLsMpZl6pKYr7WS0pD17GyZwc7LDBjeF1ao0OHp8dGw=;
        b=G07r7/YHW3nBIG60Qkk/Cht9OvqIIOu8yYodiEOBN1eH+ipr8w15bqqu0cWgxm9Twl8c8E
        KI1KUBm9lqZskzlYjdlv12gs8129OJRyutElffPMGfsFkTFJ/ZUOasLHoZah7ihKvKLhLR
        pgIbGSIPxwHPsA3mKIB0t1ElRLuPB58=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-9RR9LbzcO1Oeu3sA_e9EHw-1; Fri, 26 Aug 2022 06:14:32 -0400
X-MC-Unique: 9RR9LbzcO1Oeu3sA_e9EHw-1
Received: by mail-ed1-f71.google.com with SMTP id i6-20020a05640242c600b00447c00a776aso857296edc.20
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kLsMpZl6pKYr7WS0pD17GyZwc7LDBjeF1ao0OHp8dGw=;
        b=nkPhJXE0nnTA+x2QJICkb3NtbzbvXM7+wvwWkaDmI4pwKF5QsuveqbOmU6exAcxsHT
         4IJWkgSI0UrHt/cGuysW0H5uPE4RyzfF6MBtFEzEOKxYH4yqHnuDbd4fKW/rNtmaSpm4
         6djaG8AhjYDXOws+FXAAap+WKCx8pgvQjkwux+CcB7PysHPjm9HL6YLfeIBUIQFyGxfG
         J8ZTU+luJYHhlp83EgbRRZMYpbQSKXslmVW8JqvjKPSMqP3oX/rs1jnVqXdMhvIIdP1L
         NHyxICGznsYQ2mryd6qThrfiEPK8XdFXjVLnO3Y1OyMdnkUsrgUggD0gH4PTLC4Q40TQ
         98fw==
X-Gm-Message-State: ACgBeo23q/U2eI7kfDhOKBeI/58AmI2pMl5t/gBTfgqpdwu6kzdaDadf
        l3uGgmLMICusjSz+vykUypfruUedFBnkLRe3q2nIFkC79fGxiKCsEJX1xZafsfgeJpmOtqMCS30
        8kQ967KIh0gxu
X-Received: by 2002:a05:6402:3596:b0:447:11ea:362d with SMTP id y22-20020a056402359600b0044711ea362dmr6348253edc.117.1661508871303;
        Fri, 26 Aug 2022 03:14:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR61958O0SP3ojKwfYX23ngd+Dh+aUFS3g76QnzgJsqidkUdenB0JJsJ4POiZUw39HMhYnJNIw==
X-Received: by 2002:a05:6402:3596:b0:447:11ea:362d with SMTP id y22-20020a056402359600b0044711ea362dmr6348242edc.117.1661508871105;
        Fri, 26 Aug 2022 03:14:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id kw2-20020a170907770200b0073872f367cesm716150ejc.112.2022.08.26.03.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 03:14:30 -0700 (PDT)
Message-ID: <7558c548-7866-9176-34a2-056f4a72a483@redhat.com>
Date:   Fri, 26 Aug 2022 12:14:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Content-Language: en-US
To:     "Mi, Dapeng1" <dapeng1.mi@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
 <YwZDL4yv7F2Y4JBP@google.com>
 <PH0PR11MB4824201DABEFF588B4E0FE34CD729@PH0PR11MB4824.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <PH0PR11MB4824201DABEFF588B4E0FE34CD729@PH0PR11MB4824.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 13:31, Mi, Dapeng1 wrote:
>> I say "if", because I think this needs to come with performance numbers to show
>> the impact on guest latency so that KVM and its users can make an informed
>> decision.
>> And if it's unlikely that anyone will ever want to enable TPAUSE for halt polling,
>> then it's not worth the extra complexity in KVM.
> I ever run two scheduling related benchmarks, hackbench and schbench, I didn't see  there are obvious performance impact.
> 
> Here are the hackbench and schbench data on Intel ADL platform.

Can you confirm (using debugfs for example) that halt polling is used 
while hackbench is running, and not used while it is not running?

In particular, I think you need to run the server and client on 
different VMs, for example using netperf's UDP_RR test.  With hackbench 
the ping-pong is simply between two tasks on the same CPU, and the 
hypervisor is not exercised at all.

Paolo

