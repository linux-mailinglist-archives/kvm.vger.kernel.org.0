Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C05630808E
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 22:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhA1Vaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 16:30:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229646AbhA1Vad (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 16:30:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SL1mKT013629;
        Thu, 28 Jan 2021 16:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jt1RnwdHY5DjF/gvqVcwznXvpJQjKVhf8Q3qnBluuUs=;
 b=ORcxMv7Unpe2E2ddTEezVN+yBm/SeFaX3qkPk+kOZiNNTck5IMt4trBTjO+7hPRsfvFp
 R7g7yMOs+r373Nezc5T5awsmXMmdjWCt6mgQftj/l85dtPlI7QcnXLqSV0oa2EPmdNxd
 bAawrK3KpKtkZgEWeSiDpA4tgSQD0hRBCz4fPvM7EtZWqPAGCCbgEdxtoVj32dhEKFHK
 JjrJn3MbvyDEm0c4JyWV17DkzkGOCWYlhrmyrZiKkKF+YPhcryD0Rzw2nuuccPfuUuZb
 x/uDVE+w3SlsSxcYAfHOS0LUsyBdQEqCkb0YM9pDFC4drTIbhtfhDs3+ntW6DcPGCWDf oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36c2fn4e7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 16:29:48 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10SL2Siw017019;
        Thu, 28 Jan 2021 16:29:47 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36c2fn4e7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 16:29:47 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SLGwUD007064;
        Thu, 28 Jan 2021 21:29:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 36ag3ykg0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 21:29:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SLTj5C9176008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 21:29:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82412AE05F;
        Thu, 28 Jan 2021 21:29:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B41A6AE05C;
        Thu, 28 Jan 2021 21:29:44 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 21:29:44 +0000 (GMT)
Subject: Re: [PATCH v13 08/15] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-9-akrowiak@linux.ibm.com>
 <20210111235806.5df42658.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6b526a2c-138c-55ad-d3f0-9c96558b255b@linux.ibm.com>
Date:   Thu, 28 Jan 2021 16:29:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210111235806.5df42658.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101280099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/21 5:58 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:15:59 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The matrix of adapters and domains configured in a guest's APCB may
>> differ from the matrix of adapters and domains assigned to the matrix mdev,
>> so this patch introduces a sysfs attribute to display the matrix of
>> adapters and domains that are or will be assigned to the APCB of a guest
>> that is or will be using the matrix mdev. For a matrix mdev denoted by
>> $uuid, the guest matrix can be displayed as follows:
>>
>>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>
> But because vfio_ap_mdev_commit_shadow_apcb() is not used (see prev
> patch) the attribute won't show the guest matrix at this point. :(

I'll move this patch following all of the filtering and hot plug
patches.

>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 51 ++++++++++++++++++++++---------
>>   1 file changed, 37 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 44b3a81cadfb..1b1d5975ee0e 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -894,29 +894,24 @@ static ssize_t control_domains_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR_RO(control_domains);
>>   
>> -static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>> -			   char *buf)
>> +static ssize_t vfio_ap_mdev_matrix_show(struct ap_matrix *matrix, char *buf)
>>   {
>> -	struct mdev_device *mdev = mdev_from_dev(dev);
>> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   	char *bufpos = buf;
>>   	unsigned long apid;
>>   	unsigned long apqi;
>>   	unsigned long apid1;
>>   	unsigned long apqi1;
>> -	unsigned long napm_bits = matrix_mdev->matrix.apm_max + 1;
>> -	unsigned long naqm_bits = matrix_mdev->matrix.aqm_max + 1;
>> +	unsigned long napm_bits = matrix->apm_max + 1;
>> +	unsigned long naqm_bits = matrix->aqm_max + 1;
>>   	int nchars = 0;
>>   	int n;
>>   
>> -	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
>> -	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
>> -
>> -	mutex_lock(&matrix_dev->lock);
>> +	apid1 = find_first_bit_inv(matrix->apm, napm_bits);
>> +	apqi1 = find_first_bit_inv(matrix->aqm, naqm_bits);
>>   
>>   	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
>> -		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
>> -			for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>> +		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
>> +			for_each_set_bit_inv(apqi, matrix->aqm,
>>   					     naqm_bits) {
>>   				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
>>   					    apqi);
>> @@ -925,25 +920,52 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>>   			}
>>   		}
>>   	} else if (apid1 < napm_bits) {
>> -		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
>> +		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
>>   			n = sprintf(bufpos, "%02lx.\n", apid);
>>   			bufpos += n;
>>   			nchars += n;
>>   		}
>>   	} else if (apqi1 < naqm_bits) {
>> -		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, naqm_bits) {
>> +		for_each_set_bit_inv(apqi, matrix->aqm, naqm_bits) {
>>   			n = sprintf(bufpos, ".%04lx\n", apqi);
>>   			bufpos += n;
>>   			nchars += n;
>>   		}
>>   	}
>>   
>> +	return nchars;
>> +}
>> +
>> +static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>> +			   char *buf)
>> +{
>> +	ssize_t nchars;
>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->matrix, buf);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return nchars;
>>   }
>>   static DEVICE_ATTR_RO(matrix);
>>   
>> +static ssize_t guest_matrix_show(struct device *dev,
>> +				 struct device_attribute *attr, char *buf)
>> +{
>> +	ssize_t nchars;
>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
>> +	mutex_unlock(&matrix_dev->lock);
>> +
>> +	return nchars;
>> +}
>> +static DEVICE_ATTR_RO(guest_matrix);
>> +
>>   static struct attribute *vfio_ap_mdev_attrs[] = {
>>   	&dev_attr_assign_adapter.attr,
>>   	&dev_attr_unassign_adapter.attr,
>> @@ -953,6 +975,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
>>   	&dev_attr_unassign_control_domain.attr,
>>   	&dev_attr_control_domains.attr,
>>   	&dev_attr_matrix.attr,
>> +	&dev_attr_guest_matrix.attr,
>>   	NULL,
>>   };
>>   

