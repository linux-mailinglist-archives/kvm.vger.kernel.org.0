Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5050AEE69B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 18:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbfKDRuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 12:50:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727469AbfKDRuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 12:50:23 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA4HmZHX012492
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 12:50:22 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2pufd232-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 12:50:21 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 4 Nov 2019 17:50:18 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 17:50:15 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4HoDPL45154688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 17:50:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D7AEA4059;
        Mon,  4 Nov 2019 17:50:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E14AA4057;
        Mon,  4 Nov 2019 17:50:13 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.180.71])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Nov 2019 17:50:12 +0000 (GMT)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, imbrenda@linux.ibm.com, mihajlov@linux.ibm.com,
        mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <20191104165427.0e5e6da4.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Mon, 4 Nov 2019 18:50:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104165427.0e5e6da4.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110417-0016-0000-0000-000002C0A577
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110417-0017-0000-0000-00003322180C
Message-Id: <5a34febd-8abc-84f5-195e-43decbb366a5@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040173
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.11.19 16:54, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:24 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> From: Vasily Gorbik <gor@linux.ibm.com>
>>
>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
>> protected virtual machines hosting support code.
>>
>> Add "prot_virt" command line option which controls if the kernel
>> protected VMs support is enabled at runtime.
>>
>> Extend ultravisor info definitions and expose it via uv_info struct
>> filled in during startup.
>>
>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>> ---
>>  .../admin-guide/kernel-parameters.txt         |  5 ++
>>  arch/s390/boot/Makefile                       |  2 +-
>>  arch/s390/boot/uv.c                           | 20 +++++++-
>>  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>>  arch/s390/kernel/Makefile                     |  1 +
>>  arch/s390/kernel/setup.c                      |  4 --
>>  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
>>  arch/s390/kvm/Kconfig                         |  9 ++++
>>  8 files changed, 126 insertions(+), 9 deletions(-)
>>  create mode 100644 arch/s390/kernel/uv.c
> 
> (...)
> 
>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>> index ed007f4a6444..88cf8825d169 100644
>> --- a/arch/s390/boot/uv.c
>> +++ b/arch/s390/boot/uv.c
>> @@ -3,7 +3,12 @@
>>  #include <asm/facility.h>
>>  #include <asm/sections.h>
>>  
>> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>  int __bootdata_preserved(prot_virt_guest);
>> +#endif
>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>> +struct uv_info __bootdata_preserved(uv_info);
>> +#endif
> 
> Two functions with the same name, but different signatures look really
> ugly.
> 
> Also, what happens if I want to build just a single kernel image for
> both guest and host?

This is not two functions with the same name. It is 2 variable declarations with
the __bootdata_preserved helper. We expect to have all distro kernels to enable
both. 

> 
>>  
>>  void uv_query_info(void)
>>  {
>> @@ -18,7 +23,20 @@ void uv_query_info(void)
>>  	if (uv_call(0, (uint64_t)&uvcb))
>>  		return;
>>  
>> -	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
>> +	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)) {
> 
> Do we always have everything needed for a host if uv_call() is
> successful?

The uv_call is the query call. It will provide the list of features. We check that
later on.

> 
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
> 
> Especially as it looks like we need to test for those two commands to
> determine whether we have support for a guest.
> 
>>  		prot_virt_guest = 1;
>>  }
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index ef3c00b049ab..6db1bc495e67 100644
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
>> +	u32 reserved68[3];
>> +	u32 max_num_sec_conf;
>> +	u64 max_guest_stor_addr;
>> +	u8  reserved80[150-128];
>> +	u16 max_guest_cpus;
>> +	u64 reserved98;
>>  } __packed __aligned(8);
>>  
>>  struct uv_cb_share {
>> @@ -69,9 +81,21 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>  	return cc;
>>  }
>>  
>> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
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
> 
> What is the main difference between uv_info and uv_cb_qui? The
> alignment of max_sec_stor_addr?

One is the hardware data structure for query, the other one is the Linux
internal state.

> 
>> +extern struct uv_info uv_info;
>>  extern int prot_virt_guest;
>>  
>> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>  static inline int is_prot_virt_guest(void)
>>  {
>>  	return prot_virt_guest;
>> @@ -121,11 +145,27 @@ static inline int uv_remove_shared(unsigned long addr)
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
>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
>> +	defined(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)
>> +void uv_query_info(void);
>> +#else
>>  static inline void uv_query_info(void) {}
>>  #endif
> 
> (...)
> 
[...]

