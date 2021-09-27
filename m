Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F85B419797
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhI0PTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:19:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42288 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234972AbhI0PTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 11:19:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RDtpLQ005737;
        Mon, 27 Sep 2021 11:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZEE60/MIiE9EAlUoL+qREn3xlXTzM3VY0WrkyxkxqVs=;
 b=Z/cSuPKy4WW6nyyvwgn3IEag+/NHeYMwaeEME56kq6Tji5iOugywvpgYi/UrL76eiMlQ
 rqEPuprIVzPaSCoLhjioaWlVTcIVsBDa+BA3b0xkuLj5/GnMyTHk2MNuk4ZeOpaxlIdh
 fVNQRMiw9Sx1bGglHa/7T+LtdguH++5KUhh0CKWYUckSQu30s46iS9WHlnBUJMdwW4Ng
 TPRatQYOroLn2gAkBttRiI+2eb+7Sc0GcsX/4RwXQOVsRsjZJDSIqOIhj/Z00w6+xpwf
 Qrb5Z+SFGSV0kGRWevI032kOeI59xbuvImCf0qXbfzOKh0GfkRM9ISCwmpD8AKh8rXze aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4y7q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 11:17:04 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RCd4rR028652;
        Mon, 27 Sep 2021 11:17:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4y7p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 11:17:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RFDnB9014438;
        Mon, 27 Sep 2021 15:17:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3b9ud955wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 15:16:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RFGtkp38339018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:16:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 811A24C050;
        Mon, 27 Sep 2021 15:16:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80DD44C04E;
        Mon, 27 Sep 2021 15:16:52 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.4.236])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 15:16:52 +0000 (GMT)
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
Date:   Mon, 27 Sep 2021 17:16:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eb5BjgGXgLT0dQk2cLo1gGaMMdASPGv7
X-Proofpoint-ORIG-GUID: m0HV4GnBNkTGM5q4JkVIpGynJneqKgrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 27.09.21 um 17:03 schrieb Paolo Bonzini:
> On 27/09/21 16:59, Sean Christopherson wrote:
>>> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
>>> Author:     David Matlack<dmatlack@google.com>
>>> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
>>> Commit:     Paolo Bonzini<pbonzini@redhat.com>
>>> CommitDate: Fri Apr 24 12:53:17 2020 -0400
>>>
>>>      kvm: add capability for halt polling
>>>
>>> broke the possibility for an admin to disable halt polling for already running KVM guests.
>>> In past times doing
>>> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
>>>
>>> stopped polling system wide.
>>> Now all KVM guests will use the halt_poll_ns value that was active during
>>> startup - even those that do not use KVM_CAP_HALT_POLL.
>>>
>>> I guess this was not intended?
> 
> No, but...
> 
>> I would go so far as to say that halt_poll_ns should be a hard limit on
>> the capability
> 
> ... this would not be a good idea I think.  Anything that wants to do a lot of polling can just do "for (;;)".
> 
> So I think there are two possibilities that makes sense:
> 
> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that

what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
> 
> * just make halt_poll_ns read-only.
> 
> Paolo
> 
