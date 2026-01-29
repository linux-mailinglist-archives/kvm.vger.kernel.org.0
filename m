Return-Path: <kvm+bounces-69609-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IKDHczQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69609-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF3DB4A60
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21CA1301CCC2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F5035EDBD;
	Thu, 29 Jan 2026 21:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjVaCgTF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240635D5EE
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721945; cv=none; b=MgCWo5p5WSTkkryNuXJl56ubTlSFRzpjzDejejnOVkC4fBi8Xs4elW4aYVNG+kJxCBvRHh+z21huZqtOtlyIR/K+OCFDQPAB0wDjycQm+zxinIfbVXB3Gvj4ZHnLXDsp1KF4q9v/IX4FFDrEQGRyh4DDzP33g8yOUVukep+3vWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721945; c=relaxed/simple;
	bh=WQ9zgAmCTBZ4bwjQYNH8OonhSwck2yad34xCkVdAyYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NVugHnz9iOsWAymwBnKuKaZWkZcenvQfnk4lZsE1iPnKN0gDAzOKIoAgcU5eYX4IZWLaZXaYkJUnPgwxm57SUpJOcM8MljoazCfdiDHwF2Qp1ogsJEEl+0HipGokRJvs6IZOxVfU2M6EFRsxqHux3QsE6jPwkyLYWQD5x8/szBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjVaCgTF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso1281554a91.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721943; x=1770326743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1Z3QHTjPxpYvShlt2cO6c78554A0ZIR6ozbVe3TjI8=;
        b=XjVaCgTFQyi6ghx7LAtflhE0rRuGae3zRnMF+wJ64bOcpbaClnEJCHeeFPuNMx0bhj
         Chg5w3+Rx1+NgQiC/X3EpKjOM5AHlPxMXucXPInqNLq5W2iNCZO09+LE2qwLNDBEXIPE
         k6KPrSjv+Nicpr3qeTwLiE4/7n7Eq4kAhYE1RGrPbyQj1PFa5a168R4x8Ag9H2obFNnC
         MioljlYyKnMLyNKbtxL/nZduWIAaIE13aEIZ/x9ZtOBBqDhg6avJOIdW/06RH84x6bAT
         mspO0qAoOXdpPYicKB0pO4XSn/yd4pHPLC5KY91JNeLGhYPPPelvXvLyDFk+A+VUIMw2
         d43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721943; x=1770326743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1Z3QHTjPxpYvShlt2cO6c78554A0ZIR6ozbVe3TjI8=;
        b=ffb81p/wYtMFFbnjxbeMtFe8c9GvErVtxYpkqUiektLu/dttSynXUwbC+mgM5lZvbK
         26Azk3eFuhdHxVz6PBujpYOQ7PeoICzLIFnI4daffOKbtpYUNuM03fAXKnHW7OohDo0m
         ghzFtqmNIo22tKN7F5a3f4fq2SadPT4+LFGTRwBZgKfED6m4hZtyqCTeTk6sO3hhGDGZ
         kDQBpqc2+UMlWjS5pnaMQdA8XfBQCxb6U2Dwu9alGPjPCVc0cCCZabKVwDHSnhIzMcBV
         fZq9+6CECh4Ky3OYZpVfMl4Q3DHXL0jknZYEMPNemMO1fL9mj5W97fXDnZsiKBbQte1+
         894A==
X-Forwarded-Encrypted: i=1; AJvYcCXuRiSuCky2DDPctR8Xtzsu6MU2fD9I3PvvwoAlR+lWLATMA72dgjCTeoXpYtfoGgY42ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMpqRqQ7+ujjy5PkgbUY+9qRXQlJNqu9Ci7La2XqEOMkKz5Q6X
	7zEJKCuJDG86sVZiAXgGbp/BXqXjC8yGLwfYb5a/hXQMsinVSk790v2ELo7DfdogmfMXbHgOjz8
	+zdFbLvKqNJ0GTg==
X-Received: from pjblb16.prod.google.com ([2002:a17:90b:4a50:b0:352:b92b:ef8])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c5:b0:343:684c:f8a0 with SMTP id 98e67ed59e1d1-3543b3ae12dmr762757a91.23.1769721942669;
 Thu, 29 Jan 2026 13:25:42 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:50 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-4-dmatlack@google.com>
Subject: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel during
 Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69609-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1FF3DB4A60
X-Rspamd-Action: no action

Inherit bus numbers from the previous kernel during a Live Update when
one or more PCI devices are being preserved. This is necessary so that
preserved devices can DMA through the IOMMU during a Live Update
(changing bus numbers would break IOMMU translation).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/probe.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index af6356c5a156..ca6e5f79debb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1351,6 +1351,20 @@ static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
+static bool pci_assign_all_busses(void)
+{
+	/*
+	 * During a Live Update where devices are preserved by the previous
+	 * kernel, inherit all bus numbers assigned by the previous kernel. Bus
+	 * numbers must remain stable for preserved devices so that they can
+	 * perform DMA during the Live Update uninterrupted.
+	 */
+	if (pci_liveupdate_incoming_nr_devices())
+		return false;
+
+	return pcibios_assign_all_busses();
+}
+
 /*
  * pci_scan_bridge_extend() - Scan buses behind a bridge
  * @bus: Parent bus the bridge is on
@@ -1378,6 +1392,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	bool assign_all_busses = pci_assign_all_busses();
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
 	u32 buses, i, j = 0;
@@ -1424,7 +1439,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
-	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
+	if ((secondary || subordinate) && !assign_all_busses &&
 	    !is_cardbus && !broken) {
 		unsigned int cmax, buses;
 
@@ -1467,7 +1482,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken || is_cardbus)
+			if (assign_all_busses || broken || is_cardbus)
 
 				/*
 				 * Temporarily disable forwarding of the
@@ -1542,7 +1557,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 							max+i+1))
 					break;
 				while (parent->parent) {
-					if ((!pcibios_assign_all_busses()) &&
+					if (!assign_all_busses &&
 					    (parent->busn_res.end > max) &&
 					    (parent->busn_res.end <= max+i)) {
 						j = 1;
-- 
2.53.0.rc1.225.gd81095ad13-goog


