Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143C0CAFD4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbfJCUMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 16:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfJCUMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 16:12:54 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9351A65998
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 20:12:54 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h6so1611349wrh.6
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 13:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rerzWNDOelGSyyCVe9BrAyvD4JaZG3M8YLw2oByHjPM=;
        b=r6fH3Vl7ZbOECy2XOD0gvn4sCup1hDILPJmtqdzAKmfeL1uUpgzhQ3/IT8mElLR8jk
         JpQWOKKgkSsgrKjPEFVkiRKKpH/EzmdT2yw2S/BNO+NMebrLY2Ll4oJoV45przHHmPSu
         WtsYs2pkuewHWzLgJU5V4z8uF+cBRYJ1xJaW/K+QyglpjakRLrhYSoYFez+gfa7DyPa1
         QGqwruhfCw8LY7aMMbYJR/6hb/syxBvsQiO8fCZT20CbqkcjBlGsoJQ7+wtnHTSS1pDk
         64DQJ/kysrc+wLcfFC7qv9NAUYDpOBfbM2bPUac1Sab1EzTgF0MoZvLgRfd/02T5Q7Zc
         4w5A==
X-Gm-Message-State: APjAAAWRJOX7k4lfQXlilcW1ho+P24cCNLx+NS/Y0fxMxNKGJcftpgvw
        DRhh3Qfa87f4YrzvsZrvM+xPPZXuZngBwrOf45A4rMtJLfTBdKB2GWvbUj/q6YztWcxCTKk+bFB
        1wa7OxhwgLBIp
X-Received: by 2002:a7b:caaa:: with SMTP id r10mr8580933wml.100.1570133573282;
        Thu, 03 Oct 2019 13:12:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxigiOC/2WV/mXvcjmQaOXxgRGDV6OKPxDANRnt+Nj/+WYpfbOYZVrhbaSwqm9sAffAeu5UcA==
X-Received: by 2002:a7b:caaa:: with SMTP id r10mr8580919wml.100.1570133573021;
        Thu, 03 Oct 2019 13:12:53 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h14sm4502733wro.44.2019.10.03.13.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 13:12:52 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: omit absent pmu MSRs from MSR list
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eRFUeSB035VEC61CzAg6PY=aApjyiQoSnRydH788COL4w@mail.gmail.com>
 <f8e169a5-4cf6-8df7-86bb-f70a480c33ad@redhat.com>
 <CALMp9eSCB-wyLm-QYS-7gTcSeuWWCvgYL3iDEP0y6BM4cWMFag@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d879b3a1-c5e8-00ba-4b80-e5da4dcceea7@redhat.com>
Date:   Thu, 3 Oct 2019 22:12:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSCB-wyLm-QYS-7gTcSeuWWCvgYL3iDEP0y6BM4cWMFag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 20:23, Jim Mattson wrote:
> On Thu, Oct 3, 2019 at 10:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 03/10/19 19:20, Jim Mattson wrote:
>>> You've truncated the list I originally provided, so I think this need
>>> only go to MSR_ARCH_PERFMON_PERFCTR0 + 17. Otherwise, we could lose
>>> some valuable MSRs.
>>
>> This is v2, so it was meant to replace the patch that truncates the
>> list.  But I can include the other one too, perhaps even ask the x86
>> maintainers about decreasing INTEL_PMC_MAX_GENERIC to 18.
> 
> The list should definitely be truncated, since
> MSR_ARCH_PERFMON_EVENTSEL0 + 18 is IA32_PERF_STATUS.

Ok, thanks.

Paolo

