Return-Path: <kvm+bounces-70979-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONDoIrPmjWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70979-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:41:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF1512E5BA
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 07471304DC75
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006FF363C78;
	Thu, 12 Feb 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TegPunog"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC23361DC1;
	Thu, 12 Feb 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906990; cv=none; b=coMSvCFr3ItFqA/uRDTpE6CLvLO5h4UgUBj0fCOz4rs8Np1YwPL0qYMEI01FCYsnyb+VAKx5SvMpdqMcu7UBLm4M6b7fbKzxw5YZZkC236zdRq95s131+K3AkWPAcNrgYHgBsobBejykOzxr9JZJMUWP6Nc5MklGmNt2/Wka26I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906990; c=relaxed/simple;
	bh=XNjGb74PLFtejz7tdMieajk5jWJt9QEap7aZlzkACPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt6xz9lFZhO6ZKj81J4wAxziSd89iPdhDiJxaMPHXI9V2/hmurDB0HM7v2JR2cgnilcIySNeshuL5WAnS3qi7YZeDgMsVXBEGLOA5GFB0XJxEsD3Pgvm9DMquyzti3LaB26eMcNym9bdExo55axjhcZSNNkI8K0msNmNtMGTKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TegPunog; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906988; x=1802442988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XNjGb74PLFtejz7tdMieajk5jWJt9QEap7aZlzkACPo=;
  b=TegPunogdl2VTVNBNvSD9rDQKjuFkkNXsSEuAnXDavrgadAjp60KWxz+
   sB1XMniWp2zE21KWUXet952szfPA8cEBNFkWY7T63tXNGjKzCUJAxHFZM
   ueiPuW9YKJzFMmDG+MOfsuMndzu7lk/CbwX7SqVzhql/rTBNjC4vZ6e0W
   QlBd0Gsh3cUFl44LURMI2fOvTsziCMAXGof0wegPfVDuUE8C/xikl4gwO
   CS5ZZj2kSmD+/27KbdjT1m+XtisQE+CcIe54ICY3Um6Ry/a09K2XnV7Po
   TPhFixm1ZV5E9huD985pvRPDzrnPFZdpNFVTrCnAmbgQyAaxWfEmRswXK
   w==;
X-CSE-ConnectionGUID: gF+W0p6FQg2wp7+As50PUQ==
X-CSE-MsgGUID: jrFjadWARmiaU7IwpdqKQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662877"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662877"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:26 -0800
X-CSE-ConnectionGUID: pNDgzLglTKSCj+N/Gx3MVQ==
X-CSE-MsgGUID: tTiPWpVASRGKAwxzy59kJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428282"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:26 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 17/24] x86/virt/seamldr: Do TDX per-CPU initialization after updates
Date: Thu, 12 Feb 2026 06:35:20 -0800
Message-ID: <20260212143606.534586-18-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70979-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: AEF1512E5BA
X-Rspamd-Action: no action

After installing the new TDX module, each CPU should be initialized
again to make the CPU ready to run any other SEAMCALLs. So, call
tdx_cpu_enable() on all CPUs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 4537311780b1..e29e6094c80b 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -200,6 +200,7 @@ enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
 	TDP_CPU_INSTALL,
+	TDP_CPU_INIT,
 	TDP_DONE,
 };
 
@@ -260,6 +261,9 @@ static int do_seamldr_install_module(void *seamldr_params)
 				args.rcx = __pa(seamldr_params);
 				ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
 				break;
+			case TDP_CPU_INIT:
+				ret = tdx_cpu_enable();
+				break;
 			default:
 				break;
 			}
-- 
2.47.3


