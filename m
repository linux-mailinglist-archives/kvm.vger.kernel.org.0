Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7178F43CB87
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbhJ0OJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:09:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233046AbhJ0OJL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:09:11 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RDHnDr027637;
        Wed, 27 Oct 2021 14:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vqAejZvKe9AeVf7S/8IHMdKVXn9Kn+hdYqiAWpzm8wg=;
 b=XWSZnsWDykFn+YxPctjSWx7yQPozOUaq9XcmfzexVh40BZZEB433uGxw5GXdFbd/TsLE
 Lh307cTeYfa4jQ6IE5Lftlp6pRFZ2myKLj/ahQZErM3mPxR2HjQE4g1QOFI0cL0uiY3M
 q7Z4EXwQV8ssINMbFx+8gUm6+HhrfoPn405vpdkGhGzUT24Abvvnl4G8ViIlRs0T0mQC
 lWYgkU8Q2FtmYh2Th1Z+nAy8PpKcSrNdtp+69UHmeFWTiW5lofOIaVxkgZ5+UIJ7EvJX
 zPX00qOC3P98yXa6cevkXNmyi2rE3GrplXyRAkNHqUxH84rMOguuPL5ultnxXL+eKddk mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by7he965s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:06:45 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19RDJJgE032176;
        Wed, 27 Oct 2021 14:06:45 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by7he965f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:06:45 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RE3Tvc021183;
        Wed, 27 Oct 2021 14:06:44 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3bx4f83w5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:06:44 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RE6gOU42402196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 14:06:42 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B0AB2805E;
        Wed, 27 Oct 2021 14:06:42 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E21028067;
        Wed, 27 Oct 2021 14:06:41 +0000 (GMT)
Received: from [9.160.124.65] (unknown [9.160.124.65])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 14:06:41 +0000 (GMT)
Message-ID: <b0d3a026-68ab-4783-d0dd-af50fd709260@linux.ibm.com>
Date:   Wed, 27 Oct 2021 10:06:40 -0400
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
 <ab36ddd3-1a05-ec6a-3c6e-a8881956d0e2@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
In-Reply-To: <ab36ddd3-1a05-ec6a-3c6e-a8881956d0e2@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J0b1rhH_UwOyjMKT_yqwkhsdk5xDAPlR
X-Proofpoint-ORIG-GUID: _SQF5PrXJDlzcvsCtia8qmLJF8jwISPE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 01:37, Christian Borntraeger wrote:
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
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> And it even finds a bug in QEMU. We clear the CPNC on local CPU resets.
> Can you have a look? I think we just have to move the cpnc in the env
> field from the normal/initial reset range to the full reset range.

I'll take a look at this right away.

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
>>       }
>>       /*
>>        * If userspace sets the riccb (e.g. after migration) to a valid
>> state,
>>


-- 
Regards,
Collin

Stay safe and stay healthy
