Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BCE5ACAA
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 19:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfF2RJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jun 2019 13:09:46 -0400
Received: from mout.web.de ([212.227.17.12]:56611 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbfF2RJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jun 2019 13:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561828180;
        bh=4g8o7N9kO6/TudrbsrFQpqNziwZxgieXoxJSedctBCI=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=sfNEpmNBMoIX/K+Uisxi3Ya/l+My1swXKylpdMbrq35CkiWG/f5oVsqZnCSTmf7BQ
         AXLXIfUthpTsrjyFbrLY/3gIEzepLMaJguZsL/whXWNBVJzcjqT8PMTIsn8MD/tmE2
         IP5eo2g/KA9AeL6i+UmZyNYYEtFBmVbhzz52Z/fs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LilNJ-1iH9RO2mSL-00cvOE; Sat, 29
 Jun 2019 19:09:39 +0200
To:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: KVM works on RPi4
Message-ID: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
Date:   Sat, 29 Jun 2019 19:09:37 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lJD3HwWiZIS+ktns/En0V1mv1r5HAF8MxcHtk5MRNm8fyWiwNx2
 AAJ53ExrLi73373hHIUUxkiK8V9+/XHf+OmbIfejE4tvuQ5+ow8PLoiqYF86E5rETuFsdpy
 UVzLU+5wXGoAuJmxfWHebctALWafJy7T246ZR9OdeL60ZnqocmAYqXzfSGamSWdkGo5d8On
 M+Q8o6k73zOrp1MxTqvfg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:N1G+NOT5bLE=:Uu0c0qqlJCTJ3qaS0/fxEg
 FMSSZfijxJ8IP0xIjG69+/FoGbBPHVeWBgGpqKm+MqruY1oWDjFxT3VqFWSZvuPV8jfWcW0Vq
 HaKF0qn528u0ApAF5Kim5YqnUyMhvSHEi4q3UuzvrSzuPnMCfzQh8k2bVCnjXJC1hoiihPvdI
 HDSBdHsk1fP11xuTWx9o6gctW5cNKvPF1L4/EX4TduTHQvQtaidIRKZYOxDpx+GEGlhETo++v
 LKtzjz+m6uSv6nrhxLT6+GHH68Pgs2JhCRmYRne5BU8u6k/9+TvyGAnexoG8+p3nnfP72l1qj
 rnV2pFX4xMd+GY3gNUeU2pS1WQz1tUFz3X7nnfvueBEVacbo8LXBHgkPVxDTOkgd+C7phfAXF
 oTwdhCAOf/VsPaVQ6YYOjvCtrxk2Tjd02LaevOTwDi/SoSyFwcon6K2ZbXUnNcLF7k4NvpkFI
 dvusxL+I5OGkzt9iXrJy9cSqVxJglwvVgQIDoeUcwYeMS5BE//8gKkPCYUarn0v0V3MSHIQWE
 ZhYH8oDXVR5rcs5RlsMKFCH6lnhqmKeOynJakjNrWgpiCpqhX/LrAYcXyYh39CUn99kY0RHW6
 RHi5EwmZZiy6v5LVhMqPeFtqns5opVKmoTWwdk4ej0LLXYKM53PpjG6fHbF8dnHb4J1Aj6hRE
 iVuneiPnyXRYKh6uaO6oBfbzyM9otpTTMlly+3jz/GP38VMOikJvSbPdiTG6pLBIu5Q8j2UzF
 AJXd+9CN3ClsLwncpmNDAIbV2eidYyOfCqofzBcSlvo2ohsgi8kP2TBiseqKWmPEXQFNDeqit
 pzmyT88zqj90Rs6TNLYBFop2C5oqQB4xIiCaxDj6r7V0EGBIBD2Rndmfxg0Me0akRj+TKhwVR
 zkxgdQ3PVf8lCbZBjggvM9afVoPg5pjLEOJ10uv6EQUUHDjFqDxylpFhnCS/UoNVHsLfbO0U4
 eKMBARa7w4V4UIl5G7vUT52pnXhZnGOb9YvhQqOGCbe+2B28lAlfFoWcAXZl0wy8B3yFkw6Rz
 kzQN0Ah81whB5uwL0l2GoPVsXNzIdaqgbZNfzi8XDhGhwxC/rxWad8uY5hzG+1n3GDt4MpDn7
 2DALFF0IlGyjsG7cMTOHFuFtLsNeod87G2F
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

just got KVM running on the Raspberry Pi4. Seems they now embedded all
required logic into that new SoC.

However, as the Raspberry kernel is not yet ready for 64-bit (and
upstream is not in sight), I had to use legacy 32-bit mode. And there we
stumble over the core detection. This little patch made it work, though:

diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 2b8de885b2bf..01606aad73cc 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
 	case ARM_CPU_PART_CORTEX_A7:
 		return KVM_ARM_TARGET_CORTEX_A7;
 	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_CORTEX_A72:
 		return KVM_ARM_TARGET_CORTEX_A15;
 	default:
 		return -EINVAL;

That raises the question if this is hack or a valid change and if there
is general interest in mapping 64-bit cores on 32-bit if they happen to
run in 32-bit mode.

Jan

PS: The RPi device tree lacks description of the GICH maintenance
interrupts. Seems KVM is fine without that - because it has the
information hard-coded or because it can live without that interrupt?
