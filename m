Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8285E3B33F5
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhFXQcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 12:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXQcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 12:32:54 -0400
X-Greylist: delayed 121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Jun 2021 09:30:34 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEF1C061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 09:30:33 -0700 (PDT)
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 25508340
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 16:28:26 +0000 (UTC)
Date:   Thu, 24 Jun 2021 21:28:25 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     kvm@vger.kernel.org
Subject: [BUG] vhost-net: Enabling experimental_zcopytx always crashes the
 host on 5.10, worked fine on 5.4
Message-ID: <20210624212825.32aaa6f9@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I am upgrading my VM host from 5.4.126 to 5.10.46.
The host started crashing almost instantly after boot.

The issue is traced down to:

If the vhost-net module is loaded with "experimental_zcopytx=1", as soon as a
Windows KVM guest boots up and starts doing even a light network load
(watching YouTube), the entire host crashes with a backtrace pointing to
skb_segment, parts of which I was able to capture.

This is reproducible 100% of the time, got 3 identical crashes before getting
a capture and then flipping the parameter to 0. With it set to 0 the issue
goes away.

Reported at [1], not sure if that was the best place for the report, thought
maybe posting here as well won't hurt.

Thanks

[1] https://bugzilla.kernel.org/show_bug.cgi?id=213563

-- 
With respect,
Roman
