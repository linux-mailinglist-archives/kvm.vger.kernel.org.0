Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E41ED330
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2019 12:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKCLpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 06:45:17 -0500
Received: from mail.skyhub.de ([5.9.137.197]:57984 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbfKCLpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 06:45:17 -0500
Received: from zn.tnic (p200300EC2F2568006945035F0EB2C779.dip0.t-ipconnect.de [IPv6:2003:ec:2f25:6800:6945:35f:eb2:c779])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C3BD1EC0ABC;
        Sun,  3 Nov 2019 12:45:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572781515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8E2ALKhLLvBcj/jgrlLIW0mqpKQojqG24RxOuFeCDMU=;
        b=A2tZ/oa4JEamcjO6BX9HHvwLgMa05KjK1eT8oMnhQrYIx5eYtcPPfqI2B9AE3xo+FQ3AaY
        dePnBMsXe48LqLL3aUhGs8cOU/EOD9Q4MxhOhaLztx4VvUsS5DQLXvPP44WmgpA9Tvl/MK
        wSNM/zPF2w34wgT3Z4kgyB5OOw2u+K0=
Date:   Sun, 3 Nov 2019 12:45:16 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Message-ID: <20191103114516.GA32261@zn.tnic>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
 <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
 <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
 <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
 <CALMp9eRWjj1b7bPdiJO3ZT2xDCyV=Ypf6GUcQLkXnqr7YrXDRg@mail.gmail.com>
 <DM5PR12MB2471947F435B18CBC1F68142957D0@DM5PR12MB2471.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM5PR12MB2471947F435B18CBC1F68142957D0@DM5PR12MB2471.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 02, 2019 at 07:23:45PM +0000, Moger, Babu wrote:
> How about updating the Kconfig (patch #4) and update it to
> CONFIG_X86_UMIP (instead of CONFIG_X86_INTEL_UMIP).

Yes, pls do that and make it depend on CPU_SUP_AMD too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
