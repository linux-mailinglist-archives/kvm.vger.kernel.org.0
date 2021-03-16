Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62A733D1C1
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhCPK0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:26:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230259AbhCPK0S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:26:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GA35mC040661
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lEmKpxaD/0Wd7JoG54nQ9V2lAdq/hkAWr0pkXG5bAWM=;
 b=HFW4+JfXOazz7ckKeKNAJRBTNPPoAqMVeNsQkQHEo1LKn1+RTWbbLU+BMPkfeyHQnySO
 WyY3EzxgxPgenjK5AkG1ZPLoz4929qCUNQprr6S8Iax6Qz8Gtp1sjXNr68pskGk7fmwx
 vKhdZm0xkjxgHy7DbdaBs34Det/7G76vRzEZU/YBt9Oq3TxtVliYy5of13OzIwBde0KE
 FzVELcRLgZ50JbXAKGe6FTLoBr1GnEDjvu+cZE7ANuHV1RtlTiyuvaTfm6V/Hz5yjc3r
 lYvqdfaqBAaJTYDyEioqLzaA3xduTMPHnCamSByC9YDbFIPMLzRwVhNpJ6hxlQ4n9vmJ eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37add33tpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:15 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12GA3Sgn042179
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:15 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37add33tna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 06:26:14 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12GAMqiA009612;
        Tue, 16 Mar 2021 10:26:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 378n189eg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 10:26:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12GAQ9NZ41288106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 10:26:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81D4252054;
        Tue, 16 Mar 2021 10:26:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3DB8552052;
        Tue, 16 Mar 2021 10:26:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 5/6] s390x: css: testing measurement
 block format 0
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-6-git-send-email-pmorel@linux.ibm.com>
 <20210312121727.0328f7ab.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <8afc2606-d5de-62cc-b560-f2e0a9653a60@linux.ibm.com>
Date:   Tue, 16 Mar 2021 11:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312121727.0328f7ab.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/12/21 12:17 PM, Cornelia Huck wrote:
> On Fri, 12 Mar 2021 11:41:53 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We test the update of the measurement block format 0, the
>> measurement block origin is calculated from the mbo argument
>> used by the SCHM instruction and the offset calculated using
>> the measurement block index of the SCHIB.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 12 +++++++
>>   s390x/css.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 95 insertions(+)
>>
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
