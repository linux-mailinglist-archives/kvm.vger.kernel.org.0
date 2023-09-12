Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E1579C735
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjILGxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 02:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjILGxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 02:53:49 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFD1AF;
        Mon, 11 Sep 2023 23:53:45 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qfxHB-000H07-1W;
        Tue, 12 Sep 2023 08:53:33 +0200
Date:   Tue, 12 Sep 2023 08:53:33 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZQAK7e/yuNFiBb56@torres.zugschlus.de>
References: <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
 <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
 <20230906152107.GD11676@atomide.com>
 <ZPmignexOJvJ5J5W@torres.zugschlus.de>
 <20230907105150.GJ11676@atomide.com>
 <ZPzQvXUW+dbkLMZ2@torres.zugschlus.de>
 <20230911125340.GB5285@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911125340.GB5285@atomide.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 03:53:40PM +0300, Tony Lindgren wrote:
> * Marc Haber <mh+linux-kernel@zugschlus.de> [230909 20:08]:
> > On Thu, Sep 07, 2023 at 01:51:50PM +0300, Tony Lindgren wrote:
> > > Still a minimal reproducable test case is needed.. Or do you have the
> > > dmesg output of the failing boot?
> > 
> > I have both dmesg output of a failing boot (with my kernel) and of a
> > successful boot (with the Debian kernel). Attached.
> 
> Thanks I don't see anything strange there, serial ports are probed in
> both cases.

Yes, they do actually WORK in both cases, and even with the normal
speed, unless systemd begins doing its work, then the "bad" case keeps
running into obvious 30 second timeouts.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
