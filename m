Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F973F84AD
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhHZJjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhHZJjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:39:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E22C061757;
        Thu, 26 Aug 2021 02:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=M4KH4wNsCcMoGRKghOjgIkMql+
        BjDxKoik6ADibt7XkwqXMhyR6vDqRJEiYeiUkv4vniB6uDlM9pbifImRwT1NcsjF/cHLhVjTcT3hs
        AsCA2fLBflJGAXlQ8yTLXAq+/1yD12FnU+lJL05R29X9z3j5jZFzxbea1VERmx8SOD1LbuT9bRghs
        wD9KSbl//44a0QkYxBvHZwaNGFvtFKgldz3fzWllVmKybGw9DhZhyTqyI7OdOGq1qgMuGzjToAYiS
        7qoB5ZCPlPUHxIAEKkfkOzoLdwE/0TDVvhGvOojmkKgXeBZVsnbwmk2RvidIzEKCmgmZglBawguFd
        QV5PV/6w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBoh-00D9w0-OV; Thu, 26 Aug 2021 09:37:26 +0000
Date:   Thu, 26 Aug 2021 10:36:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH V4 08/13] vfio/pci: Move module parameters to vfio_pci.c
Message-ID: <YSdguyEOqqOI/KQ3@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-9-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-9-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
