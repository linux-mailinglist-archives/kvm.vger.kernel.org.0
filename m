Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DD293664
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 10:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbgJTIHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 04:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbgJTIHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 04:07:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F62C061755;
        Tue, 20 Oct 2020 01:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fgCdhypOjfDbt584ZfkSdLJULkd2bbMgis0CS12tEyw=; b=VziYE4P3JGjqHtlzn0AdaGeJrd
        McrlNMmB8cf/izSwrVci5qulwjBKLMa5a2Tc1gBCbQBsAPZifvrpqb2y65VsDdsVdouWEwXaFrwJP
        GYCwdSZJjilnpY4G7W1g104uAhk82dy7JdupJsdV9DK0UYgZacJRxQq6XlHz4fKZEQZUI42xlMZsK
        jHAy404KiZsZs+3LzhDMr44qv05oJ1l9y2eC3QH1onpuEfue/FfBGTvyDLkP5rFCke9ooJBuRZ7WU
        8WpzT1TSJkjsE8R7BVj+YAvQqhUC4vIW13malxk/YAh8dEI3T6e6Dqa3X8Cr/ZARZWL6xDV+j+C/l
        Ib2iFNzw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUmfa-0005nX-2U; Tue, 20 Oct 2020 08:06:58 +0000
Date:   Tue, 20 Oct 2020 09:06:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 05/16] x86/kvm: Make VirtIO use DMA API in KVM guest
Message-ID: <20201020080658.GA21238@infradead.org>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

NAK.  Any virtio implementation that needs special DMA OPS treatment
needs to set the VIRTIO_F_ACCESS_PLATFORM bit.  The only reason the
Xen hack existst is because it slipped in a long time ago and we can't
fix that any more.
