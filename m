Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A305F602418
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 08:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJRGDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 02:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRGDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 02:03:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE292F62
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 23:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bQTF/41gYM4WKw51icodbv0U0h
        eyMbgVV2qmcrl14Ix5p//51S2ZbzyphGgZhFDukdDhtCICf4nLqMHIL6mqHTaMSjIZm0X8lfQzJ6w
        igDljG57mhKZlgryh58iH2Td5oxxcs0YS8W7q+oLPINSwFjrD1wKE278SuiuXl7lhGtXkQ1/Ek5yD
        rxhlJLeSEEpVNZJH+A0NLdtSKlEVJF/WEBQr8gEsmdbsHDqrnKhW5Eyc17dlpGAQBgvgLZaRFsqB7
        gVokOO7Zz/BuRwMz6+MqIpCrtmIR6ILL7k4L8CMfxAIIW0W8s1alehmnbU0jCpTMETE8mkVCTaIJS
        HsBj9dFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okfhE-003Cxw-4J; Tue, 18 Oct 2022 06:03:24 +0000
Date:   Mon, 17 Oct 2022 23:03:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/5] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <Y05BrJiplThDwq8F@infradead.org>
References: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
 <1-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
