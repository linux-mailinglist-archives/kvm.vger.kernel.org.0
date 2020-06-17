Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7AC1FD95D
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 01:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFQXMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 19:12:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbgFQXMA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 19:12:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HN1wbh084333;
        Wed, 17 Jun 2020 19:12:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31qg6pg5uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 19:11:59 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HN29gH085267;
        Wed, 17 Jun 2020 19:11:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31qg6pg5tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 19:11:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HNAD0M007291;
        Wed, 17 Jun 2020 23:11:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 31qur601uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 23:11:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HNBsWN63111604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 23:11:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4252EAE053;
        Wed, 17 Jun 2020 23:11:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E689AAE04D;
        Wed, 17 Jun 2020 23:11:53 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.74.214])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 23:11:53 +0000 (GMT)
Date:   Thu, 18 Jun 2020 01:11:09 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/3] vfio-ccw: Indicate if a channel_program is
 started
Message-ID: <20200618011109.294a972d.pasic@linux.ibm.com>
In-Reply-To: <20200616195053.99253-2-farman@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
        <20200616195053.99253-2-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_12:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 clxscore=1015
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 cotscore=-2147483648 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006170168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 21:50:51 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The interrupt path checks the FSM state when processing a final interrupt
> (an interrupt that is neither subchannel active, nor device active),
> to determine whether to call cp_free() and release the associated memory.
> But, this does not fully close the window where a START comes in after a
> HALT/CLEAR. If the START runs while the CLEAR interrupt is being processed,
> the channel program struct will be allocated while the interrupt would be
> considering whether or not to free it. If the FSM state is CP_PROCESSING,
> then everything is fine. But if the START is able to issue its SSCH and get
> a cc0, then the in-flight interrupt would have been for an unrelated
> operation (perhaps none, if the subchannel was previously idle).
> 
> The channel_program struct has an "initialized" flag that is set early
> in the fsm_io_request() flow, to simplify the various cp_*() accessors.
> Let's extend this idea to include a "started" flag that announces that the
> channel program has successfully been issued to hardware. With this, the
> interrupt path can determine whether the final interrupt should also
> release the cp resources instead of relying on a transient FSM state.

AFAICT cp->started is potentially accessed by multiple threads, form
which at least one writes. Am I right?

Actually AFAICT you want to use cp->sarted for synchronization between
multiple treads (I/O requester(s), IRQ handler(s)). How does the
synchronization work for bool started itself, i.e. don't we have a data
race on 'started'?

A side note: I know, I asked a similar question about 'initialized' back
then.

Regards,
Halil

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c  |  2 ++
>  drivers/s390/cio/vfio_ccw_cp.h  |  1 +
>  drivers/s390/cio/vfio_ccw_drv.c |  2 +-
>  drivers/s390/cio/vfio_ccw_fsm.c | 11 +++++++++++
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index b9febc581b1f..7748eeef434e 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -657,6 +657,7 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  
>  	if (!ret) {
>  		cp->initialized = true;
> +		cp->started = false;
>  
>  		/* It is safe to force: if it was not set but idals used
>  		 * ccwchain_calc_length would have returned an error.
> @@ -685,6 +686,7 @@ void cp_free(struct channel_program *cp)
>  		return;
>  
>  	cp->initialized = false;
> +	cp->started = false;
>  	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++) {
>  			pfn_array_unpin_free(chain->ch_pa + i, cp->mdev);
> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
> index ba31240ce965..7ea14910aaaa 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.h
> +++ b/drivers/s390/cio/vfio_ccw_cp.h
> @@ -39,6 +39,7 @@ struct channel_program {
>  	union orb orb;
>  	struct device *mdev;
>  	bool initialized;
> +	bool started;
>  	struct ccw1 *guest_cp;
>  };
>  
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8c625b530035..7e2a790dc9a1 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -94,7 +94,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> +		if (is_final && private->cp.started)
>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 23e61aa638e4..d806f88eba72 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -50,6 +50,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>  		sch->schib.scsw.cmd.actl |= SCSW_ACTL_START_PEND;
>  		ret = 0;
>  		private->state = VFIO_CCW_STATE_CP_PENDING;
> +		private->cp.started = true;
>  		break;
>  	case 1:		/* Status pending */
>  	case 2:		/* Busy */
> @@ -246,6 +247,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>  	char *errstr = "request";
>  	struct subchannel_id schid = get_schid(private);
>  
> +	if (private->cp.started) {
> +		io_region->ret_code = -EBUSY;
> +		VFIO_CCW_MSG_EVENT(2,
> +				   "%pUl (%x.%x.%04x): busy\n",
> +				   mdev_uuid(mdev), schid.cssid,
> +				   schid.ssid, schid.sch_no);
> +		errstr = "busy";
> +		goto err_out;
> +	}
> +
>  	private->state = VFIO_CCW_STATE_CP_PROCESSING;
>  	memcpy(scsw, io_region->scsw_area, sizeof(*scsw));
>  

