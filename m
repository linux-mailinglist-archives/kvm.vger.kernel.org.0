Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC905F981C
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 08:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiJJGMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 02:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiJJGM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 02:12:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17804598D
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 23:12:27 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29A42Ugb025507;
        Mon, 10 Oct 2022 06:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Xl5M7dR3ef6jTOHC4lreVMFSstAqDWLkIkuSQqHrieQ=;
 b=m4H9LPVeGFRc7H2DKELtH5+BWrIvxwh2WVVz02OVAC4ngH8QX4u2+U3mIDARlu0RKT5J
 XjKZnnFHtVND5/5G7YYGghyTGjbWxzVBF+tUdg2fr2GyVSfttOPEbam6cZD/TbxfqkxL
 n/Gh0wFxO7sE9nDpBFCFLMGdkjmdoMCpCRew7e1hmjs6TNClKSwX17x4XnFHPDqlp+lT
 a1J+w7MSrg938QRitZyrdSlFAfD6RYOSVcf8R5hG8ca/nDI3+PZ4wzQRaeFYLkTQd7Iv
 I4uNhlTKrP9JAuQmoHGl3cnutK3+8ju44HOYjUH37Yfco7e+nS9yRwHQYN+HTkQ2soGW hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k7v1r2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:12:20 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29A6CJK2013908;
        Mon, 10 Oct 2022 06:12:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k7v1r26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:12:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29A66Qs1028013;
        Mon, 10 Oct 2022 06:12:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9aa7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:12:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29A67YWa43647294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 06:07:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 876BA52051;
        Mon, 10 Oct 2022 06:12:14 +0000 (GMT)
Received: from [9.171.44.80] (unknown [9.171.44.80])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D19AA5204E;
        Mon, 10 Oct 2022 06:12:13 +0000 (GMT)
Message-ID: <ee71a864-f618-f02d-0faa-1e070e09b3b8@linux.ibm.com>
Date:   Mon, 10 Oct 2022 08:12:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        david@redhat.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
 <52ad1240-1201-259a-80d0-6e05da561a7f@linux.ibm.com>
 <Y0BtWixstpm/fFlE@google.com>
 <f0c56ea6-71db-450b-f978-e801524cf025@nutanix.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <f0c56ea6-71db-450b-f978-e801524cf025@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nAKYwVnpfLIAzTtXzEd58RRZZTt1yRTC
X-Proofpoint-GUID: 5YDZ8SUz6TScockIGFiJNY9kJBGIvlkl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=903
 mlxscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100036
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.10.22 um 20:36 schrieb Shivam Kumar:
> 
> 
> On 07/10/22 11:48 pm, Sean Christopherson wrote:
>> On Thu, Sep 15, 2022, Christian Borntraeger wrote:
>>> Am 15.09.22 um 15:21 schrieb Christian Borntraeger:
>>>> I am wondering if this will work on s390. On s390  we only call
>>>> mark_page_dirty_in_slot for the kvm_read/write functions but not
>>>> for those done by the guest on fault. We do account those lazily in
>>>> kvm_arch_sync_dirty_log (like x96 in the past).
>>>>
>>>
>>> I think we need to rework the page fault handling on s390 to actually make
>>> use of this. This has to happen anyway somewhen (as indicated by the guest
>>> enter/exit rework from Mark). Right now we handle KVM page faults directly
>>> in the normal system fault handler. It seems we need to make a side turn
>>> into KVM for page faults on guests in the long run.
>>
>> s390's page table management came up in conversation at KVM Forum in the context
>> of a common MMU (or MMUs)[*].  If/when we get an MMU that supports multiple
>> architectures, that would be a perfect opportunity for s390 to switch.  I don't
>> know that it'll be feasible to make a common MMU support s390 from the get-go,
>> but at the very least we can keep y'all in the loop and not make it unnecessarily
>> difficult to support s390.
>>
>> [*] https://kvmforum2022.sched.com/event/15jJk
> Thank you Sean for the reference to the KVM Forum talk. Should I skip the support for s390 (patch no. 4) for the next patchset?

yes please.
