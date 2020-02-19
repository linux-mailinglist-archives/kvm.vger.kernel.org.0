Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6193B164283
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBSKri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 05:47:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:41128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgBSKri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 05:47:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D5C4ACE8;
        Wed, 19 Feb 2020 10:47:36 +0000 (UTC)
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
References: <20200212115516.GE20066@8bytes.org>
 <EEAC8672-C98F-45D0-9F2D-0802516C3908@amacapital.net>
 <879ace44-cee3-98aa-0dff-549b69355096@suse.com>
 <20200219104213.GJ22063@8bytes.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <64f1fa87-17c2-928b-06f5-17b6771fc753@suse.com>
Date:   Wed, 19 Feb 2020 11:47:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219104213.GJ22063@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.02.20 11:42, Joerg Roedel wrote:
> Hi Jürgen,
> 
> On Wed, Feb 12, 2020 at 05:28:21PM +0100, Jürgen Groß wrote:
>> Xen-PV is clearing BSS as the very first action.
> 
> In the kernel image? Or in the ELF loader before jumping to the kernel
> image?

In the kernel image.

See arch/x86/xen/xen-head.S - startup_xen is the entry point of the
kernel.


Juergen
