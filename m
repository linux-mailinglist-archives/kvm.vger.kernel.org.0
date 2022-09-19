Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C655BD010
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 17:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiISPLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 11:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiISPK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 11:10:59 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301B82F008
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 08:10:58 -0700 (PDT)
Date:   Mon, 19 Sep 2022 17:10:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663600255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S6VNrPMZk2oYZl8Kyyhs50ZrHrkKLgAs8UjT+ZS8d8s=;
        b=r7CqAmKaQxqObb0KeFKWfHvmgIYg5vGzswzAO9ld5OX2wK0XnaWd0TO2QY6FcJCa7ATWGc
        Z7PnB9VoTK/d5TkqySwgo16MeW0YEsan+KqaoeON2+kyvxMkn5unoB2emLPdNNKEk+dEdu
        81M01VhHFpfpFOsAUnYAT9qREdAz9x4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andrew.murray@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v4 07/12] arm: pmu: Basic event counter
 Tests
Message-ID: <20220919151049.jtujswjyv5k34log@kamzik>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-8-eric.auger@redhat.com>
 <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 10:30:01PM +0800, Zenghui Yu wrote:
> Hi Eric,
> 
> A few comments when looking through the PMU test code (2 years after
> the series was merged).

Yes, these patches were merged long ago. Now you need to send patches,
not comments.

Thanks,
drew
