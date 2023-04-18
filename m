Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2D6E6A89
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjDRRGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjDRRGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:06:01 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C91719
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:06:00 -0700 (PDT)
Received: from [167.98.27.226] (helo=[10.35.4.205])
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1poomD-000YcO-Um; Tue, 18 Apr 2023 18:05:58 +0100
Message-ID: <89499b40-c64e-3c0b-8ab6-ce84e94768d1@codethink.co.uk>
Date:   Tue, 18 Apr 2023 18:05:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH kvmtool 2/2] riscv: add zicboz support
Content-Language: en-GB
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     kvm@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
 <20230418142241.1456070-3-ben.dooks@codethink.co.uk>
 <ub3varg6spvwh5ihma4ossabuvbuvyxst63pra7rm2lfrkychf@4olgfsvgnij2>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <ub3varg6spvwh5ihma4ossabuvbuvyxst63pra7rm2lfrkychf@4olgfsvgnij2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/2023 16:00, Andrew Jones wrote:
> On Tue, Apr 18, 2023 at 03:22:41PM +0100, Ben Dooks wrote:
>> Like ZICBOM, the ZICBOZ extension requires passing extra information to
>> the guest. Add the control to pass the information to the guest, get it
>> from the kvm ioctl and pass into the guest via the device-tree info.
>>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   riscv/fdt.c                         | 11 +++++++++++
>>   riscv/include/asm/kvm.h             |  2 ++
>>   riscv/include/kvm/kvm-config-arch.h |  3 +++
>>   3 files changed, 16 insertions(+)
> 
> Hi Ben,
> 
> I have a patch almost identical to this one here
> 
> https://github.com/jones-drew/kvmtool/commit/f44010451e023b204bb1ef9767de20e0f20aca1c
> 
> The differences are that I don't add the header changes in this patch
> (as they'll come with a proper header update after Linux patches get
> merged), and I forgot to add the disable-zicboz, which you have.
> 
> I was planning on posting after the Linux patches get merged so
> I could do the proper header update first.
>

I thought they had been, I just cherry-picked them (although I may
have just used linux-next instead of linux-upstream). I've been testing
this under qemu so it seems to be working so far with what i've been
doing.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

