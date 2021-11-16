Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3316F453248
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhKPMiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:38:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236380AbhKPMiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:38:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637066123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nDD8Pw0nMM0sd/mdc/qJwcDjr7sQieU+0fU4PkeGCmc=;
        b=SobF7U3KseinYcDxx6txBrba7b3tkEFf8m/LnC+axplpqw4fdr67cv3jw2ZWkjFMcbTZXm
        HIbfLWSUlpaqKNzzHgotq3bjUVYWj75t99sKB9W05WMZwyfMb6l01gNAHRO763QOsR35zY
        xcP3C+Ncc2/g6VlNt08WizPjJM/4pgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-mpXQ5iUKOvmdeF9Oqlmleg-1; Tue, 16 Nov 2021 07:35:22 -0500
X-MC-Unique: mpXQ5iUKOvmdeF9Oqlmleg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D504101AFA8;
        Tue, 16 Nov 2021 12:35:21 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 652B55D9DE;
        Tue, 16 Nov 2021 12:35:17 +0000 (UTC)
Message-ID: <bd778500-b925-6b5c-7f57-8acd5530df73@redhat.com>
Date:   Tue, 16 Nov 2021 13:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/6] KVM: SEV: Bug fix, cleanups and enhancements
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20211109215101.2211373-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211109215101.2211373-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/21 22:50, Sean Christopherson wrote:
> Bug fix for COPY_ENC_CONTEXT_FROM that IIRC is very belated feedback (git
> says its been sitting in my local repo since at least early September).
> 
> The other patches are tangentially related cleanups and enhancements for
> the SEV and SEV-ES info, e.g. active flag, ASID, etc...
> 
> Booted an SEV guest, otherwise it's effectively all compile-tested only.
> 
> Sean Christopherson (6):
>    KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs
>    KVM: SEV: Explicitly document that there are no TOCTOU races in copy
>      ASID
>    KVM: SEV: Set sev_info.active after initial checks in sev_guest_init()
>    KVM: SEV: WARN if SEV-ES is marked active but SEV is not
>    KVM: SEV: Drop a redundant setting of sev->asid during initialization
>    KVM: SEV: Fix typo in and tweak name of cmd_allowed_from_miror()
> 
>   arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++++++++++++---------------
>   arch/x86/kvm/svm/svm.h |  2 +-
>   2 files changed, 28 insertions(+), 16 deletions(-)
> 

Queued all except 2.

Paolo

