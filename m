Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F24D007E
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfJHSJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 14:09:13 -0400
Received: from mail1.tango.lu ([212.66.75.102]:42473 "EHLO mail.tango.lu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfJHSJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 14:09:13 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2019 14:09:12 EDT
Received: from mail.tango.lu (localhost [127.0.0.1])
        by mail.tango.lu (Postfix) with ESMTP id F3B00382FC2
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 20:01:11 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 08 Oct 2019 20:01:11 +0200
From:   freebsd@tango.lu
To:     kvm@vger.kernel.org
Subject: Easy way to track Qcow2 space consumption
Message-ID: <ab1bd1a234b7b9d18433d539f179f602@tango.lu>
X-Sender: freebsd@tango.lu
User-Agent: Roundcube Webmail/1.2.0
X-Virus-Scanned: clamav-milter 0.98.7 at mail.tango.lu
X-Virus-Status: Clean
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello List,

I'm using a fairly old KVM version

ii  pve-qemu-kvm                          2.2-28                         
     amd64        Full virtualization on x86 hardware

don't see much point upgrading either since everything works but I could 
still use a feature to keep track of the actual space used by the VMs 
without SSHing into all of them and doing a df -h.

The VM images (especially the DBs with high rw operation will just grow 
and grow with time), for this to free up space the standard process was:

1, Zero-fill the drive (dd if=/dev/zero of=/some/file until you run out 
of space)
1B, sdelete -z c: < windows VM
2, Shut down the VM
3, cd to where the images for the VM are kept and run qemu-img convert 
-O qcow2 original_image.qcow2 deduplicated_image.qcow2

I wonder if there were any improvements done in the KVM for addressing 
this space issue. A lot of us using qcow2 because it's easier to backup 
due to the small size (eg: a basic configured webserver might only uses 
3-4 Gb vs a 40GB preallocated empty image full of 0s).

Thanks.
