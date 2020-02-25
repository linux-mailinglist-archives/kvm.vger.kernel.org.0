Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4DA16F087
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 21:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgBYUtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 15:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgBYUtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 15:49:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B1420675;
        Tue, 25 Feb 2020 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582663740;
        bh=kfn4BOutf8VSzmXv4R9jJuTcjrVzRzSU9qapXJ87YHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HG2hx093k72plkDwqqaCQJEmqciFZs7ZqqkFN4Aeo+Zay+CBhL3fzfMyE7GxV/v0T
         1LG/B/Mzq0U9jltQ+jxnFAUcjM9STmO/7TPiftm3dq99ohHYSy0SoJ0+s+prZ6GAlR
         OTAIxMEAYkoH70JPO8owMx1NFnE1Xy2yOcTwoO54=
Date:   Tue, 25 Feb 2020 21:48:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     gleb@kernel.org, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [Question] fix about CVE-2018-12207 for linux-4.4.y
Message-ID: <20200225204857.GB14366@kroah.com>
References: <26d70537-48a6-8c50-a496-acb1b20e8dd0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26d70537-48a6-8c50-a496-acb1b20e8dd0@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 05:31:06PM +0800, yangerkun wrote:
> Hi,
> 
> I have notice that the status of CVE-2018-12207 for linux-4.4.y stay
> vulnerable for a long time(linux-4.9.y has fix it, and I have try to fix it,
> but the different of kvm between linux-4.4.y and linux-4.9.y make it hard to
> do this). So I wander does there some plan to fix it in linux-4.4.y?

Is it really an issue in 4.4.y?  And if so, and it affects you, can you
please provide working patches for it?

Otherwise I'd strongly recommend not using 4.4.y for KVM, that ship
should have sailed a long time ago...

thanks,

greg k-h
