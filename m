Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395FA43E4D9
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhJ1PTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231370AbhJ1PT3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 11:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635434221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVtdqDXww3KgKAYnCusxuLMUzDOnQrWVlJbyjA+vsRU=;
        b=gPjdPwe+/dQQApVozTccKru8Z7yTs10NqTYTLMoUaiwU/wZp/C4jVZNE5EP7qqOKGtcaav
        ybmJ77PccO0LBblYbytt5fUNLZrfdl7QmS19gEmBsEznkLSS3uu6Y1fPZjAfdZBp23Pjdu
        5jeJzpb09HryIvwGV0tiqmzFviBYahw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-MW_4YzIxOem6d6CcDHBrfA-1; Thu, 28 Oct 2021 11:16:52 -0400
X-MC-Unique: MW_4YzIxOem6d6CcDHBrfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E298B19200C1;
        Thu, 28 Oct 2021 15:16:48 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF85560BF1;
        Thu, 28 Oct 2021 15:16:37 +0000 (UTC)
Message-ID: <ea79dbabd67c09b76ca3409d2d7d4934dc4de2c1.camel@redhat.com>
Subject: Re: [PATCH v2 30/43] KVM: Drop unused kvm_vcpu.pre_pcpu field
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Thu, 28 Oct 2021 18:16:36 +0300
In-Reply-To: <20211009021236.4122790-31-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-31-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Remove kvm_vcpu.pre_pcpu as it no longer has any users.  No functional
> change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h | 1 -
>  virt/kvm/kvm_main.c      | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1fa38dc00b87..87996b22e681 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -304,7 +304,6 @@ struct kvm_vcpu {
>  	u64 requests;
>  	unsigned long guest_debug;
>  
> -	int pre_pcpu;
>  	struct list_head blocked_vcpu_list;
>  
>  	struct mutex mutex;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c870cae7e776..2bbf5c9d410f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -426,7 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  #endif
>  	kvm_async_pf_vcpu_init(vcpu);
>  
> -	vcpu->pre_pcpu = -1;
>  	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
>  
>  	kvm_vcpu_set_in_spin_loop(vcpu, false);



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



