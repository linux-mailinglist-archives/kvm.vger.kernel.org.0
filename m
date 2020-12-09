Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127612D3C1A
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 08:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgLIHWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 02:22:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbgLIHWm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 02:22:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B971ruk017198;
        Wed, 9 Dec 2020 02:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rrRkWfMPfVX25Vub3LZ96UjgDS2pukBuUGwwnhw1X+Q=;
 b=NMnHeg+MVS5e6y1HUROGN6tKAuLP9FBUDr6oSsyhk/TpvZgbAnMew77ZBRnuhm0G50tm
 k41a/witVbemubyjq0/++4dKeANiuRIuQ3iHMUtKspjiFIo79ec9avtG15OXTfYFUMQd
 8B99E2HY7du+mOAja5JAo9DKq1Kr37l/NAI0H4DRDsMXLpQ0AkDcQfNKfDVnYqbhsnET
 97cNC1n9puuyxRb1GNyBfw4o17SwTHA+9ROsKpTlrEc0d0wgWhUETKwh+J92MPX+C9cd
 Rt1spbJxSSLSy7r8DgDAKq5rGm9WKVg3w3l1ritCLyG2P/5egQuS1xXVyLuYq5m1glFf 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35amch01kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 02:21:57 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B971vvN017620;
        Wed, 9 Dec 2020 02:21:57 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35amch01ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 02:21:57 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B97IYYp001029;
        Wed, 9 Dec 2020 07:21:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8pcvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 07:21:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B97Kb0x66912678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 07:20:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09E24204B;
        Wed,  9 Dec 2020 07:20:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CAC04203F;
        Wed,  9 Dec 2020 07:20:36 +0000 (GMT)
Received: from funtu.home (unknown [9.145.62.115])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 07:20:36 +0000 (GMT)
Subject: Re: [PATCH v12 14/17] s390/zcrypt: Notify driver on config changed
 and scan complete callbacks
To:     h@d06av26.portsmouth.uk.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-15-akrowiak@linux.ibm.com>
 <20201130101836.0399547c.pasic@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <e36c3f95-e015-3664-aa64-fc6b863d08a4@linux.ibm.com>
Date:   Wed, 9 Dec 2020 08:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201130101836.0399547c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_06:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.11.20 10:18, h@d06av26.portsmouth.uk.ibm.com wrote:
> On Tue, 24 Nov 2020 16:40:13 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch intruduces an extension to the ap bus to notify device drivers
>> when the host AP configuration changes - i.e., adapters, domains or
>> control domains are added or removed. To that end, two new callbacks are
>> introduced for AP device drivers:
>>
>>   void (*on_config_changed)(struct ap_config_info *new_config_info,
>>                             struct ap_config_info *old_config_info);
>>
>>      This callback is invoked at the start of the AP bus scan
>>      function when it determines that the host AP configuration information
>>      has changed since the previous scan. This is done by storing
>>      an old and current QCI info struct and comparing them. If there is any
>>      difference, the callback is invoked.
>>
>>      Note that when the AP bus scan detects that AP adapters, domains or
>>      control domains have been removed from the host's AP configuration, it
>>      will remove the associated devices from the AP bus subsystem's device
>>      model. This callback gives the device driver a chance to respond to
>>      the removal of the AP devices from the host configuration prior to
>>      calling the device driver's remove callback. The primary purpose of
>>      this callback is to allow the vfio_ap driver to do a bulk unplug of
>>      all affected adapters, domains and control domains from affected
>>      guests rather than unplugging them one at a time when the remove
>>      callback is invoked.
>>
>>   void (*on_scan_complete)(struct ap_config_info *new_config_info,
>>                            struct ap_config_info *old_config_info);
>>
>>      The on_scan_complete callback is invoked after the ap bus scan is
>>      complete if the host AP configuration data has changed.
>>
>>      Note that when the AP bus scan detects that adapters, domains or
>>      control domains have been added to the host's configuration, it will
>>      create new devices in the AP bus subsystem's device model. The primary
>>      purpose of this callback is to allow the vfio_ap driver to do a bulk
>>      plug of all affected adapters, domains and control domains into
>>      affected guests rather than plugging them one at a time when the
>>      probe callback is invoked.
>>
>> Please note that changes to the apmask and aqmask do not trigger
>> these two callbacks since the bus scan function is not invoked by changes
>> to those masks.
>>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/ap_bus.c          | 83 ++++++++++++++++++++++++++-
>>  drivers/s390/crypto/ap_bus.h          | 12 ++++
>>  drivers/s390/crypto/vfio_ap_private.h | 14 ++++-
>>  3 files changed, 106 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
>> index 593573740981..3a63f6b33d8a 100644
>> --- a/drivers/s390/crypto/ap_bus.c
>> +++ b/drivers/s390/crypto/ap_bus.c
>> @@ -75,6 +75,7 @@ DEFINE_MUTEX(ap_perms_mutex);
>>  EXPORT_SYMBOL(ap_perms_mutex);
>>  
>>  static struct ap_config_info *ap_qci_info;
>> +static struct ap_config_info *ap_qci_info_old;
>>  
>>  /*
>>   * AP bus related debug feature things.
>> @@ -1440,6 +1441,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
>>  		&& AP_QID_QUEUE(to_ap_queue(dev)->qid) == (int)(long) data;
>>  }
>>  
>> +/* Helper function for notify_config_changed */
>> +static int __drv_notify_config_changed(struct device_driver *drv, void *data)
>> +{
>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>> +
>> +	if (try_module_get(drv->owner)) {
>> +		if (ap_drv->on_config_changed)
>> +			ap_drv->on_config_changed(ap_qci_info,
>> +						  ap_qci_info_old);
>> +		module_put(drv->owner);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Notify all drivers about an qci config change */
>> +static inline void notify_config_changed(void)
>> +{
>> +	bus_for_each_drv(&ap_bus_type, NULL, NULL,
>> +			 __drv_notify_config_changed);
>> +}
>> +
>> +/* Helper function for notify_scan_complete */
>> +static int __drv_notify_scan_complete(struct device_driver *drv, void *data)
>> +{
>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>> +
>> +	if (try_module_get(drv->owner)) {
>> +		if (ap_drv->on_scan_complete)
>> +			ap_drv->on_scan_complete(ap_qci_info,
>> +						 ap_qci_info_old);
>> +		module_put(drv->owner);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Notify all drivers about bus scan complete */
>> +static inline void notify_scan_complete(void)
>> +{
>> +	bus_for_each_drv(&ap_bus_type, NULL, NULL,
>> +			 __drv_notify_scan_complete);
>> +}
>> +
>> +
>> +
>>  /*
>>   * Helper function for ap_scan_bus().
>>   * Remove card device and associated queue devices.
>> @@ -1718,15 +1765,43 @@ static inline void ap_scan_adapter(int ap)
>>  	put_device(&ac->ap_dev.device);
>>  }
>>  
>> +static int ap_get_configuration(void)
> I believe this was Haralds request. I'm OO contaminated, but
> the signature and the semantic does not mash well with my understanding
> of a 'getter'. Especially the return value being actually a boolean and
> 'configuration changed/still the same'. From the signature it looks more
> like the usual C-stlyle try to do something and return 0 if OK, otherwise
> error code != 0.
>
> Since it's Haralds dominion, I'm not asking you to change this, but we
> could at least document the return value (maybe also the behavior).
Well, no. This function comes from Tony. And you can see a mixture of
bool and int return values within the AP code. Historically there was no bool
and it was very long frowned upon using bool within the kernel.
However, long term I'd like to use bool for all these true/false functions and
so Tony if you need to touch this anyway you could change to bool here.

Tony, as you anyway need to rebase here - the ap code has significant changed in this corner -
should I pull these changes within the ap bus code from your patch series and push them
into the development branch after some adaptions to the current code ?
>
>> +{
>> +	int cfg_chg = 0;
>> +
>> +	if (ap_qci_info) {
>> +		if (!ap_qci_info_old) {
>> +			ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old),
>> +						  GFP_KERNEL);
>> +			if (!ap_qci_info_old)
>> +				return 0;
>> +		} else {
>> +			memcpy(ap_qci_info_old, ap_qci_info,
>> +			       sizeof(struct ap_config_info));
>> +		}
>> +		ap_fetch_qci_info(ap_qci_info);
>> +		cfg_chg = memcmp(ap_qci_info,
>> +				 ap_qci_info_old,
>> +				 sizeof(struct ap_config_info)) != 0;
>> +	}
>> +
>> +	return cfg_chg;
>> +}
>> +
>>  /**
>>   * ap_scan_bus(): Scan the AP bus for new devices
>>   * Runs periodically, workqueue timer (ap_config_time)
>>   */
>>  static void ap_scan_bus(struct work_struct *unused)
>>  {
>> -	int ap;
>> +	int ap, config_changed = 0;
>>  
>> -	ap_fetch_qci_info(ap_qci_info);
>> +	/* config change notify */
>> +	config_changed = ap_get_configuration();
>> +	if (config_changed)
>> +		notify_config_changed();
>> +	memcpy(ap_qci_info_old, ap_qci_info,
>> +	       sizeof(struct ap_config_info));
> Why is this memcpy needed? Isn't that already take care of in
> ap_get_configuration()?
>
>>  	ap_select_domain();
>>  
>>  	AP_DBF_DBG("%s running\n", __func__);
>> @@ -1735,6 +1810,10 @@ static void ap_scan_bus(struct work_struct *unused)
>>  	for (ap = 0; ap <= ap_max_adapter_id; ap++)
>>  		ap_scan_adapter(ap);
>>  
>> +	/* scan complete notify */
>> +	if (config_changed)
>> +		notify_scan_complete();
>> +
>>  	/* check if there is at least one queue available with default domain */
>>  	if (ap_domain_index >= 0) {
>>  		struct device *dev =
>> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
>> index 65edd847c65a..fbfbf6991718 100644
>> --- a/drivers/s390/crypto/ap_bus.h
>> +++ b/drivers/s390/crypto/ap_bus.h
>> @@ -146,6 +146,18 @@ struct ap_driver {
>>  	int (*probe)(struct ap_device *);
>>  	void (*remove)(struct ap_device *);
>>  	int (*in_use)(unsigned long *apm, unsigned long *aqm);
>> +	/*
>> +	 * Called at the start of the ap bus scan function when
>> +	 * the crypto config information (qci) has changed.
>> +	 */
>> +	void (*on_config_changed)(struct ap_config_info *new_config_info,
>> +				  struct ap_config_info *old_config_info);
>> +	/*
>> +	 * Called at the end of the ap bus scan function when
>> +	 * the crypto config information (qci) has changed.
>> +	 */
>> +	void (*on_scan_complete)(struct ap_config_info *new_config_info,
>> +				 struct ap_config_info *old_config_info);
>>  };
>>  
>>  #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 15b7cd74843b..7bd7e35eb2e0 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
> These changes probably belong to some next patch...
>
> With the things I just brought up clarified, you can slap a:
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> over it next time.
>
>> @@ -36,14 +36,21 @@
>>   *		driver, be it using @mdev_list or writing the state of a
>>   *		single ap_matrix_mdev device. It's quite coarse but we don't
>>   *		expect much contention.
>> + ** @ap_add:	a bitmap specifying the APIDs added to the host AP configuration
>> + *		as notified by the AP bus via the on_cfg_chg callback.
>> + * @aq_add:	a bitmap specifying the APQIs added to the host AP configuration
>> + *		as notified by the AP bus via the on_cfg_chg callback.
>>   */
>>  struct ap_matrix_dev {
>>  	struct device device;
>>  	atomic_t available_instances;
>> -	struct ap_config_info info;
>> +	struct ap_config_info config_info;
>> +	struct ap_config_info config_info_prev;
>>  	struct list_head mdev_list;
>>  	struct mutex lock;
>>  	struct ap_driver  *vfio_ap_drv;
>> +	DECLARE_BITMAP(ap_add, AP_DEVICES);
>> +	DECLARE_BITMAP(aq_add, AP_DEVICES);
>>  };
>>  
>>  extern struct ap_matrix_dev *matrix_dev;
>> @@ -90,6 +97,8 @@ struct ap_matrix_mdev {
>>  	struct kvm_s390_module_hook pqap_hook;
>>  	struct mdev_device *mdev;
>>  	DECLARE_HASHTABLE(qtable, 8);
>> +	DECLARE_BITMAP(ap_add, AP_DEVICES);
>> +	DECLARE_BITMAP(aq_add, AP_DEVICES);
>>  };
>>  
>>  extern int vfio_ap_mdev_register(void);
>> @@ -109,4 +118,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
>>  
>>  int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
>>  
>> +void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
>> +			    struct ap_config_info *old_config_info);
>> +
>>  #endif /* _VFIO_AP_PRIVATE_H_ */
