Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B36FD756
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbjEJGpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjEJGpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:45:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBAEB1;
        Tue,  9 May 2023 23:45:22 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A6iASl027579;
        Wed, 10 May 2023 06:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qF3xzVb5ASb+uwQUcMMXlDDAtZUl6pJqfD7W3a1diDk=;
 b=AnjIpXEdIJAio3WtIwHbsyw8A5YdLOSA3DYQBo0l+OaNOKEOq06lNtlFzI4byYoMkpSl
 Ht8VZqR89hXP9mpGX971PReuBgItXU5+dv/Q18OAoU1BuoWByBGtWEUngffI9eXrl60S
 WUvTLNJj1RcX+Jsu2YseEBxwmOAPHBHewyI7x7WKHZQB/C8CRQ3v3Wqg6WBEyagsAq8H
 vo8CBrnxfHirDzEt3FEqHbtEHyBGfFoov6N2g5E3gH3zXlLG92gl5wWGi4WuHK5v+3sT
 dXN+tV2jd9R0uDgrk6YJsTjgiFHIMAUe/9xOhuKddB2FAIqa7Q0EZw7Sg98K1gMgcuXf 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg5jts2yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 06:45:21 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A6dLDv010269;
        Wed, 10 May 2023 06:45:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg5jts2x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 06:45:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A3oopm017262;
        Wed, 10 May 2023 06:45:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rv35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 06:45:18 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A6jF3K27525852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 06:45:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35FC92004B;
        Wed, 10 May 2023 06:45:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C65FF20040;
        Wed, 10 May 2023 06:45:14 +0000 (GMT)
Received: from [9.171.18.209] (unknown [9.171.18.209])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 06:45:14 +0000 (GMT)
Message-ID: <8b2eafb8-8ac9-be39-3c81-9f59fd3e9147@linux.ibm.com>
Date:   Wed, 10 May 2023 08:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap events
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230509111202.333714-1-nrb@linux.ibm.com>
 <20230509111202.333714-3-nrb@linux.ibm.com>
 <c762bd30-9753-7b3e-3f46-b15ba575ee7c@linux.ibm.com>
 <168364406109.331309.632943177292737298@t14-nrb>
 <20230509171404.1495e864@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230509171404.1495e864@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: og5L45m1KvUNkQb55sBamn9B-jzFh4JE
X-Proofpoint-GUID: EcL72GNZPHYpdf1wSRyCvds78ImJW0TB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_03,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100051
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/23 17:14, Claudio Imbrenda wrote:
> On Tue, 09 May 2023 16:54:21 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> Quoting Janosch Frank (2023-05-09 13:59:46)
>> [...]
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>> index 3c3fe45085ec..7f70e3bbb44c 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -777,6 +777,11 @@ struct kvm_vm_stat {
>>>>        u64 inject_service_signal;
>>>>        u64 inject_virtio;
>>>>        u64 aen_forward;
>>>> +     u64 gmap_shadow_acquire;
>>>> +     u64 gmap_shadow_r2;
>>>> +     u64 gmap_shadow_r3;
>>>> +     u64 gmap_shadow_segment;
>>>> +     u64 gmap_shadow_page;
>>>
>>> This needs to be gmap_shadow_pgt and then we need a separate shadow page
>>> counter that's beeing incremented in kvm_s390_shadow_fault().
>>>
>>>
>>> I'm wondering if we should name them after the entries to reduce
>>> confusion especially when we get huge pages in the future.
>>>
>>> gmap_shadow_acquire
>>> gmap_shadow_r1_te (ptr to r2 table)
>>> gmap_shadow_r2_te (ptr to r3 table)
>>> gmap_shadow_r3_te (ptr to segment table)
>>> gmap_shadow_sg_te (ptr to page table)
>>> gmap_shadow_pg_te (single page table entry)
> 
> but then why not calling them gmap_shadow_{pte,pmd,pud,p4d,pgd} ?
> 

Because I'll need to look up the order of the names after the pmd :)
The gmap mostly works with s390 names.

I'm not totally opposed to that but I also don't see a clear benefit.

