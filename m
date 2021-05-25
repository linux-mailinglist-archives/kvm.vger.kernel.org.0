Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8B23909F8
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhEYTyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232849AbhEYTyV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 15:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621972370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L89GNKXuzf7d3bllCeedk3EnkkNLHNVcJL3vTLDbOyc=;
        b=Vw6OIaGGQvj2BWis8uUW0+UIubCbMvJcPr9JF+F5tmMYFKhT1HNMMgljneY14Cohgo5cdR
        0SmucPKuM+ejTIAMIbp/Y+gSnFtGO3XTNP7mKs3S8AhIJhynf0Fs0ndxtb8c1ZJse0YaPu
        cSy6Ibwp1goznnrkttUkkfmySAfrHp8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-5DsFRoDLOfua6g9zGDooUQ-1; Tue, 25 May 2021 15:52:49 -0400
X-MC-Unique: 5DsFRoDLOfua6g9zGDooUQ-1
Received: by mail-qt1-f198.google.com with SMTP id b19-20020ac84f130000b02901d543c52248so27236829qte.1
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L89GNKXuzf7d3bllCeedk3EnkkNLHNVcJL3vTLDbOyc=;
        b=fm/cTuHq0FjMxDsHblv0viEba0PNm0284l5fScWogQ/QsKYn/tQjaOu8Uc95SP0XNc
         exr80HyUzCaqdp9+O9Z8NVLwFnexDKBNF/kmOnQNnz+Z4+lork+aQI+PiAs41FZeK4su
         S2TD7r665uzuoSpyiD1PSffKa7q34HB3qMg4jodqjqho7bMtD2c2H1qdRhBYSrm724yD
         TIt5geibRa0p4UIdxgz0cXoZbEl9Zp8a92V80pxD+SpqAhzlmTqySLOjiVMVYxPdlX4o
         51Om+J930lLMXq0PlCpuYNlGqoSIieaGvwlE3nT45PkhAbAPhpNkbq5sCNrIMGSObmlW
         +/jw==
X-Gm-Message-State: AOAM531G68AmYgDN9pCWN8dOkFnt/NI/44X9L4hWMlUOVARNdWEMuYq6
        AINeRFKAYuNECGtXarHbFWKWtrFtEi08Sqw+cOidvXNCygBlYCtX+EDd9SHbzto9jsDTwajFJcr
        KLUnhVWb3UaC0
X-Received: by 2002:a05:620a:577:: with SMTP id p23mr37372720qkp.237.1621972368736;
        Tue, 25 May 2021 12:52:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeYN9ywDbXu83BzVh3PakPB2vF1MglDmAbRyDVZSahFhTPzLWWof7gPF1rBi3Ixt4I8TYUmQ==
X-Received: by 2002:a05:620a:577:: with SMTP id p23mr37372705qkp.237.1621972368514;
        Tue, 25 May 2021 12:52:48 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id z3sm128470qkj.40.2021.05.25.12.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 12:52:48 -0700 (PDT)
Date:   Tue, 25 May 2021 15:52:47 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 1/3] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <YK1Vj3DuotVnD4Z9@t490s>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.254128742@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210525134321.254128742@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 10:41:16AM -0300, Marcelo Tosatti wrote:
> Add a start_assignment hook to kvm_x86_ops, which is called when 
> kvm_arch_start_assignment is done.
> 
> The hook is required to update the wakeup vector of a sleeping vCPU
> when a device is assigned to the guest.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

