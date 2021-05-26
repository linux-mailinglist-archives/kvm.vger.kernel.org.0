Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F403915B9
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhEZLL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 07:11:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234060AbhEZLL4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 07:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622027424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvJbAVf0Tb1ulZyuUSwZ0lrOmeUKOAeH734xKBdluCA=;
        b=CyjCNVuVqH5SX22A3L0wYGVOGl/09tqhN/gnOy5ODsIZ2ciDMiTrsyDlg7h/x5RgnfeMRk
        EEu1Qe+vz5AhLhzJ6hO/8xozACMgODmoH7fdySVicRztQ14BIthBjPZucAUqEZ/77oozr6
        wAZJ4b8Ad10xXOUlYFkd6vuovi3Y0WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-dx5q9S1fO7OcQHJE81YmsA-1; Wed, 26 May 2021 07:10:21 -0400
X-MC-Unique: dx5q9S1fO7OcQHJE81YmsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D87AF6D5C2;
        Wed, 26 May 2021 11:10:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9A8378623;
        Wed, 26 May 2021 11:10:11 +0000 (UTC)
Message-ID: <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
Subject: Re: Writable module parameters in KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date:   Wed, 26 May 2021 14:10:10 +0300
In-Reply-To: <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
         <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-26 at 12:49 +0200, Paolo Bonzini wrote:
> On 26/05/21 01:45, Ben Gardon wrote:
> > At Google we have an informal practice of adding sysctls to control some 
> > KVM features. Usually these just act as simple "chicken bits" which 
> > allow us to turn off a feature without having to stall a kernel rollout 
> > if some feature causes problems. (Sysctls were used for reasons specific 
> > to Google infrastructure, not because they're necessarily better.)
> > 
> > We'd like to get rid of this divergence with upstream by converting the 
> > sysctls to writable module parameters, but I'm not sure what the general 
> > guidance is on writable module parameters. Looking through KVM, it seems 
> > like we have several writable parameters, but they're mostly read-only.
> 
> Sure, making them writable is okay.  Most KVM parameters are read-only 
> because it's much simpler (the usecase for introducing them was simply 
> "test what would happen on old processors").  What are these features 
> that you'd like to control?
> 
> > I also don't see central documentation of the module parameters. They're 
> > mentioned in the documentation for other features, but don't have their 
> > own section / file. Should they?
> 
> They probably should, yes.
> 
> Paolo
> 
I vote (because I have fun with my win98 once in a while),
to make 'npt' writable, since that is the only way
to make it run on KVM on AMD.
My personal itch only though!

Best regards,
	Maxim Levitsky

