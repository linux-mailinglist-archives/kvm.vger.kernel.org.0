Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A99418DB4E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgCTWrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:47:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:38976 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgCTWry (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 18:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584744473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WUk4FuE693/Ims71nGi8Vyb20vScmj2OBiS6y31l7rg=;
        b=BC9QvV5WJMG/3RtPazoq+NICfrSLUlgx7B2s0I6GGBjyDMfZeD4FvwiF8D7tA5IaBkjtej
        SuW3cEDJtYiXg21D80a61zu3/ShBQR0lnN25s4oTS6ov5/9NKDSmJNy6suqBGTJ+CZYTnS
        hlxKV0xM1iAzsToxsGleZBJxLP7LkXo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-0ATRpAtlPvKrLUjMpUBfCA-1; Fri, 20 Mar 2020 18:47:52 -0400
X-MC-Unique: 0ATRpAtlPvKrLUjMpUBfCA-1
Received: by mail-wr1-f71.google.com with SMTP id t4so3353164wrr.1
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 15:47:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WUk4FuE693/Ims71nGi8Vyb20vScmj2OBiS6y31l7rg=;
        b=GrP5omWYLB2YqAlY3cd+cW9q7gGHJ0fgsuRKnmk2JOHz9irWmQ6J8r7Pn3PaMmc6ps
         mRZgBKWrrsA5VJC0Clt1xV4dt8aEWG1BBxnGXQtXlulsUYqla/Oda68T7gGGhGxacpgd
         pFEld+PgMw5P+qT6JtKDH++tb7KSHZc/S/ZtEOairFl8ZP6f6q/5XJ9Zg5tsOFIZ+QYX
         0WApyGQxWwDzcO8KEsgO+9zW426Ba4juTskvXoHGrrdXSSG4NyvWzZvHd5diHRyHbKTm
         CFqwW2ZSTcnGlr/kClNyX/JEcF9qnBTWwDpeL1p0usRTB+dlM1q+kRf231UQmlT9Yeei
         48ug==
X-Gm-Message-State: ANhLgQ3Uja1nKX6/KJ2fabmqxcq8YXTEs8xUTtNmjUyDYEJYt/X0NKRp
        0cwkcyQFS2japv00OXlaDWD8Vc9RL7YexeuveUaEjqlqgkwIp9/nV88kVujQySgqiOmqAW6WFKW
        lETwnWd9ZV1Gk
X-Received: by 2002:a1c:4642:: with SMTP id t63mr12556354wma.164.1584744471136;
        Fri, 20 Mar 2020 15:47:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuPybOpKmuJb0qYlCdkGVlgmgPsG4GTfzqG4QJZsauttmA//egJ/jt8Hv5GEno+xQ6dO7QrBg==
X-Received: by 2002:a1c:4642:: with SMTP id t63mr12556341wma.164.1584744470945;
        Fri, 20 Mar 2020 15:47:50 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 61sm11285191wrn.82.2020.03.20.15.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 15:47:49 -0700 (PDT)
Date:   Fri, 20 Mar 2020 18:47:44 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 4/7] KVM: selftests: Add helpers to consolidate open
 coded list operations
Message-ID: <20200320224744.GG127076@xz-x1>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320205546.2396-5-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:43PM -0700, Sean Christopherson wrote:
> Add helpers for the KVM sefltests' variant of a linked list to replace a
> variety of open coded adds, deletes and iterators.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 68 ++++++++++++----------
>  1 file changed, 37 insertions(+), 31 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9a783c20dd26..d7b74f465570 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -19,6 +19,27 @@
>  #define KVM_UTIL_PGS_PER_HUGEPG 512
>  #define KVM_UTIL_MIN_PFN	2
>  
> +#define kvm_list_add(head, new)		\
> +do {					\
> +	if (head)			\
> +		head->prev = new;	\
> +	new->next = head;		\
> +	head = new;			\
> +} while (0)
> +
> +#define kvm_list_del(head, del)			\
> +do {						\
> +	if (del->next)				\
> +		del->next->prev = del->prev;	\
> +	if (del->prev)				\
> +		del->prev->next = del->next;	\
> +	else					\
> +		head = del->next;		\
> +} while (0)
> +
> +#define kvm_list_for_each(head, iter)		\
> +	for (iter = head; iter; iter = iter->next)
> +

I'm not sure whether we should start to use a common list, e.g.,
tools/include/linux/list.h, if we're going to rework them after all...
Even if this is preferred, maybe move to a header so kvm selftests can
use it in the future outside "vcpu" struct too and this file only?

Thanks,

-- 
Peter Xu

