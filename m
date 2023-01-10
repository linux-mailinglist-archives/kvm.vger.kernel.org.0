Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B7663C66
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 10:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjAJJLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 04:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbjAJJKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 04:10:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C4193D9;
        Tue, 10 Jan 2023 01:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=B7sGmSmXqXdck4MSb4UdnDVnJ5cP+hxBfzPSNoLBlas=; b=H++a8/OB8Gph+evoX6G3aPlj1z
        +i6Vgp0jxN9tIF/xZFKGnKV14cCjfSQIFV1i7lRhSvevb/3EuEoBVyY/u2k58CrZIsKCruEQI+H7m
        +hFHcoh1JAgVqidnjH9+TITs1EHV6t2Qt7WFLuPO7s2Yf+IYBJdD+n60G1GdUCvb3gsJwMuaDaDt+
        uDPuiOJnAKxyhYNR2gINgVczKp78Kb+hJ6dioAlD7FFV8JxmN/BbgsjE1z6Z/R4/o43rhk5pXT7Wp
        /lYhrXoq+5Fv9yKqQ0GWxw5H+cLaq+PYKQLLqgpC9yCeZFBYxwBWXI5ptX6GIkql0ZYc6ops7I5N7
        RgwlWvpw==;
Received: from [2001:4bb8:181:656b:cb3a:c552:3fcc:12a6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFAe4-0060ZL-9E; Tue, 10 Jan 2023 09:10:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: misc mdev tidyups
Date:   Tue, 10 Jan 2023 10:10:05 +0100
Message-Id: <20230110091009.474427-1-hch@lst.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

this series tidies up the mdev Kconfig interaction and documentation a bit.

Diffstat:
 Documentation/driver-api/vfio-mediated-device.rst |  108 ----------------------
 Documentation/s390/vfio-ap.rst                    |    1 
 arch/s390/Kconfig                                 |    6 -
 arch/s390/configs/debug_defconfig                 |    1 
 arch/s390/configs/defconfig                       |    1 
 drivers/gpu/drm/i915/Kconfig                      |    2 
 drivers/vfio/mdev/Kconfig                         |    8 -
 samples/Kconfig                                   |   16 +--
 samples/vfio-mdev/README.rst                      |  100 ++++++++++++++++++++
 9 files changed, 115 insertions(+), 128 deletions(-)
