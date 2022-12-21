Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB936532E9
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 16:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiLUPJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 10:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiLUPJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 10:09:00 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5007F22B01;
        Wed, 21 Dec 2022 07:08:59 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o15so11375404wmr.4;
        Wed, 21 Dec 2022 07:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OXTq8sebFtJCOj2ociK9GeRfG8lBsoPqCb0yS+CSPS8=;
        b=EN7oMT5rjrIRJvyVaC/QdFIEDYM+UzOV5EBaftH2racgVsgMoQzMFRlkR1zMQLnhVp
         VkGnLH/fV/DvbZFfS61A3Y7/EVE4mzTGx/PB/TuKMMQYPrLsRJ1V1rYgvqsJqYianeVD
         STacOrZhkcGMReTm40n2VeCFED1RFfKpEWcBtkY7LFeM6iEVCSPd7qfJ7bHWqW9Fp4f5
         LSHu35aRYJD8xP6FyU7HBsru4BDtuGgOiWV/ahZqtyYfcTI0rBI8/0PFrkF0taKWzhbL
         w4WhD2BOuQ4nmdmcH2PKH+N2j20ZROTpF0wXPR/hMPByPNPubNVJWvWUW5Ob1/7k3pHa
         hjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OXTq8sebFtJCOj2ociK9GeRfG8lBsoPqCb0yS+CSPS8=;
        b=vTK/o7hE5+wggztu0vrS62yTJix7q6+y3EzX5JqRFFz1fhIPM44RKRTMayxaddTelh
         aB84pNUN9ghzLBDYa6KEmPgGezDAx4qBi0pG0JYzourBRQE098+LTYVoN3ih8FJCZ3Sq
         Hu15wG3nQatKB4hPIuSmVqdiVjlYqGBGOjMWTbuX2KrHNr5mF3Wtz2fAy1gia2ynjR6U
         7E+8huIi8GikMzak8ymqkA3zgSX/lVOZvkAFXU/laBPFMOWfo/9EEoDIq8ikMQbrv1CV
         3KOxzrmaDtECZLVd5Tx+4JyF91VTWf5Sc7wV86xucH2RlShj0S3OMRN4zRlVCk/6Smzd
         E07A==
X-Gm-Message-State: AFqh2kqY4KAWjUBGZH0AZI0RqZ/Ha2ObBmncDnAfTawNle5iTb9BQlFo
        /J4vUdNjHwnh9SaJnPR0Y9ybIbpIsOotAoM6FW73FopF
X-Google-Smtp-Source: AMrXdXvbreqW1N4Iv6xe2I6QmjzM7ZPwEApyn0Kkk/CcJYjy3hGRfIyACRkOHyT+WP3i0uraOpFTN7ozjuahNMmOEV4=
X-Received: by 2002:a05:600c:4395:b0:3d0:7513:d149 with SMTP id
 e21-20020a05600c439500b003d07513d149mr159969wmn.156.1671635337433; Wed, 21
 Dec 2022 07:08:57 -0800 (PST)
MIME-Version: 1.0
From:   Major Saheb <majosaheb@gmail.com>
Date:   Wed, 21 Dec 2022 20:38:46 +0530
Message-ID: <CANBBZXNCaZx9fmHsre2mF2yr7Ru66BSEZxFT7ou=Y04zv5a8Zw@mail.gmail.com>
Subject: DMAR: [DMA Read NO_PASID] Request device [0b:00.0] fault addr
 0xffffe000 [fault reason 0x06] PTE Read access is not set
To:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I have an ubuntu guest running on kvm , and I am passing it 10 qemu
emulated nvme drives
    <iommu model='intel'>
      <driver intremap='on' eim='on'/>
    </iommu>
<qemu:arg value='pcie-root-port,id=pcie-root-port%d,slot=%d'/>
<qemu:arg value='nvme,drive=NVME%d,serial=%s_%d,id=NVME%d,bus=pcie-root-port%d'/>

kernel
Linux node-1 5.15.0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
x86_64 GNU/Linux

kernel command line
intel_iommu=on

I have attached these drives to vfio-pcie.

when I try to send IO commands to these drives VIA a userspace nvme
driver using VFIO I get
[ 1474.752590] DMAR: DRHD: handling fault status reg 2
[ 1474.754463] DMAR: [DMA Read NO_PASID] Request device [0b:00.0]
fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set

Can someone explain to me what's happening here ?
