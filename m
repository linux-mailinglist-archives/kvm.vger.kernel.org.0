Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A887268722
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgINIXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 04:23:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgINIXT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 04:23:19 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E83gIU182934;
        Mon, 14 Sep 2020 04:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ia2xoZWuCYpL76lyzhv4kCcuFhG1ZdZJGayL4NCUbTg=;
 b=n//a407UpuYZylocjDNsyKy7xjwkHkCi29u2eAslqi7ixBdCvhPWU2Qclv7wEmBIe/wP
 v/mWFIojmOZcLkB7aAfKEePFWX5G5oYho8qvL6homlo58L+4yOQ2x+q7HfF6gojA8k62
 0r4cbNpCJhKrL1nxMsjr4D+MXsTx1aa8SDcQkycyq4fyytcMpNTtPXUXwi6sCOeMvCmZ
 H+y1abDCUhr3NipW7W4b0pGAd6GzYQQEEhp1mAM8R6Kpwmcs8Bx3VMZ/LXoQvfoc+rXc
 Z7YhE74WA2t8XrxYnazQh5o4zCRWUUdJX1JrM6oxUQmZUkQrZQbk3NvEx1f4Rjnd2Q6U NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j21k4bu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:23:18 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E83jwj183011;
        Mon, 14 Sep 2020 04:23:18 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j21k4bte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:23:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E8MP73013804;
        Mon, 14 Sep 2020 08:23:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33gny8a1ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 08:23:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E8NDDD18350528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 08:23:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A006AE04D;
        Mon, 14 Sep 2020 08:23:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176E6AE045;
        Mon, 14 Sep 2020 08:23:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 08:23:13 +0000 (GMT)
Subject: Re: [PATCH v1 2/3] s390: define UV compatible I/O allocation
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1598875533-19947-1-git-send-email-pmorel@linux.ibm.com>
 <1598875533-19947-3-git-send-email-pmorel@linux.ibm.com>
 <20200911144058.5fe82f26.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4e09343a-6eed-7270-2157-dc65f4fb47aa@linux.ibm.com>
Date:   Mon, 14 Sep 2020 10:23:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911144058.5fe82f26.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 suspectscore=2 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-09-11 14:40, Cornelia Huck wrote:
> On Mon, 31 Aug 2020 14:05:32 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> To centralize the memory allocation for I/O we define
>> the alloc/free_io_page() functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.

...

>> +
>> +void *alloc_io_page(int size)
>> +{
>> +	void *p;
>> +
>> +	assert(size <= PAGE_SIZE);
>> +	p = alloc_page();
> 
> I see that you use this for some I/O structures in the next patch. Is
> this guaranteed to be under 2G all the time?
> 

Good catch.
I forgot that I already worked on this problem a while ago, I will 
rework the allocation.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
