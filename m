Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595CEFC9CA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKNPVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:21:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbfKNPVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:21:35 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEFEoaX021995
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:21:34 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7q2ws-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:21:33 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 14 Nov 2019 15:20:29 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 15:20:27 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEFJnvX34406780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 15:19:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C7A11C04A;
        Thu, 14 Nov 2019 15:20:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0206B11C04C;
        Thu, 14 Nov 2019 15:20:26 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 15:20:25 +0000 (GMT)
Date:   Thu, 14 Nov 2019 16:20:24 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 17/37] DOCUMENTATION: protvirt: Instruction emulation
In-Reply-To: <20191114161526.1100f4fe.cohuck@redhat.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-18-frankja@linux.ibm.com>
        <20191114161526.1100f4fe.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111415-0008-0000-0000-0000032F049B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111415-0009-0000-0000-00004A4E13ED
Message-Id: <20191114162024.13f17aa9@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=880 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 16:15:26 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 24 Oct 2019 07:40:39 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
> > As guest memory is inaccessible and information about the guest's
> > state is very limited, new ways for instruction emulation have been
> > introduced.
> > 
> > With a bounce area for guest GRs and instruction data, guest state
> > leaks can be limited by the Ultravisor. KVM now has to move
> > instruction input and output through these areas.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  Documentation/virtual/kvm/s390-pv.txt | 47
> > +++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/s390-pv.txt
> > b/Documentation/virtual/kvm/s390-pv.txt index
> > e09f2dc5f164..cb08d78a7922 100644 ---
> > a/Documentation/virtual/kvm/s390-pv.txt +++
> > b/Documentation/virtual/kvm/s390-pv.txt @@ -48,3 +48,50 @@
> > interception codes have been introduced. One which tells us that
> > CRs have changed. And one for PSW bit 13 changes. The CRs and the
> > PSW in the state description only contain the mask bits and no
> > further info like the current instruction address. +
> > +
> > +Instruction emulation:
> > +With the format 4 state description the SIE instruction already  
> 
> s/description/description,/
> 
> > +interprets more instructions than it does with format 2. As it is
> > not +able to interpret all instruction, the SIE and the UV
> > safeguard KVM's  
> 
> s/instruction/instructions/
> 
> > +emulation inputs and outputs.
> > +
> > +Guest GRs and most of the instruction data, like IO data
> > structures  
> 
> Hm, what 'IO data structures'?

the various IRB and ORB of I/O instructions

> > +are filtered. Instruction data is copied to and from the Secure
> > +Instruction Data Area. Guest GRs are put into / retrieved from the
> > +Interception-Data block.
> > +
> > +The Interception-Data block from the state description's offset
> > 0x380 +contains GRs 0 - 16. Only GR values needed to emulate an
> > instruction +will be copied into this area.
> > +
> > +The Interception Parameters state description field still contains
> > the +the bytes of the instruction text but with pre-set register
> > +values. I.e. each instruction always uses the same instruction
> > text, +to not leak guest instruction text.
> > +
> > +The Secure Instruction Data Area contains instruction storage
> > +data. Data for diag 500 is exempt from that and has to be moved
> > +through shared buffers to KVM.  
> 
> I find this paragraph a bit confusing. What does that imply for diag
> 500 interception? Data is still present in gprs 1-4?

no registers are leaked in the registers. registers are always only
exposed through the state description.

> (Also, why only diag 500? Because it is the 'reserved for kvm'
> diagnose call?)
> 
> > +
> > +When SIE intercepts an instruction, it will only allow data and
> > +program interrupts for this instruction to be moved to the guest
> > via +the two data areas discussed before. Other data is ignored or
> > results +in validity interceptions.
> > +
> > +
> > +Instruction emulation interceptions:
> > +There are two types of SIE secure instruction intercepts. The
> > normal +and the notification type. Normal secure instruction
> > intercepts will +make the guest pending for instruction completion
> > of the intercepted +instruction type, i.e. on SIE entry it is
> > attempted to complete +emulation of the instruction with the data
> > provided by KVM. That might +be a program exception or instruction
> > completion. +
> > +The notification type intercepts inform KVM about guest environment
> > +changes due to guest instruction interpretation. Such an
> > interception  
> 
> 'interpretation by SIE' ?
> 
> > +is recognized for the store prefix instruction and provides the new
> > +lowcore location for mapping change notification arming. Any KVM
> > data +in the data areas is ignored, program exceptions are not
> > injected and +execution continues on next SIE entry, as if no
> > intercept had +happened.  
> 

