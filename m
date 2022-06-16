Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F19E54DDEF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359112AbiFPJLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376585AbiFPJLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 05:11:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202235536E;
        Thu, 16 Jun 2022 02:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UrepXoaSTZrZ2O7eaVZk9L9kv3mDevlxVcY6WFIRsno=; b=l5odY+OYB0XJt2JD2mKq4mHQD+
        ehSmuOU7iaVBGrx6vUV3IOa0wdlTvebqukU00q4GGoLNMlF+Y3rRetHIraWJo549tmza9Kc1sTVIt
        g7DeNbI+XJs/C8ewt6PRWGpwerQk/hc+gOhSLvrYiCBfBNMMizpEakrHO0OodyajQ0m3u5YogP95v
        FWDnKQL+wrgC6rxsc/ZuY2kgC+gMnDutglLMR2F3pP5JjZF1rZA7jiGn1J2zYHGhFZQZWNVL/WhTU
        S24/7Lda/gU3iX+6ka66WjdaaXE1lQHvyhR85xi/TX+pv6XsXHrf51tw8FZirP2+p2glY7vUdMyDn
        kyBPghAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1lWc-001bUd-M5; Thu, 16 Jun 2022 09:10:50 +0000
Date:   Thu, 16 Jun 2022 02:10:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Message-ID: <Yqrzmr27siGjPB88@infradead.org>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:24AM -0400, Yang Weijiang wrote:
> The purpose of this patch series is to refresh the queued CET KVM
> patches[1] with the latest dependent CET native patches, pursuing
> the result that whole series could be merged ahead of CET native
> series[2] [3].

It might be helpful to explain what CET is here..
