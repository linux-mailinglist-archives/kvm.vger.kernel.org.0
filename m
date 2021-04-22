Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D2936780E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhDVDnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhDVDm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 23:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619062945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbQz3Z/KbIxPN1odwi0bfJtao9eKgb6NB/XnqDTilMI=;
        b=D38/UjQYRtIXpR1ptRWkyYvTOLjgTr5fiuvk3bwk7vAJEVUx6xllgu9Doav15FgEsU2cFN
        sVLKxw/F+oUnXIsWlTHPexdsXAjvThYAKbHRH9+SkK2e/EK0P30dxLDYmkZXMmy4TAs9ZL
        hbTHTNLUCTa1iMh41PGrxvxrPQQ4Id4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-5834pBtGOW6mC6jpWdECpQ-1; Wed, 21 Apr 2021 23:42:23 -0400
X-MC-Unique: 5834pBtGOW6mC6jpWdECpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3B3881278;
        Thu, 22 Apr 2021 03:42:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60AE75DDAD;
        Thu, 22 Apr 2021 03:42:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] update git tree location in MAINTAINERS to
 point at gitlab
To:     Jacob Xu <jacobhxu@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210421191611.2557051-1-jacobhxu@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <edc3df0e-0eb7-108d-3371-2e13f285d632@redhat.com>
Date:   Thu, 22 Apr 2021 05:42:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421191611.2557051-1-jacobhxu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/2021 21.16, Jacob Xu wrote:
> The MAINTAINERS file appears to have been forgotten during the migration
> to gitlab from the kernel.org. Let's update it now.
> 
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 54124f6..e0c8e99 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -55,7 +55,7 @@ Maintainers
>   -----------
>   M: Paolo Bonzini <pbonzini@redhat.com>
>   L: kvm@vger.kernel.org
> -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> +T:	https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git

Reviewed-by: Thomas Huth <thuth@redhat.com>

