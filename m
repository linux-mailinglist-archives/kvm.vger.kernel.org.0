Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7839234199C
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 11:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhCSKLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 06:11:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhCSKLK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 06:11:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JA39eJ008616
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 06:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yEx26G8oAQ+1E/dln0dD2t+gbtCbLtcos/qRVFK9Qh8=;
 b=Sx+Pakt5TNju1IdQmjBUb4lnorwsDoOOME7pvV0qPIgRHJdHHC5eRJSPeXsVIFnLE0XT
 HhT/MpSrvfNHGjJwgTAabkUImM/TNPIlW86EyJKFEzhhFWNLEjwHIzin/TFbRGj/KKOk
 Irs1Fx2aR9OOtIsxDzoCHCGR39haHOrm+rq+pbhBUIS1oxj7zYKCh2MPPbPl6lH8Y74G
 7RGD2e/MkylXDvWRs/DaDVC5zLP0Lp6lkkrlh11KHOBCQtp+R9s0AAkFHsiq8oEGuZ9O
 XZqc+ffbsmPxaK9P4TotLLl95UDWJFF6vTEkQJ0yQ/VD0xfI4za+OUpJ0WSbaLj5ZBNK sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vq6fh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 06:11:09 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JA3SDs009806
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 06:11:09 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vq6fgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 06:11:09 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JA8KeQ020111;
        Fri, 19 Mar 2021 10:11:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 37brpfrsg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 10:11:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JAB4YC31981850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 10:11:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33499A4054;
        Fri, 19 Mar 2021 10:11:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E719BA406B;
        Fri, 19 Mar 2021 10:11:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.79])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 10:11:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/6] s390x: lib: css: disabling a
 subchannel
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-2-git-send-email-pmorel@linux.ibm.com>
 <20210319110327.48ca8f8a.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <0ee4dd2f-7bd0-4b9f-59c5-a07f5d1cc007@linux.ibm.com>
Date:   Fri, 19 Mar 2021 11:11:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319110327.48ca8f8a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxlogscore=948 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 11:03 AM, Cornelia Huck wrote:
> On Thu, 18 Mar 2021 14:26:23 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 70 insertions(+)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
