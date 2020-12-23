Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057B82E1A14
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 09:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgLWIh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 03:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgLWIh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 03:37:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05328C0613D3
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 00:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UbKHD1D3A6dPfj1vlrTWexn8YHrdnc0Hj54wByFxNDY=; b=lKWPG4Yr0D9q0XFo02cOeSvPj0
        q7s1AcMT59U8DpAakc4fuNq/nLg0pGbo+WmzCu8qa5KINlR3mX/blceAFGnlaClhbeP5hDrSa9htc
        5RsT05zVjXTkfYDMRUTn2qycH33gRrmhiDSNqXdnComAGLg0w6/9NsFo3dtNLjpzzAGW7Qz2R3dtQ
        OySPx+Orshw9hXa85Ck0yeg9XYZ8MIrIgiuv2grwzAO7kdVets/wkERZf1w3dXPWrA0+eExQW9VYz
        aoxniLhy2xgXicmmOUZ2XAaAlZLyIwb3aw+F4bH5NdmaBNysUc62SYneOWAcefKIoS8MFvDOUQMF9
        fE/KUCCw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krzdU-0007Y5-GC; Wed, 23 Dec 2020 08:36:44 +0000
Date:   Wed, 23 Dec 2020 08:36:44 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 03/17] KVM: x86/xen: intercept xen hypercalls if
 enabled
Message-ID: <20201223083644.GC27350@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-4-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214083905.2017260-4-dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think all the Xen support code should be conditional on a new config
option so that normal configs don't have to build the code (and open
potential attack vectors).
