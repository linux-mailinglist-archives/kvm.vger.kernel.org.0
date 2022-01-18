Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FF2492D58
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbiARScW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:32:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231373AbiARScV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:32:21 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHvg7l013536;
        Tue, 18 Jan 2022 18:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nXIc+BurcjMJbheQTjSBw3CQWZoO1FMRGYbXtUdLIdo=;
 b=kESWBSVi1qqTNTxOQlgMuygD2p6FNoGmkcNsrIZQd/3HzduIASnohg94stFSD0wlJx0a
 yWvIQyDHyrQj5J84f9VCEfRC/JSjNG3IzOoWLJIEWsgexHL8RNWzFIpZzPBCaw9tMMbX
 7Mqtk+oUCuyfTr7L9igfuBjx+g5X0GSUv0KJQxKfq9ScdoaTHyFKBpbgDhQkMpG1RlKy
 ebf1/rcukhXBhqtY2MERBwme/5S42qNXvBuixZ0D9T/u0aGDuRxn0BZq4pKBdypA/f87
 k5F3Uwo5u13hYGX8LteuXaCrXuG0GOiNe3qQJRqMPxNk55Q1qTsR/+na7uvrOf5kAvqZ wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp2dms4nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:32:16 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IIV2SS008226;
        Tue, 18 Jan 2022 18:32:15 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp2dms4ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:32:15 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IIHviM020629;
        Tue, 18 Jan 2022 18:32:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3dknwaqje1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:32:14 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IIWDvD31785328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:32:13 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AE546E05B;
        Tue, 18 Jan 2022 18:32:13 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE1856E05D;
        Tue, 18 Jan 2022 18:32:11 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:32:11 +0000 (GMT)
Message-ID: <c44a7ba3-37bf-6b25-1e89-719a1487ca20@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:32:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/9] s390x/pci: zPCI interpretation support
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <32c83624-eb3b-05ea-6fb6-737bd9876db3@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <32c83624-eb3b-05ea-6fb6-737bd9876db3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: axDwkrt98FfFsrlLXD9vFSJaiBdYi8hr
X-Proofpoint-GUID: UUWcwG8OkAizBPCo4zGyv7o9iVS9R8Tf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 10:23 AM, Thomas Huth wrote:
> On 14/01/2022 21.38, Matthew Rosato wrote:
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
>   Hi Matthew,
> 
> would it make sense to create a docs/system/s390x/zpci.rst doc file, 

This is a good idea and probably something that was due for zpci before 
this series even.

> too, where you could describe such new parameters like 'intassist' and 
> 'intercept' (or is it 'interp') ? ... otherwise hardly anybody except 

Oops, 'intercept' was a holdover from a previous version and effectively 
had an inverted meaning.  It is indeed 'interp' with this current series 
(and subject to change again per other thread)


