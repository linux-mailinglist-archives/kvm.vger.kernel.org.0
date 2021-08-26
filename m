Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A049D3F8461
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhHZJSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbhHZJSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:18:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECEDC061757;
        Thu, 26 Aug 2021 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=RzBLxodQSqWhpAHRrnuAHSX2SV
        zt+ZsfP1daeqTyxksK3Er4G0di0LdnoE4NrCPfvsDxIkhIoMzHzGWTEwQgP91vklbtRhvrR3QKQyw
        NzWSFtb8nKq7OdQBRJr6M9eMVSfme11D/ZSGwTvZISpbnkfZ18QaGqQIE9TvK8stulKEZ4zqm5sB3
        H2JH2A22fR2FJigH1EZAWtuSx92K4Clhi0AfPr+qWlSp39RZBC9YjOE6jaWbBDWq8A4Tw4dDSEMr+
        IpzTqK5i6drwiFWJex6cDGYP23mNt9v5uBdd818dWE0IjALcwMILC2KcmNMqsjnvvAsGnDercP7Xf
        Z/LqHC1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBTp-00D8t3-H0; Thu, 26 Aug 2021 09:15:40 +0000
Date:   Thu, 26 Aug 2021 10:15:25 +0100
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
Subject: Re: [PATCH V4 01/13] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Message-ID: <YSdbrSZTIDjo5sXc@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-2-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-2-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
