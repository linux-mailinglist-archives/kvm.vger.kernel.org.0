Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DAE27977C
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 09:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgIZHQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 03:16:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60412 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIZHQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Sep 2020 03:16:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q71prM173502;
        Sat, 26 Sep 2020 03:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EHOoB4YRKUENh+HWxkIaXw/x+fqoGpXBewLUWbWsNJA=;
 b=MaZr2RUDr7oCWks1nuB+b5p0bRWmAqVxiXcVxo2QzNmEWgzueM/5lAJ0FHOyUhJGdiCu
 KsJacRnkZu86NWJUlTa5AKsdGOK3+ebTG2H1N7Era77+4Wqxwn6vlwxpQ4lzrFghPbaV
 sl/IQu4oXKx0UuPXXUuR+L/JAyK8Wq7GLsRM9DdHkPSY3gYv8hvHVNOmtD1zTQRacSJC
 U5Nr65dPbqO+Lpt76D0TZ1PTCatv7I4/0IajpURsGZM7SrsNzueveR6us4XUlUmrmP3x
 DnZr0CiGRBeSki2eOEj+shy7QgfzbiIRwKTbejeMmm8YGshijZLvbV6N4d+3D28OhvJz tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t0f18p2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 03:16:17 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08Q71sQK173589;
        Sat, 26 Sep 2020 03:16:16 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t0f18p2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 03:16:16 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08Q7EoHs004771;
        Sat, 26 Sep 2020 07:16:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97r590-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 07:16:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08Q7GCGW23462344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 07:16:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8274C040;
        Sat, 26 Sep 2020 07:16:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73BA94C044;
        Sat, 26 Sep 2020 07:16:11 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.162.14])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 07:16:11 +0000 (GMT)
Date:   Sat, 26 Sep 2020 09:16:09 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [PATCH v10 07/16] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20200926091609.29565e87.pasic@linux.ibm.com>
In-Reply-To: <d2e623f3-65fa-e764-61ce-b7e8c35fd399@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-8-akrowiak@linux.ibm.com>
        <20200917163448.4db80db3.cohuck@redhat.com>
        <d2e623f3-65fa-e764-61ce-b7e8c35fd399@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_05:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Sep 2020 13:09:25 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 9/17/20 10:34 AM, Cornelia Huck wrote:
> > On Fri, 21 Aug 2020 15:56:07 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
> >> The matrix of adapters and domains configured in a guest's CRYCB may
> >> differ from the matrix of adapters and domains assigned to the matrix mdev,
> >> so this patch introduces a sysfs attribute to display the matrix of a guest
> >> using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
> >> guest using the matrix mdev can be displayed as follows:
> >>
> >>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> >>
> >> If a guest is not using the matrix mdev at the time the crycb is displayed,
> >> an error (ENODEV) will be returned.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
> >>   1 file changed, 58 insertions(+)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index efb229033f9e..30bf23734af6 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -1119,6 +1119,63 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
> >>   }
> >>   static DEVICE_ATTR_RO(matrix);
> >>   
> >> +static ssize_t guest_matrix_show(struct device *dev,
> >> +				 struct device_attribute *attr, char *buf)
> >> +{
> >> +	struct mdev_device *mdev = mdev_from_dev(dev);
> >> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >> +	char *bufpos = buf;
> >> +	unsigned long apid;
> >> +	unsigned long apqi;
> >> +	unsigned long apid1;
> >> +	unsigned long apqi1;
> >> +	unsigned long napm_bits = matrix_mdev->shadow_apcb.apm_max + 1;
> >> +	unsigned long naqm_bits = matrix_mdev->shadow_apcb.aqm_max + 1;
> >> +	int nchars = 0;
> >> +	int n;
> >> +
> >> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
> >> +		return -ENODEV;
> >> +
> >> +	apid1 = find_first_bit_inv(matrix_mdev->shadow_apcb.apm, napm_bits);
> >> +	apqi1 = find_first_bit_inv(matrix_mdev->shadow_apcb.aqm, naqm_bits);
> >> +
> >> +	mutex_lock(&matrix_dev->lock);
> >> +
> >> +	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
> >> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
> >> +				     napm_bits) {
> >> +			for_each_set_bit_inv(apqi,
> >> +					     matrix_mdev->shadow_apcb.aqm,
> >> +					     naqm_bits) {
> >> +				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
> >> +					    apqi);
> >> +				bufpos += n;
> >> +				nchars += n;
> >> +			}
> >> +		}
> >> +	} else if (apid1 < napm_bits) {
> >> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
> >> +				     napm_bits) {
> >> +			n = sprintf(bufpos, "%02lx.\n", apid);
> >> +			bufpos += n;
> >> +			nchars += n;
> >> +		}
> >> +	} else if (apqi1 < naqm_bits) {
> >> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
> >> +				     naqm_bits) {
> >> +			n = sprintf(bufpos, ".%04lx\n", apqi);
> >> +			bufpos += n;
> >> +			nchars += n;
> >> +		}
> >> +	}
> >> +
> >> +	mutex_unlock(&matrix_dev->lock);
> >> +
> >> +	return nchars;
> >> +}
> > This basically looks like a version of matrix_show() operating on the
> > shadow apcb. I'm wondering if we could consolidate these two functions
> > by passing in the structure to operate on as a parameter? Might not be
> > worth the effort, though.
> 
> We still need the two functions because they back the mdev's
> sysfs matrix and guest_matrix attributes, but we could call a function.
> I'm not sure it buys us much though.

The logic seems identical with the exception that the guest variant
checks if vfio_ap_mdev_has_crycb(matrix_mdev). I'm not a big fan of
duplicated code, and especially not in such close proximity. I'm voting
for factoring out the common logic.

Otherwise looks OK.

Regards,
Halil

