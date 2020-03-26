Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3193A1939E3
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 08:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCZHzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 03:55:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56203 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbgCZHzs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 03:55:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E25875C0129;
        Thu, 26 Mar 2020 03:55:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 26 Mar 2020 03:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=WRFxXaVJ1R121EkTxmQTkclCA83
        EcIRd38Qmy1TbxiM=; b=a2kO2qeo6aqJTnKjeRPY5g8BHfJJLLx0MmFUp8qYFdc
        Z67AzO0dOEKGBUwv9JJ8ow7FRqYykkHLM7m4+3MgH2dI9JlDuyE5nUA2U3ybi8tz
        zbvo6LlXEhGiZRSQCcOzgMGRENRb4vOaGZ/shbmr/GaYjokbIlZAgSy3+3J57tdV
        yDBLbQ8C2J+uokabOBBT9mnTnGPKMhFsFpg2xGkZhRlLwqW/3q5AV12ycmh1JOVL
        vpJrZw8gS914n8O5NwjQEMI8O6V+n3by80Mzy5a4ahsu4th1w1jthDFZHHfiGVe4
        VBrsgz4LCYM3BkqzkRw/JqZDZTjcHjaCus6CglBLjAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WRFxXa
        VJ1R121EkTxmQTkclCA83EcIRd38Qmy1TbxiM=; b=l+U+4VnmRElxuwl8PnYQ6f
        K2dXKyI7afx9+K9d2ikllHJC/RDmasOtp6FVFqGxW2s9ix5F7+KufXmQCiINpKqq
        xZVxS0FwDR7ehzBlyuCQh7NEogvWi5n5Oe0+MTHMFxADjOxvZmWbJiICMjy3NXm+
        z9fgqVG0ieneeppoTawmEawAwololJdUx50sUYh3vMV51HsuD8E/g8nt2p/vUZMg
        U1jx0wEgHi2MgOECDVTFSZLZqAnbewzzmUTYcefQF5GPbnrmWD3oOn55AK1YBau0
        WpRLrG1bDEu53pJIL/aH/aVczxSVNFtfYNafwmdtdg/lC4nLsDElGRQMcvghZ7Gw
        ==
X-ME-Sender: <xms:AmB8XnaYl4XXjqh5qTRqEiuVvF2TxvfeZDi2XAISCXs_v0mXw_Um4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehhedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AmB8XiNtcATzV_CneEcKCcvxP6bdCtMl664PYXdhGN7cIsc8lUH4PA>
    <xmx:AmB8XhQYDRef0OFy1JrINS2Y5CZjG75uYg6l9dfL-_WAkaE3UPAlwg>
    <xmx:AmB8Xg4cMBzc7w4Uj_zT-OMmPtHPD8ogcq-MNsqk-iu5Futl1WdYnQ>
    <xmx:AmB8XhyKRhcaPruWvk58bm5ewSTyVgZZokRVxkbdGXuNJcdOd0BLPA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0AA33069150;
        Thu, 26 Mar 2020 03:55:45 -0400 (EDT)
Date:   Thu, 26 Mar 2020 08:55:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: linux-next: manual merge of the kvm tree with the spdx tree
Message-ID: <20200326075541.GA957772@kroah.com>
References: <20200326142727.6991104f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326142727.6991104f@canb.auug.org.au>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 02:27:27PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>   tools/testing/selftests/kvm/.gitignore
> 
> between commit:
> 
>   d198b34f3855 (".gitignore: add SPDX License Identifier")
> 
> from the spdx tree and commit:
> 
>   1914f624f5e3 ("selftests: KVM: SVM: Add vmcall test to gitignore")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Looks good, thanks!
