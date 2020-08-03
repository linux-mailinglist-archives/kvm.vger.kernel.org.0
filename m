Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E5E23AF3A
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 23:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgHCVCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 17:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbgHCVCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 17:02:13 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9ACC06174A;
        Mon,  3 Aug 2020 14:02:13 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 061AF217; Mon,  3 Aug 2020 23:02:11 +0200 (CEST)
Date:   Mon, 3 Aug 2020 23:02:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 3/4] KVM: SVM: Add GHCB Accessor functions
Message-ID: <20200803210210.GA12917@8bytes.org>
References: <20200803122708.5942-1-joro@8bytes.org>
 <20200803122708.5942-4-joro@8bytes.org>
 <20200803184545.GG3151@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803184545.GG3151@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Mon, Aug 03, 2020 at 11:45:45AM -0700, Sean Christopherson wrote:
> On Mon, Aug 03, 2020 at 02:27:07PM +0200, Joerg Roedel wrote:
> > +		return test_bit(GHCB_BITMAP_IDX(field),				\
> > +				(unsigned long *)&(ghcb)->save.valid_bitmap);	\
> 
> 'ghcb' doesn't need to be wrapped in (), it's a parameter to a function.

Thanks for your reviews, I addressed them and sent v4.

Regards,

	Joerg

