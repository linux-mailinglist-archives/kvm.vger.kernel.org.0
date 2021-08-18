Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7A93F081E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhHRPgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:36:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhHRPgP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 11:36:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IFXIXM151647;
        Wed, 18 Aug 2021 11:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=lsKe+Famr6e92Mw3Wm2gfylUV+NcWU21cZM8aINsZxQ=;
 b=D8547+Cc4aiihbeuX0ODeK7Fg5FzSz2cLXMqRUDjBUL5PgcPHihnY6bTgTzvlQ/+Y5LL
 ONEd3F5PHMMfw83qZKur+7jqF3dhwf/a9onR2ydjt1ii3SSoh+89uaSrHxHi+fAT1vGX
 Wzo/WxGaBxjdHP2z7m7wkpA6+0XkkBSUrYU1D6VSCAN4utcrWF6bHgTs92y4P41L16Jx
 E+Az1Ly5o3gmDdJMhdit4uivLbVwpyFylcBNXUBsQHeCALmqgtEdHkQpw3nmOtETfxzp
 gmdQkkGfpTZBjVHzdxlr2KO+4aP05XuMUUNs5H4UkBKNAwZqxWooPE94QT0WJL4eKsew Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ah4q2ggw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:35:34 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IFXKxn152019;
        Wed, 18 Aug 2021 11:35:33 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ah4q2ggur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:35:33 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IFWORF002005;
        Wed, 18 Aug 2021 15:35:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3ae5fdu7g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 15:35:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IFZVpY27984274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 15:35:31 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C418B7820E;
        Wed, 18 Aug 2021 15:35:30 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3FC4780B7;
        Wed, 18 Aug 2021 15:35:10 +0000 (GMT)
Received: from jarvis.lan (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 15:35:10 +0000 (GMT)
Message-ID: <8ae11fca26e8d7f96ffc7ec6353c87353cadc63a.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        tobin@ibm.com, dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Date:   Wed, 18 Aug 2021 11:35:08 -0400
In-Reply-To: <YR0nwVPKymrAeIzV@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
         <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
         <20210816144413.GA29881@ashkalra_ubuntu_server>
         <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
         <20210816151349.GA29903@ashkalra_ubuntu_server>
         <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
         <20210818103147.GB31834@ashkalra_ubuntu_server>
         <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
         <YR0nwVPKymrAeIzV@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ghVGTl4XMiAbElZCadAfALjftSV1tYpv
X-Proofpoint-ORIG-GUID: VA5Dw3nBRWVTS3qFIJrWL5E1OlnokNtr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_05:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=841 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-18 at 16:31 +0100, Dr. David Alan Gilbert wrote:
> * James Bottomley (jejb@linux.ibm.com) wrote:
> > On Wed, 2021-08-18 at 10:31 +0000, Ashish Kalra wrote:
> > > Hello Paolo,
> > > 
> > > On Mon, Aug 16, 2021 at 05:38:55PM +0200, Paolo Bonzini wrote:
> > > > On 16/08/21 17:13, Ashish Kalra wrote:
> > > > > > > I think that once the mirror VM starts booting and
> > > > > > > running the UEFI code, it might be only during the PEI or
> > > > > > > DXE phase where it will start actually running the MH
> > > > > > > code, so mirror VM probably still need to handles
> > > > > > > KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> > > > > > > accesses and Debug Agent initialization stuff in SEC
> > > > > > > startup code.
> > > > > > That may be a design of the migration helper code that you
> > > > > > were working with, but it's not necessary.
> > > > > > 
> > > > > Actually my comments are about a more generic MH code.
> > > > 
> > > > I don't think that would be a good idea; designing QEMU's
> > > > migration helper interface to be as constrained as possible is
> > > > a good thing.  The migration helper is extremely security
> > > > sensitive code, so it should not expose itself to the attack
> > > > surface of the whole of QEMU.
> > 
> > The attack surface of the MH in the guest is simply the API.  The
> > API needs to do two things:
> > 
> >    1. validate a correct endpoint and negotiate a wrapping key
> >    2. When requested by QEMU, wrap a section of guest encrypted
> > memory
> >       with the wrapping key and return it.
> > 
> > The big security risk is in 1. if the MH can be tricked into
> > communicating with the wrong endpoint it will leak the entire
> > guest.  If we can lock that down, I don't see any particular
> > security problem with 2. So, provided we get the security
> > properties of the API correct, I think we won't have to worry over
> > much about exposure of the API.
> 
> Well, we'd have to make sure it only does stuff on behalf of qemu; if
> the guest can ever write to MH's memory it could do something that
> the guest shouldn't be able to.

Given the lack of SMI, we can't guarantee that with plain SEV and -ES. 
Once we move to -SNP, we can use VMPLs to achieve this.

But realistically, given the above API, even if the guest is malicious,
what can it do?  I think it's simply return bogus pages that cause a
crash on start after migration, which doesn't look like a huge risk to
the cloud to me (it's more a self destructive act on behalf of the
guest).

James


