Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A078FB6EC0
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbfIRVWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 17:22:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727165AbfIRVWH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Sep 2019 17:22:07 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8ILKO4q042122;
        Wed, 18 Sep 2019 17:22:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v3vdn8115-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 17:22:05 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8ILLtlv044699;
        Wed, 18 Sep 2019 17:22:04 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v3vdn810u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 17:22:04 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8ILGseT001937;
        Wed, 18 Sep 2019 21:22:04 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 2v3vbtr0mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 21:22:04 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8ILM2sh36438356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 21:22:02 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05D33124058;
        Wed, 18 Sep 2019 21:22:02 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C93124054;
        Wed, 18 Sep 2019 21:22:01 +0000 (GMT)
Received: from [9.85.170.93] (unknown [9.85.170.93])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Sep 2019 21:22:01 +0000 (GMT)
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
 <20190918190433.713f4a93.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <be5bea2c-b849-ad94-b866-1ebf5467af70@linux.ibm.com>
Date:   Wed, 18 Sep 2019 17:22:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190918190433.713f4a93.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-18_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909180182
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/19 1:04 PM, Halil Pasic wrote:
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
> 
> I guess you wanted to zero out aqm here (and not apm again)!

Cut and paste without edit. I'll fix it.

> 
>> +	memcpy(matrix_mdev->crycb.adm, matrix_mdev->matrix.adm, masksz);
> 

