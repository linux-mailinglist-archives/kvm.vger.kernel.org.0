Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8C01AAC2B
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414867AbgDOPpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1414847AbgDOPoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:44:38 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE08120936;
        Wed, 15 Apr 2020 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586965478;
        bh=ORkZB2VzRythfb2s8C4ohM3kKF8ynTqiU9xG1epWqx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tr4rI1Vy93CWHk2VOKuyXctJShORcfZ/xb6wR3Q0Oj4WPaUFCE+37HIRmUo8tWQow
         fmZD6yvv7sJP0obOvUNkJD5RB04AWEeX6pebQrasRtw4lOTuCGW+ny9stL1krWIFgJ
         0vUajy9hHPLyeTUg6VUOVxsGcG15pSfxTIOEjiqI=
Date:   Wed, 15 Apr 2020 16:44:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: Re: [PATCH kvmtool 00/18] Various fixes
Message-ID: <20200415154433.GA18960@willie-the-truck>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 03:39:28PM +0100, Alexandru Elisei wrote:
> I've taken the fixes from my reassignable BARs and PCIE support series [1]
> and created this series because 1. they can be taken independently and 2.
> rebasing a 32 patch series was getting very tedious.
> 
> Changes from the original series:
> 
> * Gathered Reviewed-by tags. Only patch #14 "virtio: Don't ignore
>   initialization failures" doesn't have one.
> * The virtio net device now frees the allocated devices and the ops copy on
>   failure in patch #14.
> 
> [1] https://www.spinics.net/lists/kvm/msg211272.html

Thanks! Applied the lot, with Andre's Reviewed-by added to patch 14.

I'm not able to test device passthrough at the moment, but I assume you 
did? I once had ideas about sticking the virtio devices on a separate PCI
bus from the passthrough devices, so we'll need to revert the change to
the "bus range" property if we ever decide to do that.

Will
