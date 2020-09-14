Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F17268B98
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 15:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgINM76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 08:59:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:46294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgINMdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 08:33:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26374AC83;
        Mon, 14 Sep 2020 12:13:22 +0000 (UTC)
Date:   Mon, 14 Sep 2020 14:13:04 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Colin King <colin.king@canonical.com>
Subject: Re: [PATCH -tip] KVM: SVM: nested: Initialize on-stack pointers in
 svm_set_nested_state()
Message-ID: <20200914121304.GC4414@suse.de>
References: <20200914115129.10352-1-joro@8bytes.org>
 <87ft7klg38.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft7klg38.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On Mon, Sep 14, 2020 at 02:04:27PM +0200, Vitaly Kuznetsov wrote:
> this was previously reported by Colin:
> https://lore.kernel.org/kvm/20200911110730.24238-1-colin.king@canonical.com/
> 
> the fix itself looks good, however, I had an alternative suggestion on how
> to fix this:
> https://lore.kernel.org/kvm/87o8mclei1.fsf@vitty.brq.redhat.com/

This looks good to me, mind sending your diff as a patch with correct
Fixes tag?

Thanks,

	Joerg
