Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7277848B940
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 22:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiAKVTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 16:19:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231816AbiAKVTN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 16:19:13 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLAvfE005189;
        Tue, 11 Jan 2022 21:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ITQpgMiLnUUt84qPXXH2345Fu6/EWn+F0DtKwqOJE5A=;
 b=KyWq6GOJE90M5a9AP4QAB5bFn3npnbFK1OJsRtSiWjyZxuCaQ3FkfKB8CagzC9YBakyh
 JNqj9334tT73pdfJHSH7J98FjxWnF283PmH8IDCJMXGb1KMU9rTsFxs9ciaLb7WbGcLZ
 pESPwNQ7x4iVgJC9EbyGZuvaONL1GUBS3FYCEWOIlChsltJeb7XCqmufpY4kl5puX2CR
 gs2XZC141AeaR23Szuc+nRlL26nD7hGQ7gD1ZLAbGPQ2+OCvhaf14nMJFZVFXj2cg2ur
 d2dqp5DfhPg49GbcRf6D3J4X5oyk5eTJN8oW6RCLYNROIHswVReEPbo27MYqA/r2ywJR pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhg2s209x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:19:11 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BLB219005535;
        Tue, 11 Jan 2022 21:19:11 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhg2s209a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:19:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BLIMjO016804;
        Tue, 11 Jan 2022 21:19:10 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 3df28antep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:19:09 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BLJ8Ux36897202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 21:19:08 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C81802805E;
        Tue, 11 Jan 2022 21:19:08 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8E5328059;
        Tue, 11 Jan 2022 21:19:07 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 21:19:07 +0000 (GMT)
Message-ID: <831f8897-b7cd-8240-c607-be3a106bad5c@linux.ibm.com>
Date:   Tue, 11 Jan 2022 16:19:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 06/15] s390/vfio-ap: refresh guest's APCB by filtering
 APQNs assigned to mdev
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-7-akrowiak@linux.ibm.com>
 <20211227095301.34a91ca4.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20211227095301.34a91ca4.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XyQynO93vYZmRHdWjWF7fPlNVSLkXXko
X-Proofpoint-GUID: 111EFETHyj4iE1GPfRLEvF9ZQEUXYlkN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/27/21 03:53, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:23 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
>> that do not reference an AP queue device bound to the vfio_ap device
>> driver. The mdev's APQNs will be filtered according to the following rules:
>>
>> * The APID of each adapter and the APQI of each domain that is not in the
>> host's AP configuration is filtered out.
>>
>> * The APID of each adapter comprising an APQN that does not reference a
>> queue device bound to the vfio_ap device driver is filtered. The APQNs
>> are derived from the Cartesian product of the APID of each adapter and
>> APQI of each domain assigned to the mdev.
>>
>> The control domains that are not assigned to the host's AP configuration
>> will also be filtered before assigning them to the guest's APCB.
> The v16 version used to filer on queue removal from vfio_ap, which makes
> a ton of sense.
>
> This version will "filter back" the queues once these become bound, but
> if a queue is removed form vfio_ap, we don't seem to care to filter. Is
> this intentional?

See patch the changes to the vfio_ap_mdev_remove_queue function in patch 
09/15,
s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device

Now that I look at that patch, I should probably rearrange this patch to 
also do
filtering on queue removal, but only do the hotplug stuff in patch 09.

>
> Also we could probably do the filtering incrementally. In a sense that
> at a time only so much changes, and we know that the invariant was
> preserved without that change. But that would probably end up trading
> complexity for cycles. I will trust your judgment and your tests on this
> matter.

I am not entirely clear on what you are suggesting. I think you are
suggesting that there may not be a need to look at every APQN
assigned to the mdev when an adapter or domain is assigned or
unassigned or a queue is probed or removed. Maybe you can clarify
what you are suggesting here.

>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 66 ++++++++++++++++++++++++++++++-
>>   1 file changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 4305177029bf..46c179363aca 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -314,6 +314,62 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
>> +		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
>> +}
>> +
>> +/*
>> + * vfio_ap_mdev_filter_matrix - copy the mdev's AP configuration to the KVM
>> + *				guest's APCB then filter the APIDs that do not
>> + *				comprise at least one APQN that references a
>> + *				queue device bound to the vfio_ap device driver.
>> + *
>> + * @matrix_mdev: the mdev whose AP configuration is to be filtered.
>> + */
>> +static void vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	int ret;
>> +	unsigned long apid, apqi, apqn;
>> +
>> +	ret = ap_qci(&matrix_dev->info);
>> +	if (ret)
>> +		return;
>> +
>> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>> +
>> +	/*
>> +	 * Copy the adapters, domains and control domains to the shadow_apcb
>> +	 * from the matrix mdev, but only those that are assigned to the host's
>> +	 * AP configuration.
>> +	 */
>> +	bitmap_and(matrix_mdev->shadow_apcb.apm, matrix_mdev->matrix.apm,
>> +		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
>> +	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
>> +		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
>> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
>> +				     AP_DOMAINS) {
>> +			/*
>> +			 * If the APQN is not bound to the vfio_ap device
>> +			 * driver, then we can't assign it to the guest's
>> +			 * AP configuration. The AP architecture won't
>> +			 * allow filtering of a single APQN, so if we're
>> +			 * filtering APIDs, then filter the APID; otherwise,
>> +			 * filter the APQI.
>> +			 */
>> +			apqn = AP_MKQID(apid, apqi);
>> +			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
>> +				clear_bit_inv(apid,
>> +					      matrix_mdev->shadow_apcb.apm);
>> +				break;
>> +			}
>> +		}
>> +	}
>> +}
>> +
>>   static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -703,6 +759,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   		goto share_err;
>>   
>>   	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
>> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>>   	ret = count;
>>   	goto done;
>>   
>> @@ -771,6 +828,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>   
>>   	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>>   	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
>> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>>   	ret = count;
>>   done:
>>   	mutex_unlock(&matrix_dev->lock);
>> @@ -874,6 +932,7 @@ static ssize_t assign_domain_store(struct device *dev,
>>   		goto share_err;
>>   
>>   	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
>> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>>   	ret = count;
>>   	goto done;
>>   
>> @@ -942,6 +1001,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>>   
>>   	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>>   	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
>> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>>   	ret = count;
>>   
>>   done:
>> @@ -995,6 +1055,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
>>   	 * number of control domains that can be assigned.
>>   	 */
>>   	set_bit_inv(id, matrix_mdev->matrix.adm);
>> +	vfio_ap_mdev_filter_cdoms(matrix_mdev);
>>   	ret = count;
>>   done:
>>   	mutex_unlock(&matrix_dev->lock);
>> @@ -1042,6 +1103,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>>   	}
>>   
>>   	clear_bit_inv(domid, matrix_mdev->matrix.adm);
>> +	clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
>>   	ret = count;
>>   done:
>>   	mutex_unlock(&matrix_dev->lock);
>> @@ -1179,8 +1241,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>   		kvm_get_kvm(kvm);
>>   		matrix_mdev->kvm = kvm;
>>   		kvm->arch.crypto.data = matrix_mdev;
>> -		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
>> -		       sizeof(struct ap_matrix));
>>   		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
>>   					  matrix_mdev->shadow_apcb.aqm,
>>   					  matrix_mdev->shadow_apcb.adm);
>> @@ -1536,6 +1596,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   	q->apqn = to_ap_queue(&apdev->device)->qid;
>>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>>   	vfio_ap_queue_link_mdev(q);
>> +	if (q->matrix_mdev)
>> +		vfio_ap_mdev_filter_matrix(q->matrix_mdev);
>>   	dev_set_drvdata(&apdev->device, q);
>>   	mutex_unlock(&matrix_dev->lock);
>>   

