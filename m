Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA568063
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 19:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfGNRLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 13:11:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbfGNRLo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Jul 2019 13:11:44 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6EH6n56070792
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 13:11:43 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tqvdu417k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 13:11:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Sun, 14 Jul 2019 18:11:40 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Jul 2019 18:11:34 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6EHBXm638994046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Jul 2019 17:11:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE1211C052;
        Sun, 14 Jul 2019 17:11:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22C2C11C04C;
        Sun, 14 Jul 2019 17:11:31 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.204.136])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 14 Jul 2019 17:11:31 +0000 (GMT)
Date:   Sun, 14 Jul 2019 20:11:29 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de>
 <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
 <7FDF08CB-A429-441B-872D-FAE7293858F5@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7FDF08CB-A429-441B-872D-FAE7293858F5@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19071417-0008-0000-0000-000002FD2B05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071417-0009-0000-0000-0000226A9A79
Message-Id: <20190714171127.GA15645@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907140213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 10:45:06AM -0600, Andy Lutomirski wrote:
> 
> 
> > On Jul 12, 2019, at 10:37 AM, Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
> > 
> > 
> > 
> >> On 7/12/19 5:16 PM, Thomas Gleixner wrote:
> >>> On Fri, 12 Jul 2019, Peter Zijlstra wrote:
> >>>> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
> >>>> 
> >>>> I think that's precisely what makes ASI and PTI different and independent.
> >>>> PTI is just about switching between userland and kernel page-tables, while
> >>>> ASI is about switching page-table inside the kernel. You can have ASI without
> >>>> having PTI. You can also use ASI for kernel threads so for code that won't
> >>>> be triggered from userland and so which won't involve PTI.
> >>> 
> >>> PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
> >>> ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
> >>> 
> >>> See how very similar they are?
> >>> 
> >>> Furthermore, to recover SMT for userspace (under MDS) we not only need
> >>> core-scheduling but core-scheduling per address space. And ASI was
> >>> specifically designed to help mitigate the trainwreck just described.
> >>> 
> >>> By explicitly exposing (hopefully harmless) part of the kernel to MDS,
> >>> we reduce the part that needs core-scheduling and thus reduce the rate
> >>> the SMT siblngs need to sync up/schedule.
> >>> 
> >>> But looking at it that way, it makes no sense to retain 3 address
> >>> spaces, namely:
> >>> 
> >>>   user / kernel exposed / kernel private.
> >>> 
> >>> Specifically, it makes no sense to expose part of the kernel through MDS
> >>> but not through Meltdow. Therefore we can merge the user and kernel
> >>> exposed address spaces.
> >>> 
> >>> And then we've fully replaced PTI.
> >>> 
> >>> So no, they're not orthogonal.
> >> Right. If we decide to expose more parts of the kernel mappings then that's
> >> just adding more stuff to the existing user (PTI) map mechanics.
> > 
> > If we expose more parts of the kernel mapping by adding them to the existing
> > user (PTI) map, then we only control the mapping of kernel sensitive data but
> > we don't control user mapping (with ASI, we exclude all user mappings).
> > 
> > How would you control the mapping of userland sensitive data and exclude them
> > from the user map?
> 
> As I see it, if we think part of the kernel is okay to leak to VM guests,
> then it should think it’s okay to leak to userspace and versa. At the end
> of the day, this may just have to come down to an administrator’s choice
> of how careful the mitigations need to be.
> 
> > Would you have the application explicitly identify sensitive
> > data (like Andy suggested with a /dev/xpfo device)?
> 
> That’s not really the intent of my suggestion. I was suggesting that
> maybe we don’t need ASI at all if we allow VMs to exclude their memory
> from the kernel mapping entirely.  Heck, in a setup like this, we can
> maybe even get away with turning PTI off under very, very controlled
> circumstances.  I’m not quite sure what to do about the kernel random
> pools, though.

I think KVM already allows excluding VMs memory from the kernel mapping
with the "new guest mapping interface" [1]. The memory managed by the host
can be restricted with "mem=" and KVM maps/unmaps the guest memory pages
only when needed.

It would be interesting to see if /dev/xpfo or even
madvise(MAKE_MY_MEMORY_PRIVATE) can be made useful for multi-tenant
container hosts.

[1] https://lore.kernel.org/lkml/1548966284-28642-1-git-send-email-karahmed@amazon.de/

-- 
Sincerely yours,
Mike.

