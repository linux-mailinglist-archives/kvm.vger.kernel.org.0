Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6F380620
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhENJZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhENJZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 05:25:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE70C061574;
        Fri, 14 May 2021 02:24:07 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b2c00e3a8a74f5e6ed04b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2c00:e3a8:a74f:5e6e:d04b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4939A1EC03A0;
        Fri, 14 May 2021 11:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620984246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3L2pN2C7pvwIMORYei93VLaKVD2Mv4ej5v0DHAWsgjo=;
        b=mrMJTKp8SRrQk1dHV9Pue7ne6iLTxJTzmrKZwEmnfMTYzqH9P+/FgsaiUFt3GW1XZJiFnm
        6e1bTgZNLEDMwV9b8Gu5GnYEHp3694yzumwWJOwwK/0hIkhEQtkN/vLWSpsuUln9W4I0/k
        ca6hSVoEDVdvsgXyDUE/w/uWbXCKdUM=
Date:   Fri, 14 May 2021 11:24:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJ5Bs6WLocS0vRp/@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 10:03:18AM +0200, Paolo Bonzini wrote:
> Ok, so explain to me how this looks from the submitter standpoint: he reads
> your review of his patch, he acknowledges your point with "Yes, it makes
> sense to signal it with a WARN or so", and still is treated as shit.

How is me asking about the user experience of it all, treating him like
shit?!

How should I have asked this so that it is not making you think I'm
treating him like shit?

Because treating someone like shit is not in my goals.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
