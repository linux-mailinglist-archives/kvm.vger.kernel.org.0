Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0568814F3B6
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 22:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgAaVYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 16:24:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:45584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgAaVYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 16:24:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E716AD85;
        Fri, 31 Jan 2020 21:24:11 +0000 (UTC)
Date:   Fri, 31 Jan 2020 22:24:04 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
Message-ID: <20200131212404.GD14851@zn.tnic>
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
 <a7038958-bbab-4c53-72f0-ece46dc99b4d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7038958-bbab-4c53-72f0-ece46dc99b4d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 10:08:10PM +0100, Paolo Bonzini wrote:
> I was supposed to get a topic branch and fix everything up so that both
> CPU_BASED_ and VMX_FEATURE_ constants would get the new naming.  When
> Boris alerted me of the conflict and I said "thanks I'll sort it out",
> he probably interpreted it as me not needing the topic branch anymore.
> I then forgot to remind him, and here we are.

Damn, that was a misunderstanding. I actually had a topic branch:
tip:x86/cpu and was assuming that you'll see it from the tip-bot
notifications. But they went to lkml and you weren't CCed. And
regardless, I should've told you explicitly which one it is, sorry about
that. I'll be more explicit next time.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
