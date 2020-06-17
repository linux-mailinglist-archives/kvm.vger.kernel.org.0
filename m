Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAA1FCC34
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgFQLYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:24:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgFQLYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:24:22 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HB2GjD163363;
        Wed, 17 Jun 2020 07:24:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8nj0m4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:24:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HB2OHG164537;
        Wed, 17 Jun 2020 07:24:20 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8nj0m49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:24:20 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HBL6gJ029013;
        Wed, 17 Jun 2020 11:24:19 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 31q9v5y4tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:24:19 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBOIBR54657324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:24:18 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9503E112062;
        Wed, 17 Jun 2020 11:24:18 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13970112061;
        Wed, 17 Jun 2020 11:24:18 +0000 (GMT)
Received: from [9.65.206.193] (unknown [9.65.206.193])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:24:17 +0000 (GMT)
Subject: Re: [RFC PATCH v3 0/3] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200616195053.99253-1-farman@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Autocrypt: addr=farman@linux.ibm.com; keydata=
 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
Message-ID: <5ae6151b-31de-eca6-2917-4e23ecd4f0df@linux.ibm.com>
Date:   Wed, 17 Jun 2020 07:24:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616195053.99253-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/20 3:50 PM, Eric Farman wrote:
> Let's continue our discussion of the handling of vfio-ccw interrupts.
> 
> The initial fix [1] relied upon the interrupt path's examination of the
> FSM state, and freeing all resources if it were CP_PENDING. But the
> interface used by HALT/CLEAR SUBCHANNEL doesn't affect the FSM state.
> Consider this sequence:
> 
>     CPU 1                           CPU 2
>     CLEAR (state=IDLE/no change)
>                                     START [2]
>     INTERRUPT (set state=IDLE)
>                                     INTERRUPT (set state=IDLE)
> 
> This translates to a couple of possible scenarios:
> 
>  A) The START gets a cc2 because of the outstanding CLEAR, -EBUSY is
>     returned, resources are freed, and state remains IDLE
>  B) The START gets a cc0 because the CLEAR has already presented an
>     interrupt, and state is set to CP_PENDING
> 
> If the START gets a cc0 before the CLEAR INTERRUPT (stacked onto a
> workqueue by the IRQ context) gets a chance to run, then the INTERRUPT
> will release the channel program memory prematurely. If the two
> operations run concurrently, then the FSM state set to CP_PROCESSING
> will prevent the cp_free() from being invoked. But the io_mutex
> boundary on that path will pause itself until the START completes,
> and then allow the FSM to be reset to IDLE without considering the
> outstanding START. Neither scenario would be considered good.
> 
> Having said all of that, in v2 Conny suggested [3] the following:
> 
>> - Detach the cp from the subchannel (or better, remove the 1:1
>>   relationship). By that I mean building the cp as a separately
>>   allocated structure (maybe embedding a kref, but that might not be
>>   needed), and appending it to a list after SSCH with cc=0. Discard it
>>   if cc!=0.
>> - Remove the CP_PENDING state. The state is either IDLE after any
>>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
>>   special state for SSCH.
>> - A successful CSCH removes the first queued request, if any.
>> - A final interrupt removes the first queued request, if any.
> 
> What I have implemented here is basically this, with a few changes:
> 
>  - I don't queue cp's. Since there should only be one START in process
>    at a time, and HALT/CLEAR doesn't build a cp, I didn't see a pressing
>    need to introduce that complexity.
>  - Furthermore, while I initially made a separately allocated cp, adding
>    an alloc for a cp on each I/O AND moving the guest_cp alloc from the
>    probe path to the I/O path seems excessive. So I implemented a
>    "started" flag to the cp, set after a cc0 from the START, and examine
>    that on the interrupt path to determine whether cp_free() is needed.

FYI... After a day or two of running, I sprung a kernel debug oops for
list corruption in ccwchain_free(). I'm going to blame this piece, since
it was the last thing I changed and I hadn't come across any such damage
since v2. So either "started" is a bad idea, or a broken one. Or both. :)

>  - I opted against a "SOMETHING_PENDING" state if START/HALT/CLEAR
>    got a cc0, and just put the FSM back to IDLE. It becomes too unwieldy
>    to discern which operation an interrupt is completing, and whether
>    more interrupts are expected, to be worth the additional state.
>  - A successful CSCH doesn't do anything special, and cp_free()
>    is only performed on the interrupt path. Part of me wrestled with
>    how a HALT fits into that, but mostly it was that a cc0 on any
>    of the instructions indicated the "channel subsystem is signaled
>    to asynchronously perform the [START/HALT/CLEAR] function."
>    This means that an in-flight START could still receive data from the
>    device/subchannel, so not a good idea to release memory at that point.
> 
> Separate from all that, I added a small check of the io_work queue to
> the FSM START path. Part of the problems I've seen was that an interrupt
> is presented by a CPU, but not yet processed by vfio-ccw. Some of the
> problems seen thus far is because of this gap, and the above changes
> don't address that either. Whether this is appropriate or ridiculous
> would be a welcome discussion.
> 
> Previous versions:
> v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/
> 
> Footnotes:
> [1] https://lore.kernel.org/kvm/62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com/
> [2] Halil has pointed out that QEMU should prohibit this, based on the
>     rules set forth by the POPs. This is true, but we should not rely on
>     it behaving properly without addressing this scenario that is visible
>     today. Once I get this behaving correctly, I'll spend some time
>     seeing if QEMU is misbehaving somehow.
> [3] https://lore.kernel.org/kvm/20200518180903.7cb21dd8.cohuck@redhat.com/
> [4] https://lore.kernel.org/kvm/a52368d3-8cec-7b99-1587-25e055228b62@linux.ibm.com/
> 
> Eric Farman (3):
>   vfio-ccw: Indicate if a channel_program is started
>   vfio-ccw: Remove the CP_PENDING FSM state
>   vfio-ccw: Check workqueue before doing START
> 
>  drivers/s390/cio/vfio_ccw_cp.c      |  2 ++
>  drivers/s390/cio/vfio_ccw_cp.h      |  1 +
>  drivers/s390/cio/vfio_ccw_drv.c     |  5 +----
>  drivers/s390/cio/vfio_ccw_fsm.c     | 32 +++++++++++++++++------------
>  drivers/s390/cio/vfio_ccw_ops.c     |  3 +--
>  drivers/s390/cio/vfio_ccw_private.h |  1 -
>  6 files changed, 24 insertions(+), 20 deletions(-)
> 
