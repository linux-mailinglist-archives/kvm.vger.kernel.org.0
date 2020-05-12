Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FBC1CEEBA
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgELIDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 04:03:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729144AbgELIDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 04:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589270614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=R/i2icQan6hYxTGbHp9N0BGqJR9rk1WOFisiWB6DJKY=;
        b=RCgUa86Rgfrc0ZoUo+nuzVWnyi7xlJfu2uqwd5C5PsSbo8ob8dAt2VEb0rPhORpyGZXezH
        Alr9sqNRV6uMHUTd0zIYH3mGfHr8F+YWCDdDPrhgFslsnG0SP0dpq8QlOv1REqIOnZMlM3
        bEIW4PIguS/1nemXhxjU1n1SxtEp+U4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-pddSvpVwMRKyL2rKjWD2GQ-1; Tue, 12 May 2020 04:03:30 -0400
X-MC-Unique: pddSvpVwMRKyL2rKjWD2GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D768513F8
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 08:03:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59E065C1BB;
        Tue, 12 May 2020 08:03:28 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] Fix out-of-tree builds
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200511070641.23492-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0aef504d-5870-ba88-a85e-3fea676e16eb@redhat.com>
Date:   Tue, 12 May 2020 10:03:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200511070641.23492-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/2020 09.06, Andrew Jones wrote:
> Since b16df9ee5f3b out-of-tree builds have been broken because we
> started validating the newly user-configurable $erratatxt file
> before linking it into the build dir. We fix this not by moving
> the validation, but by removing the linking and instead using the
> full path of the $erratatxt file. This allows one to keep that file
> separate from the src and build dirs.
> 
> Fixes: b16df9ee5f3b ("arch-run: Add reserved variables to the default environ")
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  configure | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Thanks, this seems to fix the issue:

 https://travis-ci.com/github/huth/kvm-unit-tests/jobs/332339909

Thus:
Tested-by: Thomas Huth <thuth@redhat.com>

