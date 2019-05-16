Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E356E20AC6
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 17:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfEPPMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 11:12:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726796AbfEPPMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 11:12:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GF19cG087441
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 11:12:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sh8c9ebjn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 11:12:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 16 May 2019 16:11:59 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 16:11:56 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4GFBsmp38928462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 15:11:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD24542047;
        Thu, 16 May 2019 15:11:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59B6F42042;
        Thu, 16 May 2019 15:11:54 +0000 (GMT)
Received: from [9.152.222.58] (unknown [9.152.222.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 May 2019 15:11:54 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v1 1/2] vfio-ccw: Set subchannel state STANDBY on open
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
 <1557148270-19901-2-git-send-email-pmorel@linux.ibm.com>
 <3a55983d-c304-ec7e-f53d-8380576b9a42@linux.ibm.com>
 <20190508115203.5596e207.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 16 May 2019 17:11:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508115203.5596e207.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051615-4275-0000-0000-000003357BC9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051615-4276-0000-0000-00003845041E
Message-Id: <b5096a4f-e916-6046-5443-aa6724403057@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 11:52, Cornelia Huck wrote:
> On Tue, 7 May 2019 15:44:54 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> On 05/06/2019 09:11 AM, Pierre Morel wrote:
>>> When no guest is associated with the mediated device,
>>> i.e. the mediated device is not opened, the state of
>>> the mediated device is VFIO_CCW_STATE_NOT_OPER.
>>>
>>> The subchannel enablement and the according setting to the
>>> VFIO_CCW_STATE_STANDBY state should only be done when all
>>> parts of the VFIO mediated device have been initialized
>>> i.e. after the mediated device has been successfully opened.
>>>
>>> Let's stay in VFIO_CCW_STATE_NOT_OPER until the mediated
>>> device has been opened.
>>>
>>> When the mediated device is closed, disable the sub channel
>>> by calling vfio_ccw_sch_quiesce() no reset needs to be done
>>> the mediated devce will be enable on next open.
>>
>> s/devce/device
>>
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    drivers/s390/cio/vfio_ccw_drv.c | 10 +---------
>>>    drivers/s390/cio/vfio_ccw_ops.c | 36 ++++++++++++++++++------------------
>>>    2 files changed, 19 insertions(+), 27 deletions(-)
>>>
> (...)
>>> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
>>> index 5eb6111..497419c 100644
>>> --- a/drivers/s390/cio/vfio_ccw_ops.c
>>> +++ b/drivers/s390/cio/vfio_ccw_ops.c
>>> @@ -115,14 +115,10 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>>    	struct vfio_ccw_private *private =
>>>    		dev_get_drvdata(mdev_parent_dev(mdev));
>>>    
>>> -	if (private->state == VFIO_CCW_STATE_NOT_OPER)
>>> -		return -ENODEV;
>>> -
>>>    	if (atomic_dec_if_positive(&private->avail) < 0)
>>>    		return -EPERM;
>>>    
>>>    	private->mdev = mdev;
>>> -	private->state = VFIO_CCW_STATE_IDLE;
>>>    
>>>    	return 0;
>>>    }
>>> @@ -132,12 +128,7 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
>>>    	struct vfio_ccw_private *private =
>>>    		dev_get_drvdata(mdev_parent_dev(mdev));
>>>    
>>> -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
>>> -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
>>> -		if (!vfio_ccw_sch_quiesce(private->sch))
>>> -			private->state = VFIO_CCW_STATE_STANDBY;
>>> -		/* The state will be NOT_OPER on error. */
>>> -	}
>>> +	vfio_ccw_sch_quiesce(private->sch);
>>>    
>>>    	cp_free(&private->cp);
>>>    	private->mdev = NULL;
>>> @@ -151,6 +142,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
>>>    	struct vfio_ccw_private *private =
>>>    		dev_get_drvdata(mdev_parent_dev(mdev));
>>>    	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
>>> +	struct subchannel *sch = private->sch;
>>>    	int ret;
>>>    
>>>    	private->nb.notifier_call = vfio_ccw_mdev_notifier;
>>> @@ -165,6 +157,20 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
>>>    		vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>>>    					 &private->nb);
>>>    	return ret;
> 
> I think this "return ret;" needs to go into the if branch above it;
> otherwise, the code below won't be reached :)
> 
>>> +
>>> +	spin_lock_irq(private->sch->lock);
>>> +	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
>>> +		goto error;
>>> +
>>> +	private->state = VFIO_CCW_STATE_STANDBY;
>>
>> I don't think we should set the state to STANDBY here, because with just
>> this patch applied, any VFIO_CCW_EVENT_IO_REQ will return an error (due
>> to fsm_io_error).
>>
>> It might be safe to set it to IDLE in this patch.
> 
> Agreed, this should be IDLE; otherwise, I don't see how a device might
> move into IDLE state?
> 
> (That change happens in the next patch anyway.)
> 
>>
>>
>>> +	spin_unlock_irq(sch->lock);
>>> +	return 0;
>>> +
>>> +error:
>>> +	spin_unlock_irq(sch->lock);
>>> +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>>> +				 &private->nb);
>>> +	return -EFAULT;
>>>    }
>>>    
>>>    static void vfio_ccw_mdev_release(struct mdev_device *mdev)
>>> @@ -173,20 +179,14 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
>>>    		dev_get_drvdata(mdev_parent_dev(mdev));
>>>    	int i;
>>>    
>>> -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
>>> -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
>>> -		if (!vfio_ccw_mdev_reset(mdev))
>>> -			private->state = VFIO_CCW_STATE_STANDBY;
>>> -		/* The state will be NOT_OPER on error. */
>>> -	}
>>> -
>>> -	cp_free(&private->cp);
>>> +	vfio_ccw_sch_quiesce(private->sch);
>>>    	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>>>    				 &private->nb);
>>>    
>>>    	for (i = 0; i < private->num_regions; i++)
>>>    		private->region[i].ops->release(private, &private->region[i]);
>>>    
>>> +	cp_free(&private->cp);
> 
> I'm wondering why this cp_free is moved -- there should not be any
> activity related to it after quiesce, should there?

Yes there should.
I will let it where it was.



> 
>>>    	private->num_regions = 0;
>>>    	kfree(private->region);
>>>    	private->region = NULL;
>>>    
>>
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

