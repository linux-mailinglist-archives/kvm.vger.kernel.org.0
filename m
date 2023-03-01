Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405FB6A76A7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 23:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCAWMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 17:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCAWMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 17:12:37 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB1F4DBC1;
        Wed,  1 Mar 2023 14:12:36 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id y19so8669277pgk.5;
        Wed, 01 Mar 2023 14:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pfazAaB1krD03qoiIwUHuiCesj2DfTyBcU1GYneJYWY=;
        b=eg3rRwZ9NRqc4NZ7mn+d958skdQTsR4DJymp6pXMjdMC+F8Cv5+HJ4h1h31TbHYrsf
         xkQidejdXlTtUsLE4NorgMScT8UMYVTDEOrbXNiHh//bvLbt1DdI9scp0WftBOUfaOL9
         X3GOlkZy4ukLdzwwqP9uaskWDAJ+K6nyala8LjPvtDQbDW0vF6DJYfBp5vnWdk5UTjtB
         SYy9aeG2Xa1fiux0memPdeXSo97rZ3zxByZxeAp3fQHQzLEPsxndaS1s3qjMYWKZQVyw
         cc0fjA/1jbDMsCuxijqVJMRK0tdroOTJmXWbGddzEM5Icc0EoyaRUq6iu+JtTAAY76bv
         E+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfazAaB1krD03qoiIwUHuiCesj2DfTyBcU1GYneJYWY=;
        b=Xu2no8CRQmr4smKbF1XctW7nC/bxugqxjAWqjk7euC8Z+H9+qRmP5MyJGC1vxdM+nW
         8D7qmvzVjd4z/GL7zZ929Opw8gy6pq8/OsTAD1/3vccowjJ93j3X4KGc4RR30vBSx6VI
         l+/EXV61ZiCMb8s4AN3HZ83CcxDP4efkabOa3GfJU8tsnRhwbAFLJFzQXYR+GAi+YTME
         riC5V0DfJy5pxc5xZOMBA35D/zhOM5JJU0UeGNSbe8SZs0r5pf8jap+SS7nCK9BIDgdO
         m1DwStjVMv8OPFFm+CavszUya2JQS4YxXC9Y68EKO/dRWvZSPcIq1fey/obCApdaAghH
         cykw==
X-Gm-Message-State: AO0yUKUyCO/Pbjj9Zx0bW5BiGIfKsAWxbU/b8nb80I7YZoY2zWjd5t9/
        yHaAsSK3fc1Uci8zjVkKEK3mW515XQ+LLh2Ggtk=
X-Google-Smtp-Source: AK7set/xZsX7wuPd5hcssb22bozalTDdT87153QVXXZsO8821SKx1dgPeG8UYV84t8ORVw6spES6bxVcdlLRGQt0+8c=
X-Received: by 2002:a63:7d57:0:b0:4fc:2369:811 with SMTP id
 m23-20020a637d57000000b004fc23690811mr2685207pgn.6.1677708755473; Wed, 01 Mar
 2023 14:12:35 -0800 (PST)
MIME-Version: 1.0
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica> <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
In-Reply-To: <Y/8Y3WLmiw6+Z5AS@myrica>
From:   Itaru Kitayama <itaru.kitayama@gmail.com>
Date:   Thu, 2 Mar 2023 07:12:24 +0900
Message-ID: <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 1, 2023 at 6:20 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Hi Itaru,
>
> On Wed, Mar 01, 2023 at 08:35:05AM +0900, Itaru Kitayama wrote:
> > Hi Jean,
> > I've tried your series in Real on CCA Host, but the KVM arch init
> > emits an Invalid argument error and terminates.
>
> Do you know which call returns this error?  Normally the RMEGuest support
> should print more detailed errors. Are you able to launch normal guests
> (without the rme-guest object and confidential-guest-support machine
> parameter)?  Could you give the complete QEMU command-line?

No, I cant say which. Yes, the CCA-capable QEMU boots if I don't set
RME-related options.

Here's mine (based upon your command-line):
qemu-system-aarch64 -cpu host -accel kvm -machine
virt,gic-version=3,confidential-guest-support=rme0 -smp 2 -m 256M
-nographic -object rme-guest,id=rme0,measurement-algo=sha512 -kernel
Image -initrd rootfs.ext2 -append 'console=ttyAMA0 earlycon'
-overcommit mem-lock=on

Itaru.
>
> > I configure it with the aarch64-softmmu target only and built, any
> > other steps I should worry?
>
> No, that should be enough
>
> Thanks,
> Jean
