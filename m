Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8A3568F8
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350611AbhDGKGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:06:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346625AbhDGKGT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:06:19 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137A3bEB120368
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=njh0Kku3iNCpNeeXrerTuJ/OrNXGDuwdUwQnH79l/6A=;
 b=KKFHu4ukkBcj6X9hYz+BdX1Jo4kR6XiehfKH6iW8mtT+9/Ec2t77TKu3lvicgQEm+lcu
 SWQuD7wjobjqJLBkIDlUMWTpg/nakbA3H7l2H3EtXCXjv/afLOr7wQ++xIOBC7O0WAYB
 WnMF9NF81PSDjbCMjpZBbET+OTiAdGtO/C3n9i81wo21z9HFYf6s5cwmmBCi+0NuQr2O
 uIpyA3GmEES8PtPP7AHSxBc7mKj+i7jpsj+STY+K7FK5bC5AJTcIPsGwwPVJXdUh/snu
 NiX+UZeQJkj3mQoQ5vIMGmEdr38shCQB1q6cdz+AfJcJUousgQRNj+PAwLPHvCHRvug9 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvumkhsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:06:09 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137A48EU122719
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:06:09 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvumkhrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 06:06:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137A3CtK006497;
        Wed, 7 Apr 2021 10:06:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37rvbu8kq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:06:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137A63iG29557212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 10:06:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2B11AE045;
        Wed,  7 Apr 2021 10:06:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95EF5AE053;
        Wed,  7 Apr 2021 10:06:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 10:06:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 11/16] s390x: css: No support for MIDAW
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
 <1617694853-6881-12-git-send-email-pmorel@linux.ibm.com>
 <20210406175805.304b8abb.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6112a74d-1536-830c-e665-64f508462f0f@linux.ibm.com>
Date:   Wed, 7 Apr 2021 12:06:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406175805.304b8abb.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T2QWaznXW9TntEu9NjrKrVOxT4kolawE
X-Proofpoint-ORIG-GUID: ysUvH5nL3D9IinoAIaAMTYYA1siCDlOp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/21 5:58 PM, Cornelia Huck wrote:
> On Tue,  6 Apr 2021 09:40:48 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Verify that using MIDAW triggers a operand exception.
> 
> This is only for current QEMU; a future QEMU or another hypervisor may
> support it. I think in those cases the failure mode may be different
> (as the ccw does not use midaws?)

Yes, should I let fall this test case?




-- 
Pierre Morel
IBM Lab Boeblingen
