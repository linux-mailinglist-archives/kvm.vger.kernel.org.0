Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C476A8B09
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 22:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCBVMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 16:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCBVMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 16:12:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8BE57D11;
        Thu,  2 Mar 2023 13:12:21 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322KRihi009507;
        Thu, 2 Mar 2023 21:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C41PJKGqWAoHhNIrgZK/pcgj3ZWg/UjpjLf903DeDMI=;
 b=kNVaJKbNkaXZPgIV7S7uWzeZ77ALDtBopJRrGSPLXBf0NzWwE1+D1uXUTFGWA7A1kJLW
 z0lcazOwntdMekHSJ78uJKYPSuxX0H4sSeqtsLZD8GCnoHSyMqrEgKCiFKptHRZIOivp
 6sCeX5FPLx6SL5LhuYThw3785P5lCrvTcFbFC3QoosMx0R58PnlVSlADA85b4nbj94Dz
 E0tgN85tdmJTGYHzIUCxFPjBcBcOWp+k1bzcd/zVCLh9qJRUqg3FVUwGolrYbd3S7qnP
 E0z5Cd5YkJR7MjlNPTYJPsnyq0ghK+Kv9X2k0/SObKM7DI4xy9ol8wx7tWBrNodx6ppy Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p32uygxn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 21:11:29 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 322KmKgQ040718;
        Thu, 2 Mar 2023 21:11:28 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p32uygxmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 21:11:28 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 322IOh2t016406;
        Thu, 2 Mar 2023 21:11:26 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3nybdm6qvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 21:11:26 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 322LBPmh7799472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Mar 2023 21:11:25 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CD965805F;
        Thu,  2 Mar 2023 21:11:25 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 737F05805B;
        Thu,  2 Mar 2023 21:11:15 +0000 (GMT)
Received: from [9.65.199.252] (unknown [9.65.199.252])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Mar 2023 21:11:15 +0000 (GMT)
Message-ID: <740d3ee7-e981-0812-f21e-296a7f350388@linux.ibm.com>
Date:   Thu, 2 Mar 2023 23:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 52/56] ccp: Add support to decrypt the page
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-53-michael.roth@amd.com>
 <20230301232045.0000502e@intel.com>
 <e63ba525-644d-1a8c-afe7-2ced4a8fbb93@linux.ibm.com>
 <36734887-6474-b43e-51ae-34f37e6670a5@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <36734887-6474-b43e-51ae-34f37e6670a5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BH9z6nn2n8lzIHVH_MLBi3cktElaaSB7
X-Proofpoint-ORIG-GUID: NKQS8NB6-1CcXMFAavhlGNyyCSi2rGOZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_13,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/03/2023 16:33, Tom Lendacky wrote:
> On 3/1/23 23:59, Dov Murik wrote:
>> Hi Mike, Zhi,
>>
>> On 01/03/2023 23:20, Zhi Wang wrote:
>>> On Mon, 20 Feb 2023 12:38:43 -0600
>>> Michael Roth <michael.roth@amd.com> wrote:
>>>
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> Add support to decrypt guest encrypted memory. These API interfaces can
>>>> be used for example to dump VMCBs on SNP guest exit.
>>>>
>>>
>>> What kinds of check will be applied from firmware when VMM decrypts this
>>> page? I suppose there has to be kinda mechanism to prevent VMM to
>>> decrypt
>>> any page in the guest. It would be nice to have some introduction about
>>> it in the comments.
>>>
>>
>> The SNP ABI spec says (section 8.27.2 SNP_DBG_DECRYPT):
>>
>>    The firmware checks that the guest's policy allows debugging. If not,
>>    the firmware returns POLICY_FAILURE.
>>
>> and in the Guest Policy (section 4.3):
>>
>>    Bit 19 - DEBUG
>>    0: Debugging is disallowed.
>>    1: Debugging is allowed.
>>
>> In the kernel, that firmware error code is defined as
>> SEV_RET_POLICY_FAILURE.
>>
>>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> [mdr: minor commit fixups]
>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>> ---
>>>>   drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
>>>>   include/linux/psp-sev.h      | 22 ++++++++++++++++++++--
>>>>   2 files changed, 52 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c
>>>> b/drivers/crypto/ccp/sev-dev.c
>>>> index e65563bc8298..bf5167b2acfc 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -2017,6 +2017,38 @@ int sev_guest_df_flush(int *error)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>>>>   +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64
>>>> dst_pfn, int *error)
>>>> +{
>>>> +    struct sev_data_snp_dbg data = {0};
>>>> +    struct sev_device *sev;
>>>> +    int ret;
>>>> +
>>>> +    if (!psp_master || !psp_master->sev_data)
>>>> +        return -ENODEV;
>>>> +
>>>> +    sev = psp_master->sev_data;
>>>> +
>>>> +    if (!sev->snp_initialized)
>>>> +        return -EINVAL;
>>>> +
>>>> +    data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
>>>> +    data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
>>>> +    data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
>>
>> I guess this works, but I wonder why we need to turn on sme_me_mask on
>> teh dst_addr.  I thought that the firmware decrypts the guest page
>> (src_addr) to a plaintext page.  Couldn't find this requirement in the
>> SNP spec.
> 
> This sme_me_mask tells the firmware how to access the host memory
> (similar to how DMA uses sme_me_mask when supplying addresses to devices
> under SME). This needs to match the pagetable mapping being used by the
> host, otherwise the contents will appears as ciphertext to the host if
> they are not in sync. Since the default pagetable mapping is encrypted,
> the sme_me_mask bit must be provided on the destination address. So it
> is not a spec requirement, but an SME implementation requirement.
> 

Ah, OK, that's clear now. Thanks Tom.

-Dov
