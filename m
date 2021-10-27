Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD443CB8F
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbhJ0OJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:09:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhJ0OJ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:09:58 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RDHf6W032778;
        Wed, 27 Oct 2021 14:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2HhZ1iSB06fU1gQUbee7ylyzdJtktEf57Zt5XEr4R1M=;
 b=ZhPch7hJgClbPZDeLFHfaFZ86e+IZBt7jX8Ln8pLhKrBcxFQkGP8DI5c55BziRIToAtK
 be5asmE/hArUk/6uiSpALWJbklPhnozzunOq0KHOFL2/LeabpCd/eYyGcWK2gAS1udgR
 ll4v9Wna/vJpL3140STzQMSwhd3nUtLb8O8QsFk54NO9JPcUlruSB3aVGWCC3AL+VfIc
 ydehHQ2UcSBLKWZscsvcLmPYjc4zjoJY8SDhd2oWbyuLkV116W1j0xaRAmwrFEiKUQKc
 cElrKOQ5dwJbaj95sWmQj/JwH5sJUUVEIaps9tbYcLk+cR+6t6RliXOY68zZNBaUl5fs +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by7hb983y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:07:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19RDufam021267;
        Wed, 27 Oct 2021 14:07:32 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by7hb9838-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:07:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RE3Xqk021716;
        Wed, 27 Oct 2021 14:07:30 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3bx4fabwfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:07:30 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RE71xC7799416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 14:07:01 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2A522806E;
        Wed, 27 Oct 2021 14:07:00 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D28C28066;
        Wed, 27 Oct 2021 14:07:00 +0000 (GMT)
Received: from [9.160.124.65] (unknown [9.160.124.65])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 14:07:00 +0000 (GMT)
Message-ID: <83c63ace-3277-cf8a-8fd1-88d8d28113db@linux.ibm.com>
Date:   Wed, 27 Oct 2021 10:07:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
 <5f91eed7-993a-cb76-8a9f-0c17438cd064@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
In-Reply-To: <5f91eed7-993a-cb76-8a9f-0c17438cd064@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0LtBPSX_8woc1nUMBvczgXB7UiZC6wdQ
X-Proofpoint-ORIG-GUID: 2mMEelC8xQ84Bb5TGHUqy9rPUDGOP0jf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 01:41, Christian Borntraeger wrote:
> Am 27.10.21 um 04:54 schrieb Collin Walling:
>> The diag 318 data contains values that denote information regarding the
>> guest's environment. Currently, it is unecessarily difficult to observe
>> this value (either manually-inserted debug statements, gdb stepping, mem
>> dumping etc). It's useful to observe this information to obtain an
>> at-a-glance view of the guest's environment, so lets add a simple VCPU
>> event that prints the CPNC to the s390dbf logs.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> 
> applied and queued
>> ---
>>   arch/s390/kvm/kvm-s390.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6a6dd5e1daf6..da3ff24eabd0 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>       if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>>           vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>>           vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
>> +        VCPU_EVENT(vcpu, 2, "setting cpnc to %d",
>> vcpu->arch.diag318_info.cpnc);
> 
> After comparing this with the other events I think level==3 is better.
> Changed when applying.
>>       }
>>       /*
>>        * If userspace sets the riccb (e.g. after migration) to a valid
>> state,
>>

Thanks!


-- 
Regards,
Collin

Stay safe and stay healthy
