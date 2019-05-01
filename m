Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9C10F24
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 00:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfEAWqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 18:46:12 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:44000 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfEAWqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 18:46:10 -0400
Received: by mail-io1-f44.google.com with SMTP id v9so356610iol.10
        for <kvm@vger.kernel.org>; Wed, 01 May 2019 15:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucla-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fkw9oi3VL0oqq24xfC1kx9KZ48Ufxss4HZgXsunjCfE=;
        b=fHG9rnXm13sOP6xGC0Nqw1ZqhBb1Ze9NS6HdQQwHQvAk7VaBwhA8GMMbeap+Z7WL2S
         AIgi7/hbwBcQ8C6jQ+mkirlw6kWSqStIPqbwEBDPNfFx803ijbc8Vkom1YgRoiggWmSB
         qoR8YxF+WkwLFf+9w6c3U77wsPs5yEOwQXbGOtZQOEoJA0fCZ2EhK6761mTA10C9izfC
         s68v0JlGOKFcKyyY2wps7Me8h8eN/svIvbubG6Tf8LJkA4bT70W4eo5QrxxKEpIFQVBk
         bMe0qNNKFFyXVrjwYK5/2y8T4EjIQKd2Tn5Km7QV+M/Bu/J0K5/c6LWoPYzWCphI+g8y
         QWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fkw9oi3VL0oqq24xfC1kx9KZ48Ufxss4HZgXsunjCfE=;
        b=BORl/UKVywwAI/TJ9kyatJ7rGUNgx4M06tRRTVZmVcCj7e+em/I0lwjZLmb1LHuXby
         CAcAStPBn2CK5S/K56K0SLK2Oo8Tfd7WTs8NFgla1GVlXCqQyOLUlA5TXgWwme3yoLyB
         /ZIjVk0TWkXGCUaHSjGPCzH4AlkjFZoxtChKTFUUhtJovwvwWXAKJULEN66MHMhpVonX
         jvT+s9UPKiOULcTIsSWx/FYVWbEiuOKpxb7YnoyhjkchpK9H38hOX9NjMz/vcQMASt8B
         rVEzX1k+cs7ePwgEbex5X0qLs3JRYMQncPqq2Wjkoevh8JKprGKU4/hOC9GOTduXK6ii
         /8CA==
X-Gm-Message-State: APjAAAWXWtCyO6WrZ5D2Ow5kXODBIgU3x4kr6POl3o0oAzD7uihORbNi
        g2iJMiuM71nLQlvHlQ+WKAGlOVzdepsff+79darZsMdzLW7yKw==
X-Google-Smtp-Source: APXvYqxwqNJiKO50hV6cxuo/i3Cj7Rl7SJZy7vzSbSUMRcInJ6oXqQxqdXOgKKuz0++IU2kRGDSP1wCLhbyI5bwxYP4=
X-Received: by 2002:a5d:83d7:: with SMTP id u23mr307343ior.56.1556750768823;
 Wed, 01 May 2019 15:46:08 -0700 (PDT)
MIME-Version: 1.0
From:   ivo welch <ivo.welch@ucla.edu>
Date:   Wed, 1 May 2019 15:45:58 -0700
Message-ID: <CAJrNScT9i3jGY9DDGUHjtHZKJQ_RLsHM3j90Tzjpxfx0+XXV8Q@mail.gmail.com>
Subject: developer intro
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ladies and Gents--- I want to learn how to write a pseudo-storage
device, where the host can observe and potentially intercept read and
write requests to LBAs by the guest(s).  I am looking for a starter
docs, tutorials, examples, general docs, etc.  (Or perhaps is someone
interested in helping me set this up for pay, especially if such docs
are hard to find?)

My first source was https://www.linux-kvm.org/.  I am not sure whether
it is maintained or not.  For example,

On https://www.linux-kvm.org/page/Lists,_IRC, the subscribe archives
links are not working.
Under "About", the "Book qemu-kvm & libvirt" (http://qemu-buch.de/) is broken.

advice appreciated.

regards,

/ivo welch
ucla

--
Ivo Welch (ivo.welch@ucla.edu)
http://www.ivo-welch.info/
