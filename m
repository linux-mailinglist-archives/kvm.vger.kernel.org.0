Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86D4CE701
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiCEUfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiCEUfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:35:52 -0500
Received: from relay.hostedemail.com (relay.hostedemail.com [64.99.140.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913A0340C5
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 12:35:01 -0800 (PST)
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id E6BA880A7B;
        Sat,  5 Mar 2022 20:34:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id A23B230;
        Sat,  5 Mar 2022 20:34:31 +0000 (UTC)
Message-ID: <1d6d9aada7bba49b10e0abb0b1bc75bc43643d24.camel@perches.com>
Subject: Re: [PATCH 1/6] KVM: fix checkpatch warnings
From:   Joe Perches <joe@perches.com>
To:     Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 12:34:53 -0800
In-Reply-To: <20220305202637.457103-1-henryksloan@gmail.com>
References: <20220305202637.457103-1-henryksloan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: A23B230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Stat-Signature: wtczwzztypaotbsbzdgwj1w7enczizbz
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+TwPOg+NXUX5LrYuhvtQyRtTR+HEHEWqw=
X-HE-Tag: 1646512471-923606
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-03-05 at 15:26 -0500, Henry Sloan wrote:
> Fix "SPDX comment style" warnings

Hi.

You've given all these patches the same email subject line.

That would mean the commit subject line would also be the same
for each of these 6 patches.

That's bad.

More proper would be to use the first line of each commit
message as part of the subject line

i.e.: This subject line would become:

Subject: [PATCH 1/6] KVM: Fix "SPDX comment style" warnings

or perhaps better:

Subject: [PATCH 1/6] KVM: Use typical SPDX comment style

etc...

> 
> This patchset fixes many checkpatch warnings in the virt/kvm directory.

And this bit doesn't belong in the first patch of 6, but in a 0/6
patch cover letter.

cheers, Joe

