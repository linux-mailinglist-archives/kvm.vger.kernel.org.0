Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CD83F02AA
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 13:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHRL0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 07:26:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235876AbhHRL0X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 07:26:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IB3nin134429;
        Wed, 18 Aug 2021 07:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=P7qCOzC7cYxFlSmUITbBnvVVMR8JjFm+CaNpp8qgtro=;
 b=C3coVfce7h36YSOwYqkwoowhw3Zyl5yApXQf7ZbM3RBqSatDSgtf4C0zPSy0RtMjGanq
 3uwwT01FedEd1E9TRiZE1fFt2z3ZXJPtctjRIRB5tjxWHGJHS7wy1dOPMxTMBSluF3UT
 mDas+ALMu/XtfM6XxaPY2Hr8gH1/I9S874ut+IL2NTBIIPYz/4ORas6JeYvi0j/xp0nZ
 39WVpaVg8GR7L9xC6z2vT5OxlHBejq9LlAUE84tGY/4mtHzl2/jYUAd5bNy9bnPBwt2x
 oI0mKQ2WFL9mOAlq6+01uD1N8A1XZiD/zFdR8klvj/Y0M6542mNgouBr1rgUDLujxTGP dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0enw2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 07:25:44 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IB3mK3134304;
        Wed, 18 Aug 2021 07:25:43 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0enw2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 07:25:43 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IBIawJ029238;
        Wed, 18 Aug 2021 11:25:42 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3ae5fdjak3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:25:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IBPecT33292674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 11:25:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1A77805E;
        Wed, 18 Aug 2021 11:25:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38E678067;
        Wed, 18 Aug 2021 11:25:36 +0000 (GMT)
Received: from jarvis.lan (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 11:25:36 +0000 (GMT)
Message-ID: <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Date:   Wed, 18 Aug 2021 07:25:35 -0400
In-Reply-To: <20210818103147.GB31834@ashkalra_ubuntu_server>
References: <cover.1629118207.git.ashish.kalra@amd.com>
         <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
         <20210816144413.GA29881@ashkalra_ubuntu_server>
         <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
         <20210816151349.GA29903@ashkalra_ubuntu_server>
         <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
         <20210818103147.GB31834@ashkalra_ubuntu_server>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sxB68EdZTSEFyRFTC0u06_31RkLCQs2r
X-Proofpoint-GUID: NGe-QrKJ7NMu9dqRWw9a0JEuL-eC1eP2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 mlxscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-18 at 10:31 +0000, Ashish Kalra wrote:
> Hello Paolo,
> 
> On Mon, Aug 16, 2021 at 05:38:55PM +0200, Paolo Bonzini wrote:
> > On 16/08/21 17:13, Ashish Kalra wrote:
> > > > > I think that once the mirror VM starts booting and running
> > > > > the UEFI code, it might be only during the PEI or DXE phase
> > > > > where it will start actually running the MH code, so mirror
> > > > > VM probably still need to handles KVM_EXIT_IO when SEC phase
> > > > > does I/O, I can see PIC accesses and Debug Agent
> > > > > initialization stuff in SEC startup code.
> > > > That may be a design of the migration helper code that you were
> > > > working with, but it's not necessary.
> > > > 
> > > Actually my comments are about a more generic MH code.
> > 
> > I don't think that would be a good idea; designing QEMU's migration
> > helper interface to be as constrained as possible is a good
> > thing.  The migration helper is extremely security sensitive code,
> > so it should not expose itself to the attack surface of the whole
> > of QEMU.

The attack surface of the MH in the guest is simply the API.  The API
needs to do two things:

   1. validate a correct endpoint and negotiate a wrapping key
   2. When requested by QEMU, wrap a section of guest encrypted memory
      with the wrapping key and return it.

The big security risk is in 1. if the MH can be tricked into
communicating with the wrong endpoint it will leak the entire guest. 
If we can lock that down, I don't see any particular security problem
with 2. So, provided we get the security properties of the API correct,
I think we won't have to worry over much about exposure of the API.

> > One question i have here, is that where exactly will the MH code
> exist in QEMU ?

I assume it will be only x86 platform specific code, we probably will
never support it on other platforms ?

So it will probably exist in hw/i386, something similar to "microvm"
support and using the same TYPE_X86_MACHINE ?

I don't think it should be x86 only.  The migration handler receiver
should be completely CPU agnostic.  It's possible other CPUs will grow
an encrypted memory confidential computing capability (Power already
has one and ARM is "thinking" about it, but even if it doesn't, there's
a similar problem if you want to use trustzone isolation in VMs).  I
would envisage migration working substantially similarly on all of them
(need to ask an agent in the guest to wrap an encrypted page for
transport) so I think we should add this capability to the generic QEMU
migration code and let other architectures take advantage of it as they
grow the facility.

> Also if we are not going to use the existing KVM support code and
> adding some duplicate KVM interface code, do we need to interface
> with this added KVM code via the QEMU accelerator framework, or
> simply invoke this KVM code statically ?

I think we need to design the interface as cleanly as possible, so it
just depends what's easiest.  We certainly need some KVM support for
the mirror CPUs, I think but it's not clear to me yet what the simplest
way to do the interface is.

James


