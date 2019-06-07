Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1360E39312
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfFGRY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:24:56 -0400
Received: from ms.lwn.net ([45.79.88.28]:57788 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbfFGRY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:24:56 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 1E5787DA;
        Fri,  7 Jun 2019 17:24:56 +0000 (UTC)
Date:   Fri, 7 Jun 2019 11:24:54 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jiri Kosina <trivial@kernel.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] KVM: arm/arm64: Always capitalize ITS
Message-ID: <20190607112454.645fa470@lwn.net>
In-Reply-To: <20190607112951.14418-1-geert+renesas@glider.be>
References: <20190607112951.14418-1-geert+renesas@glider.be>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Jun 2019 13:29:51 +0200
Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> All but one reference is capitalized.  Fix the remaining one.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> index 4f0c9fc403656d29..eeaa95b893a89b7a 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> @@ -103,7 +103,7 @@ Groups:
>  The following ordering must be followed when restoring the GIC and the ITS:
>  a) restore all guest memory and create vcpus
>  b) restore all redistributors
> -c) provide the its base address
> +c) provide the ITS base address
>     (KVM_DEV_ARM_VGIC_GRP_ADDR)
>  d) restore the ITS in the following order:
>     1. Restore GITS_CBASER

Applied, thanks.

jon
