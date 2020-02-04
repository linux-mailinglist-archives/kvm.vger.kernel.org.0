Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6871517F4
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 10:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgBDJfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 04:35:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36831 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726151AbgBDJfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 04:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580808937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhc7fAuttAzqQLesGQlF9Eu9YYXkA3oojtVtNfxD08Y=;
        b=dd9NUtWc+7ebc5kwc1eDio6QyKi5CdSzFAp+n2EibBoPMiQcztBj1MhMx6RIQczDlTcpAP
        X+8JggvqzEt+p2Adsbsm6lNZ3iE7+i0nGCevQ7ESOA4lVwtEniSDXhc/NKDIkgz5IilqMY
        YGaB0lhU1PjH3x5riGM/YWlyGfyVkyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-aUknZt_fMuW_qscZKJVv6g-1; Tue, 04 Feb 2020 04:35:34 -0500
X-MC-Unique: aUknZt_fMuW_qscZKJVv6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2199213FE;
        Tue,  4 Feb 2020 09:35:33 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE6F65C1D8;
        Tue,  4 Feb 2020 09:35:28 +0000 (UTC)
Date:   Tue, 4 Feb 2020 10:35:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 29/37] DOCUMENTATION: protvirt: Diag 308 IPL
Message-ID: <20200204103526.28a92df5.cohuck@redhat.com>
In-Reply-To: <dcc226cc-afb4-7fea-a839-7fc99080508d@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-30-borntraeger@de.ibm.com>
        <20200203171333.6be61670.cohuck@redhat.com>
        <dcc226cc-afb4-7fea-a839-7fc99080508d@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 09:13:06 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 03.02.20 17:13, Cornelia Huck wrote:
> > On Mon,  3 Feb 2020 08:19:49 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> Description of changes that are necessary to move a KVM VM into
> >> Protected Virtualization mode.  
> > 
> > Maybe move this up to the top of the series, so that new reviewers can
> > get a quick idea about the architecture as a whole? It might also make  
> Will do. 
> > sense to make the two documents link to each other...  
> I added both files to the kvm index file and changed the title
> to contain s390. I also added a link to the base doc.

Sounds good.

> 
> >   
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  Documentation/virt/kvm/s390-pv-boot.rst | 64 +++++++++++++++++++++++++
> >>  1 file changed, 64 insertions(+)
> >>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
> >>
> >> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
> >> new file mode 100644
> >> index 000000000000..431cd5d7f686
> >> --- /dev/null
> >> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
> >> @@ -0,0 +1,64 @@
> >> +.. SPDX-License-Identifier: GPL-2.0
> >> +=========================
> >> +Boot/IPL of Protected VMs
> >> +=========================  
> > 
> > ...especially as the reader will have no idea what a "Protected VM" is,
> > unless they have read the other document before.  
> 
> > 
> >   
> >> +
> >> +Summary
> >> +-------
> >> +Protected VMs are encrypted while not running. On IPL a small
> >> +plaintext bootloader is started which provides information about the
> >> +encrypted components and necessary metadata to KVM to decrypt it.  
> > 
> > s/it/the PVM/ ?  
> 
> ack
> 
> This section looks now:
> 
> ---
> Protected Virtual Machines (PVM) are not accessible by I/O or the
> hypervisor.  When the hypervisor wants to access the memory of PVMs
> the memory needs to be made accessible. When doing so, the memory will
> be encrypted.  See :doc:`s390-pv` for details.
> 
> On IPL a....

ok

> ---
> 
> >   
> >> +
> >> +Based on this data, KVM will make the PV known to the Ultravisor and  
> > 
> > I think the other document uses 'PVM'... probably better to keep that
> > consistent.  
> 
> The feature name might change to secure execution (SE). I will need to
> go over this again. But I think we can continue to name the virtual
> machines protected virtual machines as this is more a description than
> a brand name.

I would stick with "protected virtual machines" as well; especially as
the kernel parameter is called "prot_virt", and people might wonder
why you're talking about SELinux :)

(...)

> >> +Subcodes 4 and 7 will result in specification exceptions.  
> > 
> > "Subcodes 4 and 7, which would not clear the guest memory, ..." ?  
> 
> Subcodes 4 and 7 will result in specification exceptions as they would
> not clear out the guest memory.

ok

> 
> >   
> >> +When removing a secure VM, the UV will clear all memory, so we can't
> >> +have non-clearing IPL subcodes.
> >> +
> >> +Subcodes 8, 9, 10 will result in specification exceptions.
> >> +Re-IPL into a protected mode is only possible via a detour into non
> >> +protected mode.  
> > 
> > In general, this looks like a good overview about how the guest can
> > move into protected virt mode.
> > 
> > Some information I'm missing in this doc: Where do the keys come from?
> > I assume from the machine... is there one key per CEC? Can keys be
> > transferred? Can an image be introspected to find out if it is possible
> > to run it on a given system?
> > 
> > (Not sure if there is a better resting place for that kind of
> > information.)  
> 
> There will be tooling as part of the s390-tools. I will add 
> 
> ---
> Keys
> ----
> Every CEC will have a unique public key to enable tooling to build
> encrypted images.
> See  `s390-tools <https://github.com/ibm-s390-tools/s390-tools/>`_
> for the tooling.

Sounds good.

> ---
> 
> The s390 tools part is not yet upstream but it will be soon.

I'll look forward to the s390 tools part for details on key handling,
then :)

