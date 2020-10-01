Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF62027FC4E
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 11:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgJAJM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 05:12:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgJAJM3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 05:12:29 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601543547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9CgX7y12TuPdG+fA/Z/ehI1EP/v1ur/4f67ci47Fa6A=;
        b=BSk13EFqVz5pja2rfSb42ESuX8qaJXsRjp00tJ6j8QM8d61czAAETpI2WfOSfmUBL56kBu
        5c4QUa2PNVYqKI4C3QmJSapkkW1h113wOZtJG0Vr7KwWwNjbqH3pvwUxJCAurZiFyijtF7
        nDQdyKixc65pVtaOHX56I2uGWQAp14U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-a7RPRKoBOC2VakZxIV89Qg-1; Thu, 01 Oct 2020 05:12:22 -0400
X-MC-Unique: a7RPRKoBOC2VakZxIV89Qg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FBAB393B4
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 09:12:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B5F73671;
        Thu,  1 Oct 2020 09:12:17 +0000 (UTC)
Date:   Thu, 1 Oct 2020 11:12:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH v2 4/7] kbuild: fix asm-offset generation to work with
 clang
Message-ID: <20201001091215.y5i6nk4ngrks4byf@kamzik.brq.redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
 <20201001072234.143703-5-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001072234.143703-5-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 09:22:31AM +0200, Thomas Huth wrote:
> KBuild abuses the asm statement to write to a file and
> clang chokes about these invalid asm statements. Hack it
> even more by fooling this is actual valid asm code.
> 
> This is an adaption of the Linux kernel commit cf0c3e68aa81f992b0
> which in turn is based on a patch for the U-Boot:
>   http://patchwork.ozlabs.org/patch/375026/
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/kbuild.h            | 6 +++---
>  scripts/asm-offsets.mak | 5 +++--
>  2 files changed, 6 insertions(+), 5 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>

