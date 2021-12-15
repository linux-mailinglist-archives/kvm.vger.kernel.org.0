Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458AF475A15
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243072AbhLON5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 08:57:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237608AbhLON5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 08:57:39 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFDUUKK020582;
        Wed, 15 Dec 2021 13:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GP7pjLcoYthJpbF0bz9LAu4NN813NR3H2kHv50mJyTk=;
 b=Px0t/DaA4IyNSV+crU6ryemR74Md372/q5+Xr6qXxiN+MoB/Kdfuwr/zgDa5H2MXknLJ
 tH7wUyzIL7E99fKFh5xqZuhsm1EMt4lufFUphpKCYJWdFFjf9Wn9GHLoxKlxwg5jEHmV
 wQv7qbX0W94fLkv2Q1mGQwh8x+NRUS0lh5TllcxDKvTSyW5st7BUAgXPUEZilbXkZkRx
 vV56beQeseoz+j0mPJxbLRy6Tcwe9tUf6INhbnQMusZjD2dbR4URinWVc1yRwdtXWalk
 Za/OxhG0zeeowjQ6yqkATUIdpIMn+INAzdXUSX06Jcvhmb7wuEith6DWo3g9Jjih9jmY ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyfv3jpwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 13:57:38 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BFDtkVr009465;
        Wed, 15 Dec 2021 13:57:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyfv3jpw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 13:57:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFDqi8x020263;
        Wed, 15 Dec 2021 13:57:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cy78e5rkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 13:57:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFDvW6k23265622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 13:57:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32C9242054;
        Wed, 15 Dec 2021 13:57:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3A664204D;
        Wed, 15 Dec 2021 13:57:31 +0000 (GMT)
Received: from [9.171.32.186] (unknown [9.171.32.186])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 13:57:31 +0000 (GMT)
Message-ID: <28d795f7-e3f7-e64d-88eb-264a30167961@de.ibm.com>
Date:   Wed, 15 Dec 2021 14:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211213210550.856213-1-farman@linux.ibm.com>
 <20211213210550.856213-2-farman@linux.ibm.com>
 <3832e4ab-ffb7-3389-908d-99225ccea038@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <3832e4ab-ffb7-3389-908d-99225ccea038@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C66EkEN1bTGfKgxHinpTApwdGbwD5J8o
X-Proofpoint-ORIG-GUID: CpNU_36gU5tazeRIR06KC2W53M4wZywX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_09,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.12.21 um 14:24 schrieb David Hildenbrand:
> On 13.12.21 22:05, Eric Farman wrote:
>> With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
>> orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
>> SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
>> and thus are processed in-kernel. The remainder are sent to userspace
>> with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
>> (RESTART, STOP, and STOP AND STORE STATUS) have the potential to
>> inject work back into the kernel, and thus are asynchronous.
>>
>> Let's look for those pending IRQs when processing one of the in-kernel
>> SIGP orders, and return BUSY (CC2) if one is in process. This is in
>> agreement with the Principles of Operation, which states that only one
>> order can be "active" on a CPU at a time.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
> 
> In general, LGTM. As raised, with SIGP RESTART there are other cases we
> could fix in the kernel, but they are of very low priority IMHO.

Does that qualify as an RB, assuming that we can fix the other cases later on?

