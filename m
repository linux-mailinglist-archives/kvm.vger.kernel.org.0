Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41720FC7E1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNNji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:39:38 -0500
Received: from foss.arm.com ([217.140.110.172]:43458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfKNNjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 08:39:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A36031B;
        Thu, 14 Nov 2019 05:39:37 -0800 (PST)
Received: from [10.1.32.172] (e121487-lin.cambridge.arm.com [10.1.32.172])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EB573F52E;
        Thu, 14 Nov 2019 05:39:35 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
Date:   Thu, 14 Nov 2019 13:39:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/12/19 4:42 PM, Alexandru Elisei wrote:
> Are we not testing KVM? Why are we not treating a behaviour different than what
> KVM should emulate as a fail?

Can kvm-unit-tests be run with qemu TCG?

Cheers
Vladimir
