Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9CBBBF89
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503711AbfIXBBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 21:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503707AbfIXBBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 21:01:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49E01308A9E0;
        Tue, 24 Sep 2019 01:01:00 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 835825D713;
        Tue, 24 Sep 2019 01:00:57 +0000 (UTC)
Date:   Mon, 23 Sep 2019 21:00:56 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in
 vmx.c
Message-ID: <20190924010056.GB4658@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-15-aarcange@redhat.com>
 <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 24 Sep 2019 01:01:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 12:19:12PM +0200, Paolo Bonzini wrote:
> On 20/09/19 23:25, Andrea Arcangeli wrote:
> > They can be called directly more efficiently, so we can as well mark
> > some of them inline in case gcc doesn't decide to inline them.
> 
> What is the output of size(1) before and after?

Before and after this specific commit there is a difference with gcc 8.3.

full patchset applied

 753699   87971    9616  851286   cfd56 build/arch/x86/kvm/kvm-intel.ko

git revert

 753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko

git reset --hard HEAD^

 753699   87971    9616  851286   cfd56  build/arch/x86/kvm/kvm-intel.ko

git revert

 753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko
