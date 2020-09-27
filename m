Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBA8279D54
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 03:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgI0Bjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 21:39:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61510 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgI0Bjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Sep 2020 21:39:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08R1X5tg180683;
        Sat, 26 Sep 2020 21:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=r1Yr7FlV/1H5kBQVxYAxryn3ssZsA+gmf1D3o5vBIU8=;
 b=VgUH1+MJmz6r042s/OdlxwLXhEVEhSloxfXikQTzgKQmtCWMQ5wWDL2cGPbDdbZgoWW9
 omkzStYJaLZD7K3BXClVW/Jasa49AMm3w4Z1eiGJAyCXAJH1kZHPugcMVGVX1txFbe9y
 HtwfubF4OxT94UqHMpd05DjHChyj6yVEjAEb6SbhJF4wO7rmhZ7aMN9vNDNYXBG30ZZz
 GXZDQzvlPvih1Vshg7wAUMAi94ixig5wd85prdB60qvAZ1ZiN+9Wkl+EvM0t5brakbtX
 IReWTU+7t8uWCelDLp3DK4GhuePahX7zvfOhlcsVnb7qxQvpCppjzIHcDb9D/U/Z8UQF vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33tgh88qu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 21:39:51 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08R1Y7v3183423;
        Sat, 26 Sep 2020 21:39:51 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33tgh88qtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 21:39:50 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08R1cFgX018726;
        Sun, 27 Sep 2020 01:39:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 33sw980d8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Sep 2020 01:39:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08R1dkx319071472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 01:39:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1158D52052;
        Sun, 27 Sep 2020 01:39:46 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.162.14])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 21CC95204E;
        Sun, 27 Sep 2020 01:39:45 +0000 (GMT)
Date:   Sun, 27 Sep 2020 03:39:43 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 12/16] s390/zcrypt: Notify driver on config changed
 and scan complete callbacks
Message-ID: <20200927033943.28943540.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-13-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-13-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_22:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009270013
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:12 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch intruduces an extension to the ap bus to notify drivers
> on crypto config changed and bus scan complete events.
> Two new callbacks are introduced for ap_drivers:
> 
>   void (*on_config_changed)(struct ap_config_info *new_config_info,
>                              struct ap_config_info *old_config_info);
>   void (*on_scan_complete)(struct ap_config_info *new_config_info,
>                              struct ap_config_info *old_config_info);
> 
> Both callbacks are optional. Both callbacks are only triggered
> when QCI information is available (facility bit 12):
> 
> * The on_config_changed callback is invoked at the start of the AP bus scan
>   function when it determines that the host AP configuration information
>   has changed since the previous scan. This is done by storing
>   an old and current QCI info struct and comparing them. If there is any
>   difference, the callback is invoked.
> 
>   Note that when the AP bus scan detects that AP adapters or domains have
>   been removed from the host's AP configuration, it will remove the
>   associated devices from the AP bus subsystem's device model. This
>   callback gives the device driver a chance to respond to the removal
>   of the AP devices in bulk rather than one at a time as its remove
>   callback is invoked. It will also allow the device driver to do any
>   any cleanup prior to giving control back to the bus piecemeal. This is
>   particularly important for the vfio_ap driver because there may be
>   guests using the queues at the time.
> 
> * The on_scan_complete callback is invoked after the ap bus scan is
>   complete if the host AP configuration data has changed.
> 
>   Note that when the AP bus scan detects that adapters or domains have
>   been added to the host's configuration, it will create new devices in
>   the AP bus subsystem's device model. This callback also allows the driver
>   to process all of the new devices in bulk.
> 
> Please note that changes to the apmask and aqmask do not trigger
> these two callbacks since the bus scan function is not invoked by changes
> to those masks.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 85 +++++++++++++++++++++++++++++++++++-
>  drivers/s390/crypto/ap_bus.h | 12 +++++
>  2 files changed, 96 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index db27bd931308..cbf4c4d2e573 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -73,8 +73,10 @@ struct ap_perms ap_perms;
>  EXPORT_SYMBOL(ap_perms);
>  DEFINE_MUTEX(ap_perms_mutex);
>  EXPORT_SYMBOL(ap_perms_mutex);
> +DEFINE_MUTEX(ap_config_lock);
>  
>  static struct ap_config_info *ap_qci_info;
> +static struct ap_config_info *ap_qci_info_old;
>  
>  /*
>   * AP bus related debug feature things.
> @@ -1412,6 +1414,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
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

Too many blank lines?

>  /*
>   * Helper function for ap_scan_bus().
>   * Does the scan bus job for the given adapter id.
> @@ -1565,15 +1613,44 @@ static void _ap_scan_bus_adapter(int id)
>  		put_device(&ac->ap_dev.device);
>  }
>  
> +static int ap_config_changed(void)
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
> -	int id;
> +	int id, config_changed = 0;
>  
>  	ap_fetch_qci_info(ap_qci_info);

Do we still need this ap_fetch_qci_info()? ...

> +	mutex_lock(&ap_config_lock);

The usage of ap_qci_info does not seem to change substantially, and
ap_qci_info_old is not used unlike. I believe if we need ap_config_lock
now, then we used to need it before. And then adding this lock should
really be a separate patch than clearly advertises its fix nature.


> +
> +	/* config change notify */
> +	config_changed = ap_config_changed();

... I mean ap_config_changed() does a ap_fetch_qci_info()
of it's own.

Otherwise looks OK!

Regards,
Halil

> +	if (config_changed)
> +		notify_config_changed();
>  	ap_select_domain();
>  
>  	AP_DBF(DBF_DEBUG, "%s running\n", __func__);
> @@ -1582,6 +1659,12 @@ static void ap_scan_bus(struct work_struct *unused)
>  	for (id = 0; id < AP_DEVICES; id++)
>  		_ap_scan_bus_adapter(id);
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
> index 48c57b3d53a0..3fc743ac549c 100644
> --- a/drivers/s390/crypto/ap_bus.h
> +++ b/drivers/s390/crypto/ap_bus.h
> @@ -137,6 +137,18 @@ struct ap_driver {
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

