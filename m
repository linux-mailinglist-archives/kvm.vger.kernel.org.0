Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BCF203C4F
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgFVQN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:13:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14778 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729275AbgFVQN4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:13:56 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG1eDZ193655;
        Mon, 22 Jun 2020 12:13:55 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02g7hap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:13:51 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MFxm1P075769;
        Mon, 22 Jun 2020 12:13:37 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02g7h22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:13:37 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MFxdFn001519;
        Mon, 22 Jun 2020 16:13:19 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 31t35bkmar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:13:19 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGDFBj45351404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:13:15 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BA23BE053;
        Mon, 22 Jun 2020 16:13:15 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 771A9BE04F;
        Mon, 22 Jun 2020 16:13:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.169.243])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Jun 2020 16:13:14 +0000 (GMT)
Subject: Re: [PATCH v9 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200622154636.5499-1-walling@linux.ibm.com>
 <20200622154636.5499-3-walling@linux.ibm.com>
 <20200622180459.4cf7cbf4.cohuck@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <93bd30de-2cd0-a044-4e9b-05b1eda9acb3@linux.ibm.com>
Date:   Mon, 22 Jun 2020 12:13:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622180459.4cf7cbf4.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 cotscore=-2147483648 mlxscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 12:04 PM, Cornelia Huck wrote:
> On Mon, 22 Jun 2020 11:46:36 -0400
> Collin Walling <walling@linux.ibm.com> wrote:
> 
>> DIAGNOSE 0x318 (diag318) sets information regarding the environment
>> the VM is running in (Linux, z/VM, etc) and is observed via
>> firmware/service events.
>>
>> This is a privileged s390x instruction that must be intercepted by
>> SIE. Userspace handles the instruction as well as migration. Data
>> is communicated via VCPU register synchronization.
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block. The
>> CPNC along with the Control Program Version Code (CPVC) are stored
>> in the kvm_vcpu_arch struct.
>>
>> This data is reset on load normal and clear resets.
> 
> Looks good to me AFAICS without access to the architecture.
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> 
> One small thing below.
> 
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  4 +++-
>>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>>  arch/s390/kvm/vsie.c             |  1 +
>>  include/uapi/linux/kvm.h         |  1 +
>>  5 files changed, 19 insertions(+), 3 deletions(-)
> 
> (...)
> 
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4fdf30316582..35cdb4307904 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_SECURE_GUEST 181
>>  #define KVM_CAP_HALT_POLL 182
>>  #define KVM_CAP_ASYNC_PF_INT 183
>> +#define KVM_CAP_S390_DIAG318 184
> 
> Should we document this in Documentation/virt/kvm/api.rst?
> 
> (Documentation of KVM caps generally seems to be a bit of a
> hit-and-miss, though. But we could at least document the s390 ones :)
> 
> I also noticed that the new entries for the vcpu resets and pv do not
> seem to be in proper rst format. Maybe fix that and add the new doc in
> an add-on series?
> 

Sure thing. I'll fix up the rst and add docs for the new DIAG cap.

>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
> 


-- 
Regards,
Collin

Stay safe and stay healthy
