Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3302365B1C6
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 13:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjABMI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 07:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABMI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 07:08:56 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2B15FFD;
        Mon,  2 Jan 2023 04:08:55 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bs20so24031187wrb.3;
        Mon, 02 Jan 2023 04:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/7OU6LLPb4MAlfsZPwdeEX5z7HKPN5jGvf3Z2m0cZ3g=;
        b=Q7nSJIgxvSeILtTo3xVYRqdW1boBgrY3h11H41EuHZUn/3iFA3SgfueB2NeOKPTszP
         GNkUnWSjizqipvyWWagGEBvXFfwddEsadbuqyO5baSrFzmBl5d1UsnwpT5WQLL0UmNfa
         ULBsPsMTl248dMbc47rrtCTGAAEEAPBy4ZXwM5DgVvfNBRq64sfZfk87tMT5Rc14ZoJp
         fBlUc14VUzfwAr4aP/vN2oJT9zRiQ7WpjEm5VoZo3GD70sdYNklbuXIJsalXadVBrNaX
         CpeVpRFdXQ8LDxltF2o6jsK4Vvjupwb2rERPVa64ZOaB4vXcynpuLKt9ookaweyCxQ34
         4hKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7OU6LLPb4MAlfsZPwdeEX5z7HKPN5jGvf3Z2m0cZ3g=;
        b=pulVtZJMpRkKtJDpr3bLOCzz8zF9LIq1Y2UbpSAkLb6vVmR+EoQ2QFx603Yvh1MfZ3
         E8zQBeGZDk866yGLesQk5cVrsmLn1CsXDEPAUw8ouJ9OAR0FzzEqN5WsZvcMN2sFoY1O
         XJfPwHQzhojKbkPBnSEe0y+1Enk6E2fg1ppq8Jj4f0XZuyk+Hzshj32qXiuHOtj7xXup
         qj4BnRm0AsRYIRw5+v77bo16wnsX+iiohGz6Eya7tayzuFa2bd8BXcMxbynEGKrzXIbH
         j30qtU2XBdg4geGkVPW2XI4xGsceYBCzEyujT++z+lQ4KeSNbqea65bURMjZ46sxRBY9
         wO7w==
X-Gm-Message-State: AFqh2krEhD01yFxmcKQbvo4CAhPYIR1PerI4PIhqzdpEBD/lgFbsdwV6
        PrMaTUTGT0Om4E7P8jeOInClOFru+2kr3IC7EHI=
X-Google-Smtp-Source: AMrXdXt4fgWH/GWiGQE79vQbR5rE7/act5CDX9O7L50eEsVKfdJbHsloWuq5E75HiONkpSUWqeBhxuAMH6/RqZMdwVo=
X-Received: by 2002:a5d:53c4:0:b0:294:f269:111 with SMTP id
 a4-20020a5d53c4000000b00294f2690111mr167442wrw.699.1672661333576; Mon, 02 Jan
 2023 04:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20221230192042.GA697217@bhelgaas> <29F6A46D-FBE0-40E3-992B-2C5CC6CD59D7@infradead.org>
 <0e5dc3e1-3be2-f7bc-a93c-d3e23739aa3d@intel.com> <0E552CD3-1AD0-41FA-AF8B-186A916894CA@infradead.org>
In-Reply-To: <0E552CD3-1AD0-41FA-AF8B-186A916894CA@infradead.org>
From:   Major Saheb <majosaheb@gmail.com>
Date:   Mon, 2 Jan 2023 17:38:42 +0530
Message-ID: <CANBBZXOe=pfU2uideM2ZPO_ctB4=jCeKdA67GFV_XDCdqft52Q@mail.gmail.com>
Subject: Re: DMAR: [DMA Read NO_PASID] Request device [0b:00.0] fault addr
 0xffffe000 [fault reason 0x06] PTE Read access is not set
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Yi Liu <yi.l.liu@intel.com>, Bjorn Helgaas <helgaas@kernel.org>,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
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

Thanks for the pointers , It seems there was some issue in QEMU
emulator version 6.2.0, I updated it to QEMU emulator version 7.1.92
and the issue was gone. I don't dig deeper though to find out exactly
what in QEMU.

On Sat, Dec 31, 2022 at 4:06 PM David Woodhouse <dwmw2@infradead.org> wrote:
>
>
>
> On 31 December 2022 10:13:37 GMT, Yi Liu <yi.l.liu@intel.com> wrote:
> >On 2022/12/31 04:07, David Woodhouse wrote:
> >>
> >>
> >> On 30 December 2022 19:20:42 GMT, Bjorn Helgaas <helgaas@kernel.org> wrote:
> >>> Hi Major,
> >>>
> >>> Thanks for the report!
> >>>
> >>> On Wed, Dec 21, 2022 at 08:38:46PM +0530, Major Saheb wrote:
> >>>> I have an ubuntu guest running on kvm , and I am passing it 10 qemu
> >>>> emulated nvme drives
> >>>>      <iommu model='intel'>
> >>>>        <driver intremap='on' eim='on'/>
> >>>>      </iommu>
> >>>> <qemu:arg value='pcie-root-port,id=pcie-root-port%d,slot=%d'/>
> >>>> <qemu:arg value='nvme,drive=NVME%d,serial=%s_%d,id=NVME%d,bus=pcie-root-port%d'/>
> >>>>
> >>>> kernel
> >>>> Linux node-1 5.15.0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
> >>>> x86_64 GNU/Linux
> >>>>
> >>>> kernel command line
> >>>> intel_iommu=on
> >>>>
> >>>> I have attached these drives to vfio-pcie.
> >>>>
> >>>> when I try to send IO commands to these drives VIA a userspace nvme
> >>>> driver using VFIO I get
> >>>> [ 1474.752590] DMAR: DRHD: handling fault status reg 2
> >>>> [ 1474.754463] DMAR: [DMA Read NO_PASID] Request device [0b:00.0]
> >>>> fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set
> >>>>
> >>>> Can someone explain to me what's happening here ?
> >
> >You can enable iommu debugfs (CONFIG_INTEL_IOMMU_DEBUGFS=y) to check
> >the mapping. In this file, you can see if the 0xffffe000 is mapped or
> >not.
> >
> >/sys/kernel/debug/iommu/intel/domain_translation_struct
>
> My first guess would be that it *was* using queues mapped at that address, but was taken out of the IOMMU domain to be given to userspace, without stopping them.
