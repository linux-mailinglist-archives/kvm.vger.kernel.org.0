Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CA561EBE4
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 08:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKGH0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 02:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiKGH0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 02:26:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217A0BE19;
        Sun,  6 Nov 2022 23:26:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so9848642pfb.0;
        Sun, 06 Nov 2022 23:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KVq68Qs/TMwcZHogjsQmq/uIiLZOFgV4gD8jaho36t4=;
        b=cb+5skGlWUAvNodNHcvclXRCJm6IQzky5RJkWzuCJMaTiZzbL4HACsCTzygxiMyYvj
         IuUeduu4WZAtjNR+LYirQ9P6wcF/+Pots1UhvcNhN2y/HYSw6YRERTTazKBuARHqrdwO
         Z1CvkaTHag9uPC+W5BGBCTgO9DMcZ5HktwnYrWmcahLLG9R5U/e6zC0eb7fUFtstg/Zb
         GkgZ8lV4Kh2MDTQuNEg4lWm116Uy0795vL5hfWvbbHot9Cmg85BGMZEMVX0ybBwrQi/2
         gSH9EimvEDOujtVd+nfaF0tHwRxZr8suiyVWDMEPvhjG9jw+LVpdfDMPjFVAvkpqdqVG
         MjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KVq68Qs/TMwcZHogjsQmq/uIiLZOFgV4gD8jaho36t4=;
        b=OgoZoviBvgjoa1lEzJV5fyeP9bm7/Wef820UeerTLzchMFW4dUgsr3vLlBRjj6rQG6
         72AP5rao2vAdFIuOv1kpfhCDyRux8pyRljdekn8JzvxeXDmvFXpCObgY4FIWsp7CV5D/
         vWaEtOyI8pHHUOqu6tdSpOD+y2mj13kxzQqxpLj1HpikSk19jr5hQpUT2lECO1OX5JMw
         UucSa0lmC3U6n3xQUk+uTEjFotUnkxnD9crlKzQmskRVH+SNE6MlcyxX0wprQLYIql2y
         wAtheCJz0IHL7a73aW82t0AjK6vCYo0m/GUQVx4Izf54YNqynVkTaa/jcRxE0Ei86pMJ
         e7Ng==
X-Gm-Message-State: ACrzQf1HMX1l0eh0H+Xnxwp+lZuE+bcCgA6CXkJIXRl6cT9Qny13iV/w
        jxcxk4wC3ISRu4TNBJWw8Q0=
X-Google-Smtp-Source: AMsMyM5fjQ2o9+NbX1Jsi3q88fWAklrxMKVs/Tiqnk95fzy/z42rh7+SU68zl+Y33sCsh/cpEdgxyQ==
X-Received: by 2002:a05:6a00:14d2:b0:56d:b981:8da8 with SMTP id w18-20020a056a0014d200b0056db9818da8mr33486439pfu.36.1667805979592;
        Sun, 06 Nov 2022 23:26:19 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902ea0400b001837463f654sm4234918plg.251.2022.11.06.23.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 23:26:19 -0800 (PST)
Message-ID: <524f23fa-b069-1468-dfc6-fa342c11cb7f@gmail.com>
Date:   Mon, 7 Nov 2022 15:26:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220919091008.60695-1-likexu@tencent.com>
 <Y0CAHch5UR2Lp0tU@google.com>
 <a90c28df-eb54-f20a-13a5-9ee4172f870e@gmail.com>
 <Y0mL3g2Eamp4bMHD@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y0mL3g2Eamp4bMHD@google.com>
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

On 15/10/2022 12:18 am, Sean Christopherson wrote:
> On Fri, Oct 14, 2022, Like Xu wrote:
>> On 8/10/2022 3:38 am, Sean Christopherson wrote:
>>> Does this need Cc:stable@vger.kernel.org?  Or is this benign enough that we don't
>>> care?
>>
>> Considering stable kernel may access IA32_OVERCLOCKING_STATUS as well,
>> cc stable list helps to remove the illusion of pmu msr scope for stable tree
>> maintainers.
> 
> Is that a "yes, this should be Cc'd stable" or "no, don't bother"?

Oops, I missed this one. "Yes, this should be Cc'd" as I have received a few 
complaints on this.

Please let me know if I need to post a new version of this minor patch set, 
considering the previous
comment "No need for a v4, the above nits can be handled when applying. "

Thanks,
Like Xu
