Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6531DB0D5
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 13:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETK7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 06:59:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59787 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgETK7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 06:59:54 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49RqX81vz0z9sT3; Wed, 20 May 2020 20:59:52 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Paul Mackerras <paulus@samba.org>
Cc:     dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
References: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/5] drivers/powerpc: Replace _ALIGN_UP() by ALIGN()
Message-Id: <158997212813.943180.8258248178215435632.b4-ty@ellerman.id.au>
Date:   Wed, 20 May 2020 20:59:52 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Apr 2020 18:36:34 +0000 (UTC), Christophe Leroy wrote:
> _ALIGN_UP() is specific to powerpc
> ALIGN() is generic and does the same
> 
> Replace _ALIGN_UP() by ALIGN()

Applied to powerpc/next.

[1/5] drivers/powerpc: Replace _ALIGN_UP() by ALIGN()
      https://git.kernel.org/powerpc/c/7bfc3c84cbf5167d943cff9b3d2619dab0b7894c
[2/5] powerpc: Replace _ALIGN_DOWN() by ALIGN_DOWN()
      https://git.kernel.org/powerpc/c/e96d904ede6756641563d27daa746875b478a6c8
[3/5] powerpc: Replace _ALIGN_UP() by ALIGN()
      https://git.kernel.org/powerpc/c/b711531641038f3ff3723914f3d5ba79848d347e
[4/5] powerpc: Replace _ALIGN() by ALIGN()
      https://git.kernel.org/powerpc/c/d3f3d3bf76cfb04e73436a15e3987d3573e7523a
[5/5] powerpc: Remove _ALIGN_UP(), _ALIGN_DOWN() and _ALIGN()
      https://git.kernel.org/powerpc/c/4cdb2da654033d76e1b1cb4ac427d9193dce816b

cheers
