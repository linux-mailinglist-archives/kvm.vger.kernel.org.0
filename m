Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE8F79B7C0
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbjIKUtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240160AbjIKOiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 10:38:11 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C053CF0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 07:38:06 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id B924420D6B;
        Mon, 11 Sep 2023 17:38:06 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 7A7E3274BD;
        Mon, 11 Sep 2023 17:38:04 +0300 (MSK)
Message-ID: <57f37ccc-48f1-d217-8e19-9521c9d773d8@tls.msk.ru>
Date:   Mon, 11 Sep 2023 17:38:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v3] target/i386: Restrict system-specific features from
 user emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
References: <20230911142729.25548-1-philmd@linaro.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <20230911142729.25548-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>

Thank you for patience!

11.09.2023 17:27, Philippe Mathieu-Daudé:
> Since commits 3adce820cf ("target/i386: Remove unused KVM
> stubs") and ef1cf6890f ("target/i386: Allow elision of
> kvm_hv_vpindex_settable()"), when building on a x86 host
...
