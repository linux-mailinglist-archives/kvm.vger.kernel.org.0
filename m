Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAB5CAD4B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbfJCRiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 13:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389280AbfJCRiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 13:38:03 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6C717FDCA
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 17:38:03 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z8so1424546wrs.14
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 10:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lYo2GXCjdmNjbw8XriQ6Oi5EGNGdZIx3mlt6jwh3aLc=;
        b=p0V2aiLZOynIgCLTZS+7ci4e2K65tSBEg7N9uO9PYLz76Ho00XiV6lgsPPS/+5b+Fp
         6dQIgVLWhDzS0jwLx/w1cpbsDSP7BqI96lODyk4qTNtk/RDE4nvmp/x6Cny9BpLMjZv4
         lnl2WpoIFmTCr5nPe00rF3P317AtMm5pfyrJ8w1xWIPrIAfLNJj+RhMwSvTLG5EJEjFM
         2dI/99w8X5p8CNMvoZ3U1c7ght5tPB58cL0QBlhy7uU4nau7HMh5RsYORNSwTts2ol4D
         FR5tbNsyK6p9j4aIF7n2cbyf2o4uKL3MccOBR2eAkDngXBIp5RcZwC5Uny9hLB66ZEGx
         gk5Q==
X-Gm-Message-State: APjAAAWkqBl6R24u4t3cLRyddDHqYNZw302xlVwpXzw2NxV7I9jElTTx
        ZnThgR3xvCbamIReMjvLHTFlr5XMZQzQvKajcCpzYjZeNzDDRRnk20cO1ZF48aA+cO2Cj2jSYea
        vZJU5tNwPQGnw
X-Received: by 2002:a1c:4384:: with SMTP id q126mr8378375wma.153.1570124282261;
        Thu, 03 Oct 2019 10:38:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzEKq5aJk6CuYAnZXAOfVO7RG4gr7SrDCJd/9DLazu4cJxcuFQ2bh6dgmgX7bvVQXHfJKqpqQ==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr8378354wma.153.1570124281992;
        Thu, 03 Oct 2019 10:38:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id s12sm5445982wra.82.2019.10.03.10.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 10:38:01 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: omit absent pmu MSRs from MSR list
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eRFUeSB035VEC61CzAg6PY=aApjyiQoSnRydH788COL4w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f8e169a5-4cf6-8df7-86bb-f70a480c33ad@redhat.com>
Date:   Thu, 3 Oct 2019 19:37:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRFUeSB035VEC61CzAg6PY=aApjyiQoSnRydH788COL4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 19:20, Jim Mattson wrote:
> You've truncated the list I originally provided, so I think this need
> only go to MSR_ARCH_PERFMON_PERFCTR0 + 17. Otherwise, we could lose
> some valuable MSRs.

This is v2, so it was meant to replace the patch that truncates the
list.  But I can include the other one too, perhaps even ask the x86
maintainers about decreasing INTEL_PMC_MAX_GENERIC to 18.

>> +                       if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>> +                           min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
> Why involve INTEL_PMC_MAX_GENERIC here?

It's not really necessary, but I wanted to imitate how intel_pmu_refresh
initializes pmu->nr_arch_gp_counters.

Paolo

>> +                               continue;
>> +                       break;
>> +               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 31:
> Same as the two comments above.
>> +                       if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>> +                           min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>> +                               continue;

