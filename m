Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36414738A59
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjFUQBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 12:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbjFUQBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 12:01:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A31D1718;
        Wed, 21 Jun 2023 09:00:43 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 50DBA1EC0102;
        Wed, 21 Jun 2023 18:00:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687363232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Lkm1ovXF8w/3l1dQM0aqJCHQ40tS7jLprFLy/F9Ithw=;
        b=Lv/JZdMzLJ1V/ja2qHoklv+xVmPUhC8fHl072kZMlMYUsq3+WHX3IUW39+KyB0t/lEw0qo
        yqfLsMoXQiRo+HWEdgnUJ3Pl+2fgdjnYUCqaCSlI+WLK7F2BDjwp2JpGDREMwtSfbVfiUa
        8E0ZABH+UD/wNOLXtZBnwgKVZtwnLGc=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id c0Czf9ibAY93; Wed, 21 Jun 2023 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687363227; bh=Lkm1ovXF8w/3l1dQM0aqJCHQ40tS7jLprFLy/F9Ithw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dl+W+sUM4kesP9b6SzA+PpNwR05jkz42fZ+9E5uuznFcOUWKSEQ0dEqEq5BmRH0Mj
         DJnzqmDQz4WQLjr5CbeV6gd9GDImmM0arCnGcOg6d6yLSo2KV3hzkYOeBVL/vuRnzV
         j4sTA0/ymefYw+vms8mVJPf2jNH0zQL16wjEHaeVfAgKKPgadUd2w5GQXb2V1g6QRy
         FOyY/4D0XXiM/UuG1KLYthVwx6ARpb/e/EKMzqFRKgsQw2zGPGGPLVkr/kgCqf79WN
         1zvL2iZMvsIz3iceTKAD2jT8SUlgJ8tUBUwJsierdlrpkurUBS8LAy11xq9KwfxAKF
         R5xQBVMcxygfMuPxx3r0s9FNB5vLMLlOY9uRBhxBU+Ie3dJZ0VoZBS/lq0qpBxF+l+
         nY8UbSYcObQYoK/IxU6V4ELbJ5njZ+AHxdN9ao7qx9MtE+OSbu8+4PcWXmtte9+JvI
         oyhXrFvpXDwoWnQpRttnENERDmZhWfz9XBVcEmKo4j/V8gNFWX2J93R0Yksojs0u9a
         v4zHE95wsyF666l2fIGQqawT449BMG8eyaZagWA0V4Nanc/SkXz6BakXQHiyvwC/Az
         b+2yK5E+sQ35wEtstMK47iRTNyP89w8xgn6ikSiEpk/YgbQeV5cugXbTQLkYGluFAO
         x/Imc81hftUs+JTjh2qoQ0TE=
Received: from zn.tnic (p200300ea971dc565329C23FFfeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c565:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1D60E40E019B;
        Wed, 21 Jun 2023 15:59:46 +0000 (UTC)
Date:   Wed, 21 Jun 2023 17:59:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230621155912.GKZJMeUHzKCFchhE5v@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
 <12f95b38-427c-6810-373a-ba2062c43882@intel.com>
 <20230621091541.GEZJK/veTnfhOnX8ci@fat_crate.local>
 <23f400bc-9a62-be4a-6a24-0e2149d4491c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <23f400bc-9a62-be4a-6a24-0e2149d4491c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 07:31:34AM -0700, Dave Hansen wrote:
> Yep, there's the hardware side and then there are fun nuggets like using
> mem= and then doing a software-only hot-add later after boot.

Ah, right, Mike, I think we need to check whether mem= has any effect on
SNP.

> Also, if the hardware doesn't support any kind of hotplug, it would be
> great to point to the place in the spec where it says that.

I honestly don't know. But I can't recall ever hearing about hardware
memory hotplug so something worth to check too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
