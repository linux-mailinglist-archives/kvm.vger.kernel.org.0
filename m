Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6852C68FB
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgK0PxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 10:53:04 -0500
Received: from eldondev.com ([209.195.0.149]:45626 "EHLO npcomp.net"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727281AbgK0PxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 10:53:04 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2020 10:53:04 EST
Received: by npcomp.net (Postfix, from userid 1000)
        id 50B28FD8BF; Fri, 27 Nov 2020 15:43:15 +0000 ()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eldondev.com;
        s=eldondev; t=1606491795;
        bh=8DCdgTjjdl6mzx383lMulSKdvH6MJim5RnaLe2bPrkc=;
        h=Date:From:To:Subject;
        b=q4XOx+AS+Y/wKiXjY5kK9B8h5pUaps99gl6txogWHH9Duis/lAfbcERRNzNV8c2gc
         OIdaz16vePGPS9FXyUTpB7+Ce0vUyhVVcBPkc04clfM7bxWf6cF/j1M7GpDC8um1bY
         Z9t5eu/k8deCJuCZUyV7PKvVTTNUSFFMJQo0vJcE=
Date:   Fri, 27 Nov 2020 15:43:15 +0000
From:   Eldon Stegall <eldon-qemu@eldondev.com>
To:     qemu-discuss@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, libvir-list@redhat.com
Subject: QEMU Advent Calendar 2020 Call for Images
Message-ID: <X8Eeaxj9Ekd++SI7@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi,
QEMU Advent Calendar 2020 is around the corner and we are looking for
volunteers to contribute disk images that showcase something cool, bring
back retro computing memories, or simply entertain with a puzzle or game.

QEMU Advent Calendar publishes a QEMU disk image each day from
December 1-24. Each image is a surprise designed to delight an audience
consisting of the QEMU community and beyond. You can see previous
years here:

  https://www.qemu-advent-calendar.org/

You can help us make this year's calendar awesome by:
 * Sending disk images ( or links to larger images )
 * Replying with ideas for disk images (reply off-list to avoid spoilers!)

If you have an idea after the start of the advent, go ahead and send it. We may
find space to include it, or go ahead and get a jump on 2021!

Here are the requirements for disk images:
 * Content must be freely redistributable (i.e. no proprietary
   license that prevents distribution). For GPL based software,
   you need to provide the source code, too.
 * Provide a name and a short description of the disk image
   (e.g. with hints on what to try)
 * Provide a ./run shell script that prints out the name and
   description/hints and launches QEMU
 * Provide a 320x240 screenshot/image/logo for the website
 * Size should be ideally under 100 MB per disk image
   (but if some few images are bigger, that should be OK, too)

Check out this disk image as an example of how to distribute an image:
https://www.qemu-advent-calendar.org/2018/download/day24.tar.xz

PS: QEMU Advent Calendar is a secular calendar (not
religious). The idea is to create a fun experience for the QEMU
community which can be shared with everyone. You don't need
to celebrate Christmas or another religious festival to participate!

Thanks, and best wishes!
Eldon
