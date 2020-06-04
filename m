Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F41EED8D
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 23:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFDVzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 17:55:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgFDVzC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 17:55:02 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054LXdn1100432;
        Thu, 4 Jun 2020 17:54:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f8yvgfww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 17:54:51 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054LXhoL100532;
        Thu, 4 Jun 2020 17:54:51 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f8yvgfwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 17:54:51 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054Lo2XF030098;
        Thu, 4 Jun 2020 21:54:50 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 31bf4b2q8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 21:54:49 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054LskPr29622772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 21:54:46 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2961BC6057;
        Thu,  4 Jun 2020 21:54:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 972BAC605A;
        Thu,  4 Jun 2020 21:54:44 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.160.104.193])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu,  4 Jun 2020 21:54:44 +0000 (GMT)
References: <20200521034304.340040-1-david@gibson.dropbear.id.au> <87tuzr5ts5.fsf@morokweng.localdomain> <20200604062124.GG228651@umbus.fritz.box>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-ppc@nongnu.org, qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
In-reply-to: <20200604062124.GG228651@umbus.fritz.box>
Date:   Thu, 04 Jun 2020 18:54:40 -0300
Message-ID: <87r1uu1opr.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_13:2020-06-04,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006040152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


David Gibson <david@gibson.dropbear.id.au> writes:

> On Thu, Jun 04, 2020 at 01:39:22AM -0300, Thiago Jung Bauermann wrote:
>> 
>> Hello David,
>> 
>> David Gibson <david@gibson.dropbear.id.au> writes:
>> 
>> > A number of hardware platforms are implementing mechanisms whereby the
>> > hypervisor does not have unfettered access to guest memory, in order
>> > to mitigate the security impact of a compromised hypervisor.
>> >
>> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
>> > its own memory encryption mechanism.  POWER has an upcoming mechanism
>> > to accomplish this in a different way, using a new memory protection
>> > level plus a small trusted ultravisor.  s390 also has a protected
>> > execution environment.
>> >
>> > The current code (committed or draft) for these features has each
>> > platform's version configured entirely differently.  That doesn't seem
>> > ideal for users, or particularly for management layers.
>> >
>> > AMD SEV introduces a notionally generic machine option
>> > "machine-encryption", but it doesn't actually cover any cases other
>> > than SEV.
>> >
>> > This series is a proposal to at least partially unify configuration
>> > for these mechanisms, by renaming and generalizing AMD's
>> > "memory-encryption" property.  It is replaced by a
>> > "guest-memory-protection" property pointing to a platform specific
>> > object which configures and manages the specific details.
>> >
>> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
>> 
>> Thank you very much for this series! Using a machine property is a nice
>> way of configuring this.
>> 
>> >From an end-user perspective, `-M pseries,guest-memory-protection` in
>> the command line already expresses everything that QEMU needs to know,
>> so having to add `-object pef-guest,id=pef0` seems a bit redundant. Is
>> it possible to make QEMU create the pef-guest object behind the scenes
>> when the guest-memory-protection property is specified?
>
> Not exactly - the object needs to exist for the QOM core to resolve it
> before we'd have a chance to look at the value to conditionally create
> the object.
>
> What we could do, however, is always create a PEF object in the
> machine, and it would just have no effect if the machine parameter
> wasn't specified.
>
> I did consider that option, but left it this way for greater
> consistency with AMD SEV - there the object can't be auto-created,
> since it has mandatory parameters needed to configure the encryption.
>
> I'm open to persuasion about changing that, though.

What about having it both ways?

QEMU could always create a PEF object, and if the command line defines
one, it will correspond to it. And if the command line doesn't define one,
then it would also work because the PEF object is already there.

That way, compatibility with AMD SEV is preserved but we also get
command line simplicity where it is not needed.


-- 
Thiago Jung Bauermann
IBM Linux Technology Center
