Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B231B3573
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 05:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDVDKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 23:10:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726324AbgDVDKY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 23:10:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M32jMr140578;
        Tue, 21 Apr 2020 23:10:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggr36ffm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 23:10:22 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03M32nXh140898;
        Tue, 21 Apr 2020 23:10:22 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggr36ffa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 23:10:22 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03M31uFs007729;
        Wed, 22 Apr 2020 03:10:21 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 30fs66nqe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 03:10:21 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M3ALk553739994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:10:21 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5973AE05C;
        Wed, 22 Apr 2020 03:10:20 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F215AE05F;
        Wed, 22 Apr 2020 03:10:20 +0000 (GMT)
Received: from [9.65.254.167] (unknown [9.65.254.167])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 03:10:20 +0000 (GMT)
Subject: Re: [PATCH v3 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
 <20200421173544.36b48657.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <8acd4662-5a8b-ceda-108f-ed2cfac8dcee@linux.ibm.com>
Date:   Tue, 21 Apr 2020 23:10:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421173544.36b48657.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_10:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220024
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/20 11:35 AM, Cornelia Huck wrote:
> On Fri, 17 Apr 2020 04:29:53 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Here is a new pass at the channel-path handling code for vfio-ccw.
>> Changes from previous versions are recorded in git notes for each patch.
>>
>> I dropped the "Remove inline get_schid()" patch from this version.
>> When I made the change suggested in v2, it seemed rather frivolous and
>> better to just drop it for the time being.
>>
>> I suspect that patches 5 and 7 would be better squashed together, but I
>> have not done that here.  For future versions, I guess.
> 
> The result also might get a bit large.

True.

Not that someone would pick patch 5 and not 7, but vfio-ccw is broken
between them, because of a mismatch in IRQs.  An example from hotplug:

error: internal error: unable to execute QEMU command 'device_add':
vfio: unexpected number of irqs 1

Maybe I just pull the CRW_IRQ definition into 5, and leave the wiring of
the CRW stuff in 7.  That seems to leave a better behavior.

> 
>>
>> With this, and the corresponding QEMU series (to be posted momentarily),
>> applied I am able to configure off/on a CHPID (for example, by issuing
>> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
>> events and reflect the updated path masks in its structures.
> 
> Basically, this looks good to me (modulo my comments).

Woo!  Thanks for the feedback; I'm going to try to get them all
addressed in the next couple of days.

> 
> One thing though that keeps coming up: do we need any kind of
> serialization? Can there be any confusion from concurrent reads from
> userspace, or are we sure that we always provide consistent data?
> 

I'm feeling better with the rearrangement in this version of how we get
data from the queue of CRWs into the region and off to the guest.  The
weirdness I described a few months ago seems to have been triggered by
one of the patches that's now been dropped.  But I'll walk through this
code again once I get your latest comments applied.
