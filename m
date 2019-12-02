Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1186B10EF04
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfLBSS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 13:18:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727721AbfLBSS2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 13:18:28 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2II6Ic036622
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 13:18:27 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wm6g8sd6g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 13:18:26 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 18:18:25 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 18:18:22 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2IHfDS35062158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 18:17:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53F0CA404D;
        Mon,  2 Dec 2019 18:18:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19BAEA4040;
        Mon,  2 Dec 2019 18:18:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 18:18:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 8/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-9-git-send-email-pmorel@linux.ibm.com>
 <20191202155510.410666a0.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 19:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202155510.410666a0.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120218-0028-0000-0000-000003C39236
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120218-0029-0000-0000-00002486A8E6
Message-Id: <00d5235b-eaaa-172c-6aa0-09e45be43635@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_04:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 15:55, Cornelia Huck wrote:
> On Thu, 28 Nov 2019 13:46:06 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> When a channel is enabled we can start a SENSE command using the SSCH
>> instruction to recognize the control unit and device.
>>
>> This tests the success of SSCH, the I/O interruption and the TSCH
>> instructions.
>>
>> The test expect a device with a control unit type of 0xC0CA.
> 
> s/expect/expects/

... :(

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h |  13 +++++
>>   s390x/css.c     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 150 insertions(+)
>>
> 
> (...)
> 
>> diff --git a/s390x/css.c b/s390x/css.c
>> index e42dc2f..534864f 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -11,12 +11,28 @@
>>    */
>>   
>>   #include <libcflat.h>
>> +#include <alloc_phys.h>
>> +#include <asm/page.h>
>> +#include <string.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/arch_def.h>
>> +#include <asm/clock.h>
>>   
>>   #include <css.h>
>>   
>>   #define SID_ONE		0x00010000
>> +#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
>> +
>> +struct lowcore *lowcore = (void *)0x0;
>>   
>>   static struct schib schib;
>> +#define NB_CCW  100
> 
> s/NB_CCW/NUM_CCWS/ ?
> 
> I was scratching my head a bit when I first saw that define.

French and english.... sorry
of course better, I change it

> 
>> +static struct ccw ccw[NB_CCW];
>> +#define NB_ORB  100
>> +static struct orb orb[NB_ORB];
>> +static struct irb irb;
>> +static char buffer[0x1000] __attribute__ ((aligned(8)));
>> +static struct senseid senseid;
>>   
>>   static const char *Channel_type[3] = {
>>   	"I/O", "CHSC", "MSG"
>> @@ -24,6 +40,34 @@ static const char *Channel_type[3] = {
>>   
>>   static int test_device_sid;
>>   
> 
> (...)
> 
>> +void handle_io_int(void)
>> +{
>> +	int ret = 0;
>> +	char *flags;
>> +
>> +	report_prefix_push("Interrupt");
>> +	if (lowcore->io_int_param != 0xcafec0ca) {
>> +		report("Bad io_int_param: %x", 0, lowcore->io_int_param);
>> +		report_prefix_pop();
>> +		return;
>> +	}
> 
> Should you accommodate unsolicited interrupts as well?

Yet, I do not expect unsolicited interrupt.
But should be at least kept in mind.

May be I add this for v3.

> 
>> +	report("io_int_param: %x", 1, lowcore->io_int_param);
>> +	report_prefix_pop();
>> +
>> +	ret = tsch(lowcore->subsys_id_word, &irb);
>> +	dump_irb(&irb);
>> +	flags = dump_scsw_flags(irb.scsw.ctrl);
>> +
>> +	if (ret)
>> +		report("IRB scsw flags: %s", 0, flags);
>> +	else
>> +		report("IRB scsw flags: %s", 1, flags);
>> +	report_prefix_pop();
>> +}
>> +
>> +static int start_subchannel(int code, char *data, int count)
>> +{
>> +	int ret;
>> +	struct pmcw *p = &schib.pmcw;
>> +	struct orb *orb_p = &orb[0];
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return 0;
>> +	}
>> +	ret = stsch(test_device_sid, &schib);
> 
> That schib is a global variable, isn't it? Why do you need to re-check?

In the principe the previous tests, storing the SHIB could have been 
disabled.

> 
>> +	if (ret) {
>> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
>> +		return 0;
>> +	}
>> +	if (!(p->flags & PMCW_ENABLE)) {
>> +		report_skip("Device (sid %08x) not enabled", test_device_sid);
>> +		return 0;
>> +	}
>> +	ccw[0].code = code ;
> 
> Extra ' ' before ';'

yes, thanks

> 
>> +	ccw[0].flags = CCW_F_PCI;
> 
> Huh, what's that PCI for? 

Program Control Interruption

I will add a comment :)

> 
>> +	ccw[0].count = count;
>> +	ccw[0].data = (int)(unsigned long)data;
> 
> Can you be sure that data is always below 2G?

Currently yes, the program is loaded at 0x10000 and is quite small
also doing a test does not hurt for the case the function is used in 
another test someday.

> 
>> +	orb_p->intparm = 0xcafec0ca;
>> +	orb_p->ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
>> +	orb_p->cpa = (unsigned int) (unsigned long)&ccw[0];
>> +
>> +	report_prefix_push("Start Subchannel");
>> +	ret = ssch(test_device_sid, orb_p);
>> +	if (ret) {
>> +		report("ssch cc=%d", 0, ret);
>> +		report_prefix_pop();
>> +		return 0;
>> +	}
>> +	report_prefix_pop();
>> +	return 1;
>> +}
>> +
>> +static void test_sense(void)
>> +{
>> +	int success;
>> +
>> +	enable_io_irq();
>> +
>> +	success = start_subchannel(CCW_CMD_SENSE_ID, buffer, sizeof(senseid));
>> +	if (!success) {
>> +		report("start_subchannel failed", 0);
>> +		return;
>> +	}
>> +
>> +	senseid.cu_type = buffer[2] | (buffer[1] << 8);
>> +	delay(1000);
>> +
>> +	/* Sense ID is non packed cut_type is at offset +1 byte */
>> +	if (senseid.cu_type == PONG_CU)
>> +		report("cu_type: expect c0ca, got %04x", 1, senseid.cu_type);
>> +	else
>> +		report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
>> +}
> 
> I'm not really convinced by that logic here. This will fall apart if
> you don't have your pong device exactly in the right place, and it does
> not make it easy to extend this for more devices in the future.

Wanted to keep things simple. PONG must be the first valid channel.
also, should be documented at least.

> 
> What about the following:
> - do a stsch() loop (basically re-use your first patch)
> - for each I/O subchannel with dnv=1, do SenseID
> - use the first (?) device with a c0ca CU type as your test device
> 
> Or maybe I'm overthinking this? It just does not strike me as very
> robust and reusable.

I can do it.

Thanks for the comments,

Best regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

