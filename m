Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51DD27D05C
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 16:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbgI2OAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 10:00:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4408 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728867AbgI2OAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 10:00:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TDXEk6012810;
        Tue, 29 Sep 2020 10:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KurX2Tj63i/99Pxz+3bnSVJmPd/cjS5Oqc++vVhCztw=;
 b=I429lhf6O8/1lpZRHHpoEXXn4ty9LLqGsxwiPwQ9zmZCDsqK9OwAJgX1plNpGpaQLSs8
 WqrOsc4rtPYnnBm2g7SnAB3AgLqAlcv/cJomCWh8qip8fUZ4wm2hZVcxkTagArz6hkbc
 vdveH7djk5/3PZZYm5umopIhlwC33bENwcmYxgmxM197/rUnT1RFj6EjmsloTL38x/JJ
 BNP+ZxjLa849VMHwfbQZyEUtkoLYWjeiuMIj7tLwgIFBRtv2XXJpzWNuv2hATEA6rWts
 k3E4FFlhC8FTC2/EYhGdGcMvq4CtujESEJFvEkkHkCHwAQ6B53t5nwS6LAonp870wbCY RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v4ybujva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 10:00:15 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TDXF1g012903;
        Tue, 29 Sep 2020 10:00:14 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v4ybujtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 10:00:14 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TDvxZ1014673;
        Tue, 29 Sep 2020 14:00:13 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 33sw98vkp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 14:00:13 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TE0Ati59834800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 14:00:10 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3A9B136079;
        Tue, 29 Sep 2020 14:00:03 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1115913605D;
        Tue, 29 Sep 2020 14:00:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 14:00:01 +0000 (GMT)
Subject: Re: [PATCH v10 05/16] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-6-akrowiak@linux.ibm.com>
 <20200925112941.71589591.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b6810e67-1e50-d62c-8c9e-57429e8a239f@linux.ibm.com>
Date:   Tue, 29 Sep 2020 10:00:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200925112941.71589591.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=879 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/25/20 5:29 AM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:05 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> +
>> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>> +{
>> +	bool in_use;
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
>> +	mutex_unlock(&matrix_dev->lock);
> See also my comment for patch 4. AFAIU as soon as you release the lock
> the in_use may become outdated in any moment.

See my response to your comment for patch 4.

>
>> +
>> +	return in_use;
>> +}

