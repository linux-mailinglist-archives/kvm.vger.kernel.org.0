Return-Path: <kvm+bounces-72207-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFSlF+P5oWlkyAQAu9opvQ
	(envelope-from <kvm+bounces-72207-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:09:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CE46B1BD3A6
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A3B23019115
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7775146AF14;
	Fri, 27 Feb 2026 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YG0tEJJT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A82D73BC;
	Fri, 27 Feb 2026 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222941; cv=none; b=Qzvebvq6hMxmKM/4JSbZeiICI4xPiTRsZDttk9t0/DHrp1a/G+0pK4JQrm2PX/Z0SUtYq7UkufhB0GEUtKIxMEWICFIp6Y0wWDhxaIN/7GAivpKhDbfgVZfuZa+oDpxJ4sdO5s9kjO3O6oOOPYFOfTxUcn/9AmknFWHuUZZfAJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222941; c=relaxed/simple;
	bh=+0xJWv0Lt6lH8XeECmzMB5rMfZrGfkXmNV493TaaUhs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b94Vyzbh2Jyi7bhx9gejjytztVmLY4giKVi3xctZriq/PjKsVbMFMhRv2wgjFSInzC2vfObryNsE+F0P8mBTCpyAainC9o+2z3AXUi0xtrTFBsgll03Fsb7JwdADdAnTu+pAX2ZFSuc8VYMsqVlFDW0kG2L+bWpMjHhocYjbd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YG0tEJJT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080CAC19421;
	Fri, 27 Feb 2026 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222941;
	bh=+0xJWv0Lt6lH8XeECmzMB5rMfZrGfkXmNV493TaaUhs=;
	h=Date:From:To:Cc:Subject:From;
	b=YG0tEJJTJfoLj6ARnOgB1bTSgSNKqd8i442WohX7dinOs7axJ3xEjwyfREcddRfF3
	 MZSI3F783bSmwApK0YGKE1/NKNdhkpFQLAyzjyKAqoJXV0TFSR2Law8HRKHrsNODN1
	 zbPNCJ1yzcjAf7NPH0anptpYdWJIXJ2O3V7xJm2hR2M7tC4F1UXQxZ3lqo5dtVFtrL
	 syewUm609N0x38TT4CCAcQcGvd7bFhkfSiyexqLs86QBUuH0Ro4j5wSpjlbUNOoItT
	 YEzsegr316MDzW5LuHEeVwX3p8mvHiFlVh9zwxXL6Q7iY/soq4PdRFYoxh1z6fSsZS
	 snsd6askwgy0w==
Date: Fri, 27 Feb 2026 14:08:59 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Alex Williamson <alex@shazbot.org>,
	Niklas Cassel <cassel@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Koichiro Den <den@valinux.co.jp>, Shawn Guo <shawnguo@kernel.org>,
	kvm@vger.kernel.org
Subject: [GIT PULL] PCI fixes for v7.0
Message-ID: <20260227200859.GA3913790@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72207-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[helgaas@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CE46B1BD3A6
X-Rspamd-Action: no action

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git tags/pci-v7.0-fixes-2

for you to fetch changes up to 39195990e4c093c9eecf88f29811c6de29265214:

  PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value (2026-02-27 10:24:25 -0600)

The last two commits fix issues that are quite old, but I think they're
worth including in v7.0.

----------------------------------------------------------------

- Update MAINTAINERS email address (Shawn Guo)

- Refresh cached Endpoint driver MSI Message Address to fix a v7.0
  regression when kernel changes the address after firmware has configured
  it (Niklas Cassel)

- Flush Endpoint MSI-X writes so they complete before the outbound ATU
  entry is unmapped (Niklas Cassel)

- Correct the PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value, which broke VMM use of
  PCI capabilities (Bjorn Helgaas)

----------------------------------------------------------------
Bjorn Helgaas (1):
      PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value

Niklas Cassel (2):
      PCI: dwc: ep: Refresh MSI Message Address cache on change
      PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry

Shawn Guo (1):
      MAINTAINERS: Update Shawn Guo's address for HiSilicon PCIe controller driver

 MAINTAINERS                                     |  2 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c | 25 ++++++++++++++++---------
 include/uapi/linux/pci_regs.h                   |  2 +-
 3 files changed, 18 insertions(+), 11 deletions(-)

