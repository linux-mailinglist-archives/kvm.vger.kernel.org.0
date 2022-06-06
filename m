Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABF253ECEB
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiFFRTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiFFRSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:18:54 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9672A5130C;
        Mon,  6 Jun 2022 10:17:53 -0700 (PDT)
Received: by mail-il1-f172.google.com with SMTP id d6so1584259ilm.4;
        Mon, 06 Jun 2022 10:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HOgnxEn2ntmtyghL8kOb8yKeTcYGElnyCDEZZ25iRQw=;
        b=4Rh+2Oy1eY+bYftHCMJntZLu8WUck5porKU754FT8zR6Zrc1ge8btPSGostMVvL3OV
         SnatfcmfJPoHw7VIetGqvBuSKTKPotPkorQG4RXog3r5KyneQybFCNA9fqODyOKRq3cu
         JkaTE/OFn4WPIjCWenuUfzjbasK2sDP1uqtUW/40cuMglBuofp7f/Oia3KkhOuYBhBs1
         zDb4DZfYV+MsuQ3edePHr3aP1Esoi6MOLB2QkKXTxM7QsCyoF5MMBvITQaP0EV0aXodl
         RetlcCfUZYhfHhYAog1vp4KXM6Gzb+sf29gK7B1QzTvRWwHn+wWbjU7x264uiR/Kwrn1
         9X9A==
X-Gm-Message-State: AOAM530qDiQ4MgwcvCqSG0y8EZVSl3dzi7fzsuYTm8MTuU14l6VTbLCZ
        6jqA5yTXnzCXGGmZPA2C0A==
X-Google-Smtp-Source: ABdhPJxXRz8rpxHVMQETrBoM9cb8XJJozkw5PJACTm4qK/vhBn8tviwY3PyY58j2eoaPB/u3qpK33w==
X-Received: by 2002:a05:6e02:184f:b0:2d3:d0c2:d56a with SMTP id b15-20020a056e02184f00b002d3d0c2d56amr13953839ilv.174.1654535872910;
        Mon, 06 Jun 2022 10:17:52 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id t17-20020a92c0d1000000b002d3da8e4af5sm6121750ilf.23.2022.06.06.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 10:17:52 -0700 (PDT)
Received: (nullmailer pid 911134 invoked by uid 1000);
        Mon, 06 Jun 2022 17:17:47 -0000
Date:   Mon, 6 Jun 2022 12:17:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Borislav Petkov <bp@alien8.de>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        keyrings@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-cachefs@redhat.com,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mmc@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 00/23] Update Documentation/ cross-references
Message-ID: <20220606171747.GB899329-robh@kernel.org>
References: <cover.1654529011.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654529011.git.mchehab@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 04:25:22PM +0100, Mauro Carvalho Chehab wrote:
> Hi John,
> 
> There were a number of DT binding conversions and other docs change that
> were not updated. Address them, in order to keep the cross-references on
> a sane state.
> 
> Patch series is against v5.19-rc1 (and applies cleanly on the top of
> today's -next).
> 
> Mauro Carvalho Chehab (23):
>   dt-bindings: mfd: bd9571mwv: update rohm,bd9571mwv.yaml reference
>   dt-bindings: interrupt-controller: update brcm,l2-intc.yaml reference
>   dt-bindings: arm: update vexpress-config.yaml references
>   dt-bindings: reset: update st,stih407-powerdown.yaml references
>   dt-bindings: mfd: rk808: update rockchip,rk808.yaml reference
>   dt-bindings: mmc: exynos-dw-mshc: update samsung,pinctrl.yaml
>     reference
>   docs: netdev: update maintainer-netdev.rst reference
>   docs: filesystems: update netfs-api.rst reference
>   Documentation: update watch_queue.rst references
>   Documentation: KVM: update s390-pv.rst reference
>   Documentation: KVM: update amd-memory-encryption.rst references
>   Documentation: KVM: update msr.rst reference
>   Documentation: KVM: update s390-diag.rst reference
>   MAINTAINERS: update arm,hdlcd.yaml reference
>   MAINTAINERS: update arm,komeda.yaml reference
>   MAINTAINERS: update arm,malidp.yaml reference
>   MAINTAINERS: update cortina,gemini-ethernet.yaml reference
>   MAINTAINERS: update dongwoon,dw9807-vcm.yaml reference
>   MAINTAINERS: update maxim,max77693.yaml reference
>   MAINTAINERS: update snps,axs10x-reset.yaml reference
>   objtool: update objtool.txt references
>   ASoC: wm8731: update wlf,wm8731.yaml reference
>   arch: m68k: q40: README: drop references to IDE driver

Applied patches 1-5,17,18,20
