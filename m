Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399763D5BC2
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhGZNzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhGZNzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 09:55:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755BEC061757;
        Mon, 26 Jul 2021 07:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=DxQcM5qKPQE1UMRivapeHbOVlZ1Jd9bhHUKcDhnfcZM=; b=ajIxUp2uO0P+KO+9P9GlTGYa1G
        H5TpSzHZJiproSdaTsUPRCe4/BKMffBukqPkU0ex70jTo56KN85w2wy982hI8gSmQ7iOFE6dIsaAy
        E2f/RW1Psqp8X85qcIGuBCIdB/ZBaVF7PbxalJ/evzNT07FL+damoXZmjeZ4jINOLLXOHUXKg+SuM
        ePNZhYzM9huZsJKr95pbMWHFaFSAlRiyJiBGMT8xyB9gKxqG8qxwLg2FzQ0V7EJxFhtmq1UTJ9vTN
        9LFbpgI4XD44QluB1iWEuVKHnVJZPNVGIbsHb0QO5LgBLntvOu9cDLDltzCtGogyZgyiZ6q6MASCs
        8xJjxCHw==;
Received: from [2001:4bb8:184:87c5:ee29:e765:f641:52d7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m81hV-00E2bQ-LL; Mon, 26 Jul 2021 14:35:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: two small mdev fixups
Date:   Mon, 26 Jul 2021 16:35:22 +0200
Message-Id: <20210726143524.155779-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

two small mdev fixes - one to fix mdev for built-in drivers, and the other
one to remove a pointless warning.
