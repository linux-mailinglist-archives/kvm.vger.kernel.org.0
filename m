Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F5350B542
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446694AbiDVKic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446693AbiDVKiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:38:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FD5015730
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 03:35:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1703F1576;
        Fri, 22 Apr 2022 03:35:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 178A63F766;
        Fri, 22 Apr 2022 03:35:26 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:35:26 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 3/5] virtio: Check for overflows in QUEUE_NOTIFY
 and QUEUE_SEL
Message-ID: <YmKE7hVNZ1bxu3E4@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-4-martin.b.radev@gmail.com>
 <YjIEa+t4zJYMJmvB@monolith.localdoman>
 <YkDM2UsS8rRhf3jd@sisu-ThinkPad-E14-Gen-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkDM2UsS8rRhf3jd@sisu-ThinkPad-E14-Gen-2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sun, Mar 27, 2022 at 11:45:13PM +0300, Martin Radev wrote:
> 
> Thanks for the review.
> Comments are inline.
> Here is the patch:

Would you mind making a new version of the series to send this patch?

Thanks,
Alex
