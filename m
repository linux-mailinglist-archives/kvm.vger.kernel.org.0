Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B2E751FD2
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjGMLWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbjGMLWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:22:33 -0400
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FED2700;
        Thu, 13 Jul 2023 04:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1689247349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RgbPseJJX8dAHCFOzz8t+YJrmCqZfNJY14OLm/WZc4Y=;
  b=NnyDHiHBS/TUowQHaE8RTPkzHtp1vJlgHo9oP8TXS6gEvnbymyFlpsJq
   KaTodID23AnzFokDVdFLjcm2c/OvmafIXXm2D0SAucgCF2SvRAo7AlMPi
   V5I6c+737yl6OEIOXR8ibdylN+FNMa+ihaQQOjUTHIYUE68JYoWnjZZsG
   0=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
X-SBRS: 4.0
X-MesageID: 115386809
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.123
X-Policy: $RELAYED
IronPort-Data: A9a23:MBU+W6oub+qjlPJriJUrfvwJ5fZeBmIFYhIvgKrLsJaIsI4StFCzt
 garIBmCPqyINGv9fI9zPdywpE0E757RnYI1QQU5rCxjQnxA9ZuZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpA1c/Ek/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKq04GpwUmAWP6gR5weBziJNVfrzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXAG4MbirExMP1+5CcY9BN3fwHNOvsArpK7xmMzRmBZRonaZXKQqGM7t5ExjYgwMtJGJ4yZ
 eJAN2ApNk6ZJUQSZBFOUslWcOSA3xETdxVxrl6PqLVxyG/U1AFri5DmMcbPe8zMTsJQ9qqdj
 jufoj+pXEFCZbRzzxK5zW2ztrOIxBn4XagcLq375NAxgV2ckzl75Bo+CgLg/KjRZlSFc9hHA
 0UQ+yco/e4++SSDTsH0dw+pvHme+BUbXrJ4EOQ7rgGQw6zbywefGmUACDVGbbQOuMYoSHoq3
 1mSktXBBDpzvbnTQnWYnp+VtjqxJG4EJGoLZSYYRCME5cXupMc4iRenZtV9FYargdDvXzL92
 TaHqG45nbp7pcoK0biruFPKmTShorDXQQMvoAbaRGSo6kV+foHNT4mp71fcxexNIIaQUh+Ku
 31ss9CU6+YcDJeMvDaATOUEAPei4PPtGCXRnVN1DbEg8Tq38nKudIwW5ytxTG9qM9wFfTuve
 0/OpQ5U44F7OHqscL8xYoStBsBsxq/lffz+X+zUf9NIa4J4ZQaB9ScoZlOIx332j0EpgIk7O
 JGGYYCtC2oXDeJsyz/eb/wQ2LkpzQgxwmTcQZ29xBOiuZKCa3qFYbMENkaSdOc/7bPCrAi92
 8YPaeOJxg9ZXem4ZTPYmbP/NnhTcyJ9X8qv7ZUKKKjaeFEO9Hwd5+H5n7IhQcsmvudutMDhx
 1DmYmtA6l3BvCiSQemVUUyPeI8DTL4m8yJqZHx3Ygrxs5QwSd3xtflCLvPbaZFirbU+lqAsE
 pHpbu3aWpxypiL7FyPxhHUXhKhrb1yViA2HJEJJixBvLsc7F2QlFjIJFzYDFRXi7QLt76PSW
 5X6imvmrWMrHmyO9vr+ZvO11E+WtnMAgu90VEagCoANKBS1oNY6dHSp0KJfzyQwxfLrn2vy6
 uprKU1A+bmlT3EdrbElepxoX6/2SrAjTyK27kHQ7KqsNDmyw4ZQ6dYobQp8RhiEDDmc0Pz7N
 Y1oIwTUbKVvcKBi79AtTN6GDMsWu7PSmlOt5l86RSqbNgjzV+sIz7vv9ZAni5ChD4Rx4WOeM
 n9jMPEDZN1l5OuN/IYtGTcY
IronPort-HdrOrdr: A9a23:zKjUNK/mk0QF6v/OOytuk+DgI+orL9Y04lQ7vn2YSXRuHPBw8P
 re5cjztCWE7gr5N0tBpTntAsW9qDbnhPtICOoqTNCftWvdyQiVxehZhOOIqVDd8m/Fh4pgPM
 9bAtBD4bbLbGSS4/yU3ODBKadD/OW6
X-Talos-CUID: 9a23:vyllMGMkBL4mHu5DBihnzglXO4MeUFr09VaLG2ugK2FXcejA
X-Talos-MUID: 9a23:gpNkmgilDbyps9P4w71ZIMMpCPh3/JTyTxk3kpAstfOUdj5eYDadg2Hi
X-IronPort-AV: E=Sophos;i="6.01,202,1684814400"; 
   d="scan'208";a="115386809"
From:   Andrew Cooper <andrew.cooper3@citrix.com>
To:     <kai.huang@intel.com>
CC:     <bp@alien8.de>, <dave.hansen@intel.com>, <hpa@zytor.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>, <seanjc@google.com>,
        <tglx@linutronix.de>, <x86@kernel.org>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more TDCALL/SEAMCALL leafs
Date:   Thu, 13 Jul 2023 12:22:15 +0100
Message-ID: <20230713112215.2577442-1-andrew.cooper3@citrix.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <edf3b6757c7e40abb574f2363e34c8d3722d8846.camel@intel.com>
References: <edf3b6757c7e40abb574f2363e34c8d3722d8846.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 10:47:44 +0000, Huang, Kai wrote:
> On Thu, 2023-07-13 at 12:37 +0200, Peter Zijlstra wrote:
> > On Thu, Jul 13, 2023 at 10:19:49AM +0000, Huang, Kai wrote:
> > > On Thu, 2023-07-13 at 10:43 +0200, Peter Zijlstra wrote:
> > > > On Thu, Jul 13, 2023 at 08:02:54AM +0000, Huang, Kai wrote:
> > > >
> > > > > Sorry I am ignorant here.  Won't "clearing ECX only" leave high bits of
> > > > > registers still containing guest's value?
> > > >
> > > > architecture zero-extends 32bit stores
> > >
> > > Sorry, where can I find this information? Looking at SDM I couldn't find :-(
> >
> > Yeah, I couldn't find it in a hurry either, but bpetkov pasted me this
> > from the AMD document:
> >
> >  "In 64-bit mode, the following general rules apply to instructions and their operands:
> >  “Promoted to 64 Bit”: If an instruction’s operand size (16-bit or 32-bit) in legacy and
> >  compatibility modes depends on the CS.D bit and the operand-size override prefix, then the
> >  operand-size choices in 64-bit mode are extended from 16-bit and 32-bit to include 64 bits (with a
> >  REX prefix), or the operand size is fixed at 64 bits. Such instructions are said to be “Promoted to
> >  64 bits” in Table B-1. However, byte-operand opcodes of such instructions are not promoted."
> >
> > > I _think_ I understand now? In 64-bit mode
> > >
> > > 	xor %eax, %eax
> > >
> > > equals to
> > >
> > > 	xor %rax, %rax
> > >
> > > (due to "architecture zero-extends 32bit stores")
> > >
> > > Thus using the former (plus using "d" for %r*) can save some memory?
> >
> > Yes, 64bit wide instruction get a REX prefix 0x4X (somehow I keep typing
> > RAX) byte in front to tell it's a 64bit wide op.
> >
> >    31 c0                   xor    %eax,%eax
> >    48 31 c0                xor    %rax,%rax
> >
> > The REX byte will show up for rN usage, because then we need the actual
> > Register Extention part of that prefix irrespective of the width.
> >
> >    45 31 d2                xor    %r10d,%r10d
> >    4d 31 d2                xor    %r10,%r10
> >
> > x86 instruction encoding is 'fun' :-)
> >
> > See SDM Vol 2 2.2.1.2 if you want to know more about the REX prefix.
>
> Learned something new.  Appreciate your time! :-)

And now for the extra fun...

The Silvermont uarch is 64bit, but only recognises 32bit XORs as zeroing
idioms.

So for best performance on as many uarches as possible, you should *always*
use the 32bit forms, even for %r8-15.

~Andrew
