Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD93F846D
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbhHZJVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbhHZJVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:21:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C26FC061757;
        Thu, 26 Aug 2021 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TB0Y0UJ35SKuOJcAAhCyVaItBS
        FVm3QEBcVcqTkKv0rfHRNRgVOF6e0xi3GX8olXuwd/MeYhNxLGPmOFZq+bLp4bwiSk4uaHZffKa9d
        AOt5AJQshyxPwFMvvrdIiUGho+THa+pfBWjE1Cp4JQWS8I1/vHMZp0ws45cliur2Lhk+M6/j3cpRn
        iN0yeEPkPmfReKM2vHpJLWjiSXGeIok7YPa/9GhhP5fT3HU3Ww7Iw8ps5pVYkpygDuKGR4/TSd2Mz
        59/972JfHrv/oqBWKuoeHU1dGirYIFPE/lNcxkEN58avN6eYEjMHzNj9m0aC2N+7QYcWtITfKi1je
        RZKiNgiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBVy-00D94G-6o; Thu, 26 Aug 2021 09:17:56 +0000
Date:   Thu, 26 Aug 2021 10:17:38 +0100
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
Subject: Re: [PATCH V4 02/13] vfio/pci: Rename vfio_pci_private.h to
 vfio_pci_core.h
Message-ID: <YSdcMkbXPBilNXCy@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-3-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-3-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
