Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529081517A5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 10:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgBDJTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 04:19:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21134 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgBDJTm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 04:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580807979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DpoL478ZOTDOAKFtDTVjFBM6+TruvOUqLQOnRqEp8c=;
        b=WgEgVhOUBJh2smcsTGH/eMjTUAQsgZ6QesphQLFUPNzNztiHpLqt1owV0fewgZ7IszW9Uu
        c4i+e8zQHAWJojKv8g5PHGvQqVTmzXJUekWSqCe5Sce3A5yC4mZEouCPqgLVbavebkTh/W
        tp/NTXV6+O5IjpOyQDbSOPDkQIUMfwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-04wr8iwlNymU6QF6Dc3w2w-1; Tue, 04 Feb 2020 04:19:36 -0500
X-MC-Unique: 04wr8iwlNymU6QF6Dc3w2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB2862F29;
        Tue,  4 Feb 2020 09:19:34 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBCAB89A8D;
        Tue,  4 Feb 2020 09:19:25 +0000 (UTC)
Date:   Tue, 4 Feb 2020 10:19:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 01/37] DOCUMENTATION: protvirt: Protected virtual
 machine introduction
Message-ID: <20200204101922.2f53fd30.cohuck@redhat.com>
In-Reply-To: <7a2c1152-e171-5986-9ed5-c528901baa1a@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-2-borntraeger@de.ibm.com>
        <20200203164250.7a2fd5a6.cohuck@redhat.com>
        <7a2c1152-e171-5986-9ed5-c528901baa1a@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Feb 2020 22:41:40 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 03.02.20 16:42, Cornelia Huck wrote:
> [...]
> >> +As access to the guest's state, such as the SIE state description, is
> >> +normally needed to be able to run a VM, some changes have been made in
> >> +SIE behavior. A new format 4 state description has been introduced,
> >> +where some fields have different meanings for a PVM. SIE exits are
> >> +minimized as much as possible to improve speed and reduce exposed
> >> +guest state.  
> > 
> > Suggestion: Can you include some ASCII art here describing the
> > relationship of KVM, PVMs, and the UV? I think there was something in
> > the KVM Forum talk.  
> 
> Uh, maybe I find someone who is good at doing ASCII art - I am not.

That can easily be done later; I just find a diagram showing the
relationship between the components very helpful to figure out what is
going on.

> I think I would prefer to have a link to the KVM forum talk?
> 
> I will add
> +
> +Links
> +-----
> +`KVM Forum 2019 presentation <https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf>`_
> 
> at the bottom, just in case.

Good idea.

> 
> [...]
> >> +Program and Service Call exceptions have another layer of
> >> +safeguarding; they can only be injected for instructions that have
> >> +been intercepted into KVM. The exceptions need to be a valid outcome  
> > 
> > s/valid/possible/ ?  
> 
> hmm, this is bikeshedding, but I think valid is better because it refers to
> the architecture. 

ok

> 
> >   
> >> +of an instruction emulation by KVM, e.g. we can never inject a
> >> +addressing exception as they are reported by SIE since KVM has no
> >> +access to the guest memory.
> >> +
> >> +
> >> +Mask notification interceptions
> >> +-------------------------------
> >> +As a replacement for the lctl(g) and lpsw(e) instruction
> >> +interceptions, two new interception codes have been introduced. One
> >> +indicating that the contents of CRs 0, 6 or 14 have been changed. And
> >> +one indicating PSW bit 13 changes.  
> > 
> > Hm, I think I already commented on this last time... here is my current
> > suggestion :)
> > 
> > "In order to be notified when a PVM enables a certain class of
> > interrupt, KVM cannot intercept lctl(g) and lpsw(e) anymore. As a
> > replacement, two new interception codes have been introduced: One
> > indicating that the contents of CRs 0, 6, or 14 have been changed,
> > indicating different interruption subclasses; and one indicating that
> > PSW bit 13 has been changed, indicating whether machine checks are
> > enabled."  
> 
> I will use this with ... indicating that a machine check intervention was
> requested and those are now enabled.

ok

> 
> >   
> >> +
> >> +Instruction emulation
> >> +---------------------
> >> +With the format 4 state description for PVMs, the SIE instruction already
> >> +interprets more instructions than it does with format 2. As it is not
> >> +able to interpret every instruction, the SIE and the UV safeguard KVM's
> >> +emulation inputs and outputs.  
> > 
> > "It is not able to interpret every instruction, but needs to hand some
> > tasks to KVM; therefore, the SIE and the UV safeguard..."  
> 
> Will use this.
> 
> 
> > 
> > ?
> >   
> >> +
> >> +Guest GRs and most of the instruction data, such as I/O data structures,
> >> +are filtered. Instruction data is copied to and from the Secure
> >> +Instruction Data Area. Guest GRs are put into / retrieved from the
> >> +Interception-Data block.  
> > 
> > These areas are in the SIE control block, right?  
> 
> SIDA is a new block, linked from SIE control block. The register are stored in
> the control block. I think this is really not relevant for such a document (too
> much technical detail when explaining the big idea), but I will fix the name of
> the location at 0x380 though.  (its now general register save area).

It's mostly that the block makes an appearance here, and it's unclear
what it is and where it resides. Whether it is in the control block or
is a satellite block is not really relevant for this document, I agree;
but can we make it more obvious that it is another data structure
associated with SIE? Maybe something like,

"The control structures associated with SIE provide the Secure
Instruction Data Area (SIDA) and the Interception-Data block. [Does
that one have an acronym?] Instruction data is copied to and from the
SIDA. ..."

> >   
> >> +
> >> +The Interception-Data block from the state description's offset 0x380
> >> +contains GRs 0 - 16. Only GR values needed to emulate an instruction
> >> +will be copied into this area.
> >> +
> >> +The Interception Parameters state description field still contains the
> >> +the bytes of the instruction text, but with pre-set register values
> >> +instead of the actual ones. I.e. each instruction always uses the same
> >> +instruction text, in order not to leak guest instruction text.  
> > 
> > This also implies that the register content that a guest had in r<n>
> > may be in r<m> in the interception data block if <m> is the default
> > register used for that instruction?  
> 
> yes. I will do
> ---
> ...Guest GRs are put into / retrieved from the
> General Register Save Area.
> 
> Only GR values needed to emulate an instruction will be copied into this 
> area and the real register numbers will be hidden.
> 
> The Interception Parameters state description field still contains the
> the bytes of the instruction text, but with pre-set register values
> instead of the actual ones. I.e. each instruction always uses the same
> instruction text, in order not to leak guest instruction text.
> This also implies that the register content that a guest had in r<n>
> may be in r<m> from the hypervisors point of view.

ok

> 
> ---
> 
> >   
> >> +
> >> +The Secure Instruction Data Area contains instruction storage
> >> +data. Instruction data, i.e. data being referenced by an instruction
> >> +like the SCCB for sclp, is moved over the SIDA When an instruction is  
> > 
> > Maybe move the introduction of the 'SIDA' acronym up to the
> > introduction of the Secure Instruction Data Area?
> > 
> > Also, s/moved over the SIDA/moved over to the SIDA./ ?  
> 
> Fixed. 
> >   
> [...]
> >> +The notification type intercepts inform KVM about guest environment
> >> +changes due to guest instruction interpretation. Such an interception
> >> +is recognized for example for the store prefix instruction to provide  
> > 
> > s/ for example/, for example,/  
> 
> fixed.
> 
> >   
> >> +the new lowcore location. On SIE reentry, any KVM data in the data
> >> +areas is ignored, program exceptions are not injected and execution
> >> +continues, as if no intercept had happened.  
> > 
> > So, KVM putting stuff there does not cause any exception, it is simply
> > discarded?  
> 
> Might be a bit ambigious. SIE will not inject program interrupts as the
> instruction has already completed. What about
> 
> On SIE reentry, any KVM data in the data areas is ignored and execution
> continues as if the guest instruction has completed. For that reasons

s/has/had/
s/reasons/reason,/

> KVM is not allowed to inject a program interrupt. 
> 

Sounds good to me.

