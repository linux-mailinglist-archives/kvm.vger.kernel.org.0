Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953486C66B2
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCWLel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCWLei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:34:38 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFFB11E85
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:34:28 -0700 (PDT)
Received: from [78.40.148.178] (helo=webmail.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pfJCs-006ci6-7c; Thu, 23 Mar 2023 11:34:10 +0000
MIME-Version: 1.0
Date:   Thu, 23 Mar 2023 11:34:09 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: Re: [PATCH 02/45] target/riscv: Refactor some of the generic vector
 functionality
In-Reply-To: <CAEg0e7j=yGrz6uSCZirthZB7FEF-BtB73e+D-UB_hXQTJEtmyw@mail.gmail.com>
References: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk>
 <20230310160346.1193597-3-lawrence.hunter@codethink.co.uk>
 <CAEg0e7j=yGrz6uSCZirthZB7FEF-BtB73e+D-UB_hXQTJEtmyw@mail.gmail.com>
Message-ID: <494bdf70499cc02f4e03135e4eee45f6@codethink.co.uk>
X-Sender: lawrence.hunter@codethink.co.uk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/2023 12:02, Christoph Müllner wrote:
> On Fri, Mar 10, 2023 at 5:06 PM Lawrence Hunter
> <lawrence.hunter@codethink.co.uk> wrote:
>> 
>> From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
>> 
>> Summary of refactoring:
>> 
>> * take some functions/macros out of `vector_helper` and put them in a
>> new module called `vector_internals`
>> 
>> * factor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
>> function `opivv_trans` (similar to `opivi_trans`)
> 
> I think splitting this commit into two changes would be better.
> Besides that the two changes look reasonable and correct.

Makes sense, we can do this

Best,
Lawrence
