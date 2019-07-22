Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA43B70200
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfGVOOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 10:14:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34795 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfGVOOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 10:14:46 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so5941165edb.1
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 07:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RndvtDH92J1EDhqL1dSbJVA7yR/niGc5Ev9iShmRw7Y=;
        b=rwT+K1Dva3LqMdJtA5IlAJUqEOr+5t7jZJ4sl82MQCxJNp/lq7LKgn6OM2Y/0lvvTR
         +B/0HZroyefezbg/lVEO8e7tdX0EfHAOt2z4RRfHLtj8fuwbCyxBnpRLtONQ6sbcqGOO
         3zjMa+BuxABPXbQfmae/uE38bPH54FW3SytpIvrs8PWiUuTdCw4zqGvqlV1QNJAjFb8I
         7PmNu/fyf9pinu2TWylVlceGDruUg5g2V1IoblNUlXz75TvjPDmXXG7wpzDBLIff/DLQ
         neljxqjHvAab5fySju2nFvFi14/0TvDht9V6W1HQy1DP2MTlNcbX+PM/wH3OPkbNHNp1
         r/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RndvtDH92J1EDhqL1dSbJVA7yR/niGc5Ev9iShmRw7Y=;
        b=jBFxI+nXxnGAIKM9ZNhQYM6aYdXZ15wcFHkvb2FMzCeK/lJesRUQfy3N3e6fK6I6yC
         DaPY/ILbkE/j3ylERlhOzqWIy1pzccyYis89hDxMDqnd2PPtKKkR8Dr4R8mab5vaOK6e
         A7yc9gZJWssWd53jVXgcjxl5WggWbtmGgs1kjQAZkB+PE6bC8t4RfjxDMoNR2KvXnoPx
         MDiq3Yi9qXhk3TXB1M3PeE2ze+Mm0k5V3dMLYEv8fCGF/8+96VlehsatzpWPkd6+nNo5
         n4N7mEk3OIhj4KsOTOXIWgoqFEz1kOwuBY0933A7IsT9VvhzSGzErsMNc/d+X1mcS0fZ
         Fesg==
X-Gm-Message-State: APjAAAVfyz7XoyN3e0hISflgrS9MyCCZCZ5pRJRKmXuGUqVib0ZNIrN/
        mHb0Kvijkj0OS8ecFC80G6qvoNeTimgYulf5nyVbKp85FQA=
X-Google-Smtp-Source: APXvYqxQFGICOLgyYhzs8o+woFHj1Zc3USMyOMb876MgR4r9p/4MwuG1+5WJQzEbiCmz73AKDmMBhXmByKpDUUtG7RY=
X-Received: by 2002:a17:906:718:: with SMTP id y24mr53229318ejb.71.1563804884419;
 Mon, 22 Jul 2019 07:14:44 -0700 (PDT)
MIME-Version: 1.0
From:   Kaushal Shriyan <kaushalshriyan@gmail.com>
Date:   Mon, 22 Jul 2019 19:44:55 +0530
Message-ID: <CAD7Ssm9NRozuNBX0puYyd-JnkhNt0AonerPZfZ=Qou-5inTaRw@mail.gmail.com>
Subject: KVM bridge networking
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am confused regarding KVM networking. I have configured base OS and guest OS.

[root@baremetalinhousebaseserver1 network-scripts]# cat ifcfg-br0
TYPE=bridge
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
#IPV6INIT=yes
#IPV6_AUTOCONF=yes
#IPV6_DEFROUTE=yes
#IPV6_FAILURE_FATAL=no
#IPV6_ADDR_GEN_MODE=stable-privacy
NAME=br0
#UUID=af60e6bd-e824-44fa-a816-763e6e977ae6
DEVICE=br0
ONBOOT=yes
IPADDR=192.168.0.65
PREFIX=24
GATEWAY=192.168.0.10
DNS1=213.117.155.12
DNS2=213.117.155.10
[root@baremetainhousebaseserver1 network-scripts]# cat ifcfg-em1
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=em1
UUID=af60e6bd-e824-44fa-a816-763e6e977ae6
DEVICE=em1
ONBOOT=yes
BRIDGE=br0
IPADDR=192.168.0.35
PREFIX=24
GATEWAY=192.168.0.10
DNS1=213.117.155.12
DNS2=213.117.155.10
[root@baremetainhousebaseserver1 network-scripts]#

I use the below command to launch KVM guest VM

#virt-install --name=qubecrafter02
--file=/var/lib/libvirt/images/apprafter02centos7.img --file-size=50
--nonsparse --vcpus=2 --ram=8096 --network=bridge:br0 --os-type=linux
--os-variant=rhel7 --graphics none
--location=/var/lib/libvirt/isos/CentOS-7-x86_64-DVD-1810.iso
--extra-args="console=ttyS0"

I do vim /etc/sysconfig/network-scripts/ifcfg-eth0 on guestosvm1

[root@guestosvm1 network-scripts]# cat ifcfg-eth0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
UUID=805ff146-ecc1-460a-a7e2-e35eb19814c2
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.0.66
PREFIX=24
GATEWAY=192.168.0.10
DNS1=213.117.155.12
DNS2=213.117.155.10
[root@guestosvm1 network-scripts]#

I am confused between bridge and ethernet networking. Am i missing
anything in the above configurations, Please comment.

Thanks in Advance and i look forward to hearing from you.

Best Regards,

Kaushal
