Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438A33F84A7
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhHZJhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhHZJhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:37:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C834C061757;
        Thu, 26 Aug 2021 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Y1JcRqz6FmodVJm+z8A/NsM8S+
        t7dU3ZZdJJ5zBSkcPEyzM85CtAXl/25o2njdcliavdps168ZMQjKVIdIQMI63KYL5TSYPlLFEDySR
        tIO7U7dye3kTXY7BRxPUipcybw+0xPRfGZpr4bqjbGvrOHfo9isG5r7p8+zuLJEZcBJbp4b8A4TH5
        Ogb6d/EJbVrjwuNu634uJgWASyPi2syU59Re7xrdOAFLQugz/Oq9joWmSAIBtF7zTUIcb/MNat4jO
        kgTJhJB4l9HCYgDRcOFfFiltQIC4Kf/Y8EYmI/jxxItPk1OU4jPSGCP+AKfI9HGyiEb47XYFcIkeO
        OcFfgPFw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBma-00D9p1-Vr; Thu, 26 Aug 2021 09:35:07 +0000
Date:   Thu, 26 Aug 2021 10:34:48 +0100
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
Subject: Re: [PATCH V4 07/13] vfio/pci: Move igd initialization to vfio_pci.c
Message-ID: <YSdgOPGUI267B7GA@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-8-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-8-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
