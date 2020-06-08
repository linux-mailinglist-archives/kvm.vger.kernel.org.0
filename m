Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294501F1BB9
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgFHPKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 11:10:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730127AbgFHPKe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 11:10:34 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058F3Vfb063443;
        Mon, 8 Jun 2020 11:10:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7p49eru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 11:10:11 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058F4Zs0075960;
        Mon, 8 Jun 2020 11:10:10 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7p49ep6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 11:10:10 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058F4msY019331;
        Mon, 8 Jun 2020 15:10:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 31g2s8krpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 15:10:08 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058FA8jh41812398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 15:10:08 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDB10AC08D;
        Mon,  8 Jun 2020 15:10:07 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E7ACAC08A;
        Mon,  8 Jun 2020 15:10:05 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.136.248])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jun 2020 15:10:05 +0000 (GMT)
References: <20200521034304.340040-1-david@gibson.dropbear.id.au> <87tuzr5ts5.fsf@morokweng.localdomain> <20200604062124.GG228651@umbus.fritz.box> <87r1uu1opr.fsf@morokweng.localdomain> <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com> <87pnae1k99.fsf@morokweng.localdomain> <ec71a816-b9e6-6f06-def6-73eb5164b0cc@redhat.com> <87sgf9i8sy.fsf@morokweng.localdomain> <20200606082458.GK228651@umbus.fritz.box>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <87eeqp8uh2.fsf@morokweng.localdomain>
In-reply-to: <20200606082458.GK228651@umbus.fritz.box>
Date:   Mon, 08 Jun 2020 12:10:01 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_13:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=927 impostorscore=0 suspectscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


David Gibson <david@gibson.dropbear.id.au> writes:

> On Fri, Jun 05, 2020 at 05:01:07PM -0300, Thiago Jung Bauermann wrote:
>> 
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>> > On 05/06/20 01:30, Thiago Jung Bauermann wrote:
>> >> Paolo Bonzini <pbonzini@redhat.com> writes:
>> >>> On 04/06/20 23:54, Thiago Jung Bauermann wrote:
>> >>>> QEMU could always create a PEF object, and if the command line defines
>> >>>> one, it will correspond to it. And if the command line doesn't define one,
>> >>>> then it would also work because the PEF object is already there.
>> >>>
>> >>> How would you start a non-protected VM?
>> >>> Currently it's the "-machine"
>> >>> property that decides that, and the argument requires an id
>> >>> corresponding to "-object".
>> >>
>> >> If there's only one object, there's no need to specify its id.
>> >
>> > This answers my question.  However, the property is defined for all
>> > machines (it's in the "machine" class), so if it takes the id for one
>> > machine it does so for all of them.
>> 
>> I don't understand much about QEMU internals, so perhaps it's not
>> practical to implement but from an end-user perspective I think this
>> logic can apply to all architectures (since my understanding is that all
>> of them use only one object): make the id optional. If it's not
>> specified, then there must be only one object, and the property will
>> implicitly refer to it.
>> 
>> Then, if an architecture doesn't need to specify parameters at object
>> creation time, it can be implicitly created and the user doesn't have to
>> worry about this detail.
>
> Seems overly complicated to me.  We could just have it always take an
> ID, but for platforms with no extra configuration make the
> pre-fabricated object available under a well-known name.
>
> That's essentially the same as the way you can add a device to the
> "pci.0" bus without having to instantiate and name that bus yourself.

Ok, that sounds good to me.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
