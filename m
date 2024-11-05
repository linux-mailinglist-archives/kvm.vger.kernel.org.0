Return-Path: <kvm+bounces-30672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 142D19BC5AA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C76022832E9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133261FCF4D;
	Tue,  5 Nov 2024 06:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7bw9pGT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CE31FDF96
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788747; cv=none; b=R//xVYhXQTVQlFuqqj0JZ/xAQKj1vW7MnVakjDsUuUKR3dcS0s9dgygSCkoHGN53DR0hrE44G6RCI2793PpH0iwlxjeq/uwp/iewQJ0+xHy93zqj2//r3igptXpUPIzUqdUbJ4tUPNCtg9Vt/a1Ql/KVI4vpBwS/AZLkW2z8NM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788747; c=relaxed/simple;
	bh=oaeUYxWxoTsbbEf4Af9Nw3NbJLsiof0AXokRyvVuUyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RmwrxFDvoyiW5OeHPQtgjCbPev2LvXOmaR3VxdCRcUKitMjwKefpsJ0W/Svx03MLE0bi6IVbC4tpx6K9kzp8Qj01OweVYN9TILQ+lfoi0tzTnlvjO9LUudgS/sKnm/LRVFxpUC7Cj3btfMiowTiEwDLXxZHQtl/nnWXbuMYQSnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7bw9pGT; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788746; x=1762324746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oaeUYxWxoTsbbEf4Af9Nw3NbJLsiof0AXokRyvVuUyo=;
  b=e7bw9pGTQdIwqwcc9v9FZDuUPIZ0GbWdBDx2lveytNuNQR1GVZfrHpB9
   zqps8ZM9pHTxZgFwY6Jcupf9/syGVd13Cqa6LmrMyFnS0OMMC47hsvKmo
   iulk3RlKC0D7unxuNwDr8XHv/gFqGjBLt6gv3jNpkC/UtAc4kcv11VclD
   hhcDuG/jhayOaJVAWUjiARsAYWU06SEQFLWlEkWTMMvqJ6pQRz7iWov4v
   pofpqndVlp5ubYk3NMTurpibPfbT5+fZ+BeJ6ebPBub5dG/gnxtUaNLBb
   NJIZYVDY6Z71mPDMFyqJVR4UPFHXuVlQX+a81Qed/PysYVazeiDbPeiwV
   g==;
X-CSE-ConnectionGUID: kglpdMlfQpiiSm3MNyA5HA==
X-CSE-MsgGUID: S6BiPMUiS02HQUd4905yEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689735"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689735"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:06 -0800
X-CSE-ConnectionGUID: EI5xNTcOT4uw11Kv11bggg==
X-CSE-MsgGUID: 2ryCymgaT3yCWbd2Jfig5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989510"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:01 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 38/60] i386/tdx: Disable SMM for TDX VMs
Date: Tue,  5 Nov 2024 01:23:46 -0500
Message-Id: <20241105062408.3533704-39-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 00faffa891e4..68d90a180db7 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -355,11 +355,20 @@ static Notifier tdx_machine_done_notify = {
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     kvm_mark_guest_state_protected();
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


