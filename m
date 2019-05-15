Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18A1EF70
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbfEOLeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 07:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbfEOLeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 07:34:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4730381E1A;
        Wed, 15 May 2019 11:34:12 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DF6E60CC0;
        Wed, 15 May 2019 11:34:08 +0000 (UTC)
Date:   Wed, 15 May 2019 13:34:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Collin Walling <walling@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: change default halt poll to 50000
Message-ID: <20190515133406.7b3ea902.cohuck@redhat.com>
In-Reply-To: <20190515082324.112755-1-borntraeger@de.ibm.com>
References: <20190515082324.112755-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 15 May 2019 11:34:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 10:23:24 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> older performance measurements indicated that 50000 vs 80000 reduces cpu
> consumption while still providing the benefit of halt polling. We had
> this change in the IBM KVM product, but it got lost so it never went
> upstream. Recent re-measurement indicate that 50k is still better than
> 80k.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index dbe254847e0d..cb63cc7bbf06 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -36,7 +36,7 @@
>   */
>  #define KVM_NR_IRQCHIPS 1
>  #define KVM_IRQCHIP_NUM_PINS 4096
> -#define KVM_HALT_POLL_NS_DEFAULT 80000
> +#define KVM_HALT_POLL_NS_DEFAULT 50000
>  
>  /* s390-specific vcpu->requests bit members */
>  #define KVM_REQ_ENABLE_IBS	KVM_ARCH_REQ(0)

I trust your tests :)

Acked-by: Cornelia Huck <cohuck@redhat.com>
