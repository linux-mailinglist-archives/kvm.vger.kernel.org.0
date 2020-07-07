Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6998C216B52
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGGLTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:19:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgGGLTm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 07:19:42 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067B3uPW159667;
        Tue, 7 Jul 2020 07:19:38 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324pvda5e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:19:38 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067B4AOk160984;
        Tue, 7 Jul 2020 07:19:37 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324pvda5cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:19:37 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067B0Kbq022100;
        Tue, 7 Jul 2020 11:19:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 322hd7spx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 11:19:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067BJWIx10682768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 11:19:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93105A4062;
        Tue,  7 Jul 2020 11:19:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9378A4064;
        Tue,  7 Jul 2020 11:19:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 11:19:31 +0000 (GMT)
Subject: Re: [PATCH v4 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-3-git-send-email-pmorel@linux.ibm.com>
 <20200707114633.68122a00.cohuck@redhat.com>
 <20200707060838-mutt-send-email-mst@kernel.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <64057bea-2239-1374-b371-abd7256a32bf@linux.ibm.com>
Date:   Tue, 7 Jul 2020 13:19:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707060838-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_07:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 phishscore=0 cotscore=-2147483648 impostorscore=0 mlxlogscore=906
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007070085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-07 13:14, Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2020 at 11:46:33AM +0200, Cornelia Huck wrote:
>> On Tue,  7 Jul 2020 10:44:37 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> S390, protecting the guest memory against unauthorized host access
>>> needs to enforce VIRTIO I/O device protection through the use of
>>> VIRTIO_F_VERSION_1 and VIRTIO_F_IOMMU_PLATFORM.
>>
>> Hm... what about:
>>
>> "If protected virtualization is active on s390, the virtio queues are
>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>> negotiated. Use the new arch_validate_virtio_features() interface to
>> enforce this."
> 
> s/enforce this/fail probe if that's not the case, preventing a host error on access attempt/
> 

yes, more complete, thanks.

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
