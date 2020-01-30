Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3918914D7E4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 09:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgA3Ink (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 03:43:40 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:41523 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgA3Inj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 03:43:39 -0500
Received: by mail-qt1-f172.google.com with SMTP id l19so1815676qtq.8
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 00:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KJTZMhxSYbKog3q3QunAoOxfir5NefkAvc0Wc1DUW10=;
        b=LMhl1CzhWteprbNFlrJ8l439XOCil8NzH7d4KBsBWs4e7q8CxZ6DjaPR+iF4LjHHtt
         nr/FPXLqrdIvEG5GRAt3Zioqitjx2InyNhx3scDMCgZBp1f1JG3um3NSmXg6SGOEHR8y
         lygf2bJ4dHmXVO0NdXNHNW6yUuBJXVgWfrfBtSTKNND7m/nKA8MJlhDQDps9NQ61rKSI
         BbXLbWFUzNVdeGJTx6h3lNsArT57WuDcun7y0wCvCzSusfgGIAa/22pLULMTyNaYikEG
         4DGUavnkvltNf1cAhSjEgB1Ns0LPl+SWqiASlQWGED8uQ2nrmVIMvfeoVVkKjaSzHcIJ
         trVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KJTZMhxSYbKog3q3QunAoOxfir5NefkAvc0Wc1DUW10=;
        b=iSnF6CSr4W2TDKQxC8nYNapeKSbsI+S8pCxm2NBhtls0xqys0YY7EYt2V4lEzj6YY1
         /9zR/VU1PxN+IybfJT+rQwNmIJik7eLwn96Zbws84sMFTeDdogW94WBeyzyYs39upFFs
         TilfvU53uwIxp5Sc5AxIyyH8G+VsGFwx/y5209EDC/14r6w7HaXOWXeGzVLpfKFQp19V
         be5GeRrB9g9WPSKrBAzwgo3BZtXBTS6DNADcG8+q09XffXOOPxI19cujTsoU9Rk0KN7+
         ZjBY4M24mJyY7Rt3B7xQ6CbPFW7jsRD99Si/YrDgkgdOCeG+yUeSRWRuJ5d7naDsyRPy
         9oYw==
X-Gm-Message-State: APjAAAUKc6OjI4xi4wlEd0QWWC34Eqzua3Y7TkjfxJDU+Ts/mPM3X0UV
        FSjWGmhqA16u8gNVjo5dcJoPFMsaBVgeqct/OHEOlcdY
X-Google-Smtp-Source: APXvYqzU6EnC7YHgL2F7mwFlcDxztnSIuRfb1ysW8NFlma5PTb/286Ic7T5SPPnmNtSmeN6QDRLD/enlfeQDz9RpKls=
X-Received: by 2002:ac8:145:: with SMTP id f5mr3618660qtg.194.1580373818543;
 Thu, 30 Jan 2020 00:43:38 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Bauer <cubewerk@gmail.com>
Date:   Thu, 30 Jan 2020 09:43:27 +0100
Message-ID: <CAJWMQtBraWfbDQuVXMsmvG9QN3+i18sv7g1qWe1jQotBBBLpWA@mail.gmail.com>
Subject: Node not reachable on vlan, after vlan is used by virtual machine
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

i have a strange behavior on my linux system and can not explain it.
Help would be greatly appreciated.

host proxmox1 with a trunk/bond interface to Cisco-Switch.
proxmox1 has mgmt in vlan100 on same bond:

bond1.100@bond1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP group default qlen 1000
link/ether 3c:fd:fc:9a:7d:cc brd ff:ff:ff:ff:ff:ff
inet 10.64.253.203/24 brd 10.64.253.255 scope global bond1.100

All is fine and proxmox1 is reachable from other machines through vlan 100.

The routing between the vlans, is done by a pfsense firewall on
_another_ proxmox-node.

Now instantly when i move the firewall to proxmox1-host, the proxmox1
host is not reachable through mgmt-vlan 100 anymore.

Ideas?

Thank you
