Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40066E3CD
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 15:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfD2NcD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Apr 2019 09:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfD2NcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 09:32:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF2353082B6D;
        Mon, 29 Apr 2019 13:32:02 +0000 (UTC)
Received: from gondolin (dhcp-192-187.str.redhat.com [10.33.192.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E393610027BA;
        Mon, 29 Apr 2019 13:32:01 +0000 (UTC)
Date:   Mon, 29 Apr 2019 15:31:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] Revert "KVM: doc: Document the life cycle of a VM and
 its resources"
Message-ID: <20190429153159.25dc9a96.cohuck@redhat.com>
In-Reply-To: <20190429132535.8302-1-rkrcmar@redhat.com>
References: <20190429132535.8302-1-rkrcmar@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 29 Apr 2019 13:32:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Apr 2019 15:25:35 +0200
Radim Krčmář <rkrcmar@redhat.com> wrote:

> This reverts commit 919f6cd8bb2fe7151f8aecebc3b3d1ca2567396e.
> 
> The patch was applied twice.
> The first commit is eca6be566d47029f945a5f8e1c94d374e31df2ca.
> 
> Reported-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  Documentation/virtual/kvm/api.txt | 17 -----------------
>  1 file changed, 17 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
