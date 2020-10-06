Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80C2285019
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 18:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJFQnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 12:43:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43574 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgJFQnv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 12:43:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 096GY1Hx130363;
        Tue, 6 Oct 2020 12:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6fBu163/RX6BbYHQSuxFl5MRtXVdZH8OGOOYZn+xBB8=;
 b=c/bH43McqehtycNkOvLnT/7qk2TslqufeS873QwMJDMVath1w5NIYZ2VW7lR8QEsurYo
 lPTVfQue0X2rY4+P7vp9JOYcPWuaYo4Q9LWR3XWnxG/TeRcpHE0K9VHmu+a5pLhpIht0
 AjlXZqhc+mM8zWDCxua/ZliM2MFG+QySaQzdwgsox/w1/8akb3f/cdWiifStgq4zReZd
 FGlHoehjo8JRhLZbpAuBGAEpcQr2Qsrs4ZsELKHG7xmGYvQ2lfUjbgxPMpi+3rJ5PLU1
 XuSE9cxAuabpEMyaIPUZCio1H4IorLcVv2MvdA935jytJIW4cD0RrzsMlGjcstHJcuTc 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340v5v0a98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 12:43:44 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 096GY5tS130837;
        Tue, 6 Oct 2020 12:43:44 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340v5v0a8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 12:43:44 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 096GfRZM027954;
        Tue, 6 Oct 2020 16:43:43 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 33xgx9f31f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 16:43:43 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 096Ghgdo52560238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Oct 2020 16:43:42 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B1B4112062;
        Tue,  6 Oct 2020 16:43:42 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2919D112061;
        Tue,  6 Oct 2020 16:43:40 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Oct 2020 16:43:39 +0000 (GMT)
Subject: Re: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
 <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
 <20201006173259.1ec36597.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <e9f6c3e1-9341-b0d0-9fb2-b34ebd19bcba@linux.ibm.com>
Date:   Tue, 6 Oct 2020 12:43:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201006173259.1ec36597.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_09:2020-10-06,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/20 11:32 AM, Cornelia Huck wrote:
> On Fri,  2 Oct 2020 16:06:23 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Seems a more appropriate location for them.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c          |   4 +-
>>   hw/s390x/s390-pci-bus.h          | 372 ---------------------------------------
>>   hw/s390x/s390-pci-inst.c         |   4 +-
>>   hw/s390x/s390-pci-inst.h         | 312 --------------------------------
>>   hw/s390x/s390-virtio-ccw.c       |   2 +-
>>   include/hw/s390x/s390-pci-bus.h  | 372 +++++++++++++++++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-inst.h | 312 ++++++++++++++++++++++++++++++++
>>   7 files changed, 689 insertions(+), 689 deletions(-)
>>   delete mode 100644 hw/s390x/s390-pci-bus.h
>>   delete mode 100644 hw/s390x/s390-pci-inst.h
>>   create mode 100644 include/hw/s390x/s390-pci-bus.h
>>   create mode 100644 include/hw/s390x/s390-pci-inst.h
> 
> Looks good, but...
> 
> <meta>Is there any way to coax out a more reviewable version of this
> via git mv?</meta>
> 

I tried git mv, but a diff between the old patch and the new patch looks 
the same (other than the fact that I squashed the MAINTAINERS hit in)

