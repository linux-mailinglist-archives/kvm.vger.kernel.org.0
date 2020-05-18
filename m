Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE55C1D74E8
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgERKOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:14:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgERKOb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 06:14:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IA48vX099757;
        Mon, 18 May 2020 06:14:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 313r0xrrfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 06:14:29 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IA5JXC105209;
        Mon, 18 May 2020 06:14:29 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 313r0xrrfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 06:14:29 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IAArBs014578;
        Mon, 18 May 2020 10:14:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3127t62gxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 10:14:28 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IAEQf118612668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 10:14:26 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5150E13605E;
        Mon, 18 May 2020 10:14:26 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 849CA136051;
        Mon, 18 May 2020 10:14:25 +0000 (GMT)
Received: from [9.160.58.3] (unknown [9.160.58.3])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 10:14:25 +0000 (GMT)
Subject: Re: [PATCH v4 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
 <20200518120554.6b7b04cd.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <f50aeeb0-9289-f5d8-6677-1f788bb146fc@linux.ibm.com>
Date:   Mon, 18 May 2020 06:14:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518120554.6b7b04cd.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_03:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/20 6:05 AM, Cornelia Huck wrote:
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
>>
>>> One thing though that keeps coming up: do we need any kind of
>>> serialization? Can there be any confusion from concurrent reads from
>>> userspace, or are we sure that we always provide consistent data?  
>>
>> I _think_ this is in good shape, though as suggested another set of
>> eyeballs would be nice. There is still a problem on the main
>> interrupt/FSM path, which I'm not attempting to address here.
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
> Thanks, applied.
> 
> The documentation needed a bit of fiddling (please double-check), and I
> think we want to document error codes for the schib/crw regions as
> well. I can do that if I find time, but I'd also happily merge a patch.
> 

Thank you!

I have a start for the error code documentation here. I'll finish it up
in next day or two and doublecheck the fit of this one.
