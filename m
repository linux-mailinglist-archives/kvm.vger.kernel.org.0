Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244523F0D96
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhHRVnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:43:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233971AbhHRVnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 17:43:04 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ILXQv3127870;
        Wed, 18 Aug 2021 17:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X/ZVamOOUM56zqGVXqXhKtm9nuRDiqFsLspvE+SmSLo=;
 b=Fvj1hqL2lX7upR5AKfgOxrK5khFyoj7tgvK5eayO5RO/p+KTsWI4b6x4NesYPKNm3N+A
 URI+oGD7GOKl59wIxAqQlDVaDpjg2aAcHe+JBVkAhElx+1p0Ulv4XckKKPu8kpwu3W95
 1nDtBvZFb9ut851FY4wAOxancWRI6DH2yfhnN2Dxec+YgHDSavkSCbKJF1U3KMphzUKq
 m6NWsRLWUUwJ+1Dret7m4WmnRasCZX7mUQKIL6KhJ6s15++/dkbNYeJ9WD36XpXAGNyb
 KFOcnaO5VEq9ygvgefhMfuO8Mq5MtTreEM/4HZK/qicBCanJnaj+yHfcvNkxXBO4tpUP Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf6uq2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 17:42:21 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ILXXVR128249;
        Wed, 18 Aug 2021 17:42:20 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf6uq1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 17:42:20 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17ILaRXd000505;
        Wed, 18 Aug 2021 21:42:19 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3ae5fe5nwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 21:42:19 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17ILgHhn8389206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 21:42:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3E6CAE07D;
        Wed, 18 Aug 2021 21:42:17 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76D89AE06D;
        Wed, 18 Aug 2021 21:42:17 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.77.128.89])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 21:42:17 +0000 (GMT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, jejb@linux.ibm.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        frankeh@us.ibm.com, dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
 <YR1ZvArdq4sKVyTJ@work-vm>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
Date:   Wed, 18 Aug 2021 17:42:16 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YR1ZvArdq4sKVyTJ@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O_1Qqnfk-yDoDkmanszpGR48sMJ1efjy
X-Proofpoint-GUID: lczFpwtEUJtXdyY0Y1zatQYDEk_mM86E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_07:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180132
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 3:04 PM, Dr. David Alan Gilbert wrote:
> * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
>> On 8/17/21 6:04 PM, Steve Rutherford wrote:
>>> Ahh, It sounds like you are looking into sidestepping the existing
>>> AMD-SP flows for migration. I assume the idea is to spin up a VM on
>>> the target side, and have the two VMs attest to each other. How do the
>>> two sides know if the other is legitimate? I take it that the source
>>> is directing the LAUNCH flows?
>> Yeah we don't use PSP migration flows at all. We don't need to send the MH
>> code from the source to the target because the MH lives in firmware, which
>> is common between the two.
> Are you relying on the target firmware to be *identical* or purely for
> it to be *compatible* ?  It's normal for a migration to be the result of
> wanting to do an upgrade; and that means the destination build of OVMF
> might be newer (or older, or ...).
>
> Dave

This is a good point. The migration handler on the source and target 
must have the same memory footprint or bad things will happen. Using the 
same firmware on the source and target is an easy way to guarantee this. 
Since the MH in OVMF is not a contiguous region of memory, but a group 
of functions scattered around OVMF, it is a bit difficult to guarantee 
that the memory footprint is the same if the build is different.

-Tobin

>
>
>> We start the target like a normal VM rather than
>> waiting for an incoming migration. The plan is to treat the target like a
>> normal VM for attestation as well. The guest owner will attest the target VM
>> just like they would any other VM that is started on their behalf. Secret
>> injection can be used to establish a shared key for the source and target.
>>
>> -Tobin
>>
>>> --Steve
>>>
