Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FBD3E0647
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhHDRCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 13:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhHDRCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 13:02:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3BDC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 10:01:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y7so4436175eda.5
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 10:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=MuYXFjLIDP1ffgnVXksPcMkOUrgyP9uY8yD/YwigKcw=;
        b=Qa531cOUkHVQ3dmUh/VKRCtVKKsiMp3cEvTnjeCiiVoR+bAYXqJKRpNqTq3HUCJA8j
         bI8z6zKP+/WdUQm+lJSGvcqEA/0c5mcUll0LvdFz2Egb4SLhr66qAs4c/or1E+B7c+Br
         8zeg+eLGzcTy2XzVnYGIyJkrL+69bjTkxF8orordzE7OWXz71I1FVxEnn1CbyFLZxxar
         EL1ByGm4xaPUYgqSPIUsVx0a6M5zBXW5TJcgvBYPj74ddU4GaaRPri9yZQezIp4JAhll
         sg2oiMbRKS0mNixP8GodBHETGv3iYEQ00VJ7rR0GXVO3cLoItRKjBj8mqwjEF6Cyeme+
         I3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MuYXFjLIDP1ffgnVXksPcMkOUrgyP9uY8yD/YwigKcw=;
        b=AqJ9l4z5rPlVYFYJuqShuvBoSdlZFTael4gimVwX7YwiplsrGS3+UtkaIQ3NcN0Gvn
         9jwovLZTEsUCoQ2pKExxo6IkpfIiTY+iPSfaf10/oWUdwk4GtMmC6JRx1zY2PUPen6nB
         0MJaltTewOvjcPvkMdqTBy8DyZxvD0uarCSsR+10MpwjGumTAiGoVTuE15DuHzgbLqpU
         MCkSRBwsNb1jxdpSx4nYsjGWhOdptKkIIpK8IaYvvoCbPm2jr5sI8qvhkXq4a/zJtlQK
         Th6yNH0CPC+STTkeWyPpJ36jgpLOQTe44YHnE0n8Kx7WgAmOCU9QPAIEjzgXzVSUXGRX
         PfMA==
X-Gm-Message-State: AOAM532OyIdxts7T4arfV+MI0RGGIK/+WTD0fPUcwfsSNos9aJj4RiVV
        xvl6K0SKAnu21ioymqc8fgJTjRCvtjGStEljL6hQoYsCrWSD7Q==
X-Google-Smtp-Source: ABdhPJxPhjfBGigYvHZKacQsd4HVBy2gUVYfKCD5biAr4flUqd+bpXe/rUT1fwFxjGL7S7xAQ8vQRjRCV9+Gde9tjek=
X-Received: by 2002:a05:6402:53:: with SMTP id f19mr905857edu.200.1628096508473;
 Wed, 04 Aug 2021 10:01:48 -0700 (PDT)
MIME-Version: 1.0
From:   Kaushal Shriyan <kaushalshriyan@gmail.com>
Date:   Wed, 4 Aug 2021 22:31:36 +0530
Message-ID: <CAD7Ssm8BEKjpt7PxwX7aPuCwtBjRoVx8dR3YCB6y=fQsHOOhgg@mail.gmail.com>
Subject: unable to connect to the guest VM instance running Ubuntu 18.04
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

#cat /etc/redhat-release
CentOS Linux release 7.8.2003 (Core)
#virt-install --version
1.5.0
#virt-install -n snipeitassetmanagementubuntu --ram 8096 --vcpus 2
--virt-type kvm --os-type linux --os-variant ubuntu18.04 --graphics
none --location
'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/'
--extra-args "console=tty0 console=ttyS0,115200n8" --disk
path=/linuxkvmguestosdisk/snipeitassetmanagementubuntu.img,size=30

I am unable to connect to the guest VM instance. Any clue and i look
forward to hearing from you. Thanks in advance.

Best Regards,

Kaushal
