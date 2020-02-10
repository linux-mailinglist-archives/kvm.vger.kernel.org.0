Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C02D157726
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgBJM6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:58:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49691 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727641AbgBJM56 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 07:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581339477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THi8LfFh5PgVKMea984Hu+b9NYIyVc0rah0detCixCE=;
        b=GK0YfBO/Vg5Dd4GJH6iSbbrNKuTVIXv2lN6nHEyCZGNL7Xj9AcMo474S+TwpaxtTkOMICo
        /ZNvDecyLw1NFpqQaMf365k7/iXhkhysgXoVCJVsrDy3SnL+EiLOWRKtb6ycXD59ic8gKG
        idjW528BJ2nxY5/zEpWE8Vkoyq8Y6po=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-6EV3ZC_KO8auYl4_8W3-uw-1; Mon, 10 Feb 2020 07:57:53 -0500
X-MC-Unique: 6EV3ZC_KO8auYl4_8W3-uw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 958391937FC7;
        Mon, 10 Feb 2020 12:57:51 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB2188ED1C;
        Mon, 10 Feb 2020 12:57:46 +0000 (UTC)
Date:   Mon, 10 Feb 2020 13:57:43 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 09/35] KVM: s390: protvirt: Add KVM api documentation
Message-ID: <20200210135743.580d6eeb.cohuck@redhat.com>
In-Reply-To: <aae6434d-de87-503d-de51-4cee52d375b9@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-10-borntraeger@de.ibm.com>
        <f7089ad6-65d2-35fc-16fb-b94e968fd4e8@redhat.com>
        <aae6434d-de87-503d-de51-4cee52d375b9@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 13:26:35 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 08.02.20 15:57, Thomas Huth wrote:
> > On 07/02/2020 12.39, Christian Borntraeger wrote:  
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> Add documentation for KVM_CAP_S390_PROTECTED capability and the
> >> KVM_S390_PV_COMMAND and KVM_S390_PV_COMMAND_VCPU ioctls.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  Documentation/virt/kvm/api.txt | 61 ++++++++++++++++++++++++++++++++++
> >>  1 file changed, 61 insertions(+)

> >> +4.125 KVM_S390_PV_COMMAND
> >> +
> >> +Capability: KVM_CAP_S390_PROTECTED
> >> +Architectures: s390
> >> +Type: vm ioctl
> >> +Parameters: struct kvm_pv_cmd
> >> +Returns: 0 on success, < 0 on error
> >> +
> >> +struct kvm_pv_cmd {
> >> +	__u32	cmd;	/* Command to be executed */
> >> +	__u16	rc;	/* Ultravisor return code */
> >> +	__u16	rrc;	/* Ultravisor return reason code */
> >> +	__u64	data;	/* Data or address */  
> > 
> > That remindes me ... do we maybe want a "reserved" field in here for
> > future extensions? Or is the "data" pointer enough?  
> 
> 
> This is now:
> 
> struct kvm_pv_cmd {
> 
>         __u32 cmd;      /* Command to be executed */
>         __u32 flags;    /* flags for future extensions. Must be 0 for now */
>         __u64 data;     /* Data or address */
>         __u64 reserved[2];
> };

Ok, that is where you add this... but still, the question: are those
fields only ever set by userspace, or could the kernel return things in
the reserved fields in the future?

Also, two 64 bit values seem a bit arbitrary... what about a data
address + length construct instead? (Length might be a fixed value per
flag?)

