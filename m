Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816B66A7D77
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 10:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCBJS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 04:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCBJSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 04:18:25 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416D5DBE2
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 01:18:24 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso1009183wms.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 01:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677748702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+v85GLUDrQ2zVLBvlWtS8ia1HQWcVPpr7GzHsjdX2Jw=;
        b=MswMY0eyIVOvB1BGlIsjT7T7ZB+Coenk8J9ktojT2m4Q1VRDdt++rgRUovNUXlnJ8+
         0n9yemw+T01QZcvWjHA+IRLf1JeQT4kgvMDTRAYyxhxbxVWsHDg9iQgAYLNOQNwzA9OF
         sDZz74KhVDusvK5O1ZzeFkSdIarEHU0F40BXnkkl9lMTBvYQ5MhVKpY3D2OmLJcBkAEy
         KcO16Kf5TQjdh+qmv8d3ljlMfUjsN/SwOUJhPHytWIHGEv2W78sjXEO3RFhRyQIfEBHP
         PMv71bBDjxuLO7cV0gbppJac2jsSFYaYorLS8teQTqi/lzN5ml/LLJzfs4CWnvoIVFYD
         TWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677748703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+v85GLUDrQ2zVLBvlWtS8ia1HQWcVPpr7GzHsjdX2Jw=;
        b=aVO1K8yopcdeWgxblg2FQWcvkqzw1YkycUZ3fM4+a6NRXL8hxYJVWrFWY0N3ltG4ol
         RW3h+cg9s3iLI0dfZ4m6UTJUb8KhkBrvf/QH1wKnGSt3sOrH9/zVWh9t+NfKVMw5Ny8w
         lhzow0dr+o2duvsGyZsHAbg5Z1afXQRxSbs+C/Lm4z3EVVlJqDrbuUMk43ffUgLyPpwr
         LQVx8ewYmxyyFmLG0kDslLrRQUhDzTDvWkUT23oo8JgtJz9t1t61p3zeaLx2evoVNYW1
         tBfRpu0two1+Q1bHBPrtaLgkOGm/Mxpk5km6QXxQ/CZ/NovRKwE97lKlDYuhtUmRjtya
         RH5w==
X-Gm-Message-State: AO0yUKUvYOAinmAno8aQfJ4Crx7WFD8w/bnRQtXpi3jahEl3i2gNi8ET
        ccX2d8Aj6bagp9tF+mOK+bjPrg==
X-Google-Smtp-Source: AK7set+YPw1lyaEwaI48fxgT8GolHPnYxo9XVJyK/m4+bNoNPlN8Bml3v5HR6wybgri48X3tq2AU1w==
X-Received: by 2002:a05:600c:3d8e:b0:3ea:bc08:b55e with SMTP id bi14-20020a05600c3d8e00b003eabc08b55emr6973744wmb.25.1677748702713;
        Thu, 02 Mar 2023 01:18:22 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b002c54536c662sm14745006wrn.34.2023.03.02.01.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:18:22 -0800 (PST)
Date:   Thu, 2 Mar 2023 09:18:24 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Itaru Kitayama <itaru.kitayama@gmail.com>
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
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <ZABp4KhrhsHcKmh2@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> On Wed, Mar 1, 2023 at 6:20 PM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > Hi Itaru,
> >
> > On Wed, Mar 01, 2023 at 08:35:05AM +0900, Itaru Kitayama wrote:
> > > Hi Jean,
> > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > emits an Invalid argument error and terminates.
> >
> > Do you know which call returns this error?  Normally the RMEGuest support
> > should print more detailed errors. Are you able to launch normal guests
> > (without the rme-guest object and confidential-guest-support machine
> > parameter)?  Could you give the complete QEMU command-line?
> 
> No, I cant say which. Yes, the CCA-capable QEMU boots if I don't set
> RME-related options.
> 
> Here's mine (based upon your command-line):
> qemu-system-aarch64 -cpu host -accel kvm -machine
> virt,gic-version=3,confidential-guest-support=rme0 -smp 2 -m 256M
> -nographic -object rme-guest,id=rme0,measurement-algo=sha512 -kernel
> Image -initrd rootfs.ext2 -append 'console=ttyAMA0 earlycon'
> -overcommit mem-lock=on

Thank you, this works on my setup so I'm not sure what's wrong. Check that
KVM initialized successfully, with this in the host kernel log:
"[    0.267019] kvm [1]: Using prototype RMM support (version 56.0)"

Next step would be to find out where the EINVAL comes from, with printfs
or GDB. This seems rather specific so I'll email you directly to avoid
filling up everyone's inbox.

Thanks,
Jean
