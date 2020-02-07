Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C948F15586A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgBGN1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 08:27:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23414 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbgBGN1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 08:27:00 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017DHixq038530;
        Fri, 7 Feb 2020 08:26:59 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nru82nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 08:26:58 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017DHoOe038927;
        Fri, 7 Feb 2020 08:26:57 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nru82jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 08:26:56 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017DP5qk004757;
        Fri, 7 Feb 2020 13:26:52 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 2xykc9wf65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 13:26:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017DQo4d59113738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 13:26:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6D716E050;
        Fri,  7 Feb 2020 13:26:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 175406E053;
        Fri,  7 Feb 2020 13:26:50 +0000 (GMT)
Received: from [9.160.40.56] (unknown [9.160.40.56])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 13:26:49 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/9] s390x/vfio-ccw: Channel Path Handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200207101220.2d057f18.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <1018eade-df1b-a24c-466c-c9c2ea72c2fb@linux.ibm.com>
Date:   Fri, 7 Feb 2020 08:26:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200207101220.2d057f18.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/20 4:12 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:16 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Here is a new pass at the channel-path handling code for vfio-ccw.
>> This was initially developed by Farhan Ali this past summer, and
>> picked up by me.  For my own benefit/sanity, I made a small changelog
>> in the commit message for each patch, describing the changes I've
>> made to his original code beyond just rebasing to master, rather than
>> a giant list appended here.
>>
>> I had been encountering a host crash which I think was triggered by
>> this code rather than existing within it.  I'd sent a potential fix
>> for that separately, but need more diagnosis.  So while that is
>> outstanding, I think I've gotten most (but probably not all) comments
>> from v1 addressed within.
>>
>> With this, and the corresponding QEMU series (to be posted momentarily),
>> applied I am able to configure off/on a CHPID (for example, by issuing
>> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
>> events and reflect the updated path masks in its structures.
>>
>> For reasons that are hopefully obvious, issuing chchp within the guest
>> only works for the logical vary.  Configuring it off/on does not work,
>> which I think is fine.
> 
> Before I delve into this: While the basic architecture here (and in the
> QEMU part) is still similar, you changed things like handling multiple
> CRWs? That's at least the impression I got from a very high-level skim.

I hope so.  :)

I'm not chaining any CRWs together using the CRW.C flag, since that will
expose other more interesting problems if we go beyond two.  It should
help handle the "guest processes one while another is added" scenario,
even though I've got some racing during the management of the list itself.

> 
>>
>> v1: https://lore.kernel.org/kvm/20191115025620.19593-1-farman@linux.ibm.com/
>>
>> Eric Farman (4):
>>   vfio-ccw: Refactor the unregister of the async regions
>>   vfio-ccw: Refactor IRQ handlers
>>   vfio-ccw: Add trace for CRW event
>>   vfio-ccw: Remove inline get_schid() routine
>>
>> Farhan Ali (5):
>>   vfio-ccw: Introduce new helper functions to free/destroy regions
>>   vfio-ccw: Register a chp_event callback for vfio-ccw
>>   vfio-ccw: Introduce a new schib region
>>   vfio-ccw: Introduce a new CRW region
>>   vfio-ccw: Wire up the CRW irq and CRW region
>>
>>  Documentation/s390/vfio-ccw.rst     |  31 ++++-
>>  drivers/s390/cio/Makefile           |   2 +-
>>  drivers/s390/cio/vfio_ccw_chp.c     | 136 ++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 186 ++++++++++++++++++++++++++--
>>  drivers/s390/cio/vfio_ccw_fsm.c     |   8 +-
>>  drivers/s390/cio/vfio_ccw_ops.c     |  65 +++++++---
>>  drivers/s390/cio/vfio_ccw_private.h |  16 +++
>>  drivers/s390/cio/vfio_ccw_trace.c   |   1 +
>>  drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
>>  include/uapi/linux/vfio.h           |   3 +
>>  include/uapi/linux/vfio_ccw.h       |  19 +++
>>  11 files changed, 463 insertions(+), 34 deletions(-)
>>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
>>
> 
