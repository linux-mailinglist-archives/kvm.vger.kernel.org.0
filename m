Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE6139F592
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 13:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhFHLvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 07:51:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232161AbhFHLvm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 07:51:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158BbNMt020743;
        Tue, 8 Jun 2021 07:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xbBNyN7+Fbemkm+rStPNigjyFwGmGO1f8qE20gfBnws=;
 b=OlyrHfXQl5WGus2mHBiyGDP7fzQDQVBHOwhXMFR1OHlac5WfEzlW8pYExHHgTcyrbJWS
 V2CsZGEamofAlG6yKx0wY3NTZx5syZclbiCEC9p5FKwivGxY7Amy2F4ySU02DakxsBBc
 DzRrfMejsIYOSqwHWaro2QIrxvBhX8A31L9QUnin8tph2Y3E1hTk+6SFw5+kfEtSFgYW
 LIJcb0BWbopa1ZHXALol8KvOOC2T/L9yfNYENzwrEgUaojWPhFj8x4frOUyxjjOAYIIq
 gK4MTOXCQuUtASQtpBrFYtudzUkOcEU4eg5EwJxC1qGZkcLN6KHxaBCKm4sEHpRdnx1z /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3927kd8kgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:49:48 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158BbO1r020773;
        Tue, 8 Jun 2021 07:49:48 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3927kd8kfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:49:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158Bhh20031104;
        Tue, 8 Jun 2021 11:49:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhsg7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 11:49:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158BmvsI31457596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 11:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5309442045;
        Tue,  8 Jun 2021 11:49:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDE3042042;
        Tue,  8 Jun 2021 11:49:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.177.179])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 11:49:42 +0000 (GMT)
Subject: Re: [PATCH] KVM: selftests: introduce P47V64 for s390x
To:     Christian Borntraeger <borntraeger@de.ibm.com>, pbonzini@redhat.com
Cc:     bgardon@google.com, dmatlack@google.com, drjones@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, peterx@redhat.com,
        venkateshs@chromium.org
References: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
 <20210608114546.6419-1-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <0a3de13f-9a23-428e-fd76-851784da456a@linux.ibm.com>
Date:   Tue, 8 Jun 2021 13:49:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608114546.6419-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JrUpD4UaMT_z6Eewllf40cvUdHpgNCfJ
X-Proofpoint-GUID: Vwi_2Rr9Ig_1C1qYr-PmbDoYWpVluLfR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_09:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/21 1:45 PM, Christian Borntraeger wrote:
> s390x can have up to 47bits of physical guest and 64bits of virtual
> address  bits. Add a new address mode to avoid errors of testcases
> going beyond 47bits.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..6d3f71822976 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -43,6 +43,7 @@ enum vm_guest_mode {
>  	VM_MODE_P40V48_4K,
>  	VM_MODE_P40V48_64K,
>  	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> +	VM_MODE_P47V64_4K,	/* For 48bits VA but ANY bits PA */

/* 64 bits VA but 47 bits PA */

Or, looking at the other entries above, just remove it.

>  	NUM_VM_MODES,
>  };
>  
> @@ -60,7 +61,7 @@ enum vm_guest_mode {
>  
>  #elif defined(__s390x__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
> +#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 16)
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 28e528c19d28..d61ad15b1979 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -175,6 +175,7 @@ const char *vm_guest_mode_string(uint32_t i)
>  		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
>  		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
>  		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
> +		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
>  	};
>  	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
>  		       "Missing new mode strings?");
> @@ -192,6 +193,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  	{ 40, 48,  0x1000, 12 },
>  	{ 40, 48, 0x10000, 16 },
>  	{  0,  0,  0x1000, 12 },
> +	{ 47, 64,  0x1000, 12 },
>  };
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
> @@ -277,6 +279,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
>  #endif
>  		break;
> +	case VM_MODE_P47V64_4K:
> +		vm->pgtable_levels = 4;
> +		break;
>  	default:
>  		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
>  	}
> 

