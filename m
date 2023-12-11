Return-Path: <kvm+bounces-4056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C6C80CF82
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F4D8281DAA
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 15:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FAE4B5A6;
	Mon, 11 Dec 2023 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LqtbuDcL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB0EDC;
	Mon, 11 Dec 2023 07:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702308482; x=1733844482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=bggHoXiU68cBQ7oYAKkT9kMUxOTajjceV/9v3ldJhH0=;
  b=LqtbuDcL5MwUCHzpQxD8papxZI0Pjjr5Ysk7sKRTGndDuqctKngp2fWw
   Hjp2qGiO75zcaYV3Ez0g6fN+eLEBcFLbwp5gsYqLqfquO6d3pR1X1OhtR
   fwdO1xC1p+bNhNIdIrTXW68g7vx6BPUJr73B0Fg/ofd5XwYXZB2IgqCVb
   IJr0J7WkaiZOL/BbOUjYa8f3Evq+fo6pgfl91RkccFT6HC6QJB86PKCdc
   YKj7/R11XjamsVYzG8Rg/tGuvmsU6Sr77ZtI3uFqYzxxDffN7BZv/1U4o
   58k2hmBGTFh04l47/ypCpGxdXHYLzM5l/iflwRUgrj+F0aj8IcbBilnIU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="461141946"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="461141946"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 07:28:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="891175897"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="891175897"
Received: from pasangle-nuc10i7fnh.iind.intel.com ([10.223.107.83])
  by fmsmga002.fm.intel.com with ESMTP; 11 Dec 2023 07:28:00 -0800
From: Parshuram Sangle <parshuram.sangle@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org,
	jaishankar.rajendran@intel.com,
	parshuram.sangle@intel.com
Subject: Re: [PATCH 0/2] KVM: enable halt poll shrink parameter
Date: Mon, 11 Dec 2023 20:58:42 +0530
Message-Id: <20231211152842.22777-1-parshuram.sangle@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102154628.2120-1-parshuram.sangle@intel.com>
References: <20231102154628.2120-1-parshuram.sangle@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Soft reminder for patch review

