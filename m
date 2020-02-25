Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF416BED8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 11:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgBYKdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 05:33:55 -0500
Received: from mail-ua1-f44.google.com ([209.85.222.44]:45385 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730292AbgBYKdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 05:33:55 -0500
Received: by mail-ua1-f44.google.com with SMTP id k24so4318582uaq.12
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 02:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mist.io; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=YvWiUvOjhWGTA52Nc8VJs+P0ErIcUuiuMU9Hsvorso8=;
        b=OmUILx2z5CPYeMBQxEsudDuyfgJ46VSuhOiBYWSpL8vZddG4QtIDbp6B2X+Evdd9AU
         VFkabL5xzdcn7LjQpiLo6go/5vb0IE+y1oa7gbzFOu4Ok8WeRNwbS2zqurWrvjtK1z+H
         WXggbOEPGwTV0RklkPhSiHt/C8XTHoNmwIT5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YvWiUvOjhWGTA52Nc8VJs+P0ErIcUuiuMU9Hsvorso8=;
        b=kKGfrPD//nxJoEVpzmS8WB2zMngalKzaoVgpR2YC3s2r9pdlzKYQkxoOXz2+9lXjq4
         SEwGiO9Xeo8fjtpxdjw/lCrzi8ZjSyQL8TRlfMAGkCdJ2rSdyF94+h2H2+Xzstw1bSrU
         W45iRm3jm2xH9mXCLfcbZv49MetTEY0ghenxp7O8RmV7MHIRgRVyP+f2bIf1KLMpRCUJ
         /1+0pZICI7sb00PEY0/L0ZBJOaBi2sG3n5l9Itf7ZDfUs7G8kuJQjRG/mG55rg6Pu3+8
         Hh1yLSgsmzZEUoEtiZFoS79UUmNHJAqxiuAWt5oorDlAH4VEwAF2KpN2n2YiRTfRvLIl
         U8hw==
X-Gm-Message-State: APjAAAVi0y26duhxYqfydz4HSHtTXDrBaDEBtyrSlREdr4QPuHYgl4+Q
        5wsL77n93y6WwLb4DHW/K9Pb6qmbNDOaj9rxj92Vw+oAD/o=
X-Google-Smtp-Source: APXvYqwdbkLTJGU7EuFYuv+wYI+SQrbgzRGNjg93F3EpR+S+2hsXl62IhhlaBClOShDoAemZOLO0c6p/iyfwQ5ow7Wk=
X-Received: by 2002:ab0:3773:: with SMTP id o19mr28056381uat.30.1582626832856;
 Tue, 25 Feb 2020 02:33:52 -0800 (PST)
MIME-Version: 1.0
From:   Chris Psaltis <cpsaltis@mist.io>
Date:   Tue, 25 Feb 2020 12:33:42 +0200
Message-ID: <CAFwG=J6A6mt7QD-c6FqyxwdqTP5XTHzfA7k4ysvgSunGEyk6nA@mail.gmail.com>
Subject: Management tools page
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I'm trying to update this page https://www.linux-kvm.org/page/Management_Tools.

When I edit the wiki page and then submit changes, nothing seems to happen.

Could you guide me regarding the process I need to follow?

Thanks in advance,

Chris

----
co-founder @ Mist.io
