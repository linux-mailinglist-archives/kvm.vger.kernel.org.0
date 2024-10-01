Return-Path: <kvm+bounces-27773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DD498BF9C
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DB68B274F1
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 14:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3211CC167;
	Tue,  1 Oct 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="BbaPD+ZW"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC35E1C6F5F;
	Tue,  1 Oct 2024 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792053; cv=none; b=ZZ/DdrT54pVhePOCPNMIHGyKj7XdTuImWQaOoGotjw483P4hzpyhOweOKrZftwJbf+Mpco7rcRRScgJDbS9R4k2d6ccFZCntjjbujn3h5CTtIFO40o9PxLOa5u8WJDX1POI0cfpjkvUb2YLwTCXu1n8PVS6z8f7wv3sxt8mz4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792053; c=relaxed/simple;
	bh=lageWQwmrsNic56F3KhBp/9f7cG0lPv1vxFhdZrPJzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qwy9x9v3AnxpkQLecwT8CfCz5BrKVIlVhD3U2xU9jUuwhel4qaV2iwESIVeRSKlVmOXsCRQePfcgRilagj71cCzoNzd1sFzWdM4xdxrSxB7cnpN6KJ/F7jj0x5O1DqVEUbXYDgERn5vIs776DyRNcHNvOhohTZYUaAJtRp3O+D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=BbaPD+ZW; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=JupWoUCDD8mhBIgrHgHG0tNlBPvu5qHhZqoW4JXZ8Cw=; b=BbaPD+ZWEv48ld6J
	YkWPumqaAC9LsDQJXbKqJnsxFHFkhqBGo6i1iG/EhrIKV8y+nJe6kjXUyClhEcotnHFhWv6z8eQ4c
	HMb0y6vrqreslXbNbICOwpelwNn2JP578uOwhPYbkgOEqgaonYH+gsh4P8FEwen9Al0qdlgn8J5cT
	GWwCPsPLWh17shCH5NfPmAzUKHLqJ4+moPGi0gt/jtsV42FrdjpeJHmSupjq4MOwYF9sTorV57oP7
	THW+PzCk56/CwoLFIx19h+/2uYi2fsA0Wfv3HyUyWxe8wK/mrBgFBsRs+tC+lv1BOHs0Rs+/rrTSi
	ZpLwTH7lnjtYQOC+oQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1svddX-008FA4-25;
	Tue, 01 Oct 2024 14:13:59 +0000
From: linux@treblig.org
To: pbonzini@redhat.com
Cc: seanjc@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/2] A couple of KVM dead functions
Date: Tue,  1 Oct 2024 15:13:52 +0100
Message-ID: <20241001141354.18009-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  Just some deadcode removal; I split it
because the second one is mentioned in docs
that I don't know mean if it's still needed or
how to fix up.

Dave

Dr. David Alan Gilbert (2):
  KVM: Remove unused kvm_vcpu_gfn_to_pfn
  KVM: Remove unused kvm_vcpu_gfn_to_pfn_atomic

 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 12 ------------
 2 files changed, 14 deletions(-)

-- 
2.46.2


