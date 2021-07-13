Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F093C73B5
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhGMQCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:02:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhGMQCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:02:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DFY9G8032578;
        Tue, 13 Jul 2021 11:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8bsa/V2R76F6w2TRC20EjO/nofBz4DLtfnydLCgwmPQ=;
 b=gUipDVYpxt9GjMxfbo15ZCl0tQh5VYDdlsFPvRRW9Ntt/xdBFsiEevIhiJND++QIVOuo
 V4HnQS13EoMfEO097d5G17qI8++e+4s8ZCfzJdZshZSpWTXPBZJTLe8K/4GNrYUWBMnl
 TmgP3wx+gepmlY3yjC9VGqfYRWAuWKyPlc+1K8NwqwJmdMgDj87N5amMvt8xgzO/3cuY
 60asR7RP3Bq9aAqK+QpsmXDHM3/YUCkCFaccXqnG2vzUWH+GCbcuxU2CxbtKcs9M7Zz9
 vZf0ZTkuNuhKtnPgHZsBqD0V3JZggUwIEZlQlbMZC9YIepmXT9L8O4H64wISMJ54jxh9 HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrf8b935-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:59:24 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16DFk3xW092004;
        Tue, 13 Jul 2021 11:59:24 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrf8b922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:59:24 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DFxLx1029236;
        Tue, 13 Jul 2021 15:59:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 39q368gqnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 15:59:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DFxIQG35193166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 15:59:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D5352059;
        Tue, 13 Jul 2021 15:59:18 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.75.241])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C12015204E;
        Tue, 13 Jul 2021 15:59:17 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <82d32e12-c061-1fe0-0a3e-02c930cbab2e@de.ibm.com> <YO22qSixp0VWDle2@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <fe51925a-7f1c-fb98-94c9-729c5e23ff08@de.ibm.com>
Date:   Tue, 13 Jul 2021 17:59:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YO22qSixp0VWDle2@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BfyOdoVdHbrFi610_UazhLBake7TECbt
X-Proofpoint-GUID: U_C171hMRKvQpj8pmTSGzxo15RBeJIB0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_07:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=920 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.07.21 17:52, Heiko Carstens wrote:
> On Tue, Jul 13, 2021 at 05:41:33PM +0200, Christian Borntraeger wrote:
>> On 13.07.21 16:57, Heiko Carstens wrote:
>> [..]
>>> +#define HYPERCALL_FMT_0
>>> +#define HYPERCALL_FMT_1 , "0" (r2)
>>> +#define HYPERCALL_FMT_2 , "d" (r3) HYPERCALL_FMT_1
>>> +#define HYPERCALL_FMT_3 , "d" (r4) HYPERCALL_FMT_2
>>> +#define HYPERCALL_FMT_4 , "d" (r5) HYPERCALL_FMT_3
>>> +#define HYPERCALL_FMT_5 , "d" (r6) HYPERCALL_FMT_4
>>> +#define HYPERCALL_FMT_6 , "d" (r7) HYPERCALL_FMT_5
>>
>> This will result in reverse order.
>> old:
>> "d" (__nr), "0" (__p1), "d" (__p2), "d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
>> new:
>> "d"(__nr), "d"(r7), "d"(r6), "d"(r5), "d"(r4), "d"(r3), "0"(r2)
>>
>> As we do not reference the variable in the asm this should not matter,
>> I just noticed it when comparing the result of the preprocessed files.
>>
>> Assuming that we do not care this looks good.
> 
> Yes, it does not matter. Please let me know if should change it anyway.

No, I think this is ok.
Shall I take it via the kvm tree or do you want to take it via the s390 tree?
For that
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

