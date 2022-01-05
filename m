Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6048484C3C
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 02:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiAEBt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 20:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiAEBt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 20:49:56 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D18EC061761;
        Tue,  4 Jan 2022 17:49:56 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p14so28271843plf.3;
        Tue, 04 Jan 2022 17:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=FBngTPEkKGMKclGP0jgxcSSrlzNxGXYaIdpSTFqmKCM=;
        b=VDLH5aWKyMQjoGskHxiwFVkADFp6eqVezg8OIKixHyk4gGsFxJq2MBl4Gv5Bj6hU9T
         VxrSCFegiQbvRn5BN6klakMrflTrbHqGZlyNhOVvzQ+Bl8xE2i3NDGm2At0Ev2libubR
         3wMQF26EeyJmU0NbIoWXfOhAxTafL2oO0XLA6baGtgHBLTZdjeOCr+ioSOkRIY5zlJKC
         ATeo4Cunl//t5BgXlQqz0ADhc0g8bjVvEc/dcrEIYaIXwLNzCU8FpxFoqxINGSO0rsla
         2tSkszmTh2z9Mk6X+26XsMIJkKn6cZyj60hkqcoJ4B9IatVZy64shESFf07S/c+zJziH
         qZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=FBngTPEkKGMKclGP0jgxcSSrlzNxGXYaIdpSTFqmKCM=;
        b=GPO2XoUSseITKAHP3SQijhOjE5nKCmN7q1EziSRFymZyw5G7qpsDvNj/IerYCiLdpY
         G85uS1FB3yBKfIxGtwQTV/77+H36ePBhU5vhJfAjgFGSyAFwTRxu0hGrlNqSePmWFdan
         kJbcmgM/1dCEc1+p2CrlN5S85fNO/XSVzKm7hAOfQSnnC2f1lcM+cNljEE2yZhL7UBp6
         //xYzxFOPnJeVDp0iPOFNyt8cyKlwnCvpbGSKP2xwQ+7DjTDFOLIcSmxrNirXuQj7xWP
         9T7nOCkipXy3xwf9/Rkl9DybUPz7Dpv1Ynuu/FWb5u4T2USlvmq6FW3O2uJ/7X4AbhvX
         NK4g==
X-Gm-Message-State: AOAM531UTgf7eIvcchr00WLne7KGlH8+mTiDpm6CJqHs6h+CfnrIoM7x
        JqqvyhPOopwvnZTA9g21T+E=
X-Google-Smtp-Source: ABdhPJwpt3SF+XTj3kPEy836ROsz8IVpdU1BSDzuSQGSYszu19SCL991lLNtj+w4O/f27o4SmKFoEA==
X-Received: by 2002:a17:902:bb87:b0:148:a2f7:9d8e with SMTP id m7-20020a170902bb8700b00148a2f79d8emr50996520pls.173.1641347395650;
        Tue, 04 Jan 2022 17:49:55 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 93sm549923pjo.26.2022.01.04.17.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 17:49:55 -0800 (PST)
Message-ID: <4a036416-b2db-18b4-25fa-6d4aaddfcdeb@gmail.com>
Date:   Wed, 5 Jan 2022 09:49:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v11 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice
 Lake Server
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211210133525.46465-1-likexu@tencent.com>
 <20211210133525.46465-2-likexu@tencent.com> <Yc321e9o16luwFK+@google.com>
 <69ad949e-4788-0f93-46cb-6af6f79a9f24@gmail.com>
 <YdSDEUJQgJQfZjWD@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YdSDEUJQgJQfZjWD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/1/2022 1:25 am, Sean Christopherson wrote:
> On Fri, Dec 31, 2021, Like Xu wrote:
>> On 31/12/2021 2:13 am, Sean Christopherson wrote:
>>> On Fri, Dec 10, 2021, Like Xu wrote:
>>>> The new hardware facility supporting guest PEBS is only available on
>>>> Intel Ice Lake Server platforms for now. KVM will check this field
>>>> through perf_get_x86_pmu_capability() instead of hard coding the cpu
>>>> models in the KVM code. If it is supported, the guest PEBS capability
>>>> will be exposed to the guest.
>>>
>>> So what exactly is this new feature?  I've speed read the cover letter and a few
>>> changelogs and didn't find anything that actually explained when this feature does.
>>>
>>
>> Please check Intel SDM Vol3 18.9.5 for this "EPT-Friendly PEBS" feature.
>>
>> I assume when an unfamiliar feature appears in the patch SUBJECT,
>> the reviewer may search for the exact name in the specification.
> 
> C'mon, seriously?  How the blazes am I supposed to know that the feature name
> is EPT-Friendly PEBS?  Or that it's even in the SDM (it's not in the year-old
> version of the SDM I currently have open) versus one of the many ISE docs?

You're right. The reviewer's time is valuable. Apologies for my wrong assumption.

> 
> This is not hard.  Please spend the 30 seconds it takes to write a small blurb
> so that reviewers don't have to spend 5+ minutes wondering WTF this does.
> 
>    Add support for EPT-Friendly PEBS, a new CPU feature that enlightens PEBS to
>    translate guest linear address through EPT, and facilitates handling VM-Exits
>    that occur when accessing PEBS records.  More information can be found in the
>    <date> release of Intel's SDM, Volume 3, 18.9.5 "EPT-Friendly PEBS".

Applied and thanks.
