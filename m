Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CCE3FB5A5
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhH3MGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:06:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237051AbhH3MGJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:06:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17UC42Lk169121;
        Mon, 30 Aug 2021 08:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y5H+fFogofucQYpVp4keglQZDmK0zcRTHtHkdIFs9RU=;
 b=SqKmKmNrLDdqSpzSTjzmyI1UNiZbmUnamNijkOT8kHM8LonnnTGPDBL1LNXQMeKTDs7A
 Jfc4wDBqNDS/jydK7Pyr12cjiOA6VZldhoi0afaa1tRnDNn1LtLBTF72Fns6j321H3CK
 advbLiCR2ba5w/7+MM6CrLsO0ZfAGaOCHJppV71ZvqEm6xXKNV7zC3ZHINvPcEMPEhfj
 50LWplla3BJaSvG2uTLd5IvEsCT14BmsmKHNNruCUL1K1oXqbBFm86l5Jtbs9ynJqQpA
 JDSnb3q5YfmTSlTe8V877AiiwkO2vL38xtOPf0cjggK8enKLWnYVPHt5xQ4jf+eTCKDK +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3arwpxt3w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 08:05:10 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17UC5AY0178018;
        Mon, 30 Aug 2021 08:05:10 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3arwpxt3v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 08:05:10 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17UBucbk014529;
        Mon, 30 Aug 2021 12:05:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3aqcs8awgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 12:05:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17UC53oj18940192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 12:05:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7917C4C075;
        Mon, 30 Aug 2021 12:05:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D3F4C06D;
        Mon, 30 Aug 2021 12:05:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.184])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Aug 2021 12:05:02 +0000 (GMT)
Subject: Re: [PATCH 0/2] s390x: ccw: A simple test device for virtio CCW
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, Michael S Tsirkin <mst@redhat.com>
Cc:     thuth@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, richard.henderson@linaro.org,
        drjones@redhat.com, qemu-devel@nongnu.org, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, imbrenda@linux.ibm.com
References: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
 <fe2c0cbd-24a6-0785-6a64-22c6b6c01e6d@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <cd2df86d-793e-48ca-7f67-9db8e9439b2b@linux.ibm.com>
Date:   Mon, 30 Aug 2021 14:05:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <fe2c0cbd-24a6-0785-6a64-22c6b6c01e6d@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AAKs2K-QVxX9SLHWyDJcCPziSYtvbHDx
X-Proofpoint-ORIG-GUID: 1mjDDIWDRh7Z02hEXHklvlEDxkAgBMIn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-30_04:2021-08-30,2021-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108300087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/30/21 11:51 AM, Christian Borntraeger wrote:
> 
> 
> On 27.08.21 12:50, Pierre Morel wrote:
>> Hello All,
>>
>>
>> This series presents a VIRTIO test device which receives data on its
>> input channel and sends back a simple checksum for the data it received
>> on its output channel.
>> The goal is to allow a simple VIRTIO device driver to check the VIRTIO
>> initialization and various data transfer.
>>
>> For this I introduced a new device ID for the device and having no
>> Linux driver but a kvm-unit-test driver, I have the following
>> questions:
> 
> I think we should reserve an ID in the official virtio spec then for 
> such a device?

Yes, you are right, I think we should.

> Maybe also add mst for such things.

Yes, I did.

Thanks,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
