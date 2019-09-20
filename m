Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21C3B919D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 16:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfITOYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 10:24:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387915AbfITOY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 10:24:29 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KE8e4o014172;
        Fri, 20 Sep 2019 10:24:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v4yr0aajw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:24:23 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8KE9GZR016762;
        Fri, 20 Sep 2019 10:24:23 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v4yr0aajc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:24:23 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KEDbp5004074;
        Fri, 20 Sep 2019 14:24:22 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2v3vbua63b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 14:24:22 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KEOJdQ52756922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 14:24:19 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC6FEAE05F;
        Fri, 20 Sep 2019 14:24:19 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 550F1AE062;
        Fri, 20 Sep 2019 14:24:19 +0000 (GMT)
Received: from [9.85.205.180] (unknown [9.85.205.180])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 14:24:19 +0000 (GMT)
Subject: Re: [PATCH v6 04/10] s390: vfio-ap: filter CRYCB bits for unavailable
 queue devices
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com
References: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
 <1568410018-10833-5-git-send-email-akrowiak@linux.ibm.com>
 <20190919123434.28a29c00.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <3c81ae10-79fc-d845-571f-66cb84e1227a@linux.ibm.com>
Date:   Fri, 20 Sep 2019 10:24:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190919123434.28a29c00.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/19 6:34 AM, Halil Pasic wrote:
> On Fri, 13 Sep 2019 17:26:52 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> +static void vfio_ap_mdev_get_crycb_matrix(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	unsigned long apid, apqi;
>> +	unsigned long masksz = BITS_TO_LONGS(AP_DEVICES) *
>> +			       sizeof(unsigned long);
>> +
>> +	memset(matrix_mdev->crycb.apm, 0, masksz);
>> +	memset(matrix_mdev->crycb.apm, 0, masksz);
>> +	memcpy(matrix_mdev->crycb.adm, matrix_mdev->matrix.adm, masksz);
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>> +			     matrix_mdev->matrix.apm_max + 1) {
>> +		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>> +				     matrix_mdev->matrix.aqm_max + 1) {
>> +			if (vfio_ap_find_queue(AP_MKQID(apid, apqi))) {
>> +				if (!test_bit_inv(apid, matrix_mdev->crycb.apm))
>> +					set_bit_inv(apid,
>> +						    matrix_mdev->crycb.apm);
>> +				if (!test_bit_inv(apqi, matrix_mdev->crycb.aqm))
>> +					set_bit_inv(apqi,
>> +						    matrix_mdev->crycb.aqm);
>> +			}
>> +		}
>> +	}
>> +}
> 
> Even with the discussed typo fixed (zero crycb.aqm) this procedure does
> not make sense to me. :(
> 
> If in doubt please consider the following example:
> matrix_mdev->matrix.apm and matrix_mdev->matrix.aqm have both just bits
> 0 and 1 set (i.e. first byte 0xC0 the rest of the bytes 0x0). Queues
> bound to the vfio_ap driver (0,0), (0,1), (1,0); not bound to vfio_ap is
> however (1,1). If I read this correctly this filtering logic would grant
> access to (1,1) which seems to contradict with the stated intention.

Yep, I see your point. I'll have to rework this code.

> 
> Regards,
> Halil
> 
> 
> 

