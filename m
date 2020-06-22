Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220C4203CDC
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgFVQqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:46:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729309AbgFVQp7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:45:59 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG6rdD184226;
        Mon, 22 Jun 2020 12:45:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tys216yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:45:58 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MGHxpp011500;
        Mon, 22 Jun 2020 12:45:58 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tys216yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:45:58 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGjejp007622;
        Mon, 22 Jun 2020 16:45:57 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 31t35bkup9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:45:57 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGjqJc20316564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:45:52 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE4DFBE04F;
        Mon, 22 Jun 2020 16:45:53 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B794ABE051;
        Mon, 22 Jun 2020 16:45:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.169.243])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Jun 2020 16:45:52 +0000 (GMT)
Subject: Re: [PATCH v9 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200622154636.5499-1-walling@linux.ibm.com>
 <20200622154636.5499-3-walling@linux.ibm.com>
 <20200622180459.4cf7cbf4.cohuck@redhat.com>
 <93bd30de-2cd0-a044-4e9b-05b1eda9acb3@linux.ibm.com>
 <cda0b27f-ec26-e596-9814-c4ce81915bcb@linux.ibm.com>
 <20200622183512.3547d21b.cohuck@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <effbf851-452b-bdf0-6455-3df2ec0b9a87@linux.ibm.com>
Date:   Mon, 22 Jun 2020 12:45:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622183512.3547d21b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 cotscore=-2147483648 phishscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 12:35 PM, Cornelia Huck wrote:
> On Mon, 22 Jun 2020 12:23:45 -0400
> Collin Walling <walling@linux.ibm.com> wrote:
> 
>> Mind if I get some early feedback for the first run? How does this sound:
>>
>> 8.24 KVM_CAP_S390_DIAG318
>> -------------------------
>>
>> :Architecture: s390
>>
>> This capability allows for information regarding the control program
>> that may be observed via system/firmware service events. The
>> availability of this capability indicates that KVM handling of the
>> register synchronization, reset, and VSIE shadowing of the DIAGNOSE
>> 0x318 related information is present.
>>
>> The information associated with the instruction is an 8-byte value
>> consisting of a one-byte Control Program Name Code (CPNC), and a 7-byte
>> Control Program Version Code (CPVC). The CPNC determines what
>> environment the control program is running in (e.g. Linux, z/VM...), and
>> the CPVC is used for extraneous information specific to OS (e.g. Linux
>> version, Linux distribution...)
>>
>> The CPNC must be stored in the SIE block for the CPU that executes the
>> diag instruction, which is communicated from userspace to KVM via
>> register synchronization using the KVM_SYNC_DIAG318 flag. Both codes are
>> stored together in the kvm_vcpu_arch struct.
> 
> Hm... what about replacing that last paragraph with
> 
> "If this capability is available, the CPNC and CPVC are available for
> synchronization between KVM and userspace via the sync regs mechanism
> (KVM_SYNC_DIAG318)."
> 
> ?
> 

I like it!

-- 
Regards,
Collin

Stay safe and stay healthy
