Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070305BDFE5
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiITIWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiITIWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:22:30 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D15C963
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:20:27 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:20:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663662025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z+D/+XqPkHPpeUPcy8FHBpV6Iy+MSnvu8mZYQhUXgXw=;
        b=hS3i/5/nKeFMwqqAkVMDwys7TeNml4OZeQ5IUT4tKLWPcQgSqaINr78QoqWAYLgjrtSIkx
        S8zUqjH1p05fi9agLYWv8FsdEc0eq/6DUev1Ih+vpR+Xiv9FHqDLOFbhusndXp+bK4BU42
        /VLv3OriAy/dEQDXBSZfpxy5YUM42ig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 02/19] lib/alloc_phys: Initialize
 align_min
Message-ID: <20220920082023.76ckpfqox4s76vw4@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-3-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:41AM +0100, Alexandru Elisei wrote:
> Commit 11c4715fbf87 ("alloc: implement free") changed align_min from a
> static variable to a field for the alloc_ops struct and carried over the
> initializer value of DEFAULT_MINIMUM_ALIGNMENT.
> 
> Commit 7e3e823b78c0 ("lib/alloc.h: remove align_min from struct
> alloc_ops") removed the align_min field and changed it back to a static
> variable, but missed initializing it.
> 
> Initialize align_min to DEFAULT_MINIMUM_ALIGNMENT, as it was intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 7 +++----
>  lib/alloc_phys.h | 2 --
>  2 files changed, 3 insertions(+), 6 deletions(-)

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
