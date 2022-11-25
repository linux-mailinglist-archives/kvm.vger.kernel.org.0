Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DFC639197
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 23:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKYWrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 17:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYWrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 17:47:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E8F532DD
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669416373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bM1m5O+B+JXd08IoQDsagPi2jAksJvtxGECT0lHGKhk=;
        b=A8z9HuT9UzxdKDGYnP90iFsWCJrP4OFJR++elJXyVCpHCbq6yJWyvnM2WQgwEKLXsb5NZN
        +XSQhvN1iLurfKZkejOrjWNsrebhCKY8v5ng8FDA71FSCA/EmVISUABuSuAtrNz45aAgof
        9GIvTKYSUydTsMW5PiV2rG818isbrMs=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-QeDKWNpsPvK60jLrPkFwQQ-1; Fri, 25 Nov 2022 17:46:12 -0500
X-MC-Unique: QeDKWNpsPvK60jLrPkFwQQ-1
Received: by mail-vk1-f199.google.com with SMTP id v18-20020a1f2f12000000b003b6a70630beso1603759vkv.12
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:46:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bM1m5O+B+JXd08IoQDsagPi2jAksJvtxGECT0lHGKhk=;
        b=CkKN6TSMeMHJMqQNO2zfl7xwoiF0raW+N9QstJm1osakXucXl/32SobMutptykBTvP
         iW0g73auP4UFzJneFcj7g6xHUkhFYNJrfZd3v+jtc3z+0wYI4Z9jD6/xVCT7P9lFwLCW
         p4C2RHe3x2Zrkl6E8O5rHiIQ5nWxd5UFFbkKFwMf6MCZLtAlw9pFmcCFXC9Kunpc1Xfv
         /Cxv4v7uLPeKoZ4hdExh64m7G1w1N+oFm8vKUwjNHeRjR3oEB1xwhw4X1EPoiCoVWiip
         E4kzpHLBFUQ+MJBiBTyN4HQo2q8+nfZR+67NfC/DSVslmdwEXE+p7Sau8N3oa+ekTTs5
         hdSA==
X-Gm-Message-State: ANoB5plT4dhYxJDRFNwlDYxvSNq6Oy9WqiO8aQuW146lCYXSay5FZcHz
        zdOxxbjz47OXHPDrAQao9alndBLbwcK2tpYO8OPAIN9ywoOFVQ/i2iT3m4iIM2JJp7TkHl1aizj
        YeSqeWc9B52qTg7/ZJt/0tESwvcRv
X-Received: by 2002:ab0:268e:0:b0:3e3:81cc:b64e with SMTP id t14-20020ab0268e000000b003e381ccb64emr22254332uao.57.1669416371665;
        Fri, 25 Nov 2022 14:46:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7b5nQA1kXd5O0W++FS72D9D/R8Ic77Gfd6SiJWd/A45p68YsF3CP1fSF0/Ea9O/sipkQVh1KID/2+/JdY1ePk=
X-Received: by 2002:ab0:268e:0:b0:3e3:81cc:b64e with SMTP id
 t14-20020ab0268e000000b003e381ccb64emr22254324uao.57.1669416371392; Fri, 25
 Nov 2022 14:46:11 -0800 (PST)
MIME-Version: 1.0
References: <PH0PR02MB84228844F6176836E8C86B1BA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <df01b973-d56c-7ba9-866f-9ca47dccd123@redhat.com> <PH0PR02MB84229CEBB3C7A8DAC626107CA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <PH0PR02MB8422D2C6A7F56200FCD384D8A40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
In-Reply-To: <PH0PR02MB8422D2C6A7F56200FCD384D8A40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 25 Nov 2022 23:45:59 +0100
Message-ID: <CABgObfa+NKKeV=178L348VfrZkB7sa2kCZ1V1kwU+3pKfUd2jg@mail.gmail.com>
Subject: Re: Nvidia GPU PCI passthrough and kernel commit #5f33887a36824f1e906863460535be5d841a4364
To:     "Ashish Gupta (SJC)" <ashish.gupta1@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        John Levon <john.levon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What about a much newer kernel, like 6.0 or so?

Paolo

On Thu, Nov 24, 2022 at 7:18 AM Ashish Gupta (SJC)
<ashish.gupta1@nutanix.com> wrote:
>
> Hi Paolo,
>
> With v5.10.155 also, it failed in similar way.
>
>
>
> [root@ahvgpu04-1 ~]# uname -r
>
> 5.10.155-2.el7.nutanix.20220304.242.x86_64
>
>
>
>
>
> Logs from guest vm.
>
> [  113.669214] NVRM: GPU at PCI:0000:00:06: GPU-fcdeaa4c-664a-4de8-2e32-23e14628ce8c
>
> [  113.669215] NVRM: GPU Board Serial Number: 1651522000466
>
> [  113.669216] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.669384] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.669400] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.669498] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.669609] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function GSP_RM_CONTROL (0x20800a70 0x0).
>
> [  113.669615] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function GSP_RM_CONTROL (0x20800a6c 0x4).
>
> [  113.670156] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function GSP_RM_CONTROL (0x6 0x0).
>
> [  113.670247] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.670338] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function GSP_RM_CONTROL (0x20800a38 0x18).
>
> [  113.672663] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function UPDATE_BAR_PDE (0x0 0x0).
>
> [  113.672702] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.672709] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function FREE (0x0 0x0).
>
> [  113.672787] NVRM: Xid (PCI:0000:00:06): 119, pid='<unknown>', name=<unknown>, Timeout waiting for RPC from GSP! Expected function UNLOADING_GUEST_DRIVER (0x0 0x0).
>
> [  113.674376] NVRM: GPU 0000:00:06.0: RmInitAdapter failed! (0x11:0x45:2540)
>
> [  113.675130] NVRM: GPU 0000:00:06.0: rm_init_adapter failed, device minor number 0
>
> [  113.850458] NVRM: GPU 0000:00:06.0: RmInitAdapter failed! (0x22:0x56:731)
>
> [  113.851206] NVRM: GPU 0000:00:06.0: rm_init_adapter failed, device minor number 0
>
>
>
> Regards,
>
> --Ashish Gupta
>
>
>
> From: Ashish Gupta (SJC) <ashish.gupta1@nutanix.com>
> Date: Wednesday, November 23, 2022 at 5:49 PM
> To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org <kvm@vger.kernel.org>
> Cc: seanjc@google.com <seanjc@google.com>, John Levon <john.levon@nutanix.com>
> Subject: Re: Nvidia GPU PCI passthrough and kernel commit #5f33887a36824f1e906863460535be5d841a4364
>
> > Have you tested with a more recent version than 5.10.x, to see if the
> > bug is still there?
>
>
> Building image with v5.10.155.
>
> I am hoping to get result in 2-3H, I will update thread.
>
>
>
> Regards,
>
> --Ashish Gupta
>
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Wednesday, November 23, 2022 at 5:39 PM
> To: Ashish Gupta (SJC) <ashish.gupta1@nutanix.com>, kvm@vger.kernel.org <kvm@vger.kernel.org>
> Cc: seanjc@google.com <seanjc@google.com>, John Levon <john.levon@nutanix.com>
> Subject: Re: Nvidia GPU PCI passthrough and kernel commit #5f33887a36824f1e906863460535be5d841a4364
>
> On 11/24/22 01:56, Ashish Gupta (SJC) wrote:
> > Nutanix uses KVM based hypervisor, which is called AHV (Acropolis
> > Hypervisor).
> >
> > latest AHV release is based on kernel v5.10.117. where we found that
> > Nvidia GPU cards (10/A30/A40 etc) stopped working.
> >
> > Guest VM (based on centos7 or Ubuntu 16.10) were able to identify card
> > but after installing Nvidia Grid driver we were seeing following logs in
> > guest vm.
> >
>
> Have you tested with a more recent version than 5.10.x, to see if the
> bug is still there?
>
> Paolo

