Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1D46DAE9
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhLHSWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:22:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231815AbhLHSWh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 13:22:37 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8HrHDV008954;
        Wed, 8 Dec 2021 18:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=VpuyRHQVLmacLBoAhzw36/Cfws7MZWgO8Iw88Its8xY=;
 b=Wwd9Wn79QznlP3hbbGW+OlX6E2IF69H2yb9YUcRIhrQnaB6lga458D2fif813MIBnQ+p
 lUjDA9yxWNgljjYwjMu3071HNDuijpxwCQb6X0y8OdTJRng3jdtLCUrH6DUzG4gTmcV+
 T1ZiMOSfy0/CFRhvRI19y+IWPkDskDHhmPsw4IwyZSKXz5OwEdG28DAt78dJetS2BhiP
 rgOM6Y9khAlNoUuK5DgJkfhyqNCvhdAjlI+q3skJi+wwnthfktkHPlI2ETSI8Oqbd8qg
 p7hGNmmHeGjui3/rIYEdCsYVsJ7yc+gkjVrKgDNc3F8YejbOBq+21A3Gaw5bRg0zVgoB JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cu1gjrfks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:19:04 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8Ht2YH012428;
        Wed, 8 Dec 2021 18:19:04 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cu1gjrfk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:19:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8IG1gI014955;
        Wed, 8 Dec 2021 18:19:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3cqyy9ryst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:19:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8IIxrQ28639538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 18:18:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00EC6AE04D;
        Wed,  8 Dec 2021 18:18:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE079AE045;
        Wed,  8 Dec 2021 18:18:57 +0000 (GMT)
Received: from sig-9-145-190-99.de.ibm.com (unknown [9.145.190.99])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 18:18:57 +0000 (GMT)
Message-ID: <798938f464812c7ca7a37059434629441701e3ea.camel@linux.ibm.com>
Subject: Re: [PATCH 07/32] s390/pci: externalize the SIC operation controls
 and routine
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 19:18:57 +0100
In-Reply-To: <d1b7d0be6603f473017faf3cf5f47cab92db3bef.camel@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-8-mjrosato@linux.ibm.com>
         <bc3b60f7-833d-6d50-dcd0-b102a190c69d@linux.ibm.com>
         <614215b5aa14102c7b43913b234463199401a156.camel@linux.ibm.com>
         <eea46eb2-c14e-3bc1-d8e4-b6b28c677fe2@linux.ibm.com>
         <a53b6402cefdef7645d1771a8b74782689b4e6dc.camel@linux.ibm.com>
         <d28e6848-8fa4-c2c4-1140-7da5bcbe1287@linux.ibm.com>
         <d1b7d0be6603f473017faf3cf5f47cab92db3bef.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U5l3vAD5qt3dPDDB_Ee69wpHunpfjw1R
X-Proofpoint-ORIG-GUID: 81nXNdgNawkFl5Hg5FlaEpqmI4x3WTge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-08 at 17:41 +0100, Niklas Schnelle wrote:
> On Wed, 2021-12-08 at 11:20 -0500, Matthew Rosato wrote:
> > On 12/8/21 10:59 AM, Niklas Schnelle wrote:
> > > On Wed, 2021-12-08 at 10:33 -0500, Matthew Rosato wrote:
> > > > On 12/8/21 8:53 AM, Niklas Schnelle wrote:
> > > > > On Wed, 2021-12-08 at 14:09 +0100, Christian Borntraeger wrote:
> > > > > > Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> > > > > > > A subsequent patch will be issuing SIC from KVM -- export the necessary
> > > > > > > routine and make the operation control definitions available from a header.
> > > > > > > Because the routine will now be exported, let's swap the purpose of
> > > > > > > zpci_set_irq_ctrl and __zpci_set_irq_ctrl, leaving the latter as a static
> > > > > > > within pci_irq.c only for SIC calls that don't specify an iib.
> > > > > > 
> > > > > > Maybe it would be simpler to export the __ version instead of renaming everything.
> > > > > > Whatever Niklas prefers.
> > > > > 
> > > > > See below I think it's just not worth it having both variants at all.
> > > > > 
> > > > > > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > > > ---
> > > > > > >     arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
> > > > > > >     arch/s390/pci/pci_insn.c         |  3 ++-
> > > > > > >     arch/s390/pci/pci_irq.c          | 28 ++++++++++++++--------------
> > > > > > >     3 files changed, 25 insertions(+), 23 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> > > > > > > index 61cf9531f68f..5331082fa516 100644
> > > > > > > --- a/arch/s390/include/asm/pci_insn.h
> > > > > > > +++ b/arch/s390/include/asm/pci_insn.h
> > > > > > > @@ -98,6 +98,14 @@ struct zpci_fib {
> > > > > > >     	u32 gd;
> > > > > > >     } __packed __aligned(8);
> > > > > > >     
> > > > > > > +/* Set Interruption Controls Operation Controls  */
> > > > > > > +#define	SIC_IRQ_MODE_ALL		0
> > > > > > > +#define	SIC_IRQ_MODE_SINGLE		1
> > > > > > > +#define	SIC_IRQ_MODE_DIRECT		4
> > > > > > > +#define	SIC_IRQ_MODE_D_ALL		16
> > > > > > > +#define	SIC_IRQ_MODE_D_SINGLE		17
> > > > > > > +#define	SIC_IRQ_MODE_SET_CPU		18
> > > > > > > +
> > > > > > >     /* directed interruption information block */
> > > > > > >     struct zpci_diib {
> > > > > > >     	u32 : 1;
> > > > > > > @@ -134,13 +142,6 @@ int __zpci_store(u64 data, u64 req, u64 offset);
> > > > > > >     int zpci_store(const volatile void __iomem *addr, u64 data, unsigned long len);
> > > > > > >     int __zpci_store_block(const u64 *data, u64 req, u64 offset);
> > > > > > >     void zpci_barrier(void);
> > > > > > > -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
> > > > > > > -
> > > > > > > -static inline int zpci_set_irq_ctrl(u16 ctl, u8 isc)
> > > > > > > -{
> > > > > > > -	union zpci_sic_iib iib = {{0}};
> > > > > > > -
> > > > > > > -	return __zpci_set_irq_ctrl(ctl, isc, &iib);
> > > > > > > -}
> > > > > > > +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
> > > > > 
> > > > > Since the __zpci_set_irq_ctrl() was already non static/inline the above
> > > > > inline to non-inline change shouldn't make a performance difference.
> > > > > 
> > > > > Looking at this makes me wonder though. Wouldn't it make sense to just
> > > > > have the zpci_set_irq_ctrl() function inline in the header. Its body is
> > > > > a single instruction inline asm plus a test_facility(). The latter by
> > > > > the way I think also looks rather out of place there considering we
> > > > > call zpci_set_irq_ctrl() in the interrupt handler and facilities can't
> > > > > go away so it's pretty silly to check for it on every single
> > > > > interrupt.. unless I'm totally missing something.
> > > > 
> > > > This test_facility isn't new to this patch
> > > 
> > > Yeah I got that part, your patch just made me look.
> > > 
> > > > , it was added via
> > > > 
> > > > commit 48070c73058be6de9c0d754d441ed7092dfc8f12
> > > > Author: Christian Borntraeger <borntraeger@de.ibm.com>
> > > > Date:   Mon Oct 30 14:38:58 2017 +0100
> > > > 
> > > >       s390/pci: do not require AIS facility
> > > > 
> > > > It looks like in the past, we would not even initialize zpci at all if
> > > > AIS wasn't available.  With this, we initialize PCI but only do the SIC
> > > > when we have AIS, which makes sense.
> > > 
> > > Ah yes I guess that is the something I was missing. I was wondering why
> > > that wasn't just tested for during init.
> > > 
> > > > So for this patch, the sane thing to do is probably just keep the
> > > > test_facility() in place and move to header, inline.
> > > 
> > > Yes sounds good.

As discussed out of band, slight change of plan. Let's keep the
implementation in pci_insn.c for now but remove the __* prefix and the
iib 0 wrapper. This way we get rid of potential confusion of swapping
what each variant does and we also don't need to export a __* prefixed
function. I tried it out locally and having the iib 0 at the callsites
indeed doesn't look worse.

