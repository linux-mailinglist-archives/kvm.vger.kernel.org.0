Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87DC535184
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiEZPfL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 26 May 2022 11:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiEZPfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:35:11 -0400
X-Greylist: delayed 664 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 May 2022 08:35:09 PDT
Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [45.33.216.244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26095C1EE4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:35:09 -0700 (PDT)
Received: from smtpclient.apple (macbook3.redfish-solutions.com [192.168.1.18])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.16.1/8.16.1) with ESMTPSA id 24QFO4P9338660
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:24:04 -0600
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: RTC (real-time clock) emulation through host shim
Message-Id: <133845FE-B39E-42D0-A9BE-543467F0B51E@redfish-solutions.com>
Date:   Thu, 26 May 2022 09:24:04 -0600
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Scanned-By: MIMEDefang 2.86 on 192.168.4.3
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_20,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I was wondering if it would be feasible to provide a /dev/rtc0 driver for KVM guests to sync to their host's system clock?

I recently ran into an issue where my laptop went to sleep, and when the guest and host came back out of sleep, their respective clocks had skewed and "make" was generating unexpected results.

It would be trivial to add a user-space hook on the G1 to G0 ACPI transition, and run "hwclock --hctosys" for instance for guest-side support, same as for booting.

The host- and guest- side driver support don't seem particularly complicated, either.

Is this feasible?

Thanks,

-Philip
