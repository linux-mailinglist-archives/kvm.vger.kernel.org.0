Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309354BEAF6
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiBUSvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 13:51:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiBUSsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 13:48:17 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB47669
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:47:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j15so20256824lfe.11
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxPTggMXE/9ErBr+J7gkmHW576ik0hBFFnBWoY47Y7k=;
        b=ZC32iX+BGU0Px1k8N4ZajRIJu/zchkPbz9XC1WwLHX6P+vvMFbS+EieMPDRUmFN6sZ
         W3JFKuWNuPDjv/nuXeut6STSr6YZBaGfeUAbnH/A8lV+/0qTMvVJBolH7Ol8AscPs795
         5pDxeWez+MTlEGqsmuF2SotZbTC8K1kw/HhD1DuOjA8QaAMy98paUKE1XKFAAVbbZ76v
         qx15oIa55ft86S49V920zoOkszyA5Ra2XoYeIWQW6aQ7vNaIfpVLf3d3IgqInlpIOC8h
         rzZ6Sd9aNzRjjb1DaGWiOCGTp6xJgy2AXvF9Ahl0l/Zv+H3oLP13wckMGzQEXC4dMZur
         4JOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxPTggMXE/9ErBr+J7gkmHW576ik0hBFFnBWoY47Y7k=;
        b=KcX8twwe2uzF4FlTdN6CIsVo31MbmGBsq0PKQ7OmlILXm9V9aVXaVgMJ77HDDBYiEF
         uq5+jvJLsqhdywRpjd1/cMk+Xr+ClGq4oObtHvX/IY98b4ny4afUaL9ilKP50pE70ATB
         EkGOrDYG14KLZHFDEr8uPNQ6TxPLTUP8GtvkwiYgV3hyNPlaquCfz+DqUPIV+ySz82qH
         5/rPIqxyFEvpq6CRYyRP9mcUTFkuW06YMxAU3tJwDRWzTuPPePWj9eL71HS8YcDg5C3J
         pCWCMrU/FrIa0KO28tLmpyqngftw6jZP8q1jd/+aQL1cSB/2J9EBh2ySHjMa6sgdY7dw
         kVwg==
X-Gm-Message-State: AOAM5325v5p1fe8VNVecDbrPxT44DDCktRlz0TcU113PENIMvabEOHiw
        5jj4pt4HBtquMomlxtAK3us2l3eRC6zqDWQ3Hrs=
X-Google-Smtp-Source: ABdhPJzH0qaYGMkjyBbIYeU41IKHfNIH0+hTfhzJT77mwHGvGtyUywi9L99JMy20zUkXP4VLiwxdbZz56bGq4cSRqrg=
X-Received: by 2002:a05:6512:548:b0:438:a549:d499 with SMTP id
 h8-20020a056512054800b00438a549d499mr14847377lfl.326.1645469259347; Mon, 21
 Feb 2022 10:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20220220224234.422499-1-zxwang42@gmail.com> <20220221084056.edgpsgqdm2xph4kv@gator>
 <20220221152558.2fwtzrkoq53t66ie@gator>
In-Reply-To: <20220221152558.2fwtzrkoq53t66ie@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 21 Feb 2022 10:47:00 -0800
Message-ID: <CAEDJ5ZSeU4kUoqSz1OvgPtKz9Y3bNE-+iR9nFouKYwWMrt8mqQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86 UEFI: pass envs and args
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de, kraxel@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 7:26 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Feb 21, 2022 at 09:40:56AM +0100, Andrew Jones wrote:
> > On Sun, Feb 20, 2022 at 02:42:31PM -0800, Zixuan Wang wrote:
> > > Hello,
> > >
> > > This patch series enables kvm-unit-tests to get envs and args under
> > > UEFI. The host passes envs and args through files:
> > >
> > > 1. The host stores envs into ENVS.TXT and args into ARGS.TXT
> >
> > EFI already has support for an environment and EFI apps can accept args.
> > Why not find a way to convert kvm-unit-tests ENV and unit tests args
> > into the EFI system and then use that?
> >
> > efi_setup_argv()[*] in my original PoC does that. It uses gnu-efi, but
> > it should be easy to strip away the gnu-efi stuff and go straight for
> > the underlining EFI functions.
> >
> > [*] https://github.com/rhdrjones/kvm-unit-tests/commit/12a49a2e97b457e23af10bb25cd972362b379951#:~:text=static%20void%20efi_setup_argv(EFI_HANDLE%20Image%2C%20EFI_SYSTEM_TABLE%20*SysTab)
> >
> > If you want to mimic efi_setup_argv(), then you'll also need 85baf398
> > ("lib/argv: Allow environ to be primed") from that same branch.

I think one way to implement EFI environment passing is to generate a
startup.nsh which sets the envs. But this could significantly degrade
the bootup speed because UEFI firmware waits 30 seconds for user input
before executing the startup.nsh. This slow bootup causes
./run-tests.sh to run extremely slower (~30mins or even longer), and
motivated us to implement the faster bootup process which does not
rely on the startup.nsh [**].

[**] https://lore.kernel.org/all/20211116204053.220523-10-zxwang42@gmail.com/

> > EFI wrapper scripts for each unit test can be generated to pass the args
> > to the unit test EFI apps automatically. For the environment, the EFI
> > vars can be set as usual for the system. For QEMU, that means creating
> > a VARS.fd and then adding another flash device to the VM to exposes it.

Setting up a .fd file (or an EFI NVRAM if I understand it correctly)
is interesting. Actually, I previously tried it in another way, which
is to set variables from the guest:

1. The host generates and runs a temporary test case that writes envs
and args to EFI NVRAM. This test case uses EFI firmware's
SetVariable() service with NON_VOLATILE | BOOTSERVICE_ACCESS
attributes.
2. The host calls the actual test case which reads the modified NVRAM.

This approach does not work because the guest cannot persist the NVRAM
variables in main(). This is because main() runs after EFI's
ExitBootServices(), and thus cannot set a new non-volatile variable
[***].

I can try it again with some other tricks, e.g., efi_main() creates
the non-volatile variable if not exists, then main() sets the
non-volatile variable.

[***] SetVariable(), Page 241,
https://uefi.org/sites/default/files/resources/UEFI%20Spec%202_6.pdf

> BTW, this tool from Gerd might be useful for that
>
> https://gitlab.com/kraxel/edk2-tests/-/blob/master/tools/vars.py

This script seems to modify the EFI .fd file from the host. I
previously checked several similar scripts but didn't try any.

One thing I was hesitant to modify EFI NVRAM from the host is, it may
introduce more lines of code than the current file-based envs/args
passing. I can try and see if I can simplify the script mentioned
above.

> Thanks,
> drew
>
> >
> > Thanks,
> > drew
> >
> >
> > > 2. The guest boots up and reads data from these files through UEFI file
> > > operation services
> > > 3. The file data is passed to corresponding setup functions
> > >
> > > As a result, several x86 test cases (e.g., kvmclock_test and vmexit)
> > > can now get envs/args from the host [1], thus do not report FAIL when
> > > running ./run-tests.sh.
> > >
> > > An alternative approach for envs/args passing under UEFI is to use
> > > QEMU's -append/-initrd options. However, this approach requires EFI
> > > binaries to be passed through QEMU's -kernel option. While currently,
> > > EFI binaries are loaded from a disk image. Changing this bootup process
> > > may make kvm-unit-tests (under UEFI) unable to run on bare-metal [2].
> > > On the other hand, passing envs/args through files should work on
> > > bare-metal because UEFI's file operation services do not rely on QEMU's
> > > functionalities, thus working on bare-metal.
> > >
> > > The summary of this patch series:
> > >
> > > Patch #1 pulls Linux kernel's UEFI definitions for file operations.
> > >
> > > Patch #2 implements file read functions and envs setup functions.
> > >
> > > Patch #3 implements the args setup functions.
> > >
> > > Best regards,
> > > Zixuan
> > >
> > > [1] https://github.com/TheNetAdmin/KVM-Unit-Tests-dev-fork/issues/8
> > > [2] https://lore.kernel.org/kvm/CAEDJ5ZQLm1rz+0a7MPPz3wMAoeTq2oH9z92sd0ZhCxEjWMkOpg@mail.gmail.com
> > >
> > > Zixuan Wang (3):
> > >   x86 UEFI: pull UEFI definitions for file operations
> > >   x86 UEFI: read envs from file
> > >   x86 UEFI: read args from file
> > >
> > >  lib/efi.c       | 150 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/linux/efi.h |  82 +++++++++++++++++++++++++-
> > >  x86/efi/run     |  36 +++++++++++-
> > >  3 files changed, 265 insertions(+), 3 deletions(-)
> > >
> > > --
> > > 2.35.1
> > >
>

Best regards,
Zixuan
