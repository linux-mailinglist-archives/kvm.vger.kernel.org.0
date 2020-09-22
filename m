Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E709C2743D2
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIVOGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:06:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgIVOGS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:06:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ME3ZtX090055;
        Tue, 22 Sep 2020 10:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BLWIvwPeufNrsK+EkVjlcC/z474nAfaph4hqeuuJTjg=;
 b=qr1HtbWX2Azt13/WO8ccFRIEbPqQAC9jsoRlg5RKK7/gOkwN2H4oXHNyMp6EemwGTGqZ
 XcrniNC7UHvbD/KCpsRsQVO86WSOu62ciDkNxkC47s2x7yTvxRIwY4jlvX6J8SPf7KEO
 c2UPA96H+4WWRpMEAF8w1W2wAxSOKfoY8B1xPD14Vik9+JqDaG33vCD7vByZZHQAcwnY
 etxmLGd1wMrXki1MvRmWAngE8OxtwAB193ShRyvCgKIhIx7+hOwegfQvC4sOxNVHJjm9
 iDuXWMDfAUOUAPVkesV12CHuSUpMb6mrDJEh6b69afa+oou4RYC8lP3YXBdjkYUDM1LV aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qj5uhcqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 10:06:17 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08ME5I7K097783;
        Tue, 22 Sep 2020 10:06:17 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qj5uhcpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 10:06:17 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08ME1faO018937;
        Tue, 22 Sep 2020 14:06:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 33n9m8yb6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 14:06:15 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08ME6CKF26608036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 14:06:12 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7932C605D;
        Tue, 22 Sep 2020 14:06:11 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B20BCC6057;
        Tue, 22 Sep 2020 14:06:10 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Sep 2020 14:06:10 +0000 (GMT)
Subject: Re: [PATCH 2/4] s390/pci: track whether util_str is valid in the
 zpci_dev
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-3-git-send-email-mjrosato@linux.ibm.com>
 <d1bc0e6b-2a9b-3de0-4dd6-59e26d6c1da4@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <5ef66994-e085-7d7d-141f-7a68e3915fe3@linux.ibm.com>
Date:   Tue, 22 Sep 2020 10:06:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d1bc0e6b-2a9b-3de0-4dd6-59e26d6c1da4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_13:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/20 5:41 AM, Niklas Schnelle wrote:
> Hi Matthew,
> 
> On 9/19/20 5:28 PM, Matthew Rosato wrote:
>> We'll need to keep track of whether or not the byte string in util_str is
>> valid and thus needs to be passed to a vfio-pci passthrough device.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h | 3 ++-
>>   arch/s390/pci/pci_clp.c     | 1 +
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 882e233..32eb975 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -132,7 +132,8 @@ struct zpci_dev {
>>   	u8		rid_available	: 1;
>>   	u8		has_hp_slot	: 1;
>>   	u8		is_physfn	: 1;
>> -	u8		reserved	: 5;
>> +	u8		util_avail	: 1;
> 
> Any reason you're not matching the util_str_avail name in the response struct? > I think this is currently always an EBCDIC encoded string so the 
information that
> even if it looks like binary for anyone with a non-mainframe background
> it is in fact a string seems quite helpful.

Frankly, the dropping of 'str_' was arbitrary on my part -- I'll go 
ahead and rename it to util_str_avail with v2.

> Other than that
> 
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 

Thanks!

>> +	u8		reserved	: 4;
>>   	unsigned int	devfn;		/* DEVFN part of the RID*/
>>   
>>   	struct mutex lock;
>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>> index 48bf316..d011134 100644
>> --- a/arch/s390/pci/pci_clp.c
>> +++ b/arch/s390/pci/pci_clp.c
>> @@ -168,6 +168,7 @@ static int clp_store_query_pci_fn(struct zpci_dev *zdev,
>>   	if (response->util_str_avail) {
>>   		memcpy(zdev->util_str, response->util_str,
>>   		       sizeof(zdev->util_str));
>> +		zdev->util_avail = 1;
>>   	}
>>   	zdev->mio_capable = response->mio_addr_avail;
>>   	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>>

