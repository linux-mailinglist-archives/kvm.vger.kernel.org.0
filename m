Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A68A86E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHLUeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 16:34:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbfHLUeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Aug 2019 16:34:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CKLkiS055620;
        Mon, 12 Aug 2019 16:34:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ubc76ey5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 16:34:18 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7CKNOPS060776;
        Mon, 12 Aug 2019 16:34:18 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ubc76ey5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 16:34:18 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7CKP6bO015414;
        Mon, 12 Aug 2019 20:34:17 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 2u9nj623te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 20:34:17 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CKYDHs60424604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 20:34:13 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8343913604F;
        Mon, 12 Aug 2019 20:34:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C3AA136053;
        Mon, 12 Aug 2019 20:34:11 +0000 (GMT)
Received: from [9.85.204.7] (unknown [9.85.204.7])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 20:34:11 +0000 (GMT)
Subject: Re: [PATCH v5 6/7] s390: vfio-ap: add logging to vfio_ap driver
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
 <1564612877-7598-7-git-send-email-akrowiak@linux.ibm.com>
 <20190812123517.059046b6.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <5b75a327-baac-7011-4a74-1174c7ba3ef6@linux.ibm.com>
Date:   Mon, 12 Aug 2019 16:34:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190812123517.059046b6.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120202
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/19 6:35 AM, Cornelia Huck wrote:
> On Wed, 31 Jul 2019 18:41:16 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> Added two DBF log files for logging events and errors; one for the vfio_ap
>> driver, and one for each matrix mediated device.
> 
> While the s390dbf is useful (especially for accessing the information
> in dumps), trace points are a more standard interface. Have you
> evaluated that as well? (We probably should add something to the
> vfio/mdev code as well; tracing there is a good complement to tracing
> in vendor drivers.)

I assume you are talking about the TRACE() macro here? I have not
evaluated that. I chose s390dbf for the sole reason that the
AP bus (drivers/s390/crypto/ap_bus.c) uses s390dbf. I can look into
using trace points. The genesis of this patch was in response to
comments you made in the previous series (v4). Recall that assignment
of an adapter or domain to a matrix mdev will fail if the APQN(s)
resulting from the assignment are either owned by zcrypt or another
matrix mdev. I said I'd provide a means for the admin to determine
why the assignment failed.

I will look into using trace points, but before I expend the effort
to make such a change, what would be the advantage of trace points
over s390dbf?

> 
> Also, isn't this independent of the rest of the series?

I guess that depends upon your definition of independent. Yes, this
patch could be posted as an entity unto itself, but then the rest of
the series would have to pre-req it given much of the logging is
done in code that has been modified by the series. Is there a
good reason to make this independent?

> 
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |  34 +++++++
>>   drivers/s390/crypto/vfio_ap_ops.c     | 187 ++++++++++++++++++++++++++++++----
>>   drivers/s390/crypto/vfio_ap_private.h |  20 ++++
>>   3 files changed, 223 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index d8da520ae1fa..04a77246c22a 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -22,6 +22,10 @@ MODULE_AUTHOR("IBM Corporation");
>>   MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
>>   MODULE_LICENSE("GPL v2");
>>   
>> +uint dbglvl = 3;
>> +module_param(dbglvl, uint, 0444);
>> +MODULE_PARM_DESC(dbglvl, "VFIO_AP driver debug level.");
> 
> More the default debug level, isn't it? (IIRC, you can change the level
> of the s390dbfs dynamically.)

The default debug level is 3. This allows the admin to change the debug
level at boot time so as not to miss trace events that might occur prior
to using the sysfs 'level' file to change the debug level.

For the record, I had a suggestion from Harald to change the name to
vfio_dbglvl or something of that nature to avoid namespace collisions.

> 
>> +
>>   static struct ap_driver vfio_ap_drv;
>>   
>>   struct ap_matrix_dev *matrix_dev;
>> @@ -158,6 +162,21 @@ static void vfio_ap_matrix_dev_destroy(void)
>>   	root_device_unregister(root_device);
>>   }
>>   
>> +static void vfio_ap_log_queues_in_use(struct ap_matrix_mdev *matrix_mdev,
>> +				  unsigned long *apm, unsigned long *aqm)
>> +{
>> +	unsigned long apid, apqi;
>> +
>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
>> +			VFIO_AP_DBF(matrix_dev, DBF_ERR,
>> +				    "queue %02lx.%04lx in use by mdev %s\n",
>> +				    apid, apqi,
>> +				    dev_name(mdev_dev(matrix_mdev->mdev)));
> 
> I remember some issues wrt %s in s390dbfs (lifetime); will this dbf
> potentially outlive the mdev? Or is the string copied? (Or has s390dbf
> been changed to avoid that trap? If so, please disregard my comments.)

If I understand your question, then this should not be a problem. The
lifespan of the mdev dbf files coincides with the lifespan of the mdev.
The dbf for the matrix mdev is registered when the mdev is created
and unregistered when the mdev is removed. Likewise, the vfio_ap dbf
is created when the module is initialized and unregistered when the
module is exited.

> 
>> +		}
>> +	}
>> +}
>> +
>>   static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>>   {
>>   	bool in_use = false;
>> @@ -179,6 +198,8 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>>   			continue;
>>   
>>   		in_use = true;
>> +		vfio_ap_log_queues_in_use(matrix_mdev, apm_intrsctn,
>> +					  aqm_intrsctn);
>>   	}
>>   
>>   	mutex_unlock(&matrix_dev->lock);
>> @@ -186,6 +207,16 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>>   	return in_use;
>>   }
>>   
>> +static int __init vfio_ap_debug_init(void)
>> +{
>> +	matrix_dev->dbf = debug_register(VFIO_AP_DRV_NAME, 1, 1,
>> +					 DBF_SPRINTF_MAX_ARGS * sizeof(long));
> 
> It seems that debug_register() can possibly fail? (Unlikely, but we
> should check.)

You are right! There should be a check for matrix_dev->dbf not NULL
like we do for the matrix mdev dbf in vfio_ap_mdev_debug_init();

> 
>> +	debug_register_view(matrix_dev->dbf, &debug_sprintf_view);
>> +	debug_set_level(matrix_dev->dbf, dbglvl);
>> +
>> +	return 0;
>> +}
>> +
>>   static int __init vfio_ap_init(void)
>>   {
>>   	int ret;
>> @@ -219,6 +250,8 @@ static int __init vfio_ap_init(void)
>>   		return ret;
>>   	}
>>   
>> +	vfio_ap_debug_init();
>> +
>>   	return 0;
>>   }
>>   
>> @@ -227,6 +260,7 @@ static void __exit vfio_ap_exit(void)
>>   	vfio_ap_mdev_unregister();
>>   	ap_driver_unregister(&vfio_ap_drv);
>>   	vfio_ap_matrix_dev_destroy();
>> +	debug_unregister(matrix_dev->dbf);
>>   }
>>   
>>   module_init(vfio_ap_init);
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 0e748819abb6..1aa18eba43d0 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -167,17 +167,23 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>>   		case AP_RESPONSE_INVALID_ADDRESS:
>>   		default:
>>   			/* All cases in default means AP not operational */
>> -			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
>> -				  status.response_code);
>>   			goto end_free;
>>   		}
>>   	} while (retries--);
>>   
>> -	WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
>> -		  status.response_code);
>>   end_free:
>>   	vfio_ap_free_aqic_resources(q);
>>   	q->matrix_mdev = NULL;
>> +	if (status.response_code) {
> 
> If I read the code correctly, we consider AP_RESPONSE_OTHERWISE_CHANGED
> a success as well, don't we? (Not sure what that means, though.)

It indicates that IRQ enable/disable has already been set as requested,
or a the async portion of a previous PQAP(AQIC) has not yet completed.
This just a warning, not an error.

> 
>> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
>> +			 "IRQ disable failed for queue %02x.%04x: status response code=%u\n",
>> +			 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>> +			 status.response_code);
>> +	} else {
>> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_INFO,
>> +				 "IRQ disabled for queue %02x.%04x\n",
>> +				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
>> +	}
>>   	return status;
>>   }
>>   
> 
> (...)
> 
>> @@ -321,8 +340,29 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static int vfio_ap_mdev_debug_init(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	int ret;
>> +
>> +	matrix_mdev->dbf = debug_register(dev_name(mdev_dev(matrix_mdev->mdev)),
>> +					  1, 1,
>> +					  DBF_SPRINTF_MAX_ARGS * sizeof(long));
>> +
>> +	if (!matrix_mdev->dbf)
>> +		return -ENOMEM;
> 
> Ok, here we do check for the result of debug_register().

Of course:)

> 
>> +
>> +	ret = debug_register_view(matrix_mdev->dbf, &debug_sprintf_view);
>> +	if (ret)
>> +		return ret;
> 
> Don't we need to clean up ->dbf in the failure case?

What's to clean up if it failed?

> 
> Also, we probably need to check this as well for the other dbf.

Yes.

> 
>> +
>> +	debug_set_level(matrix_mdev->dbf, dbglvl);
>> +
>> +	return 0;
>> +}
>> +
>>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   {
>> +	int ret;
>>   	struct ap_matrix_mdev *matrix_mdev;
>>   
>>   	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
>> @@ -335,6 +375,13 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   	}
>>   
>>   	matrix_mdev->mdev = mdev;
>> +
>> +	ret = vfio_ap_mdev_debug_init(matrix_mdev);
>> +	if (ret) {
>> +		kfree(matrix_mdev);
>> +		return ret;
> 
> You also should bump available_instances again in the failure case.

I agree and will fix this.

> 
>> +	}
>> +
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>> @@ -350,14 +397,19 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> -	if (matrix_mdev->kvm)
>> +	if (matrix_mdev->kvm) {
>> +		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
>> +				 "remove rejected, mdev in use by %s",
>> +				 matrix_mdev->kvm->debugfs_dentry->d_iname);
> 
> Can this be a problem when the kvm goes away (and the d_iname is gone)?
> 
> Regardless of s390dbf implementation details, is d_iname even valid in
> all cases (no debugfs)?

I don't know the answer to that. Can you point me to a way to get the
name of the guest?

> 
>>   		return -EBUSY;
>> +	}
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	vfio_ap_mdev_reset_queues(mdev);
>>   	list_del(&matrix_mdev->node);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>> +	debug_unregister(matrix_mdev->dbf);
>>   	kfree(matrix_mdev);
>>   	mdev_set_drvdata(mdev, NULL);
>>   	atomic_inc(&matrix_dev->available_instances);
>> @@ -406,6 +458,22 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>>   	NULL,
>>   };
>>   
>> +static void vfio_ap_mdev_log_sharing_error(struct ap_matrix_mdev *logdev,
>> +					   const char *assigned_to,
>> +					   unsigned long *apm,
>> +					   unsigned long *aqm)
>> +{
>> +	unsigned long apid, apqi;
>> +
>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
>> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
>> +					 "queue %02lx.%04lx already assigned to %s\n",
> 
> I'm also not 100% sure about string lifetimes here.

I don't understand your concern here, can you elaborate?

> 
>> +					 apid, apqi, assigned_to);
>> +		}
>> +	}
>> +}
>> +
>>   /**
>>    * vfio_ap_mdev_verify_no_sharing
>>    *
>> @@ -448,22 +516,39 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>>   		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
>>   			continue;
>>   
>> +		vfio_ap_mdev_log_sharing_error(matrix_mdev,
>> +					       dev_name(mdev_dev(lstdev->mdev)),
>> +					       apm, aqm);
>> +
>>   		return -EADDRINUSE;
>>   	}
>>   
>>   	return 0;
>>   }
>>   
>> -static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
>> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *logdev,
>>   				       unsigned long *apm, unsigned long *aqm)
>>   {
>> -	int ret;
>> +	int ret = 0;
>> +	unsigned long apid, apqi;
>> +
>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
>> +		for_each_set_bit_inv(apqi, aqm, AP_DEVICES) {
>> +			if (!ap_owned_by_def_drv(apid, apqi))
>> +				continue;
>> +
>> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
>> +					 "queue %02lx.%04lx owned by zcrypt\n",
> 
> s/zcrypt/default driver/ ?

I don't like default driver because IMHO default driver implies that if
no driver passes the bus match - which matches based on device type -
then it is bound to some default driver. How about:

s/zcrypt/default zcrypt driver/?

> 
>> +					 apid, apqi);
>> +
>> +			ret = -EADDRNOTAVAIL;
>> +		}
>> +	}
>>   
>> -	ret = ap_apqn_in_matrix_owned_by_def_drv(apm, aqm);
>>   	if (ret)
>> -		return (ret == 1) ? -EADDRNOTAVAIL : ret;
>> +		return ret;
>>   
>> -	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm, aqm);
>> +	return vfio_ap_mdev_verify_no_sharing(logdev, apm, aqm);
>>   }
>>   
>>   static void vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)
> 
> (...)
> 
>> @@ -1013,9 +1132,10 @@ static void vfio_ap_mdev_wait_for_qempty(ap_qid_t qid)
>>   			msleep(20);
>>   			break;
>>   		default:
>> -			pr_warn("%s: tapq response %02x waiting for queue %04x.%02x empty\n",
>> -				__func__, status.response_code,
>> -				AP_QID_CARD(qid), AP_QID_QUEUE(qid));
>> +			WARN_ONCE(1,
>> +				  "%s: tapq response %02x waiting for queue %04x.%02x empty\n",
>> +				  __func__, status.response_code,
>> +				  AP_QID_CARD(qid), AP_QID_QUEUE(qid));
> 
> Why this change?

Given the return following this, it is probably unnecessary. I'll
restore it.

> 
>>   			return;
>>   		}
>>   	} while (--retry);
> 
> (...)
> 
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 5cc3c2ebf151..f717e43e10cf 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -24,6 +24,21 @@
>>   #define VFIO_AP_MODULE_NAME "vfio_ap"
>>   #define VFIO_AP_DRV_NAME "vfio_ap"
>>   
>> +#define DBF_ERR		3	/* error conditions   */
>> +#define DBF_WARN	4	/* warning conditions */
>> +#define DBF_INFO	5	/* informational      */
>> +#define DBF_DEBUG	6	/* for debugging only */
> 
> Can you reuse the LOGLEVEL_* constants instead of rolling your own?

I assume you are talking about the log levels in linux/kern_levels.h?
Those levels range from -2 to 7. The dbf log levels range from 0 to 6.
It looks like most other drivers that use dbf hard code the levels.
I can do that if you prefer.

> 
>> +
>> +#define DBF_SPRINTF_MAX_ARGS 5
>> +
>> +#define VFIO_AP_DBF(d_matrix_dev, ...) \
>> +	debug_sprintf_event(d_matrix_dev->dbf, ##__VA_ARGS__)
>> +
>> +#define VFIO_AP_MDEV_DBF(d_matrix_mdev, ...) \
>> +	debug_sprintf_event(d_matrix_mdev->dbf, ##__VA_ARGS__)
>> +
>> +extern uint dbglvl;
>> +
>>   /**
>>    * ap_matrix_dev - the AP matrix device structure
>>    * @device:	generic device structure associated with the AP matrix device
>> @@ -43,6 +58,7 @@ struct ap_matrix_dev {
>>   	struct list_head mdev_list;
>>   	struct mutex lock;
>>   	struct ap_driver  *vfio_ap_drv;
>> +	debug_info_t *dbf;
>>   };
>>   
>>   extern struct ap_matrix_dev *matrix_dev;
>> @@ -77,6 +93,9 @@ struct ap_matrix {
>>    * @group_notifier: notifier block used for specifying callback function for
>>    *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>>    * @kvm:	the struct holding guest's state
>> + * @pqap_hook:	handler for PQAP instruction
>> + * @mdev:	the matrix mediated device
> 
> Should updating the description for these two go into a trivial
> separate patch?

I will if you insist, but what is gained by that?

> 
>> + * @dbf:	the debug info log
>>    */
>>   struct ap_matrix_mdev {
>>   	struct list_head node;
>> @@ -86,6 +105,7 @@ struct ap_matrix_mdev {
>>   	struct kvm *kvm;
>>   	struct kvm_s390_module_hook pqap_hook;
>>   	struct mdev_device *mdev;
>> +	debug_info_t *dbf;
>>   };
>>   
>>   extern int vfio_ap_mdev_register(void);
> 

