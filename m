Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B754D9DAF
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiCOOfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349288AbiCOOfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:35:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34683344E2
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:34:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t22so5148439plo.0
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YojoflKnPi3o7mgz+e2p0ycMHg/s+IEIjxf6odh0WnE=;
        b=MFrj4c3thqJQBHLLdX7z0QRRAOKmEdCfHCxKR0/doyRUxHWy3IoxRoa9ffqcoomVIg
         KFFS0Fje1Zm5StfLB6MoF7JrNdIF+7uvwzAYq2/2XYbmJizERnSXQSQu5z4kHUgsy78O
         LbL8P3ZzoAhG4s9WKFcYBH5FKFk3ql1k8nVH0gbuF1jZpYxeGZIqfbmQqB9FYQQWs1bK
         sEnqdUkHuK0LB00+PqAa5+pxNz8RQG+9P2Pr9N2fy7us0CHBFallgoGWO8C3HgVEtIw+
         I35wdbEKCTx37p5RBOJzx3hzzzZGnjitrWS5pzs/PegDjdM0VseQVPtAt+MK5tJegT7w
         9I/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YojoflKnPi3o7mgz+e2p0ycMHg/s+IEIjxf6odh0WnE=;
        b=O1PCHejm8/kNCNldcMsiuLhj712olCnOox4RYdb2kn56RTVjDcZLgxVIj5euctG2fu
         mA8gcuercCjdxUFCd3RgYNlbHILIh5l4M826wScbMuCnSliQG799TqkH7nB0FFVNygNz
         7BkuoVZx8PAdnh2DnlmjMUWpEX6j8fJSY/f0jFWH9/7ODT6o1qRfvf4hOvPln+0X2yfi
         XwIhPHrlrzuLhU723EIGL+TAywxMhdDqaQjtqKz56pL6dV0gJU68KypIcVVa5yJqG6Ix
         ozfnXCS5X0A3tj00nGhViyOHA8FRToaoQTUzZAVmwkyICOyUR228OWiRt4VWphuH9/XE
         KOhQ==
X-Gm-Message-State: AOAM530qOgalQZpgPr+QrGn26uzE2eo90kScNlKu53jRwC1c4J7Pt4oA
        0DGs4O5QofWK7pLi1SnZ0KE=
X-Google-Smtp-Source: ABdhPJzj/edktQmarfh7LdMS7Hc5zvtjAjcgDvvi14QDY/eoAYCiZ+lBXNHFb0Pux+P4HAiMQBMllg==
X-Received: by 2002:a17:902:e8c2:b0:151:cae6:46fa with SMTP id v2-20020a170902e8c200b00151cae646famr28527333plg.164.1647354846250;
        Tue, 15 Mar 2022 07:34:06 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id p186-20020a62d0c3000000b004f6fa49c4b9sm23379293pfg.218.2022.03.15.07.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 07:34:05 -0700 (PDT)
Message-ID: <608adc97-35e0-8f34-7241-5d1243925a4b@gmail.com>
Date:   Tue, 15 Mar 2022 22:33:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln
 MSRs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Lotus Fenn <lotusf@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>
References: <20220226234131.2167175-1-jmattson@google.com>
 <CABOYuva10sQbxkLPQax7egLyq2Ho-fFS0Xp7XR18NN=e-VOjNQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CABOYuva10sQbxkLPQax7egLyq2Ho-fFS0Xp7XR18NN=e-VOjNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Like Xu <likexu@tencent.com>

We may need this for legacy guests w/o df51fe7ea1c1, please note the
proposed changes to the (AMD architecturally defined)  #GP behavior
for AMD reserved bits without qualification.

On 27/2/2022 12:54 pm, David Dunn wrote:
> Reviewed-by: David Dunn <daviddunn@google.com>
> 
> On Sat, Feb 26, 2022 at 3:41 PM Jim Mattson <jmattson@google.com> wrote:
> 
>> +               data &= ~pmu->reserved_bits;
>> +               if (data != pmc->eventsel)
>>                          reprogram_gp_counter(pmc, data);
>> +               return 0;
> 
