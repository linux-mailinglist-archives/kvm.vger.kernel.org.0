Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6859327917
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 09:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhCAIXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 03:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhCAIXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 03:23:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87C1C06174A;
        Mon,  1 Mar 2021 00:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bMPJOhHJpWZ3kqtoodBrXg1OQ6T3aYVqfcZl+yljkhk=; b=seHcwHQLfI/dHDq7R7BujUX7Ti
        LYEDLwE/pzAWgLFY4dfF2z/u6IUBmGD9Av0T7Wjrovpkj/l2w0jCR44M2KDJRDRCNPhcQkmErhEXj
        e7FcOolKSDUmucZmwv1nnfpL64kJSnoXwyp33POJH3unEJoz4Ybk8ROBizIn7lr2SD+OPn4XNJW2z
        anoOabPdZ17AUErbQRzUsghKjE7mBWMNoX/H6ut3YY3//ZsI57gK/83fYgISl4CnCb97S38Z0Czmq
        Y2T2F9wapKqZWHd8AMW262DxOzeLEgE4NggwBxNRgxH0J+A8RYDzXuh3JsBgS2y/4inBtb9iSy2cB
        cmY49w7g==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGdp6-00FTKX-5D; Mon, 01 Mar 2021 08:22:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: remap_vmalloc_range clenaups
Date:   Mon,  1 Mar 2021 09:22:33 +0100
Message-Id: <20210301082235.932968-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

this series removes an open coded instance of remap_vmalloc_range and
removes the unused remap_vmalloc_range_partial export.
