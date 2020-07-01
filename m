Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1AC210B26
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgGAMmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 08:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgGAMmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 08:42:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DACC03E979;
        Wed,  1 Jul 2020 05:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/dBVnFe+0QbEb6oba4YxfBL/Fq4QYPfJyj1Q8/l0EI0=; b=J0ayZmG8Qv9RcfSsyxVjvwBPQh
        V2TSpZLiMlRjg2s9xAs+n+CxXyqz+wRIa71U1vpUYcnXMeO0H7cgq2jO7DA6KjZD6Ose8rclQ0JGK
        BH2D9euaP50Mi1cpumhmLtAHw6cVQ2uXayDfNIxmBbQ+TJUK6Pj6CKISj2G+z+Oyg0+vjPXtQxz0P
        TfQaIG5+hhpvBbuT6IlEYMhnSTx2dp2uQ0FtDVBPsY41IfVTlf39V9wOmfB8YSe43AHQq3fluIYd1
        K/yXbABV6PYzPvj9RRQImmCH70W7JpYIWfuj4fSj9CNI8BPaRnrrGNugemMUuK2XAb4GvZFO+Wwgc
        2ttWXRfQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqc41-0003HK-2U; Wed, 01 Jul 2020 12:42:09 +0000
Date:   Wed, 1 Jul 2020 13:42:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] vfio/pci: add blocklist and disable qat
Message-ID: <20200701124209.GA12512@infradead.org>
References: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 12:02:57PM +0100, Giovanni Cabiddu wrote:
> This patchset defines a blocklist of devices in the vfio-pci module and adds
> the current generation of Intel(R) QuickAssist devices to it as they are
> not designed to run in an untrusted environment.

How can they not be safe?  If any device is not safe to assign the
whole vfio concept has major issues that we need to fix for real instead
of coming up with quirk lists for specific IDs.
