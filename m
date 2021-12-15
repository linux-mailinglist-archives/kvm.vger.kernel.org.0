Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF21475C4A
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 16:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbhLOPx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 10:53:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244197AbhLOPxz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 10:53:55 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFFEASE030090;
        Wed, 15 Dec 2021 15:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Sa/aIP84wBnYppxw+j62IKiwnFnJMwmiqzz4WKJn7Tg=;
 b=m5Y6fOvtBf3M5l/+NTKnTZnIjcjYDlygKK3OSvZ1KFRFdrC5HqjPasPYGfG7BvSwqDFl
 d4iYWoz0PazfwYNaBkkQWhr72RkgXvrErJVVG3EQLskb24QNB45vfN4V8/v2dCuVkOCY
 3FoyTYvVWl0soH9kuWxIvjzIqYDk7gYBVgEN21sdUmVF5kz9iNaPcTPgbW+naA44kI7/
 h4wxk4h6aIiasG9mvPV1sX2h2wPkRsmz4WVFjHAT3PmBaOdUlp2FqoRggar6kwEkMoJl
 n7hHkLzQ+NB0z05uScVjDGRCOccd6XiwO+I/sEyCNPoxKE7Uw/Db/N1zyBM7KUhbbVik 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cygtrv65c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:53:46 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BFFEFCC030658;
        Wed, 15 Dec 2021 15:53:46 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cygtrv655-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:53:46 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFFrEnT030423;
        Wed, 15 Dec 2021 15:53:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3cy770hnch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:53:45 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFFrhHc13959676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 15:53:43 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 917006A051;
        Wed, 15 Dec 2021 15:53:43 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4807C6A05F;
        Wed, 15 Dec 2021 15:53:42 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 15:53:42 +0000 (GMT)
Message-ID: <6103b709-f29d-16f2-7fe6-f9a25dd85b89@linux.ibm.com>
Date:   Wed, 15 Dec 2021 10:53:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/12] s390x/pci: zPCI interpretation support
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <e1ba4cce-d6b9-bc86-9999-dc135046129d@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <e1ba4cce-d6b9-bc86-9999-dc135046129d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rZTakHygPATYXQMgPqBIpS7KJEG0lFFD
X-Proofpoint-GUID: JJzUQk76eFw-7sT_0yiC6hgY_bOoacpZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_10,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 2:35 AM, Pierre Morel wrote:
> 
> 
> On 12/7/21 22:04, Matthew Rosato wrote:
>> Note:  The first 3 patches of this series are included as pre-reqs, but
>> should be pulled via a separate series.  Also, patch 5 is needed to
>> support 5.16+ linux header-sync and was already done by Paolo but not
>> merged yet so is thus included here as well.
>>
>> For QEMU, the majority of the work in enabling instruction interpretation
>> is handled via new VFIO ioctls to SET the appropriate interpretation and
>> interrupt forwarding modes, and to GET the function handle to use for
>> interpretive execution.
>>
>> This series implements these new ioctls, as well as adding a new, 
>> optional
>> 'intercept' parameter to zpci to request interpretation support not be 
>> used
>> as well as an 'intassist' parameter to determine whether or not the
>> firmware assist will be used for interrupt delivery or whether the host
>> will be responsible for delivering all interrupts.
> 
> In which circumstances do we have an added value by not using interrupt 
> delivered by firmware?
> 

Disabling it can be a tool to debug and assist in problem determination, 
but that's about the only scenario I can think of where you would 
intentionally want to disable intassist.  Perhaps then it's not worth 
leaving in place.

