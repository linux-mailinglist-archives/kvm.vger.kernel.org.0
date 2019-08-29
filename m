Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99851A218F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfH2Q4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 12:56:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:39288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728007AbfH2Q4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 12:56:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 763CFAF78;
        Thu, 29 Aug 2019 16:56:14 +0000 (UTC)
Date:   Thu, 29 Aug 2019 18:56:14 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20190829165613.GE2132@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-10-brijesh.singh@amd.com>
 <20190829162641.GB2132@zn.tnic>
 <f347e7f3-133f-2199-eeec-583a10c43e3c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f347e7f3-133f-2199-eeec-583a10c43e3c@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 04:41:50PM +0000, Singh, Brijesh wrote:
> I have been waiting for some feedback before refreshing it. If you want
> then I can refresh the patch with latest from Linus and send v4.

That's Paolo's call but we're at -rc6 now and if it were me, I'd take
them the next round so that stuff gets tested longer as -rc6 is pretty
late in the game. IMO, of course.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
