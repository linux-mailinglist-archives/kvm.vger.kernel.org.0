Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCB7C2BB9
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 03:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfJABnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 21:43:32 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46413 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJABnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 21:43:32 -0400
Received: by mail-io1-f65.google.com with SMTP id c6so43486771ioo.13
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 18:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=EGN9BdRgnGW8/+ZJvEnOjum98A56x3p1yBpV8CkMJzk=;
        b=PLhdHah0u9NhzPKw2+ujPtrG7dO6edVBgwlENIcNVzefxYIeC84mq1/SzOyy6FkYNl
         PE75pj9BfLKNpe+/nEtqHffVsl1Yeg+a/KhWsCrRwjDvGDcbcNoWudeeFgATBo9PPOda
         Opq4/x65eKnJevI9v1v+OdV2BO6lxXH87UD9uP2K0Fgc0AzfOvG/MibQtNH9QZAm53Tq
         85l40+XOePFOJ2Yin1VBLzk5UzH79HQmjkqeD3/EcCxoHlnSgP+ovdcw8uAd19onRTTb
         v1uwoyRZ/Cx6w8I5xv9KznquWCaSjxg9JDNDEAWonqtS8DnGg4lnIsItdrwqsWLaY1kQ
         aQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=EGN9BdRgnGW8/+ZJvEnOjum98A56x3p1yBpV8CkMJzk=;
        b=TWrSfgVeYcHCje45rkFiOwc2ku5RivMFLFG4zLp12fX63PxnFAPNHRBNOOB8NC8r7C
         9Xz9reM3cONDG5/31x2MqfODJUv8Rbf+ZcaUPjEhcZhBpVWnwrlE1vqdKmd5XsCf47xB
         IhS5PcEkv9XAtnFPk/BuPn309elcRsWQlwqTab2Lmhl/K40Mdn9TEWdqm/yce4HPHkVC
         XFkGI+ecw1HFAJ1n6oGKbeH0fMYWiK6vpm+UexFJLElJbeXql83mZPOVq1d9LOwEy/4B
         5UyYH8ECLI9SvvHqc2fraCW4YtypxcqsOXt3oxSL64PXO3oNtZf6NMb+xxoHdxN23vtv
         v+hg==
X-Gm-Message-State: APjAAAVwkTBVr3IFG/4Qmf8K1VtqC6ytuw/ukJom2Nf7yBsM6sTEY7O7
        AgiXVPWZaWg/2Q7reoMpvPqzux7DyilTUEazppA=
X-Google-Smtp-Source: APXvYqwYVSV54eJ7AA0C2w6HU1DmX7uCAUjLFBm4MtKh4Yq0bsmHjX763Yprdman9iloHLF44Jp0Za6aj8z2VqT+yfg=
X-Received: by 2002:a02:c958:: with SMTP id u24mr21773929jao.113.1569894211434;
 Mon, 30 Sep 2019 18:43:31 -0700 (PDT)
MIME-Version: 1.0
From:   Weiwei Jia <harrynjit@gmail.com>
Date:   Mon, 30 Sep 2019 21:43:33 -0400
Message-ID: <CA+scX6k8679-YUDc+OH5q8mCHUpr9E2u=Fs-3ZtF7kFqRiL9Ag@mail.gmail.com>
Subject: About the idle driver for calling MWAIT in QEMU/KVM Guest without VM exits.
To:     mst@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     gsomlo@gmail.com, agraf@suse.de, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael and Paolo,

I read your patch[1] about better MWAIT emulation in the QEMU/KVM
Guest. As shown in [1], you mentioned that you were testing and would
post the idle
driver calling MWAIT in the QEMU/KVM Guest to avoid VM exits. However,
I could not find that idle driver. I appreciate if you can post the
idle driver and how
to use it in the QEMU/KVM Guest. Or, you may want to give me some
suggestions about how to use MWAIT in the QEMU/KVM Guest. Thanks much
for your help.

[1] https://patchwork.kernel.org/patch/9674991/


Best,
Hary
