Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4C5B55AA
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 10:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiILIDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 04:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiILIDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 04:03:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5181F601;
        Mon, 12 Sep 2022 01:03:18 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28C7g1pX030101;
        Mon, 12 Sep 2022 08:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cogpfbnj15ADP59OSMPVgLh4mCeiMTcqFNIAp5CsxfU=;
 b=kNKY+8H6VfFIOmstN572JZ7d++Al24EW1SJGN/Ze/ojkSTxUE17JQILZ1UHzAeqfLj12
 flZt2X1vH1PadkVMxn+Use3iK4E/q5aE20QcqEWyXskmG5ui5FulVHH8OqWzHtLj4iQc
 4y9S7x8DqTS5hwfQn6tfPslbweFKerj+qt04PSpr99fLHPAq1YbSA6fsJbr8fT37Bh63
 5u/zg52/0xQgPPmR7KOjxgP27h2pb6iYBv2iZbwcwHuGj2TNMdNkEjOagbz2UtcdLVmz
 tOXejs1kqxc/ABpw0n2C191iz4yP7iiI0nYg9ngdWbFnIOMjUsGomvxPw3C7UXtK0DdU eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj0kv8hw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 08:03:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28C7goS9032045;
        Mon, 12 Sep 2022 08:03:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj0kv8huk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 08:03:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28C7ojDT018285;
        Mon, 12 Sep 2022 08:03:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3jgj78sh63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 08:03:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28C83Co340501686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 08:03:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 053C142049;
        Mon, 12 Sep 2022 08:03:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC51F42045;
        Mon, 12 Sep 2022 08:03:08 +0000 (GMT)
Received: from [9.171.83.92] (unknown [9.171.83.92])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 08:03:08 +0000 (GMT)
Message-ID: <6daf3aa9-5b91-1948-0c43-b8407fe3bea2@linux.ibm.com>
Date:   Mon, 12 Sep 2022 10:03:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, svens@linux.ibm.com
References: <20220905084148.234821-1-pmorel@linux.ibm.com>
 <08c54ddd-b74e-9f6c-f5eb-13e994530ad6@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <08c54ddd-b74e-9f6c-f5eb-13e994530ad6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5NAw5mHnshwRO9qS7uVaAY2aKd9j0Fpn
X-Proofpoint-ORIG-GUID: EQiTKXhFLZNzWf5DnUPiY-F1xjFHvjEh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_04,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120027
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi David,

sorry for the delay, just came back from vacation.

On 9/5/22 18:32, David Hildenbrand wrote:
> On 05.09.22 10:41, Pierre Morel wrote:
>> Prepare VSIE for architectural changes where lowmem kernel real and
>> kernel virtual address are different.
> 
> Bear with me, it used to be
> 
>      crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
>      apcb_o = (unsigned long) &crycb->apcb0;
> 
> and now it's
> 
>      apcb_o = crycb_o + offsetof(struct kvm_s390_crypto_cb, apcb0);
> 
> 
> So the real issue seems to be
> 
>      crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
> 
> because crycb_o actually is a guest address and not a host address.

Yes, right this is the real issue, however...

> 
> 
> But now I'm confused, because I would have thought that the result 
> produced by both code would be identical (I completely agree that the 
> new variant is better).
> 
> How does this interact with "lowmem kernel real and kernel virtual 
> address are different." -- I would have thought that &crycb->apcb0 
> doesn't actually access any memory and only performs arithmetical 
> operations?

...you are right and the result is identical.


> 
>>
>> When we get the original crycb from the guest crycb we can use the
>> phys_to_virt transformation, which will use the host transformations,
>> but we must use an offset to calculate the guest real address apcb
>> and give it to read_guest_real().
> 
> Can you elaborate where phys_to_virt() comes into play?

No, it does not have to do with phys_to_virt(), I first started to work 
on the line:
- crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;

and did not notice that after the simplifications the result was identical.
So The comment is wrong and this patch is only making the code clearer.

Thanks for your clarifications,

Regards,
Pierre


> 
> If this is an actual fix (as indicated in the patch subject), should 
> this carry a
> 
>      Fixes: 56019f9aca22 ("KVM: s390: vsie: Allow CRYCB FORMAT-2")
> 

-- 
Pierre Morel
IBM Lab Boeblingen
