Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF724541E8
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhKQHhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:37:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233035AbhKQHhC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 02:37:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH6hMBb017494;
        Wed, 17 Nov 2021 07:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I3EcY84twXfrMekuCamB7WgEyxKzbqONJCNvTdgnLQQ=;
 b=j9HZH264vdn31DLBVPmwBmpnRCnL/BhvqZVkj8bfeb046Eu5QXtV/gg/6M3suGPYBhMj
 3srjNk4G8ZKpDsowRtAlfInq5ceJ2jkEZmDsHxlXewHHmesTwGYZMEn45WiSBhPbRIcR
 b3TS8IH7ZiWNUto0RmTQksq5IxpTk77NBr8tS2o0hZdreu0OA999wCtQVSJrbb06NY//
 N8yZlODGYRolfaFHZCw0AbUzPGqLkm0PffftY72lA5h2vCTPzRDWs63do3OU5EvQl16O
 ITF0Z9OiUkJdezDP4cOODZ4dtfUscockEOFVQVUxrgi5bO7b1fsr2YcwydRTrhZk05zz Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccvqgs06h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:33:45 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AH7OPeG007326;
        Wed, 17 Nov 2021 07:33:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccvqgs05j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:33:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AH7NBTU022020;
        Wed, 17 Nov 2021 07:33:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50a70js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:33:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AH7QjsS62849506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:26:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C86B6AE05D;
        Wed, 17 Nov 2021 07:33:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E7E6AE058;
        Wed, 17 Nov 2021 07:33:38 +0000 (GMT)
Received: from [9.171.32.217] (unknown [9.171.32.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Nov 2021 07:33:38 +0000 (GMT)
Message-ID: <df5a43bb-3944-6fbb-a98f-94c46db867f8@linux.ibm.com>
Date:   Wed, 17 Nov 2021 08:33:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 5/6] KVM: s390: Cap KVM_CAP_NR_VCPUS by
 num_online_cpus()
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116163443.88707-1-vkuznets@redhat.com>
 <20211116163443.88707-6-vkuznets@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211116163443.88707-6-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tTITRuQ12V0bu5W-JKkzWTvAG6mXeues
X-Proofpoint-ORIG-GUID: 71uWVThZWuKvbBrnvpkAL1quj_aMigex
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_02,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111170034
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 16.11.21 um 17:34 schrieb Vitaly Kuznetsov:
> KVM_CAP_NR_VCPUS is a legacy advisory value which on other architectures
> return num_online_cpus() caped by KVM_CAP_NR_VCPUS or something else
> (ppc and arm64 are special cases). On s390, KVM_CAP_NR_VCPUS returns
> the same as KVM_CAP_MAX_VCPUS and this may turn out to be a bad
> 'advice'. Switch s390 to returning caped num_online_cpus() too.
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

you can also add
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

(yes I am changing my default address, but the other should continue to work)

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..1cfe36f6432e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -585,6 +585,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   			r = KVM_MAX_VCPUS;
>   		else if (sclp.has_esca && sclp.has_64bscao)
>   			r = KVM_S390_ESCA_CPU_SLOTS;
> +		if (ext == KVM_CAP_NR_VCPUS)
> +			r = min_t(unsigned int, num_online_cpus(), r);
>   		break;
>   	case KVM_CAP_S390_COW:
>   		r = MACHINE_HAS_ESOP;
> 
