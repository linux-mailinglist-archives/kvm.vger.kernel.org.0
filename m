Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4635302CB
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343652AbiEVLyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 07:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiEVLyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 07:54:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF852CDC4;
        Sun, 22 May 2022 04:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RzMWJ+V7j6n8wqrdlxSAaZ65WmCdGM5jpjFwYqURuAU=; b=KcmlhnLarEdV5Hogd22WEy04wc
        fIAC//AKmkT1hu9BOGzKTN9giV2GHY/5ZIjNSME5+BVQ7fMpe7aDmjO++gQrc5dfC+ZJb9sFKhrKb
        7YN8508ec+ZXufjZLhiBF1TSGV9hdiz1kfCQG1n354+x+JlVxwgWUCUXc+AI+LVOGZm8D7QTR8vSj
        SIXtAbGQMzxz29kMBziWGwHHot0FIjk8VBwzkRJTG0zc8wPn9jJIZ5LhlMIJFHDKRbcOt6ebCXLPL
        7pBLHdpGi53Qh8WZ0eBhi768k6Q/WocMotP2Wpd1k9NZdTrBNpb3JuK+aEB9yrvbkWWzS8l3/oZOD
        29p2Z10A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nskAB-001Ecq-QI; Sun, 22 May 2022 11:54:23 +0000
Date:   Sun, 22 May 2022 04:54:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-staging@lists.linux.dev,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>, linux-nvme@lists.infradead.org,
        linux-hwmon@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-sparse@vger.kernel.org,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 736ee37e2e8eed7fe48d0a37ee5a709514d478b3
Message-ID: <Yookb5den2ruDBDo@infradead.org>
References: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com>
 <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
 <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
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

How about just turning the MMIO/PIO accessors on m68k into inline
functions as they are on most other architectures?
