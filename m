Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2390EC00D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfKAIxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:53:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbfKAIxg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 04:53:36 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA18rQCQ049730
        for <kvm@vger.kernel.org>; Fri, 1 Nov 2019 04:53:34 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w0f8bvebs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 04:53:32 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 1 Nov 2019 08:53:17 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 1 Nov 2019 08:53:14 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA18rDQT28574168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Nov 2019 08:53:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19EA7A405C;
        Fri,  1 Nov 2019 08:53:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B19FAA4054;
        Fri,  1 Nov 2019 08:53:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.151.233])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Nov 2019 08:53:12 +0000 (GMT)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Fri, 1 Nov 2019 09:53:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110108-4275-0000-0000-00000379D3D6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110108-4276-0000-0000-0000388D1560
Message-Id: <41fb411d-68b5-96be-fc0e-c88570df9d19@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911010090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.10.19 13:40, Janosch Frank wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> protected virtual machines hosting support code.
> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at runtime.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 20 +++++++-
>  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
>  arch/s390/kvm/Kconfig                         |  9 ++++
>  8 files changed, 126 insertions(+), 9 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index c7ac2f3ac99f..aa22e36b3105 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3693,6 +3693,11 @@
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
> index e2c47d3a1c89..82247e71617a 100644
> --- a/arch/s390/boot/Makefile
> +++ b/arch/s390/boot/Makefile
> @@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
>  obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
>  obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
>  obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
> -obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST))	+= uv.o
>  obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
>  obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
>  targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index ed007f4a6444..88cf8825d169 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -3,7 +3,12 @@
>  #include <asm/facility.h>
>  #include <asm/sections.h>
> 
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  int __bootdata_preserved(prot_virt_guest);
> +#endif
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +struct uv_info __bootdata_preserved(uv_info);
> +#endif
> 
>  void uv_query_info(void)
>  {
> @@ -18,7 +23,20 @@ void uv_query_info(void)
>  	if (uv_call(0, (uint64_t)&uvcb))
>  		return;
> 
> -	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
> +	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)) {
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
> index ef3c00b049ab..6db1bc495e67 100644
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
> +	u32 reserved68[3];
> +	u32 max_num_sec_conf;
> +	u64 max_guest_stor_addr;
> +	u8  reserved80[150-128];
> +	u16 max_guest_cpus;
> +	u64 reserved98;
>  } __packed __aligned(8);
> 
>  struct uv_cb_share {
> @@ -69,9 +81,21 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
> 
> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
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
>  extern int prot_virt_guest;
> 
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  static inline int is_prot_virt_guest(void)
>  {
>  	return prot_virt_guest;
> @@ -121,11 +145,27 @@ static inline int uv_remove_shared(unsigned long addr)
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
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
> +	defined(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)
> +void uv_query_info(void);
> +#else
>  static inline void uv_query_info(void) {}
>  #endif
> 
> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
> index 7edbbcd8228a..fe4fe475f526 100644
> --- a/arch/s390/kernel/Makefile
> +++ b/arch/s390/kernel/Makefile
> @@ -78,6 +78,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_events.o perf_regs.o
>  obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_diag.o
> 
>  obj-$(CONFIG_TRACEPOINTS)	+= trace.o
> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST))	+= uv.o
> 
>  # vdso
>  obj-y				+= vdso64/
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index 3ff291bc63b7..f36370f8af38 100644
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
> index 000000000000..35ce89695509
> --- /dev/null
> +++ b/arch/s390/kernel/uv.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Common Ultravisor functions and initialization
> + *
> + * Copyright IBM Corp. 2019
> + */
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <linux/memblock.h>
> +#include <asm/facility.h>
> +#include <asm/sections.h>
> +#include <asm/uv.h>
> +
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +int __bootdata_preserved(prot_virt_guest);
> +#endif
> +
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +int prot_virt_host;
> +EXPORT_SYMBOL(prot_virt_host);
> +struct uv_info __bootdata_preserved(uv_info);
> +EXPORT_SYMBOL(uv_info);
> +
> +static int __init prot_virt_setup(char *val)
> +{
> +	bool enabled;
> +	int rc;
> +
> +	rc = kstrtobool(val, &enabled);
> +	if (!rc && enabled)
> +		prot_virt_host = 1;
> +
> +	if (is_prot_virt_guest() && prot_virt_host) {
> +		prot_virt_host = 0;
> +		pr_info("Running as protected virtualization guest.");
> +	}
> +
> +	if (prot_virt_host && !test_facility(158)) {
> +		prot_virt_host = 0;
> +		pr_info("The ultravisor call facility is not available.");
> +	}
> +
> +	return rc;
> +}
> +early_param("prot_virt", prot_virt_setup);
> +#endif
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index d3db3d7ed077..652b36f0efca 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -55,6 +55,15 @@ config KVM_S390_UCONTROL
> 
>  	  If unsure, say N.
> 
> +config KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +	bool "Protected guests execution support"
> +	depends on KVM
> +	---help---
> +	  Support hosting protected virtual machines isolated from the
> +	  hypervisor.
> +
> +	  If unsure, say Y.
> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
>  # the virtualization menu.
>  source "drivers/vhost/Kconfig"
> 

As we have the prot_virt kernel paramter there is a way to fence this during runtime
Not sure if we really need a build time fence. We could get rid of
CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST and just use CONFIG_KVM instead,
assuming that in the long run all distros will enable that anyway. 
If other reviewers prefer to keep that extra option what about the following to the
help section:

----
Support hosting protected virtual machines in KVM. The state of these machines like
memory content or register content is protected from the host or host administrators.

Enabling this option will enable extra code that talks to a new firmware instance
called ultravisor that will take care of protecting the guest while also enabling
KVM to run this guest.

This feature must be enable by the kernel command line option prot_virt.

	  If unsure, say Y.

----


Either way, the remaining part is

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

