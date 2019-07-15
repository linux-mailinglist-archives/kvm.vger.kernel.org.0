Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985D269056
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390455AbfGOOUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:20:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389923AbfGOOUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XUMcM3p/qnvRPDxgVJtrMmN7KVyZqOJ6ChxzB0K7L+E=; b=a7EL+xYRoAG37/eyYpwGYpZho
        X7xg/QFkqobtLjv+zUNje5j3qcSas8r+c/uuytTwNDDt8etaTc9B8RRZN45reaq1MMwWgD73kwo9x
        5S4s4Q9GPr5lbHkGGv8FDt6whpwQdwGQUGRPdSlH3oWXGN1CfAMb/H2AuH+U/+0zNxJ607SVUHc4R
        qOw6M5r/HqzmTTSMAZmYAcPLRnS9k7W2bRZJp9j9Raqei3J2Q7KMkTX94IvYyHWxGerXDKmkmnaAs
        5BRSpmrcK35SIn47cqUOrlyiTgLoKe3sCplTY/OiU7NcyJDV8OH2AR4KBsV9axGdp62KUvbba2t+Q
        BmhXSjJXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hn1qP-0004du-5m; Mon, 15 Jul 2019 14:20:45 +0000
Date:   Mon, 15 Jul 2019 07:20:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Message-ID: <20190715142045.GA908@infradead.org>
References: <20190715131719.100650-1-pasic@linux.ibm.com>
 <20190715132027.GA18357@infradead.org>
 <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ok,

I've folded the minimal s390 fix in, please both double check that this
is ok as the minimally invasive fix:

http://git.infradead.org/users/hch/dma-mapping.git/commitdiff/7bb9bbcee8845af663a7a60df9e2cc24422b3de5

The s390 fix to clean up sev_active can then go into the series that
Thiago is working on.
