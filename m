Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DCC45047A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 13:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhKOMiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 07:38:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230438AbhKOMh4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 07:37:56 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBrtdq011652;
        Mon, 15 Nov 2021 12:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=iY1Col5FMwaQrAzLqIT+kCvknRgj+GHBiwaP932CpAc=;
 b=rHm01J9/yZtsmLfgZWnmsAXOyv63fwmQu1nqKqVaZlS5njoWrYRB+hOWtRj2Q4zgX3iJ
 KbHu6bkbviPkKCNV3rZCPKXpd/qhIqKCAJ3xqrihYkCuYSvLcrCHeW5fkwzbf/b2O6nk
 ci+a50UTTB+kf0KxKePW3kBsMXDSO8WWnVmc7Gl+uY5n9RbydndMz7JdfMYBF6S6pWbC
 asEE8oJ3tp6R90J06aKYMEwlc3FKXQQMaRPxakufQawFkceGX6aTveYZG31Q8Pvn2zQ9
 APDMX22OYR3NE7AKukdevwffNueZNTjR3EQiFbWRkgfUWtH3faMIlNIpr3lW2h7Jo8it Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbq348tva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:34:04 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AFBsE1K016059;
        Mon, 15 Nov 2021 12:34:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbq348tup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:34:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFCJ8oN002492;
        Mon, 15 Nov 2021 12:34:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3ca509cqq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:34:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFCXwha27787704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 12:33:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53F7E4204D;
        Mon, 15 Nov 2021 12:33:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72B9D4205F;
        Mon, 15 Nov 2021 12:33:57 +0000 (GMT)
Received: from [9.171.56.111] (unknown [9.171.56.111])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 12:33:57 +0000 (GMT)
Message-ID: <ecd55383-7089-b3cd-30cc-3f9feb7eadb4@de.ibm.com>
Date:   Mon, 15 Nov 2021 13:33:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and
 re-purpose it on x86
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F_7VLECjtzfz58UlopgCykV9hLKIwLBB
X-Proofpoint-GUID: Xk7vY1f_lcFudvzcJVI-5_sBZtDokgNi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.11.21 um 17:32 schrieb Paolo Bonzini:
> On 11/11/21 17:27, Vitaly Kuznetsov wrote:
>> This is a comtinuation of "KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS"
>> (https://lore.kernel.org/kvm/20211111134733.86601-1-vkuznets@redhat.com/)
>> work.
>>
>> 1) Enforce KVM_CAP_NR_VCPUS <= KVM_CAP_MAX_VCPUS rule on all
>>   architectures. [Sean Christopherson]
>> 2) Make KVM_CAP_NR_VCPUS return num_online_cpus() and not an arbitrary
>>   value of '710' on x86.
>>
>> Everything but x86 was only 'eyeball tested', the change is trivial
>> but sorry in advance if I screwed up)
> 
> Christian, can you look at this for s390?  Returning a fixed value seems wrong for KVM_CAP_NR_VCPUS.

If we talk about recommended number, then num_online_cpus() also seems to make sense on s390 so
if you change that for s390 as well I can ACK this.
