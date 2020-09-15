Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761926AD93
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgIOT2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:28:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727713AbgIOT1Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600198032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+2lLM2k9R0KoxJS0Yj1YjWZ2tzOL4fA5WnRQ04/Q60=;
        b=brxUvCMwYEyhDOLxG1vctoXChkUqUX32REEo6STwQjSDhBe0EY9CpEAZ6BL1PjPrHj4hv4
        QDqnWOltKOC4TvBiqzFJY5SfQTBlxRqwidII6rcJE6urYsQnDAMFrI6VJK6AuVFREoKE8Q
        4pc8a+hp4CIEHzI8iBGmi6+QQWJ6Cnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-umcZtNTuM9mjJt5pxoM11g-1; Tue, 15 Sep 2020 15:27:10 -0400
X-MC-Unique: umcZtNTuM9mjJt5pxoM11g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F7681074653;
        Tue, 15 Sep 2020 19:27:08 +0000 (UTC)
Received: from treble (ovpn-112-136.rdu2.redhat.com [10.10.112.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0455761982;
        Tue, 15 Sep 2020 19:27:06 +0000 (UTC)
Date:   Tue, 15 Sep 2020 14:27:05 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Move IRQ invocation to assembly
 subroutine
Message-ID: <20200915192705.vadb4he5obu3vdzm@treble>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915191505.10355-2-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 12:15:04PM -0700, Sean Christopherson wrote:
> Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> into a proper subroutine.  Unconditionally create a stack frame in the
> subroutine so that, as objtool sees things, the function has standard
> stack behavior.  The dynamic stack adjustment makes using unwind hints
> problematic.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

