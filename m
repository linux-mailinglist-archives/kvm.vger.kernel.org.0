Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EB3FC9E7
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNP1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:27:39 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43374 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfKNP1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:27:38 -0500
Received: by mail-ot1-f67.google.com with SMTP id l14so5160031oti.10
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 07:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VeY2MOcdaw6r8Ha9Eh1pv27RGxet0wBjyhB8nwJtLCk=;
        b=E9N2cNleSycQiDuGwZ+D654dUj+mEaTT0Od4euVyQpoOBSULhMe0pOdzpWK59wPvli
         51UPfgDM/E6mfWUBs6ODMQGUiPxrUmztDY7i3xxthKvaSDh4D+3diA+0m5MZ4jo0lIut
         fO1pAxw5E6moagkNWVB+eMUpGn3ElVVRMfER30Mch4axBfTda+uUy1vVSG5nNierNRri
         ZTbcPm9spj2XanM2IM0hV7UFs72Ikxcl9eUMkRZX15oDIlbdCYBobYJUhT38may1hpkS
         4YifZWRxZRTa6gbyfuMrTewbdi6HbtBZYo0gebulIbOiUh+EJaeCAjCRUj50kAfiv8WV
         xz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VeY2MOcdaw6r8Ha9Eh1pv27RGxet0wBjyhB8nwJtLCk=;
        b=L5bk1kKh/087fT0QoSv9xAFiaSX2QBv4G/x8P2TZf6RAPblf+Okhrs0BcUTDD8J2IA
         ub5tYkli9Ulzdw1DHXlqv+X06/BdX5qLD9OT/krLoBqL4cTprAlCKSTLUVW6TRDd3wy8
         gH21MWMyO8gmOP0NewPu40Z5QTELrJxNKl3TQCaM+in1Mdq8i7AdkxhxF0zRHjpfRi+n
         cqTK4TcDmmZPgU5xCRcWjE03SjvGbsswpiJZuwUsnIBdi+EWt5nIf258wIFQtCq/HBB8
         v7pLuaVwxpcV/lNYbXjrrU6XQoYBzgzDglYBzahxkYgTw3WjnIaJkb7CoKx8/KL6o2n3
         5Izw==
X-Gm-Message-State: APjAAAWvFSr/gGI+63yK6LyQ8FNSGpr2e8/e66RvuR8TYZqks2ryqyYI
        35nWEIrQbBzgrtRQ/boeNaQAyWEsCGkBZgtPyUsdiNlhGow=
X-Google-Smtp-Source: APXvYqz6c/gHgYRtpNX09mwAgZqZcQnoq6B/kPCnPlGTV64hqbThdZMLMuxrXe0XfBKKQS1wp0ZTLQ/eHN/071eq9Zk=
X-Received: by 2002:a9d:7f12:: with SMTP id j18mr7112499otq.221.1573745256587;
 Thu, 14 Nov 2019 07:27:36 -0800 (PST)
MIME-Version: 1.0
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com> <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com> <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
 <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com> <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
In-Reply-To: <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 14 Nov 2019 15:27:25 +0000
Message-ID: <CAFEAcA_kcQwrnJxtCynX9+hMEvnFN0yBnim_Kn-uut5P4fshew@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping GICD_CTLR.DS
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 at 15:21, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> TCG emulates a GIC with a single security state for me:
>
> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=3,accel=tcg
> -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd
> -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> arm/gic.flat -append irq

The virt board doesn't do EL3 by default, but if you add -machine secure=true
to your command line then it it should emulate it, including a
trustzone-aware GIC.

thanks
-- PMM
