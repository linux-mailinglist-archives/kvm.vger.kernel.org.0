Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D1E27AA28
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 11:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgI1JCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 05:02:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43440 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1JCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 05:02:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id k15so312562wrn.10;
        Mon, 28 Sep 2020 02:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=61Wao93dAT3m4CWN1ASDh+Q66ZqTfMpU2Ii242ntq0Q=;
        b=HSGE8kUZgpXqDKtQ5BJqJxv8ooXa8rTBRSjHQZjTdvsZ7xQjynfAPR+YbDVr6LczGr
         /5J1szQwomKC4ggY5I6WFRcQkpUY+tuE/Epnt0q8twiiepgMkP0Y4bxeSnuh6Xzu9jYQ
         rvf7hYxBWuzeZCVYFGZDZxYES3zPzsMU/zFbN2k3u9E+k9X4Pu03nn1DdLvaafxDtQ0c
         WRdlI8POn5m/SvMRpN6Xxze7VPCAphSnSD58eTmTHbdQImpGKzk7A9WR7QNO10JAf8F/
         iJjmk8hL6RScvw2p8lrzC6EUkyUXCsbu3r55hOYWvqjK+8qIkhCZC/OEZrITB7hILG4E
         eAlg==
X-Gm-Message-State: AOAM531oXiPE05UvX2bLeziTyMTqn7ORrmRvPqcAXNiaNsW/j9hMadhZ
        bSN4xTptUSjryFxPMDWsY8w=
X-Google-Smtp-Source: ABdhPJyGYOW0j9vRcAgJG8TPDP6El2ZizX6OIckpwOlKn4tNmxJu/SiNqJmSgKaBHedAe96MYiF3FA==
X-Received: by 2002:a5d:5404:: with SMTP id g4mr513614wrv.134.1601283718760;
        Mon, 28 Sep 2020 02:01:58 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id y1sm350748wma.36.2020.09.28.02.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 02:01:58 -0700 (PDT)
Date:   Mon, 28 Sep 2020 09:01:56 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     joseph.salisbury@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, mikelley@microsoft.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, x86@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/hyperv: Remove aliases with X64 in their name
Message-ID: <20200928090156.bgg5x54whhvxwnwr@liuwe-devbox-debian-v2>
References: <1601130386-11111-1-git-send-email-jsalisbury@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601130386-11111-1-git-send-email-jsalisbury@linux.microsoft.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 26, 2020 at 07:26:26AM -0700, Joseph Salisbury wrote:
> From: Joseph Salisbury <joseph.salisbury@microsoft.com>
> 
> In the architecture independent version of hyperv-tlfs.h, commit c55a844f46f958b
> removed the "X64" in the symbol names so they would make sense for both x86 and
> ARM64.  That commit added aliases with the "X64" in the x86 version of hyperv-tlfs.h 
> so that existing x86 code would continue to compile.
> 
> As a cleanup, update the x86 code to use the symbols without the "X64", then remove 
> the aliases.  There's no functional change.
> 
> Signed-off-by: Joseph Salisbury <joseph.salisbury@microsoft.com>

Applied to hyperv-next. Thanks.

Wei.
