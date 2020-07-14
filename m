Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E59821EFC6
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGNLxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:53:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgGNLxE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:53:04 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EBWN0P191321;
        Tue, 14 Jul 2020 07:52:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3292umq9eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:52:57 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EBhatk046262;
        Tue, 14 Jul 2020 07:52:57 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3292umq9dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:52:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EBoPBW013635;
        Tue, 14 Jul 2020 11:52:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 327527hnjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:52:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EBqpoH59965652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 11:52:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE1134C04A;
        Tue, 14 Jul 2020 11:52:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64DCB4C050;
        Tue, 14 Jul 2020 11:52:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.162.148])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 11:52:50 +0000 (GMT)
Subject: Re: [PATCH v6 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1594726682-12076-1-git-send-email-pmorel@linux.ibm.com>
 <1594726682-12076-3-git-send-email-pmorel@linux.ibm.com>
 <f72b0978-9c66-bccc-948c-bea7df989372@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7a1da5c1-3448-9e22-e741-ea8985fba0cc@linux.ibm.com>
Date:   Tue, 14 Jul 2020 13:52:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <f72b0978-9c66-bccc-948c-bea7df989372@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-14 13:42, Christian Borntraeger wrote:
> 
> On 14.07.20 13:38, Pierre Morel wrote:
>> If protected virtualization is active on s390, the virtio queues are
>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>> negotiated. Use the new arch_validate_virtio_features() interface to
>> fail probe if that's not the case, preventing a host error on access
>> attempt.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> 
> We will probably move this (and other related code) into a new file,
> but we can do that later.
> As for now:
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
