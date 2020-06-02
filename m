Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10A21EBE45
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgFBOgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 10:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgFBOgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 10:36:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAC7C08C5C0;
        Tue,  2 Jun 2020 07:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=DxdTT4Dw2u+im0Qu8w8iSwPF7RQwntfgescQKCvM7+A=; b=mAxwSGQTs+bHv2LRSurWTaylsT
        6hQTdpuBFmzPwH1qQkKFBtvR2frZ9UB6Y2xoYuqYVkbmO3vR60C/D0iAM7hpyQ1950OnYsoph+u4L
        4Im1p8CtbEw4tVq1yKRXx6k30/rZFYN1BAdwZGvJGF4dq4d0tp0c5wduM3ZNycaj6iWmAugnU+0rW
        FZvm96rNFw1ZH1eAFBu07arN3Wwns0d318KEb7K99z6jSMS/rCv2AF6Xyn/CHRLlo2NEFMa52VtiZ
        BdSHYX2xnd6Ohoy1PwjBII6UOioEpfpacNf9lG2igBUciL4X+ZhYvJBeFqslkW+Ix6z/TZgpW+4R5
        LgCRf1Ew==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jg822-00081h-CF; Tue, 02 Jun 2020 14:36:46 +0000
Subject: Re: linux-next: Tree for Jun 2 (vfio)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>
References: <20200602203737.6eec243f@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <96573328-d6d6-8da2-e388-f448d461abb3@infradead.org>
Date:   Tue, 2 Jun 2020 07:36:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602203737.6eec243f@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/20 3:37 AM, Stephen Rothwell wrote:
> Hi all,
> 
> News: The merge window has opened, so please do *not* add v5.9 material
> to your linux-next included branches until after v5.8-rc1 has been
> released.
> 
> Changes since 20200529:
> 

on i386:

ld: drivers/vfio/vfio_iommu_type1.o: in function `vfio_dma_populate_bitmap':
vfio_iommu_type1.c:(.text.unlikely+0x41): undefined reference to `__udivdi3'


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
