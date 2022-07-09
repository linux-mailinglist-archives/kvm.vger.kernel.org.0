Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401B656C8E9
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 12:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiGIKSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 06:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGIKSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 06:18:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219AE3CBF9;
        Sat,  9 Jul 2022 03:18:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lg5gw4PS4z4xn3;
        Sat,  9 Jul 2022 20:18:04 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Frederic Barrat <fbarrat@linux.ibm.com>
In-Reply-To: <20220628080228.1508847-1-aik@ozlabs.ru>
References: <20220628080228.1508847-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Do not warn when userspace asked for too big TCE table
Message-Id: <165736167184.12236.12724791428724317908.b4-ty@ellerman.id.au>
Date:   Sat, 09 Jul 2022 20:14:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jun 2022 18:02:28 +1000, Alexey Kardashevskiy wrote:
> KVM manages emulated TCE tables for guest LIOBNs by a two level table
> which maps up to 128TiB with 16MB IOMMU pages (enabled in QEMU by default)
> and MAX_ORDER=11 (the kernel's default). Note that the last level of
> the table is allocated when actual TCE is updated.
> 
> However these tables are created via ioctl() on kvmfd and the userspace
> can trigger WARN_ON_ONCE_GFP(order >= MAX_ORDER, gfp) in mm/page_alloc.c
> and flood dmesg.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Do not warn when userspace asked for too big TCE table
      https://git.kernel.org/powerpc/c/4dee21e0f2520f5032b0abce0ecae593a71bd19d

cheers
