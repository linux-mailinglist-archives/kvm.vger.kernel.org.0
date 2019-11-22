Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C2C106892
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 10:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfKVJD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 04:03:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbfKVJD1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Nov 2019 04:03:27 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM92a8M057064
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 04:03:26 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wd3fnmw37-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 04:03:26 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 22 Nov 2019 09:03:24 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Nov 2019 09:03:23 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAM93MGd36503800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 09:03:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6067DA404D;
        Fri, 22 Nov 2019 09:03:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10E1AA4057;
        Fri, 22 Nov 2019 09:03:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.182.139])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Nov 2019 09:03:21 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <20191113140539.4d153d5f.cohuck@redhat.com>
 <802c298d-d2da-83c4-c222-67bb78131988@linux.ibm.com>
 <20191121170237.72e0bd45.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 22 Nov 2019 10:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191121170237.72e0bd45.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112209-4275-0000-0000-00000384C94A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112209-4276-0000-0000-000038984946
Message-Id: <0c9d19ef-8ef7-0dab-b283-3db243b95476@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_01:2019-11-21,2019-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911220080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-21 17:02, Cornelia Huck wrote:
> On Thu, 14 Nov 2019 11:11:18 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> On 2019-11-13 14:05, Cornelia Huck wrote:
>>> On Wed, 13 Nov 2019 13:23:19 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>   
>>>> This simple test test the I/O reading by the SUB Channel by:
>>>> - initializing the Channel SubSystem with predefined CSSID:
>>>>     0xfe000000 CSSID for a Virtual CCW
>>> 0 should be fine with recent QEMU versions as well, I guess?
>> Right
>>
>>
>>>   
>>>>     0x00090000 SSID for CCW-PONG
>>> subchannel id, or subchannel set id?
>> hum, only part of, I had SSID (Subchannel Set ID) 4 (a.k.a m bit) + Bit
>> 47  =1
>>
>> But as you said, I can use CSSID 0 and m = 0 which makes:
>>
>> Subsystem Identification word = 0x00010000
> Yeah, I was mainly confused by the name 'SSID'.

Hum, yes sorry, I posted this to give a response to the kvm-test-unit 
css test.

I should have a lot more rework this old device before to post this series.
In between I did, so I will post a v2 which will suppress all these 
approximations.


>
>>>> - initializing the ORB pointing to a single READ CCW
>>> Out of curiosity: Would using a NOP also be an option?
>> It will work but will not be handled by this device, css.c intercept it
>> in sch_handle_start_func_virtual.
>>
>> AFAIU If we want to have a really good testing environment, for driver
>> testing for exemple, then it would be interesting to add a new
>> do_subchannel_work callback like do_subchannel_work_emulation along with
>> the _virtual and _paththrough variantes.
>>
>> Having a dedicated callback for emulation, we can answer to any CSS
>> instructions and SSCH commands, including NOP and TIC.
> I guess that depends on what you want to test; if you actually want to
> test device emulation as used by virtio etc., you obviously want to go
> through the existing _virtual callback :)

The first goal is to test basic I/O from inside the kvm-unit-test, 
producing errors and see how the system respond to errors.

In a standard system errors will be generated by QEMU analysing the I/O 
instruction after interception.

In a secured guest, we expect the same errors, however we want to check 
this.

This PONG device is intended to be low level, no VIRTIO, and to allow 
basic I/O.


>
> The actual motivation behind my question was:
> Is it possible to e.g. throw NOP (or TIC, or something else not
> device-specific) at a normal, existing virtio device for test purposes?
> You'd end up testing the common emulation code without needing any
> extra support in QEMU. No idea how useful that would be.

Writing a VIRTIO driver inside the kvm-unit-test is something we can do 
in the future.

As you said, the common code already handle NOP and TIC, the 
interpretation of the
CCW chain, once the SSCH has been intercepted is done by QEMU.
I do not think it would be different with SE.


>
>> My goal here was to quickly develop a device answering to some basic
>> READ/WRITE command to start memory transfers from inside a guest without
>> Linux and without implementing VIRTIO in KVM tests.
> Yes, if you want to do some simple memory transfers, virtio is probably
> not the first choice. Would e.g. doing a SenseID or so actually be
> useful in some way already? After all, it does transfer memory (but
> only in one direction).

The kvm-unit-test part is in development too.

Doing a SenseID will be implemented to recognize the PONG device.


>
>>>> +static inline int rsch(unsigned long schid)
>>> I don't think anyone has tried rsch with QEMU before; sounds like a
>>> good idea to test this :)
>> With an do_subchannel_work_emulation() callback?
> You probably need to build a simple channel program that suspends
> itself and can be resumed later.

Yes, that is something I plan to do.

To sum-up:

in kvm-unit-test: implement all I/O instructions and force instructions 
errors, like memory error, operand etc. and expect the right reaction of 
the system.

in QEMU, add the necessary infrastructure to test this.


Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

