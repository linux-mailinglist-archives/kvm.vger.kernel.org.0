Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A5C5F426C
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 13:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJDLzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 07:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJDLy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 07:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B54ABF55
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 04:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8FA1B81A19
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB368C433D6;
        Tue,  4 Oct 2022 11:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664884490;
        bh=BWDanIENnyRGAkn4VB++8Fo+Yq/hX0IwBm5yTrQjIpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRiXk1f3wRhfWRHga6j6ZZENoEgy4PksPH1SQz7Ror1DQTKU/pA5T6h2HX0HVQPop
         HvI5LnWoPjfyRw8+iovdARwwEGA1aG4QVLDazUrTLPgp4zUdmO8sEjnm4fGxSJvtTV
         h9svwlwqCPZeYyTtJQHccQWWyq5qNxHByziPKq9T2Th0FcJ87WAzmI7M+LotqXjiBh
         X7WVtLZefJBkRcARXVmNXWFvl1tUuA6x5ifRz2oyonDBIEBC6HYT2OtyLL2ycoEp1b
         /rEEFtlWn/zO+9n1MVLxcGsJg/R0Djyxi4DqcNdQgrjk8fg7YDyV/gwQn350tLkHnn
         4zipOsEFyNdSQ==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool v2] virtio-net: Fix vq->use_event_idx flag check
Date:   Tue,  4 Oct 2022 12:54:44 +0100
Message-Id: <166488433740.49462.190343118109565462.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220929121858.156-1-dinhngoc.tu@irit.fr>
References: <20220929122136.38f74d7f@donnerap.cambridge.arm.com> <20220929121858.156-1-dinhngoc.tu@irit.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Sep 2022 14:18:58 +0200, Tu Dinh Ngoc wrote:
> VIRTIO_RING_F_EVENT_IDX is a bit position value, but
> virtio_init_device_vq populates vq->use_event_idx by ANDing this value
> directly to vdev->features.
> 
> Fix the check for this flag in virtio_init_device_vq.
> 
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio-net: Fix vq->use_event_idx flag check
      https://git.kernel.org/will/kvmtool/c/717a3ab0a195

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
