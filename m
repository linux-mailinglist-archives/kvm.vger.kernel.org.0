Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308133AB20
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfFISYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 14:24:31 -0400
Received: from mail-it1-f176.google.com ([209.85.166.176]:54753 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbfFISYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 14:24:31 -0400
Received: by mail-it1-f176.google.com with SMTP id m138so8402366ita.4
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2019 11:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucla-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=SiXpQlXuAHOuavDSdQmDngXMyGEgtpDAvvMgiKOs8OE=;
        b=vhtMbPw9Fvcbi6TlueS7aGpKiTq+ydo883CgqmD77kN76QG8hRUJQZ5PyipKQ1CsL3
         AxBvZYzHxKrA9abw7tKcxpXg2nquJji14cTEouixbOe+20QaUAcqEFEy36IOiQZ+Nmhy
         MNuOJRcF2NXD7rmPBSTNvRt4BjFZR7rsaIagz+c/w7G+yxzs7UvddK52Iyou/GgH7Yll
         fOnSKUAeTOL9nuFaDrVpMBhl+LzLTicvgirR83qfcVKbzFBqi0Rq3Y/egLciv1atBdE+
         Fq6OtamXFFRFOygx0QAsmAQphSGeGbK41GVyOa2Om4hTTkvDa0WmUOSKmnBaGiyrLvtl
         uS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SiXpQlXuAHOuavDSdQmDngXMyGEgtpDAvvMgiKOs8OE=;
        b=WL5qtv5AB/IhbA7tO2wHj/bpSjBcg7jTBLkobbWnRQVq194CdkO47zcvETnE2mj8gv
         jRnVbmc6xEp2aM8Mf8fljFh+3B2iqu/gq39yL5Q6oCaHDBbX7xIPIiFIIYIpKsbPRfjU
         KFZkvJBfsW3PzHaa/pt/ZaauWDFQBfYHs4Zl6PyBj8idnHFGneM7nH4ihuvsZwc8HruV
         9BFbrjL6LK9sixnc0QRYTami08rhcapqsVirUh11I07wGqunwLO5ffmkS0wlDkSjX9Y1
         d557ST2uYEaK08LMTnvkIw8lgwZWzpTuP11deIUui/7/dT/dRZXihkIu3VjppNMLN3E/
         CbbQ==
X-Gm-Message-State: APjAAAXcop979PZKoJLy88MZRqhyEFlH3gPLgq7E0cTiT0gItDDwbku5
        HE4FGn5EOombYj9ilLCmiRJLidRYwWpiwnGFqCt/tHx5CyU=
X-Google-Smtp-Source: APXvYqyTaB3h+TGZ1Y6fEmm5mWr6z7umVeuPacdgOlkxFfuK0VAbhWl9+8AYVkKJ66cPqEKg8XztsnbbIwVi73BnJZQ=
X-Received: by 2002:a24:30d2:: with SMTP id q201mr10411976itq.100.1560104670338;
 Sun, 09 Jun 2019 11:24:30 -0700 (PDT)
MIME-Version: 1.0
From:   ivo welch <ivo.welch@ucla.edu>
Date:   Sun, 9 Jun 2019 11:24:19 -0700
Message-ID: <CAJrNScSLdAu=3Hh32mcG2nYvhby0U=Jy4UQ3h3pGbuJ0p0PCaA@mail.gmail.com>
Subject: need developer for small project
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I would like to hire someone to do some open source surgery.
specifically, I would like someone to modify the disk driver to allow
me to add some basic standalone hooks.  every time a guest wants to
read or write a sector to the drive, I want my own C routines on the
host to be called.  my C routines, in a separate standalone file,
should have the ability to do such things as log the request, rewrite
the request (e.g., write to a different sector and/or use my own
hashing encryption/decryption etc), and/or tell the disk driver not to
execute the request but return an error.  ideally, I don't need to
learn kvm internals, but get a standalone template with example use.
comp negotiable.

in addition, I have an unrelated request.  I would like to get some
basic help to get Windows 10 installed.  it was easy to install a
ubuntu guest on a ubuntu host, but I could not get a standard windows
10 guest onto my ubuntu host.  I am not asking for something special
here...this should have worked without effort right out of the box.  I
was surprised that it did not.  having someone with expertise should
just make the troubleshooting easier.

please drop me an email if you can help.

regards, /iaw
--
Ivo Welch (ivo.welch@ucla.edu)
http://www.ivo-welch.info/
