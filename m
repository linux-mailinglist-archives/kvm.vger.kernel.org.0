Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825D2222365
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 15:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgGPNDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 09:03:11 -0400
Received: from elvis.franken.de ([193.175.24.41]:38446 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgGPNDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 09:03:10 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jw3XT-0001Iu-00; Thu, 16 Jul 2020 15:03:03 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 42D36C0813; Thu, 16 Jul 2020 14:59:28 +0200 (CEST)
Date:   Thu, 16 Jul 2020 14:59:28 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] MIPS: Retire kvm paravirt
Message-ID: <20200716125928.GA12483@alpha.franken.de>
References: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
 <20200710063047.154611-2-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710063047.154611-2-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 02:30:16PM +0800, Jiaxun Yang wrote:
> paravirt machine was introduced for Cavium's partial virtualization
> technology, however, it's host side support and QEMU support never
> landed in upstream.
> 
> As Cavium was acquired by Marvel and they have no intention to maintain
> their MIPS product line, also paravirt is unlikely to be utilized by
> community users, it's time to retire it if nobody steps in to maintain
> it.

I've fine deleting it. I'll wait a few more days before applying this patch.
So if anybody wants to keep it, speak up now.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
