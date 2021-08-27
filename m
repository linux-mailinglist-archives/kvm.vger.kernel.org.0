Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958553F9AD9
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245319AbhH0O0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232477AbhH0O0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 10:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFCD460FF2;
        Fri, 27 Aug 2021 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630074348;
        bh=LFRCe8AF5yvzuQuB2n4QQOfpmrIL5dM+Fu4lEavvLgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KzFgS5C1418V3QRAboSQFqTDRZcBPVcNVQb0US/BuFWDFNcbPzPOeb+bcWY0zrI4b
         AMxMDywS+P+wMFXO1+Ho570OfYJFWaoIqO+kN5fesooBishDdqpe4XlWb21lCib8ul
         Q8dXhErug81x48x8X4iJX1isj2PBhQA1EgOabU58=
Date:   Fri, 27 Aug 2021 16:25:42 +0200
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
Subject: Re: [PATCH v2 1/7] nitro_enclaves: Enable Arm64 support
Message-ID: <YSj15tWpwQ41BFy3@kroah.com>
References: <20210827133230.29816-1-andraprs@amazon.com>
 <20210827133230.29816-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827133230.29816-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 04:32:24PM +0300, Andra Paraschiv wrote:
> Update the kernel config to enable the Nitro Enclaves kernel driver for
> Arm64 support.
> 
> Changelog
> 
> v1 -> v2
> 
> * No changes.
> 

changelogs for different all go below the --- line, as is documented.
No need for them here in the changelog text itself, right?

Please fix up and send a v3 series.

thanks,

greg k-h
