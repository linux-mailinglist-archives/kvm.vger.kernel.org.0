Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F154778C842
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 17:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbjH2PEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 11:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbjH2PEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 11:04:47 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F15B199;
        Tue, 29 Aug 2023 08:04:45 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qb0Gn-002a5D-30;
        Tue, 29 Aug 2023 17:04:41 +0200
Date:   Tue, 29 Aug 2023 17:04:41 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZO4GeazfcA09SfKw@google.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023 at 07:53:45AM -0700, Sean Christopherson wrote:
> What is different between the bad host(s) and the good host(s)?  E.g. kernel, QEMU,

The bad host is an APU ("AMD GX-412TC SOC") with 4 GB of RAM, one of the
good hosts is a "Xeon(R) CPU E3-1246 v3" with 32 GB of RAM. Both are
somewhat dated due to the darn iptables => nftables migration and still
run Debian buster, kernels are identical (a 6.4.12 built in the same
container than the 6.4.12 that works and the 6.5 that misbahaves on the
test VM), system configuration is from the same ansible playbook, but of
course there are differences. But my strongest bet is some weird CPU
type issue becuase that's the most blatant difference.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
