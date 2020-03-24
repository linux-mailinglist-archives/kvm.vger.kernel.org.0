Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B31190C8F
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCXLdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:33:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28423 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727217AbgCXLdZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585049604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmEKUVPUUIW58t8wUbOpcRcdCmPdmzEFAmhnF2iSsrM=;
        b=gvky4+9yYRWYvcQkRwyV7AV5FMFKbMU11nWL1xJuBuIvs0jBWbczGDcdeMtZEDrorsnHTp
        cVK3KzI6jZG+N4uxTcaAXY3oyE+0+flDuxDSwsaqegesSxXlbAPoLThIw7xuIA3WTzHIr7
        HrCgoB7JWsvN86BtyEr0trqVK5MUqZM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-JLPA71ElPvC4nMVOm9SygQ-1; Tue, 24 Mar 2020 07:33:20 -0400
X-MC-Unique: JLPA71ElPvC4nMVOm9SygQ-1
Received: by mail-wr1-f72.google.com with SMTP id m15so4670577wrb.0
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OmEKUVPUUIW58t8wUbOpcRcdCmPdmzEFAmhnF2iSsrM=;
        b=VxZWduOgwr4dNPjUXS8+8ZIo90I4IQLYC0RVW0bBf9AIOLQk30oY0KNC8uXTV3S9rw
         DyabKNCPUHPMvvGwcBYHFbJF3pHKIeSD21OhyLUXWaECYpo0EfET3kh0rg3DyZRkcWd3
         AExB5tBxadUqi+RHDIs1zmcz+dLDFDddPZ6y7YES/23qGoEkNCeL2F09yqz2PF9UR0QN
         V3EDP6FYWHdR8HE8KL9IctP8/21IfjWruiKyB4DTsLuxl7jmTiMXl+Qn03csgeOvcqjG
         dAP3zrncUpoYm7ewOMdaWtGWwOwffbAqYiGpmYMap1GfVh0F8ogRjr/NtWOnawAZpcpA
         cDtQ==
X-Gm-Message-State: ANhLgQ3wXahYFlYPyIAC837bHVGnOqoMU/3fJ2bFBbeyn3e7u2UuFWTY
        luDGWfLtnZoeqqWG5VlnZ+Mbhs6v4OKFV6i6BpM6VxxDB9f6y5UzalWMENYTWDnbiCZXEeVulDT
        tcu9bBq+V4kXs
X-Received: by 2002:adf:a3db:: with SMTP id m27mr37127617wrb.350.1585049599165;
        Tue, 24 Mar 2020 04:33:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvgZHkdhEh+B+n9ipNvW4FVlwMdOadw+K1ajul8byxpJD6tN65QChX591BtD1p6mNq2BLWstQ==
X-Received: by 2002:adf:a3db:: with SMTP id m27mr37127590wrb.350.1585049598914;
        Tue, 24 Mar 2020 04:33:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id s22sm3727898wmc.16.2020.03.24.04.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:33:18 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200324094154.32352-1-joro@8bytes.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33af4430-e19d-c414-3e78-bcbc69d5bfb7@redhat.com>
Date:   Tue, 24 Mar 2020 12:33:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324094154.32352-1-joro@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 10:41, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set agains kvm/queue which moves svm.c into its own
> subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
> separate source files:
> 
> 	- The parts related to nested SVM to nested.c
> 
> 	- AVIC implementation to avic.c
> 
> 	- The SEV parts to sev.c
> 
> I have tested the changes in a guest with and without SEV.
> 
> Please review.
> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (4):
>   kVM SVM: Move SVM related files to own sub-directory
>   KVM: SVM: Move Nested SVM Implementation to nested.c
>   KVM: SVM: Move AVIC code to separate file
>   KVM: SVM: Move SEV code to separate file
> 
>  arch/x86/kvm/Makefile                 |    2 +-
>  arch/x86/kvm/svm/avic.c               | 1025 ++++
>  arch/x86/kvm/svm/nested.c             |  823 ++++
>  arch/x86/kvm/{pmu_amd.c => svm/pmu.c} |    0
>  arch/x86/kvm/svm/sev.c                | 1178 +++++
>  arch/x86/kvm/{ => svm}/svm.c          | 6546 ++++++-------------------
>  arch/x86/kvm/svm/svm.h                |  491 ++
>  7 files changed, 5106 insertions(+), 4959 deletions(-)
>  create mode 100644 arch/x86/kvm/svm/avic.c
>  create mode 100644 arch/x86/kvm/svm/nested.c
>  rename arch/x86/kvm/{pmu_amd.c => svm/pmu.c} (100%)
>  create mode 100644 arch/x86/kvm/svm/sev.c
>  rename arch/x86/kvm/{ => svm}/svm.c (56%)
>  create mode 100644 arch/x86/kvm/svm/svm.h
> 

Queued, thanks (only cursorily reviewed for now).

Paolo

