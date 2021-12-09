Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1130F46F2FF
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbhLIS3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:29:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243257AbhLIS27 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 13:28:59 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Hr2WC000803;
        Thu, 9 Dec 2021 18:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SAc0Qfllc+Nmif1HmHhxRysT2XgKVLY9erZhwkF9LCg=;
 b=AuPE1XMwhCccklUsV0wyxrEtf3MqNSFIr6UMmIY+/fweA91pZwnfBtvPuZd/5Eb0sU2L
 R5SXeOzcNdO1SA9ScwThvAbToDZFFh6arrTFg3cyl5S03/NCOGCcqbon412CGb+zGFqL
 UW/xWszkCKIVnawD/LbkMF4PUKIE7wxmyq6BFzyBUQqF8nHsD8w4zBNTngscyTM4OlpR
 f2P0pZ9d52c9OUxpOSaIVwWXmjTuxqKnksaxqO02WYX/wV+WFBDT6iE/GMcE7NKT1TtN
 LhmS95guAssVzMO0ija+oNxRJQQxjrqjWISdw76EPWXeEkNAvEvRNh/qTwQSkKpra8s2 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cup7psb16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 18:25:25 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9HrURW007820;
        Thu, 9 Dec 2021 18:25:25 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cup7psb0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 18:25:25 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IHxKT017128;
        Thu, 9 Dec 2021 18:25:23 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyydqwn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 18:25:23 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9IPL6N22675882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 18:25:21 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD7976E05D;
        Thu,  9 Dec 2021 18:25:20 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8556E053;
        Thu,  9 Dec 2021 18:25:18 +0000 (GMT)
Received: from [9.211.136.233] (unknown [9.211.136.233])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 18:25:18 +0000 (GMT)
Message-ID: <9787a083-1271-85e5-b356-a35a549abfca@linux.ibm.com>
Date:   Thu, 9 Dec 2021 13:25:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 12/32] s390/pci: get SHM information from list pci
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-13-mjrosato@linux.ibm.com>
 <8411f2afe9f017e531b5a69e4863b933a50f90be.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8411f2afe9f017e531b5a69e4863b933a50f90be.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SPQXgw1_RmDCpTFpOnDcEkgbRLMyYfys
X-Proofpoint-ORIG-GUID: 7vfH0dH7GPJ7davPISFp7UDyrKIftAgY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_08,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 7:21 AM, Niklas Schnelle wrote:
> On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
>> KVM will need information on the special handle mask used to indicate
>> emulated devices.  In order to obtain this, a new type of list pci call
>> must be made to gather the information.  Remove the unused data pointer
>> from clp_list_pci and __clp_add and instead optionally pass a pointer to
>> a model-dependent-data field.  Additionally, allow for clp_list_pci calls
>> that don't specify a callback - in this case, just do the first pass of
>> list pci and exit.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h     |  6 ++++++
>>   arch/s390/include/asm/pci_clp.h |  2 +-
>>   arch/s390/pci/pci.c             | 19 +++++++++++++++++++
>>   arch/s390/pci/pci_clp.c         | 16 ++++++++++------
>>   4 files changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 00a2c24d6d2b..86f43644756d 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -219,12 +219,18 @@ int zpci_unregister_ioat(struct zpci_dev *, u8);
>>   void zpci_remove_reserved_devices(void);
>>   void zpci_update_fh(struct zpci_dev *zdev, u32 fh);
>>
> ---8<---
>> -static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>> -			void (*cb)(struct clp_fh_list_entry *, void *))
>> +int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
>> +		 void (*cb)(struct clp_fh_list_entry *))
>>   {
>>   	u64 resume_token = 0;
>>   	int nentries, i, rc;
>> @@ -368,8 +368,12 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>>   		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>>   		if (rc)
>>   			return rc;
>> +		if (mdd)
>> +			*mdd = rrb->response.mdd;
>> +		if (!cb)
>> +			return 0;
> 
> I think it would be slightly cleaner to instead de-static
> clp_list_pci_req() and call that directly. Just because that makes the
> clp_list_pci() still list all PCI functions and allows us to get rid of
> the data parameter completely.
> 

Oops, I must have missed this comment before.  Sure, makes sense.

> Also, I've been thinking about moving clp_scan_devices(),
> clp_get_state(), and clp_refresh_fh() out of pci_clp.c because they are
> higher level. I think that would nicely fit your zpci_get_mdd() in
> pci.c with or without the above suggestion. Then we could do the
> removal of the unused data parameter in that series as a cleanup. What
> do you think?

Sure, that would be fine.  So then this patch instead just exports 
alloc/free/clp_list_pci_req and the new zpci_get_mdd calls 
clp_list_pci_req directly.  I'll drop the changes to clp_list_pci() and 
__clp_add (and re-word the commit message)

> 
>>   		for (i = 0; i < nentries; i++)
>> -			cb(&rrb->response.fh_list[i], data);
>> +			cb(&rrb->response.fh_list[i]);
>>   	} while (resume_token);
>>   
>>   	return rc;
>> @@ -398,7 +402,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
>>   	return -ENODEV;
>>   }
>>   
>> -static void __clp_add(struct clp_fh_list_entry *entry, void *data)
>> +static void __clp_add(struct clp_fh_list_entry *entry)
>>   {
>>   	struct zpci_dev *zdev;
>>   
> 

