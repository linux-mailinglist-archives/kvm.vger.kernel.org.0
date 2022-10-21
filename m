Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF0607BAF
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiJUQC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 12:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiJUQC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 12:02:56 -0400
X-Greylist: delayed 466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Oct 2022 09:02:54 PDT
Received: from npcomp.net (unknown [209.195.0.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6072700FC
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:02:54 -0700 (PDT)
Received: by npcomp.net (Postfix, from userid 1000)
        id E2D7211004B; Fri, 21 Oct 2022 15:55:06 +0000 ()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eldondev.com;
        s=eldondev; t=1666367706;
        bh=bjTqeV8SmCjg58QefAYb6a6rvrdipcXPk8TTR8Y86LA=;
        h=Date:From:To:Cc:Subject;
        b=bIu0JXfdg3ZGpr5Fhzi+0aEXtImY4RGaAIwE5/kb7KlPWDk/C2fPtOaPqVgEu0zAQ
         0fJQ/QyytzBZnt2pg3jprAjjKss6nipTDLYy/KoEPvlGg0b0foCCjBD5IeCpVXDBjC
         qKqTTUaFJxSSHo6rJdAEPHE4xFozJZnpGTTpadBE=
Date:   Fri, 21 Oct 2022 15:55:06 +0000
From:   Eldon Stegall <eldon-qemu@eldondev.com>
To:     Eldon Stegall <eldon-qemu@eldondev.com>
Cc:     qemu-discuss@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, libvir-list@redhat.com
Subject: QEMU Advent Calendar 2022 Call for Images
Message-ID: <Y1LA2qoQEoQ+bNMG@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
We are working to make QEMU Advent Calendar 2022 happen this year, and
if you have had an interesting experience with QEMU recently, we would
love for you to contribute! QEMU invocations that showcase new functionality,
something cool, bring back retro computing memories, or simply entertain
with a puzzle or game are welcome. If you have an idea but aren't sure
if it fits, email me and we can try to put something together.

QEMU Advent Calendar publishes a QEMU disk image each day from December
1-24. Each image is a surprise designed to delight an audience
consisting of the QEMU community and beyond. You can see previous years
here:

  https://www.qemu-advent-calendar.org/

You can help us make this year's calendar awesome by:
 * Sending disk images ( or links to larger images )
 * Replying with ideas for disk images (reply off-list to avoid spoilers!)

If you have an idea after the start of the advent, go ahead and send it. We may
find space to include it, or go ahead and get a jump on 2024!

Here is the format we will work with you to create:
 * A name and a short description of the disk image
   (e.g. with hints on what to try)
 * A ./run shell script that prints out the name and
   description/hints and launches QEMU
 * A 320x240 screenshot/image/logo for the website

Content must be freely redistributable (i.e. no proprietary
license that prevents distribution). For GPL based software,
you need to provide the source code, too.

Check out this disk image as an example of how to distribute an image:
https://www.qemu-advent-calendar.org/2018/download/day24.tar.xz

PS: QEMU Advent Calendar is a secular calendar (not
religious). The idea is to create a fun experience for the QEMU
community which can be shared with everyone. You don't need
to celebrate Christmas or another religious festival to participate!

Thanks, and best wishes!
Eldon
