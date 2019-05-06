Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3C1144A3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 08:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfEFGyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 02:54:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbfEFGyk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 02:54:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x466q7dp132457
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 02:54:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sabuwg5wx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 02:54:38 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 07:54:36 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 07:54:33 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x466sWZ160686528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 06:54:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0581652050;
        Mon,  6 May 2019 06:54:32 +0000 (GMT)
Received: from [9.145.46.119] (unknown [9.145.46.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 602115204F;
        Mon,  6 May 2019 06:54:31 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 3/7] s390: vfio-ap: sysfs interface to display guest
 CRYCB
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-4-git-send-email-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 6 May 2019 08:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556918073-13171-4-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050606-0008-0000-0000-000002E3B0CA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050606-0009-0000-0000-0000225027A3
Message-Id: <a2361365-050e-dfdd-ccd2-0167ccfcdfbf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 23:14, Tony Krowiak wrote:
> Introduces a sysfs interface on the matrix mdev device to display the
> contents of the shadow of the guest's CRYCB
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 59 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 44a04b4aa9ae..1021466cb661 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -771,6 +771,64 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>   }
>   static DEVICE_ATTR_RO(matrix);
>   
> +static ssize_t guest_matrix_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	char *bufpos = buf;
> +	unsigned long apid;
> +	unsigned long apqi;
> +	unsigned long apid1;
> +	unsigned long apqi1;
> +	unsigned long napm_bits;
> +	unsigned long naqm_bits;
> +	int nchars = 0;
> +	int n;
> +
> +	if (!matrix_mdev->shadow_crycb)
> +		return -ENODEV;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	napm_bits = matrix_mdev->shadow_crycb->apm_max + 1;
> +	naqm_bits = matrix_mdev->shadow_crycb->aqm_max + 1;
> +	apid1 = find_first_bit_inv(matrix_mdev->shadow_crycb->apm, napm_bits);
> +	apqi1 = find_first_bit_inv(matrix_mdev->shadow_crycb->aqm, naqm_bits);
> +
> +	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb->apm,
> +				     napm_bits) {
> +			for_each_set_bit_inv(apqi,
> +					     matrix_mdev->shadow_crycb->aqm,
> +					     naqm_bits) {
> +				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
> +					    apqi);
> +				bufpos += n;
> +				nchars += n;
> +			}
> +		}
> +	} else if (apid1 < napm_bits) {
> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb->apm,
> +				     napm_bits) {
> +			n = sprintf(bufpos, "%02lx.\n", apid);
> +			bufpos += n;
> +			nchars += n;
> +		}
> +	} else if (apqi1 < naqm_bits) {
> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_crycb->aqm,
> +				     naqm_bits) {
> +			n = sprintf(bufpos, ".%04lx\n", apqi);
> +			bufpos += n;
> +			nchars += n;
> +		}
> +	}
> +
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return nchars;
> +}
> +static DEVICE_ATTR_RO(guest_matrix);
> +
>   static struct attribute *vfio_ap_mdev_attrs[] = {
>   	&dev_attr_assign_adapter.attr,
>   	&dev_attr_unassign_adapter.attr,
> @@ -780,6 +838,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
>   	&dev_attr_unassign_control_domain.attr,
>   	&dev_attr_control_domains.attr,
>   	&dev_attr_matrix.attr,
> +	&dev_attr_guest_matrix.attr,
>   	NULL,
>   };
>   
> 

Code seems very similar to matrix_show, can't you share the code?





-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

