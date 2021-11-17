Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA462454208
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhKQHsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:48:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231376AbhKQHsw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 02:48:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637135154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u47BIY/foQd7s3yK7KD7TB1lWDGnZpEy+Uxt2gJY/3E=;
        b=Sm4zG9/A3ktOawUINP6CtxmXwmk/apkJhnQjL/w2KaCVZYyggpP/zu5ZOUsFx5G9HRhHsb
        jjUg81XajRKukslLt6OuV1qiOaBQOOet+NXbs5NqPhO69tmOmcGOQWIjBoiYv/iXYPS87U
        ZSPnqo38RB8wvKfzzH/9fbVKmhq/vas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-V0QTMYDkPeCkpP9gfa7VoA-1; Wed, 17 Nov 2021 02:45:51 -0500
X-MC-Unique: V0QTMYDkPeCkpP9gfa7VoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5F30804142;
        Wed, 17 Nov 2021 07:45:47 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83DA60C0F;
        Wed, 17 Nov 2021 07:45:39 +0000 (UTC)
Message-ID: <1f582297-946c-f08b-638f-5b1546ca4458@redhat.com>
Date:   Wed, 17 Nov 2021 08:45:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] x86/kvm: remove unused ack_notifier callbacks
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211117071617.19504-1-jgross@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211117071617.19504-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 08:16, Juergen Gross wrote:
> Commit f52447261bc8c2 ("KVM: irq ack notification") introduced an
> ack_notifier() callback in struct kvm_pic and in struct kvm_ioapic
> without using them anywhere. Remove those callbacks again.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   arch/x86/kvm/ioapic.h | 1 -
>   arch/x86/kvm/irq.h    | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 623a3c5afad7..5666c39d8df1 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -81,7 +81,6 @@ struct kvm_ioapic {
>   	unsigned long irq_states[IOAPIC_NUM_PINS];
>   	struct kvm_io_device dev;
>   	struct kvm *kvm;
> -	void (*ack_notifier)(void *opaque, int irq);
>   	spinlock_t lock;
>   	struct rtc_status rtc_status;
>   	struct delayed_work eoi_inject;
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index 650642b18d15..c2d7cfe82d00 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -56,7 +56,6 @@ struct kvm_pic {
>   	struct kvm_io_device dev_master;
>   	struct kvm_io_device dev_slave;
>   	struct kvm_io_device dev_elcr;
> -	void (*ack_notifier)(void *opaque, int irq);
>   	unsigned long irq_states[PIC_NUM_PINS];
>   };
>   
> 

Nice.  Queued, thanks.

Paolo

