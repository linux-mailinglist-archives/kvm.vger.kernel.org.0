Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2811C561E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgEENA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 09:00:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24029 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728268AbgEENA1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 09:00:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CZjf6018171;
        Tue, 5 May 2020 09:00:27 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45tu31t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 09:00:25 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045CaATw020820;
        Tue, 5 May 2020 09:00:24 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45tu2yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 09:00:23 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CtnAm007314;
        Tue, 5 May 2020 13:00:21 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 30s0g6rqgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 13:00:21 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045D0LMY49152264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 13:00:21 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BDCF12405B;
        Tue,  5 May 2020 13:00:21 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96862124060;
        Tue,  5 May 2020 13:00:20 +0000 (GMT)
Received: from [9.160.31.2] (unknown [9.160.31.2])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 13:00:20 +0000 (GMT)
Subject: Re: [PATCH v4 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
 <20200505145435.40113d4c.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <14c3cf68-c1e5-b46f-d75e-955dbdd63df8@linux.ibm.com>
Date:   Tue, 5 May 2020 09:00:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505145435.40113d4c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/20 8:56 AM, Cornelia Huck wrote:
> On Tue,  5 May 2020 14:27:37 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Here is a new pass at the channel-path handling code for vfio-ccw.
>> Changes from previous versions are recorded in git notes for each patch.
>> Patches 5 through 7 got swizzled a little bit, in order to better
>> compartmentalize the code they define. Basically, the IRQ definitions
>> were moved from patch 7 to 5, and then patch 6 was placed ahead of
>> patch 5.
>>
>> I have put Conny's r-b's on patches 1, 3, 4, (new) 5, and 8, and believe
>> I have addressed all comments from v3, with two exceptions:
>>
>>> I'm wondering if we should make this [vfio_ccw_schib_region_{write,release}]
>>> callback optional (not in this patch).  
>>
>> I have that implemented on top of this series, and will send later as part
>> of a larger cleanup series.
> 
> Good, sounds reasonable.
> 
>>
>>> One thing though that keeps coming up: do we need any kind of
>>> serialization? Can there be any confusion from concurrent reads from
>>> userspace, or are we sure that we always provide consistent data?  
>>
>> I _think_ this is in good shape, though as suggested another set of
>> eyeballs would be nice. There is still a problem on the main
>> interrupt/FSM path, which I'm not attempting to address here.
> 
> I'll try to think about it some more.

Re: interrupt/FSM, I now have two separate patches that each straighten
things out on their own.  And a handful of debug patches that probably
only make things worse.  :)  I'll get one/both of those meaningful
patches sent to the list so we can have that discussion separately from
this code.

> 
>>
>> With this code plus the corresponding QEMU series (posted momentarily)
>> applied I am able to configure off/on a CHPID (for example, by issuing
>> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
>> events and reflect the updated path masks in its structures.
>>
>> v3: https://lore.kernel.org/kvm/20200417023001.65006-1-farman@linux.ibm.com/
>> v2: https://lore.kernel.org/kvm/20200206213825.11444-1-farman@linux.ibm.com/
>> v1: https://lore.kernel.org/kvm/20191115025620.19593-1-farman@linux.ibm.com/
>>
>> Eric Farman (3):
>>   vfio-ccw: Refactor the unregister of the async regions
>>   vfio-ccw: Refactor IRQ handlers
>>   vfio-ccw: Add trace for CRW event
>>
>> Farhan Ali (5):
>>   vfio-ccw: Introduce new helper functions to free/destroy regions
>>   vfio-ccw: Register a chp_event callback for vfio-ccw
>>   vfio-ccw: Introduce a new schib region
>>   vfio-ccw: Introduce a new CRW region
>>   vfio-ccw: Wire up the CRW irq and CRW region
>>
>>  Documentation/s390/vfio-ccw.rst     |  38 ++++++-
>>  drivers/s390/cio/Makefile           |   2 +-
>>  drivers/s390/cio/vfio_ccw_chp.c     | 148 +++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 165 ++++++++++++++++++++++++++--
>>  drivers/s390/cio/vfio_ccw_ops.c     |  65 ++++++++---
>>  drivers/s390/cio/vfio_ccw_private.h |  16 +++
>>  drivers/s390/cio/vfio_ccw_trace.c   |   1 +
>>  drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
>>  include/uapi/linux/vfio.h           |   3 +
>>  include/uapi/linux/vfio_ccw.h       |  18 +++
>>  10 files changed, 458 insertions(+), 28 deletions(-)
>>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
>>
> 
