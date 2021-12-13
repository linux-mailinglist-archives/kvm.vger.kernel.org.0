Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9054B472F20
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 15:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbhLMO0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 09:26:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232951AbhLMO0C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 09:26:02 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDCsVKM025467;
        Mon, 13 Dec 2021 14:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kibr89ov/HcgTKiY9mPYgwz1IUarjRNnXOw00C1Q+xA=;
 b=MlZgTPY7Y1bxDR90LEiG0I1r1RQWhGHrUUqIbYkb3XeNXrO9HEppMDSCILY4ISA+Bjn3
 k2pqyh6k+tpU8B+EsYDLEDFcQCXwhJ9nq+xF94gPR3v0P4lONr0UVHiC0+/5O4lj2QWJ
 trNq/lhdQ1qDHWWRwyZ+mithSxwwf26EBqB7mr58vmPZymMY1nwCJxOvVoonjZ07QXRW
 KTKDR/8eAiXkjQPB67Yv6pjRld2keOjlT+7hgCHkD1FG8YvS2O9qPO8F6QvgEWp6h8qn
 t+axD3n3ujRpYTOtrY4t9/1+0mer5Ysly196uVexdFiOlMhNW28LGbilC8eO17ZLRzS4 Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx5cqc02x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 14:26:00 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDDqt7n030375;
        Mon, 13 Dec 2021 14:26:00 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx5cqc02g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 14:26:00 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEOBb9019782;
        Mon, 13 Dec 2021 14:25:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3cvkm8n154-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 14:25:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDEI0UM46793122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:18:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27D3F11C050;
        Mon, 13 Dec 2021 14:25:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64B1211C054;
        Mon, 13 Dec 2021 14:25:54 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Dec 2021 14:25:54 +0000 (GMT)
Message-ID: <fbc46b35-10af-2c7e-6e47-e4987070ad83@linux.ibm.com>
Date:   Mon, 13 Dec 2021 15:26:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, gor@linux.ibm.com
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <20211122131443.66632-2-pmorel@linux.ibm.com>
 <20211209133616.650491fd@p-imbrenda> <YbImqX/NEus71tZ1@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <YbImqX/NEus71tZ1@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qsGjA7Ow13OHSb7NkX6iHBncsZ6Zj-9P
X-Proofpoint-ORIG-GUID: ZBLa6J2wrQVR7ETyp8rRyXt89foSjxM-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_06,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/21 16:54, Heiko Carstens wrote:
> On Thu, Dec 09, 2021 at 01:36:16PM +0100, Claudio Imbrenda wrote:
>> On Mon, 22 Nov 2021 14:14:43 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> We let the userland hypervisor know if the machine support the CPU
>>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>
>>> The PTF instruction will report a topology change if there is any change
>>> with a previous STSI_15_1_2 SYSIB.
>>> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
>>> inside the CPU Topology List Entry CPU mask field, which happens with
>>> changes in CPU polarization, dedication, CPU types and adding or
>>> removing CPUs in a socket.
>>>
>>> The reporting to the guest is done using the Multiprocessor
>>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>>> SCA which will be cleared during the interpretation of PTF.
>>>
>>> To check if the topology has been modified we use a new field of the
>>> arch vCPU to save the previous real CPU ID at the end of a schedule
>>> and verify on next schedule that the CPU used is in the same socket.
>>>
>>> We assume in this patch:
>>> - no polarization change: only horizontal polarization is currently
>>>    used in linux.
> 
> Why is this assumption necessary? The statement that Linux runs only
> with horizontal polarization is not true.
> 

Right, I will rephrase this as:

"Polarization change is not taken into account, QEMU intercepts queries 
for polarization change (PTF) and only provides horizontal polarization 
indication to Guest's Linux."

@Heiko, I did not find any usage of the polarization in the kernel other 
than an indication in the sysfs. Is there currently other use of the 
polarization that I did not see?



-- 
Pierre Morel
IBM Lab Boeblingen
