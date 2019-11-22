Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F047410726C
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 13:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKVMtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 07:49:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbfKVMtA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Nov 2019 07:49:00 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMClBY8112355
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 07:48:58 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wdhwsu6fv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 07:48:58 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 22 Nov 2019 12:48:56 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Nov 2019 12:48:54 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAMCmrB549807576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 12:48:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA685204F;
        Fri, 22 Nov 2019 12:48:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.30.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 332B652050;
        Fri, 22 Nov 2019 12:48:53 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <20191113140539.4d153d5f.cohuck@redhat.com>
 <802c298d-d2da-83c4-c222-67bb78131988@linux.ibm.com>
 <20191121170237.72e0bd45.cohuck@redhat.com>
 <0c9d19ef-8ef7-0dab-b283-3db243b95476@linux.ibm.com>
 <20191122115422.56019f03.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 22 Nov 2019 13:48:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191122115422.56019f03.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112212-0012-0000-0000-0000036AC524
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112212-0013-0000-0000-000021A65D74
Message-Id: <bcdd966d-b60d-471c-0c48-a7d0cd006e42@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_02:2019-11-21,2019-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-22 11:54, Cornelia Huck wrote:
> On Fri, 22 Nov 2019 10:03:21 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> On 2019-11-21 17:02, Cornelia Huck wrote:
>>> On Thu, 14 Nov 2019 11:11:18 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>   
>>>> On 2019-11-13 14:05, Cornelia Huck wrote:
>>>>> On Wed, 13 Nov 2019 13:23:19 +0100
>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>>>> - initializing the ORB pointing to a single READ CCW
>>>>> Out of curiosity: Would using a NOP also be an option?
>>>> It will work but will not be handled by this device, css.c intercept it
>>>> in sch_handle_start_func_virtual.
>>>>
>>>> AFAIU If we want to have a really good testing environment, for driver
>>>> testing for exemple, then it would be interesting to add a new
>>>> do_subchannel_work callback like do_subchannel_work_emulation along with
>>>> the _virtual and _paththrough variantes.
>>>>
>>>> Having a dedicated callback for emulation, we can answer to any CSS
>>>> instructions and SSCH commands, including NOP and TIC.
>>> I guess that depends on what you want to test; if you actually want to
>>> test device emulation as used by virtio etc., you obviously want to go
>>> through the existing _virtual callback :)
>> The first goal is to test basic I/O from inside the kvm-unit-test,
>> producing errors and see how the system respond to errors.
>>
>> In a standard system errors will be generated by QEMU analysing the I/O
>> instruction after interception.
>>
>> In a secured guest, we expect the same errors, however we want to check
>> this.
> But we still get the intercepts for all I/O instructions, right? We
> just get/inject the parameters in a slightly different way, IIUC.
>
> Not that I disagree with wanting to check this :)

AFAIU the SE firmware, the SIE and KVM first handle the instruction 
interception before it comes to the QEMU code.

There are two major changes with secure execution that we want to test, 
SE firmware and SIE modifications.
If the instruction is treated by QEMU, then hopefully we get the same 
answer as without SE.


>
>> This PONG device is intended to be low level, no VIRTIO, and to allow
>> basic I/O.
> Ok, so this is designed to test basic channel I/O handling, not
> necessarily if the guest has set up all its control structures
> correctly?

More than this it is intended, in the next version, to test answers to 
bad configurations and wrong instruction's arguments.


>
>>> The actual motivation behind my question was:
>>> Is it possible to e.g. throw NOP (or TIC, or something else not
>>> device-specific) at a normal, existing virtio device for test purposes?
>>> You'd end up testing the common emulation code without needing any
>>> extra support in QEMU. No idea how useful that would be.
>> Writing a VIRTIO driver inside the kvm-unit-test is something we can do
>> in the future.
>>
>> As you said, the common code already handle NOP and TIC, the
>> interpretation of the
>> CCW chain, once the SSCH has been intercepted is done by QEMU.
>> I do not think it would be different with SE.
> Yes. You don't really need to get the virtio device up on the virtio
> side; if recognizing the device correctly via senseID works and you
> maybe can do some NOP/TIC commands, you might have a very basic test
> without introducing a new device.

Right, but the test is incomplete, as you said before, no write 
operation with this procedure.


>
> Testing virtio-ccw via kvm-unit-tests is probably a good idea for the
> future.
>
>> To sum-up:
>>
>> in kvm-unit-test: implement all I/O instructions and force instructions
>> errors, like memory error, operand etc. and expect the right reaction of
>> the system.
>>
>> in QEMU, add the necessary infrastructure to test this.
> Sounds good to me.

Thanks,

I think the next version will make the purpose of all of it even more 
obvious,
and hopefully answers all your questions better.

Best regards,

Pierre

>
-- 
Pierre Morel
IBM Lab Boeblingen

