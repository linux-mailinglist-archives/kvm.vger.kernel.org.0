Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7580E2AE5F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 08:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfE0GIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 02:08:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfE0GIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 02:08:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8ED4C05091A
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 06:08:35 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13FC2608BA;
        Mon, 27 May 2019 06:08:33 +0000 (UTC)
Date:   Mon, 27 May 2019 14:08:31 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH] kvm: selftests: ucall improvements
Message-ID: <20190527060831.GG2517@xz-x1>
References: <20190523104635.21142-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190523104635.21142-1-drjones@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 27 May 2019 06:08:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 12:46:35PM +0200, Andrew Jones wrote:
> Make sure we complete the I/O after determining we have a ucall,
> which is I/O. Also allow the *uc parameter to optionally be NULL.
> It's quite possible that a test case will only care about the
> return value, like for example when looping on a check for
> UCALL_DONE.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Would it make more sense to include the other patch altogether to
cleanup the existing users of get_ucall() where uc can be NULL?

Thanks,

-- 
Peter Xu
