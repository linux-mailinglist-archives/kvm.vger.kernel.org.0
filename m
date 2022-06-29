Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5855F5B6
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 07:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiF2Fdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 01:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiF2Fdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 01:33:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB3D27B34;
        Tue, 28 Jun 2022 22:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FbEvqEy+fYGlXKZrnIIoOL2iLtQoh0T/Yu7KaUG/sgg=; b=XJ5oufC1GoEYCJmTAfK+EQMjzl
        50umc6ROawWzUFFuFK2gHouvKuT8ubF3doHQ/xNjYmlNWVkyQ2mlJy/dmgKzTwADnLDNHyBOnxObY
        WMMNHaLieqeChcK+YJjafHB0nPl3mE84IkwlDhNjsw9iVbSrzltyYTkxfceTDyJtWCIKzIp2BgM4p
        D9m6NCHDfalkjZxGgYEOZ1Hh0yUL1VgjIxaAJHpBfMASIVM4l8JtUE0NCuYUCD0Nhd1/ci3NVaygo
        R6dn+gQvKNz7EakgjWgIRUYBw5MLePf+tu/H1jL0QEb+bt/tO/GtuhFUmNEGkT/skyC0z6iaYnf60
        hZpEt0xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6QKR-009c2W-KM; Wed, 29 Jun 2022 05:33:31 +0000
Date:   Tue, 28 Jun 2022 22:33:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
Message-ID: <YrvkK6794URE1Xod@infradead.org>
References: <cover.1655894131.git.kai.huang@intel.com>
 <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
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

On Wed, Jun 22, 2022 at 11:15:43PM +1200, Kai Huang wrote:
> Platforms with confidential computing technology may not support ACPI
> CPU hotplug when such technology is enabled by the BIOS.  Examples
> include Intel platforms which support Intel Trust Domain Extensions
> (TDX).

What does this have to to wit hthe cc_platform abstraction?  This is
just an intel implementation bug because they hastended so much into
implementing this.  So the quirks should not overload the cc_platform
abstraction.

