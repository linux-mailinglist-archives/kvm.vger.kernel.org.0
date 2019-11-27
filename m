Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72FA10ACBD
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 10:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK0Jlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 04:41:46 -0500
Received: from 8bytes.org ([81.169.241.247]:53056 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfK0Jlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 04:41:46 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A5A1C379; Wed, 27 Nov 2019 10:41:44 +0100 (CET)
Date:   Wed, 27 Nov 2019 10:41:40 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: THP refcounting in disallowed_hugepage_adjust()?
Message-ID: <20191127094140.GA11039@8bytes.org>
References: <20191126152109.GA23850@8bytes.org>
 <20191126174603.GB22233@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126174603.GB22233@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On Tue, Nov 26, 2019 at 09:46:03AM -0800, Sean Christopherson wrote:
> disallowed_hugepage_adjust() is called from __direct_map() and its
> modification of the pfn is also contained to __direct_map(), i.e. the
> updated @pfn doesn't get propagated back up to the fault handlers.  Thus,
> kvm_release_pfn_clean() is called on the original pfn and so there's no
> need to transfer the page reference.


Thanks for your explanation, makes a lot of sense to me now.


Regards,

	Joerg
