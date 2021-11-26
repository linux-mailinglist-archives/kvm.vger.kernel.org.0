Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D945EDB6
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348776AbhKZMRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:17:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239137AbhKZMPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637928714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEaiHOjKPvvIeFADV9AA6fu7Ajtt1ugf/mQmvT607mI=;
        b=LpfEc5hZUPabCmBWYqXAdbFXgFvT8GH42qIS6zx5MwXt5J5AdP5KzwKyKfrk2P31AZ5CM/
        Ma3pBHuSObzxSYDmqSHmOwpTtcSf3qx4PHigcDfKvaaPINTrccWqVQ94e661lAObb5q/qn
        LdK9ZlShWGJfx3tKr7BukPKXSAHY2QY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-RWWi0uN7PW6PmQv2eA2g0Q-1; Fri, 26 Nov 2021 07:11:51 -0500
X-MC-Unique: RWWi0uN7PW6PmQv2eA2g0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D4CF190A7A1;
        Fri, 26 Nov 2021 12:11:49 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 085A35C1D5;
        Fri, 26 Nov 2021 12:11:46 +0000 (UTC)
Message-ID: <79642370-5e60-5830-b171-ca58a6e859ad@redhat.com>
Date:   Fri, 26 Nov 2021 13:11:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/2] KVM: nVMX: Fix VPID + !EPT TLB bugs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
References: <20211125014944.536398-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125014944.536398-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:49, Sean Christopherson wrote:
> Fix two bugs reported by Lai where KVM mishandles guest-scoped TLB flushes
> when L2 is active.  Bugs confirmed (and confirmed fixed) by the VPID+access
> test (patches posted for kvm-unit-tests).
> 
> Sean Christopherson (2):
>    KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
>    KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12
> 
>   arch/x86/kvm/vmx/nested.c | 45 +++++++++++++++++----------------------
>   arch/x86/kvm/vmx/vmx.c    | 23 ++++++++++++--------
>   arch/x86/kvm/x86.c        | 28 ++++++++++++++++++++----
>   arch/x86/kvm/x86.h        |  7 +-----
>   4 files changed, 59 insertions(+), 44 deletions(-)
> 

Queued, thanks (but I split the first in two).

Paolo

