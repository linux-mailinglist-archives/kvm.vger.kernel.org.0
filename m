Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA483472879
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhLMKNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:13:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241682AbhLMKFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:05:07 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BD9vkNl004542;
        Mon, 13 Dec 2021 10:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6CGYLc1xNdrHtFcxv7O7p0PZOmm8ac/QPQD4TYfJJbM=;
 b=OY+05C/1+ClrIU0Wiz8jpHzcGnFic9/vQ1MXh56izcbLSsPHycQ85uVq8uWrN+1HiTK8
 nlZ/iSw+LOPKYcS0xjJTwE3+kOBA8BGyk5tPcjfULCyYjQvbyGmIMMWGM6ifYHTWa3Dv
 QhIEYwq/r/g9YeGVtUDOeHwiI0sbDS5vGz+H+jbUZpsPekeudUI7wXYK/VXLjLEvNIbM
 Gp3mudIEV4JPdCua4WctrudSdaeD6Ftf9elO/DKKEkyS/vwpVsAUNw6VM0aHQRct0ND/
 JCeyp2HFst+lFXvlXjqCwLdLeVQB72FP0rYLgbgSeMuk/BwUxNLcqalPOMSP3mhKEL1M +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx40mg47n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:05:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDA0VSg014545;
        Mon, 13 Dec 2021 10:05:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx40mg46m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:05:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDA31Jh026874;
        Mon, 13 Dec 2021 10:05:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3cvkm92h34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:04:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BD9v26Z23724516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 09:57:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38F9C11C064;
        Mon, 13 Dec 2021 10:04:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A153B11C074;
        Mon, 13 Dec 2021 10:04:55 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Dec 2021 10:04:55 +0000 (GMT)
Message-ID: <67908963-76ad-8400-c6c2-24f70da3af8d@linux.ibm.com>
Date:   Mon, 13 Dec 2021 11:05:59 +0100
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
X-Proofpoint-GUID: rnNuXZzttlUbykPMmtGBCFN6qaDd_BzO
X-Proofpoint-ORIG-GUID: smVw9YNjx-0WLtG9y50VJzW6KB6iTBK3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_03,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130065
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

Oh OK, I will change this and take a look at the implications.

Thanks,
Pierre

> 

-- 
Pierre Morel
IBM Lab Boeblingen
