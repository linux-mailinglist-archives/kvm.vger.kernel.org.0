Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B968373B0B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 14:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhEEMYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 08:24:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:60830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhEEMX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 08:23:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9524CAF11;
        Wed,  5 May 2021 12:23:02 +0000 (UTC)
Date:   Wed, 5 May 2021 14:23:00 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, tglx@linutronix.de, bp@alien8.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 0/3] x86/sev-es: rename file and other cleanup
Message-ID: <YJKOJMZ+IdniIDmx@suse.de>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427111636.1207-1-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 06:16:33AM -0500, Brijesh Singh wrote:
> Brijesh Singh (3):
>   x86/sev-es: Rename sev-es.{ch} to sev.{ch}
>   x86/sev: Move GHCB MSR protocol and NAE definitions in a common header
>   x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG

Acked-by: Joerg Roedel <jroedel@suse.de>

