Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75AF4D9581
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 08:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345572AbiCOHmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 03:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245061AbiCOHmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 03:42:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE0F4B42C;
        Tue, 15 Mar 2022 00:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DOTkQJfoLEVZR3YEf0I+ot6r77i9yyI2MaiD+Wdu3Nk=; b=VsfoF85K7ycrZAAfF0QuxbxLZQ
        Wpcqd3w6qhDP0WroGGOS3HzOohOxc6RTFYml8r1bgSe0O+tdI3lCuPZROpI0Pvxt+7GUvn23y3VQp
        G9XTlOIm9dYxsTdOohdsmUr37L1ITUuFEp4YcbBAquT07jRN6RUzDq3UZmiWVncrvM/Z9OAoJe/rB
        tn820c/f1yVmjr+AsYkvVnacRhSdtc+YJYLQFEIp/rrrgBSxHHZe56rtxf0aLUAvNlIiIMfoDru+N
        7T2lSgEjnO2SlFeQFk9A/iFWDvnRTt5DTA+tFUZLhZcKh6IuAunQks2gzwxiuji5HBldSzxU4G0Rc
        t0i85tDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nU1o5-0089W4-7o; Tue, 15 Mar 2022 07:41:25 +0000
Date:   Tue, 15 Mar 2022 00:41:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] vfio-pci: Provide reviewers and acceptance criteria for
 vendor drivers
Message-ID: <YjBDJcaU7spuEwAg@infradead.org>
References: <164727326053.17467.1731353533389014796.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164727326053.17467.1731353533389014796.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please stop the factually incorrect and misleading "vendor drivers"
term.  It is a driver for a specific piece of harware, which has
absolutely nothing to do with a vendor and with an open spec can
easily support devices from multiple vendors.
