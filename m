Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25E9BBF0A
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391195AbfIWXnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 19:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbfIWXnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:43:10 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 798F1300CB25;
        Mon, 23 Sep 2019 23:43:10 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E925D9CA;
        Mon, 23 Sep 2019 23:43:07 +0000 (UTC)
Date:   Mon, 23 Sep 2019 19:43:07 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923234307.GG19996@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
 <20190923210838.GA23063@redhat.com>
 <20190923212435.GO18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923212435.GO18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 23 Sep 2019 23:43:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 02:24:35PM -0700, Sean Christopherson wrote:
> An extra CALL+RET isn't going to be noticeable, especially on modern
> hardware as the high frequency VMWRITE/VMREAD fields should hit the
> shadow VMCS.

In your last email with regard to the inlining optimizations made
possible by the monolithic KVM model you said "That'd likely save a
few CALL/RET/JMP instructions", that kind of directly contradicts the
above. I think neither one if taken at face value can be possibly
measured. However the above only is relevant for nested KVM so I'm
fine if there's an agreement that it's better to hide the nested vmx
handlers in nested.c at the cost of some call/ret.

From my part I'm dropping 15/16/17 in the short term, perhaps Vitaly
or you or Paolo if he has time, want to work on that part in parallel
to the orthogonal KVM monolithic changes?

Thanks,
Andrea
