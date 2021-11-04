Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAAA4456A0
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 16:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhKDP5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 11:57:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8659 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231604AbhKDP5F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 11:57:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4EpbJu002093;
        Thu, 4 Nov 2021 15:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xfh15wqIC3E9baw5kvY0Yb8j922Vo5rqcuqgKeYIQnY=;
 b=Pg/IyjJieaIjsaKAgMuU8p0lj0H0w6G/gPbYSTAQsL/k/HeuKm5j6xwOLUAewfrHkKoh
 onVWxY8mwCbji3GZjZ89xKBYiPKUcnx1lz/9/rwDOO6G4UL2T+nsuK3kbYzUP+x3nssp
 6Nk3rqbIj9y+nnsgTXn7s2e2xp9zI4JQqElzmsD3yDKbfGMPzOQc16+LrUKLRp6APpUZ
 WadzEWKCmtAD5fWlOj5r3oJ0emxfX11K1nFErwa4JlWSqOpupxrCKGlaT4GaOv3HxV39
 i4YMZ+TZwpBMZ+V2aoewrjnwoqOvjB+tqkVnLAMmGFWB/Pf6JYDpc19Cp50Sm1aAn+zA oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c4hnd1cp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:54:25 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4FqSww015875;
        Thu, 4 Nov 2021 15:54:24 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c4hnd1cnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:54:24 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FYhsa012388;
        Thu, 4 Nov 2021 15:54:24 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3c0wpc417f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:54:23 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4FsMvF15073914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 15:54:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A317DC6062;
        Thu,  4 Nov 2021 15:54:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9581DC6059;
        Thu,  4 Nov 2021 15:54:21 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.105.133])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 15:54:21 +0000 (GMT)
Message-ID: <1365cae27512d38a4b405d72b4d0ae2d502ec5d1.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v2 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 04 Nov 2021 11:54:20 -0400
In-Reply-To: <655b3473-ccbd-f198-6566-c23a0ec20940@redhat.com>
References: <20211102194652.2685098-1-farman@linux.ibm.com>
         <20211102194652.2685098-3-farman@linux.ibm.com>
         <7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com>
         <2ad9bef6b39a5a6c9b634cab7d70d110064d8f04.camel@linux.ibm.com>
         <655b3473-ccbd-f198-6566-c23a0ec20940@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _8RnN5jbTJTgGsVvaA4nIc7A7SE8qwfm
X-Proofpoint-ORIG-GUID: f9--B5ga8poVtjf0XzXqcsp8Eo_I2OOz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=848 mlxscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-04 at 15:59 +0100, David Hildenbrand wrote:
> > > For example, we don't care about concurrent SIGP SENSE. We only
> > > care
> > > about "lightweight" SIGP orders with concurrent "heavy weight"
> > > SIGP
> > > orders.
> > 
> > I very much care about concurrent SIGP SENSE (a "lightweight" order
> > handled in-kernel) and how that interacts with the "heavy weight"
> > SIGP
> > orders (handled in userspace). SIGP SENSE might return CC0
> > (accepted)
> > if a vcpu is operating normally, or CC1 (status stored) with status
> > bits indicating an external call is pending and/or the vcpu is
> > stopped.
> > This means that the actual response will depend on whether
> > userspace
> > has picked up the sigp order and processed it or not. Giving CC0
> > when
> > userspace is actively processing a SIGP STOP/STOP AND STORE STATUS
> > would be misleading for the SIGP SENSE. (Did the STOP order get
> > lost?
> > Failed? Not yet dispatched? Blocked?)
> 
> But that would only visible when concurrently SIGP STOP'ing from one
> VCPU and SIGP SENSE'ing from another VCPU. But in that case, there
> are
> already no guarantees, because it's inherently racy:
> 
> VCPU #2: SIGP STOP #3
> VCPU #1: SIGP SENSE #3
> 

Is it inherently racy? QEMU has a global "one SIGP at a time,
regardless of vcpu count" mechanism, so that it gets serialized at that
level. POPS says an order is rejected (BUSY) if the "access path to a
cpu is processing another order", and I would imagine that KVM is
acting as that access path to the vcpu. The deliniation between
kernelspace and userspace should be uninteresting on whether parallel
orders are serialized (in QEMU via USER_SIGP) or not (!USER_SIGP or
"lightweight" orders).

> There is no guarantee who ends up first
> a) In the kernel
> b) On the final destination (SENSE -> kernel; STOP -> QEMU)
> 
> They could be rescheduled/delayed in various ways.
> 
> 
> The important part is that orders from the *same* CPU are properly
> handled, right?
> 
> VCPU #1: SIGP STOP #3
> VCPU #1: SIGP SENSE #3
> 
> SENSE must return BUSY in case the STOP was not successful yet,
> correct?

It's not a matter of whether STOP is/not successful. If the vcpu is
actively processing a STOP, then the SENSE gets a BUSY. But there's no
code today to do that for the SENSE, which is of course why I'm here.
:)

> 
> And that can be achieved by setting the VCPU #3 busy when landing in
> user space to trigger the SIGP STOP, before returning to the kernel
> and
> processing the SIGP SENSE.
> 

I will try it, but I am not convinced.

> 
> Or am I missing something important?
> 
> > Meanwhile, the Principles of Operation (SA22-7832-12) page 4-95
> > describes a list of orders that would generate a CC2 (busy) when
> > the
> > order is still "active" in userspace:
> > 
> > """
> > A previously issued start, stop, restart, stop-
> > and-store-status, set-prefix, store-status-at-
> > address order, or store-additional-status-at-
> > address has been accepted by the
> > addressed CPU, and execution of the func-
> > tion requested by the order has not yet been
> > completed.
> 
> Right, but my take is that the order has not been accepted by the
> target
> CPU before we're actually in user space to e.g., trigger SIGP STOP.

Not accepted, yes, but also not rejected either. We're still trying to
figure out who's processing the order and getting it to the addressed
cpu.

> 
> > ...
> > If the currently specified order is sense, external
> > call, emergency signal, start, stop, restart, stop
> > and store status, set prefix, store status at
> > address, set architecture, set multithreading, or
> > store additional status at address, then the order
> > is rejected, and condition code 2 is set. If the cur-
> > rently specified order is one of the reset orders,
> > or an unassigned or not-implemented order, the
> > order code is interpreted as described in “Status
> > Bits” on page 4-96.
> > """
> > 
> > (There is another entry for the reset orders; not copied here for
> > sake
> > of keeping my novella manageable.)
> 
> Yes, these have to be special because we can have CPUs that never
> stop
> (endless program interruption stream).
> 
> > So, you're right that I could be more precise in terms how QEMU
> > handles
> > a SIGP order while it's already busy handling one, and only limit
> > the
> > CC2 from the kernel to those in-kernel orders. But I did say I took
> > this simplified approach in the cover letter. :)
> > 
> > Regardless, because of the above I really do want/need a way to
> > give
> > the kernel a clue that userspace is doing something, without
> > waiting
> > for userspace to say "hey, that order you kicked back to me? I'm
> > working on it now, I'll let you know when it's done!" Otherwise,
> > SIGP
> > SENSE (and other lightweight friends) is still racing with the
> > receipt
> > of a "start the sigp" ioctl.
> 
> And my point is that it's only visible when two VCPUs are involved
> and
> there are absolutely no guarantees regarding that. (see my first
> reply)
> 
> 

