Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FAA1FCAA7
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 12:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFQKUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 06:20:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41918 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFQKUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 06:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592389211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=GHBBSZ4cNrfcCCw/jGReGYC7ZWvNROANpJjX3mSdMh4=;
        b=SYMa8leE9Lar+xECVqW0b0J3k+Y28Gu9y94jdYT11w6THwimwyfZvzqdc8h0EMkpWhA5+A
        j6eZ6WWIc5Qhk7VgMsY/BpJjyUF3ZB0Ijjz/g2qilBTvvAwSLA3qmgA8RrL2A8uQIpWBf9
        sQzMHH2WW9By6iuxx7UPJ2p/fEHYaOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-2zJns58vOFOB11tkY0kEYQ-1; Wed, 17 Jun 2020 06:20:10 -0400
X-MC-Unique: 2zJns58vOFOB11tkY0kEYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC4F11006B0F;
        Wed, 17 Jun 2020 10:20:08 +0000 (UTC)
Received: from [10.36.112.122] (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DFCF9CFCF;
        Wed, 17 Jun 2020 10:19:57 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: reduce number of IO pins to 1
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200617083620.5409-1-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMFCQlmAYAGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl3pImkCGQEACgkQTd4Q
 9wD/g1o+VA//SFvIHUAvul05u6wKv/pIR6aICPdpF9EIgEU448g+7FfDgQwcEny1pbEzAmiw
 zAXIQ9H0NZh96lcq+yDLtONnXk/bEYWHHUA014A1wqcYNRY8RvY1+eVHb0uu0KYQoXkzvu+s
 Dncuguk470XPnscL27hs8PgOP6QjG4jt75K2LfZ0eAqTOUCZTJxA8A7E9+XTYuU0hs7QVrWJ
 jQdFxQbRMrYz7uP8KmTK9/Cnvqehgl4EzyRaZppshruKMeyheBgvgJd5On1wWq4ZUV5PFM4x
 II3QbD3EJfWbaJMR55jI9dMFa+vK7MFz3rhWOkEx/QR959lfdRSTXdxs8V3zDvChcmRVGN8U
 Vo93d1YNtWnA9w6oCW1dnDZ4kgQZZSBIjp6iHcA08apzh7DPi08jL7M9UQByeYGr8KuR4i6e
 RZI6xhlZerUScVzn35ONwOC91VdYiQgjemiVLq1WDDZ3B7DIzUZ4RQTOaIWdtXBWb8zWakt/
 ztGhsx0e39Gvt3391O1PgcA7ilhvqrBPemJrlb9xSPPRbaNAW39P8ws/UJnzSJqnHMVxbRZC
 Am4add/SM+OCP0w3xYss1jy9T+XdZa0lhUvJfLy7tNcjVG/sxkBXOaSC24MFPuwnoC9WvCVQ
 ZBxouph3kqc4Dt5X1EeXVLeba+466P1fe1rC8MbcwDkoUo65Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAiUEGAECAA8FAlXLn5ECGwwFCQlmAYAACgkQTd4Q
 9wD/g1qA6w/+M+ggFv+JdVsz5+ZIc6MSyGUozASX+bmIuPeIecc9UsFRatc91LuJCKMkD9Uv
 GOcWSeFpLrSGRQ1Z7EMzFVU//qVs6uzhsNk0RYMyS0B6oloW3FpyQ+zOVylFWQCzoyyf227y
 GW8HnXunJSC+4PtlL2AY4yZjAVAPLK2l6mhgClVXTQ/S7cBoTQKP+jvVJOoYkpnFxWE9pn4t
 H5QIFk7Ip8TKr5k3fXVWk4lnUi9MTF/5L/mWqdyIO1s7cjharQCstfWCzWrVeVctpVoDfJWp
 4LwTuQ5yEM2KcPeElLg5fR7WB2zH97oI6/Ko2DlovmfQqXh9xWozQt0iGy5tWzh6I0JrlcxJ
 ileZWLccC4XKD1037Hy2FLAjzfoWgwBLA6ULu0exOOdIa58H4PsXtkFPrUF980EEibUp0zFz
 GotRVekFAceUaRvAj7dh76cToeZkfsjAvBVb4COXuhgX6N4pofgNkW2AtgYu1nUsPAo+NftU
 CxrhjHtLn4QEBpkbErnXQyMjHpIatlYGutVMS91XTQXYydCh5crMPs7hYVsvnmGHIaB9ZMfB
 njnuI31KBiLUks+paRkHQlFcgS2N3gkRBzH7xSZ+t7Re3jvXdXEzKBbQ+dC3lpJB0wPnyMcX
 FOTT3aZT7IgePkt5iC/BKBk3hqKteTnJFeVIT7EC+a6YUFg=
Organization: Red Hat GmbH
Message-ID: <d17de7d7-6cca-672a-5519-c67fc147f6a5@redhat.com>
Date:   Wed, 17 Jun 2020 12:19:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617083620.5409-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.06.20 10:36, Christian Borntraeger wrote:
> The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
> allocation (32kb) for each guest start/restart. This can result in OOM
> killer activity even with free swap when the memory is fragmented
> enough:
> 
> kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
> kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
> kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
> kernel: Call Trace:
> kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
> kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
> kernel:  [<00000001f8687032>] dump_header+0x62/0x258
> kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
> kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
> kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
> kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
> kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
> kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
> kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
> kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
> kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
> kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
> kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
> kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
> kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8
> 
> As far as I can tell s390x does not use the iopins as we bail our for
> anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
> only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
> reduce the memory footprint.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index cee3cb6455a2..6ea0820e7c7f 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -31,12 +31,12 @@
>  #define KVM_USER_MEM_SLOTS 32
>  
>  /*
> - * These seem to be used for allocating ->chip in the routing table,
> - * which we don't use. 4096 is an out-of-thin-air value. If we need
> - * to look at ->chip later on, we'll need to revisit this.
> + * These seem to be used for allocating ->chip in the routing table, which we
> + * don't use. 1 is as small as we can get to reduce the needed memory. If we
> + * need to look at ->chip later on, we'll need to revisit this.
>   */
>  #define KVM_NR_IRQCHIPS 1
> -#define KVM_IRQCHIP_NUM_PINS 4096
> +#define KVM_IRQCHIP_NUM_PINS 1
>  #define KVM_HALT_POLL_NS_DEFAULT 50000
>  
>  /* s390-specific vcpu->requests bit members */
> 

Guess it doesn't make sense to wrap all the "->chip" handling in a
separate set of defines.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

