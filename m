Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C82C665522
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 08:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbjAKH14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 02:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbjAKH1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 02:27:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E623331A;
        Tue, 10 Jan 2023 23:27:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B7DoLq009757;
        Wed, 11 Jan 2023 07:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bJaGhzuZvR6IABqF8ZAnYUhk8yUitqZDm487hDCv2iI=;
 b=e5l1zoDEzM/oIR9UHwpA1OPByGk/SEZnxOPBF9pnh+eRHiXXF0oces8jr/tKCEoeE7Em
 XCGNk5jhMt+YWzW/edepOh9im6W4g7EbynW9YxESvPeJJj41Ol2HMQ7pI0q7eCdHehGG
 93UY5B21l3oVy3mNsX8gVgx2paAeDoTWvFm9XAx1Ol+kFuEtf8hBE6x6bhPJhPgHlkft
 5h4lkIjt+jUPJ88ZtzENaA9xiQhTqIo4RZJk777naFPEFb5xhiEPMG3YAp5yE7nMnpD/
 CU1sGxIUJwXt5lBWJ43qdjIaZeA08y/ZwSABJkLmi5P0fFcz3zYynW0Kp57/7po1j96A dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1rhu87ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 07:26:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30B7I62h022293;
        Wed, 11 Jan 2023 07:26:32 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1rhu87gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 07:26:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30B54gj2014428;
        Wed, 11 Jan 2023 07:26:31 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3n1kv51j16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 07:26:30 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30B7QTfo29622816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 07:26:29 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 171FE58053;
        Wed, 11 Jan 2023 07:26:29 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D714358043;
        Wed, 11 Jan 2023 07:26:19 +0000 (GMT)
Received: from [9.148.12.120] (unknown [9.148.12.120])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Jan 2023 07:26:19 +0000 (GMT)
Message-ID: <80ed8c14-1e00-166c-0754-42707b568562@linux.ibm.com>
Date:   Wed, 11 Jan 2023 09:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Dov Murik <dovmurik@linux.ibm.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-63-michael.roth@amd.com>
 <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
 <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
 <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com>
 <a3ecd9fc-11f8-49b6-09a2-349df815d2cf@linux.ibm.com>
 <1047996c-309b-6839-fdd7-265fc51eb07a@amd.com>
 <CAMkAt6rMwiHoNWLtrdN8g8Ghv8yN8f8fZQBBkXvUdDpdtovPzg@mail.gmail.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <CAMkAt6rMwiHoNWLtrdN8g8Ghv8yN8f8fZQBBkXvUdDpdtovPzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VM1eKCuyhDEX_d4qbaiVCVOno4JqwtpX
X-Proofpoint-ORIG-GUID: pdXzmNaWViZBcZNPR3P4d2ZBgKoW_aSW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_03,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 10/01/2023 17:23, Peter Gonda wrote:
> On Tue, Jan 10, 2023 at 8:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 1/10/23 01:10, Dov Murik wrote:
>>> Hi Tom,
>>>
>>> On 10/01/2023 0:27, Tom Lendacky wrote:
>>>> On 1/9/23 10:55, Dionna Amalie Glaze wrote:
>>>>>>> +
>>>>>>> +static int snp_set_instance_certs(struct kvm *kvm, struct
>>>>>>> kvm_sev_cmd *argp)
>>>>>>> +{
>>>>>> [...]
>>>>>>
>>>>>> Here we set the length to the page-aligned value, but we copy only
>>>>>> params.cert_len bytes.  If there are two subsequent
>>>>>> snp_set_instance_certs() calls where the second one has a shorter
>>>>>> length, we might "keep" some leftover bytes from the first call.
>>>>>>
>>>>>> Consider:
>>>>>> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
>>>>>> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
>>>>>>
>>>>>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
>>>>>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
>>>>>> 1) & PAGE_MASK which will be 8192.
>>>>>>
>>>>>> Later when fetching the certs (for the extended report or in
>>>>>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
>>>>>> filled with 4097 BBBs and 4095 leftover AAAs.
>>>>>>
>>>>>> Maybe zero sev->snp_certs_data entirely before writing to it?
>>>>>>
>>>>>
>>>>> Yes, I agree it should be zeroed, at least if the previous length is
>>>>> greater than the new length. Good catch.
>>>>>
>>>>>
>>>>>> Related question (not only for this patch) regarding snp_certs_data
>>>>>> (host or per-instance): why is its size page-aligned at all? why is it
>>>>>> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
>>>>>> is never sent to the PSP.
>>>>>>
>>>>>
>>>>> The buffer is meant to be copied into the guest driver following the
>>>>> GHCB extended guest request protocol. The data to copy back are
>>>>> expected to be in 4K page granularity.
>>>>
>>>> I don't think the data has to be in 4K page granularity. Why do you
>>>> think it does?
>>>>
>>>
>>> I looked at AMD publication 56421 SEV-ES Guest-Hypervisor Communication
>>> Block Standardization (July 2022), page 37.  The table says:
>>>
>>> --------------
>>>
>>> NAE Event: SNP Extended Guest Request
>>>
>>> Notes:
>>>
>>> RAX will have the guest physical address of the page(s) to hold returned
>>> data
>>>
>>> RBX
>>> State to Hypervisor: will contain the number of guest contiguous
>>> pages supplied to hold returned data
>>> State from Hypervisor: on error will contain the number of guest
>>> contiguous pages required to hold the data to be returned
>>>
>>> ...
>>>
>>> The request page, response page and data page(s) must be assigned to the
>>> hypervisor (shared).
>>>
>>> --------------
>>>
>>>
>>> According to this spec, it looks like the sizes are communicated as
>>> number of pages in RBX.  So the data should start at a 4KB alignment
>>> (this is verified in snp_handle_ext_guest_request()) and its length
>>> should be 4KB-aligned, as Dionna noted.
>>
>> That only indicates how many pages are required to hold the data, but the
>> hypervisor only has to copy however much data is present. If the data is
>> 20 bytes, then you only have to copy 20 bytes. If the user supplied 0 for
>> the number of pages, then the code returns 1 in RBX to indicate that one
>> page is required to hold the 20 bytes.
>>
>>>
>>> I see no reason (in the spec and in the kernel code) for the data length
>>> to be limited to 16KB (SEV_FW_BLOB_MAX_SIZE) but I might be missing some
>>> flow because Dionna ran into this limit.
>>
>> Correct, there is no limit. I believe that SEV_FW_BLOB_MAX_SIZE is a way
>> to keep the memory usage controlled because data is coming from userspace
>> and it isn't expected that the data would be larger than that.
>>
>> I'm not sure if that was in from the start or as a result of a review
>> comment. Not sure what is the best approach is.
> 
> This was discussed a bit in the guest driver changes recently too that
> SEV_FW_BLOB_MAX_SIZE is used in the guest driver code for the max cert
> length. We discussed increasing the limit there after fixing the IV
> reuse issue.

I see it now.

(Joerg, maybe we should add F:drivers/virt/coco/ to the MAINTAINERS list
so that patches there are hopefully sent to linux-coco?)


> 
> Maybe we could introduce SEV_CERT_BLOB_MAX_SIZE here to be more clear
> there is no firmware based limit? Then we could switch the guest
> driver to use that too. Dionna confirmed 4 pages is enough for our
> current usecase, Dov would you recommend something larger to start?
> 

Introducing a new constant sounds good to me (and use the same constant
in the guest driver).

I think 4 pages are OK; I also don't see real harm in increasing this
limit to 1 MB (if the host+guest agree to pass more stuff there, besides
certificates).  But maybe that's just abusing this channel, and for
other data we should use other mechanisms (like vsock).

-Dov

