Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15D1E1B87
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgEZGqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:46:07 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:38203 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgEZGqH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 02:46:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 23110972;
        Tue, 26 May 2020 02:46:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 26 May 2020 02:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=5RYRLhyLsMnW5/cobsL2Hqy7R67
        BSPcGYQeOH6J+GMs=; b=cRxQJrFoaymwwcyEAfUp0pX8PLnfnsJ5xPQgBcnSMoc
        j1JKjHjJKGGR1U/tgoRcISR85Hgz5h1YqFMKqn/gnU67SKST1jhvUvCI3rHeot8V
        rpQ9k8BWRTP0qWcJlRlD8UwZvP8fxJEs9aNiQYsOBN3TSphjKcCRrIBGSpv5ZF14
        IN4wI8VgF1ZxKsLsno7FswJzL0FP+u2yfGhNcKymfHmmYx1wQiCJMdKzzLHn/7ua
        uyr5sTlfKBe7gXAOhEvU+yb1S+KMgl3spboyFzLcEtgAuPOZEzo3Om/cJDWiMjaD
        55E4UFOGIYaDV3xbMG0SshjuwP1UI5n2tHdRlsjijRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5RYRLh
        yLsMnW5/cobsL2Hqy7R67BSPcGYQeOH6J+GMs=; b=wKA3jowSlyXRdNPIOtvTwO
        0jn4TPD61XyP6+PzPK9yAA9SZlEu4V80tbqI/dU5cXKAmlSPSzGf+8xRXeVEmxjH
        RsHWwllbqfOrThRITPR10RpxK/JqpnUx0RAfLFAjNjgpa8n0xQNkwLnTSMy8WAq8
        t5kWnGv4O+h4iEECMifmwcpclAEaQmW0CT7gd2grLwGzQcXMLcslif7sHFpf59Jh
        FxyS83zrgmZkGzHSKHipn151m3bM+TW+n4fdouGLXNEe1vSyuX1e47FmAxczGJZY
        TsLuuRTjZt0Jo15I/9NCTDNIdGx4f7eABGVC/VzKJpTChghYkGMbzEEzsv5e8j7w
        ==
X-ME-Sender: <xms:LLvMXm6fr36o8K1J7iw_69HcKT_GyGt_vV8dftNx6JJdrbxyyHmeBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LLvMXv7RYV96OrDSMZ-CDDP3JcZ3i0pDRbRQQZtAKZBezD3d-EoSNA>
    <xmx:LLvMXlf12FBix7QpKjMYARSzhBehzCbyMzJ_0tKg8kBBxuI-ovMGhQ>
    <xmx:LLvMXjIM5Dthu45Nia7gr-CugCMe9Td4cJyed788S_ea61QAjSwdJQ>
    <xmx:LLvMXv5gMxsDMnGbNe-4C5Iv7LVmGuJ8gmnjQwTJ6rz0fztmz3W8vYGoXEk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEEA93280065;
        Tue, 26 May 2020 02:46:03 -0400 (EDT)
Date:   Tue, 26 May 2020 08:46:01 +0200
From:   Greg KH <greg@kroah.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 03/18] nitro_enclaves: Define enclave info for
 internal bookkeeping
Message-ID: <20200526064601.GB2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-4-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:13:19AM +0300, Andra Paraschiv wrote:
> +/* Nitro Enclaves (NE) misc device */
> +extern struct miscdevice ne_miscdevice;

Why does your misc device need to be in a .h file?

Having the patch series like this (add random .h files, and then start
to use them), is hard to review.  Would you want to try to review a
series written in this way?

thanks,

greg k-h
