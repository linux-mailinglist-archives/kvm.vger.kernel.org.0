Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676451610B5
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 12:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgBQLLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 06:11:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727513AbgBQLLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 06:11:51 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HBAYQt031797
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:11:49 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6ddc0rm7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:11:48 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 17 Feb 2020 11:11:46 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 11:11:43 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HBBg5s67043474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 11:11:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BB952054;
        Mon, 17 Feb 2020 11:11:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AF5795204E;
        Mon, 17 Feb 2020 11:11:41 +0000 (GMT)
Subject: Re: [PATCH v2 03/42] s390/protvirt: introduce host side setup
To:     David Hildenbrand <david@redhat.com>,
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
 <8b6f790f-8d41-f9a8-1c9c-df900d22fa47@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 17 Feb 2020 12:11:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8b6f790f-8d41-f9a8-1c9c-df900d22fa47@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20021711-0028-0000-0000-000003DBBBB5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021711-0029-0000-0000-000024A0C14A
Message-Id: <66cf54a2-8fec-e992-18a9-d72b22d46b97@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_05:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.02.20 10:53, David Hildenbrand wrote:
> On 14.02.20 23:26, Christian Borntraeger wrote:
>> From: Vasily Gorbik <gor@linux.ibm.com>
>>
>> Add "prot_virt" command line option which controls if the kernel
>> protected VMs support is enabled at early boot time. This has to be
>> done early, because it needs large amounts of memory and will disable
>> some features like STP time sync for the lpar.
>>
>> Extend ultravisor info definitions and expose it via uv_info struct
>> filled in during startup.
>>
>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  .../admin-guide/kernel-parameters.txt         |  5 ++
>>  arch/s390/boot/Makefile                       |  2 +-
>>  arch/s390/boot/uv.c                           | 21 +++++++-
>>  arch/s390/include/asm/uv.h                    | 45 +++++++++++++++-
>>  arch/s390/kernel/Makefile                     |  1 +
>>  arch/s390/kernel/setup.c                      |  4 --
>>  arch/s390/kernel/uv.c                         | 52 +++++++++++++++++++
>>  7 files changed, 122 insertions(+), 8 deletions(-)
>>  create mode 100644 arch/s390/kernel/uv.c
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index dbc22d684627..b0beae9b9e36 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -3795,6 +3795,11 @@
>>  			before loading.
>>  			See Documentation/admin-guide/blockdev/ramdisk.rst.
>>  
>> +	prot_virt=	[S390] enable hosting protected virtual machines
>> +			isolated from the hypervisor (if hardware supports
>> +			that).
>> +			Format: <bool>
>> +
>>  	psi=		[KNL] Enable or disable pressure stall information
>>  			tracking.
>>  			Format: <bool>
>> diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
>> index e2c47d3a1c89..30f1811540c5 100644
>> --- a/arch/s390/boot/Makefile
>> +++ b/arch/s390/boot/Makefile
>> @@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
>>  obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
>>  obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
>>  obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
>> -obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
>> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
>>  obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
>>  obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
>>  targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>> index ed007f4a6444..af9e1cc93c68 100644
>> --- a/arch/s390/boot/uv.c
>> +++ b/arch/s390/boot/uv.c
>> @@ -3,7 +3,13 @@
>>  #include <asm/facility.h>
>>  #include <asm/sections.h>
>>  
>> +/* will be used in arch/s390/kernel/uv.c */
>> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>  int __bootdata_preserved(prot_virt_guest);
>> +#endif
>> +#if IS_ENABLED(CONFIG_KVM)
>> +struct uv_info __bootdata_preserved(uv_info);
>> +#endif
>>  
>>  void uv_query_info(void)
>>  {
>> @@ -18,7 +24,20 @@ void uv_query_info(void)
>>  	if (uv_call(0, (uint64_t)&uvcb))
>>  		return;
>>  
>> -	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
>> +	if (IS_ENABLED(CONFIG_KVM)) {
>> +		memcpy(uv_info.inst_calls_list, uvcb.inst_calls_list, sizeof(uv_info.inst_calls_list));
>> +		uv_info.uv_base_stor_len = uvcb.uv_base_stor_len;
>> +		uv_info.guest_base_stor_len = uvcb.conf_base_phys_stor_len;
>> +		uv_info.guest_virt_base_stor_len = uvcb.conf_base_virt_stor_len;
>> +		uv_info.guest_virt_var_stor_len = uvcb.conf_virt_var_stor_len;
>> +		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
>> +		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
>> +		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
>> +		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
>> +	}
>> +
>> +	if (IS_ENABLED(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) &&
>> +	    test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
>>  	    test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list))
>>  		prot_virt_guest = 1;
>>  }
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 4093a2856929..34b1114dcc38 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -44,7 +44,19 @@ struct uv_cb_qui {
>>  	struct uv_cb_header header;
>>  	u64 reserved08;
>>  	u64 inst_calls_list[4];
>> -	u64 reserved30[15];
>> +	u64 reserved30[2];
>> +	u64 uv_base_stor_len;
>> +	u64 reserved48;
>> +	u64 conf_base_phys_stor_len;
>> +	u64 conf_base_virt_stor_len;
>> +	u64 conf_virt_var_stor_len;
>> +	u64 cpu_stor_len;
>> +	u32 reserved70[3];
>> +	u32 max_num_sec_conf;
>> +	u64 max_guest_stor_addr;
>> +	u8  reserved88[158-136];
>> +	u16 max_guest_cpus;
>> +	u64 reserveda0;
>>  } __packed __aligned(8);
>>  
>>  struct uv_cb_share {
>> @@ -69,6 +81,19 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>  	return cc;
>>  }
>>  
>> +struct uv_info {
>> +	unsigned long inst_calls_list[4];
>> +	unsigned long uv_base_stor_len;
>> +	unsigned long guest_base_stor_len;
>> +	unsigned long guest_virt_base_stor_len;
>> +	unsigned long guest_virt_var_stor_len;
>> +	unsigned long guest_cpu_stor_len;
>> +	unsigned long max_sec_stor_addr;
>> +	unsigned int max_num_sec_conf;
>> +	unsigned short max_guest_cpus;
>> +};
>> +extern struct uv_info uv_info;
>> +
>>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>  extern int prot_virt_guest;
>>  
>> @@ -121,11 +146,27 @@ static inline int uv_remove_shared(unsigned long addr)
>>  	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>>  }
>>  
>> -void uv_query_info(void);
>>  #else
>>  #define is_prot_virt_guest() 0
>>  static inline int uv_set_shared(unsigned long addr) { return 0; }
>>  static inline int uv_remove_shared(unsigned long addr) { return 0; }
>> +#endif
>> +
>> +#if IS_ENABLED(CONFIG_KVM)
>> +extern int prot_virt_host;
>> +
>> +static inline int is_prot_virt_host(void)
>> +{
>> +	return prot_virt_host;
>> +}
>> +#else
>> +#define is_prot_virt_host() 0
>> +#endif
>> +
>> +#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
>> +	IS_ENABLED(CONFIG_KVM)
>> +void uv_query_info(void);
>> +#else
>>  static inline void uv_query_info(void) {}
>>  #endif
>>  
>> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
>> index 2b1203cf7be6..22bfb8d5084e 100644
>> --- a/arch/s390/kernel/Makefile
>> +++ b/arch/s390/kernel/Makefile
>> @@ -78,6 +78,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_events.o perf_regs.o
>>  obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_diag.o
>>  
>>  obj-$(CONFIG_TRACEPOINTS)	+= trace.o
>> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
>>  
>>  # vdso
>>  obj-y				+= vdso64/
>> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
>> index b2c2f75860e8..a2496382175e 100644
>> --- a/arch/s390/kernel/setup.c
>> +++ b/arch/s390/kernel/setup.c
>> @@ -92,10 +92,6 @@ char elf_platform[ELF_PLATFORM_SIZE];
>>  
>>  unsigned long int_hwcap = 0;
>>  
>> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>> -int __bootdata_preserved(prot_virt_guest);
>> -#endif
>> -
>>  int __bootdata(noexec_disabled);
>>  int __bootdata(memory_end_set);
>>  unsigned long __bootdata(memory_end);
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> new file mode 100644
>> index 000000000000..b1f936710360
>> --- /dev/null
>> +++ b/arch/s390/kernel/uv.c
>> @@ -0,0 +1,52 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Common Ultravisor functions and initialization
>> + *
>> + * Copyright IBM Corp. 2019, 2020
>> + */
>> +#define KMSG_COMPONENT "prot_virt"
>> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/sizes.h>
>> +#include <linux/bitmap.h>
>> +#include <linux/memblock.h>
>> +#include <asm/facility.h>
>> +#include <asm/sections.h>
>> +#include <asm/uv.h>
>> +
>> +/* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
>> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>> +int __bootdata_preserved(prot_virt_guest);
>> +#endif
>> +
>> +#if IS_ENABLED(CONFIG_KVM)
> 
> 
> Why is that glued to CONFIG_KVM? Can't we glue all that stuff to
> CONFIG_PROTECTED_VIRTUALIZATION_GUEST and make in kconfig
> CONFIG_PROTECTED_VIRTUALIZATION_GUEST depend on CONFIG_KVM?


CONFIG_PROTECTED_VIRTUALIZATION_GUEST is for the GUEST part (the virtio-ccw changes
inside the guest). The other thing is for the host and here we bind it
to CONFIG_KVM (or PGSTE for mm code).

> 
> IOW, I'd prefer to only have CONFIG_PROTECTED_VIRTUALIZATION_GUEST in
> !KVM code and enforce it via kconfig instead.
> 
> 
> Anyhow, I remember Conny also having a comment about that previously, so
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 
> 

