Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD85400E3
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245217AbiFGOLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245197AbiFGOLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:11:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F18DA501E;
        Tue,  7 Jun 2022 07:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81C26157B;
        Tue,  7 Jun 2022 14:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A53C385A5;
        Tue,  7 Jun 2022 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654611104;
        bh=letTzTlIdmYyCQr3t4i/4sQ++BrVupVi397GE8M9uvI=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ZmrXJqh5VhK6LBrkWuZLcZPb6LB/aKqB7VgbxKHQ5EKdRZGn1B/UtUl37J/VZlncM
         XaKVqUs9/CrLhurHZmfQE4ZHromAzF5QHFhfcePHGAZt6gJN4oXn1Jgu9OhytNBGsZ
         Dpp8c39jiY4Y6vji5iZNzY0BkjvDT9oCjsHIgHSItTWWl1ZaFW8x1MWtKzh54+Jsmx
         MgLY2ScRWCz28NxqLMnfdu2v0uWPvoMrX/y8LVhRzTo8e9BmO+8kP0GacNDIRYfLCx
         +YjXzNg0JjEvKZfsqCZP5oIjyElXDN9wiUZpKQTLYg3m4X5qyHVoxoSHYehWp506BX
         a+HtETwbE/zkg==
From:   Mark Brown <broonie@kernel.org>
To:     linux-doc@vger.kernel.org, corbet@lwn.net, mchehab@kernel.org
Cc:     linux@roeck-us.net, linux-cachefs@redhat.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, linux-samsung-soc@vger.kernel.org,
        geert@linux-m68k.org, ulf.hansson@linaro.org, hpa@zytor.com,
        alsa-devel@alsa-project.org, linux-m68k@lists.linux-m68k.org,
        krzysztof.kozlowski+dt@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        mingo@redhat.com, mchehab+huawei@kernel.org, jdelvare@suse.com,
        robh+dt@kernel.org, linux-gpio@vger.kernel.org, rafael@kernel.org,
        linux-mmc@vger.kernel.org, federico.vaga@vaga.pv.it, bp@alien8.de,
        linux-phy@lists.infradead.org, mmayer@broadcom.com,
        keyrings@vger.kernel.org, x86@kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alim.akhtar@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org,
        jarkko@kernel.org, tglx@linutronix.de, linus.walleij@linaro.org
In-Reply-To: <cover.1654529011.git.mchehab@kernel.org>
References: <cover.1654529011.git.mchehab@kernel.org>
Subject: Re: (subset) [PATCH 00/23] Update Documentation/ cross-references
Message-Id: <165461109692.1597191.11390741473240531333.b4-ty@kernel.org>
Date:   Tue, 07 Jun 2022 15:11:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

On Mon, 6 Jun 2022 16:25:22 +0100, Mauro Carvalho Chehab wrote:
> There were a number of DT binding conversions and other docs change that
> were not updated. Address them, in order to keep the cross-references on
> a sane state.
> 
> Patch series is against v5.19-rc1 (and applies cleanly on the top of
> today's -next).
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[22/23] ASoC: wm8731: update wlf,wm8731.yaml reference
        commit: 69c8027c5ff43d68449fda4510a8cce70e8578b0

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
