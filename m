Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE74CF2CE
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 08:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbiCGHpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 02:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiCGHpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 02:45:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20440DEE8;
        Sun,  6 Mar 2022 23:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=x/SZteRbhlyrKqcw/2wBmCygnukv9aFx/t2Ex3L/kzY=; b=mMEHJyAcCFJ4UhmrUkyZJYz6NI
        +BQpkgj3s0V+Es79ZuiNVll3rGcNM/VJWGYVvwAMklab3zA/mIwK/vbItTw5d6e2sNXEi/wLOlRn2
        hDXS/VENdeprp9XAdMP/Gg0hzTVWtOiW59Pyy3Fmnt/w+U4Xd4ySbcoRtZS+wwTCmB4rS43cTmXLO
        NpfK7MFtr2D28nBgvAZkxV6vtGwrTln8xHC4NjtN3W/CKpSOGbHxhAV62OHYeGyYw75lJ2M8L4oih
        GfluJiAbXr6KKmxfZ8aelatkF7E7ktG46VvhfjCsGq7Os1FVaR78QWenUflAQOvDuiICENorNUYcr
        9obc11oQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nR82d-00GJLX-6U; Mon, 07 Mar 2022 07:44:27 +0000
Date:   Sun, 6 Mar 2022 23:44:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 000/104] KVM TDX basic feature support
Message-ID: <YiW327HAJVizRJHZ@infradead.org>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
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

A series of 104 patches is completely unreviewably, please split it into
reasonable chunks.
