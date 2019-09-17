Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87999B4EB2
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 15:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfIQNDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 09:03:12 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:46823 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIQNDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 09:03:11 -0400
Received: by mail-qk1-f181.google.com with SMTP id 201so3803997qkd.13
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7dAUWfhUoIBj1hlfF3BwUwkqcp7qdwL0VJEwP0TnIsg=;
        b=AmO82FmcZRfp+bZCHkIY+lx3GumvNxBfF8Bv3oP1tzxeBUEdD71V0QTzh58uIzqINW
         rm0GSe7jw19TpxEyFsTErJmafzZzEuDY50VoKO4/e8cLvy6pJAR+QrDkWTb56hDqsOSG
         PF1J7kM1Iap9HeByf/0ET204jFrbOFHqsIPtVYkjv26ccy4YDX86U+roX2W/PwTxEBBF
         e31FpqgWgexFDRZsMthdLwFE7Yq5M5PoHMHEp08HJgSG9U835fe8sL680Zix5w7Vo4OI
         I1NZQ78zj5tfcgAD/g3Sxtg+jwZN1lwpEKIEnpQFsjKiz3XNYteL2ocm5ZxJFor0Z3s7
         QYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7dAUWfhUoIBj1hlfF3BwUwkqcp7qdwL0VJEwP0TnIsg=;
        b=aN4vtw7nsiheek5EPr0XVHbW611ILx447TsZKiEVuYwM31tzeXQdp6HzIvWXu4Qk6D
         XLqgnevJx3SbRMVKDgvLn+ivQSnyNV2TCA8gMx9IPERIWDHp5+r+QIabCDK8j4dWnSjk
         By0svORUJ7hby3pQ86eE/o0RBUSA7Hljr9yvFlPe82Sol8LDC9efySrXCfh39TGyv0X2
         F7heR0b9SsWDRCkPW3p8i/gzrL2mz4xA7jHuHfGdVBzpF6HZ6CJhUAEijI5fy0tueHN+
         PFHabWGwVs9q351UQxbJbprCEGnvrkwv4qi2Wh3JJtxizdmWNhJAjaALVghvpgcPWES6
         AVlQ==
X-Gm-Message-State: APjAAAV4b5UIAOc7cEvhXthCxG2OAH7QWgVefRvxcPuWAH3IQLEB5SpJ
        BQcQDvkDoyBj/hJwHcudOPYQyPy3R353YKNWLkXmAMIn7XI=
X-Google-Smtp-Source: APXvYqw8NROJkvXZrQc9RuQmaVt/Ez4mooLnAqCz9TWLcCKPAno6YnnnEFu9xUYo0WpaonzL9l1NgbUUYk0T66eh7bw=
X-Received: by 2002:a37:5c06:: with SMTP id q6mr3535076qkb.236.1568725390998;
 Tue, 17 Sep 2019 06:03:10 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 17 Sep 2019 14:02:59 +0100
Message-ID: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
Subject: Call for volunteers: LWN.net articles about KVM Forum talks
To:     qemu-devel <qemu-devel@nongnu.org>, libvir-list@redhat.com,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
LWN.net is a popular open source news site that covers Linux and other
open source communities (Python, GNOME, Debian, etc).  It has published
a few KVM articles in the past too.

Let's raise awareness of QEMU, KVM, and libvirt by submitting articles covering
KVM Forum.

I am looking for ~5 volunteers who are attending KVM Forum to write an article
about a talk they find interesting.

Please pick a talk you'd like to cover and reply to this email thread.
I will then send an email to LWN with a heads-up so they can let us know
if they are interested in publishing a KVM Forum special.  I will not
ask LWN.net for money.

KVM Forum schedule:
https://events.linuxfoundation.org/events/kvm-forum-2019/program/schedule/

LWN.net guidelines:
https://lwn.net/op/AuthorGuide.lwn
"Our general guideline is for articles to be around 1500 words in
length, though somewhat longer or shorter can work too. The best
articles cover a fairly narrow topic completely, without any big
omissions or any extra padding."

I volunteer to cover Michael Tsirkin's "VirtIO without the Virt -
Towards Implementations in Hardware" talk.

Thanks,
Stefan
