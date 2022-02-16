Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F494B7FE0
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 06:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245411AbiBPFJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 00:09:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiBPFJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 00:09:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D02F955C;
        Tue, 15 Feb 2022 21:09:01 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q132so1142519pgq.7;
        Tue, 15 Feb 2022 21:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ed0DvBP+K1f3QF5Ewx4kaCIp7iK5SB0WDtzvGvgXR8Y=;
        b=Tavmo/STkPM87v5QvmnaIJA9uwaiGi094499+s5845fdSfeqBajvmQp2MnCGYsM/gp
         6pTatN8kwqiRx8xgMDpt34sdD2tn8PWJ6P6aWd2HB6wxhOqX4IeQmgx5giXhSURu3HNr
         CgWvDx1McGECUfzE23JM7X+2AXOQ7RWo/eNWYU/8+VEYeMKENQ1iPm5T5s7HCkpZd9cO
         tuAEhaCW7GPrHBA+jHv79k1GivJwU+46Hu9QvF4EiNgUjSviPDZ933a//HqAfgazd4Z9
         pm7y+aezZsCjEREXf9gAIJLqa/43UtKHRgI87qBkJVcGOjpyLaOg+sTV99eA1HXy1vJy
         p39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ed0DvBP+K1f3QF5Ewx4kaCIp7iK5SB0WDtzvGvgXR8Y=;
        b=4y3uAflFV93NETNdUOurf+gTqKy9j4wfDwPteSbqCgYDcdFM7Mt+cjyvbWaQyVyUST
         QXEtoELb6SgCsn5L/OBBEwRA3tQ1MfSZTbhHcGpDqP4XG06Du76KAqYBTuBuvITfAtRz
         slEmaf91hLtu+TEvd+f+nspUPWYI5afjb8DrhoZRBuZityjy9+PlCSzkMcu1Cqrw4Qb3
         0M5TvCmr5u5iYfWe1iESoJZ4pPjDjUCCLKxG8TgF2yXGVno5/5ZNI/Gkp/3uATn1tcHN
         MIyDLCfRu32ARAFMxb8/r/wMs4esUBJWGd9l074+SE00skf7Uv7wNsVSBIQVRptKiWFx
         uzsQ==
X-Gm-Message-State: AOAM532hJt8qE135isvWOTQyZOZuyulVUyZxbn6S9KGlynY2dlhuqmh5
        8qrLUn7Hbakxh/B9UrIz0TI=
X-Google-Smtp-Source: ABdhPJzkqudfNEvGNM4ofBoq97r0Ol89SosLVDk+DXzSa8YLZpX3vbRrSSyDLNOUFg9K8+6G4xvThA==
X-Received: by 2002:a63:9dc3:0:b0:373:5fac:6063 with SMTP id i186-20020a639dc3000000b003735fac6063mr852210pgd.531.1644988140627;
        Tue, 15 Feb 2022 21:09:00 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13sm28423111pfx.122.2022.02.15.21.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 21:09:00 -0800 (PST)
Message-ID: <ca93d33d-a25c-ac04-5b4c-b60380cd4e97@gmail.com>
Date:   Wed, 16 Feb 2022 13:08:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
 <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
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

On 10/2/2022 11:34 pm, Liang, Kan wrote:
> For the current perf subsystem, a PMU should be shared among different users via 
> the multiplexing mechanism if the resource is limited. No one has full control 
> of a PMU for lifetime. A user can only have the PMU in its given period.

Off-topic, does perf has knobs to disable the default multiplexing mechanism
for individual tasks and enforce a first-come, first-served policy for same 
priority ?

The reported perf data from the multiplexing mechanism may even mislead
the conclusions of subsequent statistically based performance analysis.
