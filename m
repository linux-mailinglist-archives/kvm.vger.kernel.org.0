Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA0794053
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbjIFP0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjIFP0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 11:26:21 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42AA9E5C;
        Wed,  6 Sep 2023 08:26:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 897528050;
        Wed,  6 Sep 2023 15:26:17 +0000 (UTC)
Date:   Wed, 6 Sep 2023 18:26:16 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <20230906152616.GE11676@atomide.com>
References: <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
 <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Marc Haber <mh+linux-kernel@zugschlus.de> [230906 14:41]:
> With my tools I have found out that it really seems to be related to the
> CPU of the host. I have changed my VM definition to "copy host CPU
> configuration to VM" in libvirt and have moved this very VM (image and
> settings) to hosts with a "Ryzen 5 Pro 4650G" and to an "Intel Xeon
> E3-1246" where they work flawlessly, while on both APUs I have available
> ("AMD G-T40E" and "AMD GX-412TC SOC") the regression in 6.5 shows. And
> if I boot other VMs on the APUs with 6.5 the issue comes up. It is a
> clear regression since going back to 4.6's serial code solves the issue
> on the APUs.

Not sure why the CPU matters here..

One thing to check is if you have these in your .config:

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y

Or do you maybe have CONFIG_SERIAL_CORE=m as loadable module?

If you have CONFIG_SERIAL_CORE=m, maybe you need to modprobe serial_base
if you have some minimal rootfs that does not automatically do it for you.

Regards,

Tony
