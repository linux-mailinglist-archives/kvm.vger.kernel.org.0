Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5937479445F
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbjIFUTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjIFUTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:19:09 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE7919A3;
        Wed,  6 Sep 2023 13:19:02 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qdyzG-006ZTz-1m;
        Wed, 06 Sep 2023 22:18:54 +0200
Date:   Wed, 6 Sep 2023 22:18:54 +0200
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
Message-ID: <ZPjernao1DVQouhb@torres.zugschlus.de>
References: <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
 <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
 <20230906152616.GE11676@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230906152616.GE11676@atomide.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 06:26:16PM +0300, Tony Lindgren wrote:
> * Marc Haber <mh+linux-kernel@zugschlus.de> [230906 14:41]:
> > With my tools I have found out that it really seems to be related to the
> > CPU of the host. I have changed my VM definition to "copy host CPU
> > configuration to VM" in libvirt and have moved this very VM (image and
> > settings) to hosts with a "Ryzen 5 Pro 4650G" and to an "Intel Xeon
> > E3-1246" where they work flawlessly, while on both APUs I have available
> > ("AMD G-T40E" and "AMD GX-412TC SOC") the regression in 6.5 shows. And
> > if I boot other VMs on the APUs with 6.5 the issue comes up. It is a
> > clear regression since going back to 4.6's serial code solves the issue
> > on the APUs.
> 
> Not sure why the CPU matters here..

Neither am I.

> One thing to check is if you have these in your .config:
> 
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y

That's affirmative. Otherwise, I think that serial console wouldn't work
at all, but I get early kernel messages just fine and even at normal
speed.

> Or do you maybe have CONFIG_SERIAL_CORE=m as loadable module?

Negative.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
