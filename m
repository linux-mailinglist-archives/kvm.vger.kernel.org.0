Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31EB35E22C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343510AbhDMPB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 11:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240004AbhDMPBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 11:01:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B4C061574;
        Tue, 13 Apr 2021 08:01:32 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b8400dc5952bb5bba9b51.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8400:dc59:52bb:5bba:9b51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2F1B91EC0118;
        Tue, 13 Apr 2021 17:01:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618326091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Rgu+Cztzm/QTdXWjkbl/CCFYenDdTL3HxoCYfRG+5XI=;
        b=Q2uTda9mi5ew6HFTPtwm7P+8/hqmvN5HQx2zTWVeVz/gILCgGRlGz5cR8vOMd/Msfpgo2w
        7ikDzWB3tBeMk5PELcnZve20Ii4st7NZPgSA/USMWZfK2RedTFKI2dlZILoNzqxIpURiMK
        yYtheow6RizhXWRVHf6nktOgmGBo8BM=
Date:   Tue, 13 Apr 2021 17:01:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v5 00/11] KVM SGX virtualization support (KVM part)
Message-ID: <20210413150134.GH16519@zn.tnic>
References: <cover.1618196135.git.kai.huang@intel.com>
 <af16a973-29cd-3df0-55c6-260be5db8b12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af16a973-29cd-3df0-55c6-260be5db8b12@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 04:51:50PM +0200, Paolo Bonzini wrote:
> Boris, can you confirm that tip/x86/sgx has stable commit hashes?

Yap, you can go ahead and merge it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
