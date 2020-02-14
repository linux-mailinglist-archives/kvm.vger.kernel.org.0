Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA015D96B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBNO14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:27:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728123AbgBNO14 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:27:56 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EEPMtq143495;
        Fri, 14 Feb 2020 09:27:55 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyu8me7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 09:27:55 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EEQDV9000928;
        Fri, 14 Feb 2020 09:27:54 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyu8mdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 09:27:54 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EEPq4s010613;
        Fri, 14 Feb 2020 14:27:53 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 2y5bc06x38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 14:27:53 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EERrar43713018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 14:27:53 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEF28B2067;
        Fri, 14 Feb 2020 14:27:52 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8484BB2065;
        Fri, 14 Feb 2020 14:27:52 +0000 (GMT)
Received: from [9.160.20.216] (unknown [9.160.20.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 14:27:52 +0000 (GMT)
Subject: Re: [RFC PATCH v2 9/9] vfio-ccw: Remove inline get_schid() routine
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-10-farman@linux.ibm.com>
 <20200214142706.4d6a1efc.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <202b7945-0701-cbd2-6da3-279b63a02199@linux.ibm.com>
Date:   Fri, 14 Feb 2020 09:27:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214142706.4d6a1efc.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/20 8:27 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:25 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> This seems misplaced in the middle of FSM, returning the schid
>> field from inside the private struct.  We could move this macro
>> into vfio_ccw_private.h, but this doesn't seem to simplify things
>> that much.  Let's just remove it, and use the field directly.
> 
> It had been introduced with the first set of traces, I'm now wondering
> why, as it doesn't do any checking.

Hrm, that's a decent question.  I could refactor this, moving the
routine into vfio_ccw_private.h and add those checks, rather than
removing it outright.

I honestly only stumbled on this when I tried to use get_schid()
somewhere else, not realizing the definition was actually tucked away in
here.  And so I've left it on the end of this series as a matter of
convenience/non-forgetfulness, but splitting it out by itself would be fine.

> 
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/vfio_ccw_fsm.c | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
