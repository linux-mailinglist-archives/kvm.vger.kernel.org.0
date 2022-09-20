Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51AA5BE6A0
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiITNEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiITNED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:04:03 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA57967C82;
        Tue, 20 Sep 2022 06:04:02 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e791329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e791:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 448AB1EC00F4;
        Tue, 20 Sep 2022 15:03:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663679037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+zoLD08Q5xMXhmLe/ulvlQp2CLhM1jVc65D6yyOhzHY=;
        b=lUXGIVb8ZMDU51Aerv1PBpnFjCxrUMifge5U4PnHOLas5QWK0qmqEZghP7SEf+XTGRS1IU
        5DLN9vUNBc+R7WzqDShMJHUk23alL+UrvtpIaMw0NrmZEZR+mdxg7dq7Iv0aoPka2DeZ+V
        ogPzt/KKjIlUWGwSRjqYOtNSknzMZbQ=
Date:   Tue, 20 Sep 2022 15:03:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 11/49] crypto:ccp: Define the SEV-SNP commands
Message-ID: <Yym6Ob2tPYeb0Kq1@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <f5dec307d246096768afd770d16a26be25fa28b3.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5dec307d246096768afd770d16a26be25fa28b3.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:04:14PM +0000, Ashish Kalra wrote:
> +/**
> + * struct sev_data_snp_platform_status_buf - SNP_PLATFORM_STATUS command params
> + *
> + * @address: physical address where the status should be copied
> + */
> +struct sev_data_snp_platform_status_buf {
> +	u64 status_paddr;			/* In */
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
> + *
> + * @address: physical address of firmware image
> + * @len: len of the firmware image
> + */
> +struct sev_data_snp_download_firmware {
> +	u64 address;				/* In */
> +	u32 len;				/* In */
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_gctx_create - SNP_GCTX_CREATE command params
> + *
> + * @gctx_paddr: system physical address of the page donated to firmware by
> + *		the hypervisor to contain the guest context.
> + */
> +struct sev_data_snp_gctx_create {
> +	u64 gctx_paddr;				/* In */
> +} __packed;

So some of those structs have the same layout. Let's unify them pls.
I.e., for

sev_data_send_finish, sev_data_send_cancel, sev_data_receive_finish

you do

struct sev_data_tx {
	u32 handle;				/* In */
} __packed;

For sev_data_snp_platform_status_buf, sev_data_snp_gctx_create,
sev_data_snp_decommission and all those others who are a single u64, you
use a single

struct sev_data_addr {
	u64 gctx_paddr;				/* In */
} __packed;

so that we don't have gazillion structs all of different names but a lot
of them identical in content.


...

> +/**
> + * struct sev_data_snp_launch_finish - SNP_LAUNCH_FINISH command params
> + *
> + * @gctx_addr: system pphysical address of guest context page
			 ^^^^^^^^^

physical

> + */
> +struct sev_data_snp_launch_finish {
> +	u64 gctx_paddr;
> +	u64 id_block_paddr;
> +	u64 id_auth_paddr;
> +	u8 id_block_en:1;
> +	u8 auth_key_en:1;
> +	u64 rsvd:62;
> +	u8 host_data[32];
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_guest_status - SNP_GUEST_STATUS command params
> + *
> + * @gctx_paddr: system physical address of guest context page
> + * @address: system physical address of guest status page
> + */
> +struct sev_data_snp_guest_status {
> +	u64 gctx_paddr;
> +	u64 address;
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_page_reclaim - SNP_PAGE_RECLAIM command params
> + *
> + * @paddr: system physical address of page to be claimed. The BIT0 indicate
> + *	the page size. 0h indicates 4 kB and 1h indicates 2 MB page.
> + */
> +struct sev_data_snp_page_reclaim {
> +	u64 paddr;
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_page_unsmash - SNP_PAGE_UNMASH command params
> + *
> + * @paddr: system physical address of page to be unmashed. The BIT0 indicate

Is "BIT0" the 0th bit in the address? This needs to be spelled out
explicitly.

also, s/unmash/unsmash/gi

Also, FW SPEC says bits 11:0 are MBZ. So I'm guessing bit 0 is being
cleared before sending it to sw. I guess I'll see that later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
