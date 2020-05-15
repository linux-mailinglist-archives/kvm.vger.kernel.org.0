Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4745C1D46D6
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEOHL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:11:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgEOHL7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:11:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F72fwT036590;
        Fri, 15 May 2020 03:11:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w9df31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:11:58 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F73Dd4038988;
        Fri, 15 May 2020 03:11:57 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w9df20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:11:57 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F74f4X004167;
        Fri, 15 May 2020 07:11:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3100ubj34c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 07:11:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F7Bqdo48889934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 07:11:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6E6AA4064;
        Fri, 15 May 2020 07:11:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98F61A405F;
        Fri, 15 May 2020 07:11:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 07:11:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 07/10] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-8-git-send-email-pmorel@linux.ibm.com>
 <cff917e0-f7e0-fd48-eda5-0cbe8173ae8a@linux.ibm.com>
 <abafd691-d9ab-33b2-c522-d37fecc3e881@linux.ibm.com>
 <20200514140808.269f6485.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <de18eab3-4d0a-1b86-f6c4-27aaa7bba6bf@linux.ibm.com>
Date:   Fri, 15 May 2020 09:11:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514140808.269f6485.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 cotscore=-2147483648 clxscore=1015 mlxscore=0 malwarescore=0
 mlxlogscore=923 phishscore=0 adultscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-14 14:08, Cornelia Huck wrote:
> On Tue, 28 Apr 2020 10:27:36 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-04-27 15:11, Janosch Frank wrote:
>>> On 4/24/20 12:45 PM, Pierre Morel wrote:
> 
>>>> This is NOT a routine to really enable the channel, no retry is done,
>>>> in case of error, a report is made.
>>>
>>> Would we expect needing retries for the pong device?
>>
>> Yes it can be that we need to retry some instructions if we want them to
>> succeed.
>> This is the case for example if we develop a driver for an operating system.
>> When working with firmware, sometime, things do not work at the first
>> time. Mostly due to races in silicium, firmware or hypervisor or between
>> them all.
>>
>> Since our purpose is to detect such problems we do not retry
>> instructions but report the error.
>>
>> If we detect such problem we may in the future enhance the tests.
> 
> I think I've seen retries needed on z/VM in the past; do you know if
> that still happens?
> 

I did not try the tests under z/VM, nor direct on an LPAR, only under 
QEMU/KVM.
Under QEMU/KVM, I did not encounter any need for retry, 100% of the 
enabled succeeded on first try.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
