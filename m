Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1395A07A8
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 05:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiHYD3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 23:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiHYD2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 23:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C87F083;
        Wed, 24 Aug 2022 20:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C254D6177A;
        Thu, 25 Aug 2022 03:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9EFC433D6;
        Thu, 25 Aug 2022 03:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661398073;
        bh=hXcuoCMq+xYijaMzs0gjOOYFaKvB59qfkklmN0+PLrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLlIzrpr3fHwd6JmvtcBWzTn1hhz9LyeejohvcMwg6gQwqCHvRGSeqRdITayXRieL
         8ooFsBHWTZ94NAWxgzVV/ueGoxZZK6NfrWHHimuug3UZnTnPlK/wdvMgl8ekINyraK
         iMF69xa/rwPQf9Q+dIGDQmQsy59ofyNZ4v/ECQIkMno6+wzowfh62t40d3EvevxFQl
         4hobtxsvhnjFAEnnyr2QaqfHAWWFOa/TLrt5ITuagPVzeIx1y7LGeZPw+WHXtIqAz5
         K7YcVoX96gHbfOdd28pBMCm99Zipm+ayfNCb0tzCZgtUzajlbzmX0depDPM32rD9c+
         lzVWvd/IbMVFg==
Date:   Thu, 25 Aug 2022 06:27:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YwbsMqhnbsuoqwKv@kernel.org>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwbrywL9S+XlPzaX@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 06:26:06AM +0300, Jarkko Sakkinen wrote:
> Nit: shouldn't be this be x86/kvm?

Also, why don't you make one patch set with Dave's patch
included.

BR, Jarkko
