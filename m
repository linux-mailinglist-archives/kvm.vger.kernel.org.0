Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5B38CBA8
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhEURPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbhEURPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 13:15:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A43BC0613ED
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:13:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c17so15380410pfn.6
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=p2CM4MP1hrRU7+fp/2zo1m41ON9YEIddlJq9crMKEbQ=;
        b=WvhGtpTtoEx7HB0OPZ9XjTR7ilqHsmcVhV+jR+vZfFiYg2FnMLwOVPsXw2ZRiUvu2E
         m77gyRAWP89uByNmIR+cp2s3sOXUCFlP99iU0AXmwEH5nhyFkLQOwZD6VSQrDz6p154/
         M9tl5at5CemBY3QVAgugGPnO9jRnkotNdtIJO4tSIIZkBtRCV8/W5W/BOlgxTpfEMY9L
         cgSSHs3P94wNf0C7r3iM9TmE35DtyuUo0RUxd2LIPiZW6WovaLsD3kBhjnURNVN/IhZc
         psscXncnndby1OpwTWGEsWTQpD2jn7h4m2nMr0L1nMeutBoiPkp4c8GzMv5ueoTfDGQk
         gfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=p2CM4MP1hrRU7+fp/2zo1m41ON9YEIddlJq9crMKEbQ=;
        b=fLP5aIErA7fL0/4fKDsRJfBm2UvAZ3r+9v7m2kVeylVRNTgWv0V0/OTRUqDrpxnF9v
         r9rPS+uY6w4eGlDE2pJtVUgu+P9eGSH7ivEdTlL7uWNTvpLaOVvfQgop6jaIsmrr2482
         hiRruQ8Be59B8NUaR6TpHxGRoM3nN01HRGQSIYIyT3w1MgI/yFAG9gjzSTDR+f/tgXlb
         2EcmCwNmH8t+Q8qBkn8QQ38vuce/sheluGQZa30SF9ofIUyBR6JbXzoGl7hWoyyNBREO
         8Ry25n8YtYJ1R9OLaoXV9WFv9OTRxLSiRrf/aC66pGGSoE0BnEKUfyR1lOXNVkZjv4V9
         9yvw==
X-Gm-Message-State: AOAM531tS548oaAoQaC/xseeiLT/wUCEnhZe9RdhMjHpUn+m04t53siK
        2hjWr9HiluHb2OuSvGUErRKmxw==
X-Google-Smtp-Source: ABdhPJxYjG9nF0PMWTIKJobyACxcr+CiJtN8Wg/U81ISLixNQutYplHEzFii5EAQKwfd9K0GA4torQ==
X-Received: by 2002:a65:6256:: with SMTP id q22mr10962068pgv.391.1621617228692;
        Fri, 21 May 2021 10:13:48 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id ci2sm4624395pjb.56.2021.05.21.10.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:13:47 -0700 (PDT)
Date:   Fri, 21 May 2021 10:13:47 -0700 (PDT)
X-Google-Original-Date: Fri, 21 May 2021 10:13:45 PDT (-0700)
Subject:     Re: [PATCH v18 00/18] KVM RISC-V Support
In-Reply-To: <YKUZbb6OK+UYAq+t@kroah.com>
CC:     pbonzini@redhat.com, anup@brainfault.org,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, corbet@lwn.net, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Message-ID: <mhng-37377fcb-af8f-455c-be08-db1cd5d4b092@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 May 2021 06:58:05 PDT (-0700), Greg KH wrote:
> On Wed, May 19, 2021 at 03:29:24PM +0200, Paolo Bonzini wrote:
>> On 19/05/21 14:23, Greg Kroah-Hartman wrote:
>> > > - the code could be removed if there's no progress on either changing the
>> > > RISC-V acceptance policy or ratifying the spec
>> >
>> > I really do not understand the issue here, why can this just not be
>> > merged normally?
>>
>> Because the RISC-V people only want to merge code for "frozen" or "ratified"
>> processor extensions, and the RISC-V foundation is dragging their feet in
>> ratifying the hypervisor extension.
>>
>> It's totally a self-inflicted pain on part of the RISC-V maintainers; see
>> Documentation/riscv/patch-acceptance.rst:
>>
>>   We'll only accept patches for new modules or extensions if the
>>   specifications for those modules or extensions are listed as being
>>   "Frozen" or "Ratified" by the RISC-V Foundation.  (Developers may, of
>>   course, maintain their own Linux kernel trees that contain code for
>>   any draft extensions that they wish.)
>>
>> (Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/riscv/patch-acceptance.rst)
>
> Lovely, and how is that going to work for code that lives outside of the
> riscv "arch" layer?  Like all drivers?
>
> And what exactly is "not ratified" that these patches take advantage of?
> If there is hardware out there with these features, well, Linux needs to
> run on it, so we need to support that.  No external committee rules
> should be relevant here.
>
> Now if this is for hardware that is not "real", then that's a different
> story.  In that case, who cares, no one can use it, so why not take it?
>
> So what exactly is this trying to "protect" Linux from?
>
>> > All staging drivers need a TODO list that shows what needs to be done in
>> > order to get it out of staging.  All I can tell so far is that the riscv
>> > maintainers do not want to take this for "unknown reasons" so let's dump
>> > it over here for now where we don't have to see it.
>> >
>> > And that's not good for developers or users, so perhaps the riscv rules
>> > are not very good?
>>
>> I agree wholeheartedly.
>>
>> I have heard contrasting opinions on conflict of interest where the
>> employers of the maintainers benefit from slowing down the integration of
>> code in Linus's tree.  I find these allegations believable, but even if that
>> weren't the case, the policy is (to put it kindly) showing its limits.
>
> Slowing down code merges is horrible, again, if there's hardware out
> there, and someone sends code to support it, and wants to maintain it,
> then we should not be rejecting it.
>
> Otherwise we are not doing our job as an operating system kernel, our
> role is to make hardware work.  We don't get to just ignore code because
> we don't like the hardware (oh if only we could!), if a user wants to
> use it, our role is to handle that.
>
>> > > Of course there should have been a TODO file explaining the situation. But
>> > > if you think this is not the right place, I totally understand; if my
>> > > opinion had any weight in this, I would just place it in arch/riscv/kvm.
>> > >
>> > > The RISC-V acceptance policy as is just doesn't work, and the fact that
>> > > people are trying to work around it is proving it.  There are many ways to
>> > > improve it:
>> >
>> > What is this magical acceptance policy that is preventing working code
>> > from being merged?  And why is it suddenly the rest of the kernel
>> > developer's problems because of this?
>>
>> It is my problem because I am trying to help Anup merging some perfectly
>> good KVM code; when a new KVM port comes up, I coordinate merging the first
>> arch/*/kvm bits with the arch/ maintainers and from that point on that
>> directory becomes "mine" (or my submaintainers').
>
> Agreed, but the riscv maintainers should not be forcing this "problem"
> onto all of us, like it seems is starting to happen :(
>
> Ok, so, Paul, Palmer, and Albert, what do we do here?  Why can't we take
> working code like this into the kernel if someone is willing to support
> and maintain it over time?

I don't view this code as being in a state where it can be maintained, 
at least to the standards we generally set within the kernel.  The ISA 
extension in question is still subject to change, it says so right at 
the top of the H extension 
<https://github.com/riscv/riscv-isa-manual/blob/master/src/hypervisor.tex#L4>

    {\bf Warning! This draft specification may change before being
    accepted as standard by the RISC-V Foundation.}

That means we really can't rely on any of this to be compatible with 
what is eventually ratified and (hopefully, because this is really 
important stuff) widely implemented in hardware.  We've already had 
isuses with other specifications where drafts were propossed as being 
ready for implemnetation, software was ported, and the future drafts 
were later incompatible -- we had this years ago with the debug support, 
which was a huge headache to deal with, and we're running into it again 
with these v-0.7.1 chips coming out.  I don't want to get stuck in a 
spot where we're forced to either deal with some old draft extension 
forever or end up breaking users.

Ultimately the whole RISC-V thing is only going to work out if we can 
get to the point where vendors can agree on a shared ISA.  I understand 
that there's been a lot of frustration WRT the timelines on the H 
extension, it's been frustrating for me as well.  There are clearly 
issues with how the ISA development process is being run and while those 
are coming to a head in other areas (the V extension and non-coherent 
devices, for example) I really don't think that's the case here because 
as far as I know we don't actually have any real hardware that 
implements the H extension.

All I really care about is getting to the point where we have real 
RISC-V systems running software that's as close to upstream as is 
reasonable.  As it currently stands, I don't know of anything this is 
blocking: there's some RTL implementation floating around, but that's a 
very long way from being real hardware.  Something of this complexity 
isn't suitable for a soft core, and RTL alone doesn't fix the 
fundamental problem of having a stable platform to run on (it needs a 
complex FPGA environment, and even then it's very limited in 
functionality).  I'm not sure where exactly the line for real hardware 
is, but for something like this it would at least involve some chip that 
is widely availiable and needs the H extension to be useful.  Such a 
system existing without a ratified extension would obviously be a major 
failing on the specification side, and while I think that's happening 
now for some systems (some of these V-0.7.1 chips, and the non-coherent 
systems) I just don't see that as the case for the H extension.  We've 
got to get to the point where the ISA extensions can be ratified in a 
timely fashion, but circumventing that process by merging code early 
doesn't fix the problem.  This really needs to be fixed at the RISC-V 
foundation, not papered over in software.
￼
We have lots of real RISC-V hardware right now that's going to require a 
huge amount of work to support, trying to chase around a draft extension 
that may not even end up in hardware is just going to make headaches we 
don't have the time for.
