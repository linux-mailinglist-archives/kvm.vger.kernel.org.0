Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E011534F4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgBEQGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:06:42 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]:40903 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEQGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 11:06:42 -0500
Received: by mail-qt1-f181.google.com with SMTP id v25so1937303qto.7
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 08:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=cW02At8rCtbSYQDR/qaGPWAr3cPov/cWnXwOHXKUCEE=;
        b=qCOXTPg3gVMWLKd2m+MB2wzmTRaBJz3fGbh0J++hPjUcr++S1thR5AXdKdl/G5yWkF
         wd0cGHrrcQh/zlKoBt2L8VN15PJIhC4DtvEKe+Ac5K9Gt1nBgPUWjXKec7xP3EeQXUai
         agKo8bhVztBtd1iRiWGcmOXBEvY0hQd/zb6ZIh1emqeUO1tcT1e5qANnDvvdMLNFadeT
         hec1IHeq/SxSEFrFIoNB0VQ5UOMOGnNRWmjK61YFUh5I6vngf2TEwVgsnH4KqavPchuk
         VGugvW3qoKJEvDsg4LyyPAo6yo+WIOpLSBXuYufFG4nD9jQVQQghp82a7OHGginqnsQi
         LQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=cW02At8rCtbSYQDR/qaGPWAr3cPov/cWnXwOHXKUCEE=;
        b=KVfBkIc43Br2XAqOm3aB4TmPhLVlbE1GUjsDR8EBqwzB7PfZXcaDFQZxkjynn3zDEr
         Ip27m4pjnlLP1x6AK9JCzoGYK1575xbEfQS1Bi8HCgifnJ39kxxuUCs540wodzorRpzi
         ENOfpTXA0X/3hDKhfj83rB3WApINchAAZl6Pj7DEHiERHsovoaTSQkszscNv6vYAtD9U
         YE0OAfTK3wWHAyo2Xg1PztEzO8tQitlzTrJvFWb46jtVr8zxXXViOFaB5TTfSF47A14H
         VWT7ZgErKOzmwnsHDNgbTXtc6ZvxYVxTSY4LELTLOPRNUQlx11s6NtJiJ4x6OKhEWbV3
         nmJQ==
X-Gm-Message-State: APjAAAWQ12M6YztMs7l2c13BaggSSAhUJPG5JFf8vpqk1HUdgH4x8ctA
        tVyIpWujvWwozbYlo8yiBMAdQx225Rxf6Fvq+btYRYyKnrhp2g==
X-Google-Smtp-Source: APXvYqw8fDS648qFrrFoUGpBYSDMsUkBZSWf+5e2V+AZywpQH/ESQAiTVZqDC3bMSJGml2rxHqxdbW3Qc3WiYc2hj34=
X-Received: by 2002:ac8:4289:: with SMTP id o9mr34047949qtl.277.1580918801635;
 Wed, 05 Feb 2020 08:06:41 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 5 Feb 2020 16:06:30 +0000
Message-ID: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com>
Subject: CPU vulnerabilities in public clouds
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,
I just watched your FOSDEM talk on CPU vulnerabilities in public clouds:
https://mirror.cyberbits.eu/fosdem/2020/H.1309/vai_pubic_clouds_and_vulnerable_cpus.webm

If I understand correctly the situation for cloud users is:
1. The cloud provider takes care of hypervisor and CPU microcode fixes
but the instance may still be vulnerable to inter-process or guest
kernel attacks.
2. /sys/devices/system/cpu/vulnerabilities lists vulnerabilities that
the guest kernel knows about.  This might be outdated if new
vulnerabilities have been discovered since the kernel was installed.
False negatives are possible where your slides show the guest kernel
thinks there is no mitigation but you suspect the cloud provider has a
fix in place.
3. Cloud users still need to learn about every vulnerability to
understand whether inter-process or guest kernel attacks are possible.

Overall this seems to leave cloud users in a bad situation.  They
still need to become experts in each vulnerability and don't have
reliable information on their protection status.

Users with deep pockets will pay someone to do the work for them. For
many users the answer will probably be to apply guest OS updates and
hope for the best? :(

It would be nice if /sys/devices/system/cpu/vulnerabilities was at
least accurate...  Do you have any thoughts on improving the situation
for users?

Stefan
