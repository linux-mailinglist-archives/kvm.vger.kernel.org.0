Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB311FF0F1
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgFRLr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 07:47:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62996 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgFRLrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 07:47:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IBWLUY179659;
        Thu, 18 Jun 2020 07:47:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31r6g1247x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 07:47:51 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05IBWOpd180004;
        Thu, 18 Jun 2020 07:47:51 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31r6g1247m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 07:47:51 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05IBeIs4009845;
        Thu, 18 Jun 2020 11:47:50 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 31q9v6famg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 11:47:50 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05IBlnvx38994324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 11:47:49 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 666F7AC05B;
        Thu, 18 Jun 2020 11:47:49 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0416AC059;
        Thu, 18 Jun 2020 11:47:48 +0000 (GMT)
Received: from [9.160.28.91] (unknown [9.160.28.91])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jun 2020 11:47:48 +0000 (GMT)
Subject: Re: [RFC PATCH v3 1/3] vfio-ccw: Indicate if a channel_program is
 started
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200616195053.99253-1-farman@linux.ibm.com>
 <20200616195053.99253-2-farman@linux.ibm.com>
 <20200618011109.294a972d.pasic@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Autocrypt: addr=farman@linux.ibm.com; keydata=
 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
Message-ID: <d859aa8d-186a-31b0-0770-2885de61b4bb@linux.ibm.com>
Date:   Thu, 18 Jun 2020 07:47:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618011109.294a972d.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_07:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=2 bulkscore=0 cotscore=-2147483648
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/17/20 7:11 PM, Halil Pasic wrote:
> On Tue, 16 Jun 2020 21:50:51 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> The interrupt path checks the FSM state when processing a final interrupt
>> (an interrupt that is neither subchannel active, nor device active),
>> to determine whether to call cp_free() and release the associated memory.
>> But, this does not fully close the window where a START comes in after a
>> HALT/CLEAR. If the START runs while the CLEAR interrupt is being processed,
>> the channel program struct will be allocated while the interrupt would be
>> considering whether or not to free it. If the FSM state is CP_PROCESSING,
>> then everything is fine. But if the START is able to issue its SSCH and get
>> a cc0, then the in-flight interrupt would have been for an unrelated
>> operation (perhaps none, if the subchannel was previously idle).
>>
>> The channel_program struct has an "initialized" flag that is set early
>> in the fsm_io_request() flow, to simplify the various cp_*() accessors.
>> Let's extend this idea to include a "started" flag that announces that the
>> channel program has successfully been issued to hardware. With this, the
>> interrupt path can determine whether the final interrupt should also
>> release the cp resources instead of relying on a transient FSM state.
> 
> AFAICT cp->started is potentially accessed by multiple threads, form
> which at least one writes. Am I right?

Yup. And with the exception of the cp_free() call out of the interrupt
path, every one is accessed under the io_mutex. I'm still measuring
possible behavior at that point.

> 
> Actually AFAICT you want to use cp->sarted for synchronization between
> multiple treads (I/O requester(s), IRQ handler(s)). How does the
> synchronization work for bool started itself, i.e. don't we have a data
> race on 'started'?
> 
> A side note: I know, I asked a similar question about 'initialized' back
> then.
> 
> Regards,
> Halil
> 
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/vfio_ccw_cp.c  |  2 ++
>>  drivers/s390/cio/vfio_ccw_cp.h  |  1 +
>>  drivers/s390/cio/vfio_ccw_drv.c |  2 +-
>>  drivers/s390/cio/vfio_ccw_fsm.c | 11 +++++++++++
>>  4 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index b9febc581b1f..7748eeef434e 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -657,6 +657,7 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>>  
>>  	if (!ret) {
>>  		cp->initialized = true;
>> +		cp->started = false;
>>  
>>  		/* It is safe to force: if it was not set but idals used
>>  		 * ccwchain_calc_length would have returned an error.
>> @@ -685,6 +686,7 @@ void cp_free(struct channel_program *cp)
>>  		return;
>>  
>>  	cp->initialized = false;
>> +	cp->started = false;
>>  	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
>>  		for (i = 0; i < chain->ch_len; i++) {
>>  			pfn_array_unpin_free(chain->ch_pa + i, cp->mdev);
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
>> index ba31240ce965..7ea14910aaaa 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.h
>> +++ b/drivers/s390/cio/vfio_ccw_cp.h
>> @@ -39,6 +39,7 @@ struct channel_program {
>>  	union orb orb;
>>  	struct device *mdev;
>>  	bool initialized;
>> +	bool started;
>>  	struct ccw1 *guest_cp;
>>  };
>>  
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 8c625b530035..7e2a790dc9a1 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -94,7 +94,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>  	if (scsw_is_solicited(&irb->scsw)) {
>>  		cp_update_scsw(&private->cp, &irb->scsw);
>> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>> +		if (is_final && private->cp.started)
>>  			cp_free(&private->cp);
>>  	}
>>  	mutex_lock(&private->io_mutex);
>> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
>> index 23e61aa638e4..d806f88eba72 100644
>> --- a/drivers/s390/cio/vfio_ccw_fsm.c
>> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
>> @@ -50,6 +50,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>>  		sch->schib.scsw.cmd.actl |= SCSW_ACTL_START_PEND;
>>  		ret = 0;
>>  		private->state = VFIO_CCW_STATE_CP_PENDING;
>> +		private->cp.started = true;
>>  		break;
>>  	case 1:		/* Status pending */
>>  	case 2:		/* Busy */
>> @@ -246,6 +247,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>>  	char *errstr = "request";
>>  	struct subchannel_id schid = get_schid(private);
>>  
>> +	if (private->cp.started) {
>> +		io_region->ret_code = -EBUSY;
>> +		VFIO_CCW_MSG_EVENT(2,
>> +				   "%pUl (%x.%x.%04x): busy\n",
>> +				   mdev_uuid(mdev), schid.cssid,
>> +				   schid.ssid, schid.sch_no);
>> +		errstr = "busy";
>> +		goto err_out;
>> +	}
>> +
>>  	private->state = VFIO_CCW_STATE_CP_PROCESSING;
>>  	memcpy(scsw, io_region->scsw_area, sizeof(*scsw));
>>  
> 
