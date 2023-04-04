Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93406D6703
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbjDDPRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbjDDPRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:17:33 -0400
X-Greylist: delayed 609 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 08:17:27 PDT
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98B026A4
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:17:27 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 407924000B;
        Tue,  4 Apr 2023 18:07:15 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 1D35686;
        Tue,  4 Apr 2023 18:07:14 +0300 (MSK)
Message-ID: <cbb3df0a-7714-cbc0-efda-45f1d608e988@msgid.tls.msk.ru>
Date:   Tue, 4 Apr 2023 18:07:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 05/11] qemu-options: finesse the recommendations around
 -blockdev
To:     Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        armbru@redhat.com
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
 <20230403134920.2132362-6-alex.bennee@linaro.org>
 <ZCwsvaxRzx4bzbXo@redhat.com>
Content-Language: en-US
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <ZCwsvaxRzx4bzbXo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

04.04.2023 16:57, Kevin Wolf пишет:
> Let's not make the use of -drive look more advisable than it really is.
> If you're writing a management tool/script and you're still using -drive
> today, you're doing it wrong.

Kevin, maybe I'm wrong here, but what to do with the situation which
started it all, -- with -snapshot?

If anything, I think there should be a bold note that -snapshot is broken
by -blockdev.  Users are learning that the *hard* way, after losing their
data..

/mjt

