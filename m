Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9466FDE48
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 10:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfD2ItL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 04:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfD2ItK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 04:49:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFC76309E9B5
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 08:49:10 +0000 (UTC)
Received: from gondolin (dhcp-192-187.str.redhat.com [10.33.192.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E51D517DD1;
        Mon, 29 Apr 2019 08:49:09 +0000 (UTC)
Date:   Mon, 29 Apr 2019 10:49:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] Documentation: kvm: fix dirty log ioctl arch lists
Message-ID: <20190429104907.17bf2824.cohuck@redhat.com>
In-Reply-To: <20190429082710.15570-1-drjones@redhat.com>
References: <20190429082710.15570-1-drjones@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 29 Apr 2019 08:49:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Apr 2019 10:27:10 +0200
Andrew Jones <drjones@redhat.com> wrote:

> KVM_GET_DIRTY_LOG is implemented by all architectures, not just x86,
> and KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is additionally implemented by
> arm, arm64, and mips.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> I skimmed all ioctls in the document to see if others needed to be
> fixed, but from my quick skim the only dirty ones seem to be the
> dirty log ones.
> 
>  Documentation/virtual/kvm/api.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
