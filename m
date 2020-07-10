Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9320421B9DF
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGJPsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgGJPsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:48:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E951CC08C5CE;
        Fri, 10 Jul 2020 08:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9AtbCOMTaB9TfwaJoiXvcEqoE4bI1Zlr762TPY5bg7c=; b=OXRoxJfsNINR7br0uKMyJjdYcl
        6X48gTp/kiEodNwE1h+FcQV5JegQ7xLzmUUJMPEq042U+WEwTA9S6bK5gJCmF2vY+wZWbP9yMSeBo
        fDtjSM+peY/yGflCRuLRZNaEtdolGYlj6E69yMWatTZOzNcRgmXVf6P85JajST8fE8MkaybEZ8rZB
        GT5Gbo+Gi291k2ksp5XvmSfXd6ASZEPcWfxhgODXeM+EWAS0pDkwoYUF2rv8dfEiusfQoSiw6u1LJ
        wTp/mXuSsfIZkxYtR9gmS6Gv57A6SShRG+4SducoOIEIGCU4a1HG0Cxp/KzzEK0yP2hhjaa6u+H0p
        HfaOsmgQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtvFv-0001yh-FL; Fri, 10 Jul 2020 15:48:07 +0000
Date:   Fri, 10 Jul 2020 16:48:07 +0100
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
Message-ID: <20200710154807.GA7292@infradead.org>
References: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
 <20200701124209.GA12512@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701124209.GA12512@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 01:42:09PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 01, 2020 at 12:02:57PM +0100, Giovanni Cabiddu wrote:
> > This patchset defines a blocklist of devices in the vfio-pci module and adds
> > the current generation of Intel(R) QuickAssist devices to it as they are
> > not designed to run in an untrusted environment.
> 
> How can they not be safe?  If any device is not safe to assign the
> whole vfio concept has major issues that we need to fix for real instead
> of coming up with quirk lists for specific IDs.

No answer yet:  how is this device able to bypass the IOMMU?  Don't
we have a fundamental model flaw if a random device can bypass the
IOMMU protection?  Except for an ATS bug I can't really think of a way
how a device could bypass the IOMMU, and in that case we should just
disable ATS.
