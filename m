Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82B922548D
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgGSWcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 18:32:25 -0400
Received: from bonobo.birch.relay.mailchannels.net ([23.83.209.22]:52063 "EHLO
        bonobo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbgGSWcZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jul 2020 18:32:25 -0400
X-Sender-Id: dreamhost|x-authsender|contact@kevinloughlin.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id EF75F120C19
        for <kvm@vger.kernel.org>; Sun, 19 Jul 2020 22:32:23 +0000 (UTC)
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (100-96-7-27.trex.outbound.svc.cluster.local [100.96.7.27])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 918BC120E3E
        for <kvm@vger.kernel.org>; Sun, 19 Jul 2020 22:32:23 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|contact@kevinloughlin.org
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Sun, 19 Jul 2020 22:32:23 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|contact@kevinloughlin.org
X-MailChannels-Auth-Id: dreamhost
X-Cooing-Daffy: 2991651d6fca2b14_1595197943812_4082902339
X-MC-Loop-Signature: 1595197943812:2974110690
X-MC-Ingress-Time: 1595197943811
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a5.g.dreamhost.com (Postfix) with ESMTP id 43D3C7EF9A
        for <kvm@vger.kernel.org>; Sun, 19 Jul 2020 15:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=kevinloughlin.org; h=
        mime-version:date:from:to:subject:message-id:content-type
        :content-transfer-encoding; s=kevinloughlin.org; bh=pvW2PBg4zrfg
        mXbhQtQDrrrWlJY=; b=tZc4b+EdbEYdku0flM/dCqY+NCv3HDznQUlS5H0zhh/P
        n4HGOs52ueSx+mSJmkvZo48aZKq6vMys2GdLmlmUz9zWv6IVHliz1v1DxlkpOdPC
        U/zMIGDet12BJ6zXfLc7V5WlcK9weRhqk9E82o0CCeWHxAWN89aR6KhP9IHrZRc=
Received: from webmail.dreamhost.com (ip-66-33-200-4.dreamhost.com [66.33.200.4])
        (Authenticated sender: contact@kevinloughlin.org)
        by pdx1-sub0-mail-a5.g.dreamhost.com (Postfix) with ESMTPA id 076DF7EF99
        for <kvm@vger.kernel.org>; Sun, 19 Jul 2020 15:32:22 -0700 (PDT)
MIME-Version: 1.0
Date:   Sun, 19 Jul 2020 18:32:22 -0400
X-DH-BACKEND: pdx1-sub0-mail-a5
From:   contact@kevinloughlin.org
To:     kvm@vger.kernel.org
Subject: x86 MMU: RMap Interface
User-Agent: DreamHost Webmail/1.4.1
Message-ID: <d49ad8fb155e2ebc6e54d8b83c335926@kevinloughlin.org>
X-Sender: contact@kevinloughlin.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrgedvgdduvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepggffhffvufgfkfigtgfgsehtjehjtddtredvnecuhfhrohhmpegtohhnthgrtghtsehkvghvihhnlhhouhhghhhlihhnrdhorhhgnecuggftrfgrthhtvghrnhepgfetvdeukedvueegvdejuddvgfejudduffelffeflefhueehheefkedtieekheehnecukfhppeeiiedrfeefrddvtddtrdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepfigvsghmrghilhdrughrvggrmhhhohhsthdrtghomhdpihhnvghtpeeiiedrfeefrddvtddtrdegpdhrvghtuhhrnhdqphgrthhhpegtohhnthgrtghtsehkvghvihhnlhhouhhghhhlihhnrdhorhhgpdhmrghilhhfrhhomheptghonhhtrggttheskhgvvhhinhhlohhughhhlhhinhdrohhrghdpnhhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm a bit confused by the interface for interacting with the page rmap. 
For context, on a TDP-enabled x86-64 host, I'm logging each time a 
GFN->PFN mapping is created/modified/removed for a non-MMIO page (kernel 
version 5.4).

First, my understanding is that the page rmap is a mapping of non-MMIO 
PFNs back to the GFNs that use them. The interface for creating an rmap 
entry (and thus, a new GFN->PFN mapping) appears to be rmap_add() and is 
quite straightforward. However, rmap_remove() does not appear to be the 
(only) function for removing an entry from the page rmap. For instance, 
kvm_zap_rmapp()---used by the mmu_notifier for invalidations---jumps 
straight to pte_list_remove(), while drop_spte() uses rmap_remove(). 
Would it be fair to say that mmu_spte_clear_track_bits() is found on all 
paths for removing an entry from the page rmap?

Second, for updates to the frame numbers in an existing SPTE, there are 
both mmu_set_spte() and mmu_spte_set(). Could someone please clarify the 
difference between these functions?

Finally, much of the logic between the page rmap and parent PTE rmaps 
(understandably) overlaps. However, with TDP-enabled, I'm not entirely 
sure what the role of the parent PTE rmaps is relative to the page rmap. 
Could someone possibly clarify?

Thanks, and best wishes,

Kevin
