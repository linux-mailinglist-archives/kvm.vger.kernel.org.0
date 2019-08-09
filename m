Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89B6874CA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406068AbfHIJE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405962AbfHIJE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:04:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5623A2F30D8;
        Fri,  9 Aug 2019 09:04:28 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 487DA5D9DC;
        Fri,  9 Aug 2019 09:04:27 +0000 (UTC)
Date:   Fri, 9 Aug 2019 11:04:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: change list for KVM/s390
Message-ID: <20190809110425.45a62e7a.cohuck@redhat.com>
In-Reply-To: <1565335156-28660-1-git-send-email-pbonzini@redhat.com>
References: <1565335156-28660-1-git-send-email-pbonzini@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 09 Aug 2019 09:04:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  9 Aug 2019 09:19:16 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> KVM/s390 does not have a list of its own, and linux-s390 is in the
> loop anyway thanks to the generic arch/s390 match.  So use the generic
> KVM list for s390 patches.

Let's add the s390 list manually just for this patch, for awareness :)

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1aec93695040..6498ebaca2f6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8788,7 +8788,7 @@ M:	Christian Borntraeger <borntraeger@de.ibm.com>
>  M:	Janosch Frank <frankja@linux.ibm.com>
>  R:	David Hildenbrand <david@redhat.com>
>  R:	Cornelia Huck <cohuck@redhat.com>
> -L:	linux-s390@vger.kernel.org
> +L:	kvm@vger.kernel.org
>  W:	http://www.ibm.com/developerworks/linux/linux390/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
>  S:	Supported

Yes, get_maintainers.pl should add in the s390 list, so that sounds
fine.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
