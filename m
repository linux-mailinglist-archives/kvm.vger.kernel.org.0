Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E463E231C65
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgG2KAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 06:00:20 -0400
Received: from elvis.franken.de ([193.175.24.41]:53182 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgG2KAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 06:00:20 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k0isj-0005MI-00; Wed, 29 Jul 2020 12:00:17 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 7939AC0A9B; Wed, 29 Jul 2020 11:52:48 +0200 (CEST)
Date:   Wed, 29 Jul 2020 11:52:48 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
Message-ID: <20200729095248.GA9234@alpha.franken.de>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596005919-29365-2-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> Document loongson64v-4core-virtio, a virtio based kvm guest board for
> Loongson-3.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

hmm, I can't remember adding my signed-off to this patch. Could you
give me a reference for this ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
