Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750F22AF28
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE0HGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 03:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfE0HGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 03:06:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C55D436961
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:06:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A16731001DC2;
        Mon, 27 May 2019 07:06:19 +0000 (UTC)
Date:   Mon, 27 May 2019 09:06:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH] kvm: selftests: ucall improvements
Message-ID: <20190527070617.w76nvcotn5fi6s6t@kamzik.brq.redhat.com>
References: <20190523104635.21142-1-drjones@redhat.com>
 <20190527060831.GG2517@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527060831.GG2517@xz-x1>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 27 May 2019 07:06:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 02:08:31PM +0800, Peter Xu wrote:
> On Thu, May 23, 2019 at 12:46:35PM +0200, Andrew Jones wrote:
> > Make sure we complete the I/O after determining we have a ucall,
> > which is I/O. Also allow the *uc parameter to optionally be NULL.
> > It's quite possible that a test case will only care about the
> > return value, like for example when looping on a check for
> > UCALL_DONE.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> Would it make more sense to include the other patch altogether to
> cleanup the existing users of get_ucall() where uc can be NULL?
>

Yeah, I can do that. I'll send a v2 with the cleanup and your r-b.

Thanks,
drew 
