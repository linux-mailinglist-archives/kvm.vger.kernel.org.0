Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951B13F1B3D
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 16:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbhHSOKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 10:10:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58147 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238385AbhHSOKL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 10:10:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JE3UH5066940;
        Thu, 19 Aug 2021 10:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fOlNm9UGndJgHriN4IO131k+XnF+yCkTUGp6VeegnvM=;
 b=kUoJTXEMmVI7oblD3dqbgiACQqsduA5Jq7ynPQNr7C56ARX4nZvnixgsCuR0t+fc1BuE
 amkPRJnI3MSoiNfGlqHqIGq0SmuH0SPZSClEFye7ETj0nmgQmrE1ulMWMNMk3x5V7VPB
 9/siZuIYRP2hdwwaXeavhwnO4yef9jGQNyrzESqfbCiB8CjQmX0MfRzB3EysxXWCf70/
 YMZMMLyBQFQeLUTZRjifGjsVJrqC6CSSRu1U1t/QS9szwS9rQ5GYo7F8JRgcgE1sxBBO
 EsIXxba7pfz4+eXcfhKvlPFDSdMCzdTUTuDqSZfZQV5N0o1LxUuPCKmd3/7EKXjZKmm/ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq8hu30n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:09:30 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JE3ht8068116;
        Thu, 19 Aug 2021 10:09:30 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq8hu2yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:09:30 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JE8PhL014399;
        Thu, 19 Aug 2021 14:09:29 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3agfdne9k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 14:09:29 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JE7Yq444695958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 14:07:34 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 143A5112062;
        Thu, 19 Aug 2021 14:07:34 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9903711206B;
        Thu, 19 Aug 2021 14:07:33 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.65.229.69])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 14:07:33 +0000 (GMT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     thomas.lendacky@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, Steve Rutherford <srutherford@google.com>,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        qemu-devel@nongnu.org, frankeh@us.ibm.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
 <YR1ZvArdq4sKVyTJ@work-vm>
 <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
 <YR4U11ssVUztsPyx@work-vm>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <5d63f919-354e-5afa-fae4-0f520f5af215@linux.ibm.com>
Date:   Thu, 19 Aug 2021 10:07:33 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YR4U11ssVUztsPyx@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KRt3vr0R92vGAyXyolxYCtEk5d-z59Q5
X-Proofpoint-ORIG-GUID: WRpg8ltN1yjyzPCCsZRqj9VBZ_PPM23h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108190083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/21 4:22 AM, Dr. David Alan Gilbert wrote:
> * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
>> On 8/18/21 3:04 PM, Dr. David Alan Gilbert wrote:
>>
>>> Are you relying on the target firmware to be *identical* or purely for
>>> it to be *compatible* ?  It's normal for a migration to be the result of
>>> wanting to do an upgrade; and that means the destination build of OVMF
>>> might be newer (or older, or ...).
>>>
>>> Dave
>> This is a good point. The migration handler on the source and target must
>> have the same memory footprint or bad things will happen. Using the same
>> firmware on the source and target is an easy way to guarantee this. Since
>> the MH in OVMF is not a contiguous region of memory, but a group of
>> functions scattered around OVMF, it is a bit difficult to guarantee that the
>> memory footprint is the same if the build is different.
> Can you explain what the 'memory footprint' consists of? Can't it just
> be the whole of the OVMF rom space if you have no way of nudging the MH
> into it's own chunk?

The footprint is not massive. It is mainly ConfidentialMigrationDxe and 
the OVMF crypto support. It might be feasible to copy these components 
to a fixed location that would be the same across fw builds. It might 
also be feasible to pin these components to certain addresses. OVMF sort 
of supports doing this. We can raise the question in that community.

It also might work to protect the entirety of OVMF as you suggest. 
Currently we don't copy any of the OVMF ROM (as in flash0) over. That 
said, the MH doesn't run from the ROM so we would need to protect the 
memory used by OVMF as well. In some ways it might seem easier to 
protect all of the OVMF memory rather than just a couple of packages, 
but there are some complexities. For one thing, we would only want to 
protect efi runtime memory, as boot memory may be in use by the OS and 
would need to be migrated. The MH could check whether each page is efi 
runtime memory and skip any pages that are. Runtime memory won't be a 
contiguous blob, however, so for this approach the layout of the runtime 
memory would need to be the same on the source and target.

We can sidestep these issues entirely by using identical firmware 
images. That said, there are a number of strategies for developing 
compatible OVMF images and I definitely see the value of doing so.

-Tobin

>
> I think it really does have to cope with migration to a new version of
> host.
>
> Dave
>
>> -Tobin
>>
>>>
>>>> We start the target like a normal VM rather than
>>>> waiting for an incoming migration. The plan is to treat the target like a
>>>> normal VM for attestation as well. The guest owner will attest the target VM
>>>> just like they would any other VM that is started on their behalf. Secret
>>>> injection can be used to establish a shared key for the source and target.
>>>>
>>>> -Tobin
>>>>
>>>>> --Steve
>>>>>
