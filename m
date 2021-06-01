Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8A6397214
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhFALJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 07:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhFALJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 07:09:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67779613AD;
        Tue,  1 Jun 2021 11:07:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo2FV-004nhn-AJ; Tue, 01 Jun 2021 12:07:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keqian Zhu <zhukeqian1@huawei.com>
Cc:     wanghaibin.wang@huawei.com
Subject: Re: [PATCH v5 0/2] kvm/arm64: Try stage2 block mapping for host device MMIO
Date:   Tue,  1 Jun 2021 12:07:48 +0100
Message-Id: <162254563973.3767290.8382994018229103623.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507110322.23348-1-zhukeqian1@huawei.com>
References: <20210507110322.23348-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, zhukeqian1@huawei.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 May 2021 19:03:20 +0800, Keqian Zhu wrote:
> This rebases to newest mainline kernel.
> 
> Thanks,
> Keqian
> 
> 
> We have two pathes to build stage2 mapping for MMIO regions.
> 
> [...]

Applied to next, thanks!

[1/2] kvm/arm64: Remove the creation time's mapping of MMIO regions
      commit: fd6f17bade2147b31198ad00b22d3acf5a398aec
[2/2] kvm/arm64: Try stage2 block mapping for host device MMIO
      commit: 2aa53d68cee6603931f73b28ef6b51ff3fde9397

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


