Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17001DF1A6
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 00:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbgEVWJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 18:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbgEVWJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 18:09:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B5EC05BD43
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 15:09:02 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m44so9540954qtm.8
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 15:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/iHepWlHzPkoThKK+sxZvuLmz942NkozOITiMDLCLfg=;
        b=SsWP3Gl3dor7j0epgR7q6l0aTcG1/6LtpX81BdvLzsMx/SADmJaiJ7WE1k5CydEjCA
         pnPuBZM2mv/a+4grKSRCCTTdbdmNdeqV8dc7GncgMzMLQLg8qkKEBf77ofrwwGUI1wcl
         qmcvev9OnZOnd1KQ0RoeoNhXFiGrxldEn0ax6IzVM8vek0c9MkKJ1WHcZBGETQwFtTms
         xBqS4UkhI4zfvcUzOTP6e04vN5vzN9IMJboLXc8fMiOcbJVll92sA2xGwxazmiWl8T6U
         sgb4cPGZ+AAVrYG5juLUc8yu17IxzBd/THBJyAtbZuxeyKj6x5ZzrMFvlfZW8cSRgTP+
         /OLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/iHepWlHzPkoThKK+sxZvuLmz942NkozOITiMDLCLfg=;
        b=kNk22HxjPdsZUiOaZsEkd6LdJpdE5yqtjItNbQXl6l/UexWHhzLdkPCrt9+QPazwMm
         3wYbcZ8+Wn6Znhak16znwDa5hj7YOIZEdkWTtR8kFvNyWEHZuv0d5HJFN4NuUjWNmC33
         hLxM1dhlpwyXe2sAg8Kijy0x6LSmXkwrhKPthpdxgSz4kgymfwh3IkJ2A55ZDRFUqSo/
         +wVI7JXVbXdWhj2yqhyobrg8cEvjI4K39NHG0M/fHyo9F7QZhB1i1GTBEPHGu2AUk2TJ
         5Srs9zjpo5Kb5/lS1746fGFaG3MoxjpAkL+mh7kVqqov4Hq1CoqaYkBIERDByKrhBz1m
         6TIQ==
X-Gm-Message-State: AOAM533mqdpOHAEhxUMCNbBLB8ASUpkgtnrH8q5tLLEu5N5Xd8Hho8pq
        HAxM6TVirbwe6K89PrRaZqhXqA==
X-Google-Smtp-Source: ABdhPJyvvKpnqixLclW9SLL9hQ6ovKYcUrUanoFOiGH05AztSO5V21liqHYSLrfJzvzy71hKpb6V6g==
X-Received: by 2002:ac8:d87:: with SMTP id s7mr3686244qti.210.1590185341221;
        Fri, 22 May 2020 15:09:01 -0700 (PDT)
Received: from Qians-MacBook-Air.local (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id q17sm8581804qkq.111.2020.05.22.15.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 15:09:00 -0700 (PDT)
Date:   Fri, 22 May 2020 18:08:58 -0400
From:   Qian Cai <cai@lca.pw>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, peterx@redhat.com
Subject: Re: [PATCH v3 0/3] vfio-pci: Block user access to disabled device
 MMIO
Message-ID: <20200522220858.GE1337@Qians-MacBook-Air.local>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159017449210.18853.15037950701494323009.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 01:17:09PM -0600, Alex Williamson wrote:
> v3:
> 
> The memory_lock semaphore is only held in the MSI-X path for callouts
> to functions that may access MSI-X MMIO space of the device, this
> should resolve the circular locking dependency reported by Qian
> (re-testing very much appreciated).  I've also incorporated the
> pci_map_rom() and pci_unmap_rom() calls under the memory_lock.  Commit
> 0cfd027be1d6 ("vfio_pci: Enable memory accesses before calling
> pci_map_rom") made sure memory was enabled on the info path, but did
> not provide locking to protect that state.  The r/w path of the BAR
> access is expanded to include ROM mapping/unmapping.  Unless there
> are objections, I'll plan to drop v2 from my next branch and replace
> it with this.  Thanks,

FYI, the lockdep warning is gone.
