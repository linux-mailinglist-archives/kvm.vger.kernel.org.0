Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F002702EE
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIRRJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 13:09:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgIRRJg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 13:09:36 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IH2utj037663;
        Fri, 18 Sep 2020 13:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xrrgn91gXEZjAL29dM2nYrjXuyV5PTrrEQzwPa2zEQI=;
 b=A1CijVR2VyzWGxQEAz35wpP6aD16TkpOF9bY8ZZQVHrYquQApAtOhgNNMgFVZZS7z62C
 99HzsFUES8LwPXULFAVn+/FOjaDrX0PA1vV+/ih43KCiDGYKW4Qc+PDoe5vC6Iviyt5D
 biWgwnlr1LmqvrIMkGd54tbcEou6mb/nr3Xm/nu3V2wbA0FFUGw29l7Aim73cyzN6RaK
 vcuqI8FtxLbVRV0Ou9jlYAbHrBfu4suyzNfPO0uJX//8qF+5IYkfgxw1NFKWW5wIzmCQ
 cOF/Z76LsDy+XN7ELbyCpSKdWJFleJ6yVfCwIJUzGSQTMzlVQ6oDlI69dJ6LZWMq8Dbg Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33n0das5qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:09:32 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08IH30Tm037990;
        Fri, 18 Sep 2020 13:09:32 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33n0das5qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:09:32 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IH6exp012136;
        Fri, 18 Sep 2020 17:09:31 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 33k5v2cam8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 17:09:31 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IH9ONX53019068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 17:09:24 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E98A78060;
        Fri, 18 Sep 2020 17:09:28 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91DB67805C;
        Fri, 18 Sep 2020 17:09:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.128.188])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 17:09:26 +0000 (GMT)
Subject: Re: [PATCH v10 07/16] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-8-akrowiak@linux.ibm.com>
 <20200917163448.4db80db3.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d2e623f3-65fa-e764-61ce-b7e8c35fd399@linux.ibm.com>
Date:   Fri, 18 Sep 2020 13:09:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200917163448.4db80db3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_15:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/20 10:34 AM, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 15:56:07 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The matrix of adapters and domains configured in a guest's CRYCB may
>> differ from the matrix of adapters and domains assigned to the matrix mdev,
>> so this patch introduces a sysfs attribute to display the matrix of a guest
>> using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
>> guest using the matrix mdev can be displayed as follows:
>>
>>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
>>
>> If a guest is not using the matrix mdev at the time the crycb is displayed,
>> an error (ENODEV) will be returned.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
>>   1 file changed, 58 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index efb229033f9e..30bf23734af6 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1119,6 +1119,63 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>>   }
>>   static DEVICE_ATTR_RO(matrix);
>>   
>> +static ssize_t guest_matrix_show(struct device *dev,
>> +				 struct device_attribute *attr, char *buf)
>> +{
>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +	char *bufpos = buf;
>> +	unsigned long apid;
>> +	unsigned long apqi;
>> +	unsigned long apid1;
>> +	unsigned long apqi1;
>> +	unsigned long napm_bits = matrix_mdev->shadow_apcb.apm_max + 1;
>> +	unsigned long naqm_bits = matrix_mdev->shadow_apcb.aqm_max + 1;
>> +	int nchars = 0;
>> +	int n;
>> +
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>> +		return -ENODEV;
>> +
>> +	apid1 = find_first_bit_inv(matrix_mdev->shadow_apcb.apm, napm_bits);
>> +	apqi1 = find_first_bit_inv(matrix_mdev->shadow_apcb.aqm, naqm_bits);
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +
>> +	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
>> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
>> +				     napm_bits) {
>> +			for_each_set_bit_inv(apqi,
>> +					     matrix_mdev->shadow_apcb.aqm,
>> +					     naqm_bits) {
>> +				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
>> +					    apqi);
>> +				bufpos += n;
>> +				nchars += n;
>> +			}
>> +		}
>> +	} else if (apid1 < napm_bits) {
>> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
>> +				     napm_bits) {
>> +			n = sprintf(bufpos, "%02lx.\n", apid);
>> +			bufpos += n;
>> +			nchars += n;
>> +		}
>> +	} else if (apqi1 < naqm_bits) {
>> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
>> +				     naqm_bits) {
>> +			n = sprintf(bufpos, ".%04lx\n", apqi);
>> +			bufpos += n;
>> +			nchars += n;
>> +		}
>> +	}
>> +
>> +	mutex_unlock(&matrix_dev->lock);
>> +
>> +	return nchars;
>> +}
> This basically looks like a version of matrix_show() operating on the
> shadow apcb. I'm wondering if we could consolidate these two functions
> by passing in the structure to operate on as a parameter? Might not be
> worth the effort, though.

We still need the two functions because they back the mdev's
sysfs matrix and guest_matrix attributes, but we could call a function.
I'm not sure it buys us much though.

>

