Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E243754A
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhJVKO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 06:14:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232620AbhJVKO5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 06:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634897559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9RugSDer7RJ0VTCrZoMBdAEz7BvSX18hwT5ubFXgK8=;
        b=JwM2eWNOfI7EfrJknMx0C2r6+g1HE/ZnBfcgxqPZPrwM0h/SxBDqGdDqmxiia7qhPL5NRB
        4nbNCyy67HGMFrkRY82h0d65Yco11owVZy6jTkBnatmeRh7d9WNPjZACxFf9opG8bJ/8xl
        Fc8RmQdqOjINveSu2dCCHEHss67BxGY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-A16doPCLM5WPcwvMSZO9QA-1; Fri, 22 Oct 2021 06:12:38 -0400
X-MC-Unique: A16doPCLM5WPcwvMSZO9QA-1
Received: by mail-ed1-f72.google.com with SMTP id v11-20020a056402348b00b003dcf725d986so3252929edc.1
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 03:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m9RugSDer7RJ0VTCrZoMBdAEz7BvSX18hwT5ubFXgK8=;
        b=B0A8x8NRH01wMKCacMamq/5suPIT75OwAyKWtc6Nq2PNC+q3xP7mUrwPHN1SoG2EDz
         p9o+/ZsxH6EUam41jqRqSa2UutUHdeKviTU+FPaXCXmPgOzfP5VMzGFzneWmHK8mZ4oh
         G+iSoqBlrQ4APnKD+tpjT1w4nQnF67bO1S5glB0jMd4AYq+yf9a4AOqKKZCh7c1VK2ps
         C94Oy5NH1DTFae3bzp44/5CT84FSbLW+Lhd2LFGhGNldwxDpcx31D4uEs2rJX0g8CdJ4
         XXgVaAU9h2MfwPdXPyLdl+zEVQjCKbWH0+twOepa6lunlUnjLLWEllzSzFVhrLPq0nDw
         EKfQ==
X-Gm-Message-State: AOAM5321YqL0ZLrpY7JHIsMQgS0s7Sp/9PMN5zid023iskzm7HRx2CIF
        eXFIKvgz4WEMZbkVl+c6Xaqnoz3xdoqTXUbJbAMAYF/AtxKlNhQhvtzT1SDFYukBB0fH+mNQRb5
        4l2S0QtidpqIw
X-Received: by 2002:a17:906:1c43:: with SMTP id l3mr2665060ejg.248.1634897557289;
        Fri, 22 Oct 2021 03:12:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAfZktJXuPCDHaZPcHu6CUYaNovhzRdAvTwiBezZpyP20PINdyYr8D38Mqu5aL272pdGnJaw==
X-Received: by 2002:a17:906:1c43:: with SMTP id l3mr2665042ejg.248.1634897557094;
        Fri, 22 Oct 2021 03:12:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h10sm4293228edk.41.2021.10.22.03.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 03:12:36 -0700 (PDT)
Message-ID: <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
Date:   Fri, 22 Oct 2021 12:12:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20211022004927.1448382-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211022004927.1448382-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 02:49, Sean Christopherson wrote:
> APICv cleanups and a dissertation on handling concurrent APIC access page
> faults and APICv inhibit updates.
> 
> I've tested this but haven't hammered the AVIC stuff, I'd appreciate it if
> someone with the Hyper-V setup can beat on the AVIC toggling.
> 
> Sean Christopherson (4):
>    KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
>      memslot
>    KVM: x86: Move SVM's APICv sanity check to common x86
>    KVM: x86: Move apicv_active flag from vCPU to in-kernel local APIC
>    KVM: x86: Use rw_semaphore for APICv lock to allow vCPU parallelism
> 
>   arch/x86/include/asm/kvm_host.h |  3 +-
>   arch/x86/kvm/hyperv.c           |  4 +--
>   arch/x86/kvm/lapic.c            | 46 ++++++++++---------------
>   arch/x86/kvm/lapic.h            |  5 +--
>   arch/x86/kvm/mmu/mmu.c          | 29 ++++++++++++++--
>   arch/x86/kvm/svm/avic.c         |  2 +-
>   arch/x86/kvm/svm/svm.c          |  2 --
>   arch/x86/kvm/vmx/vmx.c          |  4 +--
>   arch/x86/kvm/x86.c              | 59 ++++++++++++++++++++++-----------
>   9 files changed, 93 insertions(+), 61 deletions(-)
> 

Queued, thanks.  I only made small edits to the comment in patch
1, to make it very slightly shorter.

	 * 2a. APICv is globally disabled but locally enabled, and this
	 *     vCPU acquires mmu_lock before __kvm_request_apicv_update
	 *     calls kvm_zap_gfn_range().  This vCPU will install a stale
	 *     SPTE, but no one will consume it as (a) no vCPUs can be
	 *     running due to the kick from KVM_REQ_APICV_UPDATE, and
	 *     (b) because KVM_REQ_APICV_UPDATE is raised before the VM
	 *     state is update, vCPUs attempting to service the request
	 *     will block on apicv_update_lock.  The update flow will
	 *     then zap the SPTE and release the lock.

Paolo

