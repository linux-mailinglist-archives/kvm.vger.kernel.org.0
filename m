Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D15199529
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbfHVNem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 09:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730621AbfHVNem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 09:34:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA486AAB2;
        Thu, 22 Aug 2019 13:34:40 +0000 (UTC)
Date:   Thu, 22 Aug 2019 15:34:40 +0200
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
Subject: Re: [PATCH v3 02/11] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <20190822133440.GD11845@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-3-brijesh.singh@amd.com>
 <20190822120254.GC11845@zn.tnic>
 <9c8fd645-8908-7ece-b60d-20de6f246df8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c8fd645-8908-7ece-b60d-20de6f246df8@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:25PM +0000, Singh, Brijesh wrote:
> FW accepts the system physical address but the userspace does not know
> the system physical instead it will give host virtual address and we
> will find its corresponding system physical address and make a FW
> call. This is a userspace interface and not the FW.

That fact could be in a sentence or two as a comment above the struct
definition.

> Okay, I will take a look and will probably reuse your functions. thank you.

Sure, and pls see if you can simplify the other command-sending
functions in a similar manner.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
