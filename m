Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D23F965A
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 10:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244654AbhH0Ioa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 04:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231824AbhH0Io3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 04:44:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EADD460F6F;
        Fri, 27 Aug 2021 08:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630053821;
        bh=s+jsdk/ggk/V8dbiafHLgrllBeAs/FB4FAAZCZzflYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRw73S7u2T4lWUTS0l45Nm5/VRoTQjpGL1tuCksr3gq5T3LVq0SJlPTEs3+LMIh34
         SStEAa9srTxR1BXkMED8Qa3uM1XXbXdl0/v+CDOcgJaZPRRRAVcAtW/laDRoT0goD6
         yFyiP1uiC7kGmHck8uNKY8pacUviTaovPk6z2DOc=
Date:   Fri, 27 Aug 2021 10:43:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v1 3/3] nitro_enclaves: Add fixes for checkpatch and docs
 reports
Message-ID: <YSilspuLarIKRquD@kroah.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826173451.93165-4-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 08:34:51PM +0300, Andra Paraschiv wrote:
> Fix the reported issues from checkpatch and kernel-doc scripts.
> 
> Update the copyright statements to include 2021, where changes have been
> made over this year.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

Please break this up into "one patch per logical change" do not mix
different things in the same commit.

thanks,

greg k-h
