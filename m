Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046BF261B7A
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgIHTDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:03:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731693AbgIHTDn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 15:03:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088J1xN1122829;
        Tue, 8 Sep 2020 15:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=daDdFQSQ8/ewgAVsdSWJ/UnpLBSx0HFoixMRKkOERnE=;
 b=Lb6o73OH4N2tzK/ZCJBNoskGrdgjK49+0X/DtRgUpz3mhH8/0LFzQWu8B6PsBh2eWdWs
 7lcQbrvxSIrdUnstD5MmiTGwYY5AMkwNZG2AHqyhhH5gHEKnIOgXDCZMEpwl/qqCGvEW
 I01yG/lA7PGhcUuyy9KNJpxZ/mvHRDHMqC5LRPO1KcOMymxJDop8a40fkWU3CX6mBjTq
 /32m1IeKzeTm+UicxyVJ5xLnnlmUsqi9qTZJ0W1C4lWTTcDqJyh9mWzkDpbSGZKTOdJl
 5ZvHIjsAcFc1uclFl4Pa9pAQ1pkHw3oCJCs9hFgRxNqORSuYjiYi4rSEiBMx9WgxxWFU wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33edwdkvt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 15:03:30 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088J2HE7125254;
        Tue, 8 Sep 2020 15:03:30 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33edwdkvsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 15:03:29 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088IpV9K023585;
        Tue, 8 Sep 2020 19:03:28 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 33c2a91hvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 19:03:28 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088J3RJE12059580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 19:03:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07A05B206A;
        Tue,  8 Sep 2020 19:03:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FA59B2065;
        Tue,  8 Sep 2020 19:03:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.141.115])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 19:03:26 +0000 (GMT)
Subject: Re: [PATCH v10 03/16] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-4-akrowiak@linux.ibm.com>
 <99581cee-65fd-a622-ddc9-1a30e4638668@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <64ca7c98-4798-35c4-307e-57c4ca4cfdb2@linux.ibm.com>
Date:   Tue, 8 Sep 2020 15:03:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <99581cee-65fd-a622-ddc9-1a30e4638668@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/4/20 4:15 AM, Christian Borntraeger wrote:
> On 21.08.20 21:56, Tony Krowiak wrote:
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index a2aa05bec718..57da703b549a 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -87,6 +87,7 @@ struct ap_matrix_mdev {
>>   	struct kvm *kvm;
>>   	struct kvm_s390_module_hook pqap_hook;
>>   	struct mdev_device *mdev;
>> +	DECLARE_HASHTABLE(qtable, 8);
>>   };
> Ah I think the include should go into this patch. But then you should revisit the patch description
> of 2 as it talks about hashtables (but doesnt do anything about it).

Got it.

>   

