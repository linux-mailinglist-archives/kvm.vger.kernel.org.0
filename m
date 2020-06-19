Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A29201137
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404759AbgFSPi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:38:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404693AbgFSPi2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7g3smqjPAINScCPgMSu8XUaQStr8Lkex1f8ARwWIpo=;
        b=Td1UV5FEctau71J3CS0dOD1addsPg0IEJP3ZcjQIUwpIl67zL1xSNNZqlYdpnK6OnKbX61
        uCFbtFNVB92KPJVNzQtZ7dopKQdDFP+LQ1GP35bNnTptWsXUY252RNXqWCeE03Cn+t8PaH
        CSy5t58MZmp7wO/+EOotRnzXU2ul7u0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-RJ8WWiR_Px-M8OFQTo2uEQ-1; Fri, 19 Jun 2020 11:38:25 -0400
X-MC-Unique: RJ8WWiR_Px-M8OFQTo2uEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 044EC85B673;
        Fri, 19 Jun 2020 15:38:24 +0000 (UTC)
Received: from localhost (unknown [10.40.208.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D33D45C1D0;
        Fri, 19 Jun 2020 15:38:19 +0000 (UTC)
Date:   Fri, 19 Jun 2020 17:38:17 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
Message-ID: <20200619173817.63249b3e@redhat.com>
In-Reply-To: <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
        <20200619143626.1b326566@redhat.com>
        <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 16:10:43 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 19/06/20 14:36, Igor Mammedov wrote:
> > qemu-kvm -m 2G -smp 4,maxcpus=8  -monitor stdio
> > (qemu) device_add qemu64-x86_64-cpu,socket-id=4,core-id=0,thread-id=0
> > 
> > in guest fails with:
> > 
> >  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4
> > 
> > which makes me suspect that  INIT/SIPI wasn't delivered
> > 
> > Is it a know issue?
> >   
> 
> No, it isn't.  I'll revert.
wait for a day or 2,

I'll try to come up with a fix over weekend.

> Paolo
> 

