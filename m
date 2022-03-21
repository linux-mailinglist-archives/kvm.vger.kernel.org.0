Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF054E3379
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiCUWxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiCUWwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:52:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981E83C7CC9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:40:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so704574pjb.4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2bnfXbBF+GtABV7TekdcS8ywNlhlzjjtfwzNNUAvbZU=;
        b=YhQl6a0dmNzIoS/RJf/U72upVEm129lZRy+fpmrRDWlj2gC8kVoCCiHOd7F+Qn8w0c
         t317CBAL13gk3J/sEwp3XNVf/QMVST0JJIol+7dwwF1CEWjK74P+QguUpCICkZAoIBJT
         EOYh4d0IkyNf6lJu/IOZYQgr+37wq6EUoyZ75NtBpWWhz+mTD/NUX4YMJ0n8nrqx5zPM
         ZQr5YS3raBcA4r9aFcrUzsRotxCj0PlJXgTbrbcoWEEL0+uqcIUtRAuoLmr7W6vo2imG
         UNgCIYcWgt8dryUF/gRgqQkutzAg6kBVhU5vd/TSsCErCSuLD2q2kuGOjVB/sq0IfX+h
         DLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2bnfXbBF+GtABV7TekdcS8ywNlhlzjjtfwzNNUAvbZU=;
        b=VyuvqbPtZpgppnpwuM+Fbj1QqZYppuyuRGwHA+MuF3DDEj6juqnnVZ90avunIG8VSp
         Iu5v9CFEd0+kTnSDTllbdeHhYiPgQ+J2Br5RFlbAhNZiCck7l9DRPCH8rDxQA0H2Gg/f
         QiMKvUl4PIpSOQEiey8D9ADXTC1syWTsp++uMqRH26st60NuLDaih06NHkFEsl68i9no
         K04/ahFBbHgG2QdLxs4Y6FkGczh/pGRxkMHqiey/Qxg1aBPXZaUI7FsbzrXP7EFanpHV
         YjO1WCJUabC7VR2Z+pDEiy/nHGy0yxP1pQOmAhb1WQsDgsIjt1HKvofX/tgqQ99N/H8Z
         MmOQ==
X-Gm-Message-State: AOAM533Ik9wy8jZQLuyHkewzqi3y5qQAT50P9ZJHlimUMcNTGmDST07B
        q9c+6u1GaOui+6ikeSVvQbONOlxleuQ=
X-Google-Smtp-Source: ABdhPJziEg0hHHZvKpi0xSAoMLh2Nnte4eWxjp0cNaoW2ym1Y2QGelYCN+v4wvy9wRuu4urkFcdLnA==
X-Received: by 2002:a17:903:22ca:b0:154:5625:e0 with SMTP id y10-20020a17090322ca00b00154562500e0mr7564482plg.15.1647900405473;
        Mon, 21 Mar 2022 15:06:45 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u126-20020a637984000000b0038147b4f53esm15129971pgc.93.2022.03.21.15.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:06:45 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:06:43 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Philippe Mathieu-Daud??? <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Message-ID: <20220321220643.GA76113@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 04:54:51PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/18/2022 10:07 PM, Philippe Mathieu-Daudé wrote:
> > Hi,
> > 
> > On 17/3/22 14:58, Xiaoyao Li wrote:
> > > TDX VM needs to boot with Trust Domain Virtual Firmware (TDVF). Unlike
> > > that OVMF is mapped as rom device, TDVF needs to be mapped as private
> > > memory. This is because TDX architecture doesn't provide read-only
> > > capability for VMM, and it doesn't support instruction emulation due
> > > to guest memory and registers are not accessible for VMM.
> > > 
> > > On the other hand, OVMF can work as TDVF, which is usually configured
> > > as pflash device in QEMU. To keep the same usage (QEMU parameter),
> > > introduce ram_mode to pflash for TDVF. When it's creating a TDX VM,
> > > ram_mode will be enabled automatically that map the firmware as RAM.
> > > 
> > > Note, this implies two things:
> > > ?? 1. TDVF (OVMF) is not read-only (write-protected).
> > > 
> > > ?? 2. It doesn't support non-volatile UEFI variables as what pflash
> > > ???????? supports that the change to non-volatile UEFI variables won't get
> > > ???????? synced back to backend vars.fd file.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > > ?? hw/block/pflash_cfi01.c | 25 ++++++++++++++++++-------
> > > ?? hw/i386/pc_sysfw.c?????????? | 14 +++++++++++---
> > > ?? 2 files changed, 29 insertions(+), 10 deletions(-)
> > 
> > If you don't need a pflash device, don't use it: simply map your nvram
> > region as ram in your machine. No need to clutter the pflash model like
> > that.
> 
> I know it's dirty to hack the pflash device. The purpose is to make the user
> interface unchanged that people can still use
> 
> 	-drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd
>         -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd
> 
> to create TD guest.

For the compatibility for qemu command line, you don't have to modify pflash
device.  Don't instantiate pflash at pc_system_flash_create(), and at
pc_system_firmware_init(), you can retrieve necessary parameters, and then
populate memory.  Although it's still hacky, it would be cleaner a bit.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
