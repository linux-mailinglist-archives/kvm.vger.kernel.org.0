Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D92B0C7F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKLSWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:22:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgKLSW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=on8C1aC3Sas9VDqoc+DFdZz6SQ9y/CUqIs5PZgSvZjY=;
        b=WGr62Iisx9CK7+LEG5cdmKXZydd7h37zJSznaGObjtWYaLuYUSt4l64l7CcHh3SxGIh0Wk
        meb7ekq+WY7ddVtxIzZHJfZrdKs8vcOdCRHIWPUXMc2k3vKbIKMDuG67nh1HopRohePh1V
        Bve4ytfzCM4L3ccEgy0Gcx5/OZEPaKg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-LKJjUZl7O0CP5SBoFUw6Wg-1; Thu, 12 Nov 2020 13:22:24 -0500
X-MC-Unique: LKJjUZl7O0CP5SBoFUw6Wg-1
Received: by mail-qk1-f199.google.com with SMTP id v134so4858605qka.19
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:22:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=on8C1aC3Sas9VDqoc+DFdZz6SQ9y/CUqIs5PZgSvZjY=;
        b=Wn/ciE2zAcJC7vmmCkhKE1Yzo6BbrWKo5sjMulHWRLGlWIGajAgeJyPhpnXLWizxL6
         +8Tdv7xUO2OOLWOCzjtJPnPVcMJfw3EhuvZZG6cfalXn9nHRQ5YSIPwxVBXbvAcNTfhz
         QSZ2NNQYywddlDwkLG+b5zd9N47gS3EmM816l5924ADG/Mqv+CB+ulowvQaHUv9Y3FTT
         hcsq0BVXUJppC8ha988QLUg/vuRq/LTPWUVX//Y8uFyYjlAxpte9QYIza+21Wi8Eva00
         PnfpV22/qooH0Qt9KxhiJBMg6Nq7wsn5CF0ydsOPr3IYFvGhrNvkdp+Cq3yAjBHu9fUW
         ysQg==
X-Gm-Message-State: AOAM530awLXZFRfct9ZZRnECp5HOlbCHEsVs0cm8k7mM8zc699Xuc7OG
        EH820qUfINBvxw641ljsmLkjzm+rCy632fKmMj/T6+wi13gtz8PGnIf6edKPlW1gdXA2bDUKDj2
        iA2mQgZl0HxT7
X-Received: by 2002:ac8:4cdb:: with SMTP id l27mr468319qtv.74.1605205343622;
        Thu, 12 Nov 2020 10:22:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzifCD+//CMGgYpygJsZ7HszDnawwmCkilFgfAiR7dAOt610kZea8GDW6MTgDVJ9reQxA5jvg==
X-Received: by 2002:ac8:4cdb:: with SMTP id l27mr468303qtv.74.1605205343428;
        Thu, 12 Nov 2020 10:22:23 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id q15sm5215738qki.13.2020.11.12.10.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:22:22 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:22:21 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 08/11] KVM: selftests: Implement perf_test_util more
 conventionally
Message-ID: <20201112182221.GV26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-9-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-9-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:33PM +0100, Andrew Jones wrote:
> It's not conventional C to put non-inline functions in header
> files. Create a source file for the functions instead. Also
> reduce the amount of globals and rename the functions to
> something less generic.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

