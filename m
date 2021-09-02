Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACC63FF17D
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346340AbhIBQer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:34:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234607AbhIBQer (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 12:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630600428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9NTiKCExUohA1RnKrGeOhWiFFdORAso6f2Gqba6jrGk=;
        b=SXzOXYAN0yWIBV7JrbSZsq3UGFgNGNoc4+BkseHcopCssbKFShBfYyIeXMLmn82ORgsMj6
        VI/FrEwpTYISEl9QqO1nKJ5rp0qeou6vma+CpPEgPX/Z3cbGvzMNH/xnBkkRecGZZNA6uH
        /sYjdz9uOWNmaiKBSeDQ7DG2ZcU3Q7o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-FSTuJgeTPLGJmP9ZO1ImBQ-1; Thu, 02 Sep 2021 12:33:47 -0400
X-MC-Unique: FSTuJgeTPLGJmP9ZO1ImBQ-1
Received: by mail-wm1-f70.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so1265545wml.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9NTiKCExUohA1RnKrGeOhWiFFdORAso6f2Gqba6jrGk=;
        b=XFsUuvY+l1YvjsRQhc5fY6xt4t1tkjse0AmW2M+nG5lxexuRc9QPhHQGgdDq/ojSso
         7v5Q8xAOlgzeEjz6xwICUOfgz0PaI4X45iuZnbTaS6Ll77TSAV3cdNrbROxY2IKA4E6Z
         cJzTXbTEGqQ2WfCGXwl8GPVUk4zWjl0a+s9232pJBgtw0ZjYC1twuNKkdtQlsoltBEoo
         Rb4ldEOgLw5Rimo/TMIikk03icFlDlkE+2o24MDgweHpEjot79LPJJVic49DAibstjjg
         hIDgFmxBiC/hYgoIfTp42zt58oxx4GM5A6x1z+ymOlwZb8nZKixEhYeCGbIEY5quYaFv
         sv4w==
X-Gm-Message-State: AOAM533/JnPiSnzLhjEE71EEMEEahyFgTQUrNIHJmCi5jfo+6BQU5ulS
        S92BmlMqQMCgUlJwHpEd81zObZsGE1N9SgZwR2wfpB9OlUG2JAIUJd134iP7FBmShwX4JJRMuzA
        BNizEFI5w3KuW
X-Received: by 2002:adf:b7cd:: with SMTP id t13mr4959385wre.63.1630600425922;
        Thu, 02 Sep 2021 09:33:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyosl8fLbBGrVtecJ67AaS0YdU+coBLRMcBv/DIsoOBrebeZ7AwYCjGOR/CMCn2/9XuEaN7hQ==
X-Received: by 2002:adf:b7cd:: with SMTP id t13mr4959365wre.63.1630600425761;
        Thu, 02 Sep 2021 09:33:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a6sm2166968wmb.7.2021.09.02.09.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:33:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: Drop unused kvm_dirty_gfn_harvested()
In-Reply-To: <20210901230506.13362-1-peterx@redhat.com>
References: <20210901230506.13362-1-peterx@redhat.com>
Date:   Thu, 02 Sep 2021 18:33:44 +0200
Message-ID: <87y28flyxj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Drop the unused function as reported by test bot.

Your subject line says "Drop unused kvm_dirty_gfn_harvested()" while in
reallity you drop "kvm_dirty_gfn_invalid()".

>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/dirty_ring.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 7aafefc50aa7..88f4683198ea 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -91,11 +91,6 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>  	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
>  }
>  
> -static inline bool kvm_dirty_gfn_invalid(struct kvm_dirty_gfn *gfn)
> -{
> -	return gfn->flags == 0;
> -}
> -
>  static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  {
>  	return gfn->flags & KVM_DIRTY_GFN_F_RESET;

-- 
Vitaly

