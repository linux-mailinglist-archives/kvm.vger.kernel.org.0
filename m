Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC10583BDE
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiG1KOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 06:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbiG1KOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 06:14:00 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5DB65545
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 03:13:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v5so716563wmj.0
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 03:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=OwtQ01iyvWW02aEqU8I1cLzmE86cVtLSJOim+G3EiMo=;
        b=nC6N1+FIfZ8qW8P0WLRt9JA3s69lzCNOcSga+7s0vxdLP3XjZhzqaIkwkP5P1tgdci
         GR29rDWmzdTuVrv+SOFKki7grcLPwYUiqICTNkz5XhDaGc4HlU/7v/OjyUWcuiqFLq5w
         XxlGRm45fSYhULfaBFChgd0iPEaaWaecoYNrA1cFSRmVPSds/r64v9iD0YBl+QaoJDmb
         DDT76x+FsCCNvJoWCquIF8cbzw2e7TqhQbbyL6e1OOVJJx1N3F1SLvDT+LLLDn/gXuhc
         sLzhGwsywrEMLyiwnEFIBOkxkyeil52HKUcWSpIYYBKOX6evRjV1ebxhgp/HO558pWb5
         /7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc;
        bh=OwtQ01iyvWW02aEqU8I1cLzmE86cVtLSJOim+G3EiMo=;
        b=IKChNY+UXbkh0fmA3Jza/vTuOM3LS53nP2g3ykOmJE8wvYqhHnP2H1QIWZ/UcLDi9s
         irSS3xbiWl6+uJH0uMzTF19jS4NxA8vmKQz9crx1gBHy8aKSOtN2xSu86KOPeFc4sfTP
         pMYh6Jtn8vitrjdDlGcvifzNMbhR4i0ITL2Wqwh789HI2Ho7caEI55DG53LGFcmiNiO5
         w1lyKC604vDf8+97/3wjwhNLzlH52J2wgwBuRfb0/bRi9+JynctEVvgfL6L9J6AWlk+3
         QzMKR/9pSHm2JC9VXkmVGU/72GcxNn5gPWHQSdlOyfSqp0wsOODOAWiuthkCESXyGn+1
         whhA==
X-Gm-Message-State: AJIora/lErsA8rqrCZsmfH/8s8LOXenVUOtc7+iLk2UogW2se0tErjp/
        RHs044mmAXO1XrX6kEKJlrdFuQ==
X-Google-Smtp-Source: AGRyM1vHfpjCseABSE4t/EiEtNmp3FM9HuOorpTvtmL0uvz/Z+yWRkdPxuVojee2GnZDIh6FNDVYjw==
X-Received: by 2002:a05:600c:3b9e:b0:3a2:feb5:2b43 with SMTP id n30-20020a05600c3b9e00b003a2feb52b43mr6073835wms.26.1659003237562;
        Thu, 28 Jul 2022 03:13:57 -0700 (PDT)
Received: from smtpclient.apple (bzq-84-110-34-91.static-ip.bezeqint.net. [84.110.34.91])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a17ab4e7c8sm5441937wmq.39.2022.07.28.03.13.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Jul 2022 03:13:56 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Guest reboot issues since QEMU 6.0 and Linux 5.11
From:   Yan Vugenfirer <yan@daynix.com>
In-Reply-To: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
Date:   Thu, 28 Jul 2022 13:13:54 +0300
Cc:     kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Mira Limbeck <m.limbeck@proxmox.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1675C8E3-D071-4F5A-814B-A06C281CC930@daynix.com>
References: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
To:     Fabian Ebner <f.ebner@proxmox.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fabian,

Can you save the dump file with QEMU monitor using dump-guest-memory or =
with virsh dump?
Then you can use elf2dmp (compiled with QEMU and is found in =
=E2=80=9Ccontrib=E2=80=9D folder) to covert the dump file to WinDbg =
format and examine the stack.=20


Best regards,
Yan.


> On 21 Jul 2022, at 3:49 PM, Fabian Ebner <f.ebner@proxmox.com> wrote:
>=20
> Hi,
> since about half a year ago, we're getting user reports about guest
> reboot issues with KVM/QEMU[0].
>=20
> The most common scenario is a Windows Server VM (2012R2/2016/2019,
> UEFI/OVMF and SeaBIOS) getting stuck during the screen with the =
Windows
> logo and the spinning circles after a reboot was triggered from within
> the guest. Quitting the kvm process and booting with a fresh instance
> works. The issue seems to become more likely, the longer the kvm
> instance runs.
>=20
> We did not get such reports while we were providing Linux 5.4 and QEMU
> 5.2.0, but we do with Linux 5.11/5.13/5.15 and QEMU 6.x.
>=20
> I'm just wondering if anybody has seen this issue before or might have =
a
> hunch what it's about? Any tips on what to look out for when debugging
> are also greatly appreciated!
>=20
> We do have debug access to a user's test VM and the VM state was saved
> before a problematic reboot, but I can't modify the host system there.
> AFAICT QEMU just executes guest code as usual, but I'm really not sure
> what to look out for.
>=20
> That VM has CPU type host, and a colleague did have a similar enough =
CPU
> to load the VM state, but for him, the reboot went through normally. =
On
> the user's system, it triggers consistently after loading the VM state
> and rebooting.
>=20
> So unfortunately, we didn't manage to reproduce the issue locally yet.
> With two other images provided by users, we ran into a boot loop, =
where
> QEMU resets the CPUs and does a few KVM_RUNs before the exit reason is
> KVM_EXIT_SHUTDOWN (which to my understanding indicates a triple fault)
> and then it repeats. It's not clear if the issues are related.
>=20
> There are also a few reports about non-Windows VMs, mostly Ubuntu =
20.04
> with UEFI/OVMF, but again, it's not clear if the issues are related.
>=20
> [0]: https://forum.proxmox.com/threads/100744/
> (the forum thread is a bit chaotic unfortunately).
>=20
> Best Regards,
> Fabi
>=20
>=20
>=20

