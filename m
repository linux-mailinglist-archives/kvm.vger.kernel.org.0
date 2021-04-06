Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DBA3552BA
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 13:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbhDFLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 07:51:18 -0400
Received: from elvis.franken.de ([193.175.24.41]:58904 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238649AbhDFLvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 07:51:18 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lTkEe-00062N-01; Tue, 06 Apr 2021 13:51:08 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C2238C24CD; Tue,  6 Apr 2021 13:39:57 +0200 (CEST)
Date:   Tue, 6 Apr 2021 13:39:57 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        seanjc@google.com, "open list:MIPS" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: MIPS: rework flush_shadow_* callbacks into one
 that prepares the flush
Message-ID: <20210406113957.GB8277@alpha.franken.de>
References: <20210402155807.49976-1-pbonzini@redhat.com>
 <20210402155807.49976-3-pbonzini@redhat.com>
 <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com>
 <aab8a915-6e73-3cba-5392-8f940479a011@redhat.com>
 <CAAhV-H72z9DbbV=_fEhCeeOaP8fQ_qtr4rQMD=f5n08ekG=Ygw@mail.gmail.com>
 <510e59e7-91b0-6754-8fb5-6a936ef47b3c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510e59e7-91b0-6754-8fb5-6a936ef47b3c@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 08:05:40AM +0200, Paolo Bonzini wrote:
> On 06/04/21 03:36, Huacai Chen wrote:
> > > I tried the merge and it will be enough for Linus to remove
> > > arch/mips/kvm/trap_emul.c.  So I will leave it as is, but next time I'd
> > > prefer KVM MIPS changes to go through either my tree or a common topic
> > > branch.
> > Emmm, the TE removal series is done by Thomas, not me.:)
> 
> Sure, sorry if the sentence sounded like it was directed to you.  No matter
> who wrote the code, synchronization between trees is only the maintainers'
> task. :)

Sorry about the mess. I'll leave arch/mips/kvm to go via your tree then.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
