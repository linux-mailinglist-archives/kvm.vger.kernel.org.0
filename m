Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79DDBF547
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfIZOtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 10:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60453 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfIZOtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 10:49:21 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51CA2796E0
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 14:49:21 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id j125so1293726wmj.6
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 07:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gtDGJyFs23zkKEb6PsMRq8GxQYTNGtYRZQ8ucJhZHVY=;
        b=RG6umOWUQyq9WzxtiyR7TPbSHJbc9p+FNEOBJlQeu6mVHr8ZZy9tTO4u4fDRkxBXVO
         V0jDdx3WnH4TlXnFJbHHYmE64sHOqSJLFho552a6K0Nikp990HZ8l9NCbXGAt8SRu0h2
         AYkWbr//JETMyYtpBqo0lCf3Oz6sH677Pu6KMb4NZEnYFE232OVbHCvsMQDk2bgmJaJD
         r1cnkItV0cWBFTua+/WumtpK3jsUN8wwkcDOvOxsS96kKH8398g2kdckPOb+5mVhStlc
         N8CFXNAvHBDvM5v9dq1+dCbreoAPNSUW4IkUoeytrtm4PHZ73YeXTv6pJkchzX7KEpKp
         mKGw==
X-Gm-Message-State: APjAAAUX7hBc5bv0o56fIk/GhRcaZu2Pmsm2iWZqYiXRS5nbb4sEYElH
        Pc6EPXwUOfUJSm7QmJFsoL3Yl8pLu7xQ3gfdOhw4v+upiAjXRyS/d5lJIOa8uuREG0kDpkrljwN
        O3vdAFao9ldPd
X-Received: by 2002:a1c:a853:: with SMTP id r80mr3280557wme.140.1569509359995;
        Thu, 26 Sep 2019 07:49:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwDWpMK5fz7+fdt7UEmpSz88qB8vPHo6Ul5kS47x4LJFwLo9kZxT08GfwrATX5NgS5M206whg==
X-Received: by 2002:a1c:a853:: with SMTP id r80mr3280541wme.140.1569509359675;
        Thu, 26 Sep 2019 07:49:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id w18sm3203706wmc.9.2019.09.26.07.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 07:49:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
To:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com, krish.sadhukhan@oracle.com,
        rkrcmar@redhat.com, dinechin@redhat.com
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
 <5B33C98B-E58D-460B-A9C3-CBE25077FA92@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8ef062e3-c180-87fc-557a-9a7c940c146f@redhat.com>
Date:   Thu, 26 Sep 2019 16:49:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5B33C98B-E58D-460B-A9C3-CBE25077FA92@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 16:35, Liran Alon wrote:
> 
> 
>> On 26 Sep 2019, at 17:32, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>
>> On Thu, Sep 26, 2019 at 11:24:57AM +0200, Paolo Bonzini wrote:
>>> On 25/09/19 03:18, Marc Orr wrote:
>>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>>> index 694ee3d42f3a..05122cf91ea1 100644
>>>> --- a/x86/unittests.cfg
>>>> +++ b/x86/unittests.cfg
>>>> @@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
>>>>
>>>> [vmx]
>>>> file = vmx.flat
>>>> -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
>>>> +extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
>>>> arch = x86_64
>>>> groups = vmx
>>>
>>> I just noticed this, why is the test disabled by default?
>>
>> The negative test triggers undefined behavior, e.g. on bare metal the
>> test would fail because VM-Enter would succeed due to lack of an explicit
>> check on the MSR count.
>>
>> Since the test relies on somehwat arbitrary KVM behavior, we made it opt-in.
> 
> Just note that when commit 5ac120c23753 ("x86: vmx: Test INIT processing during various CPU VMX states”)
> was merged to master, it was changed to accidentally remove “-atomic_switch_overflow_msrs_test”.
> (Probably a merge mistake).
> 
> So this should be fixed by a new patch :P

I will just rewrite history and fix the mistake.

Paolo

