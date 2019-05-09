Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C485E189CC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEIMbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 08:31:55 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:40102 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEIMbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 08:31:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE3BBA78;
        Thu,  9 May 2019 05:31:54 -0700 (PDT)
Received: from [10.1.196.69] (e112269-lin.cambridge.arm.com [10.1.196.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7464E3F7BD;
        Thu,  9 May 2019 05:31:53 -0700 (PDT)
Subject: Re: [PATCH v6 1/3] arm64: KVM: Propagate full Spectre v2 workaround
 state to KVM guests
To:     Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Auger <eric.auger@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>
References: <20190503142750.252793-1-andre.przywara@arm.com>
 <20190503142750.252793-2-andre.przywara@arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <af5cc288-57f9-d103-13b1-37d1a0794c5f@arm.com>
Date:   Thu, 9 May 2019 13:31:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503142750.252793-2-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 15:27, Andre Przywara wrote:
> Recent commits added the explicit notion of "workaround not required" to
> the state of the Spectre v2 (aka. BP_HARDENING) workaround, where we
> just had "needed" and "unknown" before.
> 
> Export this knowledge to the rest of the kernel and enhance the existing
> kvm_arm_harden_branch_predictor() to report this new state as well.
> Export this new state to guests when they use KVM's firmware interface
> emulation.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>
