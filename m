Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA2239A26D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhFCNpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhFCNpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 09:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622727803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/YoXGStod1h/jERDJXuFzwuJE4tYR48fwiMDlbU5AI=;
        b=d9mFFjZv3Clbr7nv+4Pq7XzJLSYV6CFMwMoa40dqftGFDMbrwqNjHyzEszwwwMGpnje5aH
        GGnqrCNlIOWINurc7Fz9k678/3ku885swAkS6aQlrTri3k0GMsEDb1m/Vh1fsbAS4J/jtB
        bdAYCjU0swnkrFLbyJqjuseqKOsUwpc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-8CcrHv-vOSey5IcGa5Px_A-1; Thu, 03 Jun 2021 09:43:21 -0400
X-MC-Unique: 8CcrHv-vOSey5IcGa5Px_A-1
Received: by mail-ed1-f69.google.com with SMTP id x8-20020aa7d3880000b029038fe468f5f4so3266369edq.10
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 06:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g/YoXGStod1h/jERDJXuFzwuJE4tYR48fwiMDlbU5AI=;
        b=O2X3/WWVOCjy20kQNf77NG1pZv2Y+dLknGPnotwYEGTWN/Kd0R/yqCjX49BR17LbXd
         0vKqoSXvuOZhx4gNHs2JYuxUngQ4cadUBD1/Ey9GKCPc8SAsZQAGbcQ3nSuOUZPw+YBk
         RWcO6FxWuhfShU8MRxuzgzIYta2UiZC8Hu2UH1Be9AExM7nkh363rzwR6QBswjTG+/iN
         NrANb4yTM8eA0PZSuT4A+TrGyVBeKvhvFN+hg5nQZ0tLavt8lYdvcBlqhl8j7EsmxSj2
         n6E8SybXDUU4wGYP3RgkAbf3kSKMKNU6z4uo36S6v57mRw7OG4LuEVY3vL9dczR7mCFs
         jKbQ==
X-Gm-Message-State: AOAM5316CvM5OPJdtZJbFtBfrJ9hku+lvLPG/wWRnWEMoTN0EYivnpEV
        vW5+VJAqkvzOq7zDOUXJe514sj0tM17N9VPRNDdvml6yndinpYQKoGSkha4miw7ouN3+s5E4Yst
        lCqQFP3dC3Ykd
X-Received: by 2002:a17:906:c010:: with SMTP id e16mr39287396ejz.214.1622727800184;
        Thu, 03 Jun 2021 06:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkBAlTramcWK5Md2ZPw/anf2r6EF7CpGQ6+Wmz/53biaTbGsw8MFyAlqZyTTAGWiKmHbfy7Q==
X-Received: by 2002:a17:906:c010:: with SMTP id e16mr39287382ejz.214.1622727799958;
        Thu, 03 Jun 2021 06:43:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cw10sm1099269ejb.62.2021.06.03.06.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:43:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
In-Reply-To: <12db5b88-a094-4fb0-eeac-e79396009f44@intel.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <871r9k36ds.fsf@vitty.brq.redhat.com>
 <12db5b88-a094-4fb0-eeac-e79396009f44@intel.com>
Date:   Thu, 03 Jun 2021 15:43:17 +0200
Message-ID: <87im2v12tm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tao Xu <tao3.xu@intel.com> writes:

> On 6/2/21 6:31 PM, Vitaly Kuznetsov wrote:
>> Tao Xu <tao3.xu@intel.com> writes:
>> 
>>> There are some cases that malicious virtual machines can cause CPU stuck
>>> (event windows don't open up), e.g., infinite loop in microcode when
>>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>>> hardware CPU can't be used by host or other VM.
>>>
>>> To resolve those cases, it can enable a notify VM exit if no event
>>> window occur in VMX non-root mode for a specified amount of time
>>> (notify window). Since CPU is first observed the risk of not causing
>>> forward progress, after notify window time in a units of crystal clock,
>>> Notify VM exit will happen. Notify VM exit can happen incident to delivery
>>> of a vectored event.
>>>
>>> Expose a module param for configuring notify window, which is in unit of
>>> crystal clock cycle.
>>> - A negative value (e.g. -1) is to disable this feature.
>>> - Make the default as 0. It is safe because an internal threshold is added
>>> to notify window to ensure all the normal instructions being coverd.
>>> - User can set it to a large value when they want to give more cycles to
>>> wait for some reasons, e.g., silicon wrongly kill some normal instruction
>>> due to internal threshold is too small.
>>>
>>> Notify VM exit is defined in latest Intel Architecture Instruction Set
>>> Extensions Programming Reference, chapter 9.2.
>>>
>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>>> ---
>>>
>>> Changelog:
>>> v2:
>>>       Default set notify window to 0, less than 0 to disable.
>>>       Add more description in commit message.
>> 
>> Sorry if this was already discussed, but in case of nested
>> virtualization and when L1 also enables
>> SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
>> during L2 execution to L1 instead of crashing the whole L1?
>> 
> Notify VM Exit will not crash L1 guest if VM context valid in exit 
> qualification. After VM exit, VMM can resume the guest normally.

Wrong choice of words, sorry. Indeed, VMM is free to decide what to do
upon such vmexit.

-- 
Vitaly

