Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB788D79D1
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfJOPap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 11:30:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732659AbfJOPap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 11:30:45 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9FFECGT055402;
        Tue, 15 Oct 2019 11:30:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vnfd8kt0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 11:30:43 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9FFFcu6068884;
        Tue, 15 Oct 2019 11:30:43 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vnfd8ksyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 11:30:43 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9FFUJYi001937;
        Tue, 15 Oct 2019 15:30:42 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 2vk6f8uns4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 15:30:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FFUf3q40567292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 15:30:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A9D8AE05C;
        Tue, 15 Oct 2019 15:30:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD8AAE066;
        Tue, 15 Oct 2019 15:30:40 +0000 (GMT)
Received: from [9.85.147.229] (unknown [9.85.147.229])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Oct 2019 15:30:40 +0000 (GMT)
Subject: Re: [RFC PATCH 1/4] vfio-ccw: Refactor how the traces are built
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-2-farman@linux.ibm.com>
 <20191015154645.2c35dd32.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <893da89b-83d5-ceee-e058-d8721d19d27f@linux.ibm.com>
Date:   Tue, 15 Oct 2019 11:30:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015154645.2c35dd32.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/15/19 9:46 AM, Cornelia Huck wrote:
> On Mon, 14 Oct 2019 20:08:52 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Commit 3cd90214b70f ("vfio: ccw: add tracepoints for interesting error
>> paths") added a quick trace point to determine where a channel program
>> failed while being processed.  It's a great addition, but adding more
>> traces to vfio-ccw is more cumbersome than it needs to be.
>>
>> Let's refactor how this is done, so that additional traces are easier
>> to add and can exist outside of the FSM if we ever desire.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/Makefile         |  4 ++--
>>  drivers/s390/cio/vfio_ccw_cp.h    |  1 +
>>  drivers/s390/cio/vfio_ccw_fsm.c   |  3 ---
>>  drivers/s390/cio/vfio_ccw_trace.c | 12 ++++++++++++
>>  drivers/s390/cio/vfio_ccw_trace.h |  2 ++
>>  5 files changed, 17 insertions(+), 5 deletions(-)
>>  create mode 100644 drivers/s390/cio/vfio_ccw_trace.c
> 
> Looks good.
> 
> I'm wondering whether we could consolidate tracepoints and s390dbf
> usage somehow. These two complement each other in a way (looking at a
> live system vs. looking at a crash dump, integration with other parts
> of the system), but they currently also cover at least partially
> different code paths. Not sure how much sense it makes to have double
> coverage at least for a subset of the functionality.
> 

Yeah, there's gaps that could/should be closed, and maybe this patch
makes it easier to add traces to paths that s390dbf currently cover and
could benefit from having both.  Some more consideration of what is
covered and where, and what is missing, is certainliy needed.

 - Eric
