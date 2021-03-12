Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB608339663
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 19:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhCLS0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 13:26:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233151AbhCLS0U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 13:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615573579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u0a1s8cUycfijhNnJ29Qlw3GsB6GzjfunAFDFNCC4sE=;
        b=V+isDUxU4DQCLEIxmc+SRFu9dD06zTsd8Gy/Ad09thLCMKn1hz90UU81dIyi9JEY4IJ4W6
        QwEMO3fmeC1j2V7KYxKhjFyakOSz68ASDVhv3OZU6GFFPaQGxfjJesK8NjybkDwizkPlss
        L0N33deJLJZz3gY3dErlZDgQ80FTfoY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-xqDF8mWxPt6rDJD45dqyIg-1; Fri, 12 Mar 2021 13:26:17 -0500
X-MC-Unique: xqDF8mWxPt6rDJD45dqyIg-1
Received: by mail-wr1-f71.google.com with SMTP id e29so11525594wra.12
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 10:26:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u0a1s8cUycfijhNnJ29Qlw3GsB6GzjfunAFDFNCC4sE=;
        b=ZsYC5XrFyDTpPaN50gsjo+kLd66t5oo7KuluCbQBMXVXn9kNX+EY9TxYXleOX5Lshb
         J69aV5RO5YFmjTIlRF8Emi6gmzARtFJadydsEY8xKN03UPC48N/d4K4e9byzQ/CfPNsH
         /tJzsYeTuiat1x2H368HZqoczpuDOgBO/tAu/2XxnAx2g/uJSjs371MQLuwxhpQVY5WC
         1e/nGbKTP0DLTTIX0uuM5s8j8drw3pnJK1J1fwRjrNT3oXd6YiIo7m57Db44tV3ErqyN
         1mp2A1kbIgdj2/YXvU5JlC2o5pRLsXRlOMzlj3r43jv7OI7LORQDifS9tFqPDE3m4HR/
         Ze/w==
X-Gm-Message-State: AOAM533ZloP0Wwe/AERGSZ8yTo5WGWgnTSPsdVD7L5upjqwixE6xu7MZ
        uMqdB1EOSFOBPUaIAcXUrPz3Up1lnGcH+1cZ8Wy7VXu8gf/W6wM3uqAnwxYoiTilCXo07XYQzkN
        MkQ1l3Yp59DDu
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr15667594wru.218.1615573576405;
        Fri, 12 Mar 2021 10:26:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAmHuAKV2XlBV7w6c7IQBtAemH47YT187WJ7ylMIQufm8cRSiFUG/3y6R7lz3aof1qY+oNtQ==
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr15667579wru.218.1615573576197;
        Fri, 12 Mar 2021 10:26:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r2sm8484995wrt.8.2021.03.12.10.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:26:15 -0800 (PST)
Subject: Re: [PATCH v2 0/4] KVM: x86: Fixups and PAE+SME fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210309224207.1218275-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <86c8e391-b115-3898-7fc2-0ea9e0a0966f@redhat.com>
Date:   Fri, 12 Mar 2021 19:26:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210309224207.1218275-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/21 23:42, Sean Christopherson wrote:
> A few stragglers bundled together to hopefully avoid more messy conflicts.
> 
> v2 (relative to the fixup mini-series):
>    - Moved SME fixes from "PCID fixup" to its correct location, in "Mark
>      PAE roots decrypted".
>    - Collected Reviewed/Tested-by tags for MMU_PRESENT+MMIO snafu, though
>      I expect they'll get squashed away.
>    - Added the PAE patches from the SME shadow paging fixes to avoid
>      spreading out the dependencies.
> 
> Sean Christopherson (4):
>    KVM: x86: Fixup "Get active PCID only when writing a CR3 value"
>    KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO SPTE's generation
>    KVM: x86/mmu: Use '0' as the one and only value for an invalid PAE
>      root
>    KVM: x86/mmu: Mark the PAE roots as decrypted for shadow paging
> 
>   arch/x86/kvm/mmu/mmu.c          | 46 ++++++++++++++++++++++++---------
>   arch/x86/kvm/mmu/mmu_audit.c    |  2 +-
>   arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++
>   arch/x86/kvm/mmu/spte.h         | 12 +++++----
>   arch/x86/kvm/svm/svm.c          |  9 +++++--
>   5 files changed, 59 insertions(+), 20 deletions(-)
> 

Queued, thanks.

Paolo

