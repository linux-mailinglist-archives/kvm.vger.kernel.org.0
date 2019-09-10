Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED8AF05A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436963AbfIJRSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732096AbfIJRSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:18:42 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1714CC049E36
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 17:18:42 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id 32so4842666wrk.15
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuYfhbb8Z3aRapTv3k5IPcJghNBswcS6futL7Li8nHM=;
        b=KnPMuTUqu7nggwetCp3aMHuKEaLRYxOEnIKoCpDJt5e4neHAWPTeGnunodc4ZdGC6p
         lCMjX3a1Fw1ISAtt+anYrH+v2GEpIM5K7HR7r/h90v7wfeF+6WNLMs7/ZMWwOnrnrX5l
         HBTJ9mjP1OqoJgVmCb/Jv2heRve31EsbEl6kTsi0WD6hEr6wFos9UNso2lP5A8F+7g/A
         jIlSe/MfhYkVWI8kpi39LLYecPv97tpDtV8z1729mZ2g9RvemfHJHGWmYTWzlkINbWDT
         0QxPTBOsNEmW4KO8LnLDFH6nE9gohXIilLiqemFzWBXU+J8JpvdexzUCfukFGUELFZy2
         4b3Q==
X-Gm-Message-State: APjAAAU4gKU0pNtbmeSg9E4/N/ISkpNelt92G49ZtadY4ehsY2bCZ99D
        TUgZuhEElr7ZNoJuhJAzi0MmkNAyeK6njTTRasKfc6H3DSbv6QrtIeN0fZhdgyYq+VNF973A1Tu
        KxX/Ynhe+OVP4
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr19039444wrn.352.1568135920582;
        Tue, 10 Sep 2019 10:18:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYjKMgs5O889hJHkbRLK9ngJgaS8XcoAuY+Os0MVZLwwO9DHPaW3BKOh6dklif3M9ClGYfhQ==
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr19039422wrn.352.1568135920337;
        Tue, 10 Sep 2019 10:18:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338? ([2001:b07:6468:f312:1435:25df:c911:3338])
        by smtp.gmail.com with ESMTPSA id l1sm21649073wrb.1.2019.09.10.10.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:18:39 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: x86: Refactor MSR related helpers
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190905212255.26549-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <96c13fa0-2547-99e2-caad-bcf3fb73806a@redhat.com>
Date:   Tue, 10 Sep 2019 19:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905212255.26549-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/19 23:22, Sean Christopherson wrote:
> Refactor x86's MSR accessors to reduce the amount of boilerplate code
> required to get/set an MSR, and consolidate the RDMSR/WRMSR emulation
> for VMX and SVM since the code is functionally identical.
> 
> Sean Christopherson (2):
>   KVM: x86: Refactor up kvm_{g,s}et_msr() to simplify callers
>   KVM: x86: Add kvm_emulate_{rd,wr}msr() to consolidate VXM/SVM code
> 
>  arch/x86/include/asm/kvm_host.h |   6 +-
>  arch/x86/kvm/svm.c              |  34 +-------
>  arch/x86/kvm/vmx/nested.c       |  22 ++---
>  arch/x86/kvm/vmx/vmx.c          |  33 +-------
>  arch/x86/kvm/x86.c              | 138 ++++++++++++++++++++------------
>  5 files changed, 100 insertions(+), 133 deletions(-)
> 

Queued, thanks.

Paolo
