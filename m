Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A7949E58E
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 16:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242786AbiA0PPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 10:15:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231149AbiA0PPN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 10:15:13 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RF1qaJ016942;
        Thu, 27 Jan 2022 15:15:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mGdwYQBS2IeyJ0zCeqVU7VTYZoopQmAH4naBarL2Da8=;
 b=Eg9IEtYAgGwfblKKu5iL8nLbkijscnGWNeK5PwHa7a8ejDn8EFlQ4aV1bI7AsbthyXEf
 KgS83Ytwc2DurndGooktx23C4bSSpn8MLtu+PNCRljGnFPTw+O+Q1HpwOqeKQr1D8KHj
 3WYHHybhP5tbaqMQV7onaR6P+BhdexjoJQrb6aYpWhVICh2WRAWM9cr0e8hsPxZiD9D8
 WsGsQVHam+XGs27dnN2eLNAT622mIaw4+w52UyVH7XL9LwldRKmyipC8sTtC5HasA4mM
 W7RJ8c2y+VoczLOuTxCelPhEvUOVe+1SAZnGMzcHe33j4ej7ZMVlifMrYa928mjoL2iw tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutb5df0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:15:12 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RF1p8k016816;
        Thu, 27 Jan 2022 15:15:12 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutb5df07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:15:12 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RF7tnb005285;
        Thu, 27 Jan 2022 15:15:11 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3dr9jcnjp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:15:11 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RFF8no11600268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 15:15:08 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DFDFB2072;
        Thu, 27 Jan 2022 15:15:08 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04BB3B2075;
        Thu, 27 Jan 2022 15:15:00 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 15:15:00 +0000 (GMT)
Message-ID: <9abf1c43-7539-b7b9-6961-dc0e35f4120c@linux.ibm.com>
Date:   Thu, 27 Jan 2022 10:14:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 12/30] s390/pci: get SHM information from list pci
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        schnelle@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, farman@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-13-mjrosato@linux.ibm.com>
 <a0fbd50c-bfa4-5f62-6dea-18b85562fff6@linux.ibm.com>
 <20220126111300.1084623e@p-imbrenda>
 <773d3d7c-24a4-fad3-8700-2ecd083a3bad@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <773d3d7c-24a4-fad3-8700-2ecd083a3bad@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkDQoc8K4r8Ib3HQS0wUjTDsWuKgyKfN
X-Proofpoint-ORIG-GUID: lJPvTt8AtWFbUO4qojzjOT0Ca828s7Y6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 8:41 AM, Pierre Morel wrote:
> 
> 
> On 1/26/22 11:13, Claudio Imbrenda wrote:
>> On Tue, 18 Jan 2022 11:36:06 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> On 1/14/22 21:31, Matthew Rosato wrote:
>>>> KVM will need information on the special handle mask used to indicate
>>>> emulated devices.  In order to obtain this, a new type of list pci call
>>>> must be made to gather the information.  Extend clp_list_pci_req to
>>>> also fetch the model-dependent-data field that holds this mask.
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>    arch/s390/include/asm/pci.h     |  1 +
>>>>    arch/s390/include/asm/pci_clp.h |  2 +-
>>>>    arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
>>>>    3 files changed, 27 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>>>> index 00a2c24d6d2b..f3cd2da8128c 100644
>>>> --- a/arch/s390/include/asm/pci.h
>>>> +++ b/arch/s390/include/asm/pci.h
>>>> @@ -227,6 +227,7 @@ int clp_enable_fh(struct zpci_dev *zdev, u32 
>>>> *fh, u8 nr_dma_as);
>>>>    int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
>>>>    int clp_get_state(u32 fid, enum zpci_state *state);
>>>>    int clp_refresh_fh(u32 fid, u32 *fh);
>>>> +int zpci_get_mdd(u32 *mdd);
>>>>    /* UID */
>>>>    void update_uid_checking(bool new);
>>>> diff --git a/arch/s390/include/asm/pci_clp.h 
>>>> b/arch/s390/include/asm/pci_clp.h
>>>> index 124fadfb74b9..d6bc324763f3 100644
>>>> --- a/arch/s390/include/asm/pci_clp.h
>>>> +++ b/arch/s390/include/asm/pci_clp.h
>>>> @@ -76,7 +76,7 @@ struct clp_req_list_pci {
>>>>    struct clp_rsp_list_pci {
>>>>        struct clp_rsp_hdr hdr;
>>>>        u64 resume_token;
>>>> -    u32 reserved2;
>>>> +    u32 mdd;
>>>>        u16 max_fn;
>>>>        u8            : 7;
>>>>        u8 uid_checking        : 1;
>>>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>>>> index bc7446566cbc..308ffb93413f 100644
>>>> --- a/arch/s390/pci/pci_clp.c
>>>> +++ b/arch/s390/pci/pci_clp.c
>>>> @@ -328,7 +328,7 @@ int clp_disable_fh(struct zpci_dev *zdev, u32 *fh)
>>>>    }
>>>>    static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
>>>> -                u64 *resume_token, int *nentries)
>>>> +                u64 *resume_token, int *nentries, u32 *mdd)
>>>>    {
>>>>        int rc;
>>>> @@ -354,6 +354,8 @@ static int clp_list_pci_req(struct 
>>>> clp_req_rsp_list_pci *rrb,
>>>>        *nentries = (rrb->response.hdr.len - LIST_PCI_HDR_LEN) /
>>>>            rrb->response.entry_size;
>>>>        *resume_token = rrb->response.resume_token;
>>>> +    if (mdd)
>>>> +        *mdd = rrb->response.mdd;
>>>>        return rc;
>>>>    }
>>>> @@ -365,7 +367,7 @@ static int clp_list_pci(struct 
>>>> clp_req_rsp_list_pci *rrb, void *data,
>>>>        int nentries, i, rc;
>>>>        do {
>>>> -        rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>>>> +        rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>>>>            if (rc)
>>>>                return rc;
>>>>            for (i = 0; i < nentries; i++)
>>>> @@ -383,7 +385,7 @@ static int clp_find_pci(struct 
>>>> clp_req_rsp_list_pci *rrb, u32 fid,
>>>>        int nentries, i, rc;
>>>>        do {
>>>> -        rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>>>> +        rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>>>>            if (rc)
>>>>                return rc;
>>>>            fh_list = rrb->response.fh_list;
>>>> @@ -468,6 +470,26 @@ int clp_get_state(u32 fid, enum zpci_state *state)
>>>>        return rc;
>>>>    }
>>>> +int zpci_get_mdd(u32 *mdd)
>>>> +{
>>>> +    struct clp_req_rsp_list_pci *rrb;
>>>> +    u64 resume_token = 0;
>>>> +    int nentries, rc;
>>>> +
>>>> +    if (!mdd)
>>>> +        return -EINVAL;
>>>
>>> I think this tests is not useful.
>>> The caller must take care not to call with a NULL pointer,
>>> what the only caller today make sure.
>>
>> what if the caller does it anyway?
>>
>> I think the test is useful. if passing NULL is a bug, then maybe
>> consider using BUG_ON, or WARN_ONCE
> 
> I think generally the caller is responsible for the test.
> In our case for example the caller can use directly the address
> of a u32 allocated on the stack or globaly and he knows if a test is 
> useful or not.
> 
> Of course we can systematically check in every kernel function all 
> pointer parameters against NULL.
> But this is not userland, not even a inter-architecture core function 
> and we can expect the kernel programmer to programm correctly.

I appreciate your optimism :)

> 
> For our special case zpci_get_mdd() nor clp_list_pci_req() do access 
> *mdd if mdd is NULL so that giving a NULL mdd pointer will not trigger a 
> fault.
> Also, the function is named zpci_get_mdd(u32 *mdd) if the caller do not 
> give a pointer to mdd which would be quite stupid to call a function 
> zpci_get_mdd() in this circumstance he will just no get mdd, no side 
> effect.
> So the only purpose having this test here is to say the caller that he 
> forgot to check his mdd allocation.
> My opinion is that he should have check.

Based on the thread of conversation, I'm going to assume you meant 'My 
opinion that he should -not- have the check here'

So, I'm generally a fan of being a bit defensive in paths that are not 
performance-intensive and would therefore typically tend to agree with 
Claudio.  But in this particular case, I'm willing to just drop this 
check and move on, primarily because 1) we only have a single caller 
already checking this case and 2) I don't really anticipate any 
additional callers later.

@Niklas do you care / is it OK to keep your R-b if I remove this 
if(!mdd) check?

