Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4A79D145
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 14:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjILMnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjILMne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 08:43:34 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA9CC4
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 05:43:30 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 29BDC211F6;
        Tue, 12 Sep 2023 15:43:32 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 1683127850;
        Tue, 12 Sep 2023 15:43:28 +0300 (MSK)
Message-ID: <d24bde51-1cbc-c3b3-82c8-894931bf6fc3@tls.msk.ru>
Date:   Tue, 12 Sep 2023 15:43:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 3/4] hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
References: <20230912113027.63941-1-philmd@linaro.org>
 <20230912113027.63941-4-philmd@linaro.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <20230912113027.63941-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

12.09.2023 14:30, Philippe Mathieu-Daudé wrote:
> Inline and guard the single call to kvm_openpic_connect_vcpu()
> allows to remove kvm-stub.c. While it seems some code churn,
> it allows forbidding user emulation to include "kvm_ppc.h" in
> the next commit.

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>

FWIW, if you reorder this and previous patches, you'll have one
less file to move in target/ppc/meson.build. Not that it matters though.

/mjt
