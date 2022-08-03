Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA12258856D
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 03:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiHCBaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 21:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiHCBaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 21:30:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B4810A1;
        Tue,  2 Aug 2022 18:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659490214; x=1691026214;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=l6tf+gFEwiZ1TzfGKtSasMdKi0NoDSHlgfiI31cXsXo=;
  b=GMK82YgQo48DiiXpf/rVeSth50ldU5KGPeNwOVckW3XEWZ6BgMpFrUix
   JnGDnFqw4xpQmzjWlWWf1KhNu1/8hRpmmoqcehiFtk0IsAvY10V2u45Fb
   7LqLG3LYdQx/8YZtfqK0mUunQm6ZIBEkeJ5wS44CPCSIYfQ74Nt8Iehgg
   XSPinD1DCgteXO6l6e708GDOhic3lslcJvkHurHBN2XE9RIiB+e+Ge5Xv
   JdeiBmCybit6PzC+dHpL19K/g+6ADU4+tEAJZwl5IKV7S1FDjtpZ5uKB4
   472l04RuX3zGBC+X22uLIRePzG9MwmtZVMRyQVH5rNvqY8fDZ9baEY/JQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269328390"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="269328390"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 18:30:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="930195098"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 18:30:11 -0700
Message-ID: <d3236016c46da2cbdf314839255e8806ae23f228.camel@intel.com>
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 03 Aug 2022 13:30:09 +1200
In-Reply-To: <da423f82faec260150b158381a24300f3cd00ffa.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
         <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
         <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
         <da423f82faec260150b158381a24300f3cd00ffa.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 11:34 +1200, Kai Huang wrote:
> > Why not just entirely remove the lower 1MB from the memblock structure
> > on TDX systems?=C2=A0 Do something equivalent to adding this on the ker=
nel
> > command line:
> >=20
> > =C2=A0	memmap=3D1M$0x0
>=20
> I will explore this option.=C2=A0 Thanks!

Hi Dave,

After investigating and testing, we cannot simply remove first 1MB from e82=
0
table which is similar to what 'memmap=3D1M$0x0' does, as the kernel needs =
low
memory as trampoline to bring up all APs.

Currently I am doing below:

--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -65,6 +65,17 @@ void __init reserve_real_mode(void)
         * setup_arch().
         */
        memblock_reserve(0, SZ_1M);
+
+       /*
+        * As one step of initializing the TDX module (on-demand), the
+        * kernel will later verify all memory regions in memblock are
+        * truly TDX-capable and convert all of them to TDX memory.
+        * The first 1MB may not be enumerated as TDX-capable memory.
+        * To avoid failure to verify, explicitly remove the first 1MB
+        * from memblock for a TDX (BIOS) enabled system.
+        */
+       if (platform_tdx_enabled())
+               memblock_remove(0, SZ_1M);

I tested an it worked (I didn't observe any problem), but am I missing
something?

Also, regarding to whether we can remove platform_tdx_enabled() at all, I l=
ooked
into the spec again and there's no MSR or CPUID from which we can check TDX=
 is
enabled by BIOS -- except checking the SEAMRR_MASK MSR, which is basically
platform_tdx_enabled() also did.

Checking MSR_MTRRcap.SEAMRR bit isn't enough as it will be true as long as =
the
hardware supports SEAMRR, but it doesn't tell whether SEAMRR(TDX) is enable=
d by
BIOS.

So if above code is reasonable, I think we can still detect TDX during boot=
 and
keep platform_tdx_enabled(). =C2=A0

It also detects TDX KeyIDs, which isn't necessary for removing the first 1M=
B
here (nor for kexec() support), but detecting TDX KeyIDs must be done anywa=
y
either during kernel boot or during initializing TDX module.

Detecting TDX KeyID at boot time also has an advantage that in the future w=
e can
expose KeyIDs via /sysfs and userspace can know how many TDs the machine ca=
n
support w/o having to initializing the  TDX module first (we received such
requirement from customer but yes it is arguable).

Any comments?

--=20
Thanks,
-Kai


