Return-Path: <kvm+bounces-49542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5E7AD9874
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 295271BC111C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364E628ECF4;
	Fri, 13 Jun 2025 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="eW4z+0jg"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F635279DAA;
	Fri, 13 Jun 2025 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856061; cv=none; b=lcJ060EUBll5aBEjhoOBS/HmGIrEoNGlAI6p9x7tzQN9Veo2ZRmyLrImEJNN+C4o7uEPjYtmFtdPUcfUkdaOHV7W7miAUJl0E/ztAnWDaRYPHo4GxN0fjkt+jVtOACvr+i3vqpRHModLdEalViOjR45Nue71Fs025IYkYBlEdhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856061; c=relaxed/simple;
	bh=CPpIDu1gwatfaG+bCwxj9Cetp6SivtQTGyc0BgWTUjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVAN0ANek4qZMLZ+aqLy59Nrduj4Lied6oO1l56K3E3KfyBIfLAdfT1ulmdnr3lERqi0ANWMWlbQpuWlLAdTngOn/0KYPlOuERC8pVNeP2DWZspdgS+f804h2WBn+uoSogaBWvWBvYo9+S4mtVRMhwT1UvWQ5pa6TGDH3Sb0g60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=eW4z+0jg; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=wZmLnK/L9PuDwfXzMx9kemM4IOFh2cNv4GMz5bT1BCw=; b=eW4z+0jg7zK8hCL4
	CK+73DpDegfZzqaF2pguAYqEPcw1PBpvgKm2YDRnOcXBhPhNbFgwMhMAyBSLeDlWMTn5AYAm/0Pui
	o5I11W5p0Jm0XrY4pXyqHAwIEsR19kNS4uKZQWC8vAE4ljebFhmw2Mw6jGqVS7QJu9HK3NrFYNT7Y
	KlRPhR+gNKJc4q19P2F3Xg2hQy3NeuAGKdwOqD81v0qJngOswfqlNFZCNvURKgB7HUpcPhY0TdfaU
	JRxTr5w/4RYfTJCgrdLot0Wni7x7xUX1RWeE05Tqv2Qh5FJ6zizsaUxeeUV+JDbIPuXW3NtpPGNeL
	hqlrhun5iId5gqdYXA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uQDUh-009ZoB-2y;
	Fri, 13 Jun 2025 23:07:31 +0000
From: linux@treblig.org
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/2] vringh small unused functions
Date: Sat, 14 Jun 2025 00:07:29 +0100
Message-ID: <20250613230731.573512-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  The following pair of patches remove a bunch of small functions
that have been unused for a long time.

Dave

Dr. David Alan Gilbert (2):
  vhost: vringh: Remove unused iotlb functions
  vhost: vringh: Remove unused functions

 drivers/vhost/vringh.c | 104 -----------------------------------------
 include/linux/vringh.h |  12 -----
 2 files changed, 116 deletions(-)

-- 
2.49.0


