Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA429C207
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819282AbgJ0R3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:29:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56858 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1813555AbgJ0R3J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 13:29:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RH32KN089417;
        Tue, 27 Oct 2020 13:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A8vltgMzDMVKywTjvwlC1Xdu1O2yd4axe54PJpEzWSE=;
 b=eKqvVqSab2i7L1AoNOVpeZihGkVMnKe32XvVtvM6qcVALcR4L9n3uSCxQLjtGLo7fUjy
 n9d3SxbATY2xa4ZZr1cKGwzNUkRATt/e0yr2w1U6eT6UB44NeMUmU4S4dSiTymbdR+MB
 Rii9IjOBKB0Bi1S3wV37l2mrYYobGlxGhyoUrKMtzryjARQE+2eMqeNdTOx5/E9+aBtV
 9e08jIbEFuv4POKMqXZ8lH2xj2WcaHB/PnIODJwRyNYJ2VzyQNFgvw3CbSyBbyw9VyEJ
 xH4B1KNnuqKJTueKwZ0pQMKlOXG9uoe+bLpx363RkxSkOZ01ZaJsBsaGSnBCwMUkEtlM aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6n558-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 13:29:00 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09RH3iBb092704;
        Tue, 27 Oct 2020 13:28:58 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6n54e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 13:28:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RHHICr011794;
        Tue, 27 Oct 2020 17:28:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 34cbw89uuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 17:28:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RHSrgj34669036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 17:28:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 354274203F;
        Tue, 27 Oct 2020 17:28:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FDBD42045;
        Tue, 27 Oct 2020 17:28:52 +0000 (GMT)
Received: from funtu.home (unknown [9.171.1.97])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 17:28:52 +0000 (GMT)
Subject: Re: [PATCH v11 11/14] s390/zcrypt: Notify driver on config changed
 and scan complete callbacks
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-12-akrowiak@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <8b3c6a0a-2411-96a8-11a3-d9bf36d42c82@linux.ibm.com>
Date:   Tue, 27 Oct 2020 18:28:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201022171209.19494-12-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_10:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.20 19:12, Tony Krowiak wrote:
> This patch intruduces an extension to the ap bus to notify device drivers
> when the host AP configuration changes - i.e., adapters, domains or
> control domains are added or removed. To that end, two new callbacks are
> introduced for AP device drivers:
>
>   void (*on_config_changed)(struct ap_config_info *new_config_info,
>                             struct ap_config_info *old_config_info);
>
>      This callback is invoked at the start of the AP bus scan
>      function when it determines that the host AP configuration information
>      has changed since the previous scan. This is done by storing
>      an old and current QCI info struct and comparing them. If there is any
>      difference, the callback is invoked.
>
>      Note that when the AP bus scan detects that AP adapters, domains or
>      control domains have been removed from the host's AP configuration, it
>      will remove the associated devices from the AP bus subsystem's device
>      model. This callback gives the device driver a chance to respond to
>      the removal of the AP devices from the host configuration prior to
>      calling the device driver's remove callback. The primary purpose of
>      this callback is to allow the vfio_ap driver to do a bulk unplug of
>      all affected adapters, domains and control domains from affected
>      guests rather than unplugging them one at a time when the remove
>      callback is invoked.
>
>   void (*on_scan_complete)(struct ap_config_info *new_config_info,
>                            struct ap_config_info *old_config_info);
>
>      The on_scan_complete callback is invoked after the ap bus scan is
>      complete if the host AP configuration data has changed.
>
>      Note that when the AP bus scan detects that adapters, domains or
>      control domains have been added to the host's configuration, it will
>      create new devices in the AP bus subsystem's device model. The primary
>      purpose of this callback is to allow the vfio_ap driver to do a bulk
>      plug of all affected adapters, domains and control domains into
>      affected guests rather than plugging them one at a time when the
>      probe callback is invoked.
>
> Please note that changes to the apmask and aqmask do not trigger
> these two callbacks since the bus scan function is not invoked by changes
> to those masks.
>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Did I really sign-off this ? I know, I saw this code but ...
First of all, please separate the ap bus changes from the vfio_ap driver changes.
This makes backports and code change history much easier.
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c          | 88 ++++++++++++++++++++++++++-
>  drivers/s390/crypto/ap_bus.h          | 12 ++++
>  drivers/s390/crypto/vfio_ap_drv.c     |  2 +-
>  drivers/s390/crypto/vfio_ap_ops.c     | 11 ++--
>  drivers/s390/crypto/vfio_ap_private.h |  2 +-
>  5 files changed, 106 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index 998e61cd86d9..5b94956ef6bc 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -73,8 +73,10 @@ struct ap_perms ap_perms;
>  EXPORT_SYMBOL(ap_perms);
>  DEFINE_MUTEX(ap_perms_mutex);
>  EXPORT_SYMBOL(ap_perms_mutex);
> +DEFINE_MUTEX(ap_config_lock);
This mutes is unnecessary, but see details below.
>  
>  static struct ap_config_info *ap_qci_info;
> +static struct ap_config_info *ap_qci_info_old;
>  
>  /*
>   * AP bus related debug feature things.
> @@ -1420,6 +1422,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
>  		&& AP_QID_QUEUE(to_ap_queue(dev)->qid) == (int)(long) data;
>  }
>  
> +/* Helper function for notify_config_changed */
> +static int __drv_notify_config_changed(struct device_driver *drv, void *data)
> +{
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +
> +	if (try_module_get(drv->owner)) {
> +		if (ap_drv->on_config_changed)
> +			ap_drv->on_config_changed(ap_qci_info,
> +						  ap_qci_info_old);
> +		module_put(drv->owner);
> +	}
> +
> +	return 0;
> +}
> +
> +/* Notify all drivers about an qci config change */
> +static inline void notify_config_changed(void)
> +{
> +	bus_for_each_drv(&ap_bus_type, NULL, NULL,
> +			 __drv_notify_config_changed);
> +}
> +
> +/* Helper function for notify_scan_complete */
> +static int __drv_notify_scan_complete(struct device_driver *drv, void *data)
> +{
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +
> +	if (try_module_get(drv->owner)) {
> +		if (ap_drv->on_scan_complete)
> +			ap_drv->on_scan_complete(ap_qci_info,
> +						 ap_qci_info_old);
> +		module_put(drv->owner);
> +	}
> +
> +	return 0;
> +}
> +
> +/* Notify all drivers about bus scan complete */
> +static inline void notify_scan_complete(void)
> +{
> +	bus_for_each_drv(&ap_bus_type, NULL, NULL,
> +			 __drv_notify_scan_complete);
> +}
> +
> +
> +
>  /*
>   * Helper function for ap_scan_bus().
>   * Remove card device and associated queue devices.
> @@ -1696,15 +1744,45 @@ static inline void ap_scan_adapter(int ap)
>  	put_device(&ac->ap_dev.device);
>  }
>  
> +static int ap_config_changed(void)
I don't like the name here. This function is effectively fetching the qci info
and then comparing the new with the prev. qci info. So it is the new
ap_get_configuration() which returns bool true (config changed) or
false (old and current config are the very same).
> +{
> +	int cfg_chg = 0;
> +
> +	if (ap_qci_info) {
> +		if (!ap_qci_info_old) {
> +			ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old),
> +						  GFP_KERNEL);
> +			if (!ap_qci_info_old)
> +				return 0;
> +		} else {
> +			memcpy(ap_qci_info_old, ap_qci_info,
> +			       sizeof(struct ap_config_info));
> +		}
> +		ap_fetch_qci_info(ap_qci_info);
> +		cfg_chg = memcmp(ap_qci_info,
> +				 ap_qci_info_old,
> +				 sizeof(struct ap_config_info)) != 0;
> +	}
> +
> +	return cfg_chg;
> +}
> +
>  /**
>   * ap_scan_bus(): Scan the AP bus for new devices
>   * Runs periodically, workqueue timer (ap_config_time)
>   */
>  static void ap_scan_bus(struct work_struct *unused)
>  {
> -	int ap;
> +	int ap, config_changed = 0;
> +
> +	mutex_lock(&ap_config_lock);
This mutex is more or less surrrounding the ap_scan_bus function.
The ap_scan_bus function is only called via a workqueue which is
making sure there is only one invocation at a point in time. So it
is not needed.
>  
> -	ap_fetch_qci_info(ap_qci_info);
> +	/* config change notify */
> +	config_changed = ap_config_changed();
> +	if (config_changed)
> +		notify_config_changed();
> +	memcpy(ap_qci_info_old, ap_qci_info,
> +	       sizeof(struct ap_config_info));
>  	ap_select_domain();
>  
>  	AP_DBF_DBG("%s running\n", __func__);
> @@ -1713,6 +1791,12 @@ static void ap_scan_bus(struct work_struct *unused)
>  	for (ap = 0; ap <= ap_max_adapter_id; ap++)
>  		ap_scan_adapter(ap);
>  
> +	/* scan complete notify */
> +	if (config_changed)
> +		notify_scan_complete();
> +
> +	mutex_unlock(&ap_config_lock);
> +
>  	/* check if there is at least one queue available with default domain */
>  	if (ap_domain_index >= 0) {
>  		struct device *dev =
> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
> index 6ce154d924d3..c021ea5121a9 100644
> --- a/drivers/s390/crypto/ap_bus.h
> +++ b/drivers/s390/crypto/ap_bus.h
> @@ -146,6 +146,18 @@ struct ap_driver {
>  	int (*probe)(struct ap_device *);
>  	void (*remove)(struct ap_device *);
>  	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
> +	/*
> +	 * Called at the start of the ap bus scan function when
> +	 * the crypto config information (qci) has changed.
> +	 */
> +	void (*on_config_changed)(struct ap_config_info *new_config_info,
> +				  struct ap_config_info *old_config_info);
> +	/*
> +	 * Called at the end of the ap bus scan function when
> +	 * the crypto config information (qci) has changed.
> +	 */
> +	void (*on_scan_complete)(struct ap_config_info *new_config_info,
> +				 struct ap_config_info *old_config_info);
>  };
>  
>  #define to_ap_drv(x) container_of((x), struct ap_driver, driver)

Rest of this patch is vfio related and should be in a separate patch.

Please note: The ap bus scan function does actively destroy card and associated queue
devices when the TAPQ invocation tells that the function bits have changed (e.g. from
EP11 mode to CCA mode) or the type has changed (e.g. from CEX6 to CEX7).
This does not come with an change in the qci apm or adm bitfields !

> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 8934471b7944..f06e19754de3 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -87,7 +87,7 @@ static int vfio_ap_matrix_dev_create(void)
>  
>  	/* Fill in config info via PQAP(QCI), if available */
>  	if (test_facility(12)) {
> -		ret = ap_qci(&matrix_dev->info);
> +		ret = ap_qci(&matrix_dev->config_info);
>  		if (ret)
>  			goto matrix_alloc_err;
>  	}
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index dae1fba41941..c4ea80ec8599 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -354,8 +354,9 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  	}
>  
>  	matrix_mdev->mdev = mdev;
> -	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
> -	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
> +	vfio_ap_matrix_init(&matrix_dev->config_info, &matrix_mdev->matrix);
> +	vfio_ap_matrix_init(&matrix_dev->config_info,
> +			    &matrix_mdev->shadow_apcb);
>  	hash_init(matrix_mdev->qtable);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
> @@ -540,8 +541,8 @@ static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev,
>  		 * If the APID is not assigned to the host AP configuration,
>  		 * we can not assign it to the guest's AP configuration
>  		 */
> -		if (!test_bit_inv(apid,
> -				  (unsigned long *)matrix_dev->info.apm)) {
> +		if (!test_bit_inv(apid, (unsigned long *)
> +				  matrix_dev->config_info.apm)) {
>  			clear_bit_inv(apid, shadow_apcb.apm);
>  			continue;
>  		}
> @@ -554,7 +555,7 @@ static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev,
>  			 * guest's AP configuration
>  			 */
>  			if (!test_bit_inv(apqi, (unsigned long *)
> -					  matrix_dev->info.aqm)) {
> +					  matrix_dev->config_info.aqm)) {
>  				clear_bit_inv(apqi, shadow_apcb.aqm);
>  				continue;
>  			}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index fc8634cee485..5065f0367ea2 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -40,7 +40,7 @@
>  struct ap_matrix_dev {
>  	struct device device;
>  	atomic_t available_instances;
> -	struct ap_config_info info;
> +	struct ap_config_info config_info;
>  	struct list_head mdev_list;
>  	struct mutex lock;
>  	struct ap_driver  *vfio_ap_drv;
