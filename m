Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5E19184A
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 18:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgCXR5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 13:57:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:36830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgCXR5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 13:57:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD664ABC7;
        Tue, 24 Mar 2020 17:57:20 +0000 (UTC)
Date:   Tue, 24 Mar 2020 10:56:14 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, tglx@linutronix.de, pbonzini@redhat.com,
        bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200324175614.fzwutnpw2xiigqni@linux-p48b>
References: <20200324044453.15733-4-dave@stgolabs.net>
 <202003250014.iSvLXrUS%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202003250014.iSvLXrUS%lkp@intel.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020, kbuild test robot wrote:

>   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vcpu_block':
>>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2698:16: error: macro "rcuwait_wait_event" passed 3 arguments, but takes just 2
>          TASK_IDLE);

This is because this series relies on the rcuwait change:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=locking/core&id=80fbaf1c3f2926c834f8ca915441dfe27ce5487e

Thanks,
Davidlohr
