Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C03284F35
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJFPqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:46:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJFPqt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:46:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 096FWWot094821;
        Tue, 6 Oct 2020 11:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WKkpOGzuPGflvpRZ5ZiIIFCyVBjtTme5ACD7olhZ8yU=;
 b=imfH03GNTpWn6o4Fj2j8a66edfWijibJGKgyQCd5Qj6O4wFJsGZSFtSjyKRmMEmJTLe7
 s8mKl3mkhAUzC96avtuqIcFJUEwwDiEpB/2D6RE+u/uvHbsmcigRx75AjZ3RHz9l64gs
 D8mD9rbERTx16QFfwZ2pvHxg03Q3sl7+lsVfrvwu3cCHF9JEHSsIExFpTOj5N/jAri1g
 W2PDiXy0C1thfzCAjbSy8WVLPrwiZGO8ltjIGTwHc+euhTSXJQ2ddNN+x+kOOfdes26T
 O8gKT8oNQbjzOcdzvwF11wITlJl+xfUqYHIhly0BFr2I715pnu71sHFIglWm5sCE36XD 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340tqfhy2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 11:46:41 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 096FWwae097633;
        Tue, 6 Oct 2020 11:46:40 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340tqfhy11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 11:46:40 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 096FVWom009210;
        Tue, 6 Oct 2020 15:46:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 33xgx9ek98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 15:46:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 096FkcFM48496972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Oct 2020 15:46:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3821112065;
        Tue,  6 Oct 2020 15:46:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F646112063;
        Tue,  6 Oct 2020 15:46:36 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Oct 2020 15:46:36 +0000 (GMT)
Subject: Re: [PATCH v2 4/9] linux-headers: update against 5.9-rc7
To:     Cornelia Huck <cohuck@redhat.com>, yuval.shaia.ml@gmail.com,
        marcel.apfelbaum@gmail.com
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
 <1601669191-6731-5-git-send-email-mjrosato@linux.ibm.com>
 <20201006173944.611048c5.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <ff130c5d-558b-1c16-1f7b-34324126b473@linux.ibm.com>
Date:   Tue, 6 Oct 2020 11:46:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201006173944.611048c5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_06:2020-10-06,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/20 11:39 AM, Cornelia Huck wrote:
> On Fri,  2 Oct 2020 16:06:26 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> PLACEHOLDER as the kernel patch driving the need for this ("vfio-pci/zdev:
>> define the vfio_zdev header") isn't merged yet.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h         | 14 +++++++-------
>>   linux-headers/linux/kvm.h                                  |  6 ++++--
>>   linux-headers/linux/vfio.h                                 |  5 +++++
>>   3 files changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> index 7b4062a..acd4c83 100644
>> --- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> +++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> @@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
>>   
>>   static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>>   {
>> -	const unsigned int idx = qatomic_read(var);
>> +	const unsigned int idx = atomic_read(var);
> 
> Hm... either this shouldn't have been renamed to qatomic_read() in the
> first place, or we need to add some post-processing to the update
> script.
> 
Before I posted this set, I mentioned this in a reply to Stefan's 
atomic->qatomic patchset that introduced the change...  Paolo replied 
and said the code shouldn't be getting imported during header updates at 
all:

https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg00734.html

Copying the maintainers of the pvrdma stuff for their awareness in case 
they missed the first exchange.



