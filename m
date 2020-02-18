Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A205E162A64
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgBRQZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbgBRQZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:25:52 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E90DA22B48;
        Tue, 18 Feb 2020 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582043152;
        bh=1LUIwG9Zqy/qD2y4JXcrbPAJv3P2L7rfHQs6EMdQR+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6jIxRae3CjwnaJxANCtzI2lR4er0TMYFfpYnpjWGTNuy3B/MWXhYHhLCS82T56Kx
         EzRukPNi9iBpf+yJWw1CBIkKMsfa6rBS0UW5vpjCItsGe5U7HSfgmYVamxOilQpFT1
         FBJJhvL4kDWbgwFm5xUfJ+Tamzrkw+c3UEoUjofQ=
Date:   Tue, 18 Feb 2020 16:25:46 +0000
From:   Will Deacon <will@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 39/42] example for future extension: mm:gup/writeback:
 add callbacks for inaccessible pages: error cases
Message-ID: <20200218162546.GC1133@willie-the-truck>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-40-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214222658.12946-40-borntraeger@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 05:26:55PM -0500, Christian Borntraeger wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> This is a potential extension to do error handling if we fail to
> make the page accessible if we know what others need.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  mm/gup.c            | 17 ++++++++++++-----
>  mm/page-writeback.c |  6 +++++-
>  2 files changed, 17 insertions(+), 6 deletions(-)

Sorry, I missed this when replying elsewhere in the thread!
Anyway, looks good to me:

Acked-by: Will Deacon <will@kernel.org>

Thanks,

Will
