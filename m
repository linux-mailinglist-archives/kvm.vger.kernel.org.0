Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26202AD687
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 13:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgKJMlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 07:41:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13730 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgKJMlY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 07:41:24 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AACWwYW041174
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 07:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C3Im1YQ+MDo8CdOGLf0QV7x7z8JQ0Ydm5ANvod9yYfw=;
 b=ok+MofM4U9ppdjM2ZNiKyVb8WRllJYbtOt3ftcigN5/Uoehefb6oYO+1RGW+KIMjGbam
 rFtVarTxRZ2NjIrt6MVUPOO7f5WU0eDM7BJSE+SLHd3yj8FJ1ImlEGLAitGiljAaapo8
 kQInzGSGK/jUg9cqp0+Wp34WjcVOQM3YZHGms3sNPoKyBJVTdLdmU7kKA0R9PLvfexpa
 zmpz5i2zmOPkW/EmIIjLErXNymhxd7Lyv7n24OsCtDv23QN/4n5jflBIUTibbrZjIVI/
 Bs+3zmUMCyv/xRrlsP1PjFDYaw/RivxWnJJYcJ6TOgIwa7cYdA0MKGDjdH3CbHZLX5v9 Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34qby991en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 07:41:23 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AACXsog048972
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 07:41:23 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34qby991d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 07:41:23 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AACSiJS022714;
        Tue, 10 Nov 2020 12:41:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34nk78k534-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 12:41:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AACfHlc4195010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 12:41:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6B2C4C044;
        Tue, 10 Nov 2020 12:41:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A2B24C052;
        Tue, 10 Nov 2020 12:41:17 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.80.78])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Nov 2020 12:41:17 +0000 (GMT)
Subject: Re: [PATCH] s390/kvm: remove diag318 reset code
To:     Cornelia Huck <cohuck@redhat.com>,
        Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, frankja@linux.ibm.com
References: <20201104181032.109800-1-walling@linux.ibm.com>
 <20201110114339.3515ec7a.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <128492b1-2d2d-babe-3c27-10f3d1f493e9@de.ibm.com>
Date:   Tue, 10 Nov 2020 13:41:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201110114339.3515ec7a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.11.20 11:43, Cornelia Huck wrote:
> On Wed,  4 Nov 2020 13:10:32 -0500
> Collin Walling <walling@linux.ibm.com> wrote:
> 
>> The diag318 data must be set to 0 by VM-wide reset events
>> triggered by diag308. As such, KVM should not handle
>> resetting this data via the VCPU ioctls.
>>
>> Fixes: 23a60f834406 (s390/kvm: diagnose 0x318 sync and reset)
> 
> Should be
> 
> Fixes: 23a60f834406 ("s390/kvm: diagnose 0x318 sync and reset")

yes.

> 
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6b74b92c1a58..f9e118a0e113 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3564,7 +3564,6 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>  		vcpu->arch.sie_block->pp = 0;
>>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>>  		vcpu->arch.sie_block->todpr = 0;
>> -		vcpu->arch.sie_block->cpnc = 0;
>>  	}
>>  }
>>  
>> @@ -3582,7 +3581,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>>  
>>  	regs->etoken = 0;
>>  	regs->etoken_extension = 0;
>> -	regs->diag318 = 0;
>>  }
>>  
>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> 
> I assume that we rely on the QEMU patch to get a completely working
> setup?

Yes, but this fix is correct in itself and needed anyway.
