Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA8D9877
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbfJPR26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbfJPR26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:28:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7652D81F19;
        Wed, 16 Oct 2019 17:28:58 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26D4F19C4F;
        Wed, 16 Oct 2019 17:28:58 +0000 (UTC)
Date:   Wed, 16 Oct 2019 11:28:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     kvm@vger.kernel.org, <sean.j.christopherson@intel.com>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191016112857.293a197d@x1.home>
In-Reply-To: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 16 Oct 2019 17:28:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019 00:49:51 -0400
Derek Yerger <derek@djy.llc> wrote:

> In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications 
> repeatedly crash with segfaults. The problem does not occur on 5.1.16.
> 
> System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10 with an 
> AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18, specific windows 
> applications frequently and repeatedly crash, throwing exceptions in random 
> libraries. Going back to 5.1.16, the issue does not occur.
> 
> The host system is unaffected by the regression.
> 
> Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu
> 
> Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing memslot 
> if VM has assigned device

That was never merged because it was superseded by:

d012a06ab1d2 Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"

That revert also induced this commit:

002c5f73c508 KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot

Both of these were merged to stable, showing up in 5.2.11 and 5.2.16
respectively, so seeing these sorts of issues might be considered a
known issue on 5.2.7, but not 5.2.18 afaik.  Do you have a specific
test that reliably reproduces the issue?  Thanks,

Alex
