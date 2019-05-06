Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6F154B5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 21:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfEFTzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 15:55:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726241AbfEFTzQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 15:55:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46Jm0G8126373;
        Mon, 6 May 2019 15:55:13 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2saudar5tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 May 2019 15:55:12 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x46DmK52003133;
        Mon, 6 May 2019 13:59:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 2s92c3vgtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 May 2019 13:59:18 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46Jt9Wh29753468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 19:55:09 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A42BAC060;
        Mon,  6 May 2019 19:55:09 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C944AC05B;
        Mon,  6 May 2019 19:55:09 +0000 (GMT)
Received: from [9.60.75.251] (unknown [9.60.75.251])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 19:55:09 +0000 (GMT)
Subject: Re: [PATCH v2 3/7] s390: vfio-ap: sysfs interface to display guest
 CRYCB
To:     pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-4-git-send-email-akrowiak@linux.ibm.com>
 <a2361365-050e-dfdd-ccd2-0167ccfcdfbf@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b0770195-c016-c661-4ca4-dabbffacf332@linux.ibm.com>
Date:   Mon, 6 May 2019 15:55:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a2361365-050e-dfdd-ccd2-0167ccfcdfbf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/19 2:54 AM, Pierre Morel wrote:
> On 03/05/2019 23:14, Tony Krowiak wrote:
>> Introduces a sysfs interface on the matrix mdev device to display the
>> contents of the shadow of the guest's CRYCB
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 59 
>> +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 59 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 44a04b4aa9ae..1021466cb661 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -771,6 +771,64 @@ static ssize_t matrix_show(struct device *dev, 
>> struct device_attribute *attr,
>>   }
>>   static DEVICE_ATTR_RO(matrix);
>> +static ssize_t guest_matrix_show(struct device *dev,
>> +                 struct device_attribute *attr, char *buf)
>> +{
>> +    struct mdev_device *mdev = mdev_from_dev(dev);
>> +    struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +    char *bufpos = buf;
>> +    unsigned long apid;
>> +    unsigned long apqi;
>> +    unsigned long apid1;
>> +    unsigned long apqi1;
>> +    unsigned long napm_bits;
>> +    unsigned long naqm_bits;
>> +    int nchars = 0;
>> +    int n;
>> +
>> +    if (!matrix_mdev->shadow_crycb)
>> +        return -ENODEV;
>> +
>> +    mutex_lock(&matrix_dev->lock);
>> +    napm_bits = matrix_mdev->shadow_crycb->apm_max + 1;
>> +    naqm_bits = matrix_mdev->shadow_crycb->aqm_max + 1;
>> +    apid1 = find_first_bit_inv(matrix_mdev->shadow_crycb->apm, 
>> napm_bits);
>> +    apqi1 = find_first_bit_inv(matrix_mdev->shadow_crycb->aqm, 
>> naqm_bits);
>> +
>> +    if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
>> +        for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb->apm,
>> +                     napm_bits) {
>> +            for_each_set_bit_inv(apqi,
>> +                         matrix_mdev->shadow_crycb->aqm,
>> +                         naqm_bits) {
>> +                n = sprintf(bufpos, "%02lx.%04lx\n", apid,
>> +                        apqi);
>> +                bufpos += n;
>> +                nchars += n;
>> +            }
>> +        }
>> +    } else if (apid1 < napm_bits) {
>> +        for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb->apm,
>> +                     napm_bits) {
>> +            n = sprintf(bufpos, "%02lx.\n", apid);
>> +            bufpos += n;
>> +            nchars += n;
>> +        }
>> +    } else if (apqi1 < naqm_bits) {
>> +        for_each_set_bit_inv(apqi, matrix_mdev->shadow_crycb->aqm,
>> +                     naqm_bits) {
>> +            n = sprintf(bufpos, ".%04lx\n", apqi);
>> +            bufpos += n;
>> +            nchars += n;
>> +        }
>> +    }
>> +
>> +    mutex_unlock(&matrix_dev->lock);
>> +
>> +    return nchars;
>> +}
>> +static DEVICE_ATTR_RO(guest_matrix);
>> +
>>   static struct attribute *vfio_ap_mdev_attrs[] = {
>>       &dev_attr_assign_adapter.attr,
>>       &dev_attr_unassign_adapter.attr,
>> @@ -780,6 +838,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
>>       &dev_attr_unassign_control_domain.attr,
>>       &dev_attr_control_domains.attr,
>>       &dev_attr_matrix.attr,
>> +    &dev_attr_guest_matrix.attr,
>>       NULL,
>>   };
>>
> 
> Code seems very similar to matrix_show, can't you share the code?

It is, I suppose I could write a function that both can call.

> 
> 
> 
> 
> 

