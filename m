Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D9FC752
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNNZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:25:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfKNNZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 08:25:15 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAED9Dqj131813
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 08:25:14 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7ky77-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 08:25:13 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 14 Nov 2019 13:25:06 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 13:25:03 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEDOP7M42795432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 13:24:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 191F752051;
        Thu, 14 Nov 2019 13:25:02 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B4C3352059;
        Thu, 14 Nov 2019 13:25:01 +0000 (GMT)
Date:   Thu, 14 Nov 2019 14:25:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 11/37] DOCUMENTATION: protvirt: Interrupt injection
In-Reply-To: <20191114140946.7bca2350.cohuck@redhat.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-12-frankja@linux.ibm.com>
        <20191114140946.7bca2350.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111413-0012-0000-0000-00000363994E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111413-0013-0000-0000-0000219F12BC
Message-Id: <20191114142500.55f985b1@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=978 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 14:09:46 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 24 Oct 2019 07:40:33 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
> > Interrupt injection has changed a lot for protected guests, as KVM
> > can't access the cpus' lowcores. New fields in the state
> > description, like the interrupt injection control, and masked
> > values safeguard the guest from KVM.
> > 
> > Let's add some documentation to the interrupt injection basics for
> > protected guests.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  Documentation/virtual/kvm/s390-pv.txt | 27
> > +++++++++++++++++++++++++++ 1 file changed, 27 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/s390-pv.txt
> > b/Documentation/virtual/kvm/s390-pv.txt index
> > 86ed95f36759..e09f2dc5f164 100644 ---
> > a/Documentation/virtual/kvm/s390-pv.txt +++
> > b/Documentation/virtual/kvm/s390-pv.txt @@ -21,3 +21,30 @@ normally
> > needed to be able to run a VM, some changes have been made in SIE
> > behavior and fields have different meaning for a PVM. SIE exits are
> > minimized as much as possible to improve speed and reduce exposed
> > guest state. +
> > +
> > +Interrupt injection:
> > +
> > +Interrupt injection is safeguarded by the Ultravisor and, as KVM
> > lost +access to the VCPUs' lowcores, is handled via the format 4
> > state +description.
> > +
> > +Machine check, external, IO and restart interruptions each can be
> > +injected on SIE entry via a bit in the interrupt injection control
> > +field (offset 0x54). If the guest cpu is not enabled for the
> > interrupt +at the time of injection, a validity interception is
> > recognized. The +interrupt's data is transported via parts of the
> > interception data +block.  
> 
> "Data associated with the interrupt needs to be placed into the
> respective fields in the interception data block to be injected into
> the guest."
> 
> ?

when a normal guest intercepts an exception, depending on the exception
type, the parameters are saved in the state description at specified
offsets, between 0xC0 amd 0xF8

to perform interrupt injection for secure guests, the same fields are
used to specify the interrupt parameters that should be injected into
the guest

> > +
> > +Program and Service Call exceptions have another layer of
> > +safeguarding, they are only injectable, when instructions have
> > +intercepted into KVM and such an exception can be an emulation
> > result.  
> 
> I find this sentence hard to parse... not sure if I understand it
> correctly.
> 
> "They can only be injected if the exception can be encountered during
> emulation of instructions that had been intercepted into KVM."
 
yes

> 
> > +
> > +
> > +Mask notification interceptions:
> > +As a replacement for the lctl(g) and lpsw(e) interception, two new
> > +interception codes have been introduced. One which tells us that
> > CRs +0, 6 or 14 have been changed and therefore interrupt masking
> > might +have changed. And one for PSW bit 13 changes. The CRs and
> > the PSW in  
> 
> Might be helpful to mention that this bit covers machine checks, which
> do not get a separate bit in the control block :)
> 
> > +the state description only contain the mask bits and no further
> > info +like the current instruction address.  
> 
> "The CRs and the PSW in the state description only contain the bits
> referring to interrupt masking; other fields like e.g. the current
> instruction address are zero."

wait state is saved too

CC is write only, and is only inspected by hardware/firmware when
KVM/qemu is interpreting an instruction that expects a new CC to be set,
and then only the expected CCs are allowed (e.g. if an instruction only
allows CC 0 or 3, 2 cannot be specified)



