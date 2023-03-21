Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641ED6C35F8
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjCUPle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCUPlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:41:32 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8966CDDB
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:41:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679413286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nu6AEzpkLDRpJUdYVJfCsu7tNGyF6kVZqp6PpNwWiyA=;
        b=UlsPM1/EpPR2eQKlMS3xuy3JKBsxEgoxKdEhY8lnmeshrB1cyHoOvq1CxscKvXoWpzwC3A
        MMGupx+j5N6ZdDjphn7Q8DKC+qTktN1kN15T2kwQ/iX9P4qcYYLul52S0909SXwjGc29wK
        2qCYzB54DYr/0/9jZ0yUTFXuLbxscxE=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Clean up the arm/run script
Date:   Tue, 21 Mar 2023 16:41:22 +0100
Message-Id: <167940943515.820115.8164556248057369265.b4-ty@linux.dev>
In-Reply-To: <20230303041052.176745-1-shahuang@redhat.com>
References: <20230303041052.176745-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Mar 2023 23:10:50 -0500, Shaoqin Huang wrote:
> Using more simple bash command to clean up the arm/run script.
> 
> Patch 1 replace the obsolete qemu script.
> 
> Patch 2 clean up the arm/run script to make the format consistent and simple.
> 
> Changelog:
> ----------
> v2:
>   - Add the oldest QEMU version for which -chardev ? work.
>   - use grep -q replace the grep > /dev/null.
>   - Add a new patch to clean up the arm/run.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
