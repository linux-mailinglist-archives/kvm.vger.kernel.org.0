Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC69D20A0FB
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 16:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405374AbgFYOmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 10:42:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405364AbgFYOmV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 10:42:21 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PEaKDR193255;
        Thu, 25 Jun 2020 10:42:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ux080tca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 10:42:19 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05PEajwb195226;
        Thu, 25 Jun 2020 10:42:19 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ux080tbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 10:42:19 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05PEdiK9023431;
        Thu, 25 Jun 2020 14:42:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 31uurq7x9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 14:42:18 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05PEgGcv34930948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 14:42:16 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B6AB205F;
        Thu, 25 Jun 2020 14:42:16 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA360B2067;
        Thu, 25 Jun 2020 14:42:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.202.75])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Jun 2020 14:42:15 +0000 (GMT)
Subject: Re: [PATCH 1/2] docs: kvm: add documentation for KVM_CAP_S390_DIAG318
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200624202200.28209-1-walling@linux.ibm.com>
 <20200624202200.28209-2-walling@linux.ibm.com>
 <151bb070-f083-5011-2f04-291058bc9cc2@linux.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <0503ff8d-21ad-1e6c-783b-3857bda76161@linux.ibm.com>
Date:   Thu, 25 Jun 2020 10:42:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <151bb070-f083-5011-2f04-291058bc9cc2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_10:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 cotscore=-2147483648 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/20 3:16 AM, Janosch Frank wrote:
> On 6/24/20 10:21 PM, Collin Walling wrote:
>> Documentation for the s390 DIAGNOSE 0x318 instruction handling.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 426f94582b7a..056608e8f243 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6150,3 +6150,22 @@ KVM can therefore start protected VMs.
>>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>>  guests when the state change is invalid.
>> +
>> +8.24 KVM_CAP_S390_DIAG318
>> +-------------------------
>> +
>> +:Architecture: s390
>> +
>> +This capability allows for information regarding the control program that may
>> +be observed via system/firmware service events. The availability of this
> 
> I'm not sure if control program is understood universally, it's a rather
> old term to say guest kernel.
> 
> How about:
> 
> This capability allows a guest to set information about its control
> program (i.e. guest kernel type and version). The information is helpful
> on system/firmware service events, providing additional data about what
> environments are running on the machine.
> 
> 

Fair point. I'll add some clarity to this.

>> +capability indicates that KVM handling of the register synchronization, reset,
>> +and VSIE shadowing of the DIAGNOSE 0x318 related information is present.
>> +
>> +The information associated with the instruction is an 8-byte value consisting
>> +of a one-byte Control Program Name Code (CPNC), and a 7-byte Control Program
>> +Version Code (CPVC). The CPNC determines what environment the control program
>> +is running in (e.g. Linux, z/VM...), and the CPVC is used for extraneous
>> +information specific to OS (e.g. Linux version, Linux distribution...)
>> +
>> +If this capability is available, then the CPNC and CPVC can be synchronized
>> +between KVM and userspace via the sync regs mechanism (KVM_SYNC_DIAG318).
>>
> 
> 


-- 
Regards,
Collin

Stay safe and stay healthy
