Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969DE3A0F74
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 11:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhFIJQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231219AbhFIJQz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 05:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623230100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgi5kKOm6TK8M2qhVcZngliu9Y3bqvGLMIuAVTt+ubM=;
        b=AU3Wlgos3zGgY/TKDvyr1IbnJkNBDavbiZGSY12XQ0iFyCkMD4rQgA77R63apdr7IBMxea
        DZcall+EdnQB/QV0MsEOIFls0VhQ4fXigSkzybNoPxD5snPXucg4kh5MNEm3cPv4AxrxK8
        0tdlsi9mF8TBTDjH+IkqVqwV4xCooAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-vYCn498aOPKkd6o0B6dZIg-1; Wed, 09 Jun 2021 05:14:59 -0400
X-MC-Unique: vYCn498aOPKkd6o0B6dZIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6495C100C661;
        Wed,  9 Jun 2021 09:14:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E2C760917;
        Wed,  9 Jun 2021 09:14:57 +0000 (UTC)
Message-ID: <a59e75a3fd891eef7d434d5ef672d4cc6dc457a5.camel@redhat.com>
Subject: Re: [Bug 53851] nVMX: Support live migration of whole L1 guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Date:   Wed, 09 Jun 2021 12:14:56 +0300
In-Reply-To: <bug-53851-28872-bYWXmtlHPv@https.bugzilla.kernel.org/>
References: <bug-53851-28872@https.bugzilla.kernel.org/>
         <bug-53851-28872-bYWXmtlHPv@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-09 at 08:55 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=53851
> 
> --- Comment #2 from christian.rohmann@frittentheke.de ---
> Sorry for replying to this rather old bug - I was pointed to this via
> https://www.linux-kvm.org/page/Nested_Guests#Limitations 
> 
> 
> If I may ask, is this really the last state of discussion and work on this
> issue?
> Looking at i.e. 
> 
> * https://github.com/qemu/qemu/commit/ebbfef2f34cfc749c045a4569dedb4f748ec024a
> *
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=039aeb9deb9291f3b19c375a8bc6fa7f768996cc
> 
> 
> there have been commits for the kernel as well as QEMU to support migration of
> nested VMs.
> 

AFAIK, running nested guests and migration while nested guest is running should
work on both Intel and AMD, but there were lots of fixes in this area recently
so a very new kernel should be used.

Plus in some cases if the nested guest is 32 bit, the migration still can fail,
on Intel at least, last time I checked. On AMD I just recently fixed
such issue for 32 bit guest and it seems to work for me.

I also know that if the nested guest is hyper-v enabled (which is a bit overkill as
this brings us to a double nesting), then it crashes once in a whileafter lots of migration
cycles.

So there are still bugs, but overall it works.

Best regards,
	Maxim Levitsky

