Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2449EFC3B9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 11:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKNKLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 05:11:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbfKNKLZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 05:11:25 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAACrA112048
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 05:11:24 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w943w9rvp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 05:11:23 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 10:11:21 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:11:19 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEABIXi49283170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:11:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2FF552050;
        Thu, 14 Nov 2019 10:11:18 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6CBA252051;
        Thu, 14 Nov 2019 10:11:18 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <20191113140539.4d153d5f.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 11:11:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191113140539.4d153d5f.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111410-0020-0000-0000-0000038618A6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0021-0000-0000-000021DC2E05
Message-Id: <802c298d-d2da-83c4-c222-67bb78131988@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=970 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-13 14:05, Cornelia Huck wrote:
> On Wed, 13 Nov 2019 13:23:19 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> This simple test test the I/O reading by the SUB Channel by:
>> - initializing the Channel SubSystem with predefined CSSID:
>>    0xfe000000 CSSID for a Virtual CCW
> 0 should be fine with recent QEMU versions as well, I guess?
Right


>
>>    0x00090000 SSID for CCW-PONG
> subchannel id, or subchannel set id?

hum, only part of, I had SSID (Subchannel Set ID) 4 (a.k.a m bit) + Bit 
47  =1

But as you said, I can use CSSID 0 and m = 0 which makes:

Subsystem Identification word = 0x00010000


>
>> - initializing the ORB pointing to a single READ CCW
> Out of curiosity: Would using a NOP also be an option?

It will work but will not be handled by this device, css.c intercept it 
in sch_handle_start_func_virtual.

AFAIU If we want to have a really good testing environment, for driver 
testing for exemple, then it would be interesting to add a new 
do_subchannel_work callback like do_subchannel_work_emulation along with 
the _virtual and _paththrough variantes.

Having a dedicated callback for emulation, we can answer to any CSS 
instructions and SSCH commands, including NOP and TIC.

My goal here was to quickly develop a device answering to some basic 
READ/WRITE command to start memory transfers from inside a guest without 
Linux and without implementing VIRTIO in KVM tests.



>
>> - starts the STSH command with the ORB
> s/STSH/SSCH/ ?

:) yes, thanks


>
>> - Expect an interrupt
>> - writes the read data to output
>>
>> The test implements lots of traces when DEBUG is on and
>> tests if memory above the stack is corrupted.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 141 +++++++++++++++++++++++++++++
>>   s390x/Makefile       |   2 +
>>   s390x/css.c          | 222 ++++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg  |   4 +
>>   5 files changed, 613 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
>>   create mode 100644 s390x/css.c
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> new file mode 100644
>> index 0000000..a7c42fd
>> --- /dev/null
>> +++ b/lib/s390x/css.h
> (...)
>
>> +static inline int rsch(unsigned long schid)
> I don't think anyone has tried rsch with QEMU before; sounds like a
> good idea to test this :)

With an do_subchannel_work_emulation() callback?


>
>> +{
>> +	register unsigned long reg1 asm("1") = schid;
>> +	int ccode;
>> +
>> +	asm volatile(
>> +		"	rsch\n"
>> +		"	ipm	%0\n"
>> +		"	srl	%0,28"
>> +		: "=d" (ccode)
>> +		: "d" (reg1)
>> +		: "cc");
>> +	return ccode;
>> +}
>> +
>> +static inline int rchp(unsigned long chpid)
> Anything useful we can test here?

Not for now.

I certainly can reduce the size of the file by removing the unused CSS 
instructions calls.

...snip...
> +
>> +static void enable_io_irq(void)
>> +{
>> +	set_io_irq_subclass_mask(0x00000000ff000000);
> So, you always enable all iscs? Maybe add a comment?

OK, is just a lazy option to get IRQ for this test.

Right, I add a comment.


>
>> +	set_system_mask(PSW_PRG_MASK >> 56);
>> +}
>> +
>> +void handle_io_int(sregs_t *regs)
>> +{
>> +	int ret = 0;
>> +
>> +	DBG("IO IRQ: subsys_id_word=%08x", lowcore->subsys_id_word);
>> +	DBG("......: io_int_parm   =%08x", lowcore->io_int_param);
>> +	DBG("......: io_int_word   =%08x", lowcore->io_int_word);
>> +	ret = tsch(lowcore->subsys_id_word, &irb);
>> +	dump_irb(&irb);
>> +	if (ret)
>> +		DBG("......: tsch retval %d", ret);
>> +	DBG("IO IRQ: END");
>> +}
>> +
>> +static void set_schib(struct schib *sch)
>> +{
>> +	struct pmcw *p = &sch->pmcw;
>> +
>> +	p->intparm = 0xdeadbeef;
>> +	p->devnum = 0xc0ca;
>> +	p->lpm = 0x80;
>> +	p->flags = 0x3081;
> Use #defines instead of magic numbers?

OK


>
>> +	p->chpid[7] = 0x22;
>> +	p->pim = 0x0f;
>> +	p->pam = 0x0f;
>> +	p->pom = 0x0f;
>> +	p->lpm = 0x0f;
>> +	p->lpum = 0xaa;
>> +	p->pnom = 0xf0;
>> +	p->mbi = 0xaa;
>> +	p->mbi = 0xaaaa;
> Many of these fields are not supposed to be modifiable by the program
> -- do you want to check what you get back after msch?
>
> Also, you set mbi twice ;) (And for it to actually have any effect,
> you'd have to execute SET CHANNEL MONITOR, no?)

Yes, it was for me to check what happens but I should remove most of 
these field initialization.

As you said they are not modifiable by the program.

Will clean this.


>
>
>> +}
>> +
>> +static void css_enable(void)
>> +{
>> +	int ret;
>> +
>> +	ret = stsch(CSSID_PONG, &schib);
>> +	if (ret)
>> +		DBG("stsch: %x\n", ret);
>> +	dump_schib(&schib);
>> +	set_schib(&schib);
>> +	dump_schib(&schib);
>> +	ret = msch(CSSID_PONG, &schib);
>> +	if (ret)
>> +		DBG("msch : %x\n", ret);
>> +}
>> +
>> +/* These two definitions are part of the QEMU PONG interface */
>> +#define PONG_WRITE 0x21
>> +#define PONG_READ  0x22
> Ah, so it's not a plain read/write, but a specialized one? Mention that
> in the patch description?
>
>> +
>> +static int css_run(int fake)
>> +{
>> +	struct orb *p = orb;
> I'd maybe call that variable 'orb' instead; at a glance, I was confused
> what you did with the pmcw below, until I realized that it's the orb :)

OK, is clearly better to use orb.


Thanks,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

