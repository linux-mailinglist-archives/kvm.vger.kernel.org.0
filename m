Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634A913931E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 15:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgAMOHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 09:07:36 -0500
Received: from foss.arm.com ([217.140.110.172]:40006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgAMOHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 09:07:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 612991045;
        Mon, 13 Jan 2020 06:07:35 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DA933F68E;
        Mon, 13 Jan 2020 06:07:34 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] arm: expand the timer tests
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200110160511.17821-1-alex.bennee@linaro.org>
 <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
Message-ID: <7be15e14-78c7-788f-7a9c-08e80bdb5600@arm.com>
Date:   Mon, 13 Jan 2020 14:07:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/20 1:48 PM, Alexandru Elisei wrote:
> [..]
>> +	isb();
>> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX (irqs on)");
> This check can be improved. You want to check the timer CTL.ISTATUS here, not the
> gic. A device (in this case, the timer) can assert the interrupt, but the gic does
> not sample it immediately. Come to think of it, the entire timer test is wrong
> because of this.

I'll write a patch for it in v4 of my fixes series.

Thanks,
Alex


