Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52C71FCD1C
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgFQMKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 08:10:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgFQMKc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 08:10:32 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HC4fqi186186;
        Wed, 17 Jun 2020 08:10:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j0mku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 08:10:29 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HC54ao188491;
        Wed, 17 Jun 2020 08:10:29 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j0mkth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 08:10:29 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HC9ln5021568;
        Wed, 17 Jun 2020 12:10:27 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 31q8kkjpk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 12:10:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HCANuh32702894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 12:10:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AABA78072;
        Wed, 17 Jun 2020 12:10:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FBB7805C;
        Wed, 17 Jun 2020 12:10:24 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.146.208])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 12:10:23 +0000 (GMT)
Subject: Re: [PATCH v8 03/16] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
 <20200605214004.14270-4-akrowiak@linux.ibm.com>
 <6ae77590-8401-a06b-eec5-713319c21017@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <f87a4326-ffd7-18b8-e128-2a583421cb1d@linux.ibm.com>
Date:   Wed, 17 Jun 2020 08:10:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6ae77590-8401-a06b-eec5-713319c21017@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 cotscore=-2147483648
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 suspectscore=3 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006170091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/20 1:50 PM, Christian Borntraeger wrote:
>
> On 05.06.20 23:39, Tony Krowiak wrote:
> [...]
>> +static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
>> +				     enum qlink_type type,
>> +				     unsigned long qlink_id)
>> +{
>> +	unsigned long id;
>> +	struct vfio_ap_queue *q;
>> +
>> +	switch (type) {
>> +	case LINK_APID:
>> +	case UNLINK_APID:
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
>> +				     matrix_mdev->matrix.aqm_max + 1) {
>> +			q = vfio_ap_get_queue(AP_MKQID(qlink_id, id));
>> +			if (q) {
>> +				if (type == LINK_APID)
>> +					q->matrix_mdev = matrix_mdev;
>> +				else
>> +					q->matrix_mdev = NULL;> +			}
>> +		}
>> +		break;
>> +	default:
> Can you rather use
> 	case LINK_APQI:
> 	case UNLINK_APQI:
>
> and add a default case with a WARN_ON_ONCE?

Yes I can.

>
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
>> +				     matrix_mdev->matrix.apm_max + 1) {
>> +			q = vfio_ap_get_queue(AP_MKQID(id, qlink_id));
>> +			if (q) {
>> +				if (type == LINK_APQI)
>> +					q->matrix_mdev = matrix_mdev;
>> +				else
>> +					q->matrix_mdev = NULL;
>> +			}
>> +		}
>> +		break;
>> +	}
>> +}
>> +

