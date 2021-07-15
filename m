Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A87A3C9DFF
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 13:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhGOLyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 07:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhGOLyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 07:54:22 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D37C06175F;
        Thu, 15 Jul 2021 04:51:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u3so3115776plf.5;
        Thu, 15 Jul 2021 04:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yZjacCxpi7Hc/0XmbRGuc2b47sUM+dfTK3uYpjKk0uk=;
        b=OSE/NzbMZZ9y27MeU4K0Fj1hs0/yEw6nnX58IKsv/HM0BhTWISAHDLR1XINadtgwdS
         Ocp2llzBL+FwVppqFbEeRF5zcb7SsBgzpQThzmrtSIXVKt5ghWAiEd86Rv+LvCEL0EKs
         RfGVfXUI41PbIGF/nid9t/Tr4xhFQOJWjnqal/0h4OwXNYVPUAwMnaXtg+H2swWLFhrZ
         sqcmlIhYYhhQaE2J9ZH39ePNzJVUtjOiPrUj6VnP8AkzFHudR7eE8vjJBgr5wDtm83KX
         VPGXeZaf6vJn0bMaN4y341ekfROTYqsoSR7Yxwxz7hnYxtfW51cMqx2zlAr566kbyDg9
         HaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZjacCxpi7Hc/0XmbRGuc2b47sUM+dfTK3uYpjKk0uk=;
        b=iuFIFm05NHr73gLsmgEpItVs0biwJmikEF8Ff0Q6b5QaogE4xRWNnArm1KVHuE1p9B
         ICwq5Li/L7Ww3LwxmUW8G2pVLW9plhRDzu9kEW6Uu0qfUBz92jRUVhZv822OjFbHpNpm
         NONWet2vrvbnOSBeDjCLoj1Tgneu9d53BYur7+eKVxnPzomOJMgVJ7mwQgCGPtuPwtuu
         3AL5g5nFaBf8aCvoOmxkW8d82JteP22OErZuFy+Q8K4O/iMteLWC1iug8a30ZmTHqnFj
         UY1ctJmFMuwVlS5hdpy0SjFPy3Lkgj8jaisD/a+KANvI56PRjdHAFflNpkPOUFXPZElZ
         afCw==
X-Gm-Message-State: AOAM531ORtwxVBzTbZtlitWyEQUnPSNIXujVgAMrjRpdXTcCbu8A46O6
        vf/iC0jcL7zt3DimgoFPtDCUzoTKBSQ8Ch2n
X-Google-Smtp-Source: ABdhPJx1I4jSSfv+s7lhS8zeKVzBTFjzQ9wVTxyrUOVVBQZJiI8HkanR4Z1raWELo3yeZNKQj6KQ8g==
X-Received: by 2002:a17:90a:6d82:: with SMTP id a2mr4004621pjk.150.1626349887810;
        Thu, 15 Jul 2021 04:51:27 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y1sm6958546pgr.70.2021.07.15.04.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 04:51:27 -0700 (PDT)
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210715104505.96220-1-likexu@tencent.com>
 <3d2ad944-9e0c-dea7-f0e4-4e55072ccf99@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86/cpuid: Expose the true number of available ASIDs
Message-ID: <fe96fd65-df65-1306-f8d0-29fd3f35a531@gmail.com>
Date:   Thu, 15 Jul 2021 19:51:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3d2ad944-9e0c-dea7-f0e4-4e55072ccf99@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/7/2021 7:19 pm, Paolo Bonzini wrote:
> On 15/07/21 12:45, Like Xu wrote:
>> The original fixed number "8" was first introduced 11 years ago. Time has
>> passed and now let KVM report the true number of address space 
>> identifiers
>> (ASIDs) that are supported by the processor returned in Fn8000_000A_EBX.
>>
>> It helps user-space to make better decisions about guest values.
>>
>> -        entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
>> -                   ASID emulation to nested SVM */
> 
> Why, since we don't have ASID emulation yet anyway?
> 
> Paolo

I suppose you're right on the current state.

But do we have an explanation as to why it is hard-coded as 8
and not zero or a real supported number?
