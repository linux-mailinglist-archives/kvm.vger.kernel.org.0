Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6033546F3DF
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 20:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhLIT2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 14:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhLIT2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 14:28:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2489C061746;
        Thu,  9 Dec 2021 11:24:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x10so5567563edd.5;
        Thu, 09 Dec 2021 11:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eh5xIGa3hUB5ARrPKMXOtqA3c4XCtDn8PDDAuOSs4Ps=;
        b=mhnlKHNneojwFfnrhX64PVlVBIqKf/jsyY2ZwEBxKPI7MN8PNJrqfgZsZLqlmu0klw
         Hol2srwNsxPm9dXrHte3WPdcvix6Gu9TyDr8bvTbppkNkWL8CLCIo841WcMk1FamSrm4
         xu6DP1Xl3Ppmpz4Y+XqnGEIA4dhWgrcMb/Xsa7crmGIReRjTa8S2JTNj3UdpPcecwcor
         2ev79Kdxv14bnC3Y3zUu2oI0CuKZFX3CWR1IdKWHx9Lyk3ORARokhIl/jWn6qKSUaBnH
         SEUPeR1+3Pj1lbYi66vJXkHueCxMhG4HW0azTXIqhjKocv0jGbJB+4EhdScwF4kPQ6rf
         SGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eh5xIGa3hUB5ARrPKMXOtqA3c4XCtDn8PDDAuOSs4Ps=;
        b=QnT0PD7aRs4h0LNxU66iw684kPXbLNMkD6sxiVYxQ9GBxKMnLLwbDvNSChDjvR2ikl
         LC5LQrCzdqhBMHjfrCD/XByxKOKXTXoDPnOX3GEydEIFFzfnY5NNKA1kWONFXeoXqGv0
         DuV7ItuG2lkBctGhr3ASaCcZsIE3iIxZC/Saux913NbhdvEYt3ZrtQmOv/aKMqpMYjkR
         xJ/lRYWvfFkLCzZSgA0oNM2BRy6apthOTrp5uSVF2AgbfaoK9uhnL6ccOai0nFC/O7mn
         eCHvotlVn3NoMl8jQ8yXarth5TfyY7jSgb2UrC6lJupYGUCp+akVYX9KrwkB5TRwRMQq
         gEQQ==
X-Gm-Message-State: AOAM530WAmVO2MRvSA50P532UOaWd3acyxCQYhC5FP6yD1fvvaoFDjLv
        WPvv2ELv7PALsuFCgFbdiSM=
X-Google-Smtp-Source: ABdhPJwTwCSTGYFUp3u99b2ZtBI+FBff0kC5ISPOIhDHQXJIaZGtOrplUBsYtIutarhqHTxitrWJUw==
X-Received: by 2002:a50:a6ca:: with SMTP id f10mr31335359edc.81.1639077876358;
        Thu, 09 Dec 2021 11:24:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m16sm316575edd.61.2021.12.09.11.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 11:24:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <9edd8c8a-26ee-9615-4b64-0ddeab1e9184@redhat.com>
Date:   Thu, 9 Dec 2021 20:24:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eRaZBftkaFsmfH8V519QdSGKTORp0OAZ2WaNi3f9X=tng@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRaZBftkaFsmfH8V519QdSGKTORp0OAZ2WaNi3f9X=tng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 04:52, Jim Mattson wrote:
> Why don't we just use PERF_TYPE_RAW for guest counters all of the
> time? What is the advantage of matching entries in a table so that we
> can use PERF_TYPE_HARDWARE?

In theory it's so that hosts without support for architectural PMU 
events can map the architectural PMU events to their own.  In practice, 
we can probably return early from intel_pmu_refresh if the host does not 
support X86_FEATURE_ARCH_PERFMON, because only the oldest Pentium 4 
toasters^Wprocessors probably have VMX but lack architectural PMU.

Paolo
