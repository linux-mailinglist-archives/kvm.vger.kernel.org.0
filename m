Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3E7489C87
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiAJPsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiAJPr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 10:47:59 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95043C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:47:59 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v6so27509017wra.8
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=peGK9jkA1ECjFCE1GKLjh+6ydkjA9f/37HFPcNjIPDU=;
        b=Fh/b5I5anwBkTrgBAtBNtIQHIvXWf0V/SmPFlgo1Ve2rCHEb+dOLc48FjRg6MyDu8W
         3JIjkFNcPvMJwb2d5XweNmVLbAzYZwc+R9yieoV/nO5cUlW7gdt/gjRxm7Vfv+yGhC7C
         UAh3QVRrkzr9VOreaFCPBJ8kfnHPm/lixEr/I8CQqyLR4tP6tUPdbihWPy+afpSTt+zC
         V+4MajeqxYj48c6D7WcxyLT/o8EgbFOASSbmqUAL1danKNNFEAzVqfpB6Ixc/xq75eSx
         69Zu8RVKme11rtIYESDsR1qD0pyXNUWrTeT4ncZtgB5S/IBqFbUZF+NHFw67ovlnh/PD
         6nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=peGK9jkA1ECjFCE1GKLjh+6ydkjA9f/37HFPcNjIPDU=;
        b=0DJAIuLJZ5dOZa/hlVhZ11Nz1mMHgY8EeQoq8+du7Z6qhPEAogIMbEBu/GWSccED4C
         LRdmEZmJpxRBYTYrEp3xeckrTs6D8RAatm0FEL0lnO89ihgumz9ueS/m/kVX3yrXrMar
         6mCn4Zj39UDyolZ0U4YWRF1k2OXEwvLEHvc+BSHDquTYOmlHJMIlARDZ2ypCImyVn1C1
         Y8ma2aFrDl7Oefns80mO2Wb9g2LgXNbWRA/2Ot+FWcQEm6SHjK7dlovGsYrkjQ1Nx7V2
         d17sirTHx3JxSmtetCOjxDhN91XcX0uxkESjJ3KpDcHvB09UEZz2aE3MprZ30JqQvE1w
         3O9Q==
X-Gm-Message-State: AOAM532c3RlLG37XKjz6MnGs4NlKtkjzNyotJ8XEcmQl6vJftIe6grwv
        UtmCeg5QklJp1njKb6UuXYp0akpXgsKhhhO+ZkKO7CD/ud+QLA==
X-Google-Smtp-Source: ABdhPJxG4gV0GKraTJ6tgmVj/WLmoPT/UKnsUKRM4S2k9+WOReU1GZyRcyeYg2VWZg8Hu9Q+7DLNpKQQR9PpEA7yc1U=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr183666wrv.521.1641829678212;
 Mon, 10 Jan 2022 07:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20220107163324.2491209-1-maz@kernel.org> <20220107163324.2491209-3-maz@kernel.org>
 <448274ac-2650-7c09-742d-584109fb5c56@redhat.com> <87k0f7tx17.wl-maz@kernel.org>
In-Reply-To: <87k0f7tx17.wl-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 10 Jan 2022 15:47:47 +0000
Message-ID: <CAFEAcA-OF29ptHr0X9ojyLEcDw9v7Smc5PC3O+v5Uv3bjiSmRA@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem redistributors
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger@redhat.com, qemu-devel@nongnu.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jan 2022 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
> $ /home/maz/vminstall/qemu-hack -m 1G -smp 256 -cpu host -machine virt,accel=kvm,gic-version=3,highmem=on -nographic -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd
> qemu-hack: warning: Number of SMP cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: warning: Number of hotpluggable cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: Capacity of the redist regions(123) is less than number of vcpus(256)

Side question: why is KVM_CAP_NR_VCPUS returning 8 for
"recommended cpus supported by KVM" ? Is something still
assuming GICv2 CPU limits?

-- PMM
