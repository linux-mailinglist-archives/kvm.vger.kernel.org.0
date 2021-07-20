Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057BE3CF8E9
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 13:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhGTK44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 06:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbhGTKzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 06:55:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C39C061574
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 04:36:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m2so25665855wrq.2
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 04:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d5WGGczUDQ+z5x6mRYmC5MZD9AX2DybKW9Ucl1ZZ5x4=;
        b=GGHkZUBInNS2eawKVqyh2dZiBgqBA0ZAt6XqWzq6FhWyVhlXFPbnrSHWOAFPS8Z9ZR
         dVibOwR1wemIROQr4YCp1xwVf64z1Rg6WMpiGmIbfEBFWPrx7MmRdjb8gV3/SgBP2ZFz
         a9equnKu6rHXrtF1/q3vcbOQPyLeVxfwNuL+UDob2YQyCPEw22TnPSzcp86A1o8wmep8
         1ovlB+LtfWokYN7bMc5KLPeyi/66y6j4HTX1EvxJshk2q4Z+Mrbh6HeBmZDHYOODRsRw
         ktVTLWOHs/HMh+a+mLrAgjBio5S/1PCoIAKLdzp+GyxBK5Ra+Tjpp58IHq5VCMfwp/Vd
         YXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d5WGGczUDQ+z5x6mRYmC5MZD9AX2DybKW9Ucl1ZZ5x4=;
        b=lLBHImpJRyJ/zhHCAvN998Mrjdwm+wbsQmT0pCpqNsZaM0UbS66qwlCtb9ctF96PP1
         B7DLmygWnwDYHtBVGrJVpCLQSho4B7FbebpTJSRxVmHY7+IzQ1ibr8Ar6sAwuTVLl/os
         pnZz+R4Dxwfd2T7I/t/AuCC8L18jFqg7jYccuAGjYbCC/f2qUiGKKxyEUVeu9guJPWb6
         aY+Gx8ZTTA/5lnPr/Kq1plfZTDSbCj96yqebiXOiN4+uQhoDz4BlY5HE37zjvgNkA0g1
         M7VLiacplztXzFSYnCkuxsRFf3aEzaSETOrEXaLiiXvU62xZj+zbwuYzxNJ7zkN9InOP
         407Q==
X-Gm-Message-State: AOAM532bI8SK0OC3/1+eZYmpGAhk4mb2K3oqw5dySzU0D83wcJ8BzK9m
        B6J8l7TJHHN3aEhSOWhU7ByR3w==
X-Google-Smtp-Source: ABdhPJxWCOn5XF/Z6Scsndh/Ax3SBXXxu2JEXA+6Z/V9aXahHy5B6KiYzK39pJgPk6HYOKcI6cp8rA==
X-Received: by 2002:a5d:6589:: with SMTP id q9mr2297646wru.284.1626780985461;
        Tue, 20 Jul 2021 04:36:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
        by smtp.gmail.com with ESMTPSA id d9sm23135294wrx.76.2021.07.20.04.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 04:36:25 -0700 (PDT)
Date:   Tue, 20 Jul 2021 12:36:21 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Message-ID: <YPa1NfbEDY3kVHzr@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-4-maz@kernel.org>
 <YPag0YQHB0nph5ji@google.com>
 <871r7t9tgi.wl-maz@kernel.org>
 <YPanmXfdr9rqnICK@google.com>
 <87zguh8c4l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zguh8c4l.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 20 Jul 2021 at 12:20:58 (+0100), Marc Zyngier wrote:
> On Tue, 20 Jul 2021 11:38:17 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Tuesday 20 Jul 2021 at 11:21:17 (+0100), Marc Zyngier wrote:
> > > On Tue, 20 Jul 2021 11:09:21 +0100,
> > > Quentin Perret <qperret@google.com> wrote:
> > > > 
> > > > On Thursday 15 Jul 2021 at 17:31:46 (+0100), Marc Zyngier wrote:
> > > > > @@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > > >  		.arg		= &map_data,
> > > > >  	};
> > > > >  
> > > > > -	if (owner_id > KVM_MAX_OWNER_ID)
> > > > > +	if (!annotation || (annotation & PTE_VALID))
> > > > >  		return -EINVAL;
> > > > 
> > > > Why do you consider annotation==0 invalid? The assumption so far has
> > > > been that the owner_id for the host is 0, so annotating a range with 0s
> > > > should be a valid operation -- this will be required when e.g.
> > > > transferring ownership of a page back to the host.
> > > 
> > > How do you then distinguish it from an empty entry that doesn't map to
> > > anything at all?
> > 
> > You don't, but that's beauty of it :)
> > 
> > The host starts with a PGD full of zeroes, which in terms of ownership
> > means that it owns the entire (I)PA space. And it loses ownership of a
> > page only when we explicitly annotate it with an owner id != 0.
> 
> Right. But this scheme doesn't apply to the guests, does it?

Right, the meaning of a NULL PTE in guests will clearly be something
different, but I guess the interpretation of what invalid mappings mean
is up to the caller.

> Don't we
> need something that is non-null to preserve the table refcounting?

Sure, but do we care? If the table entry gets zeroed we're then
basically using an 'invalid block' mapping to annotate the entire block
range with '0', whatever that means. For guests it won't mean much, but
for the host that would mean sole ownership of the entire range.
