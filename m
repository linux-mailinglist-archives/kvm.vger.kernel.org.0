Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80A3DD746
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhHBNip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbhHBNij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:38:39 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2AFC06175F;
        Mon,  2 Aug 2021 06:38:29 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F3FFD379; Mon,  2 Aug 2021 15:38:26 +0200 (CEST)
Date:   Mon, 2 Aug 2021 15:38:16 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH] KVM: SEV: improve the code readability for ASID
 management
Message-ID: <YQf1SDrEi8zl03Dv@8bytes.org>
References: <20210731011304.3868795-1-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731011304.3868795-1-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 06:13:04PM -0700, Mingwei Zhang wrote:
> Fix the min_asid usage: ensure that its usage is consistent with its name;
> adjust its value before using it as a bitmap position. Add comments on ASID
> bitmap allocation to clarify the skipping-ASID-0 property.
> 
> Fixes: 80675b3ad45f (KVM: SVM: Update ASID allocation to support SEV-ES guests)

This looks more like an optimization to me, or does this fix any real
bug?

