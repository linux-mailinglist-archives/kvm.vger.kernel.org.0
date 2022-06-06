Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FFA53E889
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiFFP0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbiFFPZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 11:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BADE1CD350;
        Mon,  6 Jun 2022 08:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A6761532;
        Mon,  6 Jun 2022 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9A7C341DE;
        Mon,  6 Jun 2022 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529149;
        bh=JJt0IO+HD16nKaMzBkekejjxzH6zJTBr5QCuFRGczGE=;
        h=From:To:Cc:Subject:Date:From;
        b=FQvjxVAjYkRkMlnXeUbGK/ffXS9EGiIGJB6czmy41m7BUi+gGlw+X1Vu+xVWhr8kL
         VZmd7RutDKDJkQ6+PNC2k4EBuWcMiwehnWLeUgcaztEFymFfTpyADom9iKEZ2r0U6R
         8QTKxcO8tqR2nN17KQ7uaYrNw3fG0aG82GOK9/YW0npuVqsyv4lNhNtBEPuUTmVVIT
         XOE4wPosVqLjYqBNBMuGPxA5PXF0QCAYswfnxGdyJu5zTk6VkYY/y8ZNnVzT895FLj
         P6YX/uUQeJAT8yJ01In++Ksk7XfTNpL0aA6OZ6qjgQfLIhLB4De2E2AivHQOnNJprR
         rbUcjc+xUJibQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nyEby-0012On-0x;
        Mon, 06 Jun 2022 16:25:46 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH 00/23] Update Documentation/ cross-references
Date:   Mon,  6 Jun 2022 16:25:22 +0100
Message-Id: <cover.1654529011.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi John,

There were a number of DT binding conversions and other docs change that
were not updated. Address them, in order to keep the cross-references on
a sane state.

Patch series is against v5.19-rc1 (and applies cleanly on the top of
today's -next).

Mauro Carvalho Chehab (23):
  dt-bindings: mfd: bd9571mwv: update rohm,bd9571mwv.yaml reference
  dt-bindings: interrupt-controller: update brcm,l2-intc.yaml reference
  dt-bindings: arm: update vexpress-config.yaml references
  dt-bindings: reset: update st,stih407-powerdown.yaml references
  dt-bindings: mfd: rk808: update rockchip,rk808.yaml reference
  dt-bindings: mmc: exynos-dw-mshc: update samsung,pinctrl.yaml
    reference
  docs: netdev: update maintainer-netdev.rst reference
  docs: filesystems: update netfs-api.rst reference
  Documentation: update watch_queue.rst references
  Documentation: KVM: update s390-pv.rst reference
  Documentation: KVM: update amd-memory-encryption.rst references
  Documentation: KVM: update msr.rst reference
  Documentation: KVM: update s390-diag.rst reference
  MAINTAINERS: update arm,hdlcd.yaml reference
  MAINTAINERS: update arm,komeda.yaml reference
  MAINTAINERS: update arm,malidp.yaml reference
  MAINTAINERS: update cortina,gemini-ethernet.yaml reference
  MAINTAINERS: update dongwoon,dw9807-vcm.yaml reference
  MAINTAINERS: update maxim,max77693.yaml reference
  MAINTAINERS: update snps,axs10x-reset.yaml reference
  objtool: update objtool.txt references
  ASoC: wm8731: update wlf,wm8731.yaml reference
  arch: m68k: q40: README: drop references to IDE driver

 .../ABI/testing/sysfs-driver-bd9571mwv-regulator   |  2 +-
 Documentation/admin-guide/kernel-parameters.txt    |  2 +-
 .../bindings/cpufreq/brcm,stb-avs-cpu-freq.txt     |  2 +-
 .../devicetree/bindings/hwmon/vexpress.txt         |  2 +-
 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     |  2 +-
 .../devicetree/bindings/phy/phy-stih407-usb.txt    |  2 +-
 .../devicetree/bindings/pinctrl/pinctrl-rk805.txt  |  2 +-
 .../devicetree/bindings/regulator/vexpress.txt     |  2 +-
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |  2 +-
 Documentation/devicetree/bindings/usb/dwc3-st.txt  |  2 +-
 Documentation/devicetree/bindings/usb/ehci-st.txt  |  2 +-
 Documentation/devicetree/bindings/usb/ohci-st.txt  |  2 +-
 Documentation/security/keys/core.rst               |  2 +-
 Documentation/security/secrets/coco.rst            |  2 +-
 .../translations/it_IT/networking/netdev-FAQ.rst   |  2 +-
 Documentation/virt/kvm/api.rst                     |  4 ++--
 Documentation/virt/kvm/s390/s390-pv-boot.rst       |  2 +-
 Documentation/virt/kvm/x86/hypercalls.rst          |  2 +-
 Documentation/x86/orc-unwinder.rst                 |  2 +-
 MAINTAINERS                                        | 14 +++++++-------
 arch/m68k/q40/README                               |  4 +---
 include/linux/fscache.h                            |  2 +-
 include/linux/objtool.h                            |  2 +-
 include/linux/watch_queue.h                        |  2 +-
 init/Kconfig                                       |  2 +-
 kernel/watch_queue.c                               |  2 +-
 lib/Kconfig.debug                                  |  2 +-
 tools/include/linux/objtool.h                      |  2 +-
 tools/objtool/check.c                              |  2 +-
 29 files changed, 36 insertions(+), 38 deletions(-)

-- 
2.36.1


