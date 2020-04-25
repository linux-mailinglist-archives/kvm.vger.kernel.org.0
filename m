Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D931B89D0
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDYWe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 18:34:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbgDYWe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 18:34:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC3E6AC46;
        Sat, 25 Apr 2020 22:34:25 +0000 (UTC)
Date:   Sat, 25 Apr 2020 15:30:14 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     tglx@linutronix.de, peterz@infradead.org, maz@kernel.org,
        bigeasy@linutronix.de, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 5/5] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200425223014.ndxjvpzk5mx7c2f3@linux-p48b>
References: <20200424054837.5138-1-dave@stgolabs.net>
 <20200424054837.5138-6-dave@stgolabs.net>
 <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Apr 2020, Paolo Bonzini wrote:

>I'm squashing this in to keep the changes compared to the current code minimal,
>and queuing the series.

Thanks!
