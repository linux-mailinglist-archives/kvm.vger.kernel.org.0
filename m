Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CE413FBA3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 22:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgAPVj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 16:39:59 -0500
Received: from mail-vs1-f42.google.com ([209.85.217.42]:34546 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgAPVj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 16:39:59 -0500
Received: by mail-vs1-f42.google.com with SMTP id g15so13662569vsf.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 13:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=r8X/eTtXXX+3aD3qi/GwYI9mDJpLNWGnj/8ycckmYrY=;
        b=TBysfOy607rD0V2R6tNfZnAmwF3/ybbp2qMwcoBj/WOb46h/AcdWkrPS+yDVEfhKhV
         sfrGM9mS3Tmnxfa5Se0AKic/mfdF/RXmySj0Azx5lLgKh10R5dRKz+kGkYh9qRkCKDH/
         bPVLDY4h6DjxF03xqeUdSOsLdM2MzsxvpiOEWuLb8gkQ80mDHoL6gUdkjQ+HFPHEdJrv
         cNhex0qF6ewSy56ALu5kOXd6FduFOyyeXsSeVigKDfX9bj54AzmZx7hUbNucd8gzE5b2
         2A9he9SVoe8RlYwMzkYT6PiOk2LXrc61jiv4b79MWaVzvgAiFTkGJ2+G3vj63sN3hb0/
         mCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r8X/eTtXXX+3aD3qi/GwYI9mDJpLNWGnj/8ycckmYrY=;
        b=tWcGxVwOlWSeaOgumcPzB+ng3HHN9+DmX7TAT5Nf5RoNpLL41PCPetlwdmHSWnmnv0
         m2l5IfmDAlMwkIgFX6gcAW+Q1SqngCKNIgK21NeaoqkA9ozOYw0wI81vlFwg6blqo9mH
         FILlUGAywYlerNJUKw/SwmV2aQM+fU9FIJXJQm+rpNiVUclXEwjEP2/QStu4AY9kGr62
         Qgz7QQUYpkguL2RL293XpTEv6ycDUn96+TV6RNOPXkiuOoGbhbXlRmAoORxCRRgPq942
         86cBKoyaTwc8t+Z/l6tcNGP2PtE8lvgf18RIsuZb7TtErYr2G7vxPK7L7hV1Pn78bY9m
         hb9Q==
X-Gm-Message-State: APjAAAVmI8CfSyBm9InHhmduyy4sakM9Ks/V9TxFdw/u4GTIHix0twkj
        4VNLfWlfgTjX52BUFMxTCFCmUq+uqm5JHRq2amCKVlEQ
X-Google-Smtp-Source: APXvYqy3g1mY0ryfeuknM87ypXS4pX9MJRs7CVrsUkb1mgnOYuhtoTjztHVpRWi9nlFvpho8rCjIqbrbu3z6LsO130s=
X-Received: by 2002:a67:ee13:: with SMTP id f19mr2798942vsp.147.1579210798312;
 Thu, 16 Jan 2020 13:39:58 -0800 (PST)
MIME-Version: 1.0
From:   Spoorti Doddamani <spoosd@gmail.com>
Date:   Thu, 16 Jan 2020 16:39:47 -0500
Message-ID: <CAGKSnTgv5F_d23oRi3FHwKVw8Mij7_5g4o2FiaXwDA43KP+nng@mail.gmail.com>
Subject: Question on rdtsc instruction in guest
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I would like to know how rdtsc instruction works when executed in
guest. The guest uses kvm-clock for timekeeping. The tsc_timestamp
field in the shared page between the hypervisor and guest is updated
constantly by the hypervisor. Does rdtsc instruction, when executed in
guest, read the value from this shared page? Or does it read the
hardware TSC MSR register? If it reads from the hardware TSC MSR
register why do I observe different values of TSC when executed in
host and guest? Or is the instruction emulated by the hypervisor?



Thanks
