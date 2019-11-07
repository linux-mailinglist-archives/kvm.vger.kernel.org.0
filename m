Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37EFF2BD6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 11:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387670AbfKGKIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 05:08:05 -0500
Received: from mail.skyhub.de ([5.9.137.197]:40946 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfKGKIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 05:08:04 -0500
Received: from zn.tnic (p200300EC2F0EAD00C81A2814AF5F9B0A.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:ad00:c81a:2814:af5f:9b0a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D330D1EC0CDE;
        Thu,  7 Nov 2019 11:08:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1573121281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TYuFODDsl5EPYP782EO8AGwRCN0zWDyo4h6kYC2FsNQ=;
        b=J4gtl72wPdw0aAPd2zhkBAUYLyv55kKd4MyzqZNQ4hjnh/CCj6GFm5qFqnsDkIqKmFYS/3
        bqUHdLn/ZNWtyEru6Bf5t4zKl/WJwu1UtS51zGK1mbsLPdmNnpIbkizOAiVa1VzAVdxKOL
        LFFnjYaWctquWHSjSiaoXuvvBJKJkUw=
Date:   Thu, 7 Nov 2019 11:07:57 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc:     "Moger, Babu" <Babu.Moger@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "bshanks@codeweavers.com" <bshanks@codeweavers.com>
Subject: Re: [PATCH v3 1/2] x86/Kconfig: Rename UMIP config parameter
Message-ID: <20191107100757.GB19501@zn.tnic>
References: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
 <157298912544.17462.2018334793891409521.stgit@naples-babu.amd.com>
 <20191107013136.GA9028@ranerica-svr.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191107013136.GA9028@ranerica-svr.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 05:31:36PM -0800, Ricardo Neri wrote:
> > +	  feature in newer x86 processors. If enabled, a general
> 
> Better to say certain x86 processors? Intel and AMD have it but what
> about others?

Changed it to "some x86 processors".

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
