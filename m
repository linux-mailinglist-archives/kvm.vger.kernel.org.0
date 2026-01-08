Return-Path: <kvm+bounces-67322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3DAD00C87
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D77E3028FF5
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E61B284669;
	Thu,  8 Jan 2026 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D9mmysE+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856B227FB34
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841605; cv=none; b=qqrkK81aDGSmx/pZVb6b1AjTulMOCCjnE5iPZgO+dqL3F3RNbPSLekVqmrD2VYtTyC1Uv3lVdjAt2NkqcrEHILlorH+/yGvVzeY4bdudyUnNBePDAF4aDlMjl4ulwaLs2DJ/c+RX0Q4yLKOen93wyflzDGNjm+U/EoYnFJWQHoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841605; c=relaxed/simple;
	bh=db3qja+kX083B6+UzCGJxLKjvW/gb7ZPUoZ7IK0uF60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WuHh0JDMziFb61XZ60tbCbTZinr/B2lrK/1wtTnVcjDsUy7F3k+1RVz5L/9+yFo1gFXQXNJRBOhZcJVtPZUE0Z1eiJFzg1JsyEpA1S4RPSIyxbYPyGB9vrjENaqMVFkwLOFnPaIZ1fh9lxeFJYo6IJWRVQA1JYJl1seOUZzHsEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D9mmysE+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841604; x=1799377604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=db3qja+kX083B6+UzCGJxLKjvW/gb7ZPUoZ7IK0uF60=;
  b=D9mmysE+ToKf80Up1YwFimQYIBovmoR5yafhbIlf5FvYbBxUrux5ATHw
   FgUzsDE7U/rUmCg7GOtD4p2PCjbGOSpg5Gm/10lfe8+jUGATao2X7C6KO
   AzZw0I/1tSNlcFxC0a5Ywjg7ptDFTbP/R8uK3Nnm0/gzJLLSUs+EKzCjs
   ITMVvSvMrPHgpt2zwZ50PdsspE24Yn3OVdko7BNCL5p9O3PZogFUuMyCp
   7w+j+OPsIzI5fNruWmvDVYuKdn7jOjtsm2TnavprE5OnW9RKbQrdln9D6
   FFqYjnc5TuQAX5+gNkpkTHUvFfta89SnhIuxg6gSIEn6XhI25mS0IMMDm
   Q==;
X-CSE-ConnectionGUID: ZRxbjlH1QEOCJBRAWY11Iw==
X-CSE-MsgGUID: 56fmeSZzTzi1tUENe12SwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877090"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877090"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:06:43 -0800
X-CSE-ConnectionGUID: jhjTk7MuQ02pJA2MeiRrCQ==
X-CSE-MsgGUID: 25rxTYTyTMijk2mwGBJf9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202210696"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:06:33 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 07/27] tests/acpi: Update DSDT tables for pc & q35 machines
Date: Thu,  8 Jan 2026 11:30:31 +0800
Message-Id: <20260108033051.777361-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now the legacy cpu hotplug way has gone away, and there's no _INIT
method in DSDT table for modern cpu hotplug support.

Update DSDT tables for pc machine, and_INIT methods are removed from
DSDT tables:

  -            Method (_INI, 0, Serialized)  // _INI: Initialize
  -            {
  -                CSEL = Zero
  -            }

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
---
Changes since v5:
 * Merge pc & q35 changes into one patch and simplify the commit
   message.

Changes since v4:
 * New patch.
---
 tests/data/acpi/x86/pc/DSDT                   | Bin 8611 -> 8598 bytes
 tests/data/acpi/x86/pc/DSDT.acpierst          | Bin 8522 -> 8509 bytes
 tests/data/acpi/x86/pc/DSDT.acpihmat          | Bin 9936 -> 9923 bytes
 tests/data/acpi/x86/pc/DSDT.bridge            | Bin 15482 -> 15469 bytes
 tests/data/acpi/x86/pc/DSDT.cphp              | Bin 9075 -> 9062 bytes
 tests/data/acpi/x86/pc/DSDT.dimmpxm           | Bin 10265 -> 10252 bytes
 tests/data/acpi/x86/pc/DSDT.hpbridge          | Bin 8562 -> 8549 bytes
 tests/data/acpi/x86/pc/DSDT.hpbrroot          | Bin 5100 -> 5087 bytes
 tests/data/acpi/x86/pc/DSDT.ipmikcs           | Bin 8683 -> 8670 bytes
 tests/data/acpi/x86/pc/DSDT.memhp             | Bin 9970 -> 9957 bytes
 tests/data/acpi/x86/pc/DSDT.nohpet            | Bin 8469 -> 8456 bytes
 tests/data/acpi/x86/pc/DSDT.numamem           | Bin 8617 -> 8604 bytes
 tests/data/acpi/x86/pc/DSDT.roothp            | Bin 12404 -> 12391 bytes
 tests/data/acpi/x86/q35/DSDT                  | Bin 8440 -> 8427 bytes
 tests/data/acpi/x86/q35/DSDT.acpierst         | Bin 8457 -> 8444 bytes
 tests/data/acpi/x86/q35/DSDT.acpihmat         | Bin 9765 -> 9752 bytes
 .../data/acpi/x86/q35/DSDT.acpihmat-generic-x | Bin 12650 -> 12637 bytes
 .../acpi/x86/q35/DSDT.acpihmat-noinitiator    | Bin 8719 -> 8706 bytes
 tests/data/acpi/x86/q35/DSDT.applesmc         | Bin 8486 -> 8473 bytes
 tests/data/acpi/x86/q35/DSDT.bridge           | Bin 12053 -> 12040 bytes
 tests/data/acpi/x86/q35/DSDT.core-count       | Bin 12998 -> 12985 bytes
 tests/data/acpi/x86/q35/DSDT.core-count2      | Bin 33855 -> 33842 bytes
 tests/data/acpi/x86/q35/DSDT.cphp             | Bin 8904 -> 8891 bytes
 tests/data/acpi/x86/q35/DSDT.cxl              | Bin 13231 -> 13218 bytes
 tests/data/acpi/x86/q35/DSDT.dimmpxm          | Bin 10094 -> 10081 bytes
 tests/data/acpi/x86/q35/DSDT.ipmibt           | Bin 8515 -> 8502 bytes
 tests/data/acpi/x86/q35/DSDT.ipmismbus        | Bin 8528 -> 8515 bytes
 tests/data/acpi/x86/q35/DSDT.ivrs             | Bin 8457 -> 8444 bytes
 tests/data/acpi/x86/q35/DSDT.memhp            | Bin 9799 -> 9786 bytes
 tests/data/acpi/x86/q35/DSDT.mmio64           | Bin 9570 -> 9557 bytes
 tests/data/acpi/x86/q35/DSDT.multi-bridge     | Bin 13293 -> 13280 bytes
 tests/data/acpi/x86/q35/DSDT.noacpihp         | Bin 8302 -> 8289 bytes
 tests/data/acpi/x86/q35/DSDT.nohpet           | Bin 8298 -> 8285 bytes
 tests/data/acpi/x86/q35/DSDT.numamem          | Bin 8446 -> 8433 bytes
 tests/data/acpi/x86/q35/DSDT.pvpanic-isa      | Bin 8541 -> 8528 bytes
 tests/data/acpi/x86/q35/DSDT.thread-count     | Bin 12998 -> 12985 bytes
 tests/data/acpi/x86/q35/DSDT.thread-count2    | Bin 33855 -> 33842 bytes
 tests/data/acpi/x86/q35/DSDT.tis.tpm12        | Bin 9046 -> 9033 bytes
 tests/data/acpi/x86/q35/DSDT.tis.tpm2         | Bin 9072 -> 9059 bytes
 tests/data/acpi/x86/q35/DSDT.type4-count      | Bin 18674 -> 18661 bytes
 tests/data/acpi/x86/q35/DSDT.viot             | Bin 14697 -> 14684 bytes
 tests/data/acpi/x86/q35/DSDT.xapic            | Bin 35803 -> 35790 bytes
 tests/qtest/bios-tables-test-allowed-diff.h   |  42 ------------------
 43 files changed, 42 deletions(-)

diff --git a/tests/data/acpi/x86/pc/DSDT b/tests/data/acpi/x86/pc/DSDT
index 4beb5194b84a711fcb52e3e52cc2096497d18442..6ea2d36d138daffb59a8636759078500adc58f24 100644
GIT binary patch
delta 39
vcmZ4NJk6QQCD<ionj!-O<M)kRr+K(so#KO?;-j0qIVa!enYp=@S55=~{=N*|

delta 53
zcmbQ{yx5t`CD<iou_6Nl<A;r0r+K)Xoa2L?;-i~9xF+A{naL}{6YuHg$x*=I9PH||
Jxq??t1OUPD58VI&

diff --git a/tests/data/acpi/x86/pc/DSDT.acpierst b/tests/data/acpi/x86/pc/DSDT.acpierst
index abda6863b64c5dc8ba5aba1a286cbfa76772a1e4..d8c173aa613f51b1c76ea7b9dee19e899cba240d 100644
GIT binary patch
delta 39
vcmX@*wAYEtCD<jzR*`{$(S9S>X&x?Dr}$u}_~<5Y&dK+AW^QifJt_<U?(Yn~

delta 53
zcmdn%bjpd#CD<jzOOb(r(PAUlX&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
JuHZc?3;?HG5552Z

diff --git a/tests/data/acpi/x86/pc/DSDT.acpihmat b/tests/data/acpi/x86/pc/DSDT.acpihmat
index d081db26d7ba504b3344fad130d5812419291ac0..ba363d6af76af728b7c88bbaf47f7e0ea3dcb41f 100644
GIT binary patch
delta 39
vcmccMd)SxDCD<k8uo?pc<CcwFr+K(sJmQ0$;-j0qIVa!enYp=@*IN<*4-pM<

delta 53
zcmX@?d%>5>CD<k8f*Jz@<Jyf}r+K&>J>!F&;-i~9xF+A{naL}{6YuHg$x*=I9PH||
Jxq{bQ5&+kc5ODwi

diff --git a/tests/data/acpi/x86/pc/DSDT.bridge b/tests/data/acpi/x86/pc/DSDT.bridge
index e16897dc5f0fbb3f7b4de8db913884046246cc3b..b68302363cb24181988d6e3dceb04a0946838d5e 100644
GIT binary patch
delta 39
vcmexW@wS4?CD<h-*M@<Ck#!^2X&x?Dr}$u}_~<5Y&dK+AW^Qif{i+855Lyl9

delta 53
zcmaD`@vDN%CD<jT%7%e~@!v+S(>z>G&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
JT*3QQ4*>hl5#|5@

diff --git a/tests/data/acpi/x86/pc/DSDT.cphp b/tests/data/acpi/x86/pc/DSDT.cphp
index e95711cd9cde5d50b841b701ae0fed5a4b15e872..20688edf2da41146ece4faa4141517408a42870c 100644
GIT binary patch
delta 39
vcmezD_RNjTCD<h-O__m#F>52&X&x@u`1oL__~<5Y&dK+AW^QifeJ2V42kQ;C

delta 53
zcmaFn_SucgCD<jTSeb!=F?l1`X&x@8g!o{m_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
JuHbzq3INN05VimS

diff --git a/tests/data/acpi/x86/pc/DSDT.dimmpxm b/tests/data/acpi/x86/pc/DSDT.dimmpxm
index 90ba66b9164f9a958d5a3c4371b1eec03e922828..8d4be05d2c71ca8de6d732d3e48e0e323143160c 100644
GIT binary patch
delta 39
vcmbOk&=bJr66_Mfqrt$yD87;FJ`a~)aD1>+d~}mH=j6{kGdIuVZIA*0-<AwM

delta 53
zcmeAPm>Iz366_KpslmX&D6o<1J`b07NPMtUd~}ls*W}MUGkHaL;ywL5ISLq@gI#?#
J_wY7I0RWRv4?X|@

diff --git a/tests/data/acpi/x86/pc/DSDT.hpbridge b/tests/data/acpi/x86/pc/DSDT.hpbridge
index 0eafe5fbf3d73719c9c3e6e26371863bfb44ed2f..2b5b885b862a2fe8bc4a24446400dccf685dab85 100644
GIT binary patch
delta 39
vcmez5^wf#VCD<h-Rgr;#QF|lTX&x?Dr}$u}_~<5Y&dK+AW^QifeJczA{o4&n

delta 53
zcmaFr^vQ|KCD<jTNRfeoQDr07X&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
JuHbzu3;?^p5J~_5

diff --git a/tests/data/acpi/x86/pc/DSDT.hpbrroot b/tests/data/acpi/x86/pc/DSDT.hpbrroot
index 077a4cc988dc417a1bc9317dddd2dbd96ff1ff50..cc6f26a3f8fe85f34a8acb5432bab3cf4d3ab1f6 100644
GIT binary patch
delta 39
vcmaE(eqWu-CD<k8zAys=W7bBl9BwXGr}$u}_~<5Y&dCkjGdHX89AgIn`U?zT

delta 53
zcmcbw{zje4CD<k8jW7cPWAa9>9BwWr=lEc!_~<4NuE`DDGkHaL;ywL5ISLq@gI#?#
JOY$6J2LQ7!4`2WQ

diff --git a/tests/data/acpi/x86/pc/DSDT.ipmikcs b/tests/data/acpi/x86/pc/DSDT.ipmikcs
index 8d465f027772f9c59b0c328c1a099e374a6d2a90..052a84e294eee4ecef9a36341493f841caf887a5 100644
GIT binary patch
delta 39
vcmaFue9xK7CD<k8o+1MSWAR3=(>z?RPVvD`@zG7*oRjbK%-r0{n<fGP5J?Sr

delta 53
zcmccT{MwnzCD<k8wITxpW6nmd(>z>G&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
JT)~?r0sz<r5P1Lq

diff --git a/tests/data/acpi/x86/pc/DSDT.memhp b/tests/data/acpi/x86/pc/DSDT.memhp
index e3b49757cb7abd7536ee89a6824967d2cb2485cf..7efc12a46cb87c0684b7d880b2cc94d302744e03 100644
GIT binary patch
delta 39
vcmez5`_z}qCD<k8sTu<V<LQlDr+K)%o#KO?;-j0qIVa!enYp=@H&+q>AHfb0

delta 53
zcmaFr`^lHfCD<k8lNtj9<B^SAr+K(Moa2L?;-i~9xF+A{naL}{6YuHg$x*=I9PH||
Jxq>%W5&-Wd5fK0Y

diff --git a/tests/data/acpi/x86/pc/DSDT.nohpet b/tests/data/acpi/x86/pc/DSDT.nohpet
index 9e772c1316d0ea07c51717466c4c7e383553f345..7eedfcd64ebd0193744864b4f6cbead35c7c3ab2 100644
GIT binary patch
delta 39
vcmbR0)ZxVC66_Mfp~%3%cwi%!Ef1HgQ+%*fd~}mH=j1@1nVY}!$cX>|)oKe*

delta 53
zcmeBhn(D;m66_Kps>r~=xN{?yEf1HIb9}H<d~}ls*W^H+nY<!A@t%I390d%{!LB}=
JU-8I^004Ze4o?68

diff --git a/tests/data/acpi/x86/pc/DSDT.numamem b/tests/data/acpi/x86/pc/DSDT.numamem
index 9bfbfc28213713c208dfc38a85abb46fb190871d..910b4952a0757025cfed1c60416d16054e70846f 100644
GIT binary patch
delta 39
vcmZ4KJja>KCD<iojv@mCWAjF?(>z?>PVvD`@zG7*oRjbK%-r0{t0Dpb_GAo)

delta 53
zcmbQ^ywaJ=CD<ior6L0ZW6egc(>z=r&hf!c@zG5lT$Atf%;Xi}iTCvL<S1Zp4tDj~
JT*0d%0syp+4~GB%

diff --git a/tests/data/acpi/x86/pc/DSDT.roothp b/tests/data/acpi/x86/pc/DSDT.roothp
index efbee6d8aa5c62ff4fcb83e6c5cff59542977850..45d3dbe1b69143a956b4f829913ca47f07134741 100644
GIT binary patch
delta 39
vcmey8@H~ObCD<h--GG6Cv3VocX&x?Dr}$u}_~<5Y&dK+AW^QifeXj%n5y%b%

delta 53
zcmaE!@FjuECD<jT#DIZ;v1TLJX&x>o=lEc!_~<4NuF3a#X7Y;g#C!UAauhH)2fO-g
JuHb#I1OV9F5d;7L

diff --git a/tests/data/acpi/x86/q35/DSDT b/tests/data/acpi/x86/q35/DSDT
index e5e8d1e041e20e1b3ee56a5c93fe3d6ebd721ee6..377e880175f6f11101548c0c64da61b5aee00bd9 100644
GIT binary patch
delta 39
vcmez2_}Y=nCD<k8wE_bJ<I#;=l9F7mPVvD`@zG7*oRf7WXKubMsmcxj3Rw)V

delta 53
zcmaFu_`{LQCD<k8hXMlw<Gzhtl9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
JJ|?Nk4gkhs53c|K

diff --git a/tests/data/acpi/x86/q35/DSDT.acpierst b/tests/data/acpi/x86/q35/DSDT.acpierst
index 072a3fe2cd17dfe06658dfd82588f69787810114..026bfdfebf66c1803f158ac8c115eb5f49b5cb19 100644
GIT binary patch
delta 39
vcmeBl`s2vu66_N4M}dKXF?A!Cq$HQCQ+%*fd~}mH=VV>UnVT<5ny~`_^t=od

delta 53
zcmez4*y+UO66_MfsmQ><7`u^6Qj*KbIX>7aKDx<+YqGB7OkNS5cuzl1jsgbfU{{~b
I$0W_z0eo!^6aWAK

diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat b/tests/data/acpi/x86/q35/DSDT.acpihmat
index 2a4f2fc1d5c5649673353186e67ff5b5e59e8d53..f1b8483d8da21dd57f3e5e7a1e4eb787df2c38ac 100644
GIT binary patch
delta 39
vcmZ4LGsB0=CD<iILXClev2i1pq$HP%M|`kTd~}mH=VV>UnVT<52Jrv@*4zt4

delta 53
zcmbQ?v($&nCD<iIRgHmxv1%iiq$HQ4XMC_zd~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4Xmc004Yz4n+U}

diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x b/tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x
index 7911c058bba5005d318b8db8d6da5c1ee381b0f1..a7731403f460a235bf705770a1547dafeee069ab 100644
GIT binary patch
delta 39
vcmaErbT^61CD<h-){udL(R3r1q$HP<Uwp7rd~}mH=VV>UnVT<5P8SCN^mq(Y

delta 53
zcmcbc^eTzVCD<h-%aDPAQGO$rq$HQWUwp7rd~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4a7!2LPlJ4^sdD

diff --git a/tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator b/tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator
index 580b4a456a20fc0cc0a832eaf74193b46d8ae8b1..cb4995de7e33cd9f2d134ec96651d217873d6944 100644
GIT binary patch
delta 39
ucmeBoX>#Fm33dr#Qet3WwBE=iDaqv%93SiyAKm25Iayb7=H|<iHXH!OR0^U1

delta 53
zcmZp2>389B33dtLS7KmbG}*`{Daqv-5+CdoAKm1^HCb13Ca(xjyr-WhM*)L#u&dAJ
IW0E!;0Apnhq5uE@

diff --git a/tests/data/acpi/x86/q35/DSDT.applesmc b/tests/data/acpi/x86/q35/DSDT.applesmc
index 5e8220e38d6f88b103f6eb3eb7c78dfa466882dc..92c8fdb6cbb8ae8bdf5ede9679eea92486eaf372 100644
GIT binary patch
delta 39
vcmZ4HG}DR8CD<iIQjvjyamz+7Nl7kOr}$u}_~<5Y&dIuxGdEwB3}y!a*l-J3

delta 53
zcmbQ~w9JXiCD<iIO_70taqUJfNl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACnAb2LOLh4p{&I

diff --git a/tests/data/acpi/x86/q35/DSDT.bridge b/tests/data/acpi/x86/q35/DSDT.bridge
index ee039453af1071e00a81ee7b37cf8f417f524257..957b3ad90c787616eac212865bce0a19a5ac1e6e 100644
GIT binary patch
delta 39
vcmbOl*Ad6%66_Mfq0hj;_+TTKq$HQCQ+%*fd~}mH=VV>UnVT<5I*9@R-%JaY

delta 53
zcmeB(n;OUE66_Kps?Wf{cyl9{q$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4ZX-0sx7f4wV1^

diff --git a/tests/data/acpi/x86/q35/DSDT.core-count b/tests/data/acpi/x86/q35/DSDT.core-count
index 7ebfceeb66460d0ad98471924ce224b7153e87ef..50ca91b065d9a2ba95f97d01856865f0e7c615f6 100644
GIT binary patch
delta 40
wcmX?>x-*r_CD<iorx61KqwPj6NlEVJc*gi(r}*e5Z_dejk~247k^Ce900Y(yC;$Ke

delta 54
zcmdm)dMuU8CD<k8m=Oa5quE9-NlEU81jhJar}*e553b32k~4Wlc;Y?%JUI#&oP%9`
KHXoP#Bmn@rP7o*n

diff --git a/tests/data/acpi/x86/q35/DSDT.core-count2 b/tests/data/acpi/x86/q35/DSDT.core-count2
index d0394558a1faa0b4ba43abab66d474d96b477ff3..f460be2bf74ae512db8f24418b42e8cf2a56202d 100644
GIT binary patch
delta 42
ycmdnr!L+G^iOVI}CB&$Ofq}7aBbTHkcTX8xe6Uk|bdxvdWIf55o3BV_X8`~d01a>e

delta 56
zcmdng!L+}FiOVI}CB(jkfq}7oBbTHkcV{_Ue6Uk|bdv|yWIf55ydpgDo_?Mj1q{x?
Mu0ETOOJ-*Q0MS7ZZ~y=R

diff --git a/tests/data/acpi/x86/q35/DSDT.cphp b/tests/data/acpi/x86/q35/DSDT.cphp
index a055c2e7d3c4f5a00a03be20fd73227e322283a4..7c87d41d03fcfd2b5b82f2581f16de6bc0bb10bf 100644
GIT binary patch
delta 39
vcmX@%y4#h@CD<iow-N&bqs2xpNl7l(`1oL__~<5Y&dIuxGdEwB{K^3U?XnDt

delta 53
zcmdn(dcu{<CD<k8gc1V-qv1v_Nl7lJg!o{m_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACvsb0RWs;4~hT)

diff --git a/tests/data/acpi/x86/q35/DSDT.cxl b/tests/data/acpi/x86/q35/DSDT.cxl
index 20843549f54af1cb0e6017c4cfff7463318d9eb7..da86b25f51b550ab20771111cb0a2bc49e713186 100644
GIT binary patch
delta 39
vcmZ3Vz9^l`CD<iokud`U<Ijy;l9F7mPVvD`@zG7*oRf7WXKubMc}Efe|Hln5

delta 53
zcmZ3KzCNAHCD<ioy)gp=<EM>Wl9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
JJ|=lb5&*aE5HJ7$

diff --git a/tests/data/acpi/x86/q35/DSDT.dimmpxm b/tests/data/acpi/x86/q35/DSDT.dimmpxm
index 664e926e90765550136242f7e3e0bdc7719c1853..a2d812e5a23a3ce7739789246b342e703f8c96c0 100644
GIT binary patch
delta 39
vcmaFo_t1~aCD<h-QJsN-@##h`T}dv#;P_yt_~<5Y&dH9FGdDk%Z07|41ThT|

delta 53
zcmaFp_s);YCD<h-Po05*@!m!*T}dwQkoaJy_~<4NuE~y)GkHaL;ywL5ISLq@gI#?#
J-;!+S1pvOk5D)+W

diff --git a/tests/data/acpi/x86/q35/DSDT.ipmibt b/tests/data/acpi/x86/q35/DSDT.ipmibt
index 4066a76d26aa380dfbecc58aa3f83ab5db2baadb..43ac1bd693d1b3f67d2a9e89ccaf8a56656df22d 100644
GIT binary patch
delta 39
vcmX@?w9SdjCD<jzOp$?s@yA9kNl7kOr}$u}_~<5Y&dIuxGdEwBEMNx!>rf04

delta 53
zcmdnybl8c@CD<jzS&@N(@#97=Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACoL#2LPI>4-o(W

diff --git a/tests/data/acpi/x86/q35/DSDT.ipmismbus b/tests/data/acpi/x86/q35/DSDT.ipmismbus
index 6d0b6b95c2a9fd01befc37b26650781ee1562e2a..1b998820d46e522b3129e42a867ed691c1f83e8f 100644
GIT binary patch
delta 39
vcmccMbl8c@CD<jzS&@N(F>@oAq$HQCQ+%*fd~}mH=VV>UnVT<5*0KWt;?)bb

delta 53
zcmX@?bis+sCD<h-K#_rgF=->0q$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4e_D0|1PE4z>UQ

diff --git a/tests/data/acpi/x86/q35/DSDT.ivrs b/tests/data/acpi/x86/q35/DSDT.ivrs
index 072a3fe2cd17dfe06658dfd82588f69787810114..026bfdfebf66c1803f158ac8c115eb5f49b5cb19 100644
GIT binary patch
delta 39
vcmeBl`s2vu66_N4M}dKXF?A!Cq$HQCQ+%*fd~}mH=VV>UnVT<5ny~`_^t=od

delta 53
zcmez4*y+UO66_MfsmQ><7`u^6Qj*KbIX>7aKDx<+YqGB7OkNS5cuzl1jsgbfU{{~b
I$0W_z0eo!^6aWAK

diff --git a/tests/data/acpi/x86/q35/DSDT.memhp b/tests/data/acpi/x86/q35/DSDT.memhp
index 4f2f9bcfceff076490cc49b8286380295a340004..7346125d23fb3174c0ce678a2cdf2fdc77c4a9fa 100644
GIT binary patch
delta 39
vcmX@^v&)CeCD<jzN{xYmamGe2Nl7kmr}$u}_~<5Y&dIuxGdEwBEa3qF=Zp*G

delta 53
zcmdnxbKHl^CD<jzU5$Z(apFcUNl7jb=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACoNM0RWT#4&?v<

diff --git a/tests/data/acpi/x86/q35/DSDT.mmio64 b/tests/data/acpi/x86/q35/DSDT.mmio64
index 0fb6aab16f1bd79f3c0790cc9f644f7e52ac37b1..15a291dbfb62e6ceb0249e02eb25b319744e351f 100644
GIT binary patch
delta 39
vcmaFlb=8Z@CD<h-RF#2&F>)i9q$HQOQ+%*fd~}mH=VV>UnVT<5_HzRO>=z6S

delta 53
zcmccW^~j6MCD<h-NtJ<tF=!)~q$HPzb9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4g4(0|1#o4-5bR

diff --git a/tests/data/acpi/x86/q35/DSDT.multi-bridge b/tests/data/acpi/x86/q35/DSDT.multi-bridge
index f6afa6d96d2525d512cc46f17439f7a49962b730..889a9040d950dd08980408d57f1037a5fc20c961 100644
GIT binary patch
delta 39
vcmaEx{ve&pCD<k8fiVLE<E@Qcl9F7mPVvD`@zG7*oRf7WXKubMDJ2B}6!;Aa

delta 53
zcmaEm{x+S<CD<k8tuX@w<K>N9l9F6b&hf!c@zG5lT$6PrXYz{h#C!UAauhH)2fO-g
JJ|-z81pw8G5DEYQ

diff --git a/tests/data/acpi/x86/q35/DSDT.noacpihp b/tests/data/acpi/x86/q35/DSDT.noacpihp
index 9f7261d1b06bbf5d8a3e5a7a46b247a2a21eb544..780616774f97a2d7305faf9e9a9d12afeb0e2fa2 100644
GIT binary patch
delta 39
vcmaFo@X&$FCD<h-QGtPhars8BUE*A>PVvD`@zG7*oRiOq&)i%h@rxY*2F?wn

delta 53
zcmaFp@XmqDCD<h-Pl17faluBeUE*9$&hf!c@zG5lT$9g<&*T;1iTCvL<S1Zp4tDj~
JoG$T;9RSJJ5TpPA

diff --git a/tests/data/acpi/x86/q35/DSDT.nohpet b/tests/data/acpi/x86/q35/DSDT.nohpet
index 99ad629c9171ff6ab346d6b4c519e77ca23e5b1c..0f862ab2938e0e11aa8335630fad389095b37edd 100644
GIT binary patch
delta 39
vcmaFmaMyv$CD<h-R)K+mv2P<+w*;4~Q+%*fd~}mH=j8bkGdH_Rs<HzB`rQm5

delta 53
zcmccX@XCS9CD<h-OM!ubv3(;~w*;4yb9}H<d~}ls*W~#UGkHaL;ywL5ISLq@gI#?#
JTS%(10|2(>4<G;l

diff --git a/tests/data/acpi/x86/q35/DSDT.numamem b/tests/data/acpi/x86/q35/DSDT.numamem
index fd1d8a79d3d9b071c8796e5e99b76698a9a8d29c..df8edc05b69ecd1331973b16e534b44616b50f58 100644
GIT binary patch
delta 39
vcmez8_|cKeCD<k8qXGj1W8g+ENl7kmr}$u}_~<5Y&dIuxGdEwB)Mf_&0sjnH

delta 53
zcmez9_|K8cCD<k8p8^8|qt`|*Nl7jb=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACuH(2LQPL4_N>J

diff --git a/tests/data/acpi/x86/q35/DSDT.pvpanic-isa b/tests/data/acpi/x86/q35/DSDT.pvpanic-isa
index 89032fa0290f496be0c06c6382586541aa1118a8..da3ce12787c28e555b6ba5eacb26275bdd4587f1 100644
GIT binary patch
delta 39
vcmccXbis+sCD<h-K#_rgv3w(!q$HQCQ+%*fd~}mH=VV>UnVT<5cCiBh>8}g;

delta 53
zcmccMbk~W?CD<h-R*`{$v0x*Yq$HP<b9}H<d~}ls*JNGEnY<!A@t%I390d%{!LB}=
Jk4bj10|1sj4)_27

diff --git a/tests/data/acpi/x86/q35/DSDT.thread-count b/tests/data/acpi/x86/q35/DSDT.thread-count
index 7ebfceeb66460d0ad98471924ce224b7153e87ef..50ca91b065d9a2ba95f97d01856865f0e7c615f6 100644
GIT binary patch
delta 40
wcmX?>x-*r_CD<iorx61KqwPj6NlEVJc*gi(r}*e5Z_dejk~247k^Ce900Y(yC;$Ke

delta 54
zcmdm)dMuU8CD<k8m=Oa5quE9-NlEU81jhJar}*e553b32k~4Wlc;Y?%JUI#&oP%9`
KHXoP#Bmn@rP7o*n

diff --git a/tests/data/acpi/x86/q35/DSDT.thread-count2 b/tests/data/acpi/x86/q35/DSDT.thread-count2
index d0394558a1faa0b4ba43abab66d474d96b477ff3..f460be2bf74ae512db8f24418b42e8cf2a56202d 100644
GIT binary patch
delta 42
ycmdnr!L+G^iOVI}CB&$Ofq}7aBbTHkcTX8xe6Uk|bdxvdWIf55o3BV_X8`~d01a>e

delta 56
zcmdng!L+}FiOVI}CB(jkfq}7oBbTHkcV{_Ue6Uk|bdv|yWIf55ydpgDo_?Mj1q{x?
Mu0ETOOJ-*Q0MS7ZZ~y=R

diff --git a/tests/data/acpi/x86/q35/DSDT.tis.tpm12 b/tests/data/acpi/x86/q35/DSDT.tis.tpm12
index f2ed40ca70cb13e733e39f4bad756be8688e01fe..67ebd7c158759221b801ecb67d8562d92fa219d5 100644
GIT binary patch
delta 39
vcmccScG8W@CD<jzQ<;H*@#{t|Nl7kOr}$u}_~<5Y&dIuxGdEwBY~}<2^lc1g

delta 53
zcmX@<cFm2;CD<h-Oqqd!@!du)Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACqk61OTT-4`u)W

diff --git a/tests/data/acpi/x86/q35/DSDT.tis.tpm2 b/tests/data/acpi/x86/q35/DSDT.tis.tpm2
index 5c975d2162d0bfee5a3a089e79b5ba038f82b7ef..c6b58472157d575e2625557d1346586be06b927c 100644
GIT binary patch
delta 39
vcmez1_SlWfCD<h-S($->as5UvNl7kOr}$u}_~<5Y&dIuxGdEwBoXZIS_>T;T

delta 53
zcmaFt_Q8$ICD<jTK$(Goam7Y1Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACsKR2>`3u4~PH&

diff --git a/tests/data/acpi/x86/q35/DSDT.type4-count b/tests/data/acpi/x86/q35/DSDT.type4-count
index 3194a82b8b4f66aff1ecf7d2d60b4890181fc600..17a64adb2055ad3168754ca121bf29851d2ee496 100644
GIT binary patch
delta 42
ycmew~k@4w7MlP3Nmyo9(3=E7>8@VJUx%&??#RogZM>lzMPS%s0x%rBuoIU_FstxM^

delta 56
zcmaDlk@3?+MlP3Nmyk~$3=E9H8@VJUxqA*V#RogZM>lzJP1ci~$t%JW@9F2sQNZ9F
M?CP`mxTKsu001Nq>i_@%

diff --git a/tests/data/acpi/x86/q35/DSDT.viot b/tests/data/acpi/x86/q35/DSDT.viot
index 129d43e1e561be3fd7cd71406829ab81d0a8aba0..6eb30e8f4b2c54e4789c649475adff356c8c58a4 100644
GIT binary patch
delta 39
vcmaD^bf<{RCD<h-#*%@7ar#CsNl7kOr}$u}_~<5Y&dIuxGdEwBoF)$d0-g-m

delta 53
zcmcap^s<P{CD<h-(~^OKal%F}Nl7jz=lEc!_~<4NuF1NRGkHaL;ywL5ISLq@gI#?#
JACsIW4*<Dl57+<z

diff --git a/tests/data/acpi/x86/q35/DSDT.xapic b/tests/data/acpi/x86/q35/DSDT.xapic
index b37ab591110d1c8201575ad6bba83449d7b90b21..111bb041dc0d114351add07c040dde61643d157a 100644
GIT binary patch
delta 42
ycmcaTo$1_kCN7s?mymPa3=E828@VJUxjR0v#RogZM>lzMPS%s0x%rADdl3LU$qs)2

delta 56
zcmX>%o$2;;CN7s?myp}t3=E9T8@VJUxm!Q7#RogZM>lzJP1ci~$t%JW@9F2sQNZ9F
M?CP`mxFmZK01fjIe*gdg

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index eed8ded69335..dfb8523c8bf4 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1,43 +1 @@
 /* List of comma-separated changed AML files to ignore */
-"tests/data/acpi/x86/pc/DSDT",
-"tests/data/acpi/x86/pc/DSDT.bridge",
-"tests/data/acpi/x86/pc/DSDT.ipmikcs",
-"tests/data/acpi/x86/pc/DSDT.cphp",
-"tests/data/acpi/x86/pc/DSDT.numamem",
-"tests/data/acpi/x86/pc/DSDT.nohpet",
-"tests/data/acpi/x86/pc/DSDT.memhp",
-"tests/data/acpi/x86/pc/DSDT.dimmpxm",
-"tests/data/acpi/x86/pc/DSDT.acpihmat",
-"tests/data/acpi/x86/pc/DSDT.acpierst",
-"tests/data/acpi/x86/pc/DSDT.roothp",
-"tests/data/acpi/x86/pc/DSDT.hpbridge",
-"tests/data/acpi/x86/pc/DSDT.hpbrroot",
-"tests/data/acpi/x86/q35/DSDT",
-"tests/data/acpi/x86/q35/DSDT.tis.tpm2",
-"tests/data/acpi/x86/q35/DSDT.tis.tpm12",
-"tests/data/acpi/x86/q35/DSDT.bridge",
-"tests/data/acpi/x86/q35/DSDT.noacpihp",
-"tests/data/acpi/x86/q35/DSDT.multi-bridge",
-"tests/data/acpi/x86/q35/DSDT.ipmibt",
-"tests/data/acpi/x86/q35/DSDT.cphp",
-"tests/data/acpi/x86/q35/DSDT.numamem",
-"tests/data/acpi/x86/q35/DSDT.nohpet",
-"tests/data/acpi/x86/q35/DSDT.acpihmat-noinitiator",
-"tests/data/acpi/x86/q35/DSDT.acpihmat-generic-x",
-"tests/data/acpi/x86/q35/DSDT.memhp",
-"tests/data/acpi/x86/q35/DSDT.dimmpxm",
-"tests/data/acpi/x86/q35/DSDT.acpihmat",
-"tests/data/acpi/x86/q35/DSDT.mmio64",
-"tests/data/acpi/x86/q35/DSDT.acpierst",
-"tests/data/acpi/x86/q35/DSDT.applesmc",
-"tests/data/acpi/x86/q35/DSDT.pvpanic-isa",
-"tests/data/acpi/x86/q35/DSDT.ivrs",
-"tests/data/acpi/x86/q35/DSDT.type4-count",
-"tests/data/acpi/x86/q35/DSDT.core-count",
-"tests/data/acpi/x86/q35/DSDT.core-count2",
-"tests/data/acpi/x86/q35/DSDT.thread-count",
-"tests/data/acpi/x86/q35/DSDT.thread-count2",
-"tests/data/acpi/x86/q35/DSDT.viot",
-"tests/data/acpi/x86/q35/DSDT.cxl",
-"tests/data/acpi/x86/q35/DSDT.ipmismbus",
-"tests/data/acpi/x86/q35/DSDT.xapic",
-- 
2.34.1


