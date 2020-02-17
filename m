Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A698160F56
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 10:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgBQJx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 04:53:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32986 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729118AbgBQJx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 04:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581933236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=r22v6XhgUST4pK6axEnOp3FcV66WE5HcjYAPWdq5z4w=;
        b=glNkU/oD72F27EWq9Il6XGAbV/LokgHqx6RCQO2v1OhRHoDyedle3ltNWaCEX5/BnlfY4y
        /Y/6PYRkj3bgU92lt5dG2qSxy9bM7eiJ074Ce3NzYMp+AAq1BBu7i5DhZY67umCRqmj9q7
        Rnt+5+HckFxGXqNFg01IRYYZGAZF/5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-SZgx_iN8OgKrZuG-IaktPA-1; Mon, 17 Feb 2020 04:53:51 -0500
X-MC-Unique: SZgx_iN8OgKrZuG-IaktPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5554DB60;
        Mon, 17 Feb 2020 09:53:49 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99C8C60BEC;
        Mon, 17 Feb 2020 09:53:43 +0000 (UTC)
Subject: Re: [PATCH v2 03/42] s390/protvirt: introduce host side setup
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-4-borntraeger@de.ibm.com>
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
Message-ID: <8b6f790f-8d41-f9a8-1c9c-df900d22fa47@redhat.com>
Date:   Mon, 17 Feb 2020 10:53:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-4-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.20 23:26, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 21 +++++++-
>  arch/s390/include/asm/uv.h                    | 45 +++++++++++++++-
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 52 +++++++++++++++++++
>  7 files changed, 122 insertions(+), 8 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index dbc22d684627..b0beae9b9e36 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3795,6 +3795,11 @@
>  			before loading.
>  			See Documentation/admin-guide/blockdev/ramdisk.rst.
>  
> +	prot_virt=	[S390] enable hosting protected virtual machines
> +			isolated from the hypervisor (if hardware supports
> +			that).
> +			Format: <bool>
> +
>  	psi=		[KNL] Enable or disable pressure stall information
>  			tracking.
>  			Format: <bool>
> diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
> index e2c47d3a1c89..30f1811540c5 100644
> --- a/arch/s390/boot/Makefile
> +++ b/arch/s390/boot/Makefile
> @@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
>  obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
>  obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
>  obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
> -obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
>  obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
>  obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
>  targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index ed007f4a6444..af9e1cc93c68 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -3,7 +3,13 @@
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  
> +/* will be used in arch/s390/kernel/uv.c */
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  int __bootdata_preserved(prot_virt_guest);
> +#endif
> +#if IS_ENABLED(CONFIG_KVM)
> +struct uv_info __bootdata_preserved(uv_info);
> +#endif
>  
>  void uv_query_info(void)
>  {
> @@ -18,7 +24,20 @@ void uv_query_info(void)
>  	if (uv_call(0, (uint64_t)&uvcb))
>  		return;
>  
> -	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
> +	if (IS_ENABLED(CONFIG_KVM)) {
> +		memcpy(uv_info.inst_calls_list, uvcb.inst_calls_list, sizeof(uv_info.inst_calls_list));
> +		uv_info.uv_base_stor_len = uvcb.uv_base_stor_len;
> +		uv_info.guest_base_stor_len = uvcb.conf_base_phys_stor_len;
> +		uv_info.guest_virt_base_stor_len = uvcb.conf_base_virt_stor_len;
> +		uv_info.guest_virt_var_stor_len = uvcb.conf_virt_var_stor_len;
> +		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
> +		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
> +		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
> +		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
> +	}
> +
> +	if (IS_ENABLED(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) &&
> +	    test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
>  	    test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list))
>  		prot_virt_guest = 1;
>  }
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 4093a2856929..34b1114dcc38 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -44,7 +44,19 @@ struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
>  	u64 inst_calls_list[4];
> -	u64 reserved30[15];
> +	u64 reserved30[2];
> +	u64 uv_base_stor_len;
> +	u64 reserved48;
> +	u64 conf_base_phys_stor_len;
> +	u64 conf_base_virt_stor_len;
> +	u64 conf_virt_var_stor_len;
> +	u64 cpu_stor_len;
> +	u32 reserved70[3];
> +	u32 max_num_sec_conf;
> +	u64 max_guest_stor_addr;
> +	u8  reserved88[158-136];
> +	u16 max_guest_cpus;
> +	u64 reserveda0;
>  } __packed __aligned(8);
>  
>  struct uv_cb_share {
> @@ -69,6 +81,19 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
>  
> +struct uv_info {
> +	unsigned long inst_calls_list[4];
> +	unsigned long uv_base_stor_len;
> +	unsigned long guest_base_stor_len;
> +	unsigned long guest_virt_base_stor_len;
> +	unsigned long guest_virt_var_stor_len;
> +	unsigned long guest_cpu_stor_len;
> +	unsigned long max_sec_stor_addr;
> +	unsigned int max_num_sec_conf;
> +	unsigned short max_guest_cpus;
> +};
> +extern struct uv_info uv_info;
> +
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  extern int prot_virt_guest;
>  
> @@ -121,11 +146,27 @@ static inline int uv_remove_shared(unsigned long addr)
>  	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>  }
>  
> -void uv_query_info(void);
>  #else
>  #define is_prot_virt_guest() 0
>  static inline int uv_set_shared(unsigned long addr) { return 0; }
>  static inline int uv_remove_shared(unsigned long addr) { return 0; }
> +#endif
> +
> +#if IS_ENABLED(CONFIG_KVM)
> +extern int prot_virt_host;
> +
> +static inline int is_prot_virt_host(void)
> +{
> +	return prot_virt_host;
> +}
> +#else
> +#define is_prot_virt_host() 0
> +#endif
> +
> +#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
> +	IS_ENABLED(CONFIG_KVM)
> +void uv_query_info(void);
> +#else
>  static inline void uv_query_info(void) {}
>  #endif
>  
> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
> index 2b1203cf7be6..22bfb8d5084e 100644
> --- a/arch/s390/kernel/Makefile
> +++ b/arch/s390/kernel/Makefile
> @@ -78,6 +78,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_events.o perf_regs.o
>  obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_diag.o
>  
>  obj-$(CONFIG_TRACEPOINTS)	+= trace.o
> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
>  
>  # vdso
>  obj-y				+= vdso64/
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index b2c2f75860e8..a2496382175e 100644
> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -92,10 +92,6 @@ char elf_platform[ELF_PLATFORM_SIZE];
>  
>  unsigned long int_hwcap = 0;
>  
> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> -int __bootdata_preserved(prot_virt_guest);
> -#endif
> -
>  int __bootdata(noexec_disabled);
>  int __bootdata(memory_end_set);
>  unsigned long __bootdata(memory_end);
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> new file mode 100644
> index 000000000000..b1f936710360
> --- /dev/null
> +++ b/arch/s390/kernel/uv.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Common Ultravisor functions and initialization
> + *
> + * Copyright IBM Corp. 2019, 2020
> + */
> +#define KMSG_COMPONENT "prot_virt"
> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <linux/memblock.h>
> +#include <asm/facility.h>
> +#include <asm/sections.h>
> +#include <asm/uv.h>
> +
> +/* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +int __bootdata_preserved(prot_virt_guest);
> +#endif
> +
> +#if IS_ENABLED(CONFIG_KVM)


Why is that glued to CONFIG_KVM? Can't we glue all that stuff to
CONFIG_PROTECTED_VIRTUALIZATION_GUEST and make in kconfig
CONFIG_PROTECTED_VIRTUALIZATION_GUEST depend on CONFIG_KVM?

IOW, I'd prefer to only have CONFIG_PROTECTED_VIRTUALIZATION_GUEST in
!KVM code and enforce it via kconfig instead.


Anyhow, I remember Conny also having a comment about that previously, so

Acked-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

