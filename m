Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3322D1D3160
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgENNeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 09:34:13 -0400
Received: from sender3-op-o12.zoho.com.cn ([124.251.121.243]:17728 "EHLO
        sender3-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgENNeN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 09:34:13 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589463221; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=IZ7LZzKqxM8JFB57jl3dBSxz1q9iKXBDVTiuMQ5E4fmfdVg1frTnbnbHUNWWc6c0HWVeBVTGxcF/54UMHo7SwXxXvUsBu8bXMoZ+2snDjJQsnmd3XOolj1B21NhvEDwpwI84wEUXHK8s5/3hbCiqTU4+Qn8pRzhnV7Y2yCsLb9o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589463221; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=DxSxIhjsXQ0oZ+ODruaLcydny7rxZb9pwc9UWDEzvZQ=; 
        b=Dqh6QsttWuDnsLaq5zl19HhKzKM7hX17r/N8+9q/VjdBcdu+HbCf+d2UwfYuT1q1WpsTA4fZm3DIQs9rj/joGJyAiCNO7ER+yiWoYpQDNjI9haX91NGvnI5I00P191zZE8MwhqSkDbRB2rO64Q80Tf1UC5U1zbR9h/ewVpb4tjI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=flygoat.com;
        spf=pass  smtp.mailfrom=jiaxun.yang@flygoat.com;
        dmarc=pass header.from=<jiaxun.yang@flygoat.com> header.from=<jiaxun.yang@flygoat.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589463221;
        s=mail; d=flygoat.com; i=jiaxun.yang@flygoat.com;
        h=Date:From:To:CC:Subject:Reply-to:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=DxSxIhjsXQ0oZ+ODruaLcydny7rxZb9pwc9UWDEzvZQ=;
        b=KeOcFB+xOeUH7Rs0FarxMQ6hYt6CXr+lg1ZM+LDeFU/f0e1ic147z0dZo0OR91Y7
        9F2O7uB/n3I68VvIXyvyWH9iQre/gcrTiBKnU30Tw4jRibVMeoEMw7qM9IJBSb1Z5ei
        3FVdQohkVittcroSrdgl8Prlsf+ikfQK/Soc6ypY=
Received: from [127.0.0.1] (114.85.159.159 [114.85.159.159]) by mx.zoho.com.cn
        with SMTPS id 1589463218310310.59631609983194; Thu, 14 May 2020 21:33:38 +0800 (CST)
Date:   Thu, 14 May 2020 21:33:35 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
CC:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
User-Agent: K-9 Mail for Android
Reply-to: jiaxun.yang@flygoat.com
In-Reply-To: <1589359366-1669-16-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com> <1589359366-1669-16-git-send-email-chenhc@lemote.com>
Message-ID: <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



=E4=BA=8E 2020=E5=B9=B45=E6=9C=8813=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=884=
:42:46, Huacai Chen <chenhc@lemote=2Ecom> =E5=86=99=E5=88=B0:
>James Hogan has become inactive for a long time and leaves KVM for MIPS
>orphan=2E I'm working on KVM/Loongson and attempt to make it upstream bot=
h
>in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
>QEMU/MIPS=2E We are both interested in QEMU/KVM/MIPS, and we have already
>made some contributions in kernel and QEMU=2E If possible, we want to tak=
e
>the KVM/MIPS maintainership=2E
>
>Signed-off-by: Huacai Chen <chenhc@lemote=2Ecom>
>---

Reviewed-by: Jiaxun Yang <jiaxun=2Eyang@flygoat=2Ecom>

Huacai is extremely experienced on virtualization,
his PhD thesis is about virtualization too=2E
He had been working on Loongson kernel for a long period=2E

Alexander maintained QEMU/MIPS for some years, he is a expert on
QEMU and MIPS architecture=2E

I believe these guys can effectively bring MIPS/KVM support back to sea le=
vel again=2E

Best wishes!
--=20
Jiaxun Yang
