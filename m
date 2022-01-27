Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76349E3B5
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 14:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiA0NkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 08:40:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229989AbiA0NkG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 08:40:06 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RDLTZn006247;
        Thu, 27 Jan 2022 13:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9B00AyijRpmNo7rB0oRFsYf4py7aMINA+uJSZmM61+Y=;
 b=OtDUO159/OQTW8jGZhYDLibp+dJ/MAJAB6tqVzUaHvPNP6kkAw7khL+36wj7ZjrTJUtu
 JzSxS9Tm278stGCCrP2itD/3D4cr/pQTBSbGGbLkKJ8S6gy4hawFZv1cczPxtu2L68iF
 Som9s6iEw+go/NXRCjAjTstB4qFqovO4LE/ywd7B9OAsYzkTspXxXeQc3oWh1zO1J4dK
 bL0oyQFYLoasx7sfyShH3xuXmC3toKqyGtTr5FnztBzKwxUDPmbgA6raVLCf24czdWSa
 UdB444GhhM5I2SMZuXMWcyrpf7et5agrCKl+oU+7HgB382yqA7NpOlll38CVqbLKh+uU Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutb5b16u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 13:40:05 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RDLkeY007552;
        Thu, 27 Jan 2022 13:40:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutb5b15x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 13:40:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RDc3rM027068;
        Thu, 27 Jan 2022 13:40:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9re7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 13:40:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RDdxPm42008968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 13:39:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C48CAE04D;
        Thu, 27 Jan 2022 13:39:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BEB7AE056;
        Thu, 27 Jan 2022 13:39:58 +0000 (GMT)
Received: from [9.171.44.35] (unknown [9.171.44.35])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 13:39:58 +0000 (GMT)
Message-ID: <773d3d7c-24a4-fad3-8700-2ecd083a3bad@linux.ibm.com>
Date:   Thu, 27 Jan 2022 14:41:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 12/30] s390/pci: get SHM information from list pci
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-13-mjrosato@linux.ibm.com>
 <a0fbd50c-bfa4-5f62-6dea-18b85562fff6@linux.ibm.com>
 <20220126111300.1084623e@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220126111300.1084623e@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zqeAf9-V971qPVXE4Wc3-kFH8AatXrg0
X-Proofpoint-ORIG-GUID: 5ENwusrFpryJ8r74zkoPDZX8oTbOwjKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/26/22 11:13, Claudio Imbrenda wrote:
> On Tue, 18 Jan 2022 11:36:06 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> KVM will need information on the special handle mask used to indicate
>>> emulated devices.  In order to obtain this, a new type of list pci call
>>> must be made to gather the information.  Extend clp_list_pci_req to
>>> also fetch the model-dependent-data field that holds this mask.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/pci.h     |  1 +
>>>    arch/s390/include/asm/pci_clp.h |  2 +-
>>>    arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
>>>    3 files changed, 27 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>>> index 00a2c24d6d2b..f3cd2da8128c 100644
>>> --- a/arch/s390/include/asm/pci.h
>>> +++ b/arch/s390/include/asm/pci.h
>>> @@ -227,6 +227,7 @@ int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
>>>    int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
>>>    int clp_get_state(u32 fid, enum zpci_state *state);
>>>    int clp_refresh_fh(u32 fid, u32 *fh);
>>> +int zpci_get_mdd(u32 *mdd);
>>>    
>>>    /* UID */
>>>    void update_uid_checking(bool new);
>>> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
>>> index 124fadfb74b9..d6bc324763f3 100644
>>> --- a/arch/s390/include/asm/pci_clp.h
>>> +++ b/arch/s390/include/asm/pci_clp.h
>>> @@ -76,7 +76,7 @@ struct clp_req_list_pci {
>>>    struct clp_rsp_list_pci {
>>>    	struct clp_rsp_hdr hdr;
>>>    	u64 resume_token;
>>> -	u32 reserved2;
>>> +	u32 mdd;
>>>    	u16 max_fn;
>>>    	u8			: 7;
>>>    	u8 uid_checking		: 1;
>>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>>> index bc7446566cbc..308ffb93413f 100644
>>> --- a/arch/s390/pci/pci_clp.c
>>> +++ b/arch/s390/pci/pci_clp.c
>>> @@ -328,7 +328,7 @@ int clp_disable_fh(struct zpci_dev *zdev, u32 *fh)
>>>    }
>>>    
>>>    static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
>>> -			    u64 *resume_token, int *nentries)
>>> +			    u64 *resume_token, int *nentries, u32 *mdd)
>>>    {
>>>    	int rc;
>>>    
>>> @@ -354,6 +354,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
>>>    	*nentries = (rrb->response.hdr.len - LIST_PCI_HDR_LEN) /
>>>    		rrb->response.entry_size;
>>>    	*resume_token = rrb->response.resume_token;
>>> +	if (mdd)
>>> +		*mdd = rrb->response.mdd;
>>>    
>>>    	return rc;
>>>    }
>>> @@ -365,7 +367,7 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>>>    	int nentries, i, rc;
>>>    
>>>    	do {
>>> -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>>> +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>>>    		if (rc)
>>>    			return rc;
>>>    		for (i = 0; i < nentries; i++)
>>> @@ -383,7 +385,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
>>>    	int nentries, i, rc;
>>>    
>>>    	do {
>>> -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>>> +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>>>    		if (rc)
>>>    			return rc;
>>>    		fh_list = rrb->response.fh_list;
>>> @@ -468,6 +470,26 @@ int clp_get_state(u32 fid, enum zpci_state *state)
>>>    	return rc;
>>>    }
>>>    
>>> +int zpci_get_mdd(u32 *mdd)
>>> +{
>>> +	struct clp_req_rsp_list_pci *rrb;
>>> +	u64 resume_token = 0;
>>> +	int nentries, rc;
>>> +
>>> +	if (!mdd)
>>> +		return -EINVAL;
>>
>> I think this tests is not useful.
>> The caller must take care not to call with a NULL pointer,
>> what the only caller today make sure.
> 
> what if the caller does it anyway?
> 
> I think the test is useful. if passing NULL is a bug, then maybe
> consider using BUG_ON, or WARN_ONCE

I think generally the caller is responsible for the test.
In our case for example the caller can use directly the address
of a u32 allocated on the stack or globaly and he knows if a test is 
useful or not.

Of course we can systematically check in every kernel function all 
pointer parameters against NULL.
But this is not userland, not even a inter-architecture core function 
and we can expect the kernel programmer to programm correctly.

For our special case zpci_get_mdd() nor clp_list_pci_req() do access 
*mdd if mdd is NULL so that giving a NULL mdd pointer will not trigger a 
fault.
Also, the function is named zpci_get_mdd(u32 *mdd) if the caller do not 
give a pointer to mdd which would be quite stupid to call a function 
zpci_get_mdd() in this circumstance he will just no get mdd, no side effect.
So the only purpose having this test here is to say the caller that he 
forgot to check his mdd allocation.
My opinion is that he should have check.

> 
>>
>>
>>> +
>>> +	rrb = clp_alloc_block(GFP_KERNEL);
>>> +	if (!rrb)
>>> +		return -ENOMEM;
>>> +
>>> +	rc = clp_list_pci_req(rrb, &resume_token, &nentries, mdd);
>>> +
>>> +	clp_free_block(rrb);
>>> +	return rc;
>>> +}
>>> +EXPORT_SYMBOL_GPL(zpci_get_mdd);
>>> +
>>>    static int clp_base_slpc(struct clp_req *req, struct clp_req_rsp_slpc *lpcb)
>>>    {
>>>    	unsigned long limit = PAGE_SIZE - sizeof(lpcb->request);
>>>    
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
