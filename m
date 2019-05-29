Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C32E076
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 17:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfE2PCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 11:02:20 -0400
Received: from foss.arm.com ([217.140.101.70]:47604 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfE2PCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 11:02:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B26DB341;
        Wed, 29 May 2019 08:02:19 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E82B23F5AF;
        Wed, 29 May 2019 08:02:18 -0700 (PDT)
Date:   Wed, 29 May 2019 16:02:16 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 0/4] kvmtool: clang/GCC9 fixes
Message-ID: <20190529150216.GC11154@fuggles.cambridge.arm.com>
References: <20190503171544.260901-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503171544.260901-1-andre.przywara@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 03, 2019 at 06:15:40PM +0100, Andre Przywara wrote:
> When compiling kvmtool with clang (works only on aarch64/arm), it turned
> up some interesting warnings. One of those is also issued by GCC9.
> 
> This series fixes them. More details in each commit message.

Thanks, pushed out now.

Will
