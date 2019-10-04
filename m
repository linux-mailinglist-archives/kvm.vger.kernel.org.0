Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46614CBA0A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 14:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfJDMLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 08:11:23 -0400
Received: from wp558.webpack.hosteurope.de ([80.237.130.80]:48940 "EHLO
        wp558.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727688AbfJDMLW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Oct 2019 08:11:22 -0400
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2019 08:11:22 EDT
Received: from mail1.i-concept.de ([130.180.70.237] helo=[192.168.122.235]); authenticated
        by wp558.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1iGM3O-0001WZ-M0; Fri, 04 Oct 2019 13:47:22 +0200
To:     kvm@vger.kernel.org
From:   Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Not able to create snapshot
Message-ID: <cb7addce-f190-a4fb-573f-3f2357baaecd@peter-speer.de>
Date:   Fri, 4 Oct 2019 13:47:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;stefanie.leisestreichler@peter-speer.de;1570191082;457a5a68;
X-HE-SMSGID: 1iGM3O-0001WZ-M0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi List.

I am using libvirt 5.6.0, QEMU 4.1.0 on Arch Linux.
When I am trying to create a snapshot of a VM (it has an existing 
snapshot already), no matter which tool I am using (virsh, qemu-img, 
virtviewer) the following error is thrown:

[root@box1 images]# qemu-img snapshot -c snap1 manjaro.qcow2
qemu-img: Could not create snapshot 'snap1': -22 (Invalid argument)

virsh # snapshot-create-as --domain M --name snap1 --description test
Fehler: Interner Fehler: Untergeordneter Prozess (/usr/bin/qemu-img 
snapshot -c snap1 /var/lib/libvirt/images/manjaro.qcow2) unerwartet Ende 
Status 1: qemu-img: Could not create snapshot 'snap1': -22 (Invalid 
argument)


virsh # snapshot-list M
  Name            Erstellungs-Zeit            Status
------------------------------------------------------
  snap-20191003   2019-10-03 15:05:36 +0200   shutoff

virsh # version
Kompiliert gegen die Bibliothek: libvirt 5.6.0
Verwende Bibliothek: libvirt 5.6.0

Verwende API: QEMU 5.6.0
Laufender Hypervisor: QEMU 4.1.0

Any help is very welcome.

Thanks,
Steffi
