Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D564D9D25
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349044AbiCOOPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiCOOPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:15:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4693969F;
        Tue, 15 Mar 2022 07:14:01 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FCioGi010949;
        Tue, 15 Mar 2022 14:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=I2JuQw69rLIE7kBwkJ7s/EF353rQBCuLMnu9w8fyeRw=;
 b=fKdr7PDtN3dyppTuMt+LQkUVfrGKTo2hUQ46Zd7S31pcautckL1OWPElwkVbEn6Hfizw
 4XfvGb/sqGsvkddHM36LV/277hJd00fL3LhuGPKoqyn8ZJBJIwIz2CMnfmNnaqRUC2ff
 O4thYZ8B5YAO23FJUsafSRVBNRj2/mC0HimLISJxvvDUjc/eYmCKl0UBLzH2YNCXKj40
 0kmd0LuCjb2FbGZW8Jo63pqsSQHouq/4pgp1Sl43GXBm2N2V2PV/fq1wB9sk/uxyGzya
 +BKZWCakkDW1un4HzRrtaQ8XPWumYnpqO3bPdeDNkUcDc6iviVANCyebkRcPeECIBi7Y FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st29r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:13:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDtcWX017886;
        Tue, 15 Mar 2022 14:13:56 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st29g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:13:56 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE7vlx016712;
        Tue, 15 Mar 2022 14:13:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3erk59b5fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:13:55 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEDrVH32834012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:13:53 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5234E136059;
        Tue, 15 Mar 2022 14:13:53 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8382136055;
        Tue, 15 Mar 2022 14:13:51 +0000 (GMT)
Received: from [9.65.71.91] (unknown [9.65.71.91])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 14:13:51 +0000 (GMT)
Message-ID: <6083d83b-6867-2525-fdd8-baccde1a599f@linux.ibm.com>
Date:   Tue, 15 Mar 2022 10:13:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 12/18] s390/vfio-ap: reset queues after adapter/domain
 unassignment
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-13-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-13-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sLeAlYw04pAVXCBoN5geiJEdTqGmQQS3
X-Proofpoint-ORIG-GUID: Es-q2duvSwtNFNcQX_wjahEZqQ5rDups
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
> When an adapter or domain is unassigned from an mdev providing the AP
> configuration to a running KVM guest, one or more of the guest's queues may
> get dynamically removed. Since the removed queues could get re-assigned to
> another mdev, they need to be reset. So, when an adapter or domain is
> unassigned from the mdev, the queues that are removed from the guest's
> AP configuration will be reset.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
...
>   
> +static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
> +					unsigned long apid, unsigned long apqi,
> +					struct ap_queue_table *qtable)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
> +	/* If the queue is assigned to the matrix mdev, unlink it. */
> +	if (q)
> +		vfio_ap_unlink_queue_fr_mdev(q);
> +
> +	/* If the queue is assigned to the APCB, store it in @qtable. */
> +	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> +	    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
> +		hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
> +}
> +
> +/**
> + * vfio_ap_mdev_unlink_adapter - unlink all queues associated with unassigned
> + *				 adapter from the matrix mdev to which the
> + *				 adapter was assigned.
> + * @matrix_mdev: the matrix mediated device to which the adapter was assigned.
> + * @apid: the APID of the unassigned adapter.
> + * @qtable: table for storing queues associated with unassigned adapter.
> + */
>   static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
> -					unsigned long apid)
> +					unsigned long apid,
> +					struct ap_queue_table *qtable)
>   {
>   	unsigned long apqi;
> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
> +		vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
> +}

Here is an alternate version of the above two functions that stops the
profileration of the qtables variable into vfio_ap_unlink_apqn_fr_mdev.
It may seem like a change with no benefit, but it simplifies things a
bit and avoids the reader from having to sink three functions deep to
find out where qtables is used. This is 100% untested.


static bool vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
					unsigned long apid, unsigned long apqi)
{
	struct vfio_ap_queue *q;

	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
	/* If the queue is assigned to the matrix mdev, unlink it. */
	if (q) {
		vfio_ap_unlink_queue_fr_mdev(q);
		return true;
	}
	return false;
}

static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
					unsigned long apid,
					struct ap_queue_table *qtable)
{
	unsigned long apqi;
	bool unlinked;

	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
		unlinked = vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);

		if (unlinked && qtable) {
			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
				hash_add(qtable->queues, &q->mdev_qnode,
					 q->apqn);
		}
	}
}


> +static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev *matrix_mdev,
> +					    unsigned long apid)
> +{
> +	int bkt;
>   	struct vfio_ap_queue *q;
> +	struct ap_queue_table qtable;
> +	hash_init(qtable.queues);
> +	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid, &qtable);
> +
> +	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
> +		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> +		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
> +	}
>   
> -	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
> -		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
> +	vfio_ap_mdev_reset_queues(&qtable);
>   
> -		if (q)
> -			vfio_ap_mdev_unlink_queue(q);
> +	hash_for_each(qtable.queues, bkt, q, mdev_qnode) {

This comment applies to all instances of btk: What is btk? Can we come
up with a more descriptive name?

> +		vfio_ap_unlink_mdev_fr_queue(q);
> +		hash_del(&q->mdev_qnode);
>   	}
>   }
...
> @@ -1273,9 +1320,9 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
>   		mutex_lock(&kvm->lock);
>   		mutex_lock(&matrix_dev->mdevs_lock);
>   
> -		kvm_arch_crypto_clear_masks(kvm);
> -		vfio_ap_mdev_reset_queues(matrix_mdev);
> -		kvm_put_kvm(kvm);
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
> +		kvm_put_kvm(matrix_mdev->kvm);
>   		matrix_mdev->kvm = NULL;

I understand changing the call to vfio_ap_mdev_reset_queues, but why are we changing the
kvm pointer on the surrounding lines?

>   
>   		mutex_unlock(&matrix_dev->mdevs_lock);
> @@ -1328,14 +1375,17 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
>   
>   	if (!q)
>   		return 0;
> +	q->reset_rc = 0;

This line seems unnecessary. You set q->reset_rc in every single case below, so this 0
will always get overwritten.

>   retry_zapq:
>   	status = ap_zapq(q->apqn);
>   	switch (status.response_code) {
>   	case AP_RESPONSE_NORMAL:
>   		ret = 0;
> +		q->reset_rc = status.response_code;
>   		break;
>   	case AP_RESPONSE_RESET_IN_PROGRESS:
> +		q->reset_rc = status.response_code;
>   		if (retry--) {
>   			msleep(20);
>   			goto retry_zapq;
> @@ -1345,13 +1395,20 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
>   	case AP_RESPONSE_Q_NOT_AVAIL:
>   	case AP_RESPONSE_DECONFIGURED:
>   	case AP_RESPONSE_CHECKSTOPPED:
> -		WARN_ON_ONCE(status.irq_enabled);
> +		WARN_ONCE(status.irq_enabled,
> +			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
> +			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> +			  status.response_code);
> +		q->reset_rc = status.response_code;
>   		ret = -EBUSY;
>   		goto free_resources;
>   	default:
>   		/* things are really broken, give up */
> -		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
> +		WARN(true,
> +		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
> +		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>   		     status.response_code);
> +		q->reset_rc = status.response_code;
>   		return -EIO;
>   	}
...

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
