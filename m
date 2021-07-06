Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C153BC75E
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhGFHnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 03:43:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230203AbhGFHnF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 03:43:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1667YKsu161474;
        Tue, 6 Jul 2021 03:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kCLZnu8UsW+L3BWrQIy8Htz4zz+s+k7Amh3LXoHY6oU=;
 b=l/uKoefgPKkvFgsMahx+saPhhAZZM/kwiGXuHONZBbSd/3yFAMmH5w/XYl4zCXi6Q8Y8
 l41YL+YZosnAYeL9xp+b/Q85s31++puIXsyn6s8fyTu4Vj7a/fvgEftaauMC6d6Ao1fZ
 BBUGVF57zCuWyymEF9Gj7npd21k+jNVlY+MQVbPeEucqRds2X71FoNgiE+hNhF9lbeXd
 oDiE6aa3A7WhSSJBiE953j2fUA+eDnr/3npQIKMhaB9cE3xlAKot584CiMjoyEKq36cU
 IQvmHhBA4sChj4HxtuiKs8O99dFJhrLMVDW4ulFm3LKrTojm00r1QNdymccmWrl9TMBD 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xsmhcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:40:27 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1667ZUEU164441;
        Tue, 6 Jul 2021 03:40:26 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xsmhca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:40:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667Xk29021613;
        Tue, 6 Jul 2021 07:40:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9470-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:40:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667eMFK32047490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 07:40:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FE844C063;
        Tue,  6 Jul 2021 07:40:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 179494C064;
        Tue,  6 Jul 2021 07:40:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.59.107])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 07:40:22 +0000 (GMT)
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <3a7be99a-5438-cc5b-ec6e-938832e7ab5a@de.ibm.com>
Date:   Tue, 6 Jul 2021 09:40:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701153853.33063-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bbelnnVMweOS_B18vhT3MgKROv8mC_A3
X-Proofpoint-GUID: J_J43FLB47EYSzLr6EH6KiVgK4JQ3Bm2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107060037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

since you have not yet pulled my queue for 5.14. Shall I add the two selftest patches and send a new
pull request?

On 01.07.21 17:38, Christian Borntraeger wrote:
> Older machines likes z196 and zEC12 do only support 44 bits of physical
> addresses. Make this the default and check via IBC if we are on a later
> machine. We then add P47V64 as an additional model.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
> ---
>   tools/testing/selftests/kvm/include/kvm_util.h |  3 ++-
>   tools/testing/selftests/kvm/lib/guest_modes.c  | 16 ++++++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
>   3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 35739567189e..74d73532fce9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -44,6 +44,7 @@ enum vm_guest_mode {
>   	VM_MODE_P40V48_64K,
>   	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
>   	VM_MODE_P47V64_4K,
> +	VM_MODE_P44V64_4K,
>   	NUM_VM_MODES,
>   };
>   
> @@ -61,7 +62,7 @@ enum vm_guest_mode {
>   
>   #elif defined(__s390x__)
>   
> -#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
> +#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
>   #define MIN_PAGE_SHIFT			12U
>   #define ptes_per_page(page_size)	((page_size) / 16)
>   
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index 25bff307c71f..c330f414ef96 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -22,6 +22,22 @@ void guest_modes_append_default(void)
>   		}
>   	}
>   #endif
> +#ifdef __s390x__
> +	{
> +		int kvm_fd, vm_fd;
> +		struct kvm_s390_vm_cpu_processor info;
> +
> +		kvm_fd = open_kvm_dev_path_or_exit();
> +		vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> +		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
> +				  KVM_S390_VM_CPU_PROCESSOR, &info, false);
> +		close(vm_fd);
> +		close(kvm_fd);
> +		/* Starting with z13 we have 47bits of physical address */
> +		if (info.ibc >= 0x30)
> +			guest_mode_append(VM_MODE_P47V64_4K, true, true);
> +	}
> +#endif
>   }
>   
>   void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index a2b732cf96ea..8606000c439e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -176,6 +176,7 @@ const char *vm_guest_mode_string(uint32_t i)
>   		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
>   		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
>   		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
> +		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
>   	};
>   	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
>   		       "Missing new mode strings?");
> @@ -194,6 +195,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>   	{ 40, 48, 0x10000, 16 },
>   	{  0,  0,  0x1000, 12 },
>   	{ 47, 64,  0x1000, 12 },
> +	{ 44, 64,  0x1000, 12 },
>   };
>   _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>   	       "Missing new mode params?");
> @@ -282,6 +284,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>   	case VM_MODE_P47V64_4K:
>   		vm->pgtable_levels = 5;
>   		break;
> +	case VM_MODE_P44V64_4K:
> +		vm->pgtable_levels = 5;
> +		break;
>   	default:
>   		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
>   	}
> 
